class Player < ActiveRecord::Base

    has_many :playersfans
    has_many :fans, through: :playersfans

    
end