class IncomeForecastController < ApplicationController
  DEFAULTS = {
    base_currency: 'USD',
    quote_currency: 'CAD'
  }.freeze
  def index
    # TODO: Do I need to set default values for a nested form here?
    # I can't figure out how to get the form to handle its own instance variables.
    @base_currency = DEFAULTS[:base_currency]
    @quote_currency = DEFAULTS[:quote_currency]
    @conversion_rate = CurrencyConversion.conversion_rate(
      base_currency: @base_currency,
      quote_currency: @quote_currency
    )
  end
end
