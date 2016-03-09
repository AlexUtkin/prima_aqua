class FillPageContents < ActiveRecord::Migration
  def up
    PageContent.create(
      relation: 'payment',
      main_text: "<div class=\"payment_page\">\r\n<div class=\"payment_page__header\">\r\n<h1>Оплата для физических лиц</h1>\r\n</div>\r\n<div class=\"payment_page__title\">\r\n<h2>Оплата наличными.</h2>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nОплата производится курьеру при получении товара\r\n</div>\r\n<div class=\"payment_page__title\">\r\n<h2>По банковской карте.</h2>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nВ нашей работе мы используем программу и картридеры 2can, с помощью них Вы сможете оплатить Ваш заказ при получении с помощью банковской карты. К сожалению, в данный момент не все наши экипажи оснащены необходимыми устройствами, поэтому возможность оплаты по картам присутствует не на всех маршрутах\r\n</div>\r\n<br>\r\n<div class=\"payment_page__header\">\r\n<h1>Оплата для юридических лиц</h1>\r\n</div>\r\n<div class=\"payment_page__title\">\r\n<h2>По безналичному счету.</h2>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nОплата осуществляется только после заключения договора.\r\n</div>\r\n<div class=\"payment_page__title\">\r\n<h2>Оплата наличными.</h2>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nОплата производится курьеру при получении товара\r\n</div>\r\n<br>\r\n<div class=\"payment_page__header\">\r\n<h1>Бесплатная доставка</h1>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nДоставка осуществляется бесплатно при следующих условиях:\r\n<br>\r\n1) заказ от одной 19л. бутыли воды\r\n<br>\r\n2) заказ от шести 6 или 8 - литровых бутылей воды\r\n<br>\r\n3) заказ только сопутствующих товаров на сумму от 1000 руб.\r\n</div>\r\n<br>\r\n<div class=\"payment_page__header\">\r\n<h1>Платная доставка</h1>\r\n</div>\r\n<div class=\"payment_page__text\">\r\nМы запустили быструю и удобную доставку воды. Мы готовы привезти воду в любое удобное для вас время (+- 15 минут) ежедневно и круглосуточно.\r\n<br>\r\nCтоимость услуги составляет 150 рублей.\r\n</div>\r\n</div>",
      seo_title: 'Способы оплаты при заказе воды на дом или в офис',
      seo_description: 'Оплата заказа',
      seo_keywords: 'виза, мастер кард, процесс оплаты'
    )
  end

  def down
    PageContent.find_by_relation(:payment).try(:delete)
  end
end
