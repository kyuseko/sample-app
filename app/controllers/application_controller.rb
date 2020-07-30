class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # CSRF保護を無効
  protect_from_forgery with: :exception
  include SessionsHelper
end
