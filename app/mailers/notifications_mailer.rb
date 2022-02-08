class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.stock_arrival.subject
  #
  def stock_arrival(user:, arrived_items:)
    @user = user
    @arrived_items = arrived_items

    mail to: user.email
  end

  def order_update(order:)
    @user = order.user
    @order = order

    mail to: user.email
  end
end
