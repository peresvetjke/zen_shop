class Delivery < ApplicationRecord
  FROM = 141230 # post index of our plant

  enum type: { "RussianPostDelivery" => 0 }

  belongs_to :order
  belongs_to :address

  validates_associated :address

  def cost
    raise "Not implemented for abstract class."
  end

  def planned_date
    raise "Not implemented for abstract class."
  end
end
