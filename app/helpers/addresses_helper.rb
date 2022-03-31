module AddressesHelper

  def full_address(address)
    if address.present?
      [:country, :postal_code, :city_with_type, :street_with_type, :house, :flat].map { |f| address.send(f) }.delete_if { |f| f.empty? }.join(", ")
    else
      ""
    end
  end

end