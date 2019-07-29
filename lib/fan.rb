class Fan < ActiveRecord::Base #Use base class from ActiveDirectory module

    has_many :playersfans
    has_many :players, through: :playersfans

end