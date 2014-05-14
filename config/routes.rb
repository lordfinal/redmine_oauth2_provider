RedmineApp::Application.routes.draw do
  
  scope "oauth2" do 
    match '/authorize_client',  :controller => 'oauth2', :action => 'authorize_app', :as => 'oauth2_authorize_client', :via =>[:post,:get]
    match '/register_client',  :controller => 'oauth2', :action => 'register_app', :as => 'oauth2_register_client', :via =>[:post,:get]
    match '/create_client', :controller => 'oauth2', :action => 'create_app', :as => 'oauth2_create_client', :via =>[:post]
    match '/client/:id', :controller => 'oauth2', :action => 'client', :id => /\d+/, :as =>'oauth2_client_show', :via => [:get]
    match '/clients', :controller => 'oauth2', :action => 'clients', :as =>'oauth2_clients', :via => [:get]
    match '/client/:id', :controller => 'oauth2', :action => 'del_client', :as =>'oauth2_client_delete', :via => [:delete]
    match '/allow_client', :controller => 'oauth2', :action => 'allow_client', :as => 'oauth2_allow_client', :via =>[:post]
  end
  scope "user" do 
    match '/oauth_user_information', :controller => 'users', :action => 'oauth_get_user_information', :as => 'oauth_get_user_information', :via => [:get,:post]
  end
end