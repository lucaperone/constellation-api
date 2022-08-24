class ContentBasedScorer < Scorer
    attr_accessor :node
    
    def initialize(node)
      @node = node
    end
    
    def score(node)
      return Node.similarity(@node, node), MAX_WEIGHT
    end
end
