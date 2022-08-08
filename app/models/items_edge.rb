class ItemsEdge < Edge
    belongs_to :node_a, :class_name => 'Item'
    belongs_to :item_a, :class_name => 'Item', :foreign_key => "node_a_id"
    belongs_to :node_b, :class_name => 'Item'
    belongs_to :item_b, :class_name => 'Item', :foreign_key => "node_b_id"
end
