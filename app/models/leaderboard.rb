class Leaderboard
  include Mongoid::Document
  field :name, type: String

  has_many :entries
  validates :name, presence: true
end
