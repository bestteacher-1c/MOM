#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Присваивает номер пакета основным средствам, для которых он еще не определено.
//
// Параметры:
//  СписокОрганизаций	 - Массив, Неопределено	 - Список организация по которым требуется создать пакеты.
//  НомерЗадания		 - Число				 - Номер задания, который будет использоваться для создания новых заданий.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Содержит измененные пакеты амортизации.
//
Функция СоздатьПакетыАмортизации(СписокОрганизаций, НомерЗадания = Неопределено) Экспорт

	Если СписокОрганизаций = Неопределено Тогда
		СписокОрганизаций = Новый Массив;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если НомерЗадания = Неопределено Тогда
		// Перед выполнением увеличиваем номер задания.
		// Т.к. в ходе выполнения в других сеансах могут добавить новые задания и они должны остаться.
		НомерЗадания = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.УвеличитьНомерЗадания();
	КонецЕсли; 
	
	НачатьТранзакцию();

	Попытка
	
		ИзмененныеПакеты = РассчитатьНомераПакетов(СписокОрганизаций);
		СформироватьЗаданияПослеСозданияПакетов(ИзмененныеПакеты, СписокОрганизаций, НомерЗадания);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
	
		ОтменитьТранзакцию();
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение ТекстОшибки;
		
	КонецПопытки; 
	
	Возврат ИзмененныеПакеты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РассчитатьНомераПакетов(СписокОрганизаций)

	ТекстЗапроса = ВнеоборотныеАктивыЛокализация.ТекстЗапросаРассчитатьНомераПакетовАмортизацииОС();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	МИНИМУМ(НАЧАЛОПЕРИОДА(ПорядокУчетаОС.Период, МЕСЯЦ)) КАК Период,
		|	ПорядокУчетаОС.Организация                           КАК Организация,
		|	ПорядокУчетаОС.ОсновноеСредство                      КАК ОсновноеСредство
		|ПОМЕСТИТЬ ВТ_СписокОС_БезНомера
		|ИЗ
		|	РегистрСведений.ПорядокУчетаОСУУ КАК ПорядокУчетаОС
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииОС
		|		ПО (ПакетыАмортизацииОС.Организация = ПорядокУчетаОС.Организация)
		|			И (ПакетыАмортизацииОС.ОсновноеСредство = ПорядокУчетаОС.ОсновноеСредство)
		|ГДЕ
		|	ПорядокУчетаОС.НачислятьАмортизациюУУ
		|	И ПорядокУчетаОС.Организация В(&Организация)
		|	И ПакетыАмортизацииОС.НомерПакета ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ПорядокУчетаОС.Организация,
		|	ПорядокУчетаОС.ОсновноеСредство
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СписокОС.Период                       КАК НачалоМесяца,
		|	КОНЕЦПЕРИОДА(СписокОС.Период, МЕСЯЦ)  КАК КонецМесяца
		|ПОМЕСТИТЬ ВТ_Периоды
		|ИЗ
		|	ВТ_СписокОС_БезНомера КАК СписокОС
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Периоды.НачалоМесяца                                  КАК Период,
		|	ПорядокУчетаОС.Организация                            КАК Организация,
		|	ПакетыАмортизацииОС.НомерПакета                       КАК НомерПакета,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПорядокУчетаОС.ОсновноеСредство) КАК ОбъемПакета
		|ИЗ
		|	ВТ_Периоды КАК Периоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОСУУ КАК ПорядокУчетаОС
		|		ПО (ПорядокУчетаОС.Период >= Периоды.НачалоМесяца)
		|			И (ПорядокУчетаОС.Период <= Периоды.КонецМесяца)
		|			И (ПорядокУчетаОС.Организация В (&Организация))
		|			И (ПорядокУчетаОС.НачислятьАмортизациюУУ)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииОС
		|		ПО (ПакетыАмортизацииОС.Организация = ПорядокУчетаОС.Организация)
		|			И (ПакетыАмортизацииОС.ОсновноеСредство = ПорядокУчетаОС.ОсновноеСредство)
		|
		|СГРУППИРОВАТЬ ПО
		|	Периоды.НачалоМесяца,
		|	ПакетыАмортизацииОС.НомерПакета,
		|	ПорядокУчетаОС.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписокОС.Период КАК Период,
		|	СписокОС.Организация КАК Организация,
		|	СписокОС.ОсновноеСредство КАК ОсновноеСредство
		|ИЗ
		|	ВТ_СписокОС_БезНомера КАК СписокОС";
		
	КонецЕсли; 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПакетыАмортизацииОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Если СписокОрганизаций.Количество() <> 0 Тогда
		ЭлементБлокировки.ИсточникДанных = СписокОрганизацийВТаблицу(СписокОрганизаций);
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	КонецЕсли; 
	Блокировка.Заблокировать(); 
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОбъемПакетов = РезультатЗапроса[РезультатЗапроса.ВГраница()-1].Выгрузить();
	Выборка = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
	
	НаборЗаписей = РегистрыСведений.ПакетыАмортизацииОС.СоздатьНаборЗаписей();
	ИзмененныеПакеты = ВнеоборотныеАктивыСлужебный.РассчитатьНомераПакетовАмортизации(Выборка, ОбъемПакетов, НаборЗаписей);
	
	СинхронизироватьНомераПакетов(СписокОрганизаций, ИзмененныеПакеты);
	
	Возврат ИзмененныеПакеты;
	
КонецФункции

// Требуется сформировать задания, т.к. у ОС появился номер пакета.
// Если это не сделать, то потеряется информация о том, что для этих ОС нужен пересчет.
//
Процедура СформироватьЗаданияПослеСозданияПакетов(ИзмененныеПакеты, СписокОрганизаций, НомерЗадания)

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		// В РИБ данный регистр обрабатывается только в главном узле.
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ИзмененныеПакеты.Организация КАК Организация,
	|	ИзмененныеПакеты.НомерПакета КАК НомерПакета
	|ПОМЕСТИТЬ ИзмененныеПакеты
	|ИЗ
	|	&ИзмененныеПакеты КАК ИзмененныеПакеты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	Задания.НомерПакета,
	|	Задания.НомерЗадания,
	|	Задания.Документ
	|ПОМЕСТИТЬ Задания
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуАмортизацииОС КАК Задания
	|ГДЕ
	|	Задания.НомерПакета = 0
	|	И Задания.НомерЗадания <= &НомерЗадания
	|	И (Задания.Организация В (&Организация)
	|			ИЛИ &ПоВсемОрганизациям)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// Запись новых заданий
	|ВЫБРАТЬ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	ИзмененныеПакеты.НомерПакета,
	|	МАКСИМУМ(Задания.НомерЗадания) КАК НомерЗадания
	|ИЗ
	|	Задания КАК Задания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИзмененныеПакеты КАК ИзмененныеПакеты
	|		ПО (ИзмененныеПакеты.Организация = Задания.Организация)
	|
	|СГРУППИРОВАТЬ ПО
	|	Задания.Месяц,
	|	Задания.Организация,
	|	ИзмененныеПакеты.НомерПакета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|// Удаление заданий
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Задания.Месяц,
	|	Задания.Организация,
	|	Задания.НомерЗадания
	|ИЗ
	|	Задания КАК Задания";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ИзмененныеПакеты", ИзмененныеПакеты);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	Запрос.УстановитьПараметр("НомерЗадания", НомерЗадания);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРасчетуАмортизацииОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("НомерПакета", 0);
	Если СписокОрганизаций.Количество() <> 0 Тогда
		ЭлементБлокировки.ИсточникДанных = СписокОрганизацийВТаблицу(СписокОрганизаций);
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	КонецЕсли; 
	Блокировка.Заблокировать(); 
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Добавление новых заданий по измененным пакетам.
	Выборка = Результат[Результат.ВГраница()-1].Выбрать();
	Пока Выборка.Следующий() Цикл
		НовоеЗаданиеЗапись = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовоеЗаданиеЗапись, Выборка);
		НовоеЗаданиеЗапись.Записать();
	КонецЦикла;
	
	// Удаление заданий на нулевой пакет.
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Месяц.Установить(Выборка.Месяц);
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НаборЗаписей.Отбор.НомерЗадания.Установить(Выборка.НомерЗадания);
		НаборЗаписей.Отбор.НомерПакета.Установить(0);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

Функция СписокОрганизацийВТаблицу(СписокОрганизаций)

	ТаблицаОрганизаций = Новый ТаблицаЗначений;
	ТаблицаОрганизаций.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	
	Для каждого Организация Из СписокОрганизаций Цикл
		НоваяСтрока = ТаблицаОрганизаций.Добавить();
		НоваяСтрока.Организация = Организация;
	КонецЦикла; 

	Возврат ТаблицаОрганизаций;
	
КонецФункции

Процедура СинхронизироватьНомераПакетов(СписокОрганизаций, ИзмененныеПакеты)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РазукомплектацияОС.Организация КАК Организация,
	|	ТабличнаяЧасть.ОсновноеСредство КАК ОсновноеСредство,
	|	ПакетыАмортизацииИсходногоОС.НомерПакета КАК НомерПакета,
	|	ПакетыАмортизацииНовогоОС.НомерПакета КАК НомерПакетаСтарый
	|ИЗ
	|	Документ.РазукомплектацияОС КАК РазукомплектацияОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РазукомплектацияОС.ОС КАК ТабличнаяЧасть
	|		ПО (ТабличнаяЧасть.Ссылка = РазукомплектацияОС.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииИсходногоОС
	|		ПО (ПакетыАмортизацииИсходногоОС.ОсновноеСредство = РазукомплектацияОС.ОсновноеСредство)
	|			И (ПакетыАмортизацииИсходногоОС.Организация = РазукомплектацияОС.Организация)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииОС КАК ПакетыАмортизацииНовогоОС
	|		ПО (ПакетыАмортизацииНовогоОС.ОсновноеСредство = ТабличнаяЧасть.ОсновноеСредство)
	|			И (ПакетыАмортизацииНовогоОС.Организация = РазукомплектацияОС.Организация)
	|ГДЕ
	|	РазукомплектацияОС.Проведен
	|	И РазукомплектацияОС.ОтражатьВУпрУчете
	|	И (РазукомплектацияОС.Организация В (&Организация)
	|			ИЛИ &ПоВсемОрганизациям)
	|	И ПакетыАмортизацииНовогоОС.НомерПакета <> ПакетыАмортизацииИсходногоОС.НомерПакета";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		НаборЗаписей = РегистрыСведений.ПакетыАмортизацииОС.СоздатьМенеджерЗаписи();
		НаборЗаписей.Организация = Выборка.Организация;
		НаборЗаписей.ОсновноеСредство = Выборка.ОсновноеСредство;
		НаборЗаписей.НомерПакета = Выборка.НомерПакета;
		НаборЗаписей.Записать(Истина);
		
		// По измененным номерам пакетов будут сформированы задания для пересчета амортизации.
		ИзмененныйПакет = ИзмененныеПакеты.Добавить();
		ИзмененныйПакет.Организация = Выборка.Организация;
		ИзмененныйПакет.НомерПакета = Выборка.НомерПакета;
		
		ИзмененныйПакет = ИзмененныеПакеты.Добавить();
		ИзмененныйПакет.Организация = Выборка.Организация;
		ИзмененныйПакет.НомерПакета = Выборка.НомерПакетаСтарый;
		
	КонецЦикла;
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли