# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  layout 'application'
  #skip_before_filter :login_required, :is_verified?
  
  def index; end

  def new; end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      if user.is_verified?
        #reset_session
        self.current_user = user
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        flash[:notice] = "Welcome back."
      else
        flash[:notice] = "You must verify your account before logging in.  Please check your email."
      end
      redirect_back_or_default('/')
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash[:notice] = "Username and/or password incorrect.  Please try again."
      redirect_to :action => 'new'
    end
    
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "Thanks for comin by.  Come back soon!"
    redirect_back_or_default('/login')
    #redirect_to :controller => 'home'
  end
  
  def method_missing *args
    redirect_to :action => 'new'
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash.now[:error] = "Incorrect login or password."
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
