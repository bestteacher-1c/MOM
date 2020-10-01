#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет документ на основании инвентаризации
//
// Параметры:
//  Объект				 - ДокументОбъект.ПеремещениеНМА2_4	 - Документ, который надо заполнить.
//  СообщатьОбОшибках	 - Булево							 - Истина, если нужно сообщить об ошибках.
//  МассивНомеровСтрок	 - Массив							 - Строки инвентаризации.
//
Процедура ЗаполнитьНаОснованииИнвентаризации(Объект, СообщатьОбОшибках, МассивНомеровСтрок = Неопределено) Экспорт

	Объект.НМА.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументОснование, "Дата,Организация,Подразделение");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТабличнаяЧасть.НематериальныйАктив КАК НематериальныйАктив,
	|	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	|	ТабличнаяЧасть.СтоимостьФактическая КАК СтоимостьФактическая
	|ПОМЕСТИТЬ СписокНМА
	|ИЗ
	|	Документ.ИнвентаризацияНМА.НМА КАК ТабличнаяЧасть
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереоценкаНМА2_4 КАК ДокументыНаОсновании
	|		ПО (ДокументыНаОсновании.ДокументОснование = ТабличнаяЧасть.Ссылка)
	|			И (ДокументыНаОсновании.Проведен)
	|			И (ДокументыНаОсновании.Ссылка <> &Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПереоценкаНМА2_4.НМА КАК ДокументыНаОснованииНМА
	|		ПО (ДокументыНаОснованииНМА.Ссылка = ДокументыНаОсновании.Ссылка)
	|			И (ДокументыНаОснованииНМА.НематериальныйАктив = ТабличнаяЧасть.НематериальныйАктив)
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &ДокументОснование
	|	И ДокументыНаОснованииНМА.Ссылка ЕСТЬ NULL
	|	И ТабличнаяЧасть.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияНаОснованииИнвентаризации.Переоценка)
	|	И (ТабличнаяЧасть.НомерСтроки В (&МассивНомеровСтрок)
	|			ИЛИ НЕ &ПоСпискуСтрок)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МестоУчетаНМА.Организация КАК Организация,
	|	МестоУчетаНМА.Подразделение КАК Подразделение,
	|	МестоУчетаНМА.НематериальныйАктив КАК НематериальныйАктив
	|ПОМЕСТИТЬ МестоУчетаНМА
	|ИЗ
	|	РегистрСведений.МестоУчетаНМА.СрезПоследних(
	|			&Дата,
	|			НематериальныйАктив В
	|				(ВЫБРАТЬ
	|					СписокНМА.НематериальныйАктив
	|				ИЗ
	|					СписокНМА КАК СписокНМА)) КАК МестоУчетаНМА
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив,
	|	Организация,
	|	Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПорядокУчетаНМАБУ.НематериальныйАктив КАК НематериальныйАктив,
	|	ПорядокУчетаНМАБУ.Состояние КАК Состояние
	|ПОМЕСТИТЬ ПорядокУчетаНМАБУ
	|ИЗ
	|	РегистрСведений.ПорядокУчетаНМАБУ.СрезПоследних(
	|			&Дата,
	|			(НематериальныйАктив, Организация) В
	|				(ВЫБРАТЬ
	|					МестоУчетаНМА.НематериальныйАктив,
	|					МестоУчетаНМА.Организация
	|				ИЗ
	|					МестоУчетаНМА КАК МестоУчетаНМА)) КАК ПорядокУчетаНМАБУ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПорядокУчетаНМАУУ.НематериальныйАктив КАК НематериальныйАктив,
	|	ПорядокУчетаНМАУУ.Состояние КАК Состояние
	|ПОМЕСТИТЬ ПорядокУчетаНМАУУ
	|ИЗ
	|	РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(
	|			&Дата,
	|			(НематериальныйАктив, Организация) В
	|				(ВЫБРАТЬ
	|					МестоУчетаНМА.НематериальныйАктив,
	|					МестоУчетаНМА.Организация
	|				ИЗ
	|					МестоУчетаНМА КАК МестоУчетаНМА)) КАК ПорядокУчетаНМАУУ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	НематериальныйАктив
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокНМА.НематериальныйАктив КАК НематериальныйАктив,
	|	СписокНМА.СтоимостьФактическая КАК СтоимостьФактическая,
	|	МестоУчетаНМА.Организация КАК Организация,
	|	МестоУчетаНМА.Подразделение КАК Подразделение,
	|	ЕСТЬNULL(ПорядокУчетаНМАБУ.Состояние, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК ОтражатьВРеглУчете,
	|	ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПринятКУчету) КАК ОтражатьВУпрУчете
	|ИЗ
	|	СписокНМА КАК СписокНМА
	|		ЛЕВОЕ СОЕДИНЕНИЕ МестоУчетаНМА КАК МестоУчетаНМА
	|		ПО (МестоУчетаНМА.НематериальныйАктив = СписокНМА.НематериальныйАктив)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПорядокУчетаНМАБУ КАК ПорядокУчетаНМАБУ
	|		ПО (ПорядокУчетаНМАБУ.НематериальныйАктив = СписокНМА.НематериальныйАктив)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПорядокУчетаНМАУУ КАК ПорядокУчетаНМАУУ
	|		ПО (ПорядокУчетаНМАУУ.НематериальныйАктив = СписокНМА.НематериальныйАктив)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СписокНМА.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ДокументОснование", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Дата", НачалоДня(РеквизитыОснования.Дата));
	Запрос.УстановитьПараметр("МассивНомеровСтрок", ?(МассивНомеровСтрок <> Неопределено, МассивНомеровСтрок, Новый Массив));
	Запрос.УстановитьПараметр("ПоСпискуСтрок", МассивНомеровСтрок <> Неопределено);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ОтражатьВРеглУчете = Неопределено;
	ОтражатьВУпрУчете = Неопределено;
	
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	
	СтрокиДобавлены = Ложь;
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = Выборка.Организация;
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(Объект.Подразделение) Тогда
			Объект.Подразделение = Выборка.Подразделение;
		КонецЕсли; 
		
		Если ОтражатьВРеглУчете = Неопределено Тогда
			Объект.ОтражатьВРеглУчете = Выборка.ОтражатьВРеглУчете;
			ОтражатьВРеглУчете = Выборка.ОтражатьВРеглУчете;
		КонецЕсли; 
		
		Если ОтражатьВУпрУчете = Неопределено Тогда
			Объект.ОтражатьВУпрУчете = Выборка.ОтражатьВУпрУчете;
			ОтражатьВУпрУчете = Выборка.ОтражатьВУпрУчете;
		КонецЕсли; 
		
		Если Объект.Организация <> Выборка.Организация 
			ИЛИ Объект.Подразделение <> Выборка.Подразделение
			ИЛИ Объект.ОтражатьВРеглУчете <> Выборка.ОтражатьВРеглУчете 
			ИЛИ Объект.ОтражатьВУпрУчете <> Выборка.ОтражатьВУпрУчете Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Объект.НМА.Добавить();
		ДанныеСтроки.НематериальныйАктив = Выборка.НематериальныйАктив;
		
		Если Объект.ОтражатьВРеглУчете Тогда
			ДанныеСтроки.СтоимостьБУ = Выборка.СтоимостьФактическая;
		КонецЕсли; 
		
		Если Объект.ОтражатьВУпрУчете Тогда
			ДанныеСтроки.СтоимостьУУ = РаботаСКурсамиВалют.ПересчитатьВВалюту(
				Выборка.СтоимостьФактическая,
				ВалютаРегл,
				ВалютаУпр,
				Объект.Дата);
		КонецЕсли; 
		
		СтрокиДобавлены = Истина;
		
	КонецЦикла;
	
	Если НЕ СтрокиДобавлены И СообщатьОбОшибках Тогда
		ТекстОшибки = НСтр("ru='В документе %1 отсутствуют строки требующие создания переоценки'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Объект.ДокументОснование);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ДокументОснование");
	КонецЕсли;
	
