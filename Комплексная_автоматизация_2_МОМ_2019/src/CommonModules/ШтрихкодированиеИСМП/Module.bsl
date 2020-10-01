#Область ПрограммныйИнтерфейс

// Приводит код маркировки к виду, необходимому для системы ИС МП.
// 
// Параметры:
//  СтрокаКодаМаркировки - Структура - Строка кода маркировки.
//  ПараметрыНормализации - Структура - См. ШтрихкодированиеИССлужебный.ПараметрыНормализацииКодаМаркировки
// Возвращаемое значение:
//  Неопределено, Строка - Код маркировки после нормализации.
Функция КодМаркировкиДляПередачиИСМП(СтрокаКодаМаркировки, ПараметрыНормализации) Экспорт
	
	Если СтрокаКодаМаркировки.ВидУпаковки = Перечисления.ВидыУпаковокИС.Потребительская Тогда
		
		ЗначениеДляПоиска = ШтрихкодированиеИССлужебный.НормализоватьКодМаркировки(
			СтрокаКодаМаркировки, СтрокаКодаМаркировки.ВидПродукции, ПараметрыНормализации);
		
	ИначеЕсли СтрокаКодаМаркировки.ВидУпаковки = Перечисления.ВидыУпаковокИС.Логистическая Тогда
		ЗначениеДляПоиска = СтрокаКодаМаркировки.СоставКодаМаркировки.SSCC;
	Иначе
		ЗначениеДляПоиска = СтрокаКодаМаркировки.Штрихкод;
	КонецЕсли;
	
	Возврат ЗначениеДляПоиска;
	
КонецФункции

// Получает вид продукции по GTIN на остатки.
// 
// Параметры:
// 	КодМаркировки - Строка                                    - Код маркировки.
// 	Организация   - Неопределено, ОпределяемыйТип.Организация - Организация, владелец GTIN на остатки.
// Возвращаемое значение:
// 	Неопределено, Массив из ПеречислениеСсылка.ВидыПродукцииИС - Виды продукции кода маркировки остатков.
Функция ВидыПродукцииПоКодуМаркировкиОстатков(КодМаркировки, Организация = Неопределено) Экспорт

	ДанныеРазбора = ШтрихкодированиеИССлужебный.РазобратьКодМаркировки(КодМаркировки);
	Если ДанныеРазбора = Неопределено Или Не ДанныеРазбора.СоставКодаМаркировки.Свойство("GTIN") Тогда
		Возврат Неопределено;
	КонецЕсли;

	МассивДанныхЗаполнения = Новый Массив;

	СтрокаДанных           = Новый Структура;
	СтрокаДанных.Вставить("GTIN", ДанныеРазбора.СоставКодаМаркировки.GTIN);
	СтрокаДанных.Вставить("ВидПродукции");
	СтрокаДанных.Вставить("Номенклатура");
	СтрокаДанных.Вставить("Представление");

	МассивДанныхЗаполнения.Добавить(СтрокаДанных);

	РегистрыСведений.КэшОписанияОстатковИСМП.ЗаполнитьТаблицуПредставленийGTINОстатки(
		МассивДанныхЗаполнения, Организация, , "Представление");

	МассивРезультат = Новый Массив;
	ВидПродукции    = МассивДанныхЗаполнения[0].ВидПродукции;

	Если ЗначениеЗаполнено(ВидПродукции) Тогда
		
		МассивРезультат.Добавить(ВидПродукции);
		
	Иначе
		
		Для Каждого ВидПродукции Из ДанныеРазбора.ВидыПродукции Цикл
			Если ИнтеграцияИСМПКлиентСервер.ВидПродукцииПодлежитМаркировкеОстатков(ВидПродукции) Тогда
				МассивРезультат.Добавить(ВидПродукции);
			КонецЕсли;
		КонецЦикла
		
	КонецЕсли;

	Возврат МассивРезультат;

КонецФункции

#КонецОбласти