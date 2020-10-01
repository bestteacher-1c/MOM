////////////////////////////////////////////////////////////////////////////////
// ОУП: Процедуры подсистемы оперативного учета производства
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


#КонецОбласти

#Область СлужебныеПроцедурыИФункции


// Возвращает структуру заполнения для формирования документов выработки по переданному отбору или строкам распоряжений.
// В функции выполняется анализ количества документов к формированию, если требуется сформировать один документ, то
// возвращается структура заполнения, иначе параметры отбора для группового формирования.
//
// Параметры:
//	Отбор	- Структура - Содержит данные для отбора:
//  						* Распоряжения - документы, на основании которых оформляется выработка
//  						* Подразделения - подразделения, по которым оформляется выработка
//	Идентификаторы	- Массив - идентификаторы, если следующим параметром передается коллекция аналитик к оформлению
//	Коллекция	- ДанныеФормыКоллекция - коллекция аналитик, по которым оформляется выработка.
//
// Возвращаемое значение:
//   Структура   - содержит поля для заполнения новых документов.
//
Функция ПараметрыОформленияВыработкиСотрудников(Отбор = Неопределено, Идентификаторы = Неопределено, Коллекция = Неопределено) Экспорт
	
	Если Отбор <> Неопределено Тогда
		КОформлению = Документы.ВыработкаСотрудников.ТрудозатратыКОформлению(Отбор);
		Строки = КОформлению.Выгрузить();
	Иначе
		Строки = Идентификаторы;
	КонецЕсли;
	
	Если Строки.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Подразделения = Новый Массив;
	Периоды = Новый Массив;
	Бригады = Новый Массив;
	Работники = Новый Массив;
	Организации = Новый Массив;
	Распоряжения = Новый Массив;
	ВидыНарядов = Новый Массив;
	
	// параметры проверки количества документов
	ТекущаяОрганизация = Неопределено;
	ТекущееПодразделение = Неопределено;
	ТекущийВидНаряда = Неопределено;
	ТекущаяБригада = Неопределено;
	ТекущееНачалоПериода = Неопределено;
	ТекущийКонецПериода = Неопределено;
	
	ТребуетсяОдинДокумент = Истина;
	
	Для Каждого Итератор Из Строки Цикл
		
		Если Коллекция <> Неопределено Тогда
			Строка = Коллекция.НайтиПоИдентификатору(Итератор);
		Иначе
			Строка = Итератор;
		КонецЕсли;
		
		Если ТекущаяОрганизация = Неопределено Тогда
			ТекущаяОрганизация = Строка.Организация;
		ИначеЕсли ТекущаяОрганизация <> Строка.Организация Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;
		
		Если ТекущееПодразделение = Неопределено Тогда
			ТекущееПодразделение = Строка.Подразделение;
		ИначеЕсли ТекущееПодразделение <> Строка.Подразделение Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;
		
		Если ТекущийВидНаряда = Неопределено Тогда
			ТекущийВидНаряда = Строка.ВидНаряда;
		ИначеЕсли ТекущийВидНаряда <> Строка.ВидНаряда Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;
		
		Если ТекущаяБригада = Неопределено И ЗначениеЗаполнено(Строка.Бригада) Тогда
			ТекущаяБригада = Строка.Бригада;
		ИначеЕсли ТекущаяБригада <> Строка.Бригада И ЗначениеЗаполнено(Строка.Бригада) Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;
		
		Если ТекущееНачалоПериода = Неопределено Тогда
			ТекущееНачалоПериода = Строка.НачалоПериода;
		ИначеЕсли ТекущееНачалоПериода <> Строка.НачалоПериода Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;
		
		Если ТекущийКонецПериода = Неопределено Тогда
			ТекущийКонецПериода = Строка.КонецПериода;
		ИначеЕсли ТекущийКонецПериода <> Строка.КонецПериода Тогда
			ТребуетсяОдинДокумент = Ложь;
		КонецЕсли;

		Подразделения.Добавить(Строка.Подразделение);
		Периоды.Добавить(Строка.НачалоПериода);
		Организации.Добавить(Строка.Организация);
		ВидыНарядов.Добавить(Строка.ВидНаряда);
		
		Если ЗначениеЗаполнено(Строка.Бригада) Тогда
			Бригады.Добавить(Строка.Бригада);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Работник) Тогда
			Работники.Добавить(Строка.Работник);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Распоряжение) Тогда
			Распоряжения.Добавить(Строка.Распоряжение);
		КонецЕсли;
		
	КонецЦикла;
	
	Результат = Новый Структура;
	
	Результат.Вставить("Подразделения",   Подразделения);
	Результат.Вставить("Периоды",         Периоды);
	Результат.Вставить("Бригады",         Бригады);
	Результат.Вставить("Работники",       Работники);
	Результат.Вставить("Организации",     Организации);
	Результат.Вставить("Распоряжения",    Распоряжения);
	Результат.Вставить("ВидыНарядов",     ВидыНарядов);
	
	Результат.Вставить("ВключатьВПериодВыполненияРабот", Истина);
	
	Результат.Вставить("ТребуетсяОдинДокумент", ТребуетсяОдинДокумент);
	
	Если ТребуетсяОдинДокумент Тогда
		
		Результат.Вставить("Подразделение",     ТекущееПодразделение);
		Результат.Вставить("Организация",       ТекущаяОрганизация);
		Результат.Вставить("ВидНаряда",         ТекущийВидНаряда);
		Результат.Вставить("НачалоПериода",     ТекущееНачалоПериода);
		Результат.Вставить("КонецПериода",      ТекущийКонецПериода);
		
		Если ЗначениеЗаполнено(ТекущаяБригада) Тогда
			Результат.Вставить("Бригада",       ТекущаяБригада);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует документы "Выработка сотрудников" по переданному отбору.
//
// Параметры:
//	Отбор	- Структура - Содержит данные для отбора:
//  						* Распоряжения - документы, на основании которых оформляется выработка
//  						* Подразделения - подразделения, по которым оформляется выработка.
//
// Возвращаемое значение:
//   Структура   - содержит массивы сформированных документов и сообщений пользователю.
//
Функция СформироватьВыработкуСотрудниковПоОтбору(СтруктураОтбора) Экспорт
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(Неопределено);
	Документы.ВыработкаСотрудников.СформироватьДокументы(СтруктураОтбора, АдресВХранилище);
	
	Возврат ПолучитьИзВременногоХранилища(АдресВХранилище);
	
КонецФункции

#КонецОбласти
