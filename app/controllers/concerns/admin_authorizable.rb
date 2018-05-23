module AdminAuthorizable
  extend ActiveSupport::Concern

  included do
    rescue_from NotPermittedException, with: -> { jsonapi_render_errors status: :forbidden }
  end

  def authorize!(action)
    raise NotPermittedException if action == :admin && !@current_user.admin?
    true
  end
end