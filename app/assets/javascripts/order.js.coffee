if window.Storage and window.JSON
  window.$storage = (key) ->
    set: (value) ->
        localStorage.setItem(key, JSON.stringify(value))
    get: ->
        item = localStorage.getItem(key)
        JSON.parse(item) if item

class Order
  constructor: ->
    #localStorage.setItem('product', '')
    #html = $storage("prima_state_card").get()
    #if html
    #  $('.prima_state_card').html(html)

    @isValid = false

    $(document).on 'change', '.js-aqua-select-tag', (e)=>
      @updateVolumesSelector(e)

    $(document).on 'change', '.js-volume-select-tag', (e)=>
      @actualizeWaterPrice($(e.currentTarget).closest('.water_template'))

    $(document).on 'click', '.js_add_position', (e)=>
      @addPosition(e)

    $(document).on 'click', '.js_remove_position', (e)=>
      @removePosition(e)

    $(document).on 'click', '.js_remove_accessory', (e)=>
      @removeAccessory(e)

    $(document).on 'click', '.js_empty_bottles', (e)->
      checkbox = $(e.currentTarget)
      checkbox.attr("checked", !checkbox.attr("checked"))

    $(document).on 'click', '.js_increment', (e)=>
      elem = $(e.currentTarget)
      if elem.data('product') == 'aqua'
        @updateWaterAmount(elem)
      else
        @updateProductAmount(elem)

    $(document).on 'click', '.js_order_change_step', ()=>
      @changeOrderStep()

    $(document).on 'click', '.js_variant', (e)=>
      elem = $(e.currentTarget)
      if  !elem.hasClass('disabled') && @isShoudProcessed(elem)
        $('.order__customer_form').toggleClass('hidden_block')

    $(document).on 'click', '.js_add_product', (e)=>
      elem = $(e.currentTarget)
      @insertProduct(elem)

    $(document).on 'click', '.js_all', (e)=>
      @filterProducts('all', e)

    $(document).on 'click', '.js_cooler', (e)=>
      @filterProducts('cooler', e)

    $(document).on 'click', '.js_accessory', (e)=>
      @filterProducts('accessory', e)

    $(document).on 'click', '.js_product', (e)=>
      @filterProducts('product', e)

    $(document).on 'click', '.js_order_back', =>
      @createOrder()
      yaCounter14311645.reachGoal('submitorder')

    $(document).on 'change', '.js_order_register_flag', ->
      $('.js_order__register_form').toggleClass('hidden_block')

    $(document).on 'change', '.js_empty_bottles', ->
      $('.js_dep').toggleClass('hidden_block')

  # improve!!! make through class
  @saveHtml: ->
    #$storage("prima_state_card").set($('.prima_state_card').html())

  validateForm: (info) =>
    msg = []
    $('.error_field').removeClass('error_field')
    msg.push('Добавьте товары в заказ') unless Object.keys(info['items']).length > 0
    customer_type = $('.js_customer_type_selector').data('val')
    form = $(".js_#{customer_type}")

    if form.find('#name').val().length < 2
      msg.push('Заполните ваше имя')
      form.find('#name').addClass('error_field')

    if form.find('#phone').val().length < 2
      msg.push('Заполните ваш телефон')
      form.find('#phone').addClass('error_field')

    if form.find('#address').val().length < 2
      msg.push('Заполните ваш адрес')
      form.find('#address').addClass('error_field')

    if $('.datepicker').val().length < 2
      msg.push('Выберите дату доставки')
      form.find('.datepicker').addClass('error_field')

    if $('.js_delivery_time_selector').data('val').length < 2
      msg.push('Выберите время доставки')
      form.find('.js_delivery_time_selector').addClass('error_field')

    if $('.js_delivery_time_selector .disabled').length > 1
      msg.push('Выберите другой день доставки')
      form.find('.js_delivery_time_selector').addClass('error_field')

    flag = msg.length < 1
    { isValid: flag, errors: msg }

  createOrder: =>
    infoData = @getOrderInfo()
    res = @validateForm(infoData)
    infoData['email'] = $('#email').val()
    infoData['password'] = $('#password').data('val')
    if res['isValid']
      window.showSpinner()
      $.ajax
        url: "/orders"
        type: 'POST'
        dataType: "json"
        data: infoData
        success: (data)=>
          window.hideSpinner()
          $('.order_error_messages').html('')
          localStorage.removeItem('prima_aqua_card')
          list = $('.js_bill')
          html = ''
          for item in data.items
            html += "<div class='bill_product'>
                      <span class='bill_product_name'>
                        #{item.name}
                      </span>
                      <span class='bill_product_cost'>
                        #{item.cost}
                        <span class='rubles'>Р</span>
                      </span>
                      <span class='bill_product_amount'>
                        #{item.amount}
                      </span>
                      <div class='clearfix'></div>
                    </div>"
          list.append(html)
          if data.deposit && data.deposit != '0'
            deposit = '+ ' + data.deposit + '<span class="rubles"> Р</span>'
            $('.total_deposit').html(deposit)
          $('.js_total_price').text(parseFloat(data.total).toFixed(2))
          $('.order_step').addClass('hidden_block')
          $('.thanks').removeClass('hidden_block')
    else
      @showErrors(res['errors'])

  showErrors: (errors)=>
    html = '<p>Пожалуйста, исправьте следующие пункты: </p> <ol>'
    for msg in errors
      html += '<li>'+msg+'</li>'
    $('.order_error_messages').html(html + '</ol>')

  restoreCard: =>
    card = JSON.parse(localStorage.getItem('prima_aqua_card')) || {}
    if !card.ttl || (new Date - card.ttl) > 36000000
      localStorage.removeItem('prima_aqua_card')
      card = {}
    if card.info
      @fillOrderForm(card.info)
    if card.items
      @restoreAquas(card.items.aquas) if card.items.aquas
      @restoreAccessories(card.items.accessories) if card.items.accessories
    @actualizeDeposit()

  restoreAquas: (aquas)=>
    html = ''
    products = $('.js_products')
    products.html('')
    dep = 0
    for aqua in aquas
      dep += parseFloat(aqua.deposit)
      products.append($('.js_aqua_template').html())
      product = products.find('.water_template').last()
      @restoreAqua(aqua, product)
    $('.js_order_deposit').html(dep)

  restoreAqua: (aqua, product)=>
    product.find('.js_amount_input').val(aqua.amount)
    product.find('.js_deposit').html(aqua.deposit)
    product.find('.js-aqua-select-tag').val(aqua.aqua)
    $.ajax
      url: "/aquas/#{aqua.aqua}/volumes"
      type: 'GET'
      dataType: "json"
      success: (data)=>
        @refreshWaterSelectTag(product.find('.js-volume-select-tag'), data.volumes, aqua.volume)
        product.find('.js_price_value').text(aqua.price.toFixed(2))
        #product.find('.js-volume-select-tag').val(aqua.volume)
    #@actualizeWaterPrice(product, aqua.aqua, aqua.volume, aqua.amount)

  restoreAccessories: (products)=>
    html = ''
    for product in products
      html = html + @productHtml(product.name, product.amount, product.price, product.info, product.step)
    $('.js_products').append(html)

  fillOrderForm: (info)=>
    form = $(".js_#{info.customer_type}")
    $('.order__customer_form ').addClass('.hidden_block')
    form.removeClass('.hidden_block')
    $('.variant').removeClass('.active')
    $('div.variant[data-val="individual"]').addClass('.active')
    form.find('#name').val(info.name)
    form.find('#phone').val(info.phone)
    form.find('#address').val(info.address)
    $('#comment').val(info.comment)
    $('.datepicker').val(info.date)
    if info.empty_bottles
      $('.js_empty_bottles').prop('checked', true)
      $('.js_dep').toggleClass('hidden_block')
    @checkAvailableTime()

  filterProducts: (type, e)->
    $('.filter_active').removeClass('filter_active')
    $(e.currentTarget).addClass('filter_active')
    carousel = $('.js_order__products')
    klass = false
    klass = if type == 'cooler'
              '.jsCooler'
            else if type == 'accessory'
              '.jsAccessory'
            else if type == 'product'
              '.jsProduct'
    if klass
      $('.js_order__products').slick('slickFilter', klass)
    else
      $('.js_order__products').slick('slickUnfilter')

  checkAvailableTime: (date = $('.datepicker').val() )->
    $.ajax
      url: "/check_time?data=#{date}"
      type: 'GET'
      dataType: "json"
      success: (msg)=>
        parent = $('.delivery_time')
        disabled = parent.find('.disabled')
        if msg.length > 0
          parent.find('.variant').addClass('active')
          disabled.addClass('active').removeClass('disabled')
          for i in msg
            if i == 1
              parent.find('.js_morning').addClass('disabled').removeClass('active')
              parent.find('.js_delivery_time_selector').data('val', 'evening')
            else if i == 2
              parent.find('.js_evening').addClass('disabled').removeClass('active')
              parent.find('.js_delivery_time_selector').data('val', 'morning')
        else
          disabled.removeClass('disabled')
          parent.find('.active').removeClass('active')
          parent.find('.js_morning').addClass('active')
          parent.find('.js_delivery_time_selector').data('val', 'morning')

  setDefaultTime: ()=>
    someDate = new Date
    hours = someDate.getHours()
    someDate.setDate(someDate.getDate() + 1)
    time = if hours < 12 then '' else someDate
    $('.datepicker').datepicker('setDate', if hours < 12 then (new Date) else someDate)
    @checkAvailableTime(time)

  changeOrderStep: ->
    $('#address').val($('#address').attr('value'))
    $('.order_step').toggleClass('hidden_block')

  isShoudProcessed: (elem)->
    elem.hasClass('first_variant') && $('.js_company').is(':visible') ||
    elem.hasClass('second_variant') && $('.js_individual').is(':visible')

  showModal: =>
    $('.js_modal_back').show()
    $('.js_modal_order').show()
    if $storage("prima_aqua_card").get() && (!!$storage("prima_aqua_card").get().items || !!$storage("prima_aqua_card").get().info)
      @restoreCard()

    $('.js_order__products').slick
      infinite: true
      slidesToShow: 3
      slidesToScroll: 3
      prevArrow: '<button type="button" class="slick-prev"><</button>'
      nextArrow: '<button type="button" class="slick-next">></button>'
    @actualizeDeposit()
    @setDefaultTime()

  addPosition: (e)->
    $('.js_products').append($('.js_aqua_template').html())
    @actualizeDeposit()

  addAqua: (elem)->
    aqua = elem.data()
    products = $('.js_products')
    products.append($('.js_aqua_template').html())
    el = products.find('.water_template').last()
    @restoreAqua(aqua, el)
    @actualizeWaterPrice(el, aqua.aqua, aqua.volume, aqua.amount)

  removePosition: (e)=>
    elem = $(e.currentTarget)
    elem.closest('.water_template').remove()
    @actualizeDeposit()

  removeAccessory: (e)->
    elem = $(e.currentTarget)
    elem.closest('.accessory_template').remove()

  updateVolumesSelector: (e)->
    elem = $(e.currentTarget)
    aqua_id = parseInt(elem.val())
    $.ajax
      url: "/aquas/#{aqua_id}/volumes"
      type: 'GET'
      dataType: "json"
      success: (data)=>
        waterLine = elem.closest('.water_template')
        @refreshWaterSelectTag(waterLine.find('.js-volume-select-tag'), data.volumes)
        @actualizeWaterPrice(waterLine)

  insertProduct: (elem)->
    attr = elem.data()
    $('.js_products').append(@productHtml(attr.title, attr.amount, attr.price, attr.id))

  productHtml: (name, amount, price, id, step=false)->
    cost = if step then parseInt(amount)/parseInt(step) * parseFloat(price) else price
    step = amount unless step
    step1 = '-' + step
    html = "<div class='accessory_template js_product_item' data-id=#{id}>
              <div class='accessory_name'>
                #{name}
              </div>
              <div class='amount js_amount'>
                <button class='js_increment button_minus' data-product='accessory' data-step=#{step1}>
                  -
                </button>
                <input value='#{amount}' disabled='disabled' class='js_accessory_amount'/>
                <button class='js_increment button_plus' data-product='accessory' data-step='#{step}'>
                  +
                </button>
              </div>
              <div class='remove_button js_remove_accessory'>
                x
              </div>
              <div class='price js_price' data-price='#{price}'>
                <span class='js_price_value'>#{cost.toFixed(2)}</span>
                <span class='js_currency'>
                  Р
                </span>
              </div>
              <div class='clearfix'></div>
            </div>"
    html

  refreshWaterSelectTag: (htmlTag, values, value = false)->
    html = ''
    for val in values
      html += "<option value='#{val}'>#{val.split('-')[1]}</option>"
    htmlTag.html(html)
    if value
      htmlTag.val(value)

  updateWaterAmount: (elem)->
    num = elem.data('step')
    input = elem.closest('.js_amount').find('input')
    val = parseInt(input.val())
    if num > 0 || val > 1
      input.val(val + num)
      @actualizeWaterPrice(elem.closest('.water_template'))

  updateProductAmount: (elem)->
    num = elem.data('step')
    input = elem.closest('.js_amount').find('input')
    val = parseInt(input.val())
    if num > 0 || (val + num) > 0
      input.val(val + num)
      @actualizeAccessoryPrice(elem.closest('.accessory_template'), num > 0)

  actualizeWaterPrice: (elem, aqua = false, volume = false, amount = false)->
    elem.find('.js_price').hide()
    $.ajax
      url: "/aquas/check_price"
      type: 'GET'
      data:
        aqua_id: aqua || parseInt(elem.find('.js-aqua-select-tag').val())
        volume_id: volume || parseInt(elem.find('.js-volume-select-tag').val())
        amount: amount || parseInt(elem.find('.js_amount_input').val())
      dataType: "json"
      success: (data)=>
        $('.order_error_messages').html('')
        elem.find('.js_price_value').html(data.price.toFixed(2))
        elem.find('.js_price').show()
        elem.find('.js_deposit').html(data.deposit)
        if data.amount
          elem.find('.js_amount_input').val(data.amount)
        if parseFloat(data.price) > 1
          elem.find('.js_currency').show()
          @actualizeDeposit()
        else
          elem.find('.js_currency').hide()
      error: =>
        elem.find('.js_price_value').html('---')
        elem.find('.js_price').show()
        $('.order_error_messages').html('Некорректные параметры заказа, возможно,<br>необходимо увеличить количество товара')

  actualizeDeposit: ->
    sum = 0.0
    for dep in $('.js_products').find('.js_deposit')
      sum += parseFloat($(dep).html())
    sum
    $('.js_order_deposit').html(sum)

  actualizeAccessoryPrice: (elem, isPositive)->
    priceBlock = elem.find('.js_price')
    priceBlock.hide()
    price = parseFloat(priceBlock.data('price'))
    oldcost = parseFloat(elem.find('.js_price_value').html())
    newCost = if isPositive then oldcost+price else oldcost-price
    elem.find('.js_price_value').html(newCost.toFixed(2))
    priceBlock.show()

  getInfo: ->
    info = {}
    info['customer_type'] = $('.js_customer_type_selector').data('val')
    form = $(".js_#{info['customer_type']}")
    info['name'] = form.find('#name').val()
    info['phone'] = form.find('#phone').val()
    info['address'] = form.find('#address').val()
    info['date'] = $('.datepicker').val()
    info['time'] = $('.js_delivery_time_selector').data('val')
    info['comment'] = $('.js_comment').val()
    info['deposit'] = parseFloat($('.js_order_deposit').html())
    info['empty_bottles'] = $('.js_empty_bottles').is(':checked')
    info['register_flag'] = $('.js_order_register_flag').is(':checked')
    info

  getProducts: =>
    products = {}
    water_lines = $('.js_products').find('.water_template')
    accessory_lines = $('.js_products').find('.accessory_template')
    if water_lines.length > 0
      products['aquas'] = @getWaters(water_lines)
    if accessory_lines.length > 0
      products['accessories'] = @getAcessories(accessory_lines)
    products

  getWaters: (product_lines)->
    products = []
    for elem in product_lines
      line = $(elem)
      product = {}
      product['aqua'] = line.find('.js-aqua-select-tag').val()
      product['volume'] = line.find('.js-volume-select-tag').val()
      product['amount'] = line.find('.js_amount_input').val()
      product['price'] = parseFloat(line.find('.js_price_value').text())
      product['deposit'] = parseFloat(line.find('.js_deposit').text())
      products.push(product)
    products

  getAcessories: (product_lines)->
    products = []
    for elem in product_lines
      line = $(elem)
      product = {}
      product['name'] = line.find('.accessory_name').text().trim()
      product['amount'] = line.find('.js_accessory_amount').val()
      product['price'] = line.find('.js_price').data('price')
      product['info'] = line.data('id')
      product['step'] = line.find('.js_increment').last().data('step')
      products.push(product)
    products

  getOrderInfo: =>
    orderItems = @getProducts()
    info = @getInfo()
    { items: orderItems, info: info, ttl: (new Date()).getTime() }

  cacheData: =>
    $storage("prima_aqua_card").set(@getOrderInfo())


$(document).on 'click', '.variant', (e)->
  elem = $(e.currentTarget)
  unless  elem.hasClass('disabled') || elem.hasClass('active')
    selector = elem.closest('.custome_selector')
    selector.find('.variant').toggleClass('active')
    selector.data('val', elem.data('val'))

$ ->
  order = new Order
  someDate = new Date
  if someDate.getHours() >= 12
    someDate.setDate(someDate.getDate() + 1)
  $('.datepicker').datepicker(
    dayNamesMin: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"]
    dateFormat: "dd-mm-yy"
    firstDay: 1
    nextText: ">"
    prevText: "<"
    minDate: someDate
    defaultDate: someDate
    monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    onSelect: (date) ->
      order.checkAvailableTime()
  )

  $(document).on 'click', '.js_order_button', (e)->
    elem = $(e.currentTarget)
    $('.js_products').html('')
    window.hideSpinner()
    order.showModal()
    order.addAqua(elem) if elem.data().aqua
    yaCounter14311645.reachGoal('order');

  $(document).on 'click', '.js_add_accessory', (e)=>
    elem = $(e.currentTarget)
    $('.js_products').html('')
    order.showModal()
    order.insertProduct(elem)

  $(document).on 'closingOrder', ->
    if $('.thanks').hasClass('hidden_block')
      order.cacheData()
    else
      $('.thanks').addClass('hidden_block')
      $('.order').addClass('hidden_block')
      $('.card').removeClass('hidden_block')
