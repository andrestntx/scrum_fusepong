Rails.application.routes.draw do
	
	devise_for :users, path: 'auth', controllers: { 
		sessions: 'users/sessions',
		registrations: 'users/registrations',
		passwords: 'users/passwords',
		confirmations: 'users/confirmations'
	}

	scope 'admin' do
		resources :projects do
		  resources :sprints
		end

		resources :users
	end

	scope 'developer' do
		scope 'projects', controller: 'projects' do
			get '/', as: 'projects_developer', action: 'index_developer'
			get '/:id', as: 'project_developer', action: 'show_developer'

			# Get a JSON with data calendar
			get '/:id/calendar', as: 'project_calendar', action: 'calendar'
		end

		scope 'projects/:project_id/sprints', controller: 'sprints' do
			get '/:id', as: 'project_sprint_developer', action: 'show_developer'

			# Get a JSON with data calendar
			get '/:id/calendar', as: 'sprint_calendar', action: 'calendar'
		end

		scope 'users', controller: 'users' do
			get '/', as: 'users_developer', action: 'index_developer'
			get '/:id', as: 'user_developer', action: 'show_developer'

			# Get a JSON with data calendar
			get '/:id/calendar', as: 'calendar', action: 'calendar'
		end

		scope 'users/:user_id' do
			resources :dailies
			post '/dailies/mobile', as: 'dailies_mobile', controller: 'dailies', action: 'create_mobile'
		end

		get '/account', as: 'account', controller: 'users', action: 'account'
	end

	scope 'mobile', controller: 'mobile' do
		get '/', as: 'index_mobile', action: 'index'	
		get '/projects/:id', as: 'projects_mobile', action: 'projects'	
		get '/team/:id', as: 'team_mobile', action: 'team'	
	end

	root to: "projects#index"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
