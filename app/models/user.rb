class User < ActiveRecord::Base
  has_many :entries
  has_many :comments
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :role
  validates :name, presence: true

  before_save :default_values
  def default_values
    self.role ||= "editor"
  end

  def admin?
    role == "admin"
  end

  def editor?
    role == "editor"
  end
end
