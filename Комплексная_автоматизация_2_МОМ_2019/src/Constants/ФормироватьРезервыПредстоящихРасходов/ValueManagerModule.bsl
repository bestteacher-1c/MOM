#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Справочники.ОбъектыУчетаРезервовПредстоящихРасходов.УстановитьИспользованиеСвойств();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли