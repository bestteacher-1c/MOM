
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
		
		Если Объект.СтатьяРасходов = Неопределено Тогда
			Объект.СтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
		КонецЕсли;
		
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
	
	Оповестить("Запись_СписаниеНМА2_4", ПараметрыЗаписи, Объект.Ссылка);
	
	СписаниеНМАКлиентЛокализация.ПослеЗаписи(Объект);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
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
	
	Если ИмяСобытия = "Запись_СписаниеНМА2_4" Тогда
		ЗаполнитьИнформациюОДокументеВДругомУчете();
	КонецЕсли;
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.НематериальныеАктивы.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.НМА.Добавить().НематериальныйАктив = ЭлементМассива;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
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
Процедура ЭлементПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаСервере("Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормыНаСервере("Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	Объект.ОтражатьВУпрУчете = (ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете")
		Или ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
	Объект.ОтражатьВРеглУчете = (ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
		Или ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
		
	Если НЕ Объект.ОтражатьВРеглУчете Тогда
		Объект.СчетУчета = Неопределено;
		Объект.Субконто1 = Неопределено;
		Объект.Субконто2 = Неопределено;
		Объект.Субконто3 = Неопределено;
	КонецЕсли;
		
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ОтражатьВУпрУчете, ОтражатьВРеглУчете");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатьяРасходовВыборЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Статья", Объект.СтатьяРасходов);
	ПараметрыФормы.Вставить("ПараметрыВыбора", Элемент.ПараметрыВыбора);
	
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораСтатьи", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		ИЛИ АналитикаРасходовЗаказРеализация
	Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст)
		ИЛИ АналитикаРасходовЗаказРеализация
	Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДокументеВДругомУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#СоздатьДокумент" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.СписаниеНМА2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#Область Локализация

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)

	СписаниеНМАКлиентЛокализация.ПриИзмененииРеквизита(Элемент.Имя, ЭтаФорма);

КонецПроцедуры

#КонецОбласти

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

