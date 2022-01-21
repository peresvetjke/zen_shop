class RussianPost::DeliveryInfoRetriever
  # https://tariff.pochta.ru/post-calculator-api.pdf
  BASE_URL =  {
                "RussianPost::DeliveryCostRetriever"        => "https://tariff.pochta.ru/v1/calculate/tariff",
                "RussianPost::DeliveryDeadlineRetriever" => "https://tariff.pochta.ru/v1/calculate/delivery"
              }
  OBJECT = 27020 # Посылка (частное лицо или предприятие) // Посылка стандарт с объявленной ценностью 
  PACK = 20      # коробка M

  attr_reader :from, :to, :weight, :sumoc

  def initialize(from:, to:, weight:, sumoc:)
    raise "DeliveryInfoRetriever cannot be initialized" if self.class == RussianPost::DeliveryInfoRetriever
    raise "Argument 'sumoc' should be Money with currency = 'RUB'" unless sumoc.class == Money && sumoc.currency.id == :rub

    @from = from
    @to = to
    @weight = weight
    @sumoc = sumoc.cents
  end

  def call
    response = JSON.parse(retrieve_info.body)
    parse(response)
  end

  protected

  def parse(response)
    # should be implemented in children classes
  end

  def retrieve_info
    http_client = Faraday.new(
      url: base_url,
      params: { 
                from:   from,
                to:     to,
                weight: weight,
                sumoc:  sumoc,
                object: OBJECT,
                pack:   PACK,
                json:   ''
              }
    )

    http_client.get
  end

  def base_url
    BASE_URL[self.class.to_s]
  end
end