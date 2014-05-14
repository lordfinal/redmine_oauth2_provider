  module RedmineSocialExtends
    module UserExtension
      module ClassMethods

      end
      
      module InstanceMethods

      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          #OAuth2 Provider-Mixins
          include Songkick::OAuth2::Model::ResourceOwner
          include Songkick::OAuth2::Model::ClientOwner

        end
      end
    end
        
    module UsersController
      module ClassMethods

      end

      module InstanceMethods

      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do

          def oauth_get_user_information
            verify_access :read_user_informations do |user|
              user = [User.find_by_login(params[:username])].map do |u|
                {:user_id => u.id, :login => u.login}
              end
              respond_to do |format|
                #format.html {render :text => user }
                format.json   { render :layout => nil, :text => user.to_json }
              end  
              
            end
          end


          private 
            
            def verify_access(scope)
              user  = User.find_by_login(params[:username])
              token = Songkick::OAuth2::Provider.access_token(user, [scope.to_s], request.env)

              unless token.valid?
                return render_403
              else
                yield user
              end
            end
        
        end
      end
    end
  end
