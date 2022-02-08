class NotificationSender
  def send_stock_arrival_newsletter
    User.find_each(batch_size: 500) do |user| 
      arrived_items = Item.arrived_items_for_follower(user).to_a
      if arrived_items.present?
        NotificationsMailer.stock_arrival(user: user, arrived_items: arrived_items).deliver_later
      end
    end
  end

  def send_order_update_newsletter(order:)
    NotificationsMailer.order_update(order: order).deliver_later
  end
end