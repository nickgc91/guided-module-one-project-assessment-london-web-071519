class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|

      t.string :name
      t.string :age
      t.string :position
      t.string :market_value
      t.string :nationality
      t.integer :club_id
      
    end
  end
end
