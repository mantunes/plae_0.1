class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'The object you tried to access does not exist'
    redirect_to organizations_path
  end

  def index
    @organizations = Organization.all
  end

  def show
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      flash[:notice] = "You've successfully created a new organization"
      redirect_to @organization
    else
      flash[:notice] = "The organization couldn't be saved"
      render('new')
    end
  end

  def edit
  end

  def update
    if @organization.update_attributes(organization_params)
      flash[:notice] = 'Organization updated successfully'
      redirect_to @organization
    else
      flash[:notice] = "Couldn't update organization details"
      render('edit')
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_path
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description, :website)
  end

  def set_organization
    @organization = Organization.find(params[:id])
  end
end
