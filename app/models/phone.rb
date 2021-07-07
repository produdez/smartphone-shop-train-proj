class Phone < ApplicationRecord
    belongs_to :model
    belongs_to :store
    belongs_to :color
end
