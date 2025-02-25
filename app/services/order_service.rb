class OrderService
  def self.get_price(aqua_id, volume_id, amount)
    price = Price.where(aqua_id: aqua_id, volume_id: volume_id).
                  where('start_count <= :count', count: amount).
                  order(:start_count).
                  last
    show_price(price.value, amount) if price
  end
  def self.show_price(price, amount)
    price.to_i < 1 ? 'Договорная' : (price.to_f * amount.to_f)
  end

  def self.check_date(date)
    # 1 - morning
    # 2 - evening
    today = Time.zone.today
    delivery_date = date.present? ? Date.parse(date) : today
    setting = OrderSetting.first
    disabled = []
    if delivery_date == today || delivery_date == Time.zone.tomorrow && Time.zone.now.localtime.hour >= 16
      disabled << 1
    end
    if delivery_date == today && Time.zone.now.localtime.hour >= 11
      disabled << 2
    end
    disabled << 1 if (today.sunday? || today.saturday?) && delivery_date.monday?
    return disabled unless setting
    # puts setting.disabled_day?(dt) || setting.disabled_date?(dt)
    # puts setting.disabled_morning_day?(dt) || setting.disabled_morning_date?(dt)
    # puts setting.disabled_evening_day?(dt) || setting.disabled_evening_date?(dt)
    if setting.disabled_day?(delivery_date) || setting.disabled_date?(delivery_date)
      disabled = [1, 2]
    elsif setting.disabled_morning_day?(delivery_date) || setting.disabled_morning_date?(delivery_date)
      disabled << 1
    elsif setting.disabled_evening_day?(delivery_date) || setting.disabled_evening_date?(delivery_date)
      disabled << 2
    end
    disabled.uniq
  end

  def self.get_order_json(params)
    ar = []
    cost = 0.0
    prefix = ''
    if params['aquas']
      params['aquas'].each_pair do |_, aqua|
        name = Aqua.where(id: aqua['aqua']).pluck(:name).first
        volume = Volume.find(aqua['volume'])
        amount = aqua['amount'].to_i
        prc = get_price(aqua['aqua'], aqua['volume'], amount)
        prc.to_f > 1 ? (cost += prc.to_f) : (prefix = 'Доворная')
        ar.push({ name: "#{name} #{volume.value}", amount: amount, cost: prc })
      end
    end
    if params['accessories']
      params['accessories'].each_pair do |_, product|
        id, klass = product['info'].split('-')
        pr = klass.classify.constantize.find(id)
        amount = product['amount'].to_i
        prc = amount*pr.price
        cost += prc
        ar.push({ name: pr.title, amount: amount, cost: prc })
      end
    end
    { items: ar, total: prefix + cost.to_s }
  end
end
