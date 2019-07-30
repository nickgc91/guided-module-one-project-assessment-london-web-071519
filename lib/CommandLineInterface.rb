class CommandLineInterface 

    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    #To turn it back on:

    #ActiveRecord::Base.logger = old_logger


    def greet
        puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
    end


    def show_favorite_players(user)
        fan1 = Fan.find_by(name: user)
        players_array = fan1.players
        players_array.each do |player|
            puts player.name 
        end
    end


    def view_fav_players_of_another_fan
        require "tty-prompt"
        prompt = TTY::Prompt.new

        puts "Great, you want to see who a specifc fan's favorite players are :)."
                fan_you_want = prompt.ask('Please type in the name of the fan whose favorite players you want to see: ', required: true)
                while Fan.find_by(name: fan_you_want) == nil
                    puts "Sorry we didn't recognize that username."
                    fan_you_want = prompt.ask("Please try again. Type in the name of the fan username: ", required: true)
                end
                puts "#{fan_you_want}\'s favorite player(s):"   
                show_favorite_players(fan_you_want) 
    end
    

    def show_fans(player)
        player1 = Player.find_by(name: player)
        players_array = player1.fans
        players_array.each do |player|
            puts player.name 
        end
    end


    def all_fans_of_specific_player
        require "tty-prompt"
        prompt = TTY::Prompt.new

        puts "So you want to see the fans of a specific player :). Awesome, which player would you like to see the fans for?"
        player_you_want = prompt.ask('Please type in the name of the player whose fans you want to see: ', required: true)
                while Player.find_by(name: player_you_want) == nil
                    puts "Sorry we didn't recognize that username."
                    player_you_want = prompt.ask("Please try again. Type in the name of the player: ", required: true)
                end
                puts "#{player_you_want}\'s fans:"
                show_fans(player_you_want)
    end

    def option_select
        require "tty-prompt"
        prompt = TTY::Prompt.new

        puts "\n \n"

        prompt.select("What would you like to do? Choose from the options below:") do |menu|
            menu.choice 'View my favorite players'
            menu.choice 'View all fans of a specifc player'
            menu.choice 'View favorite players of another fan'
            menu.choice 'View total market value of the team'
            menu.choice 'Add a new favorite player to my account'
            menu.choice 'Delete a favorite player from my account'
            menu.choice 'I just got a season ticket. Update my club season ticket status.'
            menu.choice 'exit'
          end

    end


    def run

        playerfan1 = PlayerFan.create(player_id: 7, fan_id: 11)
        puts playerfan1

        require "tty-prompt"
        prompt = TTY::Prompt.new

        greet
        user = prompt.ask('Please type in your fan username to get started or type exit to quit app: ', required: true)
        if user == "exit"
            exit
        else
            while Fan.find_by(name: user) == nil
            puts "Sorry we didn't recognize that username."
            user = prompt.ask("Please try again. Type in your fan username to get started: ", required: true)
            end
        end
        
        #user has successfully logged in
        puts "Thanks for logging in :)"


        user_option_choice = option_select

          while user_option_choice != 'exit'

            if user_option_choice == 'View my favorite players'
                puts "Your favorite player(s):"
                show_favorite_players(user) 
            elsif user_option_choice == 'View all fans of a specifc player'
                all_fans_of_specific_player
            elsif user_option_choice == 'View favorite players of another fan'
                view_fav_players_of_another_fan
            elsif user_option_choice == 'View total market value of the team'
                puts "Nick still needs to build this one: total market value of team"
            elsif user_option_choice == 'Add a new favorite player to my account'
                puts "Nick still needs to build this one: fan user can add a favorite player"
            elsif user_option_choice == 'Delete a favorite player from my account'
                puts "Nick still needs to build this one: fan user can delete a favorite player"
            elsif user_option_choice == 'I just got a season ticket. Update my club season ticket status.'
                puts "Nick still needs to build this one: update season ticket status"
            end
        
            sleep(1.5)

            user_option_choice = option_select
        end 

    
    end
   
        
end
    
