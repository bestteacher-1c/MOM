#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует описание групп технологических параметров.
//
// Параметры:
//	Операция - ПеречислениеСсылка.ОперацииЗакрытияМесяца
//
// Возвращаемое значение:
//	ТаблицаЗначений - описание групп параметров; структуру таблицы см. в коде процедуры ИнициализироватьОписаниеГруппПараметровОперации().
//
Функция ОписаниеГруппПараметровОперации(Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииЗакрытияМесяца.ПустаяСсылка() Тогда
		ОписаниеГруппПараметров = ЗакрытиеМесяцаСервер.ОписаниеГруппПараметровОперацииЗакрытияМесяца();
	ИначеЕсли Операция = Перечисления.ОперацииЗакрытияМесяца.РасчетПартийИСебестоимости Тогда
		ОписаниеГруппПараметров = РасчетСебестоимостиПрикладныеАлгоритмы.ОписаниеГруппПараметровОперацииЗакрытияМесяца();
	Иначе // у операции нет групп настраиваемых параметров
		ОписаниеГруппПараметров = Неопределено;
	КонецЕсли;
	
	Возврат ОписаниеГруппПараметров;
	
КонецФункции

// Формирует описание технологических параметров.
//
// Параметры:
//	Операция - ПеречислениеСсылка.ОперацииЗакрытияМесяца
//
// Возвращаемое значение:
//	ТаблицаЗначений - описание параметров; структуру таблицы см. в коде процедуры ИнициализироватьОписаниеПараметровОперации().
//
Функция ОписаниеПараметровОперации(Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииЗакрытияМесяца.ПустаяСсылка() Тогда
		
		ОписаниеПараметров = ЗакрытиеМесяцаСервер.ОписаниеТехнологическихПараметровЗакрытияМесяца();
		
	ИначеЕсли Операция = Перечисления.ОперацииЗакрытияМесяца.РасчетПартийИСебестоимости Тогда
		
		ОписаниеПараметров = РасчетСебестоимостиПрикладныеАлгоритмы.ОписаниеПараметровОперацииЗакрытияМесяца();
		
	//++ НЕ УТ
	ИначеЕсли Операция = Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииОС
	 ИЛИ Операция = Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА Тогда
		
		ОписаниеПараметров = ВнеоборотныеАктивы.ОписаниеПараметровОперацииЗакрытияМесяца();
		
	//-- НЕ УТ
	Иначе // у операции нет настраиваемых параметров
		
		ОписаниеПараметров = Неопределено;
		
	КонецЕсли;
	
	Возврат ОписаниеПараметров;
	
КонецФункции

// Формирует описание одинаковых параметров, используемых в нескольких операциях.
// При интерактивном изменении значения такого параметра в одной операции синхронно изменяются
// значения аналогичных параметров в других операциях.
// Синхронизируемые параметры должны иметь одинаковое имя во всех операциях.
//
// Возвращаемое значение:
//	ТаблицаЗначений - описание параметров; структуру таблицы см. в коде процедуры.
//
Функция ОписаниеСинхронизируемыхПараметровОпераций() Экспорт
	
	ТаблицаПараметров = Новый ТаблицаЗначений;
	
	ТаблицаПараметров.Колонки.Добавить("Имя",      Новый ОписаниеТипов("Строка")); // служебное имя параметра, как в ОписаниеПараметровОперации()
	ТаблицаПараметров.Колонки.Добавить("Операции", Новый ОписаниеТипов("Массив")); // синхронизируемые операции
	
	ТаблицаПараметров.Индексы.Добавить("Имя");
	
	//++ НЕ УТ
	ОписаниеПараметров = ТаблицаПараметров.Добавить();
	ОписаниеПараметров.Имя = "МаксимальноеКоличествоЗаданийДляРасчетаАмортизации";
	ОписаниеПараметров.Операции.Добавить(Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииОС);
	ОписаниеПараметров.Операции.Добавить(Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА);
	//-- НЕ УТ
	
	Возврат ТаблицаПараметров;
	
КонецФункции

// Формирует пустую таблицу для описания групп технологических параметров.
//
// Возвращаемое значение:
//	ТаблицаЗначений - описание групп параметров.
//
Функция ИнициализироватьОписаниеГруппПараметровОперации() Экспорт
	
	ТаблицаГруппПараметров = Новый ТаблицаЗначений;
	
	ТаблицаГруппПараметров.Колонки.Добавить("Имя",			Новый ОписаниеТипов("Строка")); // уникальное служебное имя группы
	ТаблицаГруппПараметров.Колонки.Добавить("Наименование",	Новый ОписаниеТипов("Строка")); // представление группы
	ТаблицаГруппПараметров.Колонки.Добавить("Описание",		Новый ОписаниеТипов("Строка")); // подробное описание назначения группы
	ТаблицаГруппПараметров.Колонки.Добавить("Скрыть", 		Новый ОписаниеТипов("Булево")); // параметры группы недоступны для интерактивного изменения
	
	// Добавим индексы таблицы.
	ТаблицаГруппПараметров.Индексы.Добавить("Имя");
	
	Возврат ТаблицаГруппПараметров;
	
КонецФункции

// Формирует пустую таблицу для описания технологических параметров.
//
// Возвращаемое значение:
//	ТаблицаЗначений - описание параметров.
//
Функция ИнициализироватьОписаниеПараметровОперации() Экспорт
	
	ТаблицаПараметров = Новый ТаблицаЗначений;
	
	ТаблицаПараметров.Колонки.Добавить("Имя",			Новый ОписаниеТипов("Строка")); // уникальное служебное имя параметра
	ТаблицаПараметров.Колонки.Добавить("Наименование",	Новый ОписаниеТипов("Строка")); // представление параметра
	ТаблицаПараметров.Колонки.Добавить("Описание",		Новый ОписаниеТипов("Строка")); // подробное описание назначения параметра
	
	ТаблицаПараметров.Колонки.Добавить("СтарыеИмена",	Новый ОписаниеТипов("Строка")); // необязательный; значения имени в предыдущих версиях (через запятую)
	
	ТаблицаПараметров.Колонки.Добавить("Родитель",		Новый ОписаниеТипов("Строка")); // необязательный; имя группы, см. ИнициализироватьОписаниеГруппПараметровОперации()
	
	ТаблицаПараметров.Колонки.Добавить("ТипЗначения",	Новый ОписаниеТипов("ОписаниеТипов"));     // тип параметра
	ТаблицаПараметров.Колонки.Добавить("СписокВыбора",	Новый ОписаниеТипов("СписокЗначений"));    // необязательный; возможные значения параметра (без ручного ввода) - имеет приоритет над "диапазоном"
	
	ТаблицаПараметров.Колонки.Добавить("ДиапазонС",		Новый ОписаниеТипов("Число, Дата")); // необязательный; возможное минимальное значение параметра
	ТаблицаПараметров.Колонки.Добавить("ДиапазонПо",	Новый ОписаниеТипов("Число, Дата")); // необязательный; возможное максимальное значение параметра
	
	ТаблицаПараметров.Колонки.Добавить("Скрыть", 		Новый ОписаниеТипов("Булево")); // значение параметра недоступно для интерактивного изменения
	
	ТаблицаПараметров.Колонки.Добавить("ЗначениеПоУмолчанию");    // значение параметра по умолчанию
	ТаблицаПараметров.Колонки.Добавить("ДополнительныеСвойства"); // необязательный; произвольные данные для операции закрытия месяца
	
	// Добавим индексы таблицы.
	ТаблицаПараметров.Индексы.Добавить("Имя");
	ТаблицаПараметров.Индексы.Добавить("Родитель");
	
	Возврат ТаблицаПараметров;
	
КонецФункции

// Возвращает пользовательские значения технологических параметров.
//
// Параметры:
//	Операция - ПеречислениеСсылка.ОперацииЗакрытияМесяца
//	СкрытыеИмеютЗначенияПоУмолчанию - Булево - для скрытых параметров будет возвращено
//		значение по умолчанию независимо от наличия измененного значения
//
// Возвращаемое значение:
//	Структура - значения параметров
//		Ключ - имя параметра
//		Значение - значение параметра; если значение не изменялось, то возвращается значение параметра по умолчанию.
//
Функция УстановленныеЗначенияПараметровОперации(Операция, СкрытыеИмеютЗначенияПоУмолчанию = Истина) Экспорт
	
	Результат = Новый Структура;
	ОписаниеПараметров = ОписаниеПараметровОперации(Операция);
	
	Если ОписаниеПараметров = Неопределено Тогда
		ОписаниеПараметров = ИнициализироватьОписаниеПараметровОперации();
	КонецЕсли;
	
	// Получим сохраненные значения параметров.
	УстановитьПривилегированныйРежим(Истина);
	СохраненныеНастройки = Константы.НастройкиЗакрытияМесяца.Получить().Получить(); // получим содержимое хранилища значения
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ТипЗнч(СохраненныеНастройки) = Тип("Соответствие") Тогда
		СохраненныеНастройки = СохраненныеНастройки.Получить(Операция); // получим параметры операции закрытия месяца
	Иначе
		СохраненныеНастройки = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СохраненныеНастройки) ИЛИ ТипЗнч(СохраненныеНастройки) <> Тип("Структура") Тогда
		СохраненныеНастройки = Новый Структура; // нет сохраненных параметров для операции
	КонецЕсли;
	
	СохраненноеЗначение = Неопределено;
	
	Для Каждого ТекущаяСтрока Из ОписаниеПараметров Цикл
		
		Результат.Вставить(ТекущаяСтрока.Имя, ТекущаяСтрока.ЗначениеПоУмолчанию); // для начала примем значение равным значению по умолчанию
		
		Если СкрытыеИмеютЗначенияПоУмолчанию И ТекущаяСтрока.Скрыть Тогда
			Продолжить; // значение по умолчанию независимо от наличия измененного значения
		КонецЕсли;
		
		Изменено = СохраненныеНастройки.Свойство(ТекущаяСтрока.Имя, СохраненноеЗначение);
		
		Если НЕ Изменено И ЗначениеЗаполнено(ТекущаяСтрока.СтарыеИмена) Тогда
			
			// Проверим, возможно есть сохраненные значения со старым именем параметра.
			СтарыеИмена = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекущаяСтрока.СтарыеИмена);
			
			Для Каждого СтароеИмя Из СтарыеИмена Цикл
				
				Изменено = СохраненныеНастройки.Свойство(СокрЛП(СтароеИмя), СохраненноеЗначение);
				
				Если Изменено Тогда
					Прервать; // есть сохраненное значение
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если НЕ Изменено ИЛИ НЕ ТекущаяСтрока.ТипЗначения.СодержитТип(ТипЗнч(СохраненноеЗначение)) Тогда
			Продолжить; // значение по умолчанию
		КонецЕсли;
		
		// Проверим, что СохраненноеЗначение имеет допустимое значение.
		Если ЗначениеЗаполнено(ТекущаяСтрока.СписокВыбора) Тогда
			
			Если ТекущаяСтрока.СписокВыбора.НайтиПоЗначению(СохраненноеЗначение) = Неопределено Тогда
				Продолжить; // значение по умолчанию
			КонецЕсли;
			
		ИначеЕсли ТекущаяСтрока.ДиапазонС <> ТекущаяСтрока.ДиапазонПо Тогда // задан диапазон
			
			Если ТекущаяСтрока.ДиапазонС <> Неопределено И СохраненноеЗначение < ТекущаяСтрока.ДиапазонС Тогда
				Продолжить; // значение по умолчанию
			ИначеЕсли ТекущаяСтрока.ДиапазонПо <> Неопределено И СохраненноеЗначение > ТекущаяСтрока.ДиапазонПо Тогда
				Продолжить; // значение по умолчанию
			КонецЕсли;
				
		КонецЕсли;
		
		Результат.Вставить(ТекущаяСтрока.Имя, СохраненноеЗначение); // есть сохраненное значение и это значение соответствует всем ограничениям
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает значения технологических параметров всех операций.
//
Функция ПрочитатьВсеПараметры() Экспорт
	
	ВсеПараметры = Новый Соответствие;
	
	ПрочитатьПараметрыОперации(Перечисления.ОперацииЗакрытияМесяца.ПустаяСсылка(), ВсеПараметры);
	
	Для Каждого Мета Из Метаданные.Перечисления.ОперацииЗакрытияМесяца.ЗначенияПеречисления Цикл
		ПрочитатьПараметрыОперации(Перечисления.ОперацииЗакрытияМесяца[Мета.Имя], ВсеПараметры);
	КонецЦикла;
	
	Возврат ВсеПараметры;
	
КонецФункции

// Возвращает значения технологических параметров указанной операции.
//
Процедура ПрочитатьПараметрыОперации(Операция, ВсеПараметры)
	
	ОписаниеПараметров = ОписаниеПараметровОперации(Операция);
	
	Если НЕ ЗначениеЗаполнено(ОписаниеПараметров) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеГруппПараметров = ОписаниеГруппПараметровОперации(Операция);
	ЗначенияПараметров = УстановленныеЗначенияПараметровОперации(Операция, Ложь);
	
	ВсеПараметры.Вставить(
		Операция,
		Новый Структура("ОписаниеГруппПараметров, ОписаниеПараметров, ЗначенияПараметров", ОписаниеГруппПараметров, ОписаниеПараметров, ЗначенияПараметров));
	
КонецПроцедуры

// Сохраняет измененные технологических параметры.
// В хранилище настроек находится соответствие:
//	Ключ - элемент перечисления ОперацииЗакрытияМесяца
//	Значение - структура параметров данного этапа
//		Ключ - имя параметра
//		Значение - значение параметра.
//
Функция СохранитьВсеПараметры(ВсеПараметры) Экспорт
	
	СохраненныеНастройки = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из ВсеПараметры Цикл
		
		ПараметрыОперации = Новый Структура;
		
		Для Каждого ОписаниеПараметра Из КлючИЗначение.Значение.ОписаниеПараметров Цикл
			
			ЗначениеПараметра = КлючИЗначение.Значение.ЗначенияПараметров[ОписаниеПараметра.Имя];
			
			Если ЗначениеПараметра <> ОписаниеПараметра.ЗначениеПоУмолчанию Тогда
				ПараметрыОперации.Вставить(ОписаниеПараметра.Имя, ЗначениеПараметра); // сохраним измененное
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ПараметрыОперации) Тогда
			СохраненныеНастройки.Вставить(КлючИЗначение.Ключ, ПараметрыОперации);
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.НастройкиЗакрытияМесяца.Установить(Новый ХранилищеЗначения(СохраненныеНастройки, Новый СжатиеДанных(9)));
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецФункции

#КонецОбласти

#КонецЕсли
