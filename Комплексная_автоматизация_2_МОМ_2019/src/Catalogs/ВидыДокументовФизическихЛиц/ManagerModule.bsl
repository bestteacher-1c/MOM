//++ НЕ УТ
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбораБЗК.ЗаполнитьДляКлассификатораСПорядкомПоДопРеквизиту(
		Справочники.ВидыДокументовФизическихЛиц,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
//-- НЕ УТ