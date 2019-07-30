
starting = 0
30.times do
    faker_player_name1 = Faker::Sports::Football.player
    faker_player_name2 = Faker::Sports::Football.player
    market_value1 = rand(100000..100000000)
    market_value2 = rand(100000..100000000)
   
    #first 11 players to be added to the table will be starting 11
    starter_player1 = nil
    if starting < 11
        starter_player1 = true
        starting += 1
    else
        starter_player1 = false
    end
    if starting < 11
        starter_player2 = true
        starting += 1
    else
        starter_player2 = false
    end

    #creating players
    if Player.find_by(name: faker_player_name1) == nil  #if player doesn't yet exist create him
        player1 = Player.create(name: faker_player_name1, position: Faker::Sports::Football.position, market_value: "£#{market_value1}", starter: starter_player1)
    else 
        return 
    end
    if Player.find_by(name: faker_player_name2) == nil
        player2 = Player.create(name: faker_player_name2, position: Faker::Sports::Football.position, market_value: "£#{market_value2}", starter: starter_player2)
    else 
        return #otherwise don't create indentical instance of player again from faker
    end

    #creating fans 
    3.times do
        faker_fan_name1 = Faker::Name.name  #create a fake name from faker
        season_ticket1 = [true, false, false, false].sample  #if the user is a season ticket holder this value will be true
        if Fan.find_by(name: faker_fan_name1) == nil #if fan doesn't yet exist create him
            fan1 = Fan.create(name: faker_fan_name1, season_ticket_holder: season_ticket1)
        else 
            return #otherwise don't create indentical instance of fan again from faker
        end
        faker_fan_name2 = Faker::Name.name
        season_ticket2 = [true, false, false].sample
        if Fan.find_by(name: faker_fan_name2) == nil
        fan2 = Fan.create(name: faker_fan_name2, season_ticket_holder: season_ticket2)
        else 
        return
        end

        #creating fans that have players and players that have fans
        PlayerFan.create(player_id: player1.id, fan_id: fan1.id)
        PlayerFan.create(player_id: player2.id, fan_id: fan1.id)
    end
end





puts "yo"