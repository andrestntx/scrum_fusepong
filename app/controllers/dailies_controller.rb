class DailiesController < ApplicationController
	def index
		@dailies = current_user.dailies
	end

	# POST /users/:user_id/dailies
	def create
		@user = User.find(params[:user_id])
		@new_daily = @user.new_daily(params[:daily][:project_id], daily_params)

		if @new_daily.save
			redirect_to account_path, notice: 'Daily was successfully created.'
		else
			redirect_to account_path, alert: 'Errors: ' + @new_daily.errors.full_messages.join(', ')
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
	    def daily_params
	      params.require(:daily).permit(:time, :comments, :daily_time_id, :date)
	    end
end
