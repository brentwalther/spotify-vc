class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def spotify
    # Use the raw info from omniauth because it's schema is what RSpotify expects.
    omniauth_options = request.env['omniauth.auth']['extra']['raw_info']
    spotify_user = RSpotify::User.new(omniauth_options)
    @user = User.find_or_create_by(email: spotify_user.email) do |user|
      user.spotify_info = spotify_user.to_hash
    end

    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    set_flash_message(:notice, :success, :kind => "Spotify") if is_navigational_format?
  end

  def failure
    redirect_to root_path
  end
end
