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
		end

		scope 'users', controller: 'users' do
			get '/', as: 'users_developer', action: 'index_developer'
			get '/:id', as: 'user_developer', action: 'show_developer'
		end

		scope 'users/:user_id' do
			resources :dailies
		end

		get '/account', as: 'account', controller: 'users', action: 'account'

	end

	scope 'all' do
		scope 'users/:user_id' do			
			scope 'projects', controller: 'projects' do
				get '/', as: 'user_projects_developer', action: 'index_user_developer'
				get '/:id', as: 'user_project_developer', action: 'show_user_developer'
			end
			
			scope 'projects/:project_id/sprints', controller: 'sprints' do
				get '/', as: 'user_project_sprints_developer', action: 'index_user_project_developer'
				get '/:id', as: 'user_project_sprint_developer', action: 'show_user_project_developer'
			end

			scope 'projects/:project_id/sprints/:sprint_id', controller: 'dailies' do
				get '/', as: 'user_project_sprint_dailies_developer', action: 'index_user_project_sprint_developer'
				get '/:id', as: 'user_project_sprint_daily_developer', action: 'show_user_project_sprint_developer'
			end
		end
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
