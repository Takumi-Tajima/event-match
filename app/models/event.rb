class Event < ApplicationRecord
  belongs_to :user

  scope :unchecked, -> { where(checked: false) }
end
