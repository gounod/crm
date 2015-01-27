# encoding: utf-8

class User < ActiveRecord::Base
  # User Roles
  rolify

  # Include default devise modules. :omniauthable, :registerable, :confirmable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable, :token_authenticatable
  before_save :reset_authentication_token
  has_many :discussions
  has_many :articles

  has_many :discussion_users
  has_many :favorites, :through => :discussion_users, :source => :discussion

  attr_accessor :otp

  acts_as_voter
  before_save :set_yubikey

  def short_name
    if self.privacy
      if self.last_name.present?
        [self.first_name.to_s[0],self.last_name].join(". ")
      else
        self.email
      end
    else
      "WEG-Mitglied"
    end
  end

  def set_yubikey
    if self.otp.present?
      otp_yubikey = Yubikey::OTP::Verify.new(:api_id => YUBIKEYCLIENTID, :api_key => YUBIKEYSECRETKEY, :otp => self.otp)
      if otp_yubikey.valid?
        self.yubikey = self.otp[0..11]
      end
    end
  end

end
