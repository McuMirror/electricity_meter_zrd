# Electricity Meter Zigbee TLSR8258 (E-Byte E180-Z5812SP)

## Устройство для дистанционного мониторинга многотарифных однофазных счетчиков с последующей передачей показаний в Home Assistant.

**Включает в себя схему опротопорта и модуль от E-Byte E180-Z5812SP, который работает, как Zigbee-роутер**

Not finished! In the process!

[Repository electricity_meter_zrd](https://github.com/slacky1965/electricity_meter_zrd)  
[Схема устройства](https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/Schematic_Electricity_Meter_zrd.jpg)

---

# Внимание!!! Плата не заказана и не протестированна!!! Это пока только для ознакомления!!!

---

**Описание**

* Рассчитано на взаимодействие через оптопорт с однофазными многотарифными электросчетчиками:

	- Каскад-1МТ  
	- Каскад-11 (требует более глубокого тестирования, нет счетчика под рукой)  
	- Меркурий-206  
	- Энергомера-СЕ102М  
	- Нева-МТ124  
	- Нартис-100  

* Модуль посылает команды электросчетчику и принимает ответы от него. В настоящий момент устройство может прочитать

	- 4 тарифа (в kWh)
	- силу тока (если доступно, в A)
	- напряжение сети (если доступно, в V)
	- мощность (если доступно, в W)
	- оставшийся ресурс батарии прибора (если доступно, в %)
	- полный серийный номер прибора (например 3171112520109)
	- дату изготовления прибора (если доступно, например 04.10.2017)

* Сохраняет в энергонезависимой памяти модуля только конфигурационные данные.
* Передает показания по сети Zigbee.
* Взаимодейстивие с "умными домами" через zigbee2mqtt.
* Первоначальная настройка происходит через web-интерфейс zigbee2mqtt.
* Сбросить устройство до заводских значений (zigbee) - нажать кнопку 5 раз.
* Сделать restart модуля - зажать кнопку более чем на 5 секунд.
* [Компиляция](#title1)  
* [Прошивка](#title2)
* [Принцип работы](#title3)
* [Настройка](#title4)  

---



Проверялось на этом.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/tlsr8258_dongle.jpg"/>

Будет сделано на этом.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/E180-Z5812SP.jpg"/>

Схема.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/Schematic_Electricity_Meter_zrd.jpg"/>

Плата разведена, но не заказана и не протестирована.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/board/board_top.jpg"/>

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/board/board_bottom.jpg"/>

Вот под такую вилку из Леруа Мерлен

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/box/box1.jpg"/>

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/box/box4.jpg"/>

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/box/81930756_03.jpg"/>

Полигон :))

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/prototype.jpg"/>

---

## <a id="title1">Компиляция</a>

[Скачиваем проект](https://github.com/slacky1965/electricity_meter_zrd)  
Если скачали архивом, разворачиваем в какой-нибудь временной директории. Далее запускаем Eclipse. В левом верхнем углу нажимаем File, в развернувшемся меню выбираем Import

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse1.jpg"/>

Далее выбираем `Existing Project into Workspace` и жмем `Next`.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse2.jpg"/>

В открывшемся окне по очереди выбираем 

1. `Browse` - находим директорию, куда скачали и развернули проект.
2. Ставим галочку в `Projects:` на появившемся проекте.
3. Ставим галочку на `Copy projects into workspace`
4. Жмем `Finish`

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse3.jpg"/>

Все, проект у нас в Эклипсе. 

	Небольшое отступление. В данном проекте OTA отключена. Связано это с нем, что при конфигурации с OTA на  
	TLSR8258F512 отведено под прошивку только 0x34000 байт. И даже, если применить модуль TLST8258F1 с 1мБ -
	это все равно не сильно исправляет ситуацию, в нем отведено место под прошивку 0x40000. К чему все это.
	Размер прошивки с 4 счетчиками подошел к своему пределу, что-то около 200000 байт. Если предположить, что
	счетчики будут добавляться, то мы в самом ближайшем будущем столкнемся с тем, что прошивка превысит размер
	выделенного под нее пространстсва. Раздельная компиляция для конкретного счетчика мне не понравилась, там
	вылезли свои глюки. Потому было принято решение остановиться на схеме с использованием `bootloader'a`. При
	таком решении и отключенном OTA, размер прошивки может достигать более 400 кБ, что достаточно много. Карту
	памяти можно посмотреть тут - tl_zigbee_sdk/proj/drivers/drv_nv.h.

Далее нужен компилятор и кое-какие утилиты. Компилятор можно скачать у [Telink'a](https://wiki.telink-semi.cn/wiki/IDE-and-Tools/IDE-for-TLSR8-Chips/). Установщик поставит IDE (правленый Эклипс) и компилятор с утилитами. Но мне такой венегрет не нравится, поэтому я пользуюсь обычным Эклипсом и makefile. Так же компилятор есть у [Ai-Thinker](https://github.com/Ai-Thinker-Open/Telink_825X_SDK). Там есть под Windows и под Linux. Так же советую скачать [git bash for windows](https://git-scm.com/download/win). Это позволит писать makefiles, которые будут прекрасно работать и под Windows и под Linux практически без редактирования. Еще понадобится Python, но я думаю, это не проблема. Не забудьте отредактировать в makefile и bootloader.makefile пути к компилятору, если он у вас лежит в другом месте.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse8.jpg"/>

Итак, компиляцию начинаем с `bootloader`. Собираем и прошиваем ([как и чем шить чуть ниже](#title2)). Если модуль пустой, то после прошивки `bootloader'a` модуль просто начнет моргать светодиодом. Это нормально.  

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse4.jpg"/>

Далее компилируем уже саму прошивку и прошиваем.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/eclipse/eclipse6.jpg"/>

Если все прошло без ошибок, то модуль запустится и начнет работу.

И последнее - проект сделан таким образом, что его можно вообще собрать без IDE, обычнам make в командной строке.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/make.jpg"/>

## <a id="title2">Прошивка</a>

Вопрос - как залить прошивку в модуль. Есть несколько вариантов. Самый простой, это приобрести у Telink их фирменный программатор.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/telink_pgm.jpg"/>

Но он неоправдано дорого стоит. Есть другой, более бюджетный вариант. Заказываем модуль TB-04 или [TB-03](http://www.ai-thinker.com/pro_view-89.html) от Ai-Thinker. Почему-то у самого производителя TB-04 не числится. Но на aliexpress их полно. В них применен TLSR8253. Паяем перемычку согласно фото.

<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/TB-03F-KIT-PGM.gif"/>
<img src="https://raw.githubusercontent.com/slacky1965/electricity_meter_zrd/main/doc/images/TB-04-KIT-wire.jpg"/>

И заливаем прошивку [вот отсюда](https://github.com/pvvx/TLSRPGM/tree/main/sources/UART2SWire/tb-0x-pgm)

Все, у нас есть недорогой программатор, который может загружать прошивки через SWS в модули от Telink'a.  
Сама программа-прошивальщик лежит [тут](https://github.com/pvvx/TLSRPGM)

## <a id="title3">Принцип работы</a>

Устройство является роутером, питается от сети ~200 вольт и никогда не спит.  
По умолчанию считывание показаний с электросчетчика происходит один раз в минуту. Изменить в большую сторону можно через интерфейс zigbee2mqtt во вкладке Exposes ([подробней о настройках чуть ниже](#title4)).

**Reporting**

Устройство высылает 20 отчетов.

	* Температура (1)
	* Четыре тарифа (4)
	* Множитель и делитель тарифов (2)
	* Остаточный процент жизни батарейки электросчетчика (1)
	* Серийный номер электросчетчика (1)
	* Дата изготовления электросчетчика (1)
	* Наименование электросчетчика (1)
	* Напряжение сети (1)
	* Множитель и делитель для напряжения сети (2)
	* Сила тока (1)
	* Множитель и делитель силы тока (2)
	* Мощность (1)
	* Множитель и делитель для мощности (2)

Настроить периоды отправки сообщений, если не устроят по умолчанию, можно в интерфейсе zigbee2mqtt во вкладке reporting([подробней о настройках чуть ниже](#title4)).

**Сетодиодная индикация режимов модуля**

Красный светодиод сигнализирует о присутствии питания на модуле.  
Зеленый светодиод служит для информирования о режимах работы модуля.

	- Одна вспышка - модуль в сети, считывание данных с электросчетчика успешно.
	- Две вспышки - модуль в сети, считывание данных с электросчетчика не происходит.
	- Три вспышки - модуль не в сети, считывание данных с электросчетчика успешно.
	- Четыре вспышки - модуль не в сети, считывание данных с электросчетчика не происходит.
	
**Память модуля и где хранится конфиг**

Согласно спецификации на чип TLSR8258F512ET32 при использовании `bootloader'a` память распределена следующим образом

		0x00000 Bootloader
		0x08000 Firmware
		0x39000 OTA Image
		0x6A000 NV_1
		0x76000 MAC address
		0x77000 C_Cfg_Info
		0x78000 U_Cfg_Info
		0x7A000 NV_2
		0x80000 End Flash

Так, как OTA не используется, то прошивка может занимать оба пространства `Firmware` и `OTA Image`, что в сумме составляет 0x62000 (401408) байтов. `bootloader` ничего не умеет, кроме, как запускать прошивку с адреса 0x8000.

В конфиге сохраняютстя только настройки модуля. Конфиг записывается в NV_2 (куда-то в область с 0x7a000 по 0x7c000). Используется модуль NV_MODULE_APP с номером NV_ITEM_APP_USER_CFG (для понимания смотрите app_cfg.h и sdk/proj/drivers/drv_nv.h)
	
## <a id="title4">Настройка</a>
