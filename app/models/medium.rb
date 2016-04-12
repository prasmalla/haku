class Medium < ActiveRecord::Base
  validates :title, :uniqueness => {:scope => :url}
end
