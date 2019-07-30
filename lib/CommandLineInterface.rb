class CommandLineInterface 

    def greet
        puts 'Welcome to Football Fan Masters, the best resource for football players information in the world!'
    end

    def run
        greet
        puts "Please type in your fan username to get started"
        user = gets.chomp

        Fan.find_by(name: user)

        
        puts "Need a reminder to show your favorite players?"
        puts "Type: yes or no"
        see_favorite_players_response =  gets.chomp
        if see_favorite_players_response == 'yes'
            fan1 = Fan.find_by(name: user) 
            puts fan1.players.first.name
        else
            nil
        end
    end
        
       

        # def show_players(user.players)
        #     playerfans.each do |playerfan|
        #         puts playerfan.name
        #     end
        # end
    

        
end
    
