class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]   # paramsハッシュからユーザーを取得します。ログインしたユーザー
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]  # ユーザーにログインを要求する ユーザーがログインしている場合のみ認可する機能
  before_action :correct_user, only: [:edit,:update]  # ユーザー自身のみが情報を編集・更新できる アクセスしたユーザーが現在ログインしているユーザーであるか確認
  before_action :admin_user, only: [:index, :destroy] # 
  before_action :admin_or_correct, only: [:show]      # 現在ログインしているユーザーが管理者の場合のみ認可する機能を追加
  
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)   # ページネーションを判定できるオブジェクトに置き換える
  end                                                           # 1ページ20人
  
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
  
  def destroy   #  管理者のみがユーザーを削除できるようになりました
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
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
    def logged_in_user   # logged_in?ヘルパーメソッド
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
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
