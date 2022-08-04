class Event < Item
    belongs_to :business, class_name: "Business", foreign_key: "business_id", optional: true
end
