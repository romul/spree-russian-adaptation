Russian Adaptation
==================

### If you don’t speak Russian

This extension adapts Spree to the Russian reality.

### Что это?

Это расширение предназначено для адаптации интернет-магазина Spree к российским реалиям.


Что готово:

* Модифицирует процесс оформления заказа
* Добавляет распечатку квитанции Сбербанка для оплаты заказа (настройки в `config/settings.yml`)
* Локализует javascript-файлы, такие как `taxonomy.js`
* Подменяет все вызовы хелпера text_area на ckeditor_textarea (требуется установка плагина rails-ckeditor)
* Вывод цен в российском формате
* Возможность оплаты заказов через RoboKassa
* Замещает конфигурационные данные при `rake db:bootstrap` на российские.



**Важно:** текущая версия расширения предназначена для Spree 0.10.x и не будет работать с Spree 0.9.x 

Для Spree 0.50.0+ существует альтернативный проект - [Synergy](https://github.com/secoint/synergy)
