module ApplicationHelper
  
  def current_controller?(options)
    url_string = URI.parser.unescape(url_for(options)).force_encoding(Encoding::BINARY)
    url_path = Rails.application.routes.recognize_path(url_string)
    params[:controller] == url_path[:controller]
  end
end
