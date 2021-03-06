class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :confirm]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show, :confirm]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
    @dates = @user.attendances.find_by!(worked_on: @first_day)
    if @user.id == 2
      @month_confirm_status = Attendance.where(month_confirm_status: 0).distinct.count
      @day_status = Attendance.where(day_status: 0).count
      @month_status = Attendance.where(month_status: 0).count
    elsif @user.id == 3
      @month_confirm_status = Attendance.where(month_confirm_status: 1).distinct.count
      @day_status = Attendance.where(day_status: 1).count
      @month_status = Attendance.where(month_status: 1).count
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def export_month
    @user = User.find(params[:id])
    @first_day = Date.parse(params[:date]) ? Date.parse(params[:date]) : Date.today.beginning_of_month
    @last_day = @first_day.end_of_month
    @dates = @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).order('worked_on')
    respond_to do |format|
      format.csv do
        send_data render_to_string, filename: "#{l(@first_day, format: :middle)}勤怠.csv", type: :csv
      end
    end
  end

  def changed_log
    @first_day = params[:date].nil? ?
                   Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    @user = User.find(params[:id])
    @dates = @user.attendances.where('worked_on >= ? and worked_on <= ?', @first_day, @last_day).where.not(month_status: nil)
  end

  def confirm
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end
  
  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_start_time)
  end
end
