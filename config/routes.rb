Rails.application.routes.draw do
	
	resources :projects do
	  resources :sprints
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
