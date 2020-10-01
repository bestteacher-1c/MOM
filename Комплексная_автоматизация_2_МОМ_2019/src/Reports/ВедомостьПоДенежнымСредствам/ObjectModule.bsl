#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
		
		Для каждого НаборДанных Из НаборыДанныхКУдалению() Цикл
			СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.Удалить(НаборДанных);
		КонецЦикла;
		
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	// Сформируем отчет
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);
	
	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(СтруктураЗаголовковПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
	ОтчетПустой = ОтчетыСервер.ОтчетПустой(ЭтотОбъект, ПроцессорКомпоновкиДанных);
	КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураЗаголовковПолей()
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	ДанныеОтчета = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДанныеОтчета").Значение;
	
	СтруктураЗаголовковПолей = Новый Структура;
	Если ИспользоватьНесколькоВалют Тогда
		Если ДанныеОтчета = 1 Тогда
			СтруктураЗаголовковПолей.Вставить("ВалютаОтчета", "");
		ИначеЕсли ДанныеОтчета = 2 Тогда
			ПараметрВалюта = Константы.ВалютаУправленческогоУчета.Получить();
			СтруктураЗаголовковПолей.Вставить("ВалютаОтчета", "(" + ПараметрВалюта + ")");
		ИначеЕсли ДанныеОтчета = 3 Тогда
			ПараметрВалюта = Константы.ВалютаРегламентированногоУчета.Получить();
			СтруктураЗаголовковПолей.Вставить("ВалютаОтчета", "(" + ПараметрВалюта + ")");
		КонецЕсли;
	Иначе
		СтруктураЗаголовковПолей.Вставить("ВалютаОтчета", "");
	КонецЕсли;
	
	Возврат СтруктураЗаголовковПолей;
	
КонецФункции

Функция НаборыДанныхКУдалению()
	
	НаборыДанныхКУдалению = Новый Массив;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваБезналичные) Тогда
		НаборыДанныхКУдалению.Добавить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.Найти("Безналичные"));
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваНаличные) Тогда
		НаборыДанныхКУдалению.Добавить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.Найти("Наличные"));
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваВКассахККМ) Тогда
		НаборыДанныхКУдалению.Добавить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.Найти("ВКассахККМ"));
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ДенежныеСредстваВПути) Тогда
		НаборыДанныхКУдалению.Добавить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Элементы.Найти("ВПути"));
	КонецЕсли;
	
	Возврат НаборыДанныхКУдалению;
	
КонецФункции

#КонецОбласти

#КонецЕсли