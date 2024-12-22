class CurrencyConversion
  include HTTParty

  def self.rates(base_currency)
    # TODO: Replace with actual API call
    #
    # Using: https://www.exchangerate-api.com/docs/standard-requests
    # url = URI("#{ENV['EXCHANGE_RATE_API_URL']}/#{base_currency}")
    #
    # response = HTTParty.get(url)
    #
    # @api_data = response.parsed_response
    {
      'conversion_rates' => {
        'USD' => base_currency == 'USD' ? 1.00 : 0.75,
        'CAD' => base_currency == 'CAD' ? 1.00 : 1.33
      }
    }
  end

  def self.conversion_rate(base_currency:, quote_currency:)
    rates(base_currency).dig('conversion_rates', quote_currency)
  end
end
