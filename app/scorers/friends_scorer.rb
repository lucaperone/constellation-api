class FriendsScorer < Scorer
    attr_accessor :items

    def initialize(user)
        @user = user
        @friends = @user.friends
        @minmax = {}
        @items = []
        @friends.each do |friend|
            edges = friend.edges(UserItemEdge)
            @items.concat(edges.map{|edge| edge.item})
            min, max = edges.map{|edge| edge.score}.compact.minmax
            @minmax[friend.id] = {min: min, range: max-min}
        end
        @items.uniq!
    end
    
    def score(item)
        ratings = 0.0
        weights = 0.0
        @edges = item.edges(UserItemEdge).where(node_a: @friends)
        @edges.each do |user_item_edge|
            user = user_item_edge.user
            score = user_item_edge.score
            unless score.nil?
                weights += 1
                ratings += (score - @minmax[user.id][:min]) / @minmax[user.id][:range]
            end
        end
        return (weights == 0.0 ? 0.0 : (ratings / weights)), @edges.length.clamp(0,MAX_WEIGHT)
    end
end
