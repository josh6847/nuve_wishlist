class UsersController < ApplicationController
  layout 'application'
  before_filter :check_verification_token, :only => :verify
  skip_before_filter :login_required, :is_verified?, :session_expiry, :only => ['new', 'create', 'destroy','verify']
  
  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  #def register
  #  cookies.delete :auth_token
  #  reset_session
  #  @user = User.new(params[:user])
  #  respond_to do |format|
  #    if @user.save
  #      self.current_user = @user
  #      #redirect_back_or_default('/')
  #      flash[:notice] = 'User was successfully created.'
  #      format.html { redirect_to(@user) }
  #      format.xml  { render :xml => @user, :status => :created, :location => @user }
  #    else
  #      format.html { render :action => "signup" }
  #      format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  def new
    @user = User.new
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @user }
    #end
    #render :update do |page|
    #  page << "$('#signup_popup_box_wrapper').show();"
    #  #page.replace_html 'login_popup_box'
    #end
  end

  def create
    cookies.delete :auth_token
    reset_session
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Thank you for signing up.  You should receive an email shortly.'
        format.html { ajax_redirect_back_or_default(root_path) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { 
          render :update do |page|
            page.replace_html 'main', :partial => 'new'
          end 
        }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |format|
      format.html { redirect_to(users_path) }
      format.xml  { head :ok }
    end
  end
  
  def verify
    if @user.is_verified?
      flash[:notice] = "This user account has already been verified.  Please log in."
      redirect_to login_path
    else
      @user.verified = true
      @user.save(false)
      reset_session
      self.current_user = @user
      flash[:notice] = "Thanks for joining. You're logged in."
      redirect_to home_path
    end
  end
  
  def upgrade
    @user = User.find(params[:id])
    @user.mod = User.mod_total
    @user.save
    @user.reload
    flash[:notice] = "User '#{@user.login}' has been upgraded."
    redirect_to users_path
  end
  
  #doesn't work yet
  def reset_password
		@account = current_user
		return if params[:account].blank?
		if @account.password_hash == Digest::SHA1.hexdigest(params[:account][:old_password])
			if @account.update_password(params[:account])
				flash[:notice] = "Your password has been changed"
			end
		else
			@account.errors.add('old_password', 'is incorrect.') 
		end
	end
	
  def change_password
    @user = User.find(params[:id].to_i)
    return if params[:user].blank?
    if @user.update_password(params[:user])
      flash[:notice] = "Your password has been changed."
      redirect_to user_path(@user)
    end
  end
  
  protected
  
    def check_verification_token
      unless(params[:id] && params[:token] && (@user = User.find(params[:id])) && @user && (@user.verification_hash == params[:token]))
        flash[:notice] = "Verification link is invalid."
        logger.warn "Failed verification link or token: '#{params[:id]}' from #{request.remote_ip} at #{Time.now.utc}"
        redirect_to root_path
      end
    end
    
    def authorized?
      return false unless current_user
      return true if params[:id] && (current_user.id == params[:id].to_i)
      redirect_to( user_path(current_user)) && flash[:error] = "You are not allowed to view that page." unless can_modify?($MOD_USERS)
      return true
    end

end
