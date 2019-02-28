class TeamsController < ApplicationController
  def index
      @teams = policy_scope(Team)
    if params[:index]
      # get start_date from the form
      booking_start_date = Date.parse params[:index][:start_date]

      # get all teams
      # reject user team & reject teams from league
      user_league_teams = current_user.team.league.teams
      teams = @teams.reject { |team| user_league_teams.include?(team) }
      # reject team where user_start_date is included in games dates
      teams_results = teams.reject do |team|
        team_games = team.requests.map(&:game).compact
        return false if team_games.nil?

        # compare it to d1 and d2 of the games (between?)
        team_games_dates = team_games.map(&:dates_range).flatten
        # if true > exclude the team from the search
        team_games_dates.include?(booking_start_date)
      end

      # teams_displayed

      user_ranking = current_user.team.ranking
      # array of hashes (with team_id: & ranking_difference:)
      ranking_differences = []
      teams_results.each do |team|
        rankings = []
        rankings << team.ranking
        rankings << user_ranking
        rankings.sort! { |a, b| b <=> a }
        difference = rankings[0] - rankings[1]

        team_result = {
                      the_team: Team.find_by_id(team.id),
                      ranking_difference: difference
                      }

        ranking_differences << team_result
        # sort an array of hash by ranking_difference
      end

      ranked_teams = ranking_differences.sort_by! { |computed_team_result| computed_team_result[:ranking_difference] }
      final_ranked_teams = []
      ranked_teams.each do |team|
        final_ranked_teams << team[:the_team]
      end
      @teams = final_ranked_teams
        # team_result[:the_team_id]
    end

  end

  def show
    @team = Team.find(params[:id])
    @requests = @team.method_unavailable_dates
    gon.unavailable_dates = @requests
    @request = Request.new
    authorize @team
    @message = Message.new
    authorize @message
  end

  # not sure that we need it since we won't have admin users
  def new
  end

  # not sure that we need it since we won't have admin users
  def create
  end

  # not sure that we need it since we won't have admin users
  def edit
  end

  # not sure that we need it since we won't have admin users
  def update
  end
end
