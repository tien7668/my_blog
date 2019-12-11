class Admin::CategoriesController < Admin::BaseController
  def index
    @records = Category.all
    respond_to do |format|
      format.html
      format.js { render template: 'admin/meta/index.js.erb' }
    end
  end

  def new
    respond_to do |format|
      format.js { render template: 'admin/meta/new_model' }
    end
  end

  def create
    if resource.update(model_params)
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
    respond_to do |format|
      format.js {render template: 'admin/meta/new_model'}
    end
  end

  def update
    if resource.update(model_params)
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def destroy
    resource.destroy
    redirect_to admin_categories_path
  end

  def resource
    super("Category")
  end

  def model_params
    params.require(:category).permit(:name, :name_en, :name_jp)
  end
end
