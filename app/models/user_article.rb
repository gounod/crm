class UserArticle < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  enum state: { opened: 0, clicked: 1 }
end
