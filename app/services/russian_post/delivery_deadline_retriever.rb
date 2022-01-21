module RussianPost
  class DeliveryDeadlineRetriever < DeliveryInfoRetriever
    protected

    def parse(response)
      Date.parse(response['delivery']['deadline'])
    end
  end
end