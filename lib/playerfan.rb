class PlayerFan < ActiveRecord::Base

    belongs_to :player
    belongs_to :fan

end