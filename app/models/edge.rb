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

        vector_a = node_a.normalized_vector
        vector_b = node_b.normalized_vector
        keys = vector_a.keys & vector_b.keys

        if keys.empty?
            return 1.0
        end

        distance = 0.0
        keys.each do |key|
            distance += ((vector_a[key] - vector_b[key])**2)
        end
        distance = Math.sqrt(distance/keys.length)
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
