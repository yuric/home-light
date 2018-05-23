class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with :name => ENV["AUTH-NAME"], :password => ENV["AUTH-PASSWORD"]
end
