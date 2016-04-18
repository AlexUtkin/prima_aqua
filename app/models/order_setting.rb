class OrderSetting < ActiveRecord::Base
  def disabled_day?(date)
    disabled_weekdays && (disabled_weekdays.split(',').include? wday(date.wday))
  end
  def disabled_date?(date)
    disabled_days && (disabled_days.split(',').include? date.day.to_s)
  end
  def disabled_morning_day?(date)
    disabled_morning_weekdays && (disabled_morning_weekdays.split(',').include? wday(date.wday))
  end
  def disabled_morning_date?(date)
    disabled_morning_days && (disabled_morning_days.split(',').include? date.day.to_s)
  end
  def disabled_evening_day?(date)
    disabled_evening_weekdays && (disabled_evening_weekdays.split(',').include? wday(date.wday))
  end
  def disabled_evening_date?(date)
    disabled_evening_days && (disabled_evening_days.split(',').include? date.day.to_s)
  end

  def wday(day)
    day == 0 ? '7' : day.to_s
  end
end
