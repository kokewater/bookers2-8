class ContactMailer < ApplicationMailer
  def send_when_admin_r(user, contact) #メソッドに対して引数を設定
    @user = user #ユーザー情報
    @answer = contact.reply_text #返信内容
    mail to: @user.email, subject: 'ククク、私のサイトへようこそ！'
  end
end