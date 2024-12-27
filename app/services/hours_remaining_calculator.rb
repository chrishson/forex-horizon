class HoursRemainingCalculator
  def initialize(start_date:,
                 end_date:,
                 hours_per_day:,
                 days_per_week:,
                 working_hours_remaining_this_week: 0,
                 days_off: 0)
    @start_date = start_date
    @end_date = end_date
    @hours_per_day = hours_per_day.to_f
    @days_per_week = days_per_week.to_i
    @working_hours_remaining_this_week = working_hours_remaining_this_week.to_f
    @days_off = days_off.to_i
  end

  def total_hours
    total_hours = @working_hours_remaining_this_week
    current_date = @start_date

    # inclusive of the current day so we - 1
    remaining_days_in_week = 7 - (current_date.wday - 1)
    # Start on the Monday next week
    current_date += remaining_days_in_week.days

    # Calculate full weeks' hours.
    # TODO: This assumes you front load the work.
    while (current_date + (@days_per_week - 1).days) <= @end_date
      total_hours += @hours_per_day * @days_per_week
      current_date += 7.days
    end

    # Calculate hours for the last partial week
    if current_date <= @end_date
      remaining_days_in_last_week = (@end_date - current_date).to_i + 1
      total_hours += [remaining_days_in_last_week, @days_per_week].min * @hours_per_day
    end

    # Deduct hours for planned days off
    total_hours -= (@days_off * @hours_per_day)

    # Ensure the total hours do not go below zero
    [total_hours, 0].max
  end
end
