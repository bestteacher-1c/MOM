
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокЗаказов

&НаКлиенте
Процедура СписокЗаказовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаменитьСпецификацию(Команда)
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	
	Возврат; // пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

