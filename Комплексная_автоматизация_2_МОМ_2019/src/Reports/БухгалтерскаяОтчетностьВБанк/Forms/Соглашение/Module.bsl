#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Соглашение = "https://reportbank.1c.ru/resources/html/userAgreement.html"
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодтверждениеСоглашенияПриИзменении(Элемент)
	
	Элементы.ФормаОтправить.Доступность = ПодтверждениеСоглашения;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отправить(Команда)
	
	СохранитьСогласие();
	Закрыть(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьСогласие()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОтчетностьВБанки", "СоглашениеПринято", Истина);
	
КонецПроцедуры

#КонецОбласти
