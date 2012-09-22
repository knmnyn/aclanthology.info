namespace :anthology do

  desc "Resets the database (and solr indices if local)"
  task :reset => :environment do
   # puts "Stopping Solr..."
   # Rake::Task['anthology:solr:stop_jetty'].invoke
    puts "Dropping Database..."
    Rake::Task['db:drop'].invoke
    puts "Migrating Database..."
    Rake::Task['db:migrate'].invoke
    puts "Dropping Solr indices"
    Rake::Task['anthology:solr:drop'].invoke
    puts "Clearing logs..."
    Rake::Task['log:clear'].invoke
    puts "Clearing Rails temporary files..."
    Rake::Task['tmp:clear'].invoke
    puts "Restarting Httpd..."
    `sudo service httpd graceful`
    puts "Restarting Solr...please wait"
    Rake::Task['anthology:solr:start_jetty'].invoke
  end

  namespace :solr do
    desc "Drop Solr Indices"
    task :drop => :environment do
      puts "/bin/rm -Rf #{Rails.root}/jetty/solr/data"
      `/bin/rm -Rf #{Rails.root}/jetty/solr/data`
    end

    desc "Start Jetty"
    task :start_jetty => :environment do
      puts "cd #{Rails.root}/jetty; nohup java -jar start.jar > jetty.log 2>&1 &"
      `cd #{Rails.root}/jetty; nohup java -jar start.jar > jetty.log 2>&1 &`
    end
  end # namespace :solr

end # namespace :anthology

