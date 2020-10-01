#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Предназначена для удаления группировок товарных ограничений, если эти группировки не содержат детальных записей
// по товарам в РС "Товарные ограничения".
//
// Параметры:
//		МассивСсылок - массив - содержит ссылки на элементы справочника ГруппировкиТоварныхОграничений,
//								которые нужно удалить.
//
Процедура УдалитьНеиспользуемыеГруппировки(МассивСсылок) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СпрГруппировки.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ГруппировкиТоварныхОграничений КАК СпрГруппировки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныеОграничения КАК ТаблицаТоварныеОграничения
		|		ПО (ТаблицаТоварныеОграничения.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
		|			И (ТаблицаТоварныеОграничения.Группировка = СпрГруппировки.Ссылка)
		|ГДЕ
		|	СпрГруппировки.Ссылка В(&МассивСсылок)
		|	И ТаблицаТоварныеОграничения.Группировка ЕСТЬ NULL";
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Набор = РегистрыСведений.ТоварныеОграничения.СоздатьНаборЗаписей();
	Набор.Отбор.Номенклатура.Установить(Справочники.Номенклатура.ПустаяСсылка());
	Пока Выборка.Следующий() Цикл
		Набор.Отбор.Группировка.Установить(Выборка.Ссылка);
		Набор.Записать();
		Выборка.Ссылка.ПолучитьОбъект().Удалить();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяНовойГруппировкиПоУмолчанию(КлючНастройки) Экспорт
	
	ТаблицаГруппировок = Новый ТаблицаЗначений();
	ТаблицаГруппировок.Колонки.Добавить("Номенклатура",
		Новый ОписаниеТипов("СправочникСсылка.ТоварныеКатегории, СправочникСсылка.Номенклатура"));
	ТаблицаГруппировок.Колонки.Добавить("Склад",
		Новый ОписаниеТипов("СправочникСсылка.Склады, СправочникСсылка.ФорматыМагазинов"));
	ТаблицаГруппировок.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число"));
	
	Если ЗначениеЗаполнено(КлючНастройки.Склад)
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегории")
		И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = Неопределено;
		НоваяСтрока.Склад         = КлючНастройки.Склад;
		НоваяСтрока.Порядок = 0;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Формат) И Не ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегории") Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = Неопределено;
		НоваяСтрока.Склад         = КлючНастройки.Формат;
		НоваяСтрока.Порядок = 1;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Категория) И Не ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов") Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = КлючНастройки.Категория;
		НоваяСтрока.Склад         = Неопределено;
		НоваяСтрока.Порядок = 2;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Категория) И ЗначениеЗаполнено(КлючНастройки.Формат) Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = КлючНастройки.Категория;
		НоваяСтрока.Склад         = КлючНастройки.Формат;
		НоваяСтрока.Порядок = 3;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Категория) И ЗначениеЗаполнено(КлючНастройки.Склад) Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = КлючНастройки.Категория;
		НоваяСтрока.Склад         = КлючНастройки.Склад;
		НоваяСтрока.Порядок = 4;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Номенклатура)
		И (Не ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов")
			Или ОбщегоНазначения.ЗначениеРеквизитаОбъекта(КлючНастройки.Номенклатура, "ТипНоменклатуры")
				= Перечисления.ТипыНоменклатуры.Работа) Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = КлючНастройки.Номенклатура;
		НоваяСтрока.Склад         = Неопределено;
		НоваяСтрока.Порядок = 5;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КлючНастройки.Номенклатура) И ЗначениеЗаполнено(КлючНастройки.Формат) Тогда
		
		НоваяСтрока = ТаблицаГруппировок.Добавить();
		НоваяСтрока.Номенклатура  = КлючНастройки.Номенклатура;
		НоваяСтрока.Склад         = КлючНастройки.Формат;
		НоваяСтрока.Порядок = 6;
		
	КонецЕсли;
	
	ТаблицаГруппировок.Сортировать("Порядок");
	Номенклатура = Неопределено;
	Склад        = Неопределено;
	Если ТаблицаГруппировок.Количество() > 0 Тогда
		
		СтрокаТаблицы = ТаблицаГруппировок[ТаблицаГруппировок.Количество() - 1];
		Номенклатура = СтрокаТаблицы.Номенклатура;
		Склад        = СтрокаТаблицы.Склад;
		ШаблонИмени = ПредставлениеГруппировки(Номенклатура, Склад);
		
	Иначе
		ШаблонИмени = НСтр("ru = 'Новый'");
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ШаблонИмени", ШаблонИмени + "%");
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СпрГруппыНастроек.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ГруппировкиТоварныхОграничений КАК СпрГруппыНастроек
		|ГДЕ
		|	СпрГруппыНастроек.Наименование ПОДОБНО &ШаблонИмени";
	
	Номер = -1;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НомерВБазе = СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрЗаменить(Выборка.Наименование, ШаблонИмени, ""));
		Номер = Макс(НомерВБазе, Номер);
		
	КонецЦикла;
	СтруктураРезультата = Новый Структура("Номенклатура, Склад, Наименование", Номенклатура, Склад,
		?(Номер = -1, ШаблонИмени, ШаблонИмени + " " + Строка(Номер + 1)));
	Возврат СтруктураРезультата;
	
КонецФункции

#КонецОбласти

Функция ПредставлениеГруппировки(Номенклатура, Склад)
	
	Если Не ЗначениеЗаполнено(Номенклатура) И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Любые товары на складах формата ""%1""'"), Склад);
		
	ИначеЕсли Не ЗначениеЗаполнено(Номенклатура) И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Любые товары на складе ""%1""'"), Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '""%1"" на складах формата ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И Не ЗначениеЗаполнено(Склад) Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '""%1"" на любом складе'"), Номенклатура);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '""%1"" на складах формата ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.Номенклатура")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '""%1"" с любой характеристикой на складе ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И Не ЗначениеЗаполнено(Склад) Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Товары категории ""%1"" на любом складе'"), Номенклатура);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.ФорматыМагазинов") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Товары категории ""%1"" на складах формата ""%2""'"), Номенклатура, Склад);
		
	ИначеЕсли ТипЗнч(Номенклатура) = Тип("СправочникСсылка.ТоварныеКатегории")
		И ТипЗнч(Склад) = Тип("СправочникСсылка.Склады") Тогда
		
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Товары категории ""%1"" на складе ""%2""'"), Номенклатура, Склад);
		
	Иначе
		
		Представление = НСтр("ru = 'Новый'");
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов") Тогда
		Представление = СтрЗаменить(Представление, НСтр("ru = 'на любом складе'"), "");
		Представление = СокрП(Представление);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#КонецЕсли