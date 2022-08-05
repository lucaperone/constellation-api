class User < Node
    # after_create :reset_edges

    MIN_AGE = 14
    MAX_AGE = 70
    AGE_NORMALIZER = 1.0/(MAX_AGE-MIN_AGE)

    # def reset_edges
    #     edges.delete_all
    #     Node.where.not(id: id).each do |node|
    #         type = nil
    #         if node.is_a?(User)
    #             type = "UsersEdge"
    #         elsif node.is_a?(Item)
    #             type = "UserItemEdge"
    #         end
    #         Edge.create(type: type, node_a: self, node_b: node)
    #     end
    # end

    def normalized_vector
        vector = super
        unless self.birthday.nil?
            vector[:age] = normalized_age(age)
        end
        return vector
    end

    def age
        if self.birthday != nil
            bd = self.birthday
            today = Date.today
            age = today.year - bd.year
            age = age - 1 if (
                bd.month >  today.month or 
                (bd.month >= today.month and bd.day > today.day)
            )
            return age
        else
            return nil
        end
    end

    def normalized_age(age)
        return (age.clamp(MIN_AGE, MAX_AGE) - MIN_AGE) * AGE_NORMALIZER
    end
end
