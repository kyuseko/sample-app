module UsersHelper
  
   # 勤怠基本情報を指定のフォーマットで返します。  
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0) # 小数点第三位以上まである場合は第二位まで表示しそれ以降は切り捨てます。
  end
end
