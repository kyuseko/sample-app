class SessionsController < ApplicationController
  
  def new
    if logged_in?
      flash[:info] = 'すでにログインしています。'
      redirect_to current_user
    end
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase) # ログインフォームから受け取った値を使ってユーザーオブジェクトを検索
    if user && user.authenticate(params[:session][:password]) # 取得したユーザーオブジェクトが有効か判定
      log_in user     # session_helper.rbのlon_in(user)からきてる
      remember user   # ログインしたユーザーを記憶する（永続化セッション） rememberヘルパーメソッドを作ってlog_inヘルパーメソッドと連携
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)  # チェックボックスがオンの時にログイン情報を記憶し、オフの時は記憶しない
      redirect_back_or user   # userを指定することで デフォルトのURLを設定                               [条件式] ? [真（true）の場合実行される処理] : [偽（false）の場合実行される処理]
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  # log_outヘルパーメソッドを使ってdestroyアクションを完成
  def destroy
    log_out if logged_in?  # ログイン中の場合のみログアウト処理を実行します。
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
