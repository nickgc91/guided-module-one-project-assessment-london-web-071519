class CommandLineInterface 

    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    #To turn it back on:

    #ActiveRecord::Base.logger = old_logger


    def greet
        puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
    end



    def run

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
        
        choices = %w(view_my_favorite_players 
        view_all_fans_of_a_specific_player 
        view_favorite_players_of_another_fan
        view_total_market_value_of_starting_11
        )

        user_option_choice = prompt.select("What would you like to do? Choose from the options below:") do |menu|
            menu.choice 'View my favorite players'
            menu.choice 'View all fans of a specifc player'
            menu.choice 'View favorite players of another fan'
            menu.choice 'View total market value of starting 11 players'
            menu.choice 'exit'
          end

          while user_option_choice != 'exit'

            if user_option_choice == 'View my favorite players'
                puts "These are your favorite player(s):"
                show_favorite_players(user) 
            elsif user_option_choice == 'View all fans of a specifc player'
                puts "Great, you want to see who a specifc fan's favorite players are :)."
                fan_you_want_to_view = prompt.ask('Please type in the name of the fan whose favorite players you want to see: ', required: true)
                while Fan.find_by(name: fan_you_want_to_view) == nil
                    puts "Sorry we didn't recognize that username."
                    fan_you_want_to_view = prompt.ask("Please try again. Type in the name of the fan username: ", required: true)
                end
                puts "#{fan_you_want_to_view}\'s favorite players are:"   
                show_favorite_players(fan_you_want_to_view) 
            else 
                puts "in the conditional statement"
            end
        
            sleep(1)

            user_option_choice = prompt.select("\n \nWhat would you like to do? Choose from the options below:") do |menu|
                menu.choice 'View my favorite players'
                menu.choice 'View all fans of a specifc player'
                menu.choice 'View favorite players of another fan'
                menu.choice 'View total market value of starting 11 players'
                menu.choice 'exit'
              end
        end 

    
    end

    def show_favorite_players(user)
        fan1 = Fan.find_by(name: user)
        players_array = fan1.players
        players_array.each do |player|
            puts player.name 
        end
    end

   
        
end
    
