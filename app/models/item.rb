class Item < Node
    validates :age_restriction, allow_nil: true, numericality: { only_integer: true }
end
