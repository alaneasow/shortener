class Shortener::ShortenedUrlsController < ActionController::Metal
  include ActionController::StrongParameters
  include ActionController::Redirecting
  include ActionController::Instrumentation
  include Rails.application.routes.url_helpers
  include Shortener

  def show
    token = ::Shortener::ShortenedUrl.extract_token(params[:id])
    track = Shortener.ignore_robots.blank? || request.human?
    url   = ::Shortener::ShortenedUrl.fetch_with_token(token: token, additional_params: params, track: track)
    if Rails.env.production?
      redirect_to "https://test.sparkstudio.co#{url[:url]}", status: :moved_permanently
    else
      redirect_to "https://sparkstudio.co#{url[:url]}", status: :moved_permanently
    end
  end
end
