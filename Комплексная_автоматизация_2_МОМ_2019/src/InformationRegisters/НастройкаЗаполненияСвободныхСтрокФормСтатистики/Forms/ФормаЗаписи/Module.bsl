#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// Инициализация служебных параметров отбора.
	ОписанияТиповВидовСубконто = Новый Структура;
	ОписанияТиповВидовСубконто.Вставить("Номенклатура"                  , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура.ТипЗначения);
	ОписанияТиповВидовСубконто.Вставить("Склад"                         , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады.ТипЗначения);
	ОписанияТиповВидовСубконто.Вставить("Контрагент"                    , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты.ТипЗначения);
	ОписанияТиповВидовСубконто.Вставить("ДоговорКонтрагента"            , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры.ТипЗначения);
	ОписанияТиповВидовСубконто.Вставить("Партия"                        , ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии.ТипЗначения);
	ОписанияТиповВидовСубконто.Вставить("ДокументРасчетовСКонтрагентами", ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами.ТипЗначения);
	
	ИнициализироватьНастройки();

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Запишем пользовательские настройки и их представление.
	ЗаполнитьЗначенияСвойств(ТекущийОбъект, ЗаполнениеФормСтатистики.СериализоватьРезультатНастройки(Настройки));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗагрузитьНастройку();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНаблюденияПриИзменении(Элемент)
	
	ИнициализироватьНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	
	ЗаполнениеФормСтатистикиКлиент.ОтборыПравоеЗначениеНачалоВыбора(Настройки, ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьНастройки()
	
	// Приведем тип аналитики к допустимому для объекта.
	ТипДетализации = Перечисления.ВидыСвободныхСтрокФормСтатистики.ТипКлассификатора(Запись.ОбъектНаблюдения.Детализация);
	Если ТипДетализации = Неопределено Тогда
		Запись.ДетализацияОбъектаНаблюдения = Неопределено;
	ИначеЕсли ТипЗнч(Запись.ДетализацияОбъектаНаблюдения) <> ТипДетализации Тогда
		Запись.ДетализацияОбъектаНаблюдения = Новый(ТипДетализации);
	КонецЕсли;
	
	// Установим параметры выбора Детализации объекта наблюдения.
	ПараметрыВыбора	= Новый Массив();
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("ДанныеКлассификатора", Истина));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Назначение", Запись.ОбъектНаблюдения.Детализация));
	Элементы.ДетализацияОбъектаНаблюдения.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);;
	
	ЗаполнениеФормСтатистики.ИнициализироватьКомпоновщикНастроекПользователя(Настройки, Запись.ОбъектНаблюдения, УникальныйИдентификатор);
		
	ЗагрузитьНастройку();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройку()
	
	ЗаполнениеФормСтатистики.ЗагрузитьНастройку(Настройки, Запись.Настройка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияОбъектаНаблюденияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Запись.ДетализацияОбъектаНаблюдения = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора() Экспорт
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Номенклатура"      , Неопределено);
	СписокПараметров.Вставить("Склад"             , Неопределено);
	СписокПараметров.Вставить("Организация"       , Запись.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

#КонецОбласти