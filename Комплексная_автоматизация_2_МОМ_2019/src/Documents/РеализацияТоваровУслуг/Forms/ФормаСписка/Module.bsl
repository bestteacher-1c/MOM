
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Статус", Статус);
		СтруктураБыстрогоОтбора.Свойство("ВариантОформленияПродажи", ВариантОформленияПродажи);
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокРеализацииТоваровУслуг, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокРеализацииТоваровУслуг, "Статус", Статус, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(СписокРеализацииТоваровУслуг, 
		"ВариантОформленияПродажи",
		ВариантОформленияПродажи,
		СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.МенеджерРеализация.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.РеализацияТоваровУслуг));

	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьОтгрузкуБезПереходаПраваСобственности") Тогда
		
		Элемент = Элементы.Статус.СписокВыбора.НайтиПоЗначению(Перечисления.СтатусыРеализацийТоваровУслуг.ВПути);
		Если Элемент <> Неопределено Тогда
			Элементы.Статус.СписокВыбора.Удалить(Элемент);
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.СписокРеализацииТоваровУслугКоманднаяПанель);
	// Конец ИнтеграцияС1СДокументооборотом

	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ПодменюЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(ПараметрыПриСозданииНаСервере);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "СписокРеализацииТоваровУслуг.Дата", Элементы.СписокРеализацииТоваровУслугДата.Имя);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "СписокРеализацииТоваровУслуг";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокРеализацииТоваровУслуг, 
		"Менеджер", 
		Менеджер, 
		СтруктураБыстрогоОтбора,
		Настройки);
	
	Настройки.Вставить("Менеджер", Менеджер);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокРеализацииТоваровУслуг,
		"Статус",
		Статус,
		СтруктураБыстрогоОтбора,
		Настройки);
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(СписокРеализацииТоваровУслуг,
		"ВариантОформленияПродажи",
		ВариантОформленияПродажи,
		СтруктураБыстрогоОтбора,
		Настройки);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРеализацииТоваровУслуг

&НаКлиенте
Процедура СписокРеализацииТоваровУслугПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРеализацииТоваровУслуг,
		"Менеджер",
		Менеджер,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРеализацииТоваровУслуг, 
		"Статус",
		Статус,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОформленияПродажиПриИзменении(Элемент)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокРеализацииТоваровУслуг, 
		"ВариантОформленияПродажи",
		ВариантОформленияПродажи,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(ВариантОформленияПродажи));
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокРеализацииТоваровУслуг);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокРеализацииТоваровУслуг, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокРеализацииТоваровУслуг);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.СписокРеализацииТоваровУслуг);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ЭлектронноеВзаимодействие.ОбменСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.СписокРеализацииТоваровУслуг);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.РеализацияТоваровУслуг.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.СписокРеализацииТоваровУслуг.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
