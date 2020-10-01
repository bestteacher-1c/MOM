#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПередЗаписью(ЭтотОбъект);
КонецПроцедуры


Процедура ПриЗаписи(Отказ, Замещение)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеРегистра = РегистрыНакопления.ДанныеТабельногоУчетаРабочегоВремениСотрудников.ОписаниеРегистра();
	
	ОписаниеРегистра.МетаданныеРегистра = Метаданные();
	ОписаниеРегистра.ИмяПоляСотрудник = "Сотрудник";
	ОписаниеРегистра.ИмяПоляПериод = "Период";
	ОписаниеРегистра.ИмяПоляПериодРегистрации = "ПериодРегистрации";
	ОписаниеРегистра.ИмяПоляВидДанных = Неопределено;
	ОписаниеРегистра.ВидДанных = Перечисления.ВидыДанныхУчетаВремениСотрудников.ДанныеТабельногоУчета;
	
	УчетРабочегоВремениРасширенный.ЗаписатьПараметрыРегистрируемыхДанных(ЭтотОбъект, ОписаниеРегистра);
	
	ДанныеИзменены = Ложь;
	
	УчетРабочегоВремениРасширенный.КонтрольИзмененияДанныхРегистровПриЗаписи(ЭтотОбъект, ДанныеИзменены);
	
	Если ДанныеИзменены Тогда
		УчетРабочегоВремениРасширенный.РегистрРассчитанныхДанныхПриИзмененииИсточниковДанных(ЭтотОбъект);
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли