#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//++ НЕ УТ
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
	//-- НЕ УТ
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	//++ НЕ УТ
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	//-- НЕ УТ
	Возврат;
КонецПроцедуры

&НаСервере
Процедура СписокПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	//++ НЕ УТ
	ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	//-- НЕ УТ
	Возврат;
КонецПроцедуры

#КонецОбласти