КонецПроцедуры

#Область Команды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаСписка";
	КонецЕсли;
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Переоценка НМА".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ПереоценкаНМА2_4) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ПереоценкаНМА2_4.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ПереоценкаНМА2_4);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_4";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  ДокументСсылка			 - ДокументСсылка.ПереоценкаНМА2_4 - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ВнеоборотныеАктивыСлужебный.ТекстыЗапросаПриПереоценке(ТекстыЗапроса, "НМА");
	ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса);
	
	ТаблицыДляДвижений = Новый Структура;
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ТаблицыДляДвижений, Истина);
	
	Возврат ТаблицыДляДвижений;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ПереоценкаНМА2_4";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
	
	ПереоценкаНМАЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка                 КАК Ссылка,
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ДанныеДокумента.Номер                  КАК Номер,
	|	ДанныеДокумента.Проведен               КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления        КАК ПометкаУдаления,
	|	ДанныеДокумента.ОтражатьВРеглУчете     КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете      КАК ОтражатьВУпрУчете,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПереоценкаНМА) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.Подразделение          КАК Подразделение,
	|	ДанныеДокумента.СтатьяДоходов          КАК СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов       КАК АналитикаДоходов,
	|	ДанныеДокумента.СтатьяРасходов         КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов      КАК АналитикаРасходов,
	|	ЕСТЬNULL(ДанныеДокумента.СтатьяРасходов.ПринятиеКналоговомуУчету, ЛОЖЬ) КАК ПринятиеКНалоговомуУчету,
	|	ДанныеДокумента.Ответственный          КАК Ответственный,
	|	ДанныеДокумента.Комментарий            КАК Комментарий
	|ИЗ
	|	Документ.ПереоценкаНМА2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КонецДня", Новый Граница(КонецДня(Реквизиты.Период),ВидГраницы.Включая));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ПереоценкаНМА2_4"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПереоценкаНМА);
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru='Переоценка НМА'"));
	ЗначенияПараметровПроведения.Вставить("ПорядокУчетаВНАВУпрУчете", Константы.ПорядокУчетаВНАВУпрУчете.Получить());

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоНМА(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоНМА";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаНМА.НомерСтроки-1, 0) КАК НомерЗаписи,
	|	&Ссылка                          КАК Ссылка,
	|	ТаблицаНМА.НематериальныйАктив   КАК НематериальныйАктив,
	|	&ХозяйственнаяОперация           КАК ХозяйственнаяОперация,
	|	&Организация                     КАК Организация,
	|	&Подразделение                   КАК Подразделение,
	|	&Период                          КАК Дата,
	|	&ИдентификаторМетаданных         КАК ТипСсылки,
	|	&Проведен                        КАК Проведен,
	|	&ОтражатьВУпрУчете               КАК ОтражатьВУпрУчете,
	|	&ОтражатьВРеглУчете              КАК ОтражатьВРеглУчете
	|ИЗ
	|	Документ.ПереоценкаНМА2_4 КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ
	|			Документ.ПереоценкаНМА2_4.НМА КАК ТаблицаНМА
	|		ПО
	|			ТаблицаНМА.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Ссылка                        КАК Ссылка,
	|	&Период                        КАК ДатаДокументаИБ,
	|	&Номер                         КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных       КАК ТипСсылки,
	|	&Организация                   КАК Организация,
	|	&ХозяйственнаяОперация         КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                   КАК НаправлениеДеятельности,
	|	&Подразделение                 КАК Подразделение,
	|	&Ответственный                 КАК Ответственный,
	|	&Комментарий                   КАК Комментарий,
	|	&Проведен                      КАК Проведен,
	|	&ПометкаУдаления               КАК ПометкаУдаления,
	|	ЛОЖЬ                           КАК ДополнительнаяЗапись,
	|	&Период                        КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                 КАК НомерПервичногоДокумента,
	|	&Период   КАК ДатаОтраженияВУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПервоначальныеСведенияНМА(ТекстыЗапроса)

	ИмяРегистра = "ПервоначальныеСведенияНМА";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаВтТаблицаНМА(ТекстыЗапроса, "Документ.ПереоценкаНМА2_4");
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                                     КАК Регистратор,
	|	&Период                                                     КАК Период,
	|	&Организация                                                КАК Организация,
	|	ПервоначальныеСведения.НематериальныйАктив                  КАК НематериальныйАктив,
	|	ПервоначальныеСведения.СпособПоступления                    КАК СпособПоступления,
	|
	// ПервоначальнаяСтоимостьУУ
	|	ВЫБОР
	|		КОГДА &ПорядокУчетаВНАВУпрУчете = ЗНАЧЕНИЕ(Перечисление.ПорядокУчетаВНАВУпрУчете.ПоСтандартамРегл)
	|			ТОГДА ПервоначальныеСведения.ПервоначальнаяСтоимостьУУ 
	|					 + ВЫБОР 
	|							КОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиУУ > 0
	|								ТОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиУУ 
	|							ИНАЧЕ 0 
	|						КОНЕЦ 
	|					- ВЫБОР 
	|							КОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиУУ > 0
	|								ТОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиУУ 
	|							ИНАЧЕ 0 
	|						КОНЕЦ
	|		ИНАЧЕ ПервоначальныеСведения.ПервоначальнаяСтоимостьУУ
	|	КОНЕЦ КАК ПервоначальнаяСтоимостьУУ,
	|
	// ПервоначальнаяСтоимостьБУ
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьБУ 
	|		 + ВЫБОР 
	|				КОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ > 0
	|					ТОГДА ТаблицаПереоценки.СуммаДооценкиСтоимостиБУ 
	|				ИНАЧЕ 0 
	|			КОНЕЦ 
	|		- ВЫБОР 
	|				КОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиБУ > 0
	|					ТОГДА ТаблицаПереоценки.СуммаУценкиСтоимостиБУ 
	|				ИНАЧЕ 0 
	|			КОНЕЦ                                               КАК ПервоначальнаяСтоимостьБУ,
	|
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьНУ            КАК ПервоначальнаяСтоимостьНУ,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьПР            КАК ПервоначальнаяСтоимостьПР,
	|	ПервоначальныеСведения.ПервоначальнаяСтоимостьВР            КАК ПервоначальнаяСтоимостьВР,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииБУ         КАК МетодНачисленияАмортизацииБУ,
	|	ПервоначальныеСведения.МетодНачисленияАмортизацииНУ         КАК МетодНачисленияАмортизацииНУ,
	|	ПервоначальныеСведения.Коэффициент                          КАК Коэффициент,
	|	ПервоначальныеСведения.АмортизацияДо2002                    КАК АмортизацияДо2002,
	|	ПервоначальныеСведения.АмортизацияДо2009                    КАК АмортизацияДо2009,
	|	ПервоначальныеСведения.СтоимостьДо2002                      КАК СтоимостьДо2002,
	|	ПервоначальныеСведения.ФактическийСрокИспользованияДо2009   КАК ФактическийСрокИспользованияДо2009,
	|	ПервоначальныеСведения.ДатаПриобретения                     КАК ДатаПриобретения,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуУУ                 КАК ДатаПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДатаПринятияКУчетуБУ                 КАК ДатаПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуУУ             КАК ДокументПринятияКУчетуУУ,
	|	ПервоначальныеСведения.ДокументПринятияКУчетуБУ             КАК ДокументПринятияКУчетуБУ,
	|	ПервоначальныеСведения.ПорядокУчетаНУ                       КАК ПорядокУчетаНУ,
	|	ПервоначальныеСведения.ДокументСписания                     КАК ДокументСписания
	|ИЗ
	|	ТаблицаПереоценки КАК ТаблицаПереоценки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(
	|			&Период,
	|			Организация = &Организация
	|			И Регистратор <> &Ссылка
	|			И НематериальныйАктив В
	|					(ВЫБРАТЬ
	|						СписокНМА.НематериальныйАктив
	|					ИЗ
	|						втСписокНМА КАК СписокНМА)
	|		) КАК ПервоначальныеСведения
	|	ПО ТаблицаПереоценки.НематериальныйАктив = ПервоначальныеСведения.НематериальныйАктив
	|ГДЕ
	|	НЕ ПервоначальныеСведения.НематериальныйАктив ЕСТЬ NULL";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаНМАЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ПереоценкаНМАЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ПереоценкаНМАЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
