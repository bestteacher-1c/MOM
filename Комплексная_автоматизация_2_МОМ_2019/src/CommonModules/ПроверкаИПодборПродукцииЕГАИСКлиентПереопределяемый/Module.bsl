#Область СлужебныйПрограммныйИнтерфейс

// Заполняет специфичные параметры открытия формы проверки и подбора табачной продукции в зависимости от точки вызова
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма из которой происходит открытие формы проверки и подбора
//  Параметры - (См. ПроверкаИПодборПродукцииЕГАИСКлиент.ПараметрыОткрытияФормыПроверкиИПодбора)
Процедура  ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, Параметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "ОбщаяФорма.ПроверкаЗаполненияДокументов" Тогда
		
		Параметры.ОрганизацияЕГАИС        = Форма.ОрганизацияЕГАИС;
		Параметры.НачальныйСтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии");
		
		Параметры.ОписаниеОповещенияПриЗакрытии = Новый ОписаниеОповещения(
			"ПриЗакрытииФормыПроверкиИПодбора",
			СобытияФормЕГАИСУТКлиент,
			Новый Структура("Форма", Форма));
		
		Объект = Новый Структура;
		Объект.Вставить("ОрганизацияЕГАИС", Форма.ОрганизацияЕГАИС);
		Объект.Вставить("Ссылка", Форма.Ссылка);
		Объект.Вставить("АкцизныеМарки", Форма.АкцизныеМарки);
		Объект.Вставить("Товары", Форма.Товары);
		
		Параметры.АдресДанныхПроверяемойАлкогольнойПродукции = ПроверкаИПодборПродукцииЕГАИСУТВызовСервера.АдресДанныхПроверкиАлкогольнойПродукции(
			Неопределено,
			Объект,
			Форма.УникальныйИдентификатор);
	
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
	
		Параметры.ОрганизацияЕГАИС        = Форма.Объект.ОрганизацияЕГАИС;
		Параметры.НачальныйСтатусПроверки = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии");
	
		Параметры.ОписаниеОповещенияПриЗакрытии = Новый ОписаниеОповещения(
			"ПриЗакрытииФормыПроверкиИПодбора",
			СобытияФормЕГАИСУТКлиент,
			Новый Структура("Форма", Форма));
		
		Объект = Новый Структура;
		Объект.Вставить("ОрганизацияЕГАИС", Форма.Объект.ОрганизацияЕГАИС);
		Объект.Вставить("Ссылка", Форма.Объект.Ссылка);
		Объект.Вставить("АкцизныеМарки", Форма.Объект.АкцизныеМарки);
		Объект.Вставить("Товары", Форма.Объект.Товары);
		
		Если Форма.Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЧековККМ.Пробит") Тогда
			Параметры.РежимПросмотра = Истина;
			Параметры.ПроверятьНеобходимостьПеремаркировки = Ложь;
		КонецЕсли;
		
		Параметры.АдресДанныхПроверяемойАлкогольнойПродукции = ПроверкаИПодборПродукцииЕГАИСУТВызовСервера.АдресДанныхПроверкиАлкогольнойПродукции(
			Неопределено,
			Объект,
			Форма.УникальныйИдентификатор);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти