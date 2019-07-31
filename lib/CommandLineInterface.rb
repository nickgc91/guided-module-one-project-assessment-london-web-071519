class CommandLineInterface 

    old_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = nil
    #To turn it back on:
    #ActiveRecord::Base.logger = old_logger



    def run

        greet
        user = logging_in
        
        #user has successfully logged in
        puts "Thanks for logging in :)"


        user_option_choice = option_select

          while user_option_choice != 'exit'

            if user_option_choice == 'View my favorite players'
                puts "\nYour favorite player(s):"
                show_favorite_players(user) 
            elsif user_option_choice == 'View all fans of a specifc player'
                all_fans_of_specific_player
            elsif user_option_choice == 'View favorite players of another fan'
                view_fav_players_of_another_fan
            elsif user_option_choice == 'View total market value of the starting 11 players'
                total_market_value_of_starting_11
            elsif user_option_choice == 'Add a new favorite player to my account'
                create_favorite_player_for_user(user)
            elsif user_option_choice == 'Delete a favorite player from my account'
                delete_favorite_player_for_user(user)
            elsif user_option_choice == 'I just got a season ticket. Update my club season ticket status.'
                got_season_ticket(user)
            end
        
            sleep(1.5)

            user_option_choice = option_select
        end 

    
    end
   
        
end
    
