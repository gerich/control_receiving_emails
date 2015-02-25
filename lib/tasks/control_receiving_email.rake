desc <<-END_DESC
  Import issues from email
  rake redmine:import_issues_from_email
END_DESC

require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

def import_issues_from_emails
  Dir.chdir Rails.root
  IssuesImportEmail.includes(:tracker, :issues_import_server, issue_category: [:project, :assigned_to])
    .active.has_project.has_user.all.each do |email|
    
    args = {
      :host                => email.issues_import_server.address,
      :port                => email.issues_import_server.port,
      :username            => email.login,
      :password            => email.password,
      :project             => email.issue_category.project.identifier,
      :tracker             => email.tracker.name,
      :category            => email.issue_category.name,
      :unknown_user        => 'accept',
      :no_permission_check => 1,
    }
    args[:ssl] = 1 if email.issues_import_server.ssl

    dump = "bundle exec rake redmine:email:receive_pop3" 
    args.each do |hash, value|
      dump << " #{hash}='#{value}'"
    end

    system(dump)
  end
end

def import_issues
  Dir.chdir Rails.root
  IssuesImportEmail.includes(:tracker, :issues_import_server, issue_category: [:project, :assigned_to])
    .active.has_project.has_user.all.each do |email|
    
    args = {
      :host                => email.issues_import_server.address,
      :port                => email.issues_import_server.port,
      :username            => email.login,
      :password            => email.password,
      :project             => email.issue_category.project.identifier,
      :tracker             => email.tracker.name,
      :category            => email.issue_category.name,
      :unknown_user        => 'accept',
      :no_permission_check => 1,
    }
    args[:ssl] = 1 if email.issues_import_server.ssl

    Rake::Task["redmine:email:receive_pop3"].execute(Rake::TaskArguments.new(args.keys, args.values))

  end
end

namespace :redmine do
  task :import_issues_from_email => :environment do
    import_issues
  end
end
