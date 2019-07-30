class Fan < ActiveRecord::Base #Use base class from ActiveDirectory module

    has_many :player_fans
    has_many :players, through: :player_fans

end