#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/1cFresh/Tariff/App/" + Версия();
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
Функция Версия() Экспорт
	
	Возврат "1.0.1.4";
	
КонецФункции

// Возвращает название программного интерфейса сообщений.
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "TariffApp";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - массив - массив обработчиков.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияТарификацияОбработчикСообщения_1_0_1_1);
	МассивОбработчиков.Добавить(СообщенияТарификацияОбработчикСообщения_1_0_1_2);
	МассивОбработчиков.Добавить(СообщенияТарификацияОбработчикСообщения_1_0_1_3);
	МассивОбработчиков.Добавить(СообщенияТарификацияОбработчикСообщения_1_0_1_4);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив - массив обработчиков.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт

КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}RegisterTariffServices.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ЗарегистрироватьТарифицируемыеУслуги(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "RegisterTariffServices");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}PutCommonTariffData.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ОтправитьОбщиеДанныеПоТарификацииВПрикладнуюИнформационнуюБазу(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PutCommonTariffData");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}PutZoneSubscriptions.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ОтправитьДанныеПоТарификацииВПриложениеАбонента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PutZoneSubscriptions");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}DeleteZoneSubscriptions.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция УдалитьДанныеПоТарификацииВПриложениеАбонента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteZoneSubscriptions");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}PutZoneLicenses.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ОтправитьДанныеПоЛицензиямВПриложениеАбонента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "PutZoneLicenses");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}DeleteZoneLicenses.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция УдалитьДанныеПоЛицензиямВПриложенииАбонента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DeleteZoneLicenses");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}GetServiceUniqueLicenses.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ЗапроситьЛицензииУникальныхУслугУМенеджераСервиса(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetServiceUniqueLicenses");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}ServiceProvider.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ТипПоставщикаУслуги(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ServiceProvider");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}Service.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ТипУслуги(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "Service");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/Tariff/App/a.b.c.d}ServiceSubscription.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция ТипПодпискиНаУслугу(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ServiceSubscription");
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти

