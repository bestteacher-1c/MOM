#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция возвращает структуру значений по умолчанию для документа для движений.
//
// Возвращаемое значение:
//	Структура - значения по умолчанию
//
Функция ЗначенияПолейЗаписиРегистраПоУмолчанию(Основание, СсылкаНаОформляемыйДокумент) Экспорт
	
	СтруктураЗначенияПоУмолчанию = Новый Структура;
	
	СтруктураЗначенияПоУмолчанию.Вставить("Документ",         СсылкаНаОформляемыйДокумент);
	СтруктураЗначенияПоУмолчанию.Вставить("Основание",        Основание);
	
	СтруктураЗначенияПоУмолчанию.Вставить("СтатусОформления", Перечисления.СтатусыОформленияДокументовГосИС.НеОформлено);
	СтруктураЗначенияПоУмолчанию.Вставить("Архивный", Ложь);
	
	СтруктураЗначенияПоУмолчанию.Вставить("Дата",  '00010101');
	СтруктураЗначенияПоУмолчанию.Вставить("Номер", "");
	СтруктураЗначенияПоУмолчанию.Вставить("Контрагент");
	СтруктураЗначенияПоУмолчанию.Вставить("ТорговыйОбъект");
	СтруктураЗначенияПоУмолчанию.Вставить("ПроизводственныйОбъект");
	СтруктураЗначенияПоУмолчанию.Вставить("Ответственный");
	СтруктураЗначенияПоУмолчанию.Вставить("ДополнительнаяИнформация");
	
	Возврат СтруктураЗначенияПоУмолчанию;
	
КонецФункции

// Проверяет наличие записей в регистре по указанным документам-основаниям и документу ВЕТИС.
//
Функция ДокументыОснованияСЗаписямиРегистра(МассивДокументов, ПустаяСсылкаВЕТИС) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СтатусыОформления.Основание,
	|	СтатусыОформления.Архивный
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК СтатусыОформления
	|ГДЕ
	|	СтатусыОформления.Основание В (&МассивДокументов)
	|	И СтатусыОформления.Документ = &ПустаяСсылкаВЕТИС";
	
	Запрос.УстановитьПараметр("МассивДокументов",  МассивДокументов);
	Запрос.УстановитьПараметр("ПустаяСсылкаВЕТИС", ПустаяСсылкаВЕТИС);
	
	Результат = Новый Структура("Неоформленные, Архивные", Новый Массив, Новый Массив);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.Архивный Тогда
			Результат.Архивные.Добавить(Выборка.Основание);
		Иначе
			Результат.Неоформленные.Добавить(Выборка.Основание);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Осуществляет запись в регистр по переданным данным.
//
// Параметры:
//  ДанныеЗаписи - данные для записи в регистр
//
Процедура ВыполнитьЗаписьВРегистр(ДанныеЗаписи) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ДанныеЗаписи);
	
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

//Удаляет запись из регистра по переданному документу.
//
//Параметры:
//   Документ  - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления - измерение регистра для очистки.
//   Основание - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС     - измерение регистра для очистки.
//
Процедура УдалитьЗаписьРегистра(Основание, Документ) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Основание.Установить(Основание);
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Архивирует записи из регистра по переданным документам.
//
// Параметры:
//   Основания - Массив Из ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - массив распоряжений
//   Документ  - ОпределяемыйТип.ДокументыВЕТИСПоддерживающиеСтатусыОформления - документ, данные по которому необходимо архивировать
// Возвращаемое значение:
// 	Массив - Выполненные изменения.
//
Функция АрхивироватьРаспоряженияКОформлению(Основания, Документ) Экспорт
	
	Изменения = Новый Массив;
	
	НаборЗаписей = РегистрыСведений.СтатусыОформленияДокументовВЕТИС.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Документ.Установить(Документ);
	
	Если Не ПравоДоступа("Изменение", Документ.Метаданные()) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для обработки распоряжений к оформлению'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Для Каждого Основание Из Основания Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяРегистра());
			ЭлементБлокировки.УстановитьЗначение("Документ",  Документ);
			ЭлементБлокировки.УстановитьЗначение("Основание", Основание);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			НаборЗаписей.Отбор.Основание.Установить(Основание);
			НаборЗаписей.Прочитать();
			Если НаборЗаписей.Выбран() Тогда
				
				Для Каждого СтрокаТЧ Из НаборЗаписей Цикл
					СтрокаТЧ.Архивный = Истина;
				КонецЦикла;
				
				НаборЗаписей.Записать();
				
				СтрокаРезультата = ИнтеграцияВЕТИСКлиентСервер.СтруктураИзменения();
				СтрокаРезультата.Объект            = Документ;
				СтрокаРезультата.ДокументОснование = Основание;
				
				Изменения.Добавить(СтрокаРезультата);
				
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ТекстСообщения = СтрШаблон(
				НСтр("ru = 'Не удалось архивировать распоряжение к оформлению %1 по причине: %2'"),
				Основание, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(НСтр("ru='ВетИС'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.РегистрыСведений.СтатусыОформленияДокументовВЕТИС,
				Основание,
				ТекстСообщения);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Изменения;
	
КонецФункции

// Возвращает статусы оформления документов ВЕТИС по указанному документу-основанию.
//
// Параметры:
//	ДокументОснование - ОпределяемыйТип.ОснованиеСтатусыОформленияДокументовВЕТИС - документ-основание для документа ВЕТИС
//
// Возвращаемое значение:
//	Структура
//		Ключ - имя документа ВЕТИС как оно указано в метаданных
//		Значение - ПеречислениеСсылка.СтатусыОформленияДокументовГосИС - статус оформления
//
Функция СтатусыДокументовВЕТИСПоДокументуОснованию(ДокументОснование) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Статусы.Документ,
	|	Статусы.СтатусОформления КАК Статус,
	|	Статусы.Архивный КАК Архивный
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовВЕТИС КАК Статусы
	|ГДЕ
	|	Статусы.Основание = &ДокументОснование";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	СтатусыОформления = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
		СтатусыОформления.Вставить(Выборка.Документ.Метаданные().Имя,
			Новый Структура("Статус, Архивный", Выборка.Статус, Выборка.Архивный));
	КонецЦикла;
	
	Возврат СтатусыОформления;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолноеИмяРегистра()
	
	Возврат "РегистрСведений.СтатусыОформленияДокументовВЕТИС";
	
КонецФункции

#КонецОбласти

#КонецЕсли
