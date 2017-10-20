class Posession < ApplicationRecord
  belongs_to :token, optional: true
end
