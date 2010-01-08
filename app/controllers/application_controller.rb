# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
    #before_filter :authenticate

    # basic authentication
    def authenticate
      authenticate_or_request_with_http_basic('this is a secret area') do |username, password|
        htpasswd = {'nuve' => 'man'}
        htpasswd[username] == password
      end
    end

    before_filter :session_expiry, :login_required, :is_verified? 
    helper_method  :session_expiry, :logged_in?, :is_verified?, :current_user, :verification_link #,:can_modify

    # Assumes a user is logged in
    #def can_modify?(mod_val)
    #  (current_user.mod & mod_val) != 0
    #end
    
    def redirect_if_auth
      redirect_to :controller => 'dashboard' if logged_in?
    end

    ## Timeout after inactivity of 1/2 hour.
    MAX_SESSION_PERIOD = 1800

    def session_expiry
      if logged_in? and session[:expiry_time] and session[:expiry_time] < Time.now
        reset_session
        flash[:error] = "Session expired. Please login again."
        redirect_to(new_session_path)
        return false
      end
      session[:expiry_time] = MAX_SESSION_PERIOD.seconds.from_now
    end

    protected
      def is_verified?
        unless (current_user && current_user.is_verified?)
          flash[:error] = 'Account has not been verified. Please check your email.'
          redirect_to :controller => "users", :action => "show", :id => current_user.id
          return false
        end
      end

      # Returns true or false if the user is logged in.
      def logged_in?
        !!current_user
      end

      # Accesses the current user from the session.
      def current_user
        @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_user == false
      end

      # Store the given user id in the session.
      def current_user=(new_user)
        session[:user_id] = new_user ? new_user.id : nil
        @current_user = new_user || false
      end

      # Check if the user is authorized
      # => override
      def authorized?(action = action_name, resource = nil)
        logged_in?
      end

      # Filter method to enforce a login requirement.
      def login_required
        #flash[:error] ||= 'Login required.' unless authorized? || access_denied
        unless authorized?
          flash[:notice] = 'You must be logged in to do that.'
          access_denied
        end
      end

      # Redirect as appropriate when an access request fails.
      #
      # The default action is to redirect to the login screen.
      #
      # Override this method in your controllers if you want to have special
      # behavior in case the user is not authorized
      # to access the requested action.  For example, a popup window might
      # simply close itself.
      def access_denied
        respond_to do |format|
          format.html do
            store_location
            redirect_to login_path
          end
          #format.any(:json, :xml) do
          #  request_http_basic_authentication 'Web Password'
          #end
        end
      end

      # Store the URI of the current request in the session.
      def store_location
        session[:return_to] = request.request_uri
      end

      # Redirect to the URI stored by the most recent store_location call or
      # to the passed default.  Set an appropriately modified
      #   after_filter :store_location, :only => [:index, :new, :show, :edit]
      # for any controller you want to be bounce-backable.
      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end
      
      def ajax_redirect_back_or_default(default)
        render :update do |page|
          page.redirect_to(session[:return_to] || default)
        end
        session[:return_to] = nil
      end

      # Inclusion hook to make #current_user and #logged_in?
      # available as ActionView helper methods.
      def self.included(base)
        base.send :helper_method, :current_user, :logged_in?, :authorized? if base.respond_to? :helper_method
      end

      #
      # Login
      #

      # Called from #current_user.  First attempt to login by the user id stored in the session.
      def login_from_session
        self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
      end

      # Called from #current_user.  Now, attempt to login by basic authentication information.
      def login_from_basic_auth
        authenticate_with_http_basic do |login, password|
          self.current_user = User.authenticate(login, password)
        end
      end

      #
      # Logout
      #
      # This is ususally what you want; resetting the session willy-nilly wreaks
      # havoc with forgery protection, and is only strictly necessary on login.
      # However, **all session state variables should be unset here**.
      def logout_keeping_session!
        # Kill server-side auth cookie
        #@current_user.forget_me if @current_user.is_a? User
        @current_user = false     # not logged in, and don't do it for me
        kill_remember_cookie!     # Kill client-side auth cookie
        session[:user_id] = nil   # keeps the session but kill our variable
        # explicitly kill any other session variables you set
      end

      # The session should only be reset at the tail end of a form POST --
      # otherwise the request forgery protection fails. It's only really necessary
      # when you cross quarantine (logged-out to logged-in).
      def logout_killing_session!
        logout_keeping_session!
        reset_session
      end

      # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
      # for the paranoid: we _should_ be storing user_token = hash(cookie_token, request IP)
      def login_from_cookie
        user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
        if user && user.remember_token?
          self.current_user = user
          handle_remember_cookie! false # freshen cookie token (keeping date)
          self.current_user
        end
      end

      #
      # Remember_me Tokens
      #
      def valid_remember_cookie?
        return nil unless @current_user
        (@current_user.remember_token?) && 
          (cookies[:auth_token] == @current_user.remember_token)
      end

      # Refresh the cookie auth token if it exists, create it otherwise
      def handle_remember_cookie!(new_cookie_flag)
        return unless @current_user
        case
          when valid_remember_cookie? 
            then @current_user.refresh_token # keeping same expiry date
          when new_cookie_flag
            then @current_user.remember_me
        else
          @current_user.forget_me
        end
        send_remember_cookie!
      end

      def kill_remember_cookie!
        cookies.delete :auth_token
      end

      def send_remember_cookie!
        cookies[:auth_token] = {
          :value   => @current_user.remember_token,
          :expires => @current_user.remember_token_expires_at }
      end
end
