module Forms
  class IncomeForecastFormController < ApplicationController
    before_action :validate_form_params, only: %i[update_forecasted_income]
    before_action :set_projected_income, only: %i[update_forecasted_income], if: lambda {
      @errors.blank?
    }
    def index; end

    def update_forecasted_income
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              'form_errors',
              partial: 'income_forecast/income_forecast_form_errors',
              locals: {
                errors: @errors
              }
            ),
            turbo_stream.replace(
              'projected_income',
              partial: 'income_forecast/projected_income',
              locals: {
                base_income: @base_income,
                quote_income: @quote_income,
                weekday_days_remaining: @weekday_days_remaining,
                weekend_days_remaining: @weekend_days_remaining,
                total_days_remaining: @total_days_remaining
              }
            )
          ]
        end
      end
    end

    private

    def set_projected_income
      # TODO: Not really just projected_income, refactor name and what it does later.
      return if form_params[:conversion_rate].blank?

      days_remaining_service = DaysRemaining.new(
        start_date: form_params[:start_date].to_date,
        end_date: form_params[:end_date].to_date
      )

      @weekday_days_remaining = days_remaining_service.weekday_days_remaining
      @weekend_days_remaining = days_remaining_service.weekend_days_remaining
      @total_days_remaining = days_remaining_service.total_days_remaining

      # TODO: refactor params?
      @total_hours = HoursRemainingCalculator.new(
        start_date: form_params[:start_date].to_date,
        end_date: form_params[:end_date].to_date,
        hours_per_day: form_params[:hours_per_day],
        days_per_week: form_params[:days_per_week],
        working_hours_remaining_this_week: form_params[:working_hours_remaining_this_week],
        days_off: form_params[:days_off]
      ).total_hours

      income_calculator = IncomeCalculator.new(
        total_hours: @total_hours,
        hourly_rate: form_params[:hourly_rate].to_f,
        conversion_rate: form_params[:conversion_rate]
      )

      @errors = []
      @base_income = income_calculator.base_income
      @quote_income = income_calculator.quote_income
    end

    def form_params
      params.permit(
        :hours_per_day,
        :hourly_rate,
        :days_per_week,
        :working_hours_remaining_this_week,
        :days_off,
        :conversion_rate,
        :start_date,
        :end_date
      )
    end

    def validate_form_params
      @errors = []
      form_params.each do |key, value|
        # TODO: Really bad but temporary.
        next if %i[working_hours_remaining_this_week days_off].include?(key.to_sym)

        @errors << "#{key} must be a positive number" if value.blank? || value.to_f <= 0
      end
    end
  end
end
