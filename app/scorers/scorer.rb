class Scorer
    MAX_WEIGHT = 20 # Acceptable number of reviews before collaborative is as important as content-based

    def score(item)
        raise NotImplementedError
    end
end
