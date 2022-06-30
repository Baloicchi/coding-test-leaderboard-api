class EntriesController < ApplicationController
  ## curl --header "Content-Type: application/json" --request POST --data '{ "score": {score}, "scored_at": "{scored_at}", "user_id": "{user_id}", "leaderboard_id": "{leaderboard_id}" }' http://localhost:3000/entry -v
  def create
    @entry = Entry.create!(entry_params)
    render json: @entry, status: :ok
  rescue Mongoid::Errors::Validations => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  private
  def entry_params
    params.require(:entry).permit(:score, :scored_at, :user_id, :leaderboard_id)
  end
end
