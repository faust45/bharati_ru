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
  root :to => "main#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  #

  match 'users/login(.:format)' => 'users#login', :as => 'login'
  match 'users/logout' => 'users#logout', :as => 'logout'
  match 'users/change_css_style/:css_style' => 'users#change_css_style', :as => 'user_change_css_style'

  match 'photos' => 'photos#index', :as => 'photos'
  match 'photos/:section_id' => 'photos#index', :as => 'photos_section'
  match 'photos/album/:id' => 'photos#album', :as => 'album_photos'

  match 'videos' => 'videos#index', :as => 'videos'
  match 'videos/author/:author_id/:id' => 'videos#show', :as => 'show_author_video'
  match 'videos/author/:author_id' => 'videos#author', :as => 'author_videos'
  match 'videos/author/:author_id/year/:year' => 'videos#year', :as => 'author_year_videos'
  match 'videos/author/:author_id/year/:year/:id' => 'videos#year', :as => 'show_author_year_video'
  match 'videos/:id' => 'videos#show', :as => 'show_video'

  match 'publications' => 'publications#index', :as => 'publications'
  match 'publications/album/:album_id' => 'publications#album', :as => 'publications_album'
  match 'publications/author/:author_id' => 'publications#author', :as => 'author_publications'
  match 'publications/:id' => 'publications#show', :as => 'show_publication'

  match 'about' => 'about#index', :as => 'about', :defaults => {:about => 'about'}
  match 'about/ychenie' => 'about#index', :as => 'about_ychenie', :defaults => {:about => 'ychenie'}
  match 'about/to_start' => 'about#index', :as => 'about_to_start', :defaults => {:about => 'to_start'}
  match 'about/author/:id' => 'about#author', :as => 'about_author'

  match 'events' => 'events#index', :as => 'events'
  match 'events/type/:type' => 'events#type', :as => 'events_type'
  match 'events/:id' => 'events#show', :as => 'show_event'

  match 'teachers' => 'teachers#index', :as => 'teachers'
  match 'teachers/:id' => 'teachers#index', :as => 'teacher_show'

  match 'contacts' => 'contacts#feedback', :as => 'contacts', :via => :get
  match 'contacts' => 'contacts#feedback', :as => 'feedback', :via => :get
  match 'contacts' => 'contacts#post_msg', :as => 'post_msg', :via => :post
  match 'contacts/follow' => 'contacts#on_other_sites', :as => 'on_other_sites'
  match 'contacts/links' => 'contacts#links', :as => 'contacts_links'

  match 'audios' => 'audios#index', :as => 'audios'

  match 'audios/album/Bhagavatam' => 'audios#bhagavatam', :as => 'audios_bhagavatam'
  match 'audios/album/Bhagavatam/Book/:book_num' => 'audios#bhagavatam', :as => 'audios_bhagavatam_book', 
        :constraints => { :book_num => /\d+.?\d?/ }
  match 'audios/album/Bhagavatam/Book/:book_num/:track_id' => 'audios#bhagavatam', :as => 'audios_bhagavatam_track',
        :constraints => { :book_num => /\d+.?\d?/ }

  match 'audios/album/:album_id/' => 'audios#album', :as => 'album'
  match 'audios/album/:album_id/track/:id' => 'audios#album', :as => 'album_track'
  match 'audios/author/:author_id' => 'audios#author', :as => 'author_audios'
  match 'audios/show/:id' => 'audios#show', :as => 'show_audio'
  match 'audios/author/:author_id/year/:year' => 'audios#year', :as => 'author_year_audios'
  match 'audios/author/:author_id/year/:year/:month' => 'audios#year', :as => 'author_year_month_audios'
  match 'audios/author/:author_id/year/:year/:month/:track_id' => 'audios#year', :as => 'author_year_month_track'


  match 'audios/search' => 'search#audios', :as => 'audios_search'
  match 'audios/album/:album_id/search' => 'search#audios', :as => 'audios_search_in_album'
  match 'audios/author/:author_id/search' => 'search#audios', :as => 'audios_search_in_author'
  match 'audios/author/:author_id/:year/search' => 'search#audios', :as => 'audios_search_in_author_year'

  resources :users do
  end


  namespace :admin do
    root :to => "audios#index"

    controller 'albums' do
      scope 'albums' do
        match 'add_track',  :to => :add_track,  :as => :album_add_track
        match 'drop_track', :to => :drop_track, :as => :album_drop_track
        match 'upload/cover', :to => :upload_cover, :as => :album_upload_cover
      end
    end

    controller 'audios' do
      scope 'audios' do
        root :to => "audios#index", :as => :audios
        match 'save', :to => :update, :as => :audio_update
        match 'destroy', :to => :destroy, :as => :audio_destroy
        match 'upload/new',   :to => :new, :as => :audio_new
        match 'upload/photo', :to => :upload_photo, :as => :audio_upload_photo
        match 'upload/replace_source', :to => :replace_source, :as => :audio_replace_source
        match 'author/:author_id', :to => "audios#author", :as => :author_audios
      end
    end

    controller 'albums' do
      scope 'albums' do
        match 'save', :to => :update, :as => :album_update
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

    controller 'authors' do
      scope 'authors' do
        root :to => "authors#index", :as => :authors
        match 'destroy', :to => :destroy, :as => :author_destroy
        match 'save', :to => :update, :as => :author_update
        match 'new',   :to => :new, :as => :author_new
        match 'upload/photo', :to => :upload_photo, :as => :author_upload_photo
      end
    end

    resources :tags do
    end
  end

  match 'autocomplete/tags', :to => 'admin/tags#autocomplete', :as => :autocomplete_tags
  match 'autocomplete/albums', :to => 'admin/albums#autocomplete', :as => :autocomplete_albums

  match '/:any', :to => 'application#page_404', :constraints => { :any => /.*/ }
end
