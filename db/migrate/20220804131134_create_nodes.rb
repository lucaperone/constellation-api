class CreateNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :latitude, precision: 7, scale: 5
      t.decimal :longitude, precision: 7, scale: 5
      t.text :weights
      t.date :birthday
    
      t.timestamps
    end

    create_table :items do |t|
      t.string :type
      t.string :name
      t.decimal :latitude, precision: 7, scale: 5
      t.decimal :longitude, precision: 7, scale: 5
      t.text :weights
      t.integer :age_restriction
      t.boolean :is_open
      t.string :owner
      t.references :business, foreign_key: { to_table: :items}, index: true
      
      t.timestamps
    end
    
  end
end
