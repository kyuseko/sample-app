module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)                 # 様々な場所で使いまわせるようにSessionsヘルパーモジュールにlog_inメソッドを定義
    session[:user_id]=user.id # ユーザーのブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成
  end                              # user.idはsession[:user_id]と記述することで元通りの値を取得することが可能
  # ユーザーのログインを行ってcreateアクションを完了してユーザー情報ページへリダイレクトする準備が整いました。
  # log_inメソッドの機能で、ユーザーIDを一時的セッションの中に安全に記憶
  
  
  # 永続的セッションを記憶します（Userモデルを参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id  # ユーザーidをcookiesに保存
    cookies.permanent[:remember_token] = user.remember_token
  end                                             # ログインするユーザーはブラウザで有効な記憶トークンを取得できるよう記録
  
  # 永続的セッションを破棄します
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄します
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 一時的セッションにいるユーザーを返します。
  # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user  # 現在ログイン中のユーザーを取得 インスタンス変数にしてdbへ問い合わせ一回で済む 
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id) # nilの時対応ができないからfind_by ユーザーオブジェクト取得
    elsif (user_id = cookies.signed[:user_id])   # ユーザーidをcookiesに保存を代入
      user = User.find_by(id: user_id)           # ユーザーオブジェクトを取得
      if user && user.authenticated?(cookies[:remember_token])  # cookiesに保存されているremember_tokenがdbにあるremember_digestと一致することを確認
        log_in user
        @current_user = user
      end
    end
  end
  # ログインしている状態とは、「一時的セッションにユーザーIDが存在する
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  # ユーザーがログインしている時とそうではない時でレイアウトを変更してみましょう。
  # このログイン状態を論理値（trueかfalse）で返すヘルパーメソッド（logged_in?）を定義しましょう。
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶しているURL(またはデフォルトURL)にリダイレクトします。
  def redirect_back_or(default_url) # URLを記憶しておく手段として、一時的セッションであるsessionハッシュを使います。
    redirect_to(session[:forwarding_url] || default_url)  # nilでなければその値を使い、そうでなければ右側のdefaultの値を使います。
    session.delete(:forwarding_url)    # 一時的セッションを破棄
  end

  # アクセスしようとしたURLを記憶します。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
