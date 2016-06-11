$(document).ready(function(){
  $('.delivery-body-text-search').bind('keyup', function() {
    $('.delivery-body-text form').delay(200).submit();
  });
  $('.close-modal > img').click(function(){
    $('#dialog').hide();
  });
  $('.delivery-list-group-item > a').click(function(e) {
    e.preventDefault();
    $('#dialog').show();
    $('.dialog-text').html($($(this).attr('popup')).text());
    var linkToDistrict = "/districts/"+$(this).attr('district_id');
    $('.dialog-text').append($("<div><a href="+linkToDistrict+">Подробнее</a></div>"));

    // код выбирает как разместить окно диалога на экране относительно выбранного элемента
    if ( document.documentElement && document.documentElement.clientWidth >= 992 ){
      $('#dialog').css('left', $(this).position().left + $(this).width() + 10);
      $('#dialog').css('top', $(this).position().top - 7);
      $('#tail1').show();
      $('#tail2').show();
    }else{
      var padding = 20;
      var clientWidth = document.documentElement.clientWidth;
      var left = $(this).position().left + $(this).width() + 10 - 210;
      var top = $(this).position().top - 7 + 30;

      left = left <= padding ? padding : left > clientWidth - padding - $('#dialog').width() ? 'auto' : left;

      $('#dialog').css('right', padding );
      $('#dialog').css('left', left );
      $('#dialog').css('top', top );
      $('#tail1').hide();
      $('#tail2').hide();
    }

  });
});

ymaps.ready(init);
function init() {
  var myMap = new ymaps.Map('delivery-body-map', {
    center: [59.980488, 30.02889],
    zoom: 7.7
  });
  $.each(gon.district, function(index, value) {
    myMap.geoObjects.add(
      new ymaps.Placemark([value.lat, value.lon],
        {
          body: value.map_popup || value.name
        },
        {
          // Опции.
          // Необходимо указать данный тип макета.
          iconLayout: 'default#image',
          // Своё изображение иконки метки.
          iconImageHref: '/assets/office.png',
          // Размеры метки.
          iconImageSize: [30, 42],
          // Смещение левого верхнего угла иконки относительно
          // её "ножки" (точки привязки).
          iconImageOffset: [-3, -42],
          balloonContentBodyLayout : ymaps.templateLayoutFactory.createClass('<div>$[properties.body]</div>')
        }
      )
    );
    myMap.controls.add("zoomControl");
  });
};
