class Run < ActiveRecord::Base
  has_many :entries
  belongs_to :data_set
  belongs_to :app
  
  def to_ary
    [self]
  end
  
end
