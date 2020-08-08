class TasksController < ApplicationController
  
   before_action :set_user  # paramsハッシュからユーザーを取得します。ログインしたユーザー
   before_action :set_task, only: %i(show edit update destroy)  # userのidとtaskのidが一致しているか
   before_action :logged_in_user       # ログインしていないユーザー アクションを指定
   before_action :correct_user                                  # 現ログインユーザーであるか 正しいユーザーか？
   
   
  def index
    # @user=User.find(params[:user_id])
    @tasks=@user.tasks  # Userモデルに紐付くtasksのレコード全て取得 ドット手法
  end
  
  def new
    # @user=User.find(params[:user_id])
    @task= @user.tasks.new
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
    # @user=User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
  end 
  
  def edit
    @tasks = @user.tasks.find(params[:id])
  end 
  
  def update
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました。"
      redirect_to user_task_url(@user, @task)
    else
      render :edit
    end
  end
  
  
  def destroy
    @tasks = @user.tasks.find(params[:id])
    @tasks.destroy
    redirect_to user_tasks_url
  end
  
  
 private  # 外部からは使用できないようにします
     # Strong Parameters
    def task_params    # requireとは必要とするで、permitは許可をするという意味
      params.require(:task).permit(:name, :description)  # require(:task)がダブルのでいらない
    end 
 
    # beforeフィルター
    
      # paramsハッシュからユーザーを取得します。
    def set_user
      @user=User.find(params[:user_id])
    end
    
    
    def set_task  # 権限があるか？  userのidとtaskのidが一致しているか？
     unless @task = @user.tasks.find_by(id: params[:id])
        flash[:danger] = "権限がありません。"
        redirect_to user_tasks_url @user
     end
    end
    
    
end
