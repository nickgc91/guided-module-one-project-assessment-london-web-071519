#greets user into the app
def greet
    puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
end

#allows user to login with name
def logging_in
    require "tty-prompt"
    prompt = TTY::Prompt.new

#provide user two options --> 1) sign in or 2) create a new account
    welcome = prompt.select("Welcome:") do |menu|
        menu.choice 'Sign In'
        menu.choice 'Create New Account'
    end

#sign in: prompt user for name 
    if welcome == 'Sign In'
         user_name = prompt.ask('Please type in your full name to get started or type exit to quit app: ', required: true)
         if user_name == "exit"
         exit
        else
            while Fan.find_by(name: user_name) == nil
                puts "\nSorry we didn't recognize that name."
                user_name = prompt.ask("Please try again. Type in your name to get started: ", required: true)
            if user_name == 'exit'
                exit
            end
            end
        end
    elsif welcome == 'Create New Account'
        user_name = prompt.ask('Please type in your full name to get started or type exit to quit app: ', required: true)
        Fan.create(name: user_name, season_ticket_holder: false)
        puts "Your Football Fan Masters account has been created. Your username is #{user_name} :)"
    end
   user_name
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
        menu.choice 'View most expensive player from a specifc premier league team'
        menu.choice 'Add a new favorite player to my account'
        menu.choice 'Delete a favorite player from my account'
        menu.choice 'I just got a season ticket. Update my club season ticket status.'
        menu.choice 'exit'
      end

end

#returns the favorite players of a specific fan
def favorite_players(fan)
    Fan.find_by(name: fan).players
end

#displays the favorite players of a specific fan
def show_favorite_players(fan) #this method is backend finding the players of a specifc fan
    players_array = favorite_players(fan)
    players_array.each do |player|
        puts player.name 
    end
end

#helper method provides array of all fans in database
def all_fans
    Fan.all
end

#allows user to select a specific fan from a menu of all fans
def select_fan_from_list(my_fans)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("Here's a list of the players: (you can type the name of the player to filter through the players)", filter: true) do |menu|
        my_fans.each do |fan|
            menu.choice fan.name
        end
    end
    
end

#this method displays the favorite players of another specific fan that the user fan wants to see
def view_fav_players_of_another_fan 
    require "tty-prompt"
    prompt = TTY::Prompt.new

    chosen_fan = select_fan_from_list(all_fans)  
    
    show_favorite_players(chosen_fan) 
end




#displays the fans of a specifc player
def show_fans(player) 
    player1 = Player.find_by(name: player)
    fans_array = player1.fans
    fans_array.each do |fan|
        puts fan.name 
    end
end

#helper method provides array of all players in database
def all_players
    Player.all
end


def all_fans_of_specific_player #this method displays the fans of a specific player to the CLI
    
    require "tty-prompt"
    prompt = TTY::Prompt.new

    chosen_player = select_player_from_list(all_players)
    
    show_fans(chosen_player)
end


def all_clubs
    Club.all
end

def most_expensive_player_on_team #calculates the total market value of the 11 
    #starting players and prints out a message to share the value with the user
    
        require "tty-prompt"
        prompt = TTY::Prompt.new
    
        puts "\n \n"
    
        chosen_club = prompt.select("For which club do you want to know who the most expensive player is?", filter: true) do |menu|
            all_clubs.each do |club|
                menu.choice club.name
            end
        end

        my_club = Club.find_by(name: chosen_club)
        club_players = my_club.players.sort_by do |player|
            player.market_value.to_i
        end

        most_expensive_player = club_players.last
        puts "#{most_expensive_player.name}'s most expensive player is #{most_expensive_player.name}. He is worth £#{most_expensive_player.market_value}M"

end




def select_player_from_list(my_players)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("Here's a list of the players: ", filter: true) do |menu|
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