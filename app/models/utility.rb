# Higher growth = worse bottleneck
# If bottleneck detection is too sensitive or not sensitive enough, you can adjust the function 
#   growth margin of error as an optional second argument


class Utility
    
  def clear_data
    `rake db:drop && rake db:create && rake db:migrate`
  end  
  
  
  def parse_files
    `scp -r mwoffendin@xstack.exascale-tech.com:~/profile_output/* ../profile_output`
    Dir.entries("../profile_output")[2..-1].each do |file|
      parse_file(file)
    end
  end 
   
  
  def parse_file(file)
    f = File.open("../profile_output/#{file}")
    read = false
    skip = 4
    total_time = 0
    data = []
    
    f.each_line do |line|
      # Find start of data
      if line.index("#### Overall ###")
        read = true
      end      
      
      # Find end of data
      if read && line.index("--- Call-graph profile ---")
        f.close
        data = data[0..-3]
        break
      end
      
      # Grab data
      if read
        if skip == 3
          total_time = line.split(':').last.to_f
        end
        
        if skip > 0
          skip -= 1
        else
          data << line.squeeze(" ").split(" ")
        end
      end
    end

    info = file.split('_')
    app = App.find_by_name(info[1])
    app = App.create(name: info[1]) unless app
    dataset = DataSet.where(name: info[3], size: info[2].to_i).first
    dataset = DataSet.create(name: info[3], size: info[2].to_i) unless dataset
    
    run = Run.create(app_id: app.id, data_set_id: dataset.id, thread_count: info.last.split('.').first.to_i, run_time: total_time.to_i)
    
    
    parse_data(data, run.id)
  end
  
  
  
  def parse_data(data, run_id = 1)
    data.each do |entry|
      function = Function.find_by_name(entry[6])
      if function
        function_id = function.id
      else
        function = Function.create(name: entry[6])
        function_id = function.id
      end
      Entry.create(run_time: entry[1].to_f, run_time_no_calls: entry[2].to_f, calls: entry[3].to_i, run_id: run_id, function_id: function_id)
    end
  end
  
  
    
  def parallel_scalability_bottlenecks(app_name, margin_of_error=1)
    bottlenecks = []
    suspected_bottlenecks = []
    app = App.where(name: app_name).pluck(:id)
    runs = Run.where("app_id IN (?)",app).order("thread_count")
    
    # Make sure we have enough data to make any conclusions
    return insufficient_data if runs.blank? 
    threadcounts = {}
    runs.each do |run|
      runs -= run if threadcounts[run.thread_count]
      threadcounts[run.thread_count] = true
    end
    return insufficient_data if runs.length == 1
    
    # Go through each function profiled
    runs.first.entries.each do |entry|
      # Get all entries for that function
      entries = Entry.where("run_id IN (?) AND function_id = ?", runs.map{|r| r.id}, entry.function_id).joins(:run).order('runs.thread_count')
      # If the entry's percent running time increases as the thread count increases, it's a bottleneck
      self_percents = entries.map{|e| e.self_percent}
      self_percents.each do |percent|
        if percent > self_percents[0] + margin_of_error
          bottlenecks << {function: entry.function.name, 
                          growth: percent - self_percents[0] }
          break
        end
      end
      total_percents = entries.map{|e| e.total_percent}
      total_percents.each do |percent|
        if percent > total_percents[0] + margin_of_error
          suspected_bottlenecks << {function: entry.function.name, 
                                    growth: percent - total_percents[0] }
          break
        end
      end
    end
    suspected_bottlenecks -= bottlenecks
    return {bottlenecks: bottlenecks, suspected: suspected_bottlenecks}
  end
  
  
  
  
  def dataset_scalability_bottlenecks(app_name, margin_of_error=1)
    bottlenecks = []
    suspected_bottlenecks = []
    app = App.where(name: app_name).pluck(:id)
    runs = Run.where("app_id IN (?)", app).joins(:data_set).order("data_sets.size")
    
    times = runs.map {|run| run.run_time}
    
    # Make sure we have enough data to make any conclusions
    return insufficient_data if runs.blank? 
    datasets = {}
    runs.each do |run|
      runs -= run if datasets[run.data_set.size]
      datasets[run.data_set.size] = true
    end
    return insufficient_data if runs.length == 1
    
    # Go through each function profiled
    runs.first.entries.each do |entry|
      # We exit nested iterations via an exception
      begin
        # Get all entries for that function
        entries = Entry.where("run_id IN (?) AND function_id = ?", runs.map{|r| r.id},
                  entry.function_id).joins(:run => [:data_set]).order('data_sets.size')
        
        self_percents = []
        total_percents = []
        entries.each_with_index { |e, i| self_percents << e.adjusted_self_percent(times[i]) }
        entries.each_with_index { |e, i| total_percents << e.adjusted_total_percent(times[i]) }
        
        # If the entry's percent running time increases as the thread count increases, 
        # it's a bottleneck
        # When we find a suspected bottleneck, we add it to the list and remove its time from
        # the total run's time. This is because if one function's time increased dramatically
        # then all other functions would appear to have decreased, even if they had increased
        # but to a lesser extent.
        # TODO: re-iterate through all the entries to get anything we missed.
        self_percents.each_with_index do |percent, index|
          # Checks to see if the function is growing.
          if percent > self_percents[0] + margin_of_error
            bottlenecks << {function: entry.function.name, 
                            growth: percent - self_percents[0] }
            times = times.map {|time| time - entries[index].run_time}
            throw Exception.new('done')
          end
        end
        
        total_percents.each_with_index do |percent, index|
          if percent > total_percents[0] + margin_of_error
            suspected_bottlenecks << {function: entry.function.name, 
                                      growth: percent - total_percents[0] }
            times = times.map {|time| time - entries[index].run_time}
            throw Exception.new('done')
          end
        end
      # Exit nested loops here
      rescue 
      end
    end
    
    suspected_bottlenecks -= bottlenecks
    
    unless bottlenecks.blank?
      puts "Self Bottlenecks"
      puts "Function\t\tPercent percentage growth"
      bottlenecks.each do |bottleneck|
        puts "#{bottleneck[:function]}\t\t#{bottleneck[:growth]}"
      end
    end
    
    unless suspected_bottlenecks.blank?
      puts "Children Bottlenecks"
      puts "Function\t\tPercent percentage growth"
      suspected_bottlenecks.each do |suspect|
        puts "#{suspect[:function]}\t\t#{suspect[:growth]}"
      end
    end
    
    return {bottlenecks: bottlenecks, suspected: suspected_bottlenecks}
  end
  
  
  
  private
  def insufficient_data
    puts "Insufficient data. Run more tests"
    {bottlenecks: [], suspected: []}
  end
  
end
