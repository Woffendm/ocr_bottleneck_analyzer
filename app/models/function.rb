class Function < ActiveRecord::Base
  has_many :entries
  
  def to_ary
    [self]
  end
end
