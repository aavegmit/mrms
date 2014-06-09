Mrms::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "users"}
  resources :vaccines


  resources :patients do
     collection do
	post 'vaccinate'
     end
  end

#  resources :welcome do
#     collection do
#	get 'upload'
#     end
#  end
  
  resources :reminder do
     collection do
	get 'index'
     end
  end

  devise_scope :user do
     authenticated :user do
	root :to => 'patients#index', as: :authenticated_root
     end
     unauthenticated :user do
	root :to => 'devise/sessions#new', as: :unauthenticated_root
     end
  end

  namespace :api do
     devise_scope :user do
	post 'sessions' => 'session#create', :as => 'login'
     end
     resources :reminder do
	collection do
	   post 'getSMSReminders'
	end
     end
  end
end
