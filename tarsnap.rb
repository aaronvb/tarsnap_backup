require 'time'
require 'pathname'

class Tarsnap
  def initialize(options)
    @to_backup          = options[:to_backup] 
    @name_of_backup     = options[:backup_name]

    # config
    @number_to_keep     = options[:number_to_keep]      || 5
    @tarsnap            = options[:where_tarsnap]       || "/usr/local/bin/tarsnap"
    @options            = options[:options]             || ""
    @log_dir            = options[:log_path]            || "/tmp"
    @log_filename       = options[:log_filename]        || "tarsnap_backup.log"

    logfile = Pathname.new(@log_dir).join(@log_filename)
    @logger = Logger.new(logfile)
  end
    
  def backup
    # output start to logger
    @logger.write("Starting '#{@name_of_backup}' tarsnap backup")
    archive = find_last_archive_for(@name_of_backup)
    arc_date = archive.split(".")[1]

    if (Time.now - Time.parse(arc_date)) < 0
      @logger.write("Error: Found archive with date in the future: #{@name_of_backup}")
      # send email
    end
    
    # check if last backup is from today
    if !Time.now.strftime("%Y-%m-%d").eql?(arc_date)
      do_backup
    else
      @logger.write("Found backup from today for: #{@name_of_backup}. Skipping it.")
    end
    @logger.write("Finished '#{@name_of_backup}' tarsnap backup")
  end

  def find_last_archive_for(name)
    existing_archives = gather_archives 
    matching_archives = existing_archives.select {|x| x =~ /#{name}/}
    matching_archives.sort.last
  end
    
  def do_backup
    # generate backup name: name.YYYY-MM-DD.HH-MM-SS
    # example: projects.2014-11-25.12-07-54
    backup_name = Time.now.strftime("#{@name_of_backup}.%F.%H-%M-%S")
    @logger.write("Tarsnap backup name: #{backup_name}")
    
    # start backup
    cmd = `#{@tarsnap} -c -f #{backup_name} #{@to_backup} #{@options}`
    
    # gather stats
    stats(backup_name)
   
    prune
  end

  def stats(name)
   cmd = `#{@tarsnap} -f #{name} --print-stats`
    
    # output stats and end to logger
    @logger.write("Stats: \n#{cmd}\n")
  end

  def gather_archives
    output = `#{@tarsnap} --list-archives`
    
    # convert output to array
    archives = output.split("\n")
    # remove (previously added) archives from list that don't match the format
    # archivename.yyyy-mm-dd.hh-mm-ss
    archives.keep_if { |e| e =~ /^.+\.\d{4}-\d{2}-\d{2}.\d{2}-\d{2}-\d{2}$/ }
  end
  
  def prune
    @logger.write("Starting '#{@name_of_backup}' tarsnap prune")
    archives = gather_archives 
    # find out how many of each archive exists
    # keep at least @min_number_to_keep
    # sort by date and delete the oldest

    archive_names = archives.collect {|x| x.split(".")[0]}
    matching_archives = archives.select {|x| x =~ /#{@name_of_backup}/}
    @logger.write("Found #{matching_archives.count} archives for #{@name_of_backup}")
    if matching_archives.count > @number_to_keep
      matching_archives = matching_archives.sort
      amount_to_delete = matching_archives.count - @number_to_keep
      old_archives = matching_archives.slice(0, amount_to_delete)
      @logger.write("Going to delete #{amount_to_delete} archives: #{old_archives}")
      delete_archives(old_archives)
    end
    @logger.write("End '#{@name_of_backup}' tarsnap prune\n\n")
  end

  def delete_archives(archives)  
    archives.each do |a|
      @logger.write("Destroying: #{a}")
      cmd = `#{@tarsnap} -d -f #{a}`
      @logger.write("Finished Destroying #{a}")
    end
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
