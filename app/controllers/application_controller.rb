class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_student!

  rescue_from ActionController::RoutingError do |exception|
   logger.error 'Routing error occurred'
   render plain: '404 Not found', status: 404
  end


end
