class DailiesController < ApplicationController
	before_action :authenticate_user!
	before_action :new_daily, only: [:create, :create_mobile]
	
	def index
		@dailies = current_user.dailies
	end

	# POST /users/:user_id/dailies
	def create
		if @new_daily.save
			redirect_to account_path, notice: 'Daily was successfully created.'
		else
			redirect_to account_path, alert: 'Errors: ' + @new_daily.errors.full_messages.join(', ')
		end
	end

	def create_mobile
		if @new_daily.save
			redirect_to team_mobile_path(@user), notice: 'Daily was successfully created.'
		else
			redirect_to team_mobile_path(@user), alert: 'Errors: ' + @new_daily.errors.full_messages.join(', ')
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
	    def daily_params
	      params.require(:daily).permit(:time, :comments, :daily_time_id, :date)
	    end

	    def set_user
	    	@user = User.find(params[:user_id])
	    end

	    def new_daily
	    	set_user
	    	@new_daily = @user.new_daily(params[:daily][:project_id], daily_params)
	    end
end
