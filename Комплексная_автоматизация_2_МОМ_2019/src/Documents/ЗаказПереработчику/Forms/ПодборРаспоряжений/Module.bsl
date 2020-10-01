
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПериодПриИзменении(Элемент)
	
	
	Возврат; // В КА пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикПроизводства

&НаКлиенте
Процедура ГрафикПроизводстваВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ГрафикПроизводстваЗаказПредставление Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элементы.ГрафикПроизводства.ТекущиеДанные;
		ПоказатьЗначение(, ТекущиеДанные.Распоряжение);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	
	Возврат; // В КА пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПродукцию(Команда)
	
	Для каждого ТекущиеДанные Из ГрафикПроизводства Цикл
		ТекущиеДанные.Пометка = Истина;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьПродукцию(Команда)
	
	Для каждого ТекущиеДанные Из ГрафикПроизводства Цикл
		ТекущиеДанные.Пометка = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

