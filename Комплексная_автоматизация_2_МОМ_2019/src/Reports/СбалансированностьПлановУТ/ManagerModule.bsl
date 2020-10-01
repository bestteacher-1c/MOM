#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуСбалансированностьПланов(КомандыОтчетов) Экспорт
	
	//++ НЕ УТ
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СбалансированностьПлановУП) 
			И (    ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж")
			   ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства")
			   ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СбалансированностьПлановУП.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Сбалансированность планов'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.КлючВарианта =                "СбалансированностьПланов";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	//-- НЕ УТ
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СбалансированностьПлановУТ) 
			И (    ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПродаж")
			   ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки")) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СбалансированностьПлановУТ.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Сбалансированность планов'");
		
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Важное";
		КомандаОтчет.КлючВарианта =                "СбалансированностьПланов";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли