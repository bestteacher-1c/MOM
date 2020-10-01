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
		НомерЗадания = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.УвеличитьНомерЗадания();
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

	ТекстЗапроса = ВнеоборотныеАктивыЛокализация.ТекстЗапросаРассчитатьНомераПакетовАмортизацииНМА();
	
	Если ТекстЗапроса = Неопределено Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	МИНИМУМ(НАЧАЛОПЕРИОДА(ПорядокУчетаНМА.Период, МЕСЯЦ)) КАК Период,
		|	ПорядокУчетаНМА.Организация                           КАК Организация,
		|	ПорядокУчетаНМА.НематериальныйАктив                   КАК НематериальныйАктив
		|ПОМЕСТИТЬ ВТ_СписокНМА_БезНомера
		|ИЗ
		|	РегистрСведений.ПорядокУчетаНМАУУ КАК ПорядокУчетаНМА
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииНМА КАК ПакетыАмортизацииНМА
		|		ПО (ПакетыАмортизацииНМА.Организация = ПорядокУчетаНМА.Организация)
		|			И (ПакетыАмортизацииНМА.НематериальныйАктив = ПорядокУчетаНМА.НематериальныйАктив)
		|ГДЕ
		|	ПорядокУчетаНМА.НачислятьАмортизациюУУ
		|	И ПорядокУчетаНМА.Организация В(&Организация)
		|	И ПакетыАмортизацииНМА.НомерПакета ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ПорядокУчетаНМА.Организация,
		|	ПорядокУчетаНМА.НематериальныйАктив
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СписокНМА.Период                      КАК НачалоМесяца,
		|	КОНЕЦПЕРИОДА(СписокНМА.Период, МЕСЯЦ) КАК КонецМесяца
		|ПОМЕСТИТЬ ВТ_Периоды
		|ИЗ
		|	ВТ_СписокНМА_БезНомера КАК СписокНМА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Периоды.НачалоМесяца                                      КАК Период,
		|	ПорядокУчетаНМА.Организация                               КАК Организация,
		|	ПакетыАмортизацииНМА.НомерПакета                          КАК НомерПакета,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПорядокУчетаНМА.НематериальныйАктив) КАК ОбъемПакета
		|ИЗ
		|	ВТ_Периоды КАК Периоды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ КАК ПорядокУчетаНМА
		|		ПО (ПорядокУчетаНМА.Период >= Периоды.НачалоМесяца)
		|			И (ПорядокУчетаНМА.Период <= Периоды.КонецМесяца)
		|			И (ПорядокУчетаНМА.Организация В (&Организация))
		|			И (ПорядокУчетаНМА.НачислятьАмортизациюУУ)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПакетыАмортизацииНМА КАК ПакетыАмортизацииНМА
		|		ПО (ПакетыАмортизацииНМА.Организация = ПорядокУчетаНМА.Организация)
		|			И (ПакетыАмортизацииНМА.НематериальныйАктив = ПорядокУчетаНМА.НематериальныйАктив)
		|
		|СГРУППИРОВАТЬ ПО
		|	Периоды.НачалоМесяца,
		|	ПакетыАмортизацииНМА.НомерПакета,
		|	ПорядокУчетаНМА.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СписокНМА.Период КАК Период,
		|	СписокНМА.Организация КАК Организация,
		|	СписокНМА.НематериальныйАктив КАК НематериальныйАктив
		|ИЗ
		|	ВТ_СписокНМА_БезНомера КАК СписокНМА";
	
	КонецЕсли; 
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Организация", СписокОрганизаций);
	Запрос.УстановитьПараметр("ПоВсемОрганизациям", СписокОрганизаций.Количество() = 0);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПакетыАмортизацииНМА");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Если СписокОрганизаций.Количество() <> 0 Тогда
		ЭлементБлокировки.ИсточникДанных = СписокОрганизацийВТаблицу(СписокОрганизаций);
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	КонецЕсли; 
	Блокировка.Заблокировать(); 
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ОбъемПакетов = РезультатЗапроса[РезультатЗапроса.ВГраница()-1].Выгрузить();
	Выборка = РезультатЗапроса[РезультатЗапроса.ВГраница()].Выбрать();
	
	НаборЗаписей = РегистрыСведений.ПакетыАмортизацииНМА.СоздатьНаборЗаписей();
	ИзмененныеПакеты = ВнеоборотныеАктивыСлужебный.РассчитатьНомераПакетовАмортизации(Выборка, ОбъемПакетов, НаборЗаписей);
	
	Возврат ИзмененныеПакеты;
	
КонецФункции

// Требуется сформировать задания, т.к. у НМА появился номер пакета.
// Если это не сделать, то потеряется информация о том, что для этих НМА нужен пересчет.
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
	|	РегистрСведений.ЗаданияКРасчетуАмортизацииНМА КАК Задания
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
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ЗаданияКРасчетуАмортизацииНМА");
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
		НовоеЗаданиеЗапись = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(НовоеЗаданиеЗапись, Выборка);
		НовоеЗаданиеЗапись.Записать();
	КонецЦикла;
	
	// Удаление заданий на нулевой пакет.
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.СоздатьНаборЗаписей();
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

#КонецОбласти

#КонецЕсли