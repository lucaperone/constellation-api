class UsersEdge < Edge
    belongs_to :node_a, :class_name => 'User'
    belongs_to :user_a, :class_name => 'User', :foreign_key => "node_a_id"
    belongs_to :node_b, :class_name => 'User'
    belongs_to :user_b, :class_name => 'User', :foreign_key => "node_b_id"
end
