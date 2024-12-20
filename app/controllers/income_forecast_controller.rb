require 'httparty'

class IncomeForecastController < ApplicationController
  def index
    # Replace this URL with your API endpoint

    # Using: https://www.exchangerate-api.com/docs/standard-requests
    # url = URI("#{ENV['EXCHANGE_RATE_API_URL']}/CAD")
    #
    # response = HTTParty.get(url)
    #
    # @api_data = response.parsed_response

    # Faking API calls for now. 1500 a month limit.
    @api_data = {
      "conversion_rates" => {
        "USD" => 0.75
      }
    }

    # TODO: hard coding USD for now until forms implemented.
    @quote_currency = "USD"
    @base_to_quote_conversion_rate = @api_data.dig("conversion_rates", @quote_currency)
  rescue StandardError => e
    @error_message = "Error fetching API data: #{e.message}"
  end
end
