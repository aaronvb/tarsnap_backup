require 'time'

class Tarsnap
  def initialize(options)
    @to_backup = "#{options[:to_backup]}" if options[:to_backup]
    @prune = options[:prune_backups] if options[:prune_backups]
    @name = options[:backup_name] if options[:backup_name]
    @tarsnap = options[:where_tarsnap] if options[:where_tarsnap]
    if options[:log_path]
      @log = "#{options[:log_path]}/#{@name}.log"
    else
      @log = "#{options[:log_path]}/default.log"
    end
    @logger = Logger.new(@log)
  end
    
  def backup
    # output start to logger
    @logger.write("Starting '#{@name}' tarsnap backup")
    
    # generate backup name: name.YYYY-MM-DD.HH-MM-SS
    # example: projects.2014-11-25.12-07-54
    backup_name = Time.now.strftime("#{@name}.%F.%H-%M-%S")
    @logger.write("Tarsnap backup name: #{backup_name}")
    
    # start backup
    cmd = `#{@tarsnap} -c -f #{backup_name} #{@to_backup}`
    
    # gather stats
    cmd = `#{@tarsnap} -f #{backup_name} --print-stats`
    
    # output stats and end to logger
    @logger.write("Stats: \n#{cmd}\n")
    @logger.write("End '#{@name}' tarsnap backup\n\n")
    
    prune if @prune
  end
  
  def prune
    @logger.write("Starting '#{@name}' tarsnap prune")
    
    # gather archives
    output = `#{@tarsnap} --list-archives`
    
    # convert output to array
    archives = output.split("\n")
    archives_to_prune = []
    archives.each do |a|
      # split tarsnap archive name by periods
      split_archive = a.split(".")
      
      # split_archive[0] is name
      # split_archive[1] is date YYYY-MM-DD
      # split-archive[2] is time HH-MM-SS (24-hour)
      
      time_of_archive = Time.parse("#{split_archive[1]} #{split_archive[2].gsub('-', ':')}")
      time_to_compare = Time.now - @prune
      
      if time_of_archive < time_to_compare
        # archive is past the prune date
        archives_to_prune.push a
      end
    end
    
    archives_to_prune.each do |a|
      @logger.write("Destroying: #{a}")
      cmd = `#{@tarsnap} -d -f #{a}`
      @logger.write("Finished Destroying #{a}")
    end
    
    @logger.write("End '#{@name}' tarsnap prune\n\n")
  end
end

class Logger
  def initialize(file)
    @log = file
  end
  
  def write(data)
    log = File.open(@log, "a")
    log.puts "[#{Time.now.to_s}] #{data}"
    log.close
  end
end