class Feature < ApplicationRecord
    def self.fill_vector(vector)
        if vector.length < self.count 
            default = {}
            self.all.map{|feature| default[feature.name.to_s] = 0}
            return default.merge(vector)
        else
            return vector
        end
    end
end
