class ItemItemScorer < Scorer
    attr_reader :user, :edges
    def initialize(user)
      @user = user
      @edges = @user.edges(UserItemEdge)
    end

    def score(item)
        rating = 0.0
        weights = 0.0
        @edges.each do |user_item_edge|
            score = user_item_edge.score
            unless score.nil?
                weight = Node.similarity(user_item_edge.item, item)
                weights += weight
                rating += score * weight
            end
        end
        return (weights == 0.0 ? 0.0 : (rating / weights)), @edges.length.clamp(0,MAX_WEIGHT)
    end
end
