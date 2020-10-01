
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.РежимВыбораСтроки) Тогда
		РежимВыбораСтроки = Параметры.РежимВыбораСтроки;
	Иначе
		РежимВыбораСтроки = "ОткрытьФормуЗаписи";
	КонецЕсли;
	
	Если РежимВыбораСтроки = "ОткрытьФормуОбъекта" Тогда
		Элементы.ДополнительнаяЗапись.Видимость = Ложь;
		Элементы.РазделительЗаписи.Видимость = Ложь;
		Элементы.Ссылка.Видимость = Ложь;
		Элементы.ПометкаУдаления.Видимость = Ложь;
		Элементы.Проведен.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимВыбораСтроки = "ОткрытьФормуЗаписи" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
	ИначеЕсли РежимВыбораСтроки = "ОткрытьФормуОбъекта" Тогда
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти