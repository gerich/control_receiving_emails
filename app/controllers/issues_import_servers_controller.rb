class IssuesImportServersController < ApplicationController
  unloadable

  def create
    server = IssuesImportServer.create(params[:server])
    render_server(server)
  end

  def update
    server = IssuesImportServer.find(params[:id])
    server.update_attributes(params[:server])
    render_server(server)
  end

  def destroy
    server = IssuesImportServer.includes(:issues_import_email).find(params[:id])
    email_ids = server.issues_import_email.map {|email| email.id}
    server.destroy
    render_server(server, email_ids)
  end

  private 

  def render_server(server, emails = [])
    if server.errors.empty? then
      render :json => {server: server.attributes, emails: emails}
    else
      render :json => {server: server.attributes, errors: server.errors}
    end  
  end
end
