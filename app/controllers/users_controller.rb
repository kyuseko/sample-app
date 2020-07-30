class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]   # paramsハッシュからユーザーを取得します。ログインしたユーザー
  before_action :logged_in_user, only: [:index, :show, :edit, :update]  # ユーザーにログインを要求する
  before_action :correct_user, only: [:edit, :update]  # ユーザー自身のみが情報を編集・更新できる
  
  
  def index
    @users = User.paginate(page: params[:page])   # ページネーションを判定できるオブジェクトに置き換える
  end
  
  def show
    # @user = User.find(params[:id]) # IDがわかっているデータをあるモデルから取得したい時
  end                                # showアクションであるIDのデータを取得

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user  # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end 
  
  def update   # 編集更新
    if @user.update_attributes(user_params)
      redirect_to @user   # 更新に成功した場合の処理を記述します。
    else
      render :edit      
    end
  end
   
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
    
    
     # beforeフィルター
    
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?  # unlessは条件式がfalseの場合のみ
        store_location   # アクセスしたページを格納しておく
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      redirect_to(root_url) unless current_user?(@user)
    end
end
