
#Область ПрограммныйИнтерфейс

// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
// при создании информационной базы или обновлении программы.
//
// см. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам()
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	//++ Локализация
	
	//++ НЕ УТ
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ИнтеграцияРекрутинговыхСайтов") Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ИнтеграцияРекрутинговыхСайтов");
		Модуль.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
		
	КонецЕсли;
	
	// РегламентированнаяОтчетность
	РегламентированнаяОтчетность.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
	// Конец РегламентированнаяОтчетность
	//-- НЕ УТ
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений);
	// Конец ЭлектронноеВзаимодействие
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти