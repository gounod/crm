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

  def process_email_callback(params)

    # Returned events and options are described at https://eu.mailjet.com/docs/event_tracking
    case params['event']
    when 'open'
      article_id = params["CustomID"]
      article = Article.find_by_id(article_id) if article_id.present?

      ua = UserArticle.where(user_id: self.id, article_id: article.id).first_or_create if article.present?
      # Mailjet's invisible pixel was downloaded: user allowed for images to be seen
    when 'click'
      # article_id = params["CustomID"]
      # article = Article.find_by_id(article_id) if article_id.present?

      # ua = UserArticle.where(user_id: self.id, article_id: article.id).first_or_create if article.present?
      # ua.clicked! if ua.present?
      # a link (tracked by Mailjet) was clicked
    when 'bounce'
      # is user's email valid? Recipient not found
    when 'spam'
      # gateway or user flagged you
    when 'blocked'
      # gateway or user blocked you
    when 'typofix'
      # email routed from params['original_address'] to params['new_address']
    else
      Rails.logger.fatal "[Mailjet] Unknown event #{params['event']} for User #{self.inspect} -- DUMP #{params.inspect}"
    end
  end

end
