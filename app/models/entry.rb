class Entry < ActiveRecord::Base
  belongs_to :function
  belongs_to :run
  def self_percent
    self.run_time_no_calls.to_f * 100 / self.run.run_time
  end
  
  def adjusted_self_percent total_time
    self.run_time_no_calls.to_f * 100 / total_time
  end
  
  def total_percent
    self.run_time.to_f * 100 / self.run.run_time
  end
  
  def adjusted_total_percent total_time
    self.run_time.to_f * 100 / total_time
  end
end
