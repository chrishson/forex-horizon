class CurrencyService
  include HTTParty

  def initialize(base_currency:, quote_currency:)
    @base_currency = base_currency
    @quote_currency = quote_currency
  end

  def conversion_rate
    rates.dig('conversion_rates', @quote_currency)
  end

  private

  def rates
    # TODO: Replace with actual API call
    #
    # Using: https://www.exchangerate-api.com/docs/standard-requests
    # url = URI("#{ENV['EXCHANGE_RATE_API_URL']}/CAD")
    #
    # response = HTTParty.get(url)
    #
    # @api_data = response.parsed_response
    {
      'conversion_rates' => {
        'USD' => @base_currency == 'USD' ? 1.00 : 0.75,
        'CAD' => @base_currency == 'CAD' ? 1.00 : 1.33
      }
    }
  end
end
