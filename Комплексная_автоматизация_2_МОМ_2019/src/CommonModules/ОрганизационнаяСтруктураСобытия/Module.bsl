
#Область СлужебныйПрограммныйИнтерфейс

// Процедура предназначена для обновления структуры предприятия.
//
Процедура ОбновитьСтруктуруПредприятия() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		Возврат;
	КонецЕсли;
	
	Если Константы.СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц.Получить() Тогда
		// Соответствие не установлено - не нужно создавать элемент-«отражение».
		Возврат;
	КонецЕсли;
	
	ОбновитьСтруктуруПредприятияПоТаблицеИсточника(Справочники.Организации.ПустаяСсылка());
	ОбновитьСтруктуруПредприятияПоТаблицеИсточника(Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	
	ОрганизационнаяСтруктура.ОбновитьМестаПозицийШтатногоРасписанияПоСтруктуреЮридическихЛиц();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик подписки на событие СтруктураПредприятияПередЗаписью.
// Выполняется перед записью элемента структуры предприятия для синхронизации пометки удаления.
//
Процедура СтруктураПредприятияПередЗаписью(ПодразделениеПредприятияОбъект, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ПодразделениеПредприятияОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// При записи нужно синхронизировать с объектом структуры-источника пометку удаления.
	Если Не ЗначениеЗаполнено(ПодразделениеПредприятияОбъект.Источник) Тогда
		Возврат;
	КонецЕсли;
	
	ИсточникОбъект = ПодразделениеПредприятияОбъект.Источник.ПолучитьОбъект();
	ИсточникОбъект.ДополнительныеСвойства.Вставить("УстановкаПометкиУдаленияСтруктурыПредприятия", Истина);
	ИсточникОбъект.УстановитьПометкуУдаления(ПодразделениеПредприятияОбъект.ПометкаУдаления);
	
КонецПроцедуры

// Обработчик подписки на событие СтруктураПредприятияИсточникПриЗаписи.
// Выполняется при записи подразделения или организации для актуализации структуры предприятия.
//
Процедура ОбновитьЭлементСтруктурыПредприятия(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ДополнительныеСвойства.Свойство("УстановкаПометкиУдаленияСтруктурыПредприятия") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы") Тогда
		Возврат;
	КонецЕсли;
	
	Если Константы.СтруктураПредприятияНеСоответствуетСтруктуреЮридическихЛиц.Получить() Тогда
		// Соответствие не установлено - не нужно создавать элемент-«отражение».
		Возврат;
	КонецЕсли;
	
	УправленческаяОрганизация = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.Организации.УправленческаяОрганизация");
	Если Источник.Ссылка = УправленческаяОрганизация Тогда 
		Возврат;
	КонецЕсли;
	
	ТаблицаИзмененных = ИзмененныеЭлементыИсточника(Источник.Ссылка);
	Для Каждого СтрокаИсточника Из ТаблицаИзмененных Цикл
		Если ЗначениеЗаполнено(СтрокаИсточника.Ссылка) Тогда
			ПодразделениеОбъект = СтрокаИсточника.Ссылка.ПолучитьОбъект();
		Иначе
			ПодразделениеОбъект = Справочники.СтруктураПредприятия.СоздатьЭлемент();
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПодразделениеОбъект, СтрокаИсточника);
		ЗаполнитьКодПодразделенияПоИсточнику(ПодразделениеОбъект, СтрокаИсточника);
		ПодразделениеОбъект.ДополнительныеСвойства.Вставить("ОбновлениеПоСтруктуреИсточнику", Истина);
		ПодразделениеОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Подготовка обновления регистра "ПодчиненностьСтруктурныхЕдиниц" при изменениях в справочнике СтруктураПредприятия.
// Обработчик события ПередЗаписью() этого справочника.
//
Процедура ПодготовитьОбновлениеПодчиненностиСтруктурныхЕдиниц(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Источник.ЭтоНовый() Тогда
		Источник.ДополнительныеСвойства.Вставить("ЭтоНоваяСтруктурнаяЕдиница", Истина);
	Иначе
		
		ТекущийРодитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "Родитель");
		Если ТекущийРодитель <> Источник.Родитель Тогда
			Источник.ДополнительныеСвойства.Вставить("СменаРодителя", Истина);
			Источник.ДополнительныеСвойства.Вставить("ПредыдущийРодитель", ТекущийРодитель);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Обновление регистра "ПодчиненностьСтруктурныхЕдиниц" при изменениях в справочнике СтруктураПредприятия.
// Обработчик события ПриЗаписи() этого справочника.
//
Процедура ОбновитьПодчиненностьСтруктурныхЕдиниц(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли; 
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЭтоНоваяСтруктурнаяЕдиница = Источник.ДополнительныеСвойства.Свойство("ЭтоНоваяСтруктурнаяЕдиница");
	СменаРодителя = Источник.ДополнительныеСвойства.Свойство("СменаРодителя");
	
	СписокСтруктурныхЕдиниц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Источник.Ссылка);
	
	Если НЕ ЭтоНоваяСтруктурнаяЕдиница И НЕ СменаРодителя Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.ПодчиненностьСтруктурныхЕдиниц.ОбновитьПодчиненностьСтруктурныхЕдиниц(СписокСтруктурныхЕдиниц);
	
	Если СменаРодителя Тогда
		
		ПредыдущийРодитель = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Источник.ДополнительныеСвойства, "ПредыдущийРодитель");
		Если ПредыдущийРодитель = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущийРодитель = Источник.Родитель;
		
		РегистрыСведений.ПодчиненностьСтруктурныхЕдиниц.ОбновитьПодчиненностьСтруктурныхЕдиницПриСменеРодителя(
			Источник.Ссылка, ПредыдущийРодитель, ТекущийРодитель);
			
	КонецЕсли;
		
КонецПроцедуры

// Обновляет состояние структуры предприятия, используя все элементы таблицы источника.
//
Процедура ОбновитьСтруктуруПредприятияПоТаблицеИсточника(ИсточникПустаяСсылка)
	
	ТаблицаИзмененных = ИзмененныеЭлементыИсточника(ИсточникПустаяСсылка);
	
	Если ТаблицаИзмененных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Отдельным запросом получаем иерархию элементов источника 
	// для корректной расстановки связей подразделений структуры предприятия.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаИсточника.Ссылка КАК Источник,
	|	СтруктураПредприятия.Ссылка КАК Ссылка
	|ИЗ
	|	#СтруктураИсточник КАК ТаблицаИсточника
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ПО (СтруктураПредприятия.Источник = ТаблицаИсточника.Ссылка)
	|ГДЕ
	|	ТаблицаИсточника.Ссылка В(&Источник)
	|ИТОГИ ПО
	|	Источник ИЕРАРХИЯ";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#СтруктураИсточник", ИсточникПустаяСсылка.Метаданные().ПолноеИмя());
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Источник", ТаблицаИзмененных.ВыгрузитьКолонку("Источник"));
	
	РезультатИерархии = Запрос.Выполнить();
	
	СоответствиеПодразделений = Новый Соответствие;
	ОбновитьУровеньИерархииСтруктурыПредприятия(РезультатИерархии, ТаблицаИзмененных, СоответствиеПодразделений);
	
КонецПроцедуры

Процедура ОбновитьУровеньИерархииСтруктурыПредприятия(ВыборкаПоГруппировке, ТаблицаИзмененных, СоответствиеПодразделений)
	
	Выборка = ВыборкаПоГруппировке.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока Выборка.Следующий() Цикл
		// Пропускаем, если источник уже обрабатывали на других уровнях группировки.
		Если ЗначениеЗаполнено(Выборка.Источник) 
			И СоответствиеПодразделений[Выборка.Источник] = Неопределено Тогда
			НайденныеСтроки = ТаблицаИзмененных.НайтиСтроки(Новый Структура("Источник", Выборка.Источник));
			Если НайденныеСтроки.Количество() > 0 Тогда
				СтрокаИсточника = НайденныеСтроки[0];
				Если ЗначениеЗаполнено(СтрокаИсточника.Ссылка) Тогда
					ПодразделениеОбъект = СтрокаИсточника.Ссылка.ПолучитьОбъект();
				Иначе
					ПодразделениеОбъект = Справочники.СтруктураПредприятия.СоздатьЭлемент();
				КонецЕсли;
				ЗаполнитьЗначенияСвойств(ПодразделениеОбъект, СтрокаИсточника);
				Родитель = СоответствиеПодразделений[СтрокаИсточника.ИсточникРодитель];
				Если Родитель <> Неопределено И ПодразделениеОбъект.Родитель <> Родитель Тогда
					ПодразделениеОбъект.Родитель = Родитель;
				КонецЕсли;
				ПодразделениеОбъект.ДополнительныеСвойства.Вставить("ОбновлениеПоСтруктуреИсточнику", Истина);
				ЗаполнитьКодПодразделенияПоИсточнику(ПодразделениеОбъект, СтрокаИсточника);
				ПодразделениеОбъект.Записать();
			КонецЕсли;
			СоответствиеПодразделений.Вставить(Выборка.Источник, ПодразделениеОбъект.Ссылка);
		КонецЕсли;
		ОбновитьУровеньИерархииСтруктурыПредприятия(Выборка, ТаблицаИзмененных, СоответствиеПодразделений);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьКодПодразделенияПоИсточнику(ПодразделениеОбъект, СведенияИсточника)
	
	// У организации нет кода, получаем очередной код по порядку.
	Если СведенияИсточника.Код = Неопределено И ПодразделениеОбъект.Ссылка.Пустая() Тогда
		ПодразделениеОбъект.УстановитьНовыйКод();
		Возврат;
	КонецЕсли;
	
	// Код подразделения составляем, добавляя в качестве префикса код организации-родителя.
	Если ТипЗнч(СведенияИсточника.Источник) <> Тип("СправочникСсылка.ПодразделенияОрганизаций") Тогда
		Возврат;
	КонецЕсли;
	
	// Запросом находим код подразделения структуры предприятия, 
	// соответствующего организации подразделения.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Источник", СведенияИсточника.Источник);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПодразделениеВерхнегоУровня.Ссылка,
		|	ПодразделениеВерхнегоУровня.Код
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК ПодразделениеВерхнегоУровня
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|			ПО (Организации.Ссылка = ПодразделенияОрганизаций.Владелец)
		|		ПО (Организации.Ссылка = ПодразделениеВерхнегоУровня.Источник)
		|			И (ПодразделенияОрганизаций.Ссылка = &Источник)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	// Код подразделения формируем как источника с префиксом 
	// последних символов кода подразделения верхнего уровня (соответствующего организации).
	// То есть, если организации соответствует подразделение с кодом "000000001", 
	// а у подразделения организации код "000000023", 
	// у подразделения структуры предприятия будет код "001000023".
	
	ДлинаПрефикса = 3;
	ДлинаКода = Метаданные.НайтиПоТипу(ТипЗнч(СведенияИсточника.Источник)).ДлинаКода;
	
	ПрефиксКода = Прав(Выборка.Код, ДлинаПрефикса);
	ПредлагаемыйКод = ПрефиксКода + Прав(СокрЛП(СведенияИсточника.Код), ДлинаКода - ДлинаПрефикса);
	
	// Проверяем не занят ли этот код?
	Запрос.УстановитьПараметр("Код", ПредлагаемыйКод);
	Запрос.УстановитьПараметр("ТекущееПодразделение", ПодразделениеОбъект.Ссылка);
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Поле1
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Код = &Код
		|	И СтруктураПредприятия.Ссылка <> &ТекущееПодразделение";
	КодЗанят = Не Запрос.Выполнить().Пустой();
	
	Если КодЗанят Тогда
		// Чтобы не допустить нарушение уникальности кода, 
		// в ситуации, когда есть несколько подразделений с одинаковым окончанием кода,
		// получаем новый код с учетом префикса.
		ПодразделениеОбъект.УстановитьНовыйКод(ПрефиксКода);
		Возврат;
	КонецЕсли;
	
	ПодразделениеОбъект.Код = ПредлагаемыйКод;
	
