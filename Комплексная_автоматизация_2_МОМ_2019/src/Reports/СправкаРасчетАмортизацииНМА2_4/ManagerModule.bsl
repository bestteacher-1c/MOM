#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаПоНМА(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СправкаРасчетАмортизацииНМА2_4)
		И ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4() Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СправкаРасчетАмортизацииНМА2_4.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Справка-расчет амортизации'");
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "СправкаРасчетПоНМА");
		КомандаОтчет.КлючВарианта = "СправкаРасчетАмортизацииНМА";
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчетаПоДокументуАмортизацииНМА(КомандыОтчетов) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.СправкаРасчетАмортизацииНМА2_4)
		И ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4() Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.СправкаРасчетАмортизацииНМА2_4.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Справка-расчет амортизации'");
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.МножественныйВыбор = Ложь;
		КомандаОтчет.КлючВарианта = "СправкаРасчетПоДокументуАмортизацииНМАКонтекст";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "СправкаРасчетПоДокументуАмортизацииНМА");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
		
#КонецЕсли