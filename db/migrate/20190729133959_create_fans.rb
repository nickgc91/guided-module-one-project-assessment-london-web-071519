class CreateFans < ActiveRecord::Migration[5.2]
  def change
    create_table :fans do |t|
      t.string :name
      t.boolean :season_ticket_holder
    end
  end
end
