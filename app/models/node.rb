class Node < ApplicationRecord
    has_many :edge_as, class_name: "Edge", foreign_key: "node_a_id"
    has_many :node_as, through: :edge_as
    has_many :edge_bs, class_name: "Edge", foreign_key: "node_b_id"
    has_many :node_bs, through: :edge_bs

    # after_create :reset_edges

    serialize :features, JSON

    validates :latitude, allow_nil: true, numericality: { in: -90.0..90.0 }
    validates :longitude, allow_nil: true, numericality: { in: -180.0..180.0 }

    # def reset_edges
    #     edges.delete_all
    #     Node.where.not(id: id).each do |node|
    #         Edge.create(node_a: self, node_b: node)
    #     end
    # end

    def self.distance(node_a, node_b)
        vector_a = node_a.normalized_vector
        vector_b = node_b.normalized_vector
        keys = vector_a.keys & vector_b.keys

        if keys.empty?
            return 1.0
        end

        distance = 0.0
        if node_a.is_a?(User) && node_b.is_a?(User)
            distance = self.cosine_similarity(vector_a, vector_b, keys)
        elsif node_a.is_a?(Item) && node_b.is_a?(Item)
            distance = self.hamming_distance(vector_a, vector_b, keys)
        else
            distance = self.minkowski_distance(vector_a, vector_b, keys)
        end
        
        return distance

    end

    def self.cosine_similarity(hash_a, hash_b, keys)
        dot = 0.0
        norm_a = 0.0 
        norm_b = 0.0 
        keys.each do |key|
            dot += hash_a[key] * hash_b[key]
            norm_a += hash_a[key]**2 
            norm_b += hash_b[key]**2 
        end
        return dot/Math.sqrt(norm_a * norm_b)
    end

    def self.hamming_distance(hash_a, hash_b, keys)
        distance = 0.0
        keys.each do |key|
            distance += hash_a[key] == hash_b[key] ? 0 : 1
        end
        return distance/keys.length
    end

    def self.minkowski_distance(hash_a, hash_b, keys, p=2)
        distance = 0.0
        keys.each do |key|
            distance += ((hash_a[key] - hash_b[key])**p)
        end
        return (distance/keys.length)**(1.0/p)
    end

    def edges
        return Edge.where(node_a_id: id).or(Edge.where(node_b_id: id))
    end

    def normalized_vector
        return self.features.nil? ? {} : self.features
    end
end
