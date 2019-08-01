class Player < ActiveRecord::Base

    has_many :player_fans
    has_many :fans, through: :player_fans
    belongs_to :club

end