Rails.application.routes.draw do
	
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
		end

		scope 'projects/:project_id/sprints', controller: 'sprints' do
			get '/:id', as: 'project_sprint_developer', action: 'show_developer'
			get '/:id/calendar', as: 'sprint_calendar', action: 'calendar'
		end

		scope 'users', controller: 'users' do
			get '/', as: 'users_developer', action: 'index_developer'
			get '/:id/calendar', as: 'calendar', action: 'calendar'
			get '/:id', as: 'user_developer', action: 'show_developer'
		end

		scope 'users/:user_id' do
			resources :dailies
		end

		get '/account', as: 'account', controller: 'users', action: 'account'
	end

	devise_for :users, path: 'auth', controllers: { 
		sessions: 'users/sessions',
		registrations: 'users/registrations',
		passwords: 'users/passwords',
		confirmations: 'users/confirmations'
	}

	root to: "projects#index"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
