class CreateEdges < ActiveRecord::Migration[6.0]
  def change
    create_table :edges do |t|
      t.string :type
      t.references :node_a
      t.references :node_b
      t.float :distance, default: 1
      t.boolean :are_friends, default: false
      t.boolean :is_in_favourites, default: false
      t.integer :rating
      t.integer :visits, default: 0
    
      t.timestamps
    end    
  end
end
