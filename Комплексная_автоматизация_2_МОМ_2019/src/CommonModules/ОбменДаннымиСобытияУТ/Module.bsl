
#Область ПрограммныйИнтерфейс

#Область ОбменЧерезУниверсальныйФормат

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник        - ДокументОбъект - источник события.
//  Отказ           - Булево - флаг отказа от выполнения обработчика.
//  РежимЗаписи     - РежимЗаписиДокумента - см. в синтаксис-помощнике РежимЗаписиДокумента.
//  РежимПроведения - РежимПроведенияДокумента - см. в синтаксис-помощнике РежимПроведенияДокумента.
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - НаборЗаписейРегистра - источник события.
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура СинхронизацияДанныхЧерезУниверсальныйФорматПередЗаписьюНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("СинхронизацияДанныхЧерезУниверсальныйФормат", Источник, Отказ, Замещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиПравилРегистрации

// Параметры обработчиков правил регистрации "ПриОбработке" и "ПриОбработкеДополнительный"
//
// Возвращает: ПараметрыОбработки - Структура
//    РазделыУчетаСтрокой - Строка - Список через запятую, разделов учета, по которым необходимо произвести фильтрацию
//    ТекстЗапроса - Строка - Текст запроса к ИБ для вычисления массива узлов получателей
//    ПараметрыЗапроса - Структура - Структура с заполненными параметрами запроса к ИБ, для вычисления узлов получателей
//    ИспользоватьКэш - Булево - Флаг использования кэша
//    Отказ - Булево - флаг отказа от выполнения обработчика
//    Объект - ЛюбойОбъект - Объект, для которого выполняются правила регистрации
//    Выгрузка - Булево - Флаг, определяющий происходит запись объекта или выгрузка.
//
Функция ИнициализироватьПараметрыОбработкиПРО() Экспорт
	
	ПараметрыОбработки = Новый Структура();
	ПараметрыОбработки.Вставить("РазделыУчетаСтрокой", "");
	ПараметрыОбработки.Вставить("ТекстЗапроса",        "");
	ПараметрыОбработки.Вставить("ПараметрыЗапроса",    Новый Структура());
	ПараметрыОбработки.Вставить("ИспользоватьКэш",     Ложь);
	ПараметрыОбработки.Вставить("Отказ",               Ложь);
	ПараметрыОбработки.Вставить("Объект",              Неопределено);
	ПараметрыОбработки.Вставить("Выгрузка",            Ложь);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

// Процедура-обработчик события "ПриОбработке".
// Вызывается из правил регистрации плана обмена СинхронизацияДанныхЧерезУниверсальныйФормат.
//
// Параметры:
//  ПараметрыОбработкиПРО – Структура – см. ИнициализироватьПараметрыОбработкиПРО.
// Возвращает:
//  ПараметрыОбработкиПРО – Структура – см. ИнициализироватьПараметрыОбработкиПРО.
//
Функция ПриОбработкеПРО(ПараметрыОбработкиПРО) Экспорт
	
	// Адаптируем текст запроса с учета разделов учета.
	ПодзапросРазделыУчета = "";
	МассивРазделовУчета   = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПараметрыОбработкиПРО.РазделыУчетаСтрокой,,Истина);
	
	Если МассивРазделовУчета.Количество() = 0 Тогда
		//Если разделы учета не указаны, то адаптация запроса не имеет смысла.
		Возврат ПараметрыОбработкиПРО;
	КонецЕсли;
	
	ПараметрыОбработкиПРО.ИспользоватьКэш = Ложь;
	ТекстЗапроса                          = ПараметрыОбработкиПРО.ТекстЗапроса;
	
	НомерРаздела = 1;
	Для Каждого РазделУчета Из МассивРазделовУчета Цикл
		
		ПараметрыОбработкиПРО.ПараметрыЗапроса.Вставить("РазделУчета"+НомерРаздела, СокрЛП(РазделУчета));
		ПодзапросРазделыУчета = ПодзапросРазделыУчета + ?(ПодзапросРазделыУчета = "", "", Символы.ПС + "ИЛИ ")
			+ "ПланОбменаРазделыУчета.РазделУчета = &СвойствоОбъекта_РазделУчета" + НомерРаздела;
		НомерРаздела = НомерРаздела + 1;
		
	КонецЦикла;
	
	Если МассивРазделовУчета.Количество() > 1 Тогда
		ПодзапросРазделыУчета = "(" + ПодзапросРазделыУчета + ")";
	КонецЕсли;
	
	ТекстЛевогоСоединения = "КАК ПланОбменаОсновнаяТаблица
		|ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.РазделыУчета КАК ПланОбменаРазделыУчета
		|ПО ПланОбменаОсновнаяТаблица.Ссылка = ПланОбменаРазделыУчета.Ссылка
		|	И " + ПодзапросРазделыУчета + "
		|	И ПланОбменаРазделыУчета.Выгружать";
	
	ТекстУсловияРазделовУчета = "	И ЕстьNULL(ПланОбменаРазделыУчета.Выгружать, ЛОЖЬ)
		|[ОбязательныеУсловия]";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "КАК ПланОбменаОсновнаяТаблица", ТекстЛевогоСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ОбязательныеУсловия]", ТекстУсловияРазделовУчета);
	
	ПараметрыОбработкиПРО.ТекстЗапроса = ТекстЗапроса;
	
	Возврат ПараметрыОбработкиПРО;
	
КонецФункции

Процедура ДокументВзаимозачетЗадолженностиПослеОбработкиПРО(Объект, Выгрузка, Получатели, ИмяПланаОбмена) Экспорт
	
	Если Выгрузка Или Получатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ 
		|СвязанныеДокументы.Ссылка КАК Ссылка
		|ИЗ
		|	КритерийОтбора.СвязанныеДокументы(&ЗначениеКритерияОтбора) КАК СвязанныеДокументы
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(СвязанныеДокументы.Ссылка) = ТИП(Документ.СчетФактураВыданныйАванс)
		|	ИЛИ ТИПЗНАЧЕНИЯ(СвязанныеДокументы.Ссылка) = ТИП(Документ.СчетФактураПолученныйАванс)");
		
	Запрос.УстановитьПараметр("ЗначениеКритерияОтбора",Объект.Ссылка);
	
	Результат = Запрос.Выполнить().Выбрать();
	Пока Результат.Следующий() Цикл
		СчетФактура = Результат.Ссылка.ПолучитьОбъект();
		ОбменДаннымиСобытия.ВыполнитьПравилаРегистрацииДляОбъекта(СчетФактура, ИмяПланаОбмена, Неопределено);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДокументСчетФактураВыданныйПередОбработкойПРО(Объект, Отказ) Экспорт
	
	ИсключаемыеТипыДокументовОснований = Новый Массив;
	ИсключаемыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ВыкупВозвратнойТарыКлиентом"));
	ИсключаемыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ЗаписьКнигиПродаж"));

	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТипДокументаОснования = ТипЗнч(Объект.ДокументОснование);
		Если ИсключаемыеТипыДокументовОснований.Найти(ТипДокументаОснования) <> Неопределено Тогда
			Отказ = Истина;
		ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.РеализацияУслугПрочихАктивов") Тогда
			
			ХозяйственнаяОперация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.ДокументОснование, "ХозяйственнаяОперация");
			Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
				Отказ = Истина;
			КонецЕсли;
		ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.КорректировкаРеализации") Тогда
			Если ТипЗнч(Объект.ДокументОснование.ДокументОснование) = Тип("ДокументСсылка.АктВыполненныхРабот") Тогда
				Отказ = Истина;
			КонецЕсли;
		ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			Если Объект.ДокументОснование.Статус = Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате Тогда
				Отказ = Истина;
			КонецЕсли;
		ИначеЕсли ТипДокументаОснования = Тип("ДокументСсылка.ОтчетКомиссионера") 
			ИЛИ ТипДокументаОснования = Тип("ДокументСсылка.ОтчетКомитенту")
			ИЛИ ТипДокументаОснования = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
			ОбменДаннымиСобытияУТ.ДокументОтчетКомиссионераКомитентуПриОбработкеПРО(Объект.ДокументОснование, Отказ);
		КонецЕсли;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДокументСчетФактураПолученныйПередОбработкойПРО(Объект, Отказ) Экспорт
	ДопустимыеТипыДокументовОснований = Новый Массив;
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ВозвратТоваровОтКлиента"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ОтчетКомиссионера"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ОтчетКомитенту"));
	//++ НЕ УТ
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ОтчетПереработчика"));
	//-- НЕ УТ
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.КорректировкаПриобретения"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями"));
	ДопустимыеТипыДокументовОснований.Добавить(Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями"));

	ДокументОснованиеКорректен = Ложь;
	Для Каждого Строка Из Объект.ДокументыОснования Цикл
		
		ДокументОснование = Строка.ДокументОснование;
		
		Если Не ЗначениеЗаполнено(ДокументОснование)
			Или Не ДокументОснование.Проведен Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДопустимыеТипыДокументовОснований.Найти(ТипЗнч(ДокументОснование)) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетКомиссионера")
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетКомитенту")
			ИЛИ ТипЗнч(ДокументОснование) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
			Если ДокументОснование.СуммаДокумента <= 0 Тогда
				Продолжить;
			КонецЕсли;
			ЕстьТовары = Ложь;
			Для Каждого СтрокаТовары Из ДокументОснование.Товары Цикл
				
				ТипНоменклатуры = Неопределено;
				Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
					ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТовары.Номенклатура, "ТипНоменклатуры");
				Иначе
					Продолжить;
				КонецЕсли;
				
				Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
					ЕстьТовары = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЕстьТовары Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		ДокументОснованиеКорректен = Истина;
		Прервать;
		
	КонецЦикла;
	Если НЕ ДокументОснованиеКорректен Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура ДокументОтчетКомиссионераКомитентуПриОбработкеПРО(Объект, Отказ) Экспорт
	ЕстьТовары = Ложь;
	Для Каждого СтрокаТовары Из Объект.Товары Цикл
		
		ТипНоменклатуры = Неопределено;
		Если ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
			ТипНоменклатуры = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТовары.Номенклатура, "ТипНоменклатуры");
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
			ЕстьТовары = Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	Если НЕ ЕстьТовары Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецОбласти