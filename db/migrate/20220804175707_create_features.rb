class CreateFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :features do |t|
      t.string :type
      t.string :name
    end
  end
end
