class Node < ApplicationRecord
    has_many :edge_as, class_name: "Edge", foreign_key: "node_a_id"
    has_many :node_as, through: :edge_as
    has_many :edge_bs, class_name: "Edge", foreign_key: "node_b_id"
    has_many :node_bs, through: :edge_bs

    after_create :reset_edges

    serialize :features, JSON

    validates :latitude, allow_nil: true, numericality: { in: -90.0..90.0 }
    validates :longitude, allow_nil: true, numericality: { in: -180.0..180.0 }

    def reset_edges
        edges.delete_all
        Node.where.not(id: id).each do |node|
            Edge.create(node_a: self, node_b: node)
        end
    end

    def edges
        return Edge.where(node_a_id: id).or(Edge.where(node_b_id: id))
    end

    def normalized_vector
        return self.features.nil? ? {} : self.features
    end
end
