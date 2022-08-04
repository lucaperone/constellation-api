class Node < ApplicationRecord
    self.abstract_class = true

    serialize :weights, JSON

    validates :latitude, allow_nil: true, numericality: { in: -90.0..90.0 }
    validates :longitude, allow_nil: true, numericality: { in: -180.0..180.0 }

    def normalized_vector
        return self.weights.nil? ? {} : self.weights
    end
end
