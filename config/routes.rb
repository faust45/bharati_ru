MahaMandala::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "audios#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  #

  match 'users/login(.:format)' => 'users#login', :as => 'login'
  match 'users/logout' => 'users#logout', :as => 'logout'
  match 'users/change_css_style/:css_style' => 'users#change_css_style', :as => 'user_change_css_style'

  match 'audios/album/:album_id/' => 'audios#album', :as => 'album'
  match 'audios/album/:album_id/track/:id' => 'audios#album', :as => 'album_track'
  match 'audios/author/:author_id' => 'audios#author', :as => 'author_audios'

  resources :users do
  end

  resources :audios do
  end

  namespace :admin do
    root :to => "audios#index"

    match 'audios/author/:author_id', :to => "audios#author", :as => :author_audios

    controller 'albums' do
      scope 'albums' do
        match 'add_track',  :to => :add_track,  :as => :album_add_track
        match 'drop_track', :to => :drop_track, :as => :album_drop_track
      end
    end

    controller 'audios' do
      scope 'audios' do
        match 'upload/photo', :to => :upload_photo, :as => :audio_upload_photo
        match 'upload/replace_source', :to => :replace_source, :as => :audio_replace_source
      end
    end

    resources :albums do
    end

    resources :videos do
    end

    resources :audios do
      collection do
        post 'upload'
      end
    end

    controller :contents do
      scope '/contents' do
        match ':id/delete_file', :to => :delete_file, :as => :contents_delete_file
      end
    end

    controller :centers do
      scope :as => 'centers' do
        match ':id/delete_file', :to => :delete_file, :as => :delete_file
      end
    end

    resources :authors do
      collection do
        get 'autocomplete'
      end
    end

    resources :tags do
    end
  end

  match 'autocomplete/tags', :to => 'admin/tags#autocomplete', :as => :autocomplete_tags
  match 'autocomplete/albums', :to => 'admin/albums#autocomplete', :as => :autocomplete_albums
end
