require 'digest/sha1'
class User < ActiveRecord::Base
  USER_ACCOUNT_VERIFICATION_TOKEN = "3f9c2bcc50d816dee16552ac5c39cde16908074a"
  
  before_create :normalize_fields, :validate
  validates_presence_of :email, :login#, :phone, :first_name, :last_name
  validates_uniqueness_of :login, :on => :create, :message => "already exists and must be unique."
  validates_uniqueness_of :email, :on => :create, :message => "already exists and must be unique."
  validates_confirmation_of :password  
  
  attr_accessible :login, :phone, :email, :password, :password_confirmation
  attr_accessor :password   # Virtual attribute for the unencrypted password
  
  #verification for validation of user email address: send notifications, etc
  after_create :send_verification
  
  def normalize(field="", title_case = true)
    return "" if field.blank?
    return field.downcase.titlecase if title_case
    field.downcase
  end
  
  def normalize_fields
    self.first_name = normalize(self.first_name)
    self.last_name = normalize(self.last_name)
    self.email = normalize(self.email, false)
  end
  
  def display_name(reversed=false)
    return "#{self.last_name}, #{self.first_name}"if reversed
    "#{self.first_name} #{self.last_name.first}"
  end
  
  def is_verified?
    verified
  end
  
      # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    (u && u.authenticated?(password)) ? u : nil
  end
  
  # Checks password against stored db password
  def authenticated?(password)
    password_hash == User.encrypted_password(password,salt)
  end

  # Mutator for password, Admin only
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.password_hash = User.encrypted_password(self.password, self.salt)
  end
  
  def is_admin? 
    mod == User.mod_total
  end
  
  def self.mod_total
    $MODS.sum
  end
  
  # expects an user object params hash
  def update_password(user = {})
    self.attributes = user
    if self.password.blank? or self.password_confirmation.blank?
      self.errors.add("password", "and confirmation password are required")
      return false
    elsif self.password.size < 5
      self.errors.add("password", "must be at least 5 characters")
      return false
    elsif self.password != self.password_confirmation
      self.errors.add("password", "does not match the password confirmation")
      return false
    else
      self.password_hash = Digest::SHA1.hexdigest(self.password)
      self.save(false)
    end
  end
  
  def remember_token?
    remember_token_expires_at && (Time.now.utc < remember_token_expires_at )
  end
  
  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = Digest::SHA1.hexdigest("#{email}--#{remember_token_expires_at}")
    save(false)
  end
  
  def refresh_token
    remember_me if remember_token?
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def verification_hash
    Digest::SHA1.hexdigest(self.email + User::USER_ACCOUNT_VERIFICATION_TOKEN)
  end
  
  def verification_url
    "users/verify/#{self.id}?token=#{self.verification_hash}"
  end

  protected
  
    def validate
      errors.add_to_base("Password cannot be blank.") if password_hash.blank?
    	_phone = self.phone.gsub(/[^\d]/,"")
    	debugger
    	unless _phone.length == 10
    	  self.errors.add_to_base("Phone must contain 10 digits")
      else
        self.phone = "#{_phone[0..2]}-#{_phone[3..5]}-#{_phone[6..9]}"
    	end
    end
  
    def self.encrypted_password(password, salt)
      Digest::SHA1.hexdigest(password + salt + REST_AUTH_SITE_KEY)
    end

    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
    
    def send_verification
      Notifier.deliver_account_verification(self)
    end
    
end


