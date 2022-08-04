class Business < Item
    has_many :events, class_name: "Event", dependent: :destroy
end
