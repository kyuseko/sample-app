class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) # ログインフォームから受け取った値を使ってユーザーオブジェクトを検索
    if user && user.authenticate(params[:session][:password]) # 取得したユーザーオブジェクトが有効か判定
      log_in user     # session_helper.rbのlon_in(user)からきてる
      remember user   # ログインしたユーザーを記憶する（永続化セッション）
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user   # デフォルトのURLを設定
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    log_out if logged_in?  # ログイン中の場合のみログアウト処理を実行します。
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
