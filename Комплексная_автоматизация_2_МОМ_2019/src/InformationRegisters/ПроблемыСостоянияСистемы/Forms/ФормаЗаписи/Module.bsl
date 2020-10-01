
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Проверка", 		   Запись.Проверка);
	Запрос.УстановитьПараметр("Организация", 	   Запись.Организация);
	Запрос.УстановитьПараметр("ПроверяемыйПериод", Запись.ПроверяемыйПериод);
	Запрос.УстановитьПараметр("Проблема", 		   Запись.Проблема);
	
	// Заполнение списка объектов.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбъектыПроблемСостоянияСистемы.Объект,
	|	ОбъектыПроблемСостоянияСистемы.СоставнойОбъект,
	|	ОбъектыПроблемСостоянияСистемы.Представление
	|ИЗ
	|	РегистрСведений.ОбъектыПроблемСостоянияСистемы КАК ОбъектыПроблемСостоянияСистемы
	|ГДЕ
	|	ОбъектыПроблемСостоянияСистемы.Проблема = &Проблема
	|
	|УПОРЯДОЧИТЬ ПО
	|	Объект
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПроблемныеОбъекты.Очистить();
	
	Пока Выборка.Следующий() Цикл
		ПроблемныеОбъекты.Добавить(
			?(ЗначениеЗаполнено(Выборка.Объект), Выборка.Объект,
				?(ЗначениеЗаполнено(Выборка.Представление), Выборка.Представление, Выборка.СоставнойОбъект)));
	КонецЦикла;
	
	Элементы.ПроблемныеОбъекты.Видимость = (ПроблемныеОбъекты.Количество() > 0);
	
	// Заполнение расшифровки.
	Расшифровка.Очистить();
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПроблемыСостоянияСистемы.ДополнительнаяИнформация
	|ИЗ
	|	РегистрСведений.ПроблемыСостоянияСистемы КАК ПроблемыСостоянияСистемы
	|ГДЕ
	|	ПроблемыСостоянияСистемы.Проблема = &Проблема";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		ДопИнформация = Выборка.ДополнительнаяИнформация.Получить();
		
		Если ТипЗнч(ДопИнформация) = Тип("Структура") ИЛИ ТипЗнч(ДопИнформация) = Тип("ФиксированнаяСтруктура") Тогда
			
			ТипВсеСсылки = ОбщегоНазначения.ОписаниеТипаВсеСсылки();
			
			Для Каждого КлючИЗначение Из ДопИнформация Цикл
				
				Если ЗначениеЗаполнено(КлючИЗначение.Значение) И ТипВсеСсылки.СодержитТип(ТипЗнч(КлючИЗначение.Значение)) Тогда
					Расшифровка.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ + ": " + КлючИЗначение.Значение);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Расшифровка.Видимость = (Расшифровка.Количество() > 0);
	
	// Получение даты последней проверки.
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВыполнениеПроверокСостоянияСистемы.ДатаВыполнения
	|ИЗ
	|	РегистрСведений.ВыполнениеПроверокСостоянияСистемы КАК ВыполнениеПроверокСостоянияСистемы
	|ГДЕ
	|	ВыполнениеПроверокСостоянияСистемы.Проверка = &Проверка
	|	И ВыполнениеПроверокСостоянияСистемы.Организация = &Организация
	|	И ВыполнениеПроверокСостоянияСистемы.ПроверяемыйПериод = &ПроверяемыйПериод";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		ДатаПроверки = Формат(Выборка.ДатаВыполнения, "ДЛФ=DT");
	Иначе
		ДатаПроверки = НСтр("ru='не удалось определить дату проверки'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Расшифровка[ВыбраннаяСтрока].Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроблемныеОбъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, ПроблемныеОбъекты[ВыбраннаяСтрока].Значение);
	
КонецПроцедуры

#КонецОбласти
