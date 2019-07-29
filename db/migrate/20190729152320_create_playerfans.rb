class CreatePlayerfans < ActiveRecord::Migration[5.2]
  def change
    create_table :player_fans do |t|
      t.string :name
      t.integer :player_id
      t.integer :fan_id
    end
  end
end