КонецПроцедуры

// Функция предназначена для получения данных по таблице источника структуры предприятия.
//
// Параметры:
//	- Источник - ссылка на элемент структуры источника или пустая ссылка 
//				для определения метаданных.
//
// Возвращаемое значение - таблица значений с изменившимися элементами структуры источника и их данными.
//
Функция ИзмененныеЭлементыИсточника(Источник)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаИсточника.Ссылка КАК Источник,
		|	СтруктураПредприятия.Ссылка КАК Ссылка,
		|	ТаблицаИсточника.ПометкаУдаления КАК ПометкаУдаления,
		|	ТаблицаИсточника.Код КАК Код,
		|	ТаблицаИсточника.Наименование КАК Наименование,
		|	ТаблицаИсточника.Родитель КАК ИсточникРодитель,
		|	ЕСТЬNULL(СтруктураПредприятияРодитель.Ссылка, СтруктураПредприятияВладелец.Ссылка) КАК Родитель,
		|	ИСТИНА КАК СоответствуетСтруктуреЮридическихЛиц
		|ИЗ
		|	#СтруктураИсточник КАК ТаблицаИсточника
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|		ПО (СтруктураПредприятия.Источник = ТаблицаИсточника.Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятияРодитель
		|		ПО (СтруктураПредприятияРодитель.Источник = ТаблицаИсточника.Родитель)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятияВладелец
		|		ПО (СтруктураПредприятияВладелец.Источник = ТаблицаИсточника.Владелец)
		|ГДЕ
		|	(ТаблицаИсточника.Ссылка = &Источник
		|			ИЛИ &ПоВсемЭлементамИсточника)
		|	И ТаблицаИсточника.Предопределенный = ЛОЖЬ
		|	И ТаблицаИсточника.Владелец.Предопределенный = ЛОЖЬ
		|	И (СтруктураПредприятия.Ссылка ЕСТЬ NULL
		|			ИЛИ СтруктураПредприятия.ПометкаУдаления <> ТаблицаИсточника.ПометкаУдаления
		|			ИЛИ СтруктураПредприятия.Код <> ТаблицаИсточника.Код
		|			ИЛИ СтруктураПредприятия.Наименование <> ТаблицаИсточника.Наименование
		|			ИЛИ СтруктураПредприятия.Родитель <> ЕСТЬNULL(СтруктураПредприятияРодитель.Ссылка, СтруктураПредприятияВладелец.Ссылка))";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#СтруктураИсточник", Источник.Метаданные().ПолноеИмя());
	
	Если Источник.Метаданные().ДлинаКода = 0 Тогда
		// Если нет кода - заменяем обращение к полю Код.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"ТаблицаИсточника.Код КАК Код",
		"НЕОПРЕДЕЛЕНО КАК Код");
		// ..И исключаем соединение по коду.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"ИЛИ СтруктураПредприятия.Код <> ТаблицаИсточника.Код",
		"");
	КонецЕсли;
	
	Если Источник.Метаданные().Владельцы.Количество() = 0 Тогда
		// Если справочник не подчинен владельцу, то изменяем заполнение поля Родитель.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"ЕСТЬNULL(СтруктураПредприятияРодитель.Ссылка, СтруктураПредприятияВладелец.Ссылка)",
		"СтруктураПредприятияРодитель.Ссылка");
		// ..И исключаем соединение по владельцу.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятияВладелец
		|		ПО (СтруктураПредприятияВладелец.Источник = ТаблицаИсточника.Владелец)",
		"");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
		|	И ТаблицаИсточника.Владелец.Предопределенный = ЛОЖЬ",
		"");
	КонецЕсли;
	
	Если Не Источник.Метаданные().Иерархический Тогда
		// Если справочник не иерархический, то исключаем использование родителя.
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СтруктураПредприятияРодитель.Ссылка", "НЕОПРЕДЕЛЕНО");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураПредприятия КАК СтруктураПредприятияРодитель
		|		ПО (СтруктураПредприятияРодитель.Источник = ТаблицаИсточника.Родитель)",
		"");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
		|			ИЛИ СтруктураПредприятия.Родитель <> ЕСТЬNULL(СтруктураПредприятияРодитель.Ссылка, СтруктураПредприятияВладелец.Ссылка)",
		"");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаИсточника.Родитель", "НЕОПРЕДЕЛЕНО");
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Источник", Источник);
	Запрос.УстановитьПараметр("ПоВсемЭлементамИсточника", Не ЗначениеЗаполнено(Источник));
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти
