class Export
    def self.export
        File.open("./constellation_#{Time.new.to_i}.gdf", 'w') { |file| 
            file.write("nodedef>name VARCHAR,label VARCHAR,class VARCHAR,Polygon INTEGER\n")
            # User.all.each do |node|
            #     file.write("#{node.id},#{node.name},User,0\n")
            # end
            # Item.all.each do |node|
            #     file.write("#{node.id},#{node.name},Item,4\n")
            # end

            Node.all.each do |node|
                file.write("#{node.id},#{node.name},#{node.type},#{node.type == "User" ? 0 : 4}\n")
            end

            file.write("edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE, class VARCHAR\n")
            
            items = Item.all
            nodes = Node.all
            items.each do |item|
                nodes.each do |node|
                    file.write("#{node.id},#{item.id},#{1-Node.distance(node,item)},#{node.type}#{item.type}\n")
                end
            end


            # nodes = Node.all.order(:id)
            # ids = nodes.pluck(:id)
            # l = ids.length
            
            # ids.each_with_index do |id, i|
            #     for j in i+1...l do
            #         a = nodes[i]
            #         b = nodes[j]
            #         file.write("#{a},#{b},#{Node.distance(a,b)},#{a.type}#{b.type}\n")
            #     end
            # end

            # scale = 1.0

            # min, max = UsersEdge.where.not(distance: 1).pluck(:distance).minmax
            # range = max-min

            # UsersEdge.all.each do |edge|
            #     file.write("#{edge.node_a_id},#{edge.node_b_id},#{edge.distance == 1 ? 0 : (1-((edge.distance - min) * scale / range))},UsersEdge\n")
            # end

            # min, max = ItemsEdge.where.not(distance: 1).pluck(:distance).minmax
            # range = max-min

            # ItemsEdge.all.each do |edge|
            #     file.write("#{edge.node_a_id},#{edge.node_b_id},#{edge.distance == 1 ? 0 : (1-((edge.distance - min) * scale / range))},ItemsEdge\n")
            # end

            # min, max = UserItemEdge.where.not(distance: 1).pluck(:distance).minmax
            # range = max-min

            # UserItemEdge.all.each do |edge|
            #     file.write("#{edge.node_a_id},#{edge.node_b_id},#{edge.distance == 1 ? 0 : (1-((edge.distance - min) * scale / range))},UserItemEdge\n")
            # end
            #add features
        }
        return nil
    end
end