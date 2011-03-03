# Additions to the DB rake tasks.
namespace :db do
  # A task to completely rebuild the DB.
  task :rebuild do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
  end
end
