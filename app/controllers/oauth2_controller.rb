class Oauth2Controller < ApplicationController 
  before_filter :require_login, :except => []
  before_filter :require_admin, :only => [:register_app, :create_app, :del_client]

  def authorize_app
    #http://localhost:3000/oauth2/authorize_client?response_type=token&client_id=js6w22mlf06cv4r4en6ka3ac6d4gm3y&redirect_uri=https://owncloud.reichmann-software.com
    @oauth2 = Songkick::OAuth2::Provider.parse(User.current, request.env)

    if @oauth2.redirect?  
      redirect_to(@oauth2.redirect_uri, :status => @oauth2.response_status)
    end

    respond_to do |format|
      format.html {}
      format.api {}
      format.atom {}
    end
  end

  def register_app
    @client = Songkick::OAuth2::Model::Client.new
    respond_to do |format|
      format.html {}
      format.api {}
      format.atom {}
    end
  end
 
  def create_app
    @client = Songkick::OAuth2::Model::Client.new({ 'name' => params[:name], 'redirect_uri' => params[:redirect_uri]})
    @client.owner = User.current
    if @client.save
      session[:client_secret] = @client.client_secret
      redirect_to(oauth2_client_show_path(@client.id))
    else
      err_msg = ''
      if @client.errors.any?
        @client.errors.full_messages.each do |message|
          err_msg += "<b class='icon icon-bolt'><i>#{message}</i></b><br />"
        end
      end
      flash[:error] = "#{l(:label_oauth2_create_application_error)}: <br />"
      flash[:error] += err_msg.html_safe
      redirect_to(oauth2_register_client_path)
    end
  end

  def client
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])
    @client_secret = session[:client_secret]
  end

  def clients
    @clients = Songkick::OAuth2::Model::Client.all
  end

  def del_client
    @client = Songkick::OAuth2::Model::Client.find_by_id(params[:id])

    @client.delete
    redirect_to(oauth2_clients_path)
  end

  def allow_client
    @auth = Songkick::OAuth2::Provider::Authorization.new(User.current, params)
    if params['allow'] == '1'
      @auth.grant_access!
    else
      @auth.deny_access!
    end
    redirect_to(@auth.redirect_uri,  :status => @auth.response_status)
  end
end