class Export
    def self.export
        File.open("./constellation_#{Time.new.to_i}.gdf", 'w') { |file|
            ActiveRecord::Base.logger.silence do
                nodes = {}
                edges = {}
                # weights = {
                #     "UserUser"=> [],
                #     "UserItem"=> [],
                #     "ItemItem"=> [],
                # }
                puts "\nCreating Nodes and Edges"
                Node.all.each_with_index do |node,i|
                    puts i
                    nodes[node.id] = {record: node, classic: false}
                    nodes.each do |id, prev_node|
                        record = prev_node[:record]
                        if node.id != record.id
                            min, max = [node.id, record.id].minmax
                            min_node = Node.find(min)
                            max_node = Node.find(max)
                            weight = Node.similarity(node, record)
                            type = "#{min_node.type}#{max_node.type}"
                            edge = Edge.between(min_node, max_node)
                            
                            # weights[type].append(weight)
                            
                            edges["#{min}-#{max}"] = {
                                node1: min,
                                node2: max,
                                weight: weight, #need to normalize by edge type
                                type: type,
                                friends: "#{edge.is_a?(UsersEdge)}",
                                feedback: "#{edge.is_a?(UserItemEdge)}",
                                classic: false,
                            }
                        end
                    end
                end

                puts "\nRecommending"    
                # Classic recommendation
                recommender = RecommendationController.new
                6.times do |i|
                    user = User.where(cluster:"u-#{i}").first
                    scorers = [
                        ContentBasedScorer.new(user), # Explicit feedback content-based
                        UserUserScorer.new(user), # User-User collaborative
                        ItemItemScorer.new(user), # Item-Item collaborative
                    ]
                    items = recommender.recommend(scorers, 10, threshold: 0.5)
                    nodes[user.id][:classic] = "user-#{i}"
                    items.each do |item|
                        unless nodes[item.id].nil?
                            nodes[item.id][:classic] = item.cluster
                            edges["#{user.id}-#{item.id}"][:classic] = true
                        end
                    end
                end
                    
                puts "\nWriting Nodes"
                file.write("nodedef>name VARCHAR,label VARCHAR,type VARCHAR,Polygon INTEGER,cluster VARCHAR, classic VARCHAR\n")
                nodes.each do |id, node|
                    file.write("#{id},#{node[:record].name},#{node[:record].type},#{node[:record].type == "User" ? 0 : 4},#{node[:record].cluster},#{node[:classic]}\n")
                end

                # mins = {
                #     "UserUser"=> 0,
                #     "UserItem"=> 0,
                #     "ItemItem"=> 0,
                # }
                # ranges = {
                #     "UserUser"=> 0,
                #     "UserItem"=> 0,
                #     "ItemItem"=> 0,
                # }
                # weights.each do |type,weights|
                #     min, max = weights.minmax
                #     mins[type] = min
                #     ranges[type] = max - min
                # end
                    
                puts "\nWriting Edges"
                file.write("edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE, type VARCHAR, friends VARCHAR, feedback VARCHAR, classic VARCHAR\n")
                edges.each do |id, edge|
                    file.write("#{edge[:node1]},#{edge[:node2]},#{edge[:weight]},#{edge[:type]},#{edge[:friends]},#{edge[:feedback]},#{edge[:classic]}\n")
                end
            end
        }
        return nil
    end

    def self.recommend
        File.open("./constellation_#{Time.new.to_i}.gdf", 'w') { |file|
            ActiveRecord::Base.logger.silence do
                nodes = {}
                edges = {}
                weights = {
                    "UserItem"=> [],
                    "ItemItem"=> [],
                }
                recommender = RecommendationController.new

                puts "\n\n\nCreating Nodes and Edges"
                user = User.all.max_by{|user| user.edges.count}
                nodes[user.id] = {record: user}
                #all
                Item.all.each_with_index do |item,i|
                    puts i
                    nodes[item.id] = {record: item}
                    nodes.each do |id, prev_node|
                        record = prev_node[:record]
                        if item.id != record.id
                            min, max = [item.id, record.id].minmax
                            min_node = Node.find(min)
                            max_node = Node.find(max)
                            weight = Node.similarity(item, record)
                            type = "#{min_node.type}#{max_node.type}"
                            
                            weights[type].append(weight)
                            
                            edges["#{min}-#{max}"] = {
                                node1: min,
                                node2: max,
                                weight: weight, #need to normalize by edge type
                                type: type,
                                feedback: 0.0,
                                content: -1,
                                useruser: -1,
                                itemitem: -1,
                                all: -1,
                            }
                        end
                    end
                end

                # feedback
                puts "\n\n\nFeedback"
                user.edges(UserItemEdge).each do |edge|
                    edges["#{user.id}-#{edge.item.id}"][:feedback] = edge.score
                end

                # Content-Based
                puts "\n\n\nContent-Based"
                scorers = [
                    ContentBasedScorer.new(user), # Explicit feedback content-based
                ]
                items = recommender.recommend(scorers, 15, threshold: 0.5)
                items.each_with_index do |item, i|
                    edges["#{user.id}-#{item.id}"][:content] = i
                end

                # User-User
                puts "\n\n\nUser-User"
                scorers = [
                    UserUserScorer.new(user), # Explicit feedback content-based
                ]
                items = recommender.recommend(scorers, 15, threshold: 0.5)
                items.each_with_index do |item, i|
                    edges["#{user.id}-#{item.id}"][:useruser] = i
                end

                # Item-Item
                puts "\n\n\nItem-Item"
                scorers = [
                    ItemItemScorer.new(user), # Explicit feedback content-based
                ]
                items = recommender.recommend(scorers, 15, threshold: 0.5)
                items.each_with_index do |item, i|
                    edges["#{user.id}-#{item.id}"][:itemitem] = i
                end

                # recommend
                puts "\n\n\nAll"
                scorers = [
                    ContentBasedScorer.new(user), # Explicit feedback content-based
                    UserUserScorer.new(user), # User-User collaborative
                    ItemItemScorer.new(user), # Item-Item collaborative
                ]
                items = recommender.recommend(scorers, 15, threshold: 0.5)
                items.each_with_index do |item,i|
                    edges["#{user.id}-#{item.id}"][:all] = i
                end
                    
                puts "\n\n\nWriting Nodes"
                file.write("nodedef>name VARCHAR,label VARCHAR,type VARCHAR,Polygon INTEGER,cluster VARCHAR\n")
                nodes.each do |id, node|
                    file.write("#{id},#{node[:record].name},#{node[:record].type},#{node[:record].type == "User" ? 0 : 4},#{node[:record].cluster}\n")
                end

                mins = {
                    "UserItem"=> 0,
                    "ItemItem"=> 0,
                }
                ranges = {
                    "UserItem"=> 0,
                    "ItemItem"=> 0,
                }
                weights.each do |type,weights|
                    min, max = weights.minmax
                    mins[type] = min
                    ranges[type] = max - min
                end
                    
                puts "\n\n\nWriting Edges"
                file.write("edgedef>node1 VARCHAR,node2 VARCHAR, weight DOUBLE, type VARCHAR, feedback DOUBLE, content INTEGER, useruser INTEGER, itemitem INTEGER, all INTEGER\n")
                edges.each do |id, edge|
                    w = (edge[:weight] - mins[edge[:type]]) / ranges[edge[:type]]
                    file.write("#{edge[:node1]},#{edge[:node2]},#{w == 0 ? 0.000001 : w},#{edge[:type]},#{edge[:feedback]},#{edge[:content]},#{edge[:useruser]},#{edge[:itemitem]},#{edge[:all]}\n")
                end
            end
        }
        return nil
    end
end