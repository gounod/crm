# encoding: utf-8

class Article < ActiveRecord::Base
  resourcify #added bei User Roles
  belongs_to :discussion
  belongs_to :user

  after_create :set_discussion_date
  after_create :send_notifications
  acts_as_votable

  def set_discussion_date
    self.discussion.touch
  end

  def send_notifications
    send_mail_to_users = []
    #mail an Moderator, wenn er das will
    if self.try(:discussion).try(:user).try(:notify_me_on_new_articles_i_moderate)
      unless send_mail_to_users.include?(self.discussion.user)
        Mailer.new_article(self.discussion.user,self).deliver
        send_mail_to_users << self.discussion.user
      end
    end

    self.discussion.followers.where(:notify_me_on_new_articles_i_follow => true).each do |user|
      next unless discussion.readable_by(user)
      unless send_mail_to_users.include?(user)
        Mailer.new_article(user,self).deliver
        send_mail_to_users << user
      end
    end
  end

end
