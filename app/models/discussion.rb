# encoding: utf-8

class Discussion < ActiveRecord::Base
  resourcify #added bei User Roles
  belongs_to :user
  has_many :articles, :dependent => :delete_all
  acts_as_taggable

end
