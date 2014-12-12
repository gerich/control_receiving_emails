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
    hash = email.attributes
    if (email.errors.empty?) then
      render :json =>{email: hash}
    else
      render :json =>{email: hash, errors: email.errors}
    end
  end
end