&НаКлиенте
Процедура НастроитьОтражениеВРеглУчете(Команда)
	
	РеглУчетКлиент.ОткрытьНастройкуОтраженияВРеглУчетеАктиваПассива(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#Область ПодключаемыеКоманды

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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЗавершение(ИмяЭлемента, ДополнительныеПараметры) Экспорт

	Если ДополнительныеПараметры.ТребуетсяВызовСервера Тогда
		ПриИзмененииРеквизитаЗавершениеНаСервере(ИмяЭлемента, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаЗавершениеНаСервере(ИмяЭлемента, ДополнительныеПараметры)

	СписаниеНМАЛокализация.ПриИзмененииРеквизита(ИмяЭлемента, ЭтаФорма, ДополнительныеПараметры);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление, "СтатьяРасходов, АналитикаРасходов");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ИнициализацияФормыПриСозданииНаСервере();
	
	Если Объект.ОтражатьВУпрУчете И Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
	ИначеЕсли Объект.ОтражатьВУпрУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
	ИначеЕсли Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	КонецЕсли;
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		Элементы.СтатьяРасходов.Заголовок = НСтр("ru = 'Статья расходов'");
	КонецЕсли;
	
	СписаниеНМАЛокализация.ПриЧтенииСозданииНаСервере(ЭтаФорма);
		
	ЗаполнитьИнформациюОДокументеВДругомУчете();
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()

	ЗаполнитьСлужебныеПараметрыФормы();
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Элементы.НМАСуммаСписанияУУ.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("НМА.СуммаСписанияУУ");
	Элементы.НМАСуммаСписанияБУ.Заголовок = СлужебныеПараметрыФормы.ПредставлениеРеквизитов.Получить("НМА.СуммаСписанияБУ");
	Элементы.ГруппаРеглУчет.Заголовок = СтрШаблон(НСтр("ru = 'Регламентированный учет (%1)'"), Строка(ВалютаРегл));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеПараметрыФормы()

	НовыеСлужебныеПараметрыФормы = Новый Структура;
	НовыеСлужебныеПараметрыФормы.Вставить("ПредставлениеРеквизитов", Документы.СписаниеНМА2_4.ПредставлениеРеквизитов());
	
	СлужебныеПараметрыФормы = Новый ФиксированнаяСтруктура(НовыеСлужебныеПараметрыФормы);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, ИзмененныеРеквизиты = "")
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = (СтруктураИзмененныхРеквизитов.Количество() = 0);
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", Форма.ВедетсяРегламентированныйУчетВНА);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", Форма.ВалютыСовпадают);
	ВнеоборотныеАктивыКлиентСерверЛокализация.ДополнитьВспомогательныеРеквизиты_СписаниеНМА(Форма, ВспомогательныеРеквизиты);
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_СписаниеНМА(
									Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
	
	ВнеоборотныеАктивыКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ЧастичнаяЛиквидация")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ ОбновитьВсе Тогда
		
		Если НЕ Объект.ОтражатьВРеглУчете 
			ИЛИ НЕ Объект.ЧастичнаяЛиквидация Тогда
			
			Элементы.НМАСуммаСписанияБУ.Видимость = Ложь;
			Элементы.НМАСуммаСписанияБУ_Расширенная.Видимость = Ложь;
			
		ИначеЕсли НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
			
			Элементы.НМАСуммаСписанияБУ.Видимость = Истина;
			Элементы.НМАСуммаСписанияБУ_Расширенная.Видимость = Ложь;
			Элементы.ГруппаРеглУчет.Видимость = Ложь;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ВнеоборотныеАктивыКлиентСерверЛокализация.НастроитьЗависимыеЭлементыФормы_СписаниеНМА(
		Форма, ВспомогательныеРеквизиты, СтруктураИзмененныхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(Знач ИзмененныеРеквизиты = "")

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = (СтруктураИзмененныхРеквизитов.Количество() = 0);
	
	Если СтруктураИзмененныхРеквизитов.Свойство("Организация") 
		ИЛИ ОбновитьВсе Тогда
		
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СтатьяРасходов") 
		ИЛИ ОбновитьВсе Тогда
		
		Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
			
			АналитикаРасходовОбязательна = Ложь;
			АналитикаРасходовЗаказРеализация = Ложь;
			
		Иначе
			
			АналитикаРасходовОбязательна = 
				ЗначениеЗаполнено(Объект.СтатьяРасходов)
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
				
			АналитикаРасходовЗаказРеализация = 
				ЗначениеЗаполнено(Объект.СтатьяРасходов)
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
			
		КонецЕсли;
		
		НаСтатьиАктивовПассивов = (ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов"));
		Элементы.АналитикаРасходов.Видимость = НЕ НаСтатьиАктивовПассивов;
		Элементы.АналитикаРасходов.Доступность = ЗначениеЗаполнено(Объект.СтатьяРасходов);
		Элементы.АналитикаАктивовПассивов.Видимость = НаСтатьиАктивовПассивов;
		Элементы.АналитикаАктивовПассивов.Доступность = 
			ЗначениеЗаполнено(Объект.СтатьяРасходов) 
			И Не ТипЗнч(Объект.АналитикаАктивовПассивов) = Тип("ПеречислениеСсылка.СтатьиБезАналитики");
			
		Элементы.АналитикаРасходов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаРасходов)));
		Элементы.АналитикаАктивовПассивов.ОграничениеТипа = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(Объект.АналитикаАктивовПассивов)));
			
	КонецЕсли;

	СписаниеНМАЛокализация.НастроитьЗависимыеЭлементыФормы(ЭтаФорма, СтруктураИзмененныхРеквизитов);
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДокументеВДругомУчете()
	
	ВнеоборотныеАктивыСлужебный.ЗаполнитьИнформациюОДокументеВДругомУчете(Объект, Элементы);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Объект.СтатьяРасходов = Результат;
		СтатьяРасходовПриИзмененииСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер()
	
	Если ТипЗнч(Объект.СтатьяРасходов) = Тип("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов") Тогда
		
		ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаАктивовПассивов);
			
		Объект.АналитикаРасходов = Неопределено;
		
	Иначе
		
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
			Объект,
			Объект.СтатьяРасходов,
			Объект.АналитикаРасходов);
		
		Объект.АналитикаАктивовПассивов = Неопределено;
		
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормыНаСервере("СтатьяРасходов");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

#КонецОбласти