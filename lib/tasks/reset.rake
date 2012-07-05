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
   # puts "Restarting Apache2..."
   # `sudo service apache2 graceful`
   # puts "Restarting Solr...please wait"
   # Rake::Task['anthology:solr:start_jetty'].invoke
  end


  namespace :solr do
    desc "Drop Solr Indices"
    task :drop => :environment do
      `/bin/rm -Rf jetty/solr/data`
    end

  end # namespace :solr

  task :test do
    x=`echo ls`
    bib=`BiblioScript/biblio_script.sh -q BiblioScript/input_sample_prav.txt BiblioScript/output-dir/`
    print bib
  end

end # namespace :anthology

