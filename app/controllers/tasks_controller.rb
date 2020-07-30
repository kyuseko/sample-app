class TasksController < ApplicationController
  
   before_action :set_user  # paramsハッシュからユーザーを取得します。ログインしたユーザー
   
   
  def index
    # @user=User.find(params[:user_id])
    @tasks=@user.tasks  # Userモデルに紐付くtasksのレコード全て取得 ドット手法
  end
  
  def new
    # @user=User.find(params[:user_id])
    @tasks=@user.tasks.new
  end 
  
  def create
    # @user=User.find(params[:user_id])
    @tasks=@user.tasks.build(task_params)  # user_idを入れる
    if @tasks.save
      flash[:success] = '新規作成に成功しました。'
      redirect_to user_tasks_url @user   # 保存に成功した場合は、ここに記述した処理が実行されます。
    else                                 # 一覧ページへ
      render :new
    end
  end
  
  def show
    @tasks = Task.find(params[:id])
  end 
  
  def edit
    @tasks = Task.find(params[:id])
  end 
  
  def update
    @tasks = Task.find(params[:id])
    redirect_to posts_index_url
  end
  
  
  
 private  # 外部からは使用できないようにします
     # Strong Parameters
    def task_params    # requireとは必要とするで、permitは許可をするという意味
      params.permit(:name, :description, :user_id)  # require(:task)がダブルのでいらない
    end 
 
    # beforeフィルター
    
      # paramsハッシュからユーザーを取得します。
    def set_user
      @user=User.find(params[:user_id])
    end
    
    
end
