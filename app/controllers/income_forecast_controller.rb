class IncomeForecastController < ApplicationController
  DEFAULTS = {
    base_currency: 'USD',
    quote_currency: 'CAD'
  }.freeze
  def index
    @base_currency = DEFAULTS[:base_currency]
    @quote_currency = DEFAULTS[:quote_currency]
    @conversion_rate = CurrencyConversion.conversion_rate(
      base_currency: @base_currency,
      quote_currency: @quote_currency
    )
  end

  def update_conversion_rate
    respond_to do |format|
      format.turbo_stream do
        @base_currency = conversion_rate_params[:base_currency]
        @quote_currency = conversion_rate_params[:quote_currency]

        @conversion_rate = CurrencyConversion.conversion_rate(
          base_currency: @base_currency,
          quote_currency: @quote_currency
        )

        render turbo_stream: turbo_stream.replace(
          'conversion-rate',
          partial: 'income_forecast/conversion_rate',
          locals: {
            base_currency: @base_currency,
            quote_currency: @quote_currency,
            conversion_rate: @conversion_rate
          }
        )
      end
    end
  end

  private

  def conversion_rate_params
    params.permit(:base_currency, :quote_currency)
  end
end
