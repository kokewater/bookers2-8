class ContactMailer < ApplicationMailer
  def welcome_email(user)#メソッドに対して引数を設定
    @user = user #ユーザー情報
    mail(:subject => "登録完了のお知らせ", to: user.email)
  end
end