module ApplicationHelper
  def price_amount(price)
    if price.start_count.present? && price.end_count.present?
      "#{price.start_count}-#{price.end_count}"
    else
      "от #{price.start_count}"
    end
  end

  def price_val(price)
    if price.value.present?
      price.value.to_s + '<span class="ruble"> Р </span>'
    else
      "Договорная"
    end
  end

  def link_active?(params_val=nil)
    params[:type_construction].present? && params[:type_construction] == params_val && !params_val.nil? ||
    params_val.nil? && params[:type_construction].blank? && params[:controller] == 'coolers' && params[:action] == 'index'
  end

  def text_align_for_post(post)
    if post.button_name.blank? && post.link_url.blank? && post.link_name.blank?
      'center_text_align'
    end
  end

  def active_products?(current)
    current == params[:type]
  end
  def products_list(order)
    json = JSON.parse(order.order_info.gsub('=>', ':'))
    json['aquas'].values.map do |val|
      name = val['aqua'].split('-').last
      volume = val['volume'].split('-').last
      "#{name} - #{volume}, кол-во: #{val['amount']}, цена: #{val['price']} руб."
    end.join('<br/>')
  end

  def title(page_title)
    content_for(:title) { page_title.to_s }
  end

  def meta_keywords(content)
    content_for(:keywords) { content.to_s }
  end

  def meta_description(content)
    if content.present?
      content_for(:description) { strip_tags(content.truncate(150, separator: ' ').to_s) }
    end
  end

  def order
    direction = if params[:direction] == 'desc'
                  'asc'
                elsif params[:direction] == 'asc'
                  ''
                else
                  'desc'
                end
    link_to 'Сортировать по цене', {direction: direction}
  end

  def triangle
    (params[:direction] == 'desc' ? '&#9660;' : '&#9650;').html_safe if params[:direction].present?
  end

  def link_with_tab(name = nil, options = {}, html_options = nil, &block)
    link_to(name, {target: '_blank'}.merge(options), html_options, &block)
  end
end
