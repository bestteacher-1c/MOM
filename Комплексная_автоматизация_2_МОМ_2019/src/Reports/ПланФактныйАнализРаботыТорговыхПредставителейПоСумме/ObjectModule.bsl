#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);

КонецПроцедуры

#КонецОбласти
	
#КонецЕсли