#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ПроверкаКонтрагентовПараметрыОбработчикаОжидания Экспорт;

&НаКлиенте
Перем ФормаДлительнойОперации Экспорт;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	ОписаниеТиповДокументРасчетов = Метаданные.Документы.ЗаписьКнигиПокупок.Реквизиты.ДокументРасчетов.Тип;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриСозданииНаСервереДокумент(ЭтотОбъект, Параметры);
	ПроверкаКонтрагентовВызовСервераПереопределяемыйУТ.ФормаДокументаПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	Если Объект.СпособКорректировкиНДС <> ПредопределенноеЗначение("Перечисление.СпособыКорректировкиНДС.Скорректировать") Тогда
		Объект.ПредъявленСчетФактура	= Ложь;
	КонецЕсли;
	
	Если НЕ Объект.ПредъявленСчетФактура Тогда
		Объект.ДатаСчетаФактуры			= '00010101';
		Объект.НомерСчетаФактуры		= "";
		Получен = Ложь;
	КонецЕсли;
	
	Если НЕ Получен Тогда
		Объект.ДатаПолучения = '00010101';
		Объект.ПолученВЭлектронномВиде = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПараметрыДействия = Новый Структура("Номенклатура", "ВедетсяУчетПоГТД");
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакВедетсяУчетПоГТД", ПараметрыДействия);

	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Ценности,СтруктураДействий);
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	//++ НЕ УТ
	РеглУчетВызовСервера.ЗаполнитьПредставлениеСчетаРеглУчетаВТЧ(Объект.Ценности);
	//-- НЕ УТ
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ЗаписьКнигиПокупок", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереДокумент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииДокумент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПриЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	НеобходимоПересчитатьВалюту(Новый ОписаниеОповещения("ВалютаПриИзмененииЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если Результат Тогда
        
        ПриИзмененииВалютыСервер(Объект.Валюта);
        ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаДокумента, Объект.Валюта);
        
    КонецЕсли;
    
    ВалютаДокумента = Объект.Валюта;

КонецПроцедуры

&НаКлиенте
Процедура ПредъявленСчетФактураПриИзменении(Элемент)
	
	УстановитьДоступностьРеквизитовСчетФактуры(ЭтаФорма);
	Если НЕ Объект.ПредъявленСчетФактура Тогда
		Получен = Ложь;
	КонецЕсли;
	УстановитьДоступностьРеквизитовПолучения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписьДополнительногоЛистаПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовДопЛистов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРасчетовПриИзменении(Элемент)
	
	ПриИзмененииОперацииДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ДокументРасчетов = Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДоступныеТипы", ОписаниеТиповДокументРасчетов);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыборТипаДокументаРасчетов", ЭтотОбъект);
		ОткрытьФорму("ОбщаяФорма.ВыборТипаИзСписка", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументРасчетовОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Объект.ДокументРасчетов = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособКорректировкиНДСПриИзменении(Элемент)
	
	ПриИзмененииОперацииДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииПриИзменении(Элемент)
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("КодВидаОперацииНачалоВыбораЗавершение", ЭтотОбъект), СписокКодовВидовОпераций, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КодВидаОперацииНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		Объект.КодВидаОперации = ВыбранныйЭлемент.Значение;
		ОбновитьПредставлениеВидаОперации(ЭтаФорма);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаСчетаФактурыПриИзменении(Элемент)
	
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	УстановитьДоступностьРеквизитовПолучения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(Истина);
	УстановитьДоступностьРеквизитовСчетФактуры(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииСервер();
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Объект.Дата);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если СписокВыбораКПП.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(Объект.Контрагент) Тогда
			ЗаполнитьСписокВыбораКПП(СписокВыбораКПП, Объект.Контрагент, Объект.Дата);
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеВыбора = СписокВыбораКПП;
	
КонецПроцедуры

&НаКлиенте
Процедура КППКонтрагентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ИННКонтрагентаПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентовВДокументе(ЭтотОбъект, Элемент);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЦенности

&НаКлиенте
Процедура ЦенностиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	//++ НЕ УТ
	Если Поле = Элементы.ЦенностиСчетРеглУчета Тогда
		РеглУчетКлиент.ОткрытьНастройкуОтраженияВРеглУчетеАктиваПассиваСтрокиТЧ(ЭтаФорма, "Ценности", ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиПослеУдаления(Элемент)
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Ценности.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиСтавкаНДСПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Ценности.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Ценности.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",
		Новый Структура("НалогообложениеНДС, Дата", НалогообложениеНДС, Объект.Дата));
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД", Новый Структура("Номенклатура", "ВедетсяУчетПоГТД"));

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Ценности"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	ОбновитьСуммыПодвала(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ЦенностиВидЦенностиПриИзменении(Элемент)
	
	ВидЦенностиПриИзмененииСервер(Элементы.Ценности.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенностиКоличествоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Ценности.ТекущиеДанные;
	
	// Изменим знак в суммах
	Если ТекущаяСтрока.Количество < 0 И ТекущаяСтрока.Сумма > 0 
		ИЛИ ТекущаяСтрока.Количество >= 0 И ТекущаяСтрока.Сумма < 0 Тогда
		ТекущаяСтрока.Сумма = -ТекущаяСтрока.Сумма;
	КонецЕсли; 
	Если ТекущаяСтрока.Количество < 0 И ТекущаяСтрока.СуммаНДС > 0 
		ИЛИ ТекущаяСтрока.Количество >= 0 И ТекущаяСтрока.СуммаНДС < 0 Тогда
		ТекущаяСтрока.СуммаНДС = -ТекущаяСтрока.СуммаНДС;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыОплаты

&НаКлиенте
Процедура ДокументыОплатыДокументОплатыПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДокументыОплаты.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущаяСтрока.ДокументОплаты) Тогда
		ТекущаяСтрока.ДатаОплаты = ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(ТекущаяСтрока.ДокументОплаты, "Дата");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
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

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеНомераГТД(ЭтаФорма,
															 "ЦенностиНомерГТД",
															 "Объект.Ценности.ВедетсяУчетПоГТД");
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДатаСчетаФактуры.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомерСчетаФактуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПредъявленСчетФактура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//++ НЕ УТ
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦенностиСчетРеглУчета.Имя);
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",  ЦветаСтиля.ЦветГиперссылки);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦенностиСчетРеглУчета.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Ценности.ПредставлениеОтраженияВРеглУчете");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",  НСтр("ru = 'Настроить'"));
	
	//-- НЕ УТ
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

// Пересчитывает суммы документа в выбранную валюту
//
// Параметры:
// НоваяВалюта - Валюта, в которую необходимо пересчитать суммы.
//
&НаСервере
Процедура ПриИзмененииВалютыСервер(НоваяВалюта)
	
	СтараяВалюта                = ВалютаДокумента;
	ДатаДокумента               = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	СтруктураКурсовСтаройВалюты = РаботаСКурсамиВалют.ПолучитьКурсВалюты(СтараяВалюта, ДатаДокумента);
	СтруктураКурсовНовойВалюты  = РаботаСКурсамиВалют.ПолучитьКурсВалюты(НоваяВалюта,  ДатаДокумента);
	
	Для Каждого ТекСтрока Из Объект.Ценности Цикл
		
		ТекСтрока.Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
			ТекСтрока.Сумма,
			СтруктураКурсовСтаройВалюты,
			СтруктураКурсовНовойВалюты);
			
		ТекСтрока.СуммаНДС = ЦенообразованиеКлиентСервер.РассчитатьСуммуНДС(ТекСтрока.Сумма, ТекСтрока.СтавкаНДС, Ложь);
		
	КонецЦикла;
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
КонецПроцедуры

// Изменяет видимость, доступность реквизитов
//
&НаКлиенте
Процедура ПриИзмененииОперацииДокумента()

	УстановитьВидимостьЭлементовПоОперации(ЭтаФорма, ОтложитьНДС, ЗаблокироватьНДС);
	
	Если Объект.ПредъявленСчетФактура Тогда
		Если Объект.СпособКорректировкиНДС = ОтложитьНДС 
			ИЛИ Объект.СпособКорректировкиНДС = ЗаблокироватьНДС Тогда
			
			Объект.ПредъявленСчетФактура = Ложь;
			УстановитьДоступностьРеквизитовСчетФактуры(ЭтаФорма);
			Получен = Ложь;
			УстановитьДоступностьРеквизитовПолучения(ЭтаФорма);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОтобразитьРезультатПроверкиКонтрагента() Экспорт
	ПроверкаКонтрагентов.ОтобразитьРезультатПроверкиКонтрагентаВДокументе(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания) Экспорт	
	ПроверкаКонтрагентов.ПроверитьКонтрагентовВДокументеФоновоеЗадание(ЭтотОбъект, ПараметрыФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьКонтрагентов(Команда)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПроверитьКонтрагентовВДокументеПоКнопке(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	// Константы
	ОтложитьНДС      = Перечисления.СпособыКорректировкиНДС.Отложить;
	ЗаблокироватьНДС = Перечисления.СпособыКорректировкиНДС.Заблокировать;
	НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;

	ВалютаДокумента = Объект.Валюта;
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы();
	УстановитьВидимостьЭлементовПоОперации(ЭтаФорма, ОтложитьНДС, ЗаблокироватьНДС);
	УстановитьДоступностьРеквизитовСчетФактуры(ЭтаФорма);
	УстановитьДоступностьЭлементовДопЛистов(ЭтаФорма);
	
	ПараметрыДействия = Новый Структура("Номенклатура", "ВедетсяУчетПоГТД");
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакВедетсяУчетПоГТД", ПараметрыДействия);
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Ценности, СтруктураДействий);
	
	//++ НЕ УТ
	РеглУчетВызовСервера.ЗаполнитьПредставлениеСчетаРеглУчетаВТЧ(Объект.Ценности);
	//-- НЕ УТ
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаОснование", "Видимость", ЗначениеЗаполнено(Объект.ДокументОснование));
	
	ОбновитьСуммыПодвала(ЭтаФорма);
	
	Получен = ЗначениеЗаполнено(Объект.ДатаПолучения);
	УстановитьДоступностьРеквизитовПолучения(ЭтаФорма);
	
	ЗаполнитьСписокКодовВидовОпераций();
	УстановитьСвязиПараметровВыбораДокументаРасчетов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстСообщенияДатаПолучения = НСтр("ru = 'Поле ""Дата получения"" не заполнено'");
	
	Если Получен И НЕ ЗначениеЗаполнено(Объект.ДатаПолучения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияДатаПолучения,,"ДатаПолучения","Объект",Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеобходимоПересчитатьВалюту(Знач Оповещение)

	Если Не ЗначениеЗаполнено(Объект.Валюта) Тогда
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		Возврат;
	ИначеЕсли ВалютаДокумента = Объект.Валюта Тогда
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		Возврат;
	ИначеЕсли Объект.Ценности.Итог("Сумма") = 0 Тогда
		ВыполнитьОбработкуОповещения(Оповещение, Ложь);
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru='Пересчитать суммы в документе в валюту %1 ?'");
	ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Объект.Валюта);
	
	ОтветНаВопрос = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("НеобходимоПересчитатьВалютуЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)), ТекстСообщения, РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура НеобходимоПересчитатьВалютуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ОтветНаВопрос = РезультатВопроса;
    
    Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
        ВыполнитьОбработкуОповещения(Оповещение, Истина);
        Возврат;
    Иначе
        ВыполнитьОбработкуОповещения(Оповещение, Ложь);
        Возврат;
    КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьЭлементовПоОперации(Форма, ОтложитьНДС, ЗаблокироватьНДС)

	ЭтоКорректировкаНДСКВычету = ЗначениеЗаполнено(Форма.Объект.ДокументРасчетов);
	ЭтоРаспределениеНДС = Форма.Объект.СпособКорректировкиНДС = ОтложитьНДС ИЛИ Форма.Объект.СпособКорректировкиНДС = ЗаблокироватьНДС; 
	
	//Операция "корректировка НДС"
	Форма.Элементы.ЦенностиВидЦенности.Видимость = НЕ ЭтоРаспределениеНДС;
	Форма.Элементы.ЦенностиСобытие.Видимость = НЕ ЭтоРаспределениеНДС;
	
	//Операция "распределение НД"
	Форма.Элементы.ЦенностиНоменклатура.Видимость = ЭтоРаспределениеНДС;
	Форма.Элементы.ЦенностиКоличество.Видимость   = ЭтоРаспределениеНДС;
	
	// Операция "НДС к вычету"
	Форма.Элементы.ПредъявленСчетФактура.Доступность = НЕ ЭтоРаспределениеНДС;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРеквизитовСчетФактуры(Форма)
	
	Форма.Элементы.ДатаСчетаФактуры.Доступность  = Форма.Объект.ПредъявленСчетФактура;
	Форма.Элементы.НомерСчетаФактуры.Доступность = Форма.Объект.ПредъявленСчетФактура;
	Форма.Элементы.Получен.Доступность           = Форма.Объект.ПредъявленСчетФактура;
	
	ТипКонтрагентаКонтрагент = ТипЗнч(Форма.Объект.Контрагент) = Тип("СправочникСсылка.Контрагенты");
	
	Форма.Элементы.ИННКонтрагента.Доступность = ТипКонтрагентаКонтрагент 
	                                            И ЗначениеЗаполнено(Форма.Объект.Контрагент);
	Форма.Элементы.КППКонтрагента.Доступность = ТипКонтрагентаКонтрагент
	                                            И ЗначениеЗаполнено(Форма.Объект.Контрагент)
	                                            И Форма.КонтрагентЮрЛицо;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовДопЛистов(Форма)

	Форма.Элементы.КорректируемыйПериод.Доступность = Форма.Объект.ЗаписьДополнительногоЛиста; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСуммыПодвала(Форма)

	Форма.СуммаВсего = Форма.Объект.Ценности.Итог("Сумма") + Форма.Объект.Ценности.Итог("СуммаНДС");

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПересчетСуммыНДСВСтрокеТЧ()

	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Ложь);
	
	Возврат СтруктураЗаполненияЦены;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРеквизитовПолучения(Форма)
	
	Форма.Элементы.ДатаПолучения.Доступность			= Форма.Получен;
	Форма.Элементы.ПолученВЭлектронномВиде.Доступность	= Форма.Получен;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеВидаОперации(Форма)
	
	ТекущийКод = Форма.СписокКодовВидовОпераций.НайтиПоЗначению(Форма.Объект.КодВидаОперации);
	Если ТекущийКод <> Неопределено Тогда
		Форма.ПредставлениеВидаОперации = Сред(ТекущийКод.Представление, 4);
	Иначе
		Форма.ПредставлениеВидаОперации = "";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидЦенностиПриИзмененииСервер(ИдентификаторСтроки)
	
	//++ НЕ УТ
	ТекущаяСтрока = Объект.Ценности.НайтиПоИдентификатору(ИдентификаторСтроки);
	ОтражениеВРеглУчете = Документы.ЗаписьКнигиПокупок.ОтражениеВРеглУчете(
		ТекущаяСтрока.ВидЦенности, Объект.Контрагент, Объект.ДокументРасчетов);
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ОтражениеВРеглУчете);
	ТекущаяСтрока.ПредставлениеОтраженияВРеглУчете = РеглУчетВызовСервера.ПредставлениеОтраженияВРеглУчете(ТекущаяСтрока);
	//-- НЕ УТ
	Возврат;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКодовВидовОпераций()
	
	Если ЗначениеЗаполнено(Объект.ДатаПолучения) Тогда
		ДатаКодовВидовОпераций = Объект.ДатаПолучения;
	ИначеЕсли ЗначениеЗаполнено(Объект.Дата) Тогда
		ДатаКодовВидовОпераций = Объект.Дата;
	Иначе
		ДатаКодовВидовОпераций = ТекущаяДатаСеанса();
	КонецЕсли;
	
	УчетНДС.ЗаполнитьСписокКодовВидовОпераций(
		Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры,
		СписокКодовВидовОпераций,
		ДатаКодовВидовОпераций);
	
	ОбновитьПредставлениеВидаОперации(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыборТипаДокументаРасчетов(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = ПараметрыОткрытияФормыВыбораДокументаРасчетов(Результат);
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораДокументРасчетов", ЭтотОбъект);
	ОткрытьФорму(
		ПараметрыФормы.ИмяФормыВыбора, 
		ПараметрыФормы.ПараметрыОткрытия, 
		ЭтаФорма, 
		, 
		, 
		, 
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораДокументРасчетов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Объект.ДокументРасчетов = Результат;
		УстановитьСвязиПараметровВыбораДокументаРасчетов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыВыбораДокументаРасчетов(ТипЗначения)
	
	Если ТипЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФормыВыбора = Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя() + ".ФормаВыбора";
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормыВыбора", ИмяФормыВыбора);
	
	Отбор = Новый Структура;
	Для каждого Параметр Из СвязиПараметрыОтбора(ТипЗначения) Цикл
		Отбор.Вставить(Параметр.Ключ, Объект[Параметр.Значение]);
	КонецЦикла;
	
	Результат.Вставить("ПараметрыОткрытия", Новый Структура("Отбор", Отбор));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвязиПараметрыОтбора(ТипЗначения)
	
	СвязиПараметрыОтбора = Новый Структура;
	Если ТипЗначения = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Организация");
	Иначе
		СвязиПараметрыОтбора.Вставить("Организация", "Организация");
	КонецЕсли;
		
	Возврат СвязиПараметрыОтбора;
	
КонецФункции

&НаСервере
Процедура УстановитьСвязиПараметровВыбораДокументаРасчетов()
	
	ПараметрыОтбора = СвязиПараметрыОтбора(ТипЗнч(Объект.ДокументРасчетов));
	
	МассивОтборов = Новый Массив;
	Для каждого Отбор Из ПараметрыОтбора Цикл
		МассивОтборов.Добавить(Новый СвязьПараметраВыбора("Отбор." + Отбор.Ключ, "Объект." + Отбор.Значение));
	КонецЦикла;
	
	ДокументРасчетовПараметрыВыбора = Новый ФиксированныйМассив(МассивОтборов);
	Элементы.ДокументРасчетов.СвязиПараметровВыбора =ДокументРасчетовПараметрыВыбора;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ИзменятьИННКПП = Ложь) Экспорт
	
	УчетНДСРФ.ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(ЭтотОбъект, Объект.Дата, ИзменятьИННКПП);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораКПП(СписокВыбора, Контрагент, ДатаСведений)
	
	УчетНДСРФ.ЗаполнитьСписокВыбораКППСчетФактурыПолученные(СписокВыбора, Контрагент, ДатаСведений);
	
КонецПроцедуры

Процедура ДатаПриИзмененииСервер()
	
	ЗаполнитьЗависимыеОтКонтрагентаРеквизитыФормы(Истина);
	ЗаполнитьСписокКодовВидовОпераций();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
