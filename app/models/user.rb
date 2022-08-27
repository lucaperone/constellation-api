class User < Node
    MIN_AGE = 14
    MAX_AGE = 70
    AGE_NORMALIZER = 1.0/(MAX_AGE-MIN_AGE)

    def friends
        edges = UsersEdge.where(are_friends: true).where(node_a_id: id).or(UsersEdge.where(node_b_id: id))
        return User.find(edges.map{|edge| edge.node_a_id == id ? edge.node_b_id : edge.node_a_id})
    end

    def favourites
        edges = UserItemEdge.where(node_a_id: id, is_in_favourites: true)
        return edges.map{|edge| edge.node_b}
    end

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
