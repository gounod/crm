# encoding: utf-8

class Discussion < ActiveRecord::Base
  resourcify #added bei User Roles
  belongs_to :user
  has_many :articles, :dependent => :delete_all
  acts_as_taggable
  acts_as_votable

  after_create :send_notifications

  has_many :discussion_users
  has_many :followers, :through => :discussion_users, :source => :user


  def send_notifications
    User.where(:notify_me_on_discussion_create => true).each do |user|
      Mailer.new_discussion(user,self).deliver
    end
  end

end
