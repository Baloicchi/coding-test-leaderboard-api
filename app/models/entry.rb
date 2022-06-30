require_relative '../models/user'
require_relative '../models/leaderboard'

class Entry
  include Mongoid::Document

  field :score, type: Integer
  field :scored_at, type: DateTime

  belongs_to :user
  belongs_to :leaderboard

  validates :score, :scored_at, presence: true

  before_validation :set_user, :set_board

  def set_user
    raise StandardError.new('Missing User') if self.user_id.nil?

    user = User.find_by!(_id: self.user_id)
    self.user = user if user
  end

  def set_board
    raise StandardError.new('Missing Leaderboard') if self.leaderboard_id.nil?

    leaderboard = Leaderboard.find_by!(_id: self.leaderboard_id)
    self.leaderboard = leaderboard if leaderboard
  end
end
