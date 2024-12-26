module Forms
  class CurrencyConversionFormController < ApplicationController
    def update_conversion_rate
      respond_to do |format|
        format.turbo_stream do
          @base_currency = form_params[:base_currency]
          @quote_currency = form_params[:quote_currency]

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

    def form_params
      params.permit(:base_currency, :quote_currency)
    end
  end
end
