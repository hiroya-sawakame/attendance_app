class AttendancesController < ApplicationController
  
  before_action :set_user, only: [:edit_one_month, :update_one_month, :overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month, :overtime]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :overtime]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end

  def overtime
    @day = Attendance.find_by(id: params[:format])
  end

  def create_overtime
    @attendance = Attendance.find_by(id: params[:format])
    @attendance.update_attributes(overtime: params[:overtime], content: params[:content], day_status: params[:day_status])
    flash[:info] = '残業申請しました。'
    redirect_back(fallback_location: root_path)
  end

  def approval_overtime
    if params[:id] == "2"
      @users = User.joins(:attendances).where(attendances: { day_status: 0}).distinct
      @day_status_all = Attendance.where(day_status: 0)
      # binding.pry
    elsif params[:id] == "3"
      @users = User.joins(:attendances).where(attendances: { day_status: 1}).distinct
      @day_status_all = Attendance.where(day_status: 1)
    end
  end

  def approval_overtime_done
    ActiveRecord::Base.transaction do # トランザクションを開始します。

      attendances_day_status_params.each do |id, item|
        p '--test--'
        p params[:attendances]
        p '--test_2--'
        p params[:attendances][:id]
        p '--test_3--'
        # binding.pry
        if params[:checkbox] == true
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
      end
    end
    flash[:info] = '申請内容を確認しました。'
    redirect_back(fallback_location: root_path)

    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました、下記の３点をご確認ください。<br>" + "①　出勤・退勤時間は両方入力されているか？<br>" + "②　出勤より退勤時間の方が早い時間ではないか？<br>" + "③　備考欄は50文字以内になっているか？"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  private
  
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end

  def attendances_day_status_params
    params.permit(attendances: [:day_status, :checkbox])[:attendances]
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end
  end
end