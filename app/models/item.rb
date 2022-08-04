class Item < Node
    after_create :reset_edges

    validates :age_restriction, allow_nil: true, numericality: { only_integer: true }

    def reset_edges
        edges.delete_all
        Node.where.not(id: id).each do |node|
            type = nil
            if node.is_a?(Item)
                type = "ItemsEdge"
            elsif node.is_a?(User)
                type = "UserItemEdge"
            end
            Edge.create(type: type, node_a: node, node_b: self)
        end
    end
end
