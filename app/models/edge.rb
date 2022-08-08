class Edge < ApplicationRecord
    belongs_to :node_a, :class_name => 'Node'
    belongs_to :node_b, :class_name => 'Node'

    after_create :update_similarity

    validate :no_parallel
    validate :no_loop
    validates :similarity, numericality: { in: 0.0..1.0 }

    MODIFIER_SCALE = 0.15

    def no_parallel
        unless Edge.between(node_a, node_b).nil?
            errors.add(:nodes, "Edge already exists")
        end
    end

    def no_loop
        if node_a == node_b
            errors.add(:nodes, "Edge is a loop")
        end
    end

    def self.between(node_a, node_b)
        return Edge.where(node_a: node_a, node_b: node_b).or(Edge.where(node_a: node_b, node_b: node_a)).first
    end
end
