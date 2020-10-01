#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Организация,ФизическоеЛицо,ДатаДокумента");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
	Если ЗначениеЗаполнено(ДатаДокумента) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ДатаДокументаОснования", КонецДня(ДатаДокумента), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ФизическоеЛицо", ФизическоеЛицо, ВидСравненияКомпоновкиДанных.Равно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Сотрудники, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
		Если ЗначениеЗаполнено(ДатаДокумента) Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
				Сотрудники, "ДатаДокументаОснования", КонецДня(ДатаДокумента), Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"Сотрудники",
		"Видимость",
		Не ЗначениеЗаполнено(ФизическоеЛицо));
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыРасширеннаяПодсистемы") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РазрядКатегория", "Видимость", Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Сотрудники.ТекущиеДанные <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ФизическоеЛицо", Элементы.Сотрудники.ТекущиеДанные.ФизическоеЛицо, ВидСравненияКомпоновкиДанных.Равно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ФизическоеЛицо", ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка"), ВидСравненияКомпоновкиДанных.Равно, , , РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
