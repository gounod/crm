# encoding: utf-8

class Discussion < ActiveRecord::Base
  resourcify #added bei User Roles
  belongs_to :user
  has_many :articles, :dependent => :delete_all
  acts_as_taggable
  acts_as_votable
  has_many :uploads

  after_create :add_auto_followers
  after_create :send_notifications

  has_many :discussion_users
  has_many :followers, :through => :discussion_users, :source => :user

  def unread_articles(user)
    total_articles_count = articles.count
    read_articles = UserArticle.where(user_id: user.id, article_id: article_ids).count
    total_articles_count - read_articles
  end

  def selected_users
    selected_user_list.to_s.split(",").map(&:strip)
  end

  def readable_by(current_user)
    return true if current_user.has_role?(:admin)
    return true if public
    return true if user.email == current_user.email
    return true if !public && selected_users.any? && selected_users.include?(current_user.email)
    return false
  end

  def add_auto_followers
    if public
      User.where(:auto_follow => true).each do |user|
        followers << user unless followers.include?(user)
      end
    end
  end

  def send_notifications
    User.where(:notify_me_on_discussion_create => true).each do |user|
      next unless readable_by(user)
      Mailer.new_discussion(user,self).deliver
    end
  end

end
