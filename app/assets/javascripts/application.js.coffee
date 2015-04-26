# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require select2
#= require prices
#= require order
#= require jquery-ui/datepicker

showPhoneModal = ->
  $('.js_modal_back').show()
  $('.js_modal_phone').show()

closeModals = ->
  #if $('.js_modal_order').is(":visible")
  #  $storage("prima_state_card").set($('.prima_state_card').html())
  $('.js_modal_back').hide()
  $('.js_modal').hide()

showNotice = (msg) ->
  noticeModal = $('.js_modal_notice')
  noticeModal.find('.modal__title').html(msg)
  $('.js_modal').hide()
  noticeModal.show()

showSignIn = ->
  $('.js_modal_back').show()
  $('.js_login').show()

showRegistration = ->
  $('.js_modal_back').show()
  $('.js_registration_modal').show()

$(document).on 'click', '.header__contacts', (e)->
  e.preventDefault()
  showPhoneModal()

$(document).on 'click', '.js_sign_in', ->
  showSignIn()

$(document).on 'click', '.js_register', ->
  closeModals()
  showRegistration()

$(document).on 'click', '.js_order_signin', ->
  closeModals()
  showSignIn()

$(document).on 'click', '.js_modal', (e)->
  e.stopPropagation()

$(document).on 'click', '.js_modal_back', ->
  if $('.js_modal_order').is(':visible')
    $(document).trigger('closingOrder')
  closeModals()

$(document).on 'click', '.modal__view', ->
  if $('.js_modal_order').is(':visible')
    $(document).trigger('closingOrder')
  closeModals()

$(document).on 'click', '.js_close_button', ->
  if $('.js_modal_order').is(':visible')
    $(document).trigger('closingOrder')
  closeModals()

$(document).on 'click', '.js_order_finish', ->
  if $('.js_modal_order').is(':visible')
    $(document).trigger('closingOrder')
  closeModals()

submitPhoneCall = (name, time, phone)->
  $.ajax
    url: '/phone_calls'
    type: 'POST'
    dataType: "json"
    data:
      name: name
      phone: phone
      time: time
    success: (data)->
      showNotice('Ваш заказ принят в обработку')
      setTimeout(closeModals, 2000)
    error: (xhr)->
      closeModals()
      alert 'Упс! Что-то пошло не так.'

submitService = (name, address, phone)->
  $.ajax
    url: '/services'
    type: 'POST'
    dataType: "json"
    data:
      name: name
      phone: phone
      address: address
    success: (data)->
      showNotice('Ваш заказ принят в обработку')
      setTimeout(closeModals, 2000)
    error: (xhr)->
      closeModals()
      alert 'Упс! Что-то пошло не так.'

$(document).on 'click', '.js_phone_call_submit', ->
  phone = $('.js_phone').val()
  name = $('.js_name').val()
  time = $('.js_time').val()
  if phone && name && time
    submitPhoneCall(name, time, phone)
  else
    $('.modal_error').removeClass('modal_error')
    unless time
      $('.js_time').closest(".input_set").addClass('modal_error')
    unless name
      $('.js_name').closest(".input_set").addClass('modal_error')
    unless phone
      $('.js_phone').closest(".input_set").addClass('modal_error')

$(document).on 'click', 'div.service-body_imgs-img > div > a', (e)->
  e.preventDefault()
  showServiceModal()

showServiceModal = ->
  $('.js_modal_back').show()
  $('.js_modal_service').show()

$(document).on 'click', '.js_service_submit', ->
  phone = $('.js_service_phone').val()
  name = $('.js_service_name').val()
  address = $('.js_service_address').val()
  if phone && name && address
    submitService(name, address, phone)
  else
    $('.modal_error').removeClass('modal_error')
    unless address
      $('.js_service_address').closest(".input_set").addClass('modal_error')
    unless name
      $('.js_service_name').closest(".input_set").addClass('modal_error')
    unless phone
      $('.js_service_phone').closest(".input_set").addClass('modal_error')

$ ->
  $('.header__actions').slick({
    infinite: true,
    speed: 300,
    slidesToShow: 1,
    adaptiveHeight: true
    prevArrow: '<button type="button" class="slick-prev"><</button>'
    nextArrow: '<button type="button" class="slick-next">></button>'
  });
