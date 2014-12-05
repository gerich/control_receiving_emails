class ImportController < ApplicationController
  unloadable

  def show
    @servers = transform(IssuesImportServer.all)
    @emails = transform(IssuesImportEmail.all)
    @projects = transform_projects(Project.includes(:trackers, issue_categories: [:assigned_to]).all)
  end

  def save
  end

  private 
  
  def transform_projects(projects)
    transformed_projects = []
    projects.each do |project|
      hash = { :id => project.id, :name => project.name, :trackers => [], :categories => [] }
      
      project.trackers.each do |tracker|
        hash[:trackers].push({ :id => tracker.id, :name => tracker.name })
      end

      project.issue_categories.each do |category|
        hash[:categories].push({ :id => category.id, :name => category.name, :assigend_to => category.assigned_to.name })
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
