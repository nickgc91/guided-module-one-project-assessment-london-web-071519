#greets user into the app
def greet
    puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
end



#USER LOGIN
def logging_in
    require "tty-prompt"
    prompt = TTY::Prompt.new

#provide user two menu options --> 1) sign in or 2) create a new account
    welcome = prompt.select("Welcome:") do |menu|
        menu.choice 'Sign In'
        menu.choice 'Create New Account'
    end


    if welcome == 'Sign In' #sign in: prompt user for name 
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
    elsif welcome == 'Create New Account' #new account: prompt user for name 
        user_name = prompt.ask('Please type in your full name to get started or type exit to quit app: ', required: true)
        Fan.create(name: user_name, season_ticket_holder: false) #creates a new instance of fan in the database
        puts "Your Football Fan Masters account has been created. Your username is #{user_name} :)"
    end
   user_name
end



#MAIN APP MENU: this method provides the menu selection functionality of the app. 

#The user can choose from several options. 
def option_select 
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("What would you like to do? Choose from the options below:") do |menu|
        menu.choice 'View my favorite players' #MAIN MENU OPTION 1 - SHOWS USER'S FAVORITE PLAYERS
        menu.choice 'Add a new favorite player to my account' #MAIN MENU OPTION 2
        menu.choice 'Delete a favorite player from my account' #MAIN MENU OPTION 3
        menu.choice 'View all fans of a specifc player' #MAIN MENU OPTION 4
        menu.choice 'View favorite players of another fan' #MAIN MENU OPTION 5
        menu.choice 'View players from a specific club' #MAIN MENU OPTION 6
        menu.choice 'View most expensive player from a specifc premier league team' #MAIN MENU OPTION 7
        menu.choice 'I just got a season ticket. Update my club season ticket status.' #MAIN MENU OPTION 8
        menu.choice 'exit' #MAIN MENU OPTION EXIT
      end

end





#MAIN MENU OPTION 1 - SHOWS USER'S FAVORITE PLAYERS

#returns the favorite players of a specific fan
def favorite_players(fan)
    Fan.find_by(name: fan).players
end
#this method returns the fan instance associated with the name provided in the argument. It then calls the instance 
#method ".players" on that instance of fan which returns an array of players that belong to that fan


#this method also gets called in "view_fav_players_of_another_fan" method from MAIN MENU OPTION 5
#displays the favorite players of a specific fan
def show_favorite_players(fan) #this method is backend finding the players of a specifc fan
    players_array = favorite_players(fan)
    players_array.each do |player|
        puts player.name 
    end
end
#this method calls favorite_players on the fan name provided by the argument and stores the array of players returned
#into players_array. It then loops through that array of player instances that belong to that specific instance 
#of fan and prints the attribute "name" of each specific instance of the players in the array. 




#CREATE/DELETE PLAYERS - MAIN MENU OPTIONS 2 & 3 
#OPTION 2 - CREATE PLAYER
#OPTION 3 - DELETE PLAYER



#provides player list for user to choose from
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
#this method gets passed an array of player instances. It then uses the tty menu to display the name attribute of
#each player instance in that array. The method returns the name attribute of the player instance chosen. 



#MAIN MENU OPTION 2 - CREATE PLAYER (see above for "select_player_from_list" method)

#USER CAN ADD A NEW FAVORITE PLAYER TO THEIR INSTANCE
def create_favorite_player_for_user(user)
    require "tty-prompt"
    prompt = TTY::Prompt.new

    if favorite_players(user).length > 4 #a user can only have 5 favorite players
        puts "You can only have 5 favorite players!! Delete one of your players so you can add a new one :)"
        return
    else

        chosen_player = select_player_from_list(all_players)
        player_to_use = Player.find_by(name: chosen_player) #access the Player instance with the attribute name = chosen_player
        fan_to_use = Fan.find_by(name: user) #access the instance of fan that is the current user
    
        if !PlayerFan.find_by(player_id: player_to_use.id, fan_id: fan_to_use.id) #calls class method "find by" on PlayerFan class to check that player is not already a favorite (if the instance of PlayerFan already exists)
             PlayerFan.create(player_id: player_to_use.id, fan_id: fan_to_use.id) #class method "create" creates PlayerFan instance
             puts "#{chosen_player} was added to your favorite players :)" 
         else
           puts "This is already one of your favorite players :)" #otherwise tell user that the player is already one of their favorite players
         end
     end

