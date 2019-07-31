#greets user into the app
def greet
    puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
end

#allows user to login with name
def logging_in
    require "tty-prompt"
    prompt = TTY::Prompt.new

    user = prompt.ask('Please type in your full name to get started or type exit to quit app: ', required: true)
    if user == "exit"
        exit
    else
        while Fan.find_by(name: user) == nil
        puts "\nSorry we didn't recognize that username."
        user = prompt.ask("Please try again. Type in your fan username to get started: ", required: true)
        if user == 'exit'
            exit
        end
        end
    end
    user
end

#this method provides the menu selection functionality of the app. The user can choose from several options. 
def option_select 
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("What would you like to do? Choose from the options below:") do |menu|
        menu.choice 'View my favorite players'
        menu.choice 'View all fans of a specifc player'
        menu.choice 'View favorite players of another fan'
        menu.choice 'View total market value of the starting 11 players'
        menu.choice 'Add a new favorite player to my account'
        menu.choice 'Delete a favorite player from my account'
        menu.choice 'I just got a season ticket. Update my club season ticket status.'
        menu.choice 'exit'
      end

end

#returns the favorite players of a specific fan
def favorite_players(fan)
    fan1 = Fan.find_by(name: fan)
    fan1.players
end

#displays the favorite players of a specific fan
def show_favorite_players(fan) #this method is backend finding the players of a specifc fan
    players_array = favorite_players(fan)
    players_array.each do |player|
        puts player.name 
    end
end

#this method displays the favorite players of another specific fan that the user fan wants to see
def view_fav_players_of_another_fan 
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "Great, you want to see who a specifc fan's favorite players are :)."
            fan_you_want = prompt.ask('Please type in the full name of the fan whose favorite players you want to see: ', required: true)
            while Fan.find_by(name: fan_you_want) == nil
                puts "\nSorry we didn't recognize that username."
                fan_you_want = prompt.ask("Please try again. Type in the name of the fan username: ", required: true)
            end
            puts "\n#{fan_you_want}\'s favorite player(s):"   
            show_favorite_players(fan_you_want) 
end

#displays the fans of a specifc player
def show_fans(player) 
    player1 = Player.find_by(name: player)
    fans_array = player1.fans
    fans_array.each do |fan|
        puts fan.name 
    end
end

def all_players
    Player.all
end

# def choose_specific_player #prompts the user for a player name and returns that player if the player exists
#     require "tty-prompt"
#     prompt = TTY::Prompt.new
#     player_you_want = prompt.ask('Please type in the name of the player: ', required: true)
#             while Player.find_by(name: player_you_want) == nil
#                 puts "Sorry we didn't recognize that username."
#                 player_you_want = prompt.ask("Please try again. Type in the name of the player: ", required: true)
#             end
#         player_you_want
# end


def all_fans_of_specific_player #this method displays the fans of a specific player to the CLI
    puts "\nSo you want to see the fans of a specific player :). Awesome, which player would you like to see the fans for?"
    chosen_player = select_player_from_list
    puts "\n#{chosen_player}\'s fans:"
            show_fans(chosen_player)
end



def total_market_value_of_starting_11 #calculates the total market value of the 11 
    #starting players and prints out a message to share the value with the user
    sum = 0
    Player.where(starter: true).map do |player|
       player_value = player.market_value.split(/£/)
       player_value = player_value[1].to_i
       sum += player_value
    end
   
    sum = sum.to_s
    sum = "£" + sum
    puts "\nThe total market value of the 11 starting players on the team is #{sum}"
end









def select_player_from_list(my_players)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("Here's a list of the players:") do |menu|
        my_players.each do |player|
            menu.choice player.name 
        end
    end
    
end

def create_favorite_player_for_user(user)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    if favorite_players(user).length > 4 #a user can only have 5 favorite players
        puts "You can only have 5 favorite players!! Delete one of your players so you can add a new one :)"
        return
    else

        chosen_player = select_player_from_list(all_players)
        player_to_use = Player.find_by(name: chosen_player) #access the instance of object Player with the name chosen_player
        fan_to_use = Fan.find_by(name: user) #access the instance of fan that is the current user
    
        if PlayerFan.find_by(player_id: player_to_use.id, fan_id: fan_to_use.id) == nil #check that player is not already a favorite
             PlayerFan.create(player_id: player_to_use.id, fan_id: fan_to_use.id) #adds player to the user
             puts "#{chosen_player} was added to your favorite players :)" 
         else
           puts "This is already one of your favorite players :)" #otherwise tell user that the player is already one of their favorite players
         end
     end

end

def delete_favorite_player_for_user(user)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    if favorite_players(user).length == 0
        puts "You have no favorite players right now :("
        return
    end

    chosen_player = select_player_from_list(favorite_players(user))
    player_to_use = Player.find_by(name: chosen_player) #access the instance of object Player with the name chosen_player
    fan_to_use = Fan.find_by(name: user) #access the instance of fan that is the current user
    if PlayerFan.find_by(player_id: player_to_use.id, fan_id: fan_to_use.id)  #check that player is not already a favorite
        PlayerFan.find_by(player_id: player_to_use.id, fan_id: fan_to_use.id).destroy #deletes favorite player from user
        puts "#{chosen_player} was deleted from your favorite players :)" 
    else
        puts "This is not one of your favorite players :)" #otherwise tell user that the player is already one of their favorite players
    end
end

def got_season_ticket(user)
    puts "\n \nCongrats on getting a season ticket. You're a true fan! :)"
    fan = Fan.find_by(name: user)
    fan.update(season_ticket_holder: true)
    puts "We've updated your account so other fans know that they can meet up with you at the stadium during season games :)."
end