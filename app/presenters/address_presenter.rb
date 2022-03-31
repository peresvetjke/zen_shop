class AddressPresenter < BasePresenter
  presents :address

private

  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, "Not available", class: "none"
    end
  end
end