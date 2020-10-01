#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура АктуализироватьГрафикЗаказовНаСервере выполняет сдвиг дат поставки.
// Дата следующей поставки становится плановой датой поставки если дата заказа на плановую дату поставки просрочена.
//
// Параметры:
//	Объект      - СправочникОбъект.СпособыОбеспеченияПотребностей - объект, график заказов которого необходимо актуализировать,
//	ДатаСегодня - Дата - дата, по истечение которой дата заказа на ближайшую поставку считается просроченной.
//
Процедура АктуализироватьГрафикЗаказовНаСервере(Объект, ДатаСегодня) Экспорт
	
	Для Счетчик = 1 По 2 Цикл
		
		Если Объект.ФормироватьПлановыеЗаказы
			И Объект.ПлановаяДатаЗаказа < ДатаСегодня Тогда

			// Период, когда ближайшей считалась плановая дата поставки прошел, выполняем сдвиг дат.
			Объект.ПлановаяДатаПоставки = Объект.ДатаСледующейПоставки;
			Объект.ДатаСледующейПоставки = '00010101';//очищаем дату следующей поставки.

			Если ЗначениеЗаполнено(Объект.ПлановаяДатаПоставки) Тогда

				ПлановаяДатаЗаказа = ОпределитьДатуЗаказаПоДатеПоставки(Объект.ПлановаяДатаПоставки, Объект.СрокИсполненияЗаказа);
				Объект.ПлановаяДатаЗаказа = ПлановаяДатаЗаказа;

			Иначе
				
				Объект.ПлановаяДатаЗаказа = '00010101';//очищаем дату заказа.

			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

// Предназначена для получения текста запроса временной таблицы "ВтДатыПлановойПоставки", которая содержит даты плановой
// поставки по способу обеспечения, для способов обеспечения перечисленных во временной таблице "ВтСпособыОбеспечения".
//
// Параметры:
//  Разделы - Массив, Неопределено - массив для описания временных таблиц, включенных в пакетный запрос.
//
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаДатПлановойПоставки(Разделы = Неопределено) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Т.СпособОбеспеченияПотребностей                           КАК СпособОбеспечения,
		|	ЕСТЬNULL(СпрСпособ.ФормироватьПлановыеЗаказы, ЛОЖЬ)       КАК ФормироватьПлановыеЗаказы,
		|	ЕСТЬNULL(СпрСпособ.ГарантированныйСрокОтгрузки, 0)        КАК ГарантированныйСрокОтгрузки,
		|	ВЫБОР КОГДА СпрСпособ.ПлановаяДатаПоставки >= &НачалоТекущегоДня ТОГДА
		|				СпрСпособ.ПлановаяДатаПоставки
		|			ИНАЧЕ
		|				СпрСпособ.ДатаСледующейПоставки
		|		КОНЕЦ                                                 КАК ПлановаяДатаПоставки
		|ПОМЕСТИТЬ ВтРеквизитыСпособовОбеспечения
		|ИЗ
		|	ВтСпособыОбеспечения КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособ
		|		ПО Т.СпособОбеспеченияПотребностей = СпрСпособ.Ссылка
		|ИНДЕКСИРОВАТЬ ПО
		|	ГарантированныйСрокОтгрузки
		|;
		|////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Календарь.Значение            КАК Календарь,
		|	Т.ГарантированныйСрокОтгрузки КАК ЧислоДней,
		|	&НачалоТекущегоДня            КАК ДатаОтсчета
		|ПОМЕСТИТЬ ВтПараметрыПоиска
		|ИЗ
		|	ВтРеквизитыСпособовОбеспечения КАК Т,
		|	Константа.ОсновнойКалендарьПредприятия КАК Календарь
		|ГДЕ
		|	НЕ Т.ФормироватьПлановыеЗаказы
		|	И Календарь.Значение <> ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)
		|;
		|/////////////////////////////////////////////////
		|
		|";

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаРеквизитыСпособовОбеспечения");
		Разделы.Добавить("ТаблицаПараметрыПоиска");
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + ОбеспечениеСервер.ТекстЗапросаДатГрафика(Разделы);
	ТекстЗапроса = ТекстЗапроса
		+ "ВЫБРАТЬ
		|	Т.СпособОбеспечения КАК СпособОбеспечения,
		|	ДатыГрафика.Дата    КАК Дата
		|ПОМЕСТИТЬ ВтДатыПлановойПоставки
		|ИЗ
		|	ВтРеквизитыСпособовОбеспечения КАК Т
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВтДатыГрафика КАК ДатыГрафика
		|		ПО Т.ГарантированныйСрокОтгрузки = ДатыГрафика.ЧислоДней
		|ГДЕ
		|	НЕ Т.ФормироватьПлановыеЗаказы
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Т.СпособОбеспечения КАК СпособОбеспечения,
		|	ДОБАВИТЬКДАТЕ(&НачалоТекущегоДня, ДЕНЬ, Т.ГарантированныйСрокОтгрузки)
		|ИЗ
		|	ВтРеквизитыСпособовОбеспечения КАК Т,
		|	Константа.ОсновнойКалендарьПредприятия КАК Календарь
		|ГДЕ
		|	НЕ Т.ФормироватьПлановыеЗаказы
		|	И Календарь.Значение = ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Т.СпособОбеспечения         КАК СпособОбеспечения,
		|	Т.ПлановаяДатаПоставки      КАК Дата
		|ИЗ
		|	ВтРеквизитыСпособовОбеспечения КАК Т
		|ГДЕ
		|	Т.ФормироватьПлановыеЗаказы
		|	И Т.ПлановаяДатаПоставки >= &НачалоТекущегоДня
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	СпособОбеспечения
		|;
		|/////////////////////////////////////////////////
		|
		|";

	Если Разделы <> Неопределено Тогда
		Разделы.Добавить("ТаблицаДатыПлановойПоставки");
	КонецЕсли;

	Возврат ТекстЗапроса;

КонецФункции

// Предназначена для получения даты заказа для обеспечения своевременной поставки на определенную дату (дату поставки)
// исходя из срока исполнения заказа.
//
// Параметры:
//  ДатаПоставки - Дата - дата поставки, для которой необходимо рассчитать дату заказа.
//  СрокИсполненияЗаказа - Число - срок в днях между датой заказа и датой поставки.
//
// Возвращаемое значение:
//  Дата - искомая дата заказа
//
Функция ОпределитьДатуЗаказаПоДатеПоставки(ДатаПоставки, СрокИсполненияЗаказа) Экспорт

	КалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();

	Если ЗначениеЗаполнено(КалендарьПредприятия) Тогда

		Запрос = Новый Запрос();
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕСТЬNULL(ДатаЗаказа.ДатаГрафика, ДатаЗаказаВПрошломГоду.ДатаГрафика) КАК Дата
		|ИЗ
		|	РегистрСведений.КалендарныеГрафики КАК ДатаПоставки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК ДатаЗаказа
		|		ПО ДатаЗаказа.Календарь     = &Календарь
		|			И ДатаЗаказа.Год        = ГОД(&ДатаПоставки)
		|			И ДатаЗаказа.КоличествоДнейВГрафикеСНачалаГода =
		|				ДатаПоставки.КоличествоДнейВГрафикеСНачалаГода
		|				- &СрокИсполненияЗаказа
		|			И ДатаЗаказа.ДеньВключенВГрафик
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК КонецПрошлогоГода
		|		ПО КонецПрошлогоГода.Календарь     = &Календарь
		|			И КонецПрошлогоГода.Год        = ГОД(&ДатаПоставки) - 1
		|			И КонецПрошлогоГода.ДатаГрафика = ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(&ДатаПоставки, ГОД), ДЕНЬ, -1)
		|			И ДатаЗаказа.ДатаГрафика ЕСТЬ NULL
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК ДатаЗаказаВПрошломГоду
		|		ПО ДатаЗаказаВПрошломГоду.Календарь     = &Календарь
		|			И ДатаЗаказаВПрошломГоду.Год        = ГОД(&ДатаПоставки) - 1
		|			И ДатаЗаказаВПрошломГоду.КоличествоДнейВГрафикеСНачалаГода =
		|				КонецПрошлогоГода.КоличествоДнейВГрафикеСНачалаГода
		|				- &СрокИсполненияЗаказа
		|				+ ДатаПоставки.КоличествоДнейВГрафикеСНачалаГода
		|			И ДатаЗаказаВПрошломГоду.ДеньВключенВГрафик
		|			И ДатаЗаказа.ДатаГрафика ЕСТЬ NULL
		|ГДЕ
		|	ДатаПоставки.Календарь     = &Календарь
		|	И ДатаПоставки.ДатаГрафика = &ДатаПоставки
		|	И ДатаПоставки.Год         = ГОД(&ДатаПоставки)";
		Запрос.УстановитьПараметр("Календарь", КалендарьПредприятия);
		Запрос.УстановитьПараметр("ДатаПоставки", ДатаПоставки);
		Запрос.УстановитьПараметр("СрокИсполненияЗаказа", СрокИсполненияЗаказа);

		Выборка = Запрос.Выполнить().Выбрать();
		ДатаГрафика = НСтр("ru = 'не заполнен график работы предприятия'");
		Если Выборка.Следующий() И Не Выборка.Дата = Null Тогда
			ДатаГрафика = Выборка.Дата;
		КонецЕсли;

		Возврат ДатаГрафика;

	Иначе
		Возврат ДатаПоставки - СрокИсполненияЗаказа * 86400; //86400 - длительность суток в секундах
	КонецЕсли;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбеспечениеПотребностей

Функция ВременнаяТаблицаДатПоставок() Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОсновнойКалендарь.Значение     КАК Календарь,
		|	Т.Ссылка.СрокИсполненияЗаказа  КАК ЧислоДней,
		|	&НачалоТекущегоДня             КАК ДатаОтсчета
		|
		|ПОМЕСТИТЬ ВтПараметрыПоиска
		|ИЗ
		|	ВтСпособыОбеспечения КАК Т,
		|	Константа.ОсновнойКалендарьПредприятия КАК ОсновнойКалендарь
		|ГДЕ
		|	ОсновнойКалендарь.Значение <> ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)
		|;
		|/////////////////////////////////////////////////
		|
		|";

	ТекстЗапроса = ТекстЗапроса + ОбеспечениеСервер.ТекстЗапросаДатГрафика();

	ТекстЗапроса = ТекстЗапроса +
		"ВЫБРАТЬ
		|	Т.Ссылка                                           КАК Ссылка,
		|	ВЫБОР КОГДА Т.Ссылка ЕСТЬ NULL ТОГДА
		|				&НачалоТекущегоДня
		|			КОГДА ОсновнойКалендарь.Значение = ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка) ТОГДА
		|				ДОБАВИТЬКДАТЕ(&НачалоТекущегоДня, ДЕНЬ, Т.Ссылка.СрокИсполненияЗаказа)
		|			ИНАЧЕ
		|				ДатыГрафика.Дата
		|		КОНЕЦ                                          КАК ДатаВозможнойПоставки,
		|
		|	ЕСТЬNULL(Т.Ссылка.ФормироватьПлановыеЗаказы, ЛОЖЬ) КАК ФормироватьПлановыеЗаказы,
		|	Т.Ссылка.ПлановаяДатаЗаказа                        КАК ПлановаяДатаЗаказа,
		|	Т.Ссылка.ПлановаяДатаПоставки                      КАК ПлановаяДатаПоставки,
		|	Т.Ссылка.ДатаСледующейПоставки                     КАК ДатаСледующейПоставки,
		|	Т.Ссылка.ОбеспечиваемыйПериод                      КАК ОбеспечиваемыйПериод,
		|
		|	ВЫБОР КОГДА НЕ Т.Ссылка ЕСТЬ NULL И ОсновнойКалендарь.Значение <> ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка)
		|			И ДатыГрафика.Дата ЕСТЬ NULL ТОГДА
		|				ИСТИНА
		|			ИНАЧЕ
		|				ЛОЖЬ
		|		КОНЕЦ                                          КАК ОшибкаНеЗаполненКалендарьПредприятия
		|
		|ПОМЕСТИТЬ ВтСпособыОбеспеченияДатыПоставок
		|ИЗ
		|	ВтСпособыОбеспечения КАК Т
		|
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Константа.ОсновнойКалендарьПредприятия КАК ОсновнойКалендарь
		|		ПО ИСТИНА
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтДатыГрафика КАК ДатыГрафика
		|		ПО Т.Ссылка.СрокИсполненияЗаказа = ДатыГрафика.ЧислоДней
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Ссылка
		|;
		|
		|/////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВтПараметрыПоиска;
		|
		|/////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВтДатыГрафика;
		|
		|////////////////////////////////////////////////////////////////
		|";

	Возврат ТекстЗапроса;

КонецФункции

Функция ВременнаяТаблицаИнтерваловРаботыСкладов() Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВЫБОР КОГДА Т.Склад.Календарь <> ЗНАЧЕНИЕ(Справочник.Календари.ПустаяСсылка) ТОГДА
		|				Т.Склад.Календарь
		|			ИНАЧЕ
		|				ОсновнойКалендарь.Значение
		|		КОНЕЦ                                        КАК Календарь,
		|	ТаблицаСпособовОбеспечения.ДатаВозможнойПоставки КАК ДатаВозможнойПоставки,
		|	ТаблицаСпособовОбеспечения.ПлановаяДатаПоставки  КАК ПлановаяДатаПоставки,
		|	ТаблицаСпособовОбеспечения.ДатаСледующейПоставки КАК ДатаСледующейПоставки,
		|	ТаблицаСпособовОбеспечения.ОбеспечиваемыйПериод  КАК ОбеспечиваемыйПериод
		|
		|ПОМЕСТИТЬ ВтКалендариИДаты
		|ИЗ
		|	ВтСкладыИСпособыОбеспечения КАК Т
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ Константа.ОсновнойКалендарьПредприятия КАК ОсновнойКалендарь
		|	ПО ИСТИНА
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ ВтСпособыОбеспеченияДатыПоставок КАК ТаблицаСпособовОбеспечения
		|	ПО Т.СпособОбеспечения = ТаблицаСпособовОбеспечения.Ссылка
		|;
		|
		|/////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Календарь               КАК Календарь,
		|	&НачалоТекущегоДня        КАК Дата1,
		|	Т.ДатаВозможнойПоставки   КАК Дата2
		|
		|ПОМЕСТИТЬ ВтПараметрыПоиска
		|ИЗ
		|	ВтКалендариИДаты КАК Т
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Т.Календарь               КАК Календарь,
		|	&НачалоТекущегоДня        КАК Дата1,
		|	Т.ПлановаяДатаПоставки    КАК Дата2
		|ИЗ
		|	ВтКалендариИДаты КАК Т
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	Т.Календарь               КАК Календарь,
		|	Т.ПлановаяДатаПоставки    КАК Дата1,
		|	Т.ДатаСледующейПоставки   КАК Дата2
		|ИЗ
		|	ВтКалендариИДаты КАК Т
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Календарь,
		|	Дата1, Дата2
		|;
		|
		|/////////////////////////////////////////////////////////
		|";

	ТекстЗапроса = ТекстЗапроса + ОбеспечениеСервер.ТекстЗапросаКоличестваДнейМеждуДатамиГрафика();

	Возврат ТекстЗапроса;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли