desc <<-END_DESC
  Import issues from email
  rake redmine:import_issues_from_email
END_DESC

require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

def import_issues_from_emails
  Dir.chdir Rails.root
  IssuesImportEmail.includes(:project, :tracker, :issues_import_server).where(:active => true).all.each do |email|
    args = {
      :host => email.issues_import_server.address,
      :port => email.issues_import_server.port,
      :username => email.login,
      :password => email.password,
      :project => email.project.identifier,
      :tracker => email.tracker.name,
      :unknown_user => 'accept',
      :no_permission_check => 1,
    }
    args[:ssl] = 1 if email.issues_import_server.ssl
    args[:category] = email.issue_category.name unless email.issue_category.nil?

    dump = "bundle exec rake redmine:email:receive_pop3" 
    args.each do |hash, value|
      dump << " #{hash}=#{value}"
    end

    #Rake::Task['redmine:email:receive_pop3'].execute(Rake::TaskArguments.new(args.keys, args.values))
    system(dump)
  end
end

namespace :redmine do
  task :import_issues_from_email => :environment do
    import_issues_from_emails
  end
end
