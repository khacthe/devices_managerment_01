class Supports::BaseSupport

  def get_categories
    Category.all
  end

  def get_workspaces
    Workspace.all
  end

end
