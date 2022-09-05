class UserUserScorer < Scorer
    MAX_USERS = 50

    def initialize(user)
        @user = user
        @users = User.all.sort_by{|user| Node.similarity(@user, user)}.reverse!.take(MAX_USERS)
        @minmax = {}
        @users.each do |user|
            min, max = user.edges(UserItemEdge).map{|edge| edge.score}.compact.minmax
            @minmax[user.id] =(min.nil? || max.nil?) ? nil : {min: min, range: max-min}
        end
    end
    
    def score(item)
        ratings = 0.0
        weights = 0.0
        @edges = item.edges(UserItemEdge).where(node_a: @users)
        @edges.each do |user_item_edge|
            user = user_item_edge.user
            score = user_item_edge.score
            unless score.nil?
                weight = Node.similarity(@user, user)
                weights += weight
                if @minmax[user.id].nil?
                    ratings += score * weight
                else
                    ratings += (score - @minmax[user.id][:min]) * weight / @minmax[user.id][:range]
                end
            end
        end
        return (weights == 0.0 ? 0.0 : (ratings / weights)), @edges.length.clamp(0,MAX_WEIGHT)
    end
end
