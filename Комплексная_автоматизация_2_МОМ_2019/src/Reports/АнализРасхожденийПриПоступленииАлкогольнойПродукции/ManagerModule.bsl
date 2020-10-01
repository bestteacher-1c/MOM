#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область КомандыПодменюОтчеты

// Добавляет команду отчета в список команд.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов.
//
Функция ДобавитьКомандуОтчета(КомандыОтчетов) Экспорт

	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции) Тогда
		
		КомандаОтчет = КомандыОтчетов.Добавить();
		
		КомандаОтчет.Менеджер = Метаданные.Отчеты.АнализРасхожденийПриПоступленииАлкогольнойПродукции.ПолноеИмя();
		КомандаОтчет.Представление = НСтр("ru = 'Расхождения при поступлении ТТН ЕГАИС'");
		КомандаОтчет.МножественныйВыбор = Истина;
		КомандаОтчет.Важность = "Обычное";
		КомандаОтчет.ФункциональныеОпции = "ВестиСведенияДляДекларацийАлкоВРознице";
		КомандаОтчет.ДополнительныеПараметры.Вставить("ИмяКоманды", "АнализРасхожденийПриПоступленииАлкогольнойПродукцииТТН_ЕГАИС");
		
		Возврат КомандаОтчет;
		
	КонецЕсли;

	Возврат Неопределено;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли