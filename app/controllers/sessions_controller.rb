# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'application'
  skip_before_filter :login_required, :is_verified?, :session_expiry
  before_filter :redirect_if_auth, :only => ['new']
  
  def index
    redirect_to :action => "new"
  end

  def new; end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      if user.is_verified?
        self.current_user = user
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        ajax_redirect_back_or_default(home_path)
      else
        flash[:notice] = "You must verify your account before logging in.  Please check your email."
        ajax_redirect_back_or_default('/')
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash.now[:notice] = "Username and/or password incorrect.  Please try again."
      render :update do |page|
        page.replace_html 'main', :partial => 'new'
      end
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Thanks for coming by. Come back soon!"
    redirect_back_or_default('/login')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    #flash.now[:error] = "Incorrect login or password."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
