class UserItemEdge < Edge
    belongs_to :node_a, :class_name => 'User'
    belongs_to :user, :class_name => 'User', :foreign_key => "node_a_id"
    belongs_to :node_b, :class_name => 'Item'
    belongs_to :item, :class_name => 'Item', :foreign_key => "node_b_id"

    validates :rating, allow_nil: true, numericality: { only_integer: true, in: 0..10 }
    validates :visits, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    MAX_RATING = 10
    RATING_NORMALIZER = 1.0 / MAX_RATING

    MIN_VISITS = 3

    def score
        score = 0.0
        count = 0
        unless rating.nil?
            score += rating * RATING_NORMALIZER
            count += 1
        end
        if visits >= MIN_VISITS
            score += 1
            count += 1
        end
        if is_in_favourites
            score += 1
            count += 1
        end
        return count == 0 ? nil : score/count
    end
end
