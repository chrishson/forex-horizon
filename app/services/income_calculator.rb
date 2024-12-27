class IncomeCalculator
  def initialize(total_hours:, hourly_rate:, conversion_rate:)
    @total_hours = total_hours
    @hourly_rate = hourly_rate
    @conversion_rate = conversion_rate
  end

  def base_income
    @total_hours * @hourly_rate
  end

  def quote_income
    base_income * @conversion_rate.to_f
  end
end
