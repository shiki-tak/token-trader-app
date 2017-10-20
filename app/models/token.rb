class Token < ApplicationRecord
  has_one :posession, dependent: :destroy
end
