class Node < ApplicationRecord
    has_many :edge_as, class_name: "Edge", foreign_key: "node_a_id"
    has_many :node_as, through: :edge_as
    has_many :edge_bs, class_name: "Edge", foreign_key: "node_b_id"
    has_many :node_bs, through: :edge_bs

    serialize :attributes, JSON

    validates :latitude, allow_nil: true, numericality: { in: -90.0..90.0 }
    validates :longitude, allow_nil: true, numericality: { in: -180.0..180.0 }

    def edges
        return Edge.where(node_a_id: self.id).or(Edge.where(node_b_id: self.id))
    end

    def normalized_vector
        return self.attributes.nil? ? {} : self.attributes
    end
end
