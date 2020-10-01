#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
// 
// Возвращаемое значение:
// 	Массив - имена блокируемых реквизитов:
//		* БлокируемыйРеквизит - Строка - Имя блокируемого реквизита.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ВидАналитики1");
	Результат.Добавить("ВидАналитики2");
	Результат.Добавить("ВидАналитики3");
	Результат.Добавить("ВидАналитики4");
	Результат.Добавить("ВидАналитики5");
	Результат.Добавить("ВидАналитики6");
	Результат.Добавить("УчитыватьПоКоличеству");
	Результат.Добавить("УчитыватьПоВалюте");
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа ИЛИ
	|	ЗначениеРазрешено(Ссылка)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Перем ЗначениеПараметра;
	
	Если Параметры.Свойство("ВидБюджета", ЗначениеПараметра) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДопРеквизиты.Значение КАК СтатьяБюджетов,
		|	ДопРеквизиты.Значение.Наименование КАК ТекстПредставление,
		|	ДопРеквизиты.Значение.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.ЭлементыФинансовыхОтчетов КАК ЭлементыВидовБюджетов
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ЭлементыФинансовыхОтчетов.РеквизитыВидаЭлемента КАК ДопРеквизиты
		|		ПО ЭлементыВидовБюджетов.Ссылка = ДопРеквизиты.Ссылка
		|			И (ДопРеквизиты.Реквизит = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РеквизитыЭлементовФинансовыхОтчетов.СтатьяБюджетов))
		|ГДЕ
		|	ЭлементыВидовБюджетов.Владелец = &ВидБюджета
		|	И НЕ ЭлементыВидовБюджетов.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("ВидБюджета", ЗначениеПараметра);
		
	ИначеЕсли Параметры.Свойство("ЕстьАналитика", ЗначениеПараметра) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатьиБюджетов.Ссылка КАК СтатьяБюджетов,
		|	СтатьиБюджетов.Представление  КАК ТекстПредставление,
		|	СтатьиБюджетов.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Справочник.СтатьиБюджетов КАК СтатьиБюджетов
		|ГДЕ
		|	СтатьиБюджетов.ВидАналитики1 = &Аналитика
		|	И СтатьиБюджетов.ВидАналитики2 = &Аналитика
		|	И СтатьиБюджетов.ВидАналитики3 = &Аналитика
		|	И СтатьиБюджетов.ВидАналитики4 = &Аналитика
		|	И СтатьиБюджетов.ВидАналитики5 = &Аналитика
		|	И СтатьиБюджетов.ВидАналитики6 = &Аналитика";
		
		Запрос.УстановитьПараметр("Аналитика", ЗначениеПараметра);

	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		
		ДанныеВыбора = Новый СписокЗначений;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ПометкаУдаления Тогда
				СтруктураЗначение = Новый Структура("Значение, ПометкаУдаления", Выборка.СтатьяБюджетов, Выборка.ПометкаУдаления);
				ДанныеВыбора.Добавить(СтруктураЗначение, Выборка.ТекстПредставление, , БиблиотекаКартинок.ПомеченныйНаУдалениеЭлемент);
			Иначе
				ДанныеВыбора.Добавить(Выборка.СтатьяБюджетов, Выборка.ТекстПредставление);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	//++ НЕ УТ
	Отчеты.ОборотнаяВедомостьБюджетирования.ДобавитьКомандуОтчета(КомандыОтчетов);
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


