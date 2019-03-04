class GamesController < ApplicationController
  def index
    @games = policy_scope(Game)
  end

  def show
    @game = Game.find(params[:id])
    authorize @game
    @request = @game.request
    @team = current_user.team
    @message = Message.new(request: @request)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
