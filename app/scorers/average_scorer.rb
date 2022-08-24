class AverageScorer < Scorer
    def score(item)
        # Really bad, should just store average in table
        # But wanted to use Scorer design pattern
        @item = item
        @edges = @item.edges(UserItemEdge)
        if @edges.length == 0
            return 0, 0
        end
        return (@edges.reduce(0){|sum,edge| edge.score.nil? ? sum : sum + edge.score} / @edges.length), MAX_WEIGHT
    end
end
