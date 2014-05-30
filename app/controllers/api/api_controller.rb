module Api
  class Api::ApiController < ActionController::Base
    TOKEN = "e1732ee082eaa73c21a6e3b3541e560b"

#    before_filter :restrict_access
    respond_to :json


    private

    def restrict_access
      authenticate_or_request_with_http_token do |token, options|
        token == TOKEN
      end
    end

    def authenticate_user
      if params[:session_token]
        user = User.find_by_session_token(params[:session_token])
        if user.nil?
          render :json => {:success => false, :error => "Invalid session_token"}
        else
          @current_user = user
        end
      else
        render :json => {:success => false, :error => "session_token is missing"}
      end
    end
  end
end
