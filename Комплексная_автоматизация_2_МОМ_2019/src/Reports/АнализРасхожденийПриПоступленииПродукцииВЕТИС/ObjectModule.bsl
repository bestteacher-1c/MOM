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
	Настройки.События.ПриСозданииНаСервере = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриПоступленииПродукцииВЕТИС_Накладная" Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				|	ДокументВЕТИС.ДокументОснование КАК ДокументОснование
				|ИЗ
				|	Документ.ВходящаяТранспортнаяОперацияВЕТИС КАК ДокументВЕТИС
				|ГДЕ
				|	ДокументВЕТИС.Ссылка В(&МассивСсылок)";
			
			Запрос.УстановитьПараметр("МассивСсылок", Параметры.ПараметрКоманды);
			МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДокументОснование");
			
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ДокументВЕТИС", МассивСсылок);
			
		ИначеЕсли Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "АнализРасхожденийПриПоступленииПродукцииВЕТИС" Тогда
			
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("ДокументВЕТИС", Параметры.ПараметрКоманды);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВырезатьИзСхемыЗапросаНедоступныеДокументыОснования(ЭтаФорма);
	
	ЭтаФорма.Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ВырезатьИзСхемыЗапросаНедоступныеДокументыОснования();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ВырезатьИзСхемыЗапросаНедоступныеДокументыОснования(Форма = Неопределено)
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос;
	
	Для Каждого ТипОснования Из Метаданные.ОпределяемыеТипы.ОснованиеВходящаяТранспортнаяОперацияВЕТИС.Тип.Типы() Цикл
		
		ТипМетаданныхОснования = Метаданные.НайтиПоТипу(ТипОснования);
		Если Не ПравоДоступа("Просмотр", ТипМетаданныхОснования) Тогда
			ВырезатьТипОснованияИзТекста(ТекстЗапроса, ТипМетаданныхОснования.ПолноеИмя());
			Если Форма <> Неопределено Тогда 
				Форма.НастройкиОтчета.СхемаМодифицирована = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса;
	
	Если Форма <> Неопределено И Форма.НастройкиОтчета.СхемаМодифицирована Тогда
		Форма.НастройкиОтчета.АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВырезатьТипОснованияИзТекста(ТекстЗапроса, ИмяДокументаОснования)
	
	ПервоеВхождение = СтрНайти(ТекстЗапроса, ИмяДокументаОснования);
	
	Если ПервоеВхождение = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	НачалоБлока     = СтрНайти(ТекстЗапроса, "ВЫБРАТЬ", НаправлениеПоиска.СКонца, ПервоеВхождение);
	ПоследнееВхождение = СтрНайти(ТекстЗапроса, ИмяДокументаОснования, НаправлениеПоиска.СКонца);
	
	УдалятьДо   = СтрНайти(ТекстЗапроса, "ОБЪЕДИНИТЬ ВСЕ",,ПоследнееВхождение) + СтрДлина("ОБЪЕДИНИТЬ ВСЕ");
	Если УдалятьДо = 0 Тогда
		УдалятьДо = СтрНайти(ТекстЗапроса, ";",,ПоследнееВхождение) - 1;
		УдалятьС  = СтрНайти(ТекстЗапроса, "ОБЪЕДИНИТЬ ВСЕ", НаправлениеПоиска.СКонца, ПоследнееВхождение);
	Иначе 
		УдалятьС  = НачалоБлока;
	КонецЕсли;
	
	ТекстЗапроса = Лев(ТекстЗапроса, УдалятьС - 1) + Сред(ТекстЗапроса, УдалятьДо);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли