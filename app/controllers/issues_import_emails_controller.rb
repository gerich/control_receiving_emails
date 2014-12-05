class IssuesImportEmailsController < ApplicationController
  unloadable

  def create
    email = IssuesImportEmail.create(params[:email])
    render_email(email)
  end

  def update
    email = IssuesImportEmail.find(params[:id])
    email.update_attributes(params[:email])
    render_email(email)
  end

  def destroy
    email = IssuesImportEmail.find(params[:id])
    email.destroy
    render_email(email)
  end

  private 

  def render_email(email)
    if (email.errors.empty?) then
      render :json =>{email: email.attributes}
    else
      render :json =>{email: email.attributes, errors: email.errors}
    end
  end
end
