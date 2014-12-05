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
    server = IssuesImportServer.find(params[:id])
    server.destroy
    render_server(server)
  end

  private 

  def render_server(server)
    if server.errors.empty? then
      render :json => {server: server.attributes}
    else
      render :json => {server: server.attributes, errors: server.errors}
    end  
  end
end
