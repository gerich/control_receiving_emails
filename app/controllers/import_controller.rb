class ImportController < ApplicationController
  unloadable

  def show
    @servers = transform(IssuesImportServer.all)
    @emails = transform(IssuesImportEmail.includes(issue_category: [:project, :assigned_to]).all)
    @projects = transform_projects(Project.includes(:trackers, :members => [:principal]).all)
  end

  private 
  
  def transform_projects(projects)
    transformed_projects = []
    projects.each do |project|
      hash = { :id => project.id, :name => project.name, :trackers => [], :users => [] }
      
      project.trackers.each do |tracker|
        hash[:trackers].push({ :id => tracker.id, :name => tracker.name })
      end

      project.members.each do |member|
        hash[:users].push({ :id => member.user.id, :name => member.user.name })
      end

      transformed_projects.push(hash)
    end

    return transformed_projects
  end

  def transform(data)
    transformed = []

    data.each do |el|
      transformed.push(el.attributes)
    end

    return transformed
  end
end
