class LeaderboardsController < ApplicationController
  def index
    limit = (params[:per_page] || 10).to_i
    skip = params[:page] ? params[:page].to_i - 1 : 0

    @leaderboard = Leaderboard.find(params[:_id])

    @entries = @leaderboard.entries.skip(skip).limit(limit)
    @entries = @entries.order(score: :desc, scored_at: :asc)
    
    entries_json = @entries.as_json(
      only: [:score, :user_id, :scored_at],
    ).each_with_index.map { |entry, rank| 
      user = User.find(entry["user_id"])
      entry.merge!("rank" => rank, "name": user.name, "user_id": user._id.to_s) 
    }

    render json: {
      board: {
        _id: @leaderboard[:_id].to_s,
        name: @leaderboard[:name],
        entries: entries_json
      }
    }, 
    status: :ok

  rescue Mongoid::Errors::DocumentNotFound
    render json: { errors: 'Leaderboard not found.' }, status: :not_found
  end

  def create
    @leaderboard = Leaderboard.create!(leaderboard_params)
    render json: { board: { _id: @leaderboard[:_id].to_s, name: @leaderboard[:name] } }, status: :ok
  rescue Mongoid::Errors::Validations => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def add_score
    _id          = params[:_id]
    user_id      = params[:user_id]
    score_to_add = params[:score_to_add]

    raise StandardError.new('Missing _id') if _id.blank?
    raise StandardError.new('Missing user_id') if user_id.blank?

    raise StandardError.new('Missing score_to_add') if score_to_add.blank?
    raise StandardError.new('score_to_add should be an Integer.') if !score_to_add.is_a? Integer

    @entry = Entry.find_by(leaderboard_id: params[:_id], user_id: user_id)
    @entry.update!(score: @entry.score + score_to_add)

    render json: { 
      entry: {
        _id: _id,
        board_id: @entry.leaderboard_id.to_s,
        score: @entry.score,
        scored_at: @entry.scored_at,
        user_id: @entry.user_id.to_s
      }
    }, 
    status: :ok
  rescue Mongoid::Errors::DocumentNotFound
    render json: { errors: 'Entry not found.' }, status: :not_found
  end

  private
  def leaderboard_params
    params.require(:leaderboard).permit(:name)
  end
end
