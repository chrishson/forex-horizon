class DaysRemaining
  attr_reader :total_days_remaining, :business_days_remaining, :weekend_days_remaining

  def initialize(start_date: Time.zone.today, end_date: Time.zone.today.end_of_year)
    @start_date = start_date
    @end_date = end_date

    calculate_days
  end

  private

  def calculate_days
    @total_days_remaining = 0
    @business_days_remaining = 0
    @weekend_days_remaining = 0

    (@start_date..@end_date).each do |date|
      @total_days_remaining += 1
      if weekend?(date)
        @weekend_days_remaining += 1
      else
        @business_days_remaining += 1
      end
    end
  end

  def weekday?(date)
    !date.saturday? && !date.sunday?
  end

  def weekend?(date)
    date.saturday? || date.sunday?
  end
end
