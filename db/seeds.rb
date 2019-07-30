12.times do
    faker_player_name = Faker::Sports::Football.player
    market_value = rand(100000..100000000)
    starting = 0
    starter_player = nil
    if starting < 11
        starter_player = true
        starting + 1
    else
        starter_player = false
    end
    if Player.find_by(name: faker_player_name) == nil
        player1 = Player.create(name: faker_player_name, position: Faker::Sports::Football.position, market_value: "£#{market_value}", starter: starter_player)
    else 
        return
    end
    3.times do
        faker_fan_name = Faker::Name.name
        season_ticket = [true, false, false].sample
        if Fan.find_by(name: faker_fan_name) == nil
        fan1 = Fan.create(name: faker_fan_name, season_ticket_holder: season_ticket)
        else 
        return
        end
        PlayerFan.create(player_id: player1.id, fan_id: fan1.id)
    end
end





puts "yo"