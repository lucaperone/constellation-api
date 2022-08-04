class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :nodes do |t|
      t.string :type
      t.string :name
      t.decimal :latitude, precision: 7, scale: 5
      t.decimal :longitude, precision: 7, scale: 5
      t.text :features
      t.date :birthday
      t.integer :age_restriction
      t.boolean :is_open
      t.string :owner
      t.references :business, foreign_key: { to_table: :nodes}, index: true
      
      t.timestamps
    end    
  end
end
