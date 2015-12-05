# encoding: utf-8

class Upload < ActiveRecord::Base
  belongs_to :discussion
  has_attached_file :image,
                    :styles => { :medium => "300x150#",:thumb => "100x100>" },
                    :path => "public/system/:class/:id/:style/:filename",
                    :url => "/system/:class/:id/:style/:basename.:extension"

  validates_attachment  :image,
                        :presence => true,
                        #:content_type => { :content_type => /^image.*/ },
                        :size => { :less_than => 30.megabyte }
  do_not_validate_attachment_file_type :image
  before_post_process :image_file?

  def image_file?
    #debugger
    if !(self.image_content_type =~ /^image.*/).nil?
      return true
    else
      return false
    end
  end

end
