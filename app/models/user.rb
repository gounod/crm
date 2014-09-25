# encoding: utf-8

class User < ActiveRecord::Base
  # User Roles
  rolify

  # Include default devise modules. :omniauthable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable, :confirmable, :token_authenticatable
  before_save :reset_authentication_token
  has_many :discussions
  has_many :articles


  def short_name
    if self.last_name.present?
      [self.first_name.to_s[0],self.last_name].join(". ")
    else
      self.email
    end
  end
end
