#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

&НаКлиенте
Перем КэшРеквизитов;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.ПоказательРаспределения.СписокВыбора.Очистить();
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ВыручкаОтПродаж", НСтр("ru = 'Выручка от продаж'"));
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("СебестоимостьПродаж", НСтр("ru = 'Себестоимость продаж'"));
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ВаловаяПрибыль", НСтр("ru = 'Валовая прибыль'"));
	//++ НЕ УТ
	Элементы.ПоказательРаспределения.СписокВыбора.Добавить("ПрямыеЗатраты", НСтр("ru = 'Прямые производственные затраты'"));
	//-- НЕ УТ
	УТБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьСлужебныеРеквизитыФормы();
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьНадписьПериод();
	
	КэшРеквизитов = Новый Структура;
	КэшРеквизитов.Вставить("РегламентированныйУчет", Объект.РегламентированныйУчет);
	КэшРеквизитов.Вставить("УправленческийУчет", Объект.УправленческийУчет);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	РеквизитыОтборов = Новый Массив;
	//++ НЕ УТ
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоГруппамПродукции", "ГруппаПродукции"));
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоМатериалам", "Материал"));
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоВидамРабот", "ВидРабот"));
	//-- НЕ УТ
	РеквизитыОтборов.Добавить(Новый Структура("ОтборПоНаправлениямДеятельности", "НаправлениеДеятельности"));
	
	Для Каждого РеквизитСОтбором Из РеквизитыОтборов Цикл
		
		Для Каждого КлючИЗначение Из РеквизитСОтбором Цикл
			
			Объект[КлючИЗначение.Ключ].Очистить();
			Для Каждого Элемент Из ЭтаФорма[КлючИЗначение.Ключ] Цикл 
				
				НоваяСтрока = Объект[КлючИЗначение.Ключ].Добавить();
				НоваяСтрока[КлючИЗначение.Значение] = Элемент.Значение;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;	
	
	//++ НЕ УТ
	Если ПоказательРаспределения = "ПрямыеЗатраты" Тогда
		Возврат;
	КонецЕсли;
	//-- НЕ УТ
	
	ШаблонТипаБазы = "Перечисление.ТипыБазыРаспределенияРасходов.%1";
	Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение(СтрШаблон(ШаблонТипаБазы, ПоказательРаспределения));
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	Если ВладелецФормы <> Неопределено И ВладелецФормы.Имя = "СтатьиРасходов" Тогда
		
		ПараметрыПередачи = Новый Структура();
		ПараметрыПередачи.Вставить("Организация", Объект.Организация);
		ПараметрыПередачи.Вставить("Подразделение", Объект.Подразделение);
		ПараметрыПередачи.Вставить("СтатьяРасходов", Объект.СтатьяРасходов);
		ПараметрыПередачи.Вставить("АналитикаРасходов", Объект.АналитикаРасходов);
		ПараметрыПередачи.Вставить("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
		
		Если Объект.Проведен Тогда
			
			ДокументПередачи = Объект.Ссылка;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияРасходов.ГотовоКРаспределениюПоБазе");
				
		Иначе
			
			ДокументПередачи = Неопределено;
			Состояние = ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент");
				
		КонецЕсли;
		
		Если Объект.УправленческийУчет Или КэшРеквизитов.УправленческийУчет Тогда
			
			Если Не Объект.УправленческийУчет И КэшРеквизитов.УправленческийУчет Тогда
				
				ПараметрыПередачи.Вставить("ДокументУпр", Неопределено);				
				ПараметрыПередачи.Вставить("СостояниеУпр", 
					ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент"));
				
			Иначе
				
				ПараметрыПередачи.Вставить("ДокументУпр", ДокументПередачи);				
				ПараметрыПередачи.Вставить("СостояниеУпр", Состояние);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Объект.РегламентированныйУчет Или КэшРеквизитов.РегламентированныйУчет Тогда
			
			Если Не Объект.РегламентированныйУчет И КэшРеквизитов.РегламентированныйУчет Тогда
				
				ПараметрыПередачи.Вставить("ДокументРегл", Неопределено);				
				ПараметрыПередачи.Вставить("СостояниеРегл", 
					ПредопределенноеЗначение("Перечисление.СостоянияРаспределенияРасходов.ТребуетсяСформироватьДокумент"));
				
			Иначе
				
				ПараметрыПередачи.Вставить("ДокументРегл", ДокументПередачи);				
				ПараметрыПередачи.Вставить("СостояниеРегл", Состояние);
				
			КонецЕсли;
			
		КонецЕсли;
		Оповестить("Запись_РаспределениеПрочихЗатрат", ПараметрыПередачи);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ОбновитьНадписьПериод();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПравилаРаспределения

&НаКлиенте
Процедура ПоказательРаспределенияПриИзменении(Элемент)
	
	ОбработатьИзменениеПоказательРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеРаспределенияПриИзменении(Элемент)
	
	ОбработатьИзменениеНаправленияРаспределения();
	
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПоПартиямПриИзменении(Элемент)
	
	//++ НЕ УТ
	ОбработатьИзменениеБазаРаспределенияПоПартиям();
	//-- НЕ УТ
	// В УТ обработчик пустой.
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//++ НЕ УТ
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОтборБазы" Тогда
		
		ПараметрыОтбора = Новый Структура();
		ДопПараметрОтбора = "";
		
		ГруппаБазы = ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям);
		Если ГруппаБазы = "Материалы" Тогда
			
			ПараметрыОтбора.Вставить("МассивМатериалов", ОтборПоМатериалам.ВыгрузитьЗначения());
			ДопПараметрОтбора = "ОтборПоМатериалам";
			
		ИначеЕсли ГруппаБазы = "Трудозатраты" Тогда
			
			ПараметрыОтбора.Вставить("МассивВидовРабот", ОтборПоВидамРабот.ВыгрузитьЗначения());
			ДопПараметрОтбора = "ОтборПоВидамРабот";
			
		КонецЕсли;
		
		ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
				ПараметрыОтбора,
				ЭтаФорма,,,, 
				Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, ДопПараметрОтбора), 
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ГруппыПродукции" Тогда
		
		ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
				Новый Структура("МассивГруппПродукции", ОтборПоГруппамПродукции.ВыгрузитьЗначения()),
				ЭтаФорма,,,, 
				Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, "ОтборПоГруппамПродукции"), 
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
				
	КонецЕсли;
	//-- НЕ УТ
	Если НавигационнаяСсылкаФорматированнойСтроки = "НаправленияДеятельности" Тогда
		
		ПараметрыОтбора = Новый Структура("МассивНаправленийДеятельности", ОтборПоНаправлениямДеятельности.ВыгрузитьЗначения());
		ДопПараметрОтбора = "ОтборПоНаправлениямДеятельности";

		ОткрытьФорму("Справочник.ПравилаРаспределенияРасходов.Форма.ФормаОтбора",
				ПараметрыОтбора,
				ЭтаФорма,,,, 
				Новый ОписаниеОповещения("ЗавершитьПодборОтборов", ЭтотОбъект, ДопПараметрОтбора), 
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
				
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#Область БСП

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Подбор

&НаКлиенте
Процедура ЗавершитьПодборОтборов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ТипЗнч(Результат) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	Если ДополнительныеПараметры = "ОтборПоНаправлениямДеятельности" Тогда
		
		ОтборПоНаправлениямДеятельности.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоНаправлениямДеятельности(ЭтаФорма);
		
	//++ НЕ УТ
	ИначеЕсли ДополнительныеПараметры = "ОтборПоМатериалам" Тогда
		
		ОтборПоМатериалам.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоУказаннымПозициям(
			ЭтаФорма);
		
	ИначеЕсли ДополнительныеПараметры = "ОтборПоВидамРабот" Тогда
		
		ОтборПоВидамРабот.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоУказаннымПозициям(
			ЭтаФорма);
	ИначеЕсли ДополнительныеПараметры = "ОтборПоГруппамПродукции" Тогда
		
		Модифицированность = Истина;
		ОтборПоГруппамПродукции.ЗагрузитьЗначения(Результат);
		ОбработатьИзмененияОтбораПоГруппамПродукции(ЭтаФорма);
	//-- НЕ УТ	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИзмененийРеквизитов

&НаКлиенте
Процедура ОбработатьИзменениеНаправленияРаспределения()
	
	ОчиститьЗависимыеРеквизиты("НаправлениеРаспределения");
	
	УстановитьВидимостьСтраниц(ЭтаФорма, "НаправлениеРаспределения");
	УстановитьДоступностьЭлементов(ЭтаФорма, "НаправлениеРаспределения");
	УстановитьВидимостьЭлементов(ЭтаФорма, "НаправлениеРаспределения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеПоказательРаспределения()
	
	ОчиститьЗависимыеРеквизиты("ПоказательРаспределения");		
	УстановитьВидимостьЭлементов(ЭтаФорма, "ПоказательРаспределения");	
	
КонецПроцедуры

//++ НЕ УТ
&НаКлиенте
Процедура ОбработатьИзменениеБазаРаспределенияПоПартиям()
	
	Если (ОтборПоМатериалам.Количество()
			И Не ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям) = "Материалы") 
		Или (ОтборПоВидамРабот.Количество()
			И Не ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям) = "Трудозатраты") Тогда
		ОчиститьЗависимыеРеквизиты("БазаРаспределенияПоПартиям");
	Иначе
		ОбработатьИзмененияОтбораПоУказаннымПозициям(ЭтаФорма);
	КонецЕсли;
	
	НастроитьОформлениеПолей(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзмененияОтбораПоУказаннымПозициям(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ГруппаБазы = ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям);
	ИмяРеквизита = "";
	Если ГруппаБазы = "Материалы" Тогда
		
		ПредставлениеОтбора = СформироватьПредставлениеОтбора("ОтборБазы", Форма.ОтборПоМатериалам.ВыгрузитьЗначения());
		ИмяРеквизита = "ОтборПоМатериалам";
		
	ИначеЕсли ГруппаБазы = "Трудозатраты" Тогда

		ПредставлениеОтбора = СформироватьПредставлениеОтбора("ОтборБазы", Форма.ОтборПоВидамРабот.ВыгрузитьЗначения());
		ИмяРеквизита = "ОтборПоВидамРабот";
		
	КонецЕсли;
	
	Элементы.ПредставлениеОтбораПоУказаннымПозициямФР.Заголовок = ПредставлениеОтбора;
	НастроитьЗаголовкиПолей(Форма, ИмяРеквизита);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзмененияОтбораПоГруппамПродукции(Форма)
	
	Элементы = Форма.Элементы;
		
	Элементы.ПредставлениеОтбораПоГруппамПродукции.Заголовок = 
		СформироватьПредставлениеОтбора("ГруппыПродукции", 
			Форма.ОтборПоГруппамПродукции.ВыгрузитьЗначения(), 
			НСтр("ru = 'группа, группы, групп'"), 
			НСтр("ru = 'Указать группы (виды) продукции'"));
		
	НастроитьЗаголовкиПолей(Форма, "ОтборПоГруппамПродукции");
	
КонецПроцедуры

//-- НЕ УТ

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьИзмененияОтбораПоНаправлениямДеятельности(Форма)
	
	Элементы = Форма.Элементы;
			
	Элементы.ПредставлениеУказанныхНД.Заголовок = 
		СформироватьПредставлениеОтбора("НаправленияДеятельности", Форма.ОтборПоНаправлениямДеятельности.ВыгрузитьЗначения(), 
			НСтр("ru = 'направление деятельности, направления деятельности, направлений деятельности'"));
		
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьПредставлениеОтбора(Гиперссылка, СписокОтбора, ПредметИсчисления = Неопределено, ТекстУказатьПустоеЗначение = "")
	
	Если СписокОтбора.Количество() = 0 Тогда
		
		Если ПустаяСтрока(ТекстУказатьПустоеЗначение) Тогда
			ТекстУказать = НСтр("ru = 'Указать'");
		Иначе
			ТекстУказать = ТекстУказатьПустоеЗначение;
		КонецЕсли;
		
		Возврат Новый ФорматированнаяСтрока(ТекстУказать,,,, Гиперссылка);
		
	КонецЕсли;	
	
	Возврат ПредставлениеОтбора(СписокОтбора, ПредметИсчисления, Гиперссылка);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПредставлениеОтбора(СписокОтбора, ПредметИсчисления, Гиперссылка)
	
	
	ПредставлениеОтбора = Справочники.ПравилаРаспределенияРасходов.ПредставлениеОтобранныхПозиций(СписокОтбора, ПредметИсчисления);
	ФорматированноеПредставлениеОтбора = Новый ФорматированнаяСтрока(ПредставлениеОтбора,, ЦветаСтиля.ПоясняющийТекст);
	
	ПодстрокаИзменить = Новый ФорматированнаяСтрока(НСтр("ru = '(Изменить)'"),,,, Гиперссылка);
	
	Возврат Новый ФорматированнаяСтрока(ФорматированноеПредставлениеОтбора,
		?(ПустаяСтрока(ФорматированноеПредставлениеОтбора), "", " "),
		ПодстрокаИзменить);
	
КонецФункции

#КонецОбласти

#Область БСП

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область УправлениеФормой

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьСтраниц(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = Неопределено Или ИмяРеквизита = "НаправлениеРаспределения" Тогда
		
		Элементы.ОписаниеПравилаНаФинансовыйРезультат.Видимость = 
			Не Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам")
			И Не Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.Текущее");
			
		Элементы.СтраницаНаправленияДеятельности.Видимость = 
			Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам");
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементов(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = "НаправлениеРаспределения" Или ИмяРеквизита = Неопределено Тогда
		Элементы.ПредставлениеУказанныхНД.Видимость = 
			Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.Указанные");
	КонецЕсли;
	
	Если ИмяРеквизита = "ПоказательРаспределения" Или ИмяРеквизита = Неопределено Тогда
		Элементы.ГруппаБазаРаспределенияНаФР.Видимость = Форма.ПоказательРаспределения = "ПрямыеЗатраты";
		//++ НЕ УТ
		Элементы.ГруппаОтборПоГруппамПродукции.Видимость = Форма.АналитическийУчетПоГруппамПродукции
			Или Форма.ОтборПоГруппамПродукции.Количество();
		//-- НЕ УТ
	КонецЕсли;
	
	Если ИмяРеквизита = Неопределено Тогда
		
		Элементы.ГруппаВидыУчета.Видимость = Не Форма.УТБазовая;
		Элементы.НастройкаРаспределенияНеТребуется.Видимость = 
			Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.Текущее");
		Элементы.ГруппаКудаРаспределять.Видимость = Не Элементы.НастройкаРаспределенияНеТребуется.Видимость;
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = Неопределено Тогда
		
		ВариантыРаспределения = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Объект.СтатьяРасходов, 
			"ВариантРаспределенияРасходовРегл, ВариантРаспределенияРасходовУпр");
		Элементы.ГруппаВидыУчета.Доступность = 
			ВариантыРаспределения.ВариантРаспределенияРасходовРегл = ВариантыРаспределения.ВариантРаспределенияРасходовУпр;
		Элементы.НаправлениеРаспределенияМеждуНД.Доступность = 
			Не Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.Текущее");
		
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ
&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОформлениеПолей(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.БазаРаспределенияНаФР.ОтметкаНезаполненного = Форма.ПоказательРаспределения = "ПрямыеЗатраты" 
		И Не ЗначениеЗаполнено(Объект.БазаРаспределенияПоПартиям);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗаголовкиПолей(Форма, ИмяРеквизита = Неопределено)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если ИмяРеквизита = "ОтборПоМатериалам" Или ИмяРеквизита = "БазаРаспределенияПоПартиям" 
		Или ИмяРеквизита = Неопределено Тогда
		
		Если Форма.ОтборПоМатериалам.Количество() Тогда
			Элементы.ЗаголовокОтбораПоУказаннымПозициямФР.Заголовок = НСтр("ru = 'По указанным материалам'");
		ИначеЕсли ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям) = "Материалы" Тогда
			Элементы.ЗаголовокОтбораПоУказаннымПозициямФР.Заголовок = НСтр("ru = 'Без отбора по материалам'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяРеквизита = "ОтборПоВидамРабот" Или ИмяРеквизита = "БазаРаспределенияПоПартиям" 
		Или ИмяРеквизита = Неопределено Тогда
		
		Если Форма.ОтборПоВидамРабот.Количество() Тогда
			Элементы.ЗаголовокОтбораПоУказаннымПозициямФР.Заголовок = НСтр("ru = 'По указанным видам работ'");
		ИначеЕсли ГруппаПоБазеРаспределения(Объект.БазаРаспределенияПоПартиям) = "Трудозатраты" Тогда
			Элементы.ЗаголовокОтбораПоУказаннымПозициямФР.Заголовок = НСтр("ru = 'Без отбора по видам работ'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяРеквизита = "ОтборПоГруппамПродукции" Или ИмяРеквизита = Неопределено Тогда
		
		Если Форма.ОтборПоГруппамПродукции.Количество() Тогда
			Элементы.ЗаголовокОтбораПоГруппамПродукции.Заголовок = НСтр("ru = 'На указанные группы продукции'");
		Иначе
			Элементы.ЗаголовокОтбораПоГруппамПродукции.Заголовок = НСтр("ru = 'На все группы продукции'");
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.БазаРаспределенияПоПартиям)
		Или Объект.БазаРаспределенияПоПартиям = ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат") Тогда
		Элементы.ЗаголовокОтбораПоУказаннымПозициямФР.Заголовок = НСтр("ru = 'Отбор недоступен.'");
	КонецЕсли;
		
КонецПроцедуры

//-- НЕ УТ
#КонецОбласти

#Область ИнициализацияФормы

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ОпределитьВидимостьИСуммуРасходовПоСтатье();
	
	ЗаполнитьСлужебныеРеквизитыФормы();
	
	УстановитьВидимостьСтраниц(ЭтаФорма);
	УстановитьВидимостьЭлементов(ЭтаФорма);
	УстановитьДоступностьЭлементов(ЭтаФорма);
	//++ НЕ УТ
	НастроитьОформлениеПолей(ЭтаФорма);
	НастроитьЗаголовкиПолей(ЭтаФорма);
	//-- НЕ УТ
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыФормы()
	
	УстановитьЗаголовокФормы();
	
	//++ НЕ УТ
	АналитическийУчетПоГруппамПродукции = ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции");
	
	ОтборПоМатериалам.ЗагрузитьЗначения(Объект.ОтборПоМатериалам.Выгрузить(, "Материал").ВыгрузитьКолонку("Материал"));
	ОтборПоВидамРабот.ЗагрузитьЗначения(Объект.ОтборПоВидамРабот.Выгрузить(, "ВидРабот").ВыгрузитьКолонку("ВидРабот"));
	ОтборПоГруппамПродукции.ЗагрузитьЗначения(Объект.ОтборПоГруппамПродукции.Выгрузить(, "ГруппаПродукции").ВыгрузитьКолонку("ГруппаПродукции"));
	ОбработатьИзмененияОтбораПоГруппамПродукции(ЭтаФорма);	
	ОбработатьИзмененияОтбораПоУказаннымПозициям(ЭтаФорма);
	//-- НЕ УТ
	ОтборПоНаправлениямДеятельности.ЗагрузитьЗначения(
		Объект.ОтборПоНаправлениямДеятельности.Выгрузить(, "НаправлениеДеятельности").ВыгрузитьКолонку("НаправлениеДеятельности"));
	ОбработатьИзмененияОтбораПоНаправлениямДеятельности(ЭтаФорма);
	
	ПоказательРаспределения = ОпределитьЗначениеПоказателяРаспределения(Объект.БазаРаспределенияПоПартиям);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()
	
	ПредставлениеОбъекта = Метаданные.Документы.РаспределениеПрочихЗатрат.РасширенноеПредставлениеОбъекта;
	УточнениеПредставленияОбъекта = НСтр("ru = 'между направлениями деятельности'");
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ШаблонЗаголовка = НСтр("ru = '%1 %2 (создание)'");
		Заголовок = СтрШаблон(ШаблонЗаголовка, ПредставлениеОбъекта, УточнениеПредставленияОбъекта);
		
	Иначе
		
		ШаблонЗаголовка = НСтр("ru = '%1 %2 №%3 от %4'");
		Заголовок = СтрШаблон(ШаблонЗаголовка, ПредставлениеОбъекта, 
								УточнениеПредставленияОбъекта,
								Объект.Номер,
								Формат(Объект.Дата, "ДЛФ=DT"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписьПериод()

	НадписьПериод = ПредставлениеПериода(НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата), "ДЛФ=D");
	
КонецПроцедуры

#КонецОбласти
//++ НЕ УТ
#Область РаботаСТипамиБаз

&НаКлиентеНаСервереБезКонтекста
Функция ГруппаПоБазеРаспределения(БазаРаспределения)
	
	БазыРаспределенияПоГруппам = БазыРаспределенияПоГруппам();
	
	Если Не БазыРаспределенияПоГруппам.Материалы.Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Материалы";
	ИначеЕсли Не БазыРаспределенияПоГруппам.Трудозатраты.Найти(БазаРаспределения) = Неопределено Тогда
		Возврат "Трудозатраты";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция БазыРаспределенияПоГруппам()
	
	Материалы = Новый Массив;
	Материалы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаМатериальныхЗатрат"));
	Материалы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоУказанныхМатериалов"));
	Материалы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ВесУказанныхМатериалов"));
	Материалы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.ОбъемУказанныхМатериалов"));
	
	Трудозатраты = Новый Массив;
	Трудозатраты.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.СуммаРасходовНаОплатуТруда"));
	Трудозатраты.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда"));
	Трудозатраты.Добавить(ПредопределенноеЗначение("Перечисление.ТипыБазыРаспределенияРасходов.КоличествоРаботУказанныхВидов"));
	
	ГруппыБаз = Новый Структура;
	ГруппыБаз.Вставить("Материалы", Материалы);
	ГруппыБаз.Вставить("Трудозатраты", Трудозатраты);
	
	Возврат ГруппыБаз;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область КонтрольИзмененийРеквизитов

&НаКлиенте
Процедура ОбработатьИзменениеРеквизитов(ИмяРеквизита)
	
	Если ИмяРеквизита = "ПоказательРаспределения" Тогда
		ОбработатьИзменениеПоказательРаспределения();
	ИначеЕсли ИмяРеквизита = "НаправлениеРаспределения" Тогда
		ОбработатьИзменениеНаправленияРаспределения();
	//++ НЕ УТ	
	ИначеЕсли ИмяРеквизита = "ОтборПоМатериалам" 
		Или ИмяРеквизита = "ОтборПоВидамРабот"
		Или ИмяРеквизита = "ОтборПоПродукции" Тогда
		ОбработатьИзмененияОтбораПоУказаннымПозициям(ЭтаФорма);
	ИначеЕсли ИмяРеквизита = "ОтборПоГруппамПродукции" Тогда
		ОбработатьИзмененияОтбораПоГруппамПродукции(ЭтаФорма);
	//-- НЕ УТ
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОчиститьЗависимыеРеквизиты(ИмяРеквизита)
	
	СтруктураЗависимыхРеквизитов = ЗависимыеРеквизиты(ИмяРеквизита);
	
	Для Каждого РеквизитФормы Из СтруктураЗависимыхРеквизитов.РеквизитыФормы Цикл
		
		Если ТипЗнч(ЭтаФорма[РеквизитФормы]) = Тип("ДанныеФормыКоллекция") Тогда
			ЭтаФорма[РеквизитФормы].Очистить();
		Иначе
			ЭтаФорма[РеквизитФормы] = Неопределено;
		КонецЕсли;
		
		ОбработатьИзменениеРеквизитов(РеквизитФормы);
		
	КонецЦикла;
	
	Для Каждого РеквизитОбъекта Из СтруктураЗависимыхРеквизитов.РеквизитыОбъекта Цикл
		
		Если ТипЗнч(Объект[РеквизитОбъекта]) = Тип("ДанныеФормыКоллекция") Тогда
			Объект[РеквизитОбъекта].Очистить();
		Иначе
			Объект[РеквизитОбъекта] = Неопределено;
		КонецЕсли;
		
		ОбработатьИзменениеРеквизитов(РеквизитОбъекта);
		
	КонецЦикла;
	
	Возврат СтруктураЗависимыхРеквизитов;
	
КонецФункции

&НаКлиенте
Функция ЗависимыеРеквизиты(Реквизит)
	
	РеквизитыФормы = Новый Массив;
	РеквизитыОбъекта = Новый Массив;
	
	Если Реквизит = "НаправлениеРаспределения" Тогда
		
		РеквизитыФормы.Добавить("ОтборПоНаправлениямДеятельности");
		РеквизитыОбъекта.Добавить("НаправленияДеятельности");
		
		Если Объект.НаправлениеРаспределения = ПредопределенноеЗначение("Перечисление.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам") Тогда
			РеквизитыФормы.Добавить("ПоказательРаспределения");
		КонецЕсли;
		
	ИначеЕсли Реквизит = "ПоказательРаспределения" Тогда
		РеквизитыОбъекта.Добавить("БазаРаспределенияПоПартиям");
	//++ НЕ УТ
		РеквизитыФормы.Добавить("ОтборПоГруппамПродукции");
	ИначеЕсли Реквизит = "БазаРаспределенияПоПартиям" Тогда
		
		РеквизитыФормы.Добавить("ОтборПоМатериалам");
		РеквизитыФормы.Добавить("ОтборПоВидамРабот");
	//-- НЕ УТ
	КонецЕсли;
	
	Возврат Новый Структура("РеквизитыФормы, РеквизитыОбъекта", РеквизитыФормы, РеквизитыОбъекта);
		
КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОпределитьВидимостьИСуммуРасходовПоСтатье()
	
	Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	*
		|ИЗ
		|	РегистрНакопления.ДвиженияНоменклатураДоходыРасходы.Обороты(
		|			&ДатаНачала,
		|			&ДатаОкончания,
		|			,
		|			СтатьяДоходовРасходов = &Статья
		|				И АналитикаРасходов = &Аналитика) КАК Движения");
	
	Запрос.УстановитьПараметр("Статья", Объект.СтатьяРасходов);
	Запрос.УстановитьПараметр("Аналитика", Объект.АналитикаРасходов);
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецМесяца(Объект.Дата));
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЕстьОборотыПоСтатье = НЕ Запрос.Выполнить().Пустой();
	Если НЕ ЕстьОборотыПоСтатье Тогда
		Элементы.ГруппаСуммы.Видимость = Истина;
		Элементы.ГруппаБезСумм.Видимость = Ложь;
	Иначе
		Элементы.ГруппаСуммы.Видимость = Ложь;
		Элементы.ГруппаБезСумм.Видимость = Истина;
	КонецЕсли;
	
	Если ЕстьОборотыПоСтатье Тогда
		Возврат;
	КонецЕсли;
	
	ПоддерживаемыеВариантыРаспределения = Новый Массив();
	//++ НЕ УТ
	ПоддерживаемыеВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты);
	//-- НЕ УТ
	ПоддерживаемыеВариантыРаспределения.Добавить(Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности);
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.РаспределениеПрочихЗатрат.ТекстЗапросаПоступилоПрочихРасходов() + "
		|ВЫБРАТЬ
		|	Т.Сумма,
		|	Т.СуммаРегл,
		|	Т.ВременнаяРазница
		|ИЗ
		|	РасходыКРаспределению КАК Т
		|ГДЕ
		|	Т.СтатьяРасходов = &Статья
		|	И Т.АналитикаРасходов = &Аналитика
		|	И Т.НаправлениеДеятельности = &НаправлениеДеятельности";
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Объект.Дата));
	Запрос.УстановитьПараметр("ГраницаКонецПериода", Новый Граница(КонецМесяца(Объект.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("МассивОрганизаций", Объект.Организация);
	Запрос.УстановитьПараметр("СписокПодразделений", Объект.Подразделение);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", Ложь);
	Запрос.УстановитьПараметр("ПоВсемПодразделениям", Ложь);
	Запрос.УстановитьПараметр("Статья", Объект.СтатьяРасходов);
	Запрос.УстановитьПараметр("Аналитика", Объект.АналитикаРасходов);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", Объект.НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ВариантыРаспределенияРасходов", ПоддерживаемыеВариантыРаспределения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ШаблонПредставления = НСтр("ru = '%1 (%2)'");
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ПоступилоУпр = 0;
	ПоступилоРегл = 0;
	ПоступилоВременнаяРазница = 0;
	
	Если Выборка.Следующий() Тогда
		Сумма = Выборка.Сумма;
		СуммаРегл = Выборка.СуммаРегл;
		ВременнаяРазница = Выборка.ВременнаяРазница;
	КонецЕсли;
	
	Элементы.Сумма.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонПредставления,
		Сумма,
		ВалютаУпр);
	Элементы.СуммаРегл.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонПредставления,
		СуммаРегл,
		ВалютаРегл);
	Элементы.СуммаВР.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонПредставления,
		ВременнаяРазница,
		ВалютаРегл);
		
	Элементы.ГруппаРегл.Видимость = (Не СуммаРегл = 0);
	//++ НЕ УТ
	Элементы.ГруппаВР.Видимость = 
		УчетнаяПолитика.ВедетсяУчетПостоянныхИВременныхРазниц(Объект.Организация, Объект.Дата)
		И Не ВременнаяРазница = 0;
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОпределитьЗначениеПоказателяРаспределения(База)
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.ВаловаяПрибыль Тогда
		Возврат "ВаловаяПрибыль";
	КонецЕсли;
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.СебестоимостьПродаж Тогда
		Возврат "СебестоимостьПродаж";
	КонецЕсли;
	
	Если База = Перечисления.ТипыБазыРаспределенияРасходов.ВыручкаОтПродаж Тогда
		Возврат "ВыручкаОтПродаж";
	КонецЕсли;
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(База) Тогда
		Возврат "ПрямыеЗатраты";
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#КонецОбласти
