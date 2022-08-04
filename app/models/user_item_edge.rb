class UserItemEdge < Edge
    belongs_to :node_a, :class_name => 'User'
    belongs_to :user, :class_name => 'User', :foreign_key => "node_a_id"
    belongs_to :node_b, :class_name => 'Item'
    belongs_to :item, :class_name => 'Item', :foreign_key => "node_b_id"

    validates :rating, allow_nil: true, numericality: { only_integer: true, in: 0..10 }
    validates :visits, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    MAX_RATING = 10
    RATING_NORMALIZER = 2.0 / MAX_RATING
    RATING_OFFSET = 1
    
    MAX_VISITS = 10
    VISITS_NORMALIZER = 1.0 / MAX_VISITS

    def guards
        unless self.user.age.nil? || self.item.age_restriction.nil?
            return self.user.age < self.item.age_restriction # add distance ?
        end
        return false
    end

    def modifiers
        value = 0
        value += self.rating.nil? ? 0 : self.rating * RATING_NORMALIZER - RATING_OFFSET
        value += self.visits.clamp(0,MAX_VISITS) * VISITS_NORMALIZER
        value += self.is_in_favourites ? 1 : 0
        return value
    end
end
