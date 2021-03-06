class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :is_admin, except: [:show]
  
  # GET /categories
  # GET /categories.json
  def index
    # @categories = Categorie.all
    @categories = Categorie.paginate(page: params[:page], per_page: 5)

  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @idCategorie = Categorie.where(slug: params[:id])
    @articles = Article.where(categorie_id: @idCategorie).paginate(page: params[:page], per_page: 5)
  end

  # GET /categories/new
  def new
    @category = Categorie.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Categorie.new(category_params)
    # @article.created_by = current_user
    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, notice: t('category_flash_save') }
        format.json { render :show, status: :created, location: categories_path }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      @article.created_by = current_user
      if @category.update(category_params)
        format.html { redirect_to categories_path, notice: t('category_flash_save') }
        format.json { render :show, status: :ok, location: categories_path }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: t('category_flash_destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Categorie.find(params[:id])
    end
    
    def is_admin
      if !user_signed_in?
         render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
      else
        if !current_user.has_role?(:admin, current_user)
           render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:categorie).permit(:nom)
    end
end
