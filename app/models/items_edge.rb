class ItemsEdge < Edge
    belongs_to :node_a, :class_name => 'Item'
    belongs_to :item_a, :class_name => 'Item', :foreign_key => "node_a_id"
    belongs_to :node_b, :class_name => 'Item'
    belongs_to :item_b, :class_name => 'Item', :foreign_key => "node_b_id"

    def modifiers
        value = 0
        unless self.item_a.owner.nil? || self.item_b.owner.nil? 
            value += self.item_a.owner == self.item_b.owner ? 1 : 0
        end
        return value
    end
end
