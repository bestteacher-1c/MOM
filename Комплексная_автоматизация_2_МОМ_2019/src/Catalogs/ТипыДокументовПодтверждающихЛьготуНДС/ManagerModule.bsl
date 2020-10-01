#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает тип документа, подтверждающего налоговую льготу по НДС.
//
// Параметры:
//  ВидЭД - ПеречислениеСсылка.ВидыЭД - вид электронного документа, указанный в документе реализации.
//
// Возвращаемое значение:
// 	СправочникСсылка.ТипыДокументовПодтверждающихЛьготуНДС - Тип документа или Неопределено.
//
Функция ТипПодтверждающегоДокументаПоВидуЭД(ВидЭД) Экспорт
	
	Если ВидЭД = Перечисления.ВидыЭД.АктВыполненныхРабот
		ИЛИ ВидЭД = Перечисления.ВидыЭД.АктЗаказчик
		ИЛИ ВидЭД = Перечисления.ВидыЭД.АктИсполнитель
		ИЛИ ВидЭД = Перечисления.ВидыЭД.АктНаПередачуПрав Тогда 
		Возврат Справочники.ТипыДокументовПодтверждающихЛьготуНДС.Акт;
	ИначеЕсли ВидЭД = Перечисления.ВидыЭД.ТОРГ12
		ИЛИ ВидЭД = Перечисления.ВидыЭД.ТОРГ12Покупатель
		ИЛИ ВидЭД = Перечисления.ВидыЭД.ТОРГ12Продавец Тогда 
		Возврат Справочники.ТипыДокументовПодтверждающихЛьготуНДС.Накладная;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик обновления 3.0.51.5
// Устанавливает полное наименование для типов документов.
Процедура УстановитьПолноеНаименование() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТипыДокументовПодтверждающихЛьготуНДС.Ссылка,
	|	ВЫБОР
	|		КОГДА ТипыДокументовПодтверждающихЛьготуНДС.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументовПодтверждающихЛьготуНДС.Акт)
	|			ТОГДА &НаименованиеАкт
	|		КОГДА ТипыДокументовПодтверждающихЛьготуНДС.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументовПодтверждающихЛьготуНДС.Договор)
	|			ТОГДА &НаименованиеДоговор
	|		КОГДА ТипыДокументовПодтверждающихЛьготуНДС.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументовПодтверждающихЛьготуНДС.Накладная)
	|			ТОГДА &НаименованиеТоварнаяНакладная
	|		КОГДА ТипыДокументовПодтверждающихЛьготуНДС.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументовПодтверждающихЛьготуНДС.СправкаРасчет)
	|			ТОГДА &НаименованиеСправкаРасчет
	|		КОГДА ТипыДокументовПодтверждающихЛьготуНДС.Ссылка = ЗНАЧЕНИЕ(Справочник.ТипыДокументовПодтверждающихЛьготуНДС.УПД)
	|			ТОГДА &НаименованиеУПД
	|	КОНЕЦ КАК ПолноеНаименование
	|ИЗ
	|	Справочник.ТипыДокументовПодтверждающихЛьготуНДС КАК ТипыДокументовПодтверждающихЛьготуНДС
	|ГДЕ
	|	ТипыДокументовПодтверждающихЛьготуНДС.ПолноеНаименование = """"
	|	И ТипыДокументовПодтверждающихЛьготуНДС.Предопределенный";
	
	Запрос.УстановитьПараметр("НаименованиеАкт",               НСтр("ru='Акт'"));
	Запрос.УстановитьПараметр("НаименованиеДоговор",           НСтр("ru='Договор'"));
	Запрос.УстановитьПараметр("НаименованиеТоварнаяНакладная", НСтр("ru='Товарная накладная'"));
	Запрос.УстановитьПараметр("НаименованиеСправкаРасчет",     НСтр("ru='Справка-расчет'"));
	Запрос.УстановитьПараметр("НаименованиеУПД",               НСтр("ru='Универсальный передаточный документ'"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТипДокументаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ТипДокументаОбъект.ПолноеНаименование = Выборка.ПолноеНаименование;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ТипДокументаОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли