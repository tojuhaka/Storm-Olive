module SessionsHelper
  def logger
    RAILS_DEFAULT_LOGGER
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    @current_user = user
  end

  def current_user=(user)
    current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    # !current_user.nil? doesnt work TODO: why?
    !@current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    @current_user = nil
  end

  private
    def user_from_remember_token
      remember_token = cookies[:remember_token]
      User.find_by_remember_token(remember_token) unless remember_token.nil?
    end

    def remember_token
      Cookies.signed[:remember_token] || [nil, nil]
    end
end
