
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Источник            = Параметры.Источник;
	СкидкаНаценка       = Параметры.СкидкаНаценка;
	ПозицияНоменклатуры = Параметры.ПозицияНоменклатуры;
	Если ЗначениеЗаполнено(ПозицияНоменклатуры) Тогда
		Номенклатура = ПозицияНоменклатуры.Номенклатура;
		Характеристика = ПозицияНоменклатуры.Характеристика;
	КонецЕсли;
	
	Элементы.ДействиеСкидокНаценок.Видимость = ЗначениеЗаполнено(СкидкаНаценка);
	Элементы.ДействиеСкидокНаценокПоНоменклатуре.Видимость = ЗначениеЗаполнено(ПозицияНоменклатуры);
	Элементы.СкидкаНаценка.Видимость = ЗначениеЗаполнено(СкидкаНаценка);
	Элементы.Номенклатура.Видимость = ЗначениеЗаполнено(Номенклатура);
	Элементы.Характеристика.Видимость = ЗначениеЗаполнено(Характеристика);

	Если ЗначениеЗаполнено(СкидкаНаценка) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДействиеСкидокНаценок,
			"СкидкаНаценка",
			СкидкаНаценка,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДействиеСкидокНаценок,
			"Источник",
			Источник,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПозицияНоменклатуры) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДействиеСкидокНаценокПоНоменклатуре,
			"Номенклатура",
			Номенклатура,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДействиеСкидокНаценокПоНоменклатуре,
			"Характеристика",
			Характеристика,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДействиеСкидокНаценокПоНоменклатуре,
			"Источник",
			Источник,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина);
			
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Источник) Тогда
		Элементы.Источник.Видимость = Ложь;
	Иначе
		
		Если ТипЗнч(Источник) = Тип("СправочникСсылка.Склады") Тогда
			Элементы.Источник.Заголовок = НСтр("ru = 'Склад'");
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.СоглашенияСКлиентами") Тогда
			Элементы.Источник.Заголовок = НСтр("ru = 'Соглашение'");
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.ВидыКартЛояльности") Тогда
			Элементы.Источник.Заголовок = НСтр("ru = 'Вид карты лояльности'");
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.СкидкиНаценки") Тогда
			Элементы.Источник.Заголовок = НСтр("ru = 'Скидка (наценка)'");
		ИначеЕсли ТипЗнч(Источник) = Тип("СправочникСсылка.УсловияПредоставленияСкидокНаценок") Тогда
			Элементы.Источник.Заголовок = НСтр("ru = 'Условие предоставления'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура ДействиеСкидокНаценокПослеУдаления(Элемент)
	
	МассивСкидкиНаценки = Новый Массив;
	МассивИсточники = Новый Массив;
	
	МассивСкидкиНаценки.Добавить(СкидкаНаценка);
	МассивИсточники.Добавить(Источник);
	
	Параметр = Новый Структура;
	Параметр.Вставить("СкидкаНаценка", МассивСкидкиНаценки);
	Параметр.Вставить("Источник", МассивИсточники);
	
	Оповестить("Запись_ДействиеСкидокНаценок", Параметр, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеСкидокНаценокПоНоменклатуреПослеУдаления(Элемент)
	
	МассивИсточники = Новый Массив;
	МассивИсточники.Добавить(Источник);
	
	Параметр = Новый Структура;
	Параметр.Вставить("Источник", МассивИсточники);
	
	Оповестить("Запись_ДействиеСкидокНаценокПоНоменклатуре", Параметр, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти