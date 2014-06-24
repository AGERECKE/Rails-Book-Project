class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :email, :type => String
  field :login, :type => String
  
  
    field :encrypted_password, :type => String

    ## Password Expirable
    field :password_changed_at, :type => Time

    ## Recoverable
    field :reset_password_token,   :type => String
    field :reset_password_sent_at, :type => Time

    ## Rememberable
    field :remember_created_at, :type => Time

    ## Trackable
    field :sign_in_count,      :type => Integer, :default => 0
    field :current_sign_in_at, :type => Time
    field :last_sign_in_at,    :type => Time
    field :current_sign_in_ip, :type => String
    field :last_sign_in_ip,    :type => String

    ## Encryptable
    field :password_salt, :type => String

    ## Confirmable
    field :confirmation_token,   :type => String
    field :confirmed_at,         :type => Time
    field :confirmation_sent_at, :type => Time
    field :unconfirmed_email,    :type => String # Only if using reconfirmable
    field :deactivated,          :type => Boolean, :default => false
    

    ## Lockable
    field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
    field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
    field :locked_at,       :type => Time

    ## Token authenticatable
    field :authentication_token, :type => String

    ## Invitable
    field :invitation_token, :type => String
    field :invitation_sent_at, :type => Time
    field :invitation_accepted_at, :type => Time
    field :invitation_limit, :type => Integer, :default => 0
    field :invited_by_id, :type => String
    field :invited_by_type, :type => String
  
  
  has_many :bookmarks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login, :url
  # attr_accessible :title, :body
  
  
  
  def saved_bookmark?(bookmark)
    if bookmark.present? && bookmark[:url].present?
      link = Link.where(:url => bookmark[:url]).first
      link.present? && bookmarks.where(:link_id => link.id).first.present?
    end
  end

  
  def update_with_password(params={})
    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
      if params[:password_confirmation].blank?
      end
      update_attributes(params)
    end
  end
  validates :login,
            :presence => true,
            :uniqueness => true,
            :length => { :minimum => 4, :maximum => 20 }
            
  protected
  
  def self.find_for_database_authentication(conditions)
    login = conditions.delete(:login)
    self.any_of({ :login => login }, { :email => login }).first
  end
end
