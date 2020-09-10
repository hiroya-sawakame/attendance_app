class BasesController < ApplicationController
  def new
    @base = Base.new
    @bases = Base.paginate(page: params[:page])
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
      redirect_to new_basis_path
    else
      render 'new'
    end
  end

  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] ="更新しました。"
      redirect_to new_basis_path
    else
      render 'new'
    end
  end

  def destroy
    Base.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to new_basis_path
  end

  private

  def base_params
    params.require(:base).permit(:number, :place, :type, :image)
  end
end