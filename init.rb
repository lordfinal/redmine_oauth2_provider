require 'rails'
require 'redmine'

Rails.configuration.to_prepare do
  require_dependency 'user'
  
  require File.join(File.dirname(__FILE__),'lib','redmine_oauth2_provider','patch_user' )
  User.send(:include, ::RedmineSocialExtends::UserExtension)
  UsersController.send(:include, ::RedmineSocialExtends::UsersController)
end

#oauth provider 
#Schema
#Add the Songkick::OAuth2::Provider tables to your app's schema. 
#
#This is done using 
# rails c  << Songkick::OAuth2::Model::Schema.migrate
# which will run all the gem's migrations that have not yet been applied to your database.
require 'songkick/oauth2/provider'
Songkick::OAuth2::Provider.realm = 'redmine'
#Songkick::OAuth2::Provider.enforce_ssl = true

if(ActiveRecord::Base.connection.tables.select {|t| t.include?("oauth2") }.empty?)
  Songkick::OAuth2::Model::Schema.migrate
end

Redmine::Plugin.register :redmine_oauth2_provider do
  name 'Redmine Oauth2 Privider'
  author 'lord.final'
  description 'Oauth2 Provider for Redmine'
  version '0.0.1'
  url 'https://github.com/lordfinal/redmine_oauth2_provider'
  author_url 'https://github.com/lordfinal/redmine_oauth2_provider'
  settings(:default => { 
    'permissions' => { :read_user_informations => 'Read all user informations'}
    }, :partial =>'settings_redmine_oauth2_provider/settings')
  menu :admin_menu, :oauth2_applications, {:controller => 'oauth2', :action => 'clients'}, :caption => :label_oauth2_applications, :html => {:class => "icon icon-share"}
end
