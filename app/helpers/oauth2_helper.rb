module Oauth2Helper
  def oauth2_client_information
     html = "<p><label style=\"width: 100px;\">#{l(:label_oauth2_client_id)}: </label><label style=\"width: 260px;\">#{@client.client_id}</label></p>"
     html += "<p><label style=\"width: 100px;\">#{l(:label_oauth2_client_secret)}: </label><label style=\"width: 260px;\">#{@client_secret}</label></p>"
     html += "<p><label style=\"width: 100px;\">#{l(:label_oauth2_client_owner)}: </label><label style=\"width: 260px;\">#{@client.owner}</label></p>"
     return html.html_safe
  end
end