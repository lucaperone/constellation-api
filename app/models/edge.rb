class Edge < ApplicationRecord
    belongs_to :node_a, :class_name => 'Node'
    belongs_to :node_b, :class_name => 'Node'

    after_create :update_distance

    validates :distance, numericality: { in: 0.0..1.0 }

    MODIFIER_SCALE = 0.15

    def update_distance
        if guards
            return 1.0
        end
        
        distance = Node.distance(node_a, node_b)
        distance -= modifiers * MODIFIER_SCALE
        
        self.update(distance: distance.clamp(0.0,1.0))
    end

    def guards
        return false
    end

    def modifiers
        return 0.0
    end
end
