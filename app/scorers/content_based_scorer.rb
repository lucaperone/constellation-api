class ContentBasedScorer < Scorer
    def initialize(user)
      @user = user
    end
    
    def score(item)
      return Node.similarity(@user, item), MAX_WEIGHT
    end
end
