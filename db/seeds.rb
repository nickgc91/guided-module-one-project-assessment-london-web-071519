10.times do
fan1 = Fan.create(name: Faker::Name.name)
player1 = Player.create(name: Faker::Sports::Football.player)
PlayerFan.create(player_id: player1.id, fan_id: fan1.id)
end