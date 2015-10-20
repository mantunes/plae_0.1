class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
    @memberships = current_user.memberships
  end
  def show
  end
  def new
  end
  def create
  end
  def edit
  end
  def update
  end
  def destroy
  end
end
