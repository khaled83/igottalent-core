class ApplicationController < ActionController::API
  include JSONAPI::Utils

  # protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :jsonapi_render_not_found
end
