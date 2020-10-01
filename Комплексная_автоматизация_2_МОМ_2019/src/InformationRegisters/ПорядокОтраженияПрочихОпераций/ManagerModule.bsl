
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

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

#Область СлужебныеПроцедурыИФункции

Функция РезультатЗапросаПоНастройкамОтраженияВУчете(МассивОрганизаций, Период) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПорядокОтражения.Организация КАК Организация,
	|	ПорядокОтражения.Документ КАК Документ,
	|
	|	ПорядокОтражения.СчетУчета КАК СчетУчета
	|ИЗ
	|	РегистрСведений.ПорядокОтраженияПрочихОпераций КАК ПорядокОтражения
	|ГДЕ
	|	ПорядокОтражения.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ПорядокОтражения.Организация В (&МассивОрганизаций)
	|	
	|УПОРЯДОЧИТЬ ПО
	|	Организация Возр,
	|	Дата Возр,
	|	Документ ВОЗР
	|");
	Запрос.УстановитьПараметр("МассивОрганизаций", МассивОрганизаций);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Возвращает счет учета и аналитики для отражения строк документа в регл. учете
//
// Параметры:
//    ДокументСсылка - ДокументСсылка - Ссылка на документ.
//
// Возвращаемое значение:
//    ТаблицаЗначений - таблица, содержащая порядок отражения строк документа в регл. учете,
//    Неопределено, если для документа нет записей.
Функция ПорядокОтраженияДокумента(ДокументСсылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПорядокОтражения.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ПорядокОтражения.СчетУчета КАК СчетУчета,
	|	ПорядокОтражения.Субконто1 КАК Субконто1,
	|	ПорядокОтражения.Субконто2 КАК Субконто2,
	|	ПорядокОтражения.Субконто3 КАК Субконто3
	|ИЗ
	|	РегистрСведений.ПорядокОтраженияПрочихОпераций КАК ПорядокОтражения
	|ГДЕ
	|	ПорядокОтражения.Документ = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат РезультатЗапроса.Выгрузить();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли