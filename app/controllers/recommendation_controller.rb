class RecommendationController < ApplicationController
    before_action :set_user

    def graph
        nodes_obj = @user.friends.shuffle.take(5) + @user.favourites.shuffle.take(5)
        
        scorer = ContentBasedScorer.new(nil)
        temp = []
        nodes_obj.each do |node|
            scorer.node = node
            temp.concat(recommend([scorer], 5, threshold: 0.3))
        end 
        nodes_obj.concat(temp)
        
        scorers = [
            ContentBasedScorer.new(@user), # Explicit feedback content-based
            UserUserScorer.new(@user), # User-User collaborative
            ItemItemScorer.new(@user), # Item-Item collaborative
        ]
        nodes_obj.concat(recommend(scorers, 30, threshold: 0.3))

        nodes_obj.uniq!

        nodes = nodes_obj.map{|node| {
            id: node.id.to_s,
            label: node.name,
            type: node.type
        }}

        edges = []
        nodes_obj.each_with_index do |node_i, i|
            for j in (i+1)...nodes_obj.length do
                node_j = nodes_obj[j]
                unless (node_i.is_a?(Item) && node_j.is_a?(Item))
                    s = Node.similarity(node_i, node_j)
                    edges.append({
                        source: node_i.id.to_s,
                        target: node_j.id.to_s,
                        value: s,
                        style: {stroke: "rgba(255,255,255,#{s/4})"},
                    })
                end
            end
        end
        

        render json: {
            "nodes": nodes,
            "edges": edges,
        }
    end

    def user
        scorers = [
            ContentBasedScorer.new(@user), # Explicit feedback content-based
            UserUserScorer.new(@user), # User-User collaborative
            ItemItemScorer.new(@user), # Item-Item collaborative
        ]

        render json: recommend(scorers, 50, threshold: 0.5)
    end

    def lists
        @lists = []

        # Feature
        @features = @user.features
                    .filter{|feature, score| score >= 0.6}
                    .sort_by{|feature,score| score}
                    .reverse.take(5).shuffle.take(2)
                    .map{|feature_score| feature_score[0]}


        @features.each do |feature|
            @lists.append({
                title: "You seem to like",
                ref: {
                    type: "Feature",
                    id: Feature.where(name: feature).first.id,
                    name: feature,
                },
                items: recommend(
                    [AverageScorer.new()],
                    10,
                    items: Item.where("features like ?", "%\"#{feature}\":1%")
                )
            })
        end

        # Similar to item
        @items = @user.edges(UserItemEdge)
                    .filter{|edge| !edge.score.nil? && edge.score >= 0.5}
                    .sort_by{|edge| edge.score}
                    .reverse.take(5).shuffle.take(2)
                    .map{|edge| edge.item}

        @items.each do |item|
            @lists.append({
                title: "Similar to ",
                ref: {
                    type: "Item",
                    id: item.id,
                    name: item.name
                },
                items: recommend(
                    [ContentBasedScorer.new(item)],
                    10,
                    items: Item.where.not(id: item.id))
            })
        end

        @friends = @user.friends
        @lists.append({
            title: "Your friends like",
            ref: nil,
            items: recommend(
                [scorer = FriendsScorer.new(@user)],
                10,
                items: scorer.items
            )
        })

        @lists.shuffle!

        # Tastes
        @lists.prepend({
            title: "Based on your tastes",
            ref: nil,
            items: recommend([
                ContentBasedScorer.new(@user), # Explicit feedback content-based
                UserUserScorer.new(@user), # User-User collaborative
                ItemItemScorer.new(@user), # Item-Item collaborative
            ], 20, threshold: 0.5)
        })

        @lists.each do |list|
            list[:items] = list[:items].clone.map{ |item|
                edge = Edge.between(@user, item)
                {
                    item: item,
                    is_in_favourites: edge ? edge.is_in_favourites : false,
                    rating: edge ? edge.rating ? edge.rating : 0 : 0
                }
            }
        end

        render json: @lists
    end

    def friends
        @friends = @user.friends
        filter = @friends.map{|friend| friend.id}
        filter.append(@user.id)

        counter = {}

        @friends.each do |friend| 
            friend.friends.each do |next_friend|
                counter[next_friend.id] = counter[next_friend.id].nil? ? 0 : counter[next_friend.id] + 1
            end
        end

        render json: User.find(
            counter
                .filter{|id,count| !filter.include?(id) && count > 0}
                .sort_by{|id,count| count}
                .map{|id_count| id_count[0]}
                .reverse
                .take(3)
        )
    end

    private

    def set_user
        @user = User.find(params[:id])
    end
        
    def recommend(scorers, recommendations_number, threshold: 0.0, items: Item.all)
        # Compute weighted score for each item    
        items_score = {}
        items.each do |item|
            scores = 0.0
            weights = 0.0
            scorers.each do |scorer|
                score, weight = scorer.score(item)
                scores += score * weight
                weights += weight
            end

            items_score[item.id] = weights == 0 ? 0 : (scores / weights)
        end

        # Filter by threshold, sort by score, from ASC to DESC,
        # Keep only needed number, keep only ids, fetch items in db
        return Item.find(
            items_score
            .filter{|id, score| score >= threshold}
            .sort_by{|id, score| score}
            .reverse
            .take(recommendations_number)
            .map{|id_score| id_score[0]}
        )
    end
end