end


#MAIN MENU OPTION 3 - DELETE PLAYER (see above for "select_player_from_list" method)

#DELETES A USER'S FAVORITE PLAYER
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





#MAIN MENU OPTION 4 - DISPLAY FANS OF SPECIFIC PLAYER

#displays the fans of a specifc player
def show_fans(player) 
    player1 = Player.find_by(name: player)
    fans_array = player1.fans
    fans_array.each do |fan|
        puts fan.name 
    end
end

#helper method provides array of all players in database - calls ".all" class method on Player class
def all_players
    Player.all
end

#MAIN MENU OPTION 4
#calls "select_player_from_list(all_players)" to allow user to choose which player they want to see fans of
#calls show_fans method on that player to see fans of the player
def all_fans_of_specific_player 
    
    require "tty-prompt"
    prompt = TTY::Prompt.new

    chosen_player = select_player_from_list(all_players)
    show_fans(chosen_player)
end




#MAIN MENU OPTION 5 - VIEW FAVORITE PLAYERS OF ANOTHER FAN

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




#CLUB - MAIN MENU OPTIONS 6 & 7 
#OPTION 6: VIEW MOST EXPENSIVE PLAYER ON SPECIFIC CLUB 
#OPTION 7: VIEW ALL PLAYERS ON SPECIFIC CLUB


def all_clubs
    Club.all
end
#returns all instances of club


#user chooses a club name and club name gets returned
def choose_club
    require "tty-prompt"
    prompt = TTY::Prompt.new

    puts "\n \n"

    prompt.select("For which club?", filter: true) do |menu|
        all_clubs.each do |club|
            menu.choice club.name
        end
    end
end
#this method creates a tty options menu to display the 20 different epl teams to the user. The user can then 
#choose the club they want to find information about and this club name (a string) gets returned. 


#MENU 6 - DISPLAYS PLAYERS ON SPECIFIC CLUB
def show_players_on_specific_club
    the_club = choose_club #user chooses club they want to see players for
    the_club = Club.find_by(name: the_club) #use class instance find_by to find the instance of club with the name provided by user (the_club)
    the_club.players.each do |player| #loops through instance of club and prints all players 
        puts player.name
    end
end
# the_club stores the  club choice that the user makes in choose_club. In the next step we use the class method 
#".find_by" to find the specifc instance of club that has as attribute "name" that matches the club chosen by 
#the user. We then loop through each player by calling an instance method "#players" on that instance of the club
#which return an array containing all the players belonging to that specific instance of the club. It then prints
#out the names of all the players by accessing the "name" attribute of that player instance. 



#MAIN MENU OPTION 7 - MOST EXPENSIVE PLAYER ON CLUB
def most_expensive_player_on_team 

        the_club = choose_club #user chooses club they want to see most expensive player for
        my_club = Club.find_by(name: the_club) #use class instance find_by to find the instance of club with the name provided by user (the_club)
        club_players = my_club.players.sort_by do |player| #loops through instance of club and sorts the players by their market value (remember to change market_value from string to integer)
            player.market_value.to_i
        end

        most_expensive_player = club_players.last #in ascending order the last item of the sorted array is the player with the highest market value
        puts "#{the_club}'s most expensive player is #{most_expensive_player.name}. He is worth £#{most_expensive_player.market_value}M"
        #the_club --> user choice of club name
        #most_expensive_player.name --> use the_club name to find the specific instance of Club class. 
        #Use ".players" method to find all player instances of that specifc club (the instances of players that 
        #belong to that instance of club). Use ".name" method to retrieve attribute "name" of player instance. 
        #Use ".market_value" to retrieve attribute "market_value" of the player instance. 

end




#MAIN MENU OPTION 8 - SEASON TICKET UPDATE

def got_season_ticket(user)
    puts "\n \nCongrats on getting a season ticket. You're a true fan! :)"
    fan = Fan.find_by(name: user) 
    fan.update(season_ticket_holder: true)
    puts "We've updated your account so other fans know that they can meet up with you at the stadium during season games :)."
end