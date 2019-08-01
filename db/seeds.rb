
require 'csv'
require "pry"


array = CSV.read("db/epldata_final.csv")

array.shift

array.each do |row|
    Player.create(name: row.first, age: row[2], position: row[3], market_value: row[5], nationality: row[11], club_id: row[14])
end

the_clubs = array.map do |row|
     row[1]
end.uniq

the_clubs.each do |club|
    Club.create(name: club)
end



500.times do
    season_ticket1 = [true, false, false, false].sample
    faker_fan_name1 = Faker::Name.name
    if !Fan.find_by(name: faker_fan_name1) #if fan doesn't yet exist create him
        fan1 = Fan.create(name: faker_fan_name1, season_ticket_holder: season_ticket1)
    else 
        return #otherwise don't create indentical instance of fan again from faker
    end

end 

player1 = Player.all.sample
fan1 = Fan.all.sample
PlayerFan.create(player_id: player1.id, fan_id: fan1.id)

250.times do 

    player1 = Player.all.sample
    player2 = Player.all.sample
    player3 = Player.all.sample

    fan1 = Fan.all.sample
    fan2 = Fan.all.sample
    fan3 = Fan.all.sample

    if !PlayerFan.all.find_by(player_id: player1.id, fan_id: fan1.id)
        PlayerFan.create(player_id: player1.id, fan_id: fan1.id)
    end
    if !PlayerFan.all.find_by(player_id: player1.id, fan_id: fan2.id)
        PlayerFan.create(player_id: player1.id, fan_id: fan2.id)
    end
    if !PlayerFan.all.find_by(player_id: player1.id, fan_id: fan3.id) 
        PlayerFan.create(player_id: player1.id, fan_id: fan3.id)
    end


    if !PlayerFan.all.find_by(player_id: player1.id, fan_id: fan1.id) 
        PlayerFan.create(player_id: player1.id, fan_id: fan1.id)
    end
    if !PlayerFan.all.find_by(player_id: player2.id, fan_id: fan1.id)
        PlayerFan.create(player_id: player2.id, fan_id: fan1.id)
    end
    if !PlayerFan.all.find_by(player_id: player3.id, fan_id: fan1.id)
        PlayerFan.create(player_id: player3.id, fan_id: fan1.id)
    end

end 







