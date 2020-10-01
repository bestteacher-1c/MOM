#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	#Область СтандартныеПодсистемы
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПереоценкаНМА2_4", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьИнформациюОДокументеВДругомУчете();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПереоценкаНМА2_4" Тогда
		ЗаполнитьИнформациюОДокументеВДругомУчете();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	Объект.ОтражатьВУпрУчете = (ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете")
		Или ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
	Объект.ОтражатьВРеглУчете = (ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
		Или ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
		
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ОтражатьВУпрУчете, ОтражатьВРеглУчете");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	
	СтатьяДоходовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяДоходовПриИзмененииНаСервере()
	
	АналитикаДоходовОбязательна = ЗначениеЗаполнено(Объект.СтатьяДоходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	ДоходыИРасходыСервер.СтатьяДоходовПриИзменении(Объект, Объект.СтатьяДоходов, Объект.Подразделение, Объект.АналитикаДоходов);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна = ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, Объект.СтатьяРасходов, Объект.АналитикаРасходов);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДокументеВДругомУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#СоздатьДокумент" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ПереоценкаНМА2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)

	ПереоценкаНМАКлиентЛокализация.ПриИзмененииРеквизита(Элемент, ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНМА

&НаКлиенте
Процедура НМАОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.НМА, "НематериальныйАктив", ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыПодбора = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.НМАНематериальныйАктив, ЭтаФорма);
	ОткрытьФорму(
		"Справочник.НематериальныеАктивы.ФормаВыбора",
		ПараметрыПодбора,
		Элементы.НМА,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ИнициализацияФормыПриСозданииНаСервере();
	
	АналитикаРасходовОбязательна = ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
	ЗаполнитьИнформациюОДокументеВДругомУчете();
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, ИзмененныеРеквизиты = "")
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", Форма.ВедетсяРегламентированныйУчетВНА);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", Форма.ВалютыСовпадают);
	
	ПараметрыРеквизитовОбъекта =  ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПереоценкаНМА(
									Форма.Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
	
	ВнеоборотныеАктивыКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДокументеВДругомУчете()
	
	ВнеоборотныеАктивыСлужебный.ЗаполнитьИнформациюОДокументеВДругомУчете(Объект, Элементы);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()

	ЗаполнитьВариантОтраженияВУчете();

	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Если ВедетсяРегламентированныйУчетВНА Тогда
		
		Элементы.НМАСтоимостьУУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма упр. (%1)'"), Строка(ВалютаУпр));
		Элементы.НМАСтоимостьБУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма регл. (%1)'"), Строка(ВалютаРегл));
		
	Иначе
		
		Если ВалютыСовпадают Тогда
			Элементы.НМАСтоимостьУУ.Заголовок = НСтр("ru = 'Сумма'");
			Элементы.НМАСтоимостьБУ.Заголовок = НСтр("ru = 'Сумма'");
		Иначе
			Элементы.НМАСтоимостьУУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма (%1)'"), Строка(ВалютаУпр));
			Элементы.НМАСтоимостьБУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма (%1)'"), Строка(ВалютаРегл));
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантОтраженияВУчете()
	
	Если Объект.ОтражатьВУпрУчете И Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
	ИначеЕсли Объект.ОтражатьВУпрУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
	ИначеЕсли Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЗавершение(ИмяЭлемента, ДополнительныеПараметры) Экспорт

	Если ДополнительныеПараметры.ТребуетсяВызовСервера Тогда
		ПриИзмененииРеквизитаЗавершениеНаСервере(ИмяЭлемента, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаЗавершениеНаСервере(Знач ИмяЭлемента, Знач ДополнительныеПараметры)
	Перем ПараметрыДействия;
	
	ПереоценкаНМАЛокализация.ПриИзмененииРеквизита(ИмяЭлемента, ЭтаФорма, ДополнительныеПараметры);

	Если ДополнительныеПараметры.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормы(ЭтаФорма, ПараметрыДействия);
	КонецЕсли; 
	Если ДополнительныеПараметры.Свойство("Выполнить_ЗаполнитьВариантОтраженияВУчете") Тогда
		ЗаполнитьВариантОтраженияВУчете();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти