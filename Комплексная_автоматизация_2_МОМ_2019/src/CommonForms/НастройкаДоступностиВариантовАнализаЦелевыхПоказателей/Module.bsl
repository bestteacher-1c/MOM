#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗаполнитьДеревоПользователей();
	
	ЗаполнитьНастройкиДоступности();
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если НЕ ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), НСтр("ru='Настройки были изменены. Записать изменения настроек?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		ЗаписатьНастройкиСервер();
		Закрыть();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПользователей

&НаКлиенте
Процедура ДеревоПользователейПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиДереваПользователей",0.2,Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоВариантовАнализа

&НаКлиенте
Процедура ДеревоВариантовАнализаДоступностьПоЦелиПриИзменении(Элемент)
	
	ИспользоватьНесохраненныеНастройки = Истина;
	
	Если Элементы.ДеревоВариантовАнализа.ТекущиеДанные <> Неопределено Тогда
		ОбновитьСоставДоступностиВниз(Элементы.ДеревоВариантовАнализа.ТекущаяСтрока, Элементы.ДеревоВариантовАнализа.ТекущиеДанные.ДоступностьПоЦели);
		ОбновитьСоставДоступностиВверх(Элементы.ДеревоВариантовАнализа.ТекущаяСтрока);
		
	КонецЕсли;
	
	ОбновитьВыбранныеВариантыАнализа();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВариантовАнализаДоступностьПриИзменении(Элемент)
	
	ИспользоватьНесохраненныеНастройки = Истина;
	
	Если Элементы.ДеревоВариантовАнализа.ТекущиеДанные.Доступность = 2 Тогда
		Элементы.ДеревоВариантовАнализа.ТекущиеДанные.Доступность = 0;
		
	КонецЕсли;
	
	Если Элементы.ДеревоВариантовАнализа.ТекущиеДанные <> Неопределено Тогда
		ОбновитьСоставДоступностиВверх(Элементы.ДеревоВариантовАнализа.ТекущаяСтрока);
		
	КонецЕсли;
	
	ОбновитьВыбранныеВариантыАнализа();
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьНастройки(Команда)
	
	ЗаписатьНастройкиСервер();
	
	Модифицированность = Ложь;
	ИспользоватьНесохраненныеНастройки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНастройкиИЗакрыть(Команда)
	
	ЗаписатьНастройкиСервер();
	
	Модифицированность = Ложь;
	ИспользоватьНесохраненныеНастройки = Ложь;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ИспользоватьНесохраненныеНастройки = Истина;
	
	ОбновитьСоставДоступностиВниз(Неопределено, Истина);
	
	ОбновитьВыбранныеВариантыАнализа();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоДоступуПоОтветственным(Команда)
		
	ОткрытьФорму("Отчет.ДоступностьВариантовАнализаЦелевыхПоказателей.Форма",
		Новый Структура("КлючНазначенияИспользования, 
						|КлючВарианта, 
						|СформироватьПриОткрытии", УникальныйИдентификатор, "ДоступностьОтветственным", Истина),,, ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоДоступуПоСотрудникамПодразделений(Команда)
		
	ОткрытьФорму("Отчет.ДоступностьВариантовАнализаЦелевыхПоказателей.Форма",
		Новый Структура("КлючНазначенияИспользования, 
						|КлючВарианта, 
						|СформироватьПриОткрытии", УникальныйИдентификатор, "ДоступностьСотрудникамОтделов", Истина),,, ВариантОткрытияОкна.ОтдельноеОкно);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметки(Команда)
	
	ИспользоватьНесохраненныеНастройки = Истина;
	
	ОбновитьСоставДоступностиВниз(Неопределено, Ложь);
	
	ОбновитьВыбранныеВариантыАнализа();
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПользователь.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.КартинкаПользователя.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПользователей.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0; // Группа строк - Подразделение

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПользователей.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1; // Строка пользователя

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиДоступностиПодразделение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПользователей.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0; // Группа строк - Подразделение

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоПользователей.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.СтруктураПредприятия.ПустаяСсылка();

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Подразделение не указано>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализаДоступность.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализаВариантАнализа.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализаТипАнализа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВариантовАнализа.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0; // Группа строк - Целевой показатель или группа целей

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализаДоступностьПоЦели.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализаЦель.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВариантовАнализа.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1; // Строка варианта анализа

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоВариантовАнализа.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоВариантовАнализа.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0; // Группа строк - Целевой показатель или группа целей


	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ReportGroup1BackColor);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаКлиенте 
Процедура ОбновитьВыбранныеВариантыАнализа()
	
	ТекущиеДанныеПользователей = ДеревоПользователей.НайтиПоИдентификатору(Элементы.ДеревоПользователей.ТекущаяСтрока);
	
	ПользователиПодразделения = Новый Массив;
	
	Если ТекущиеДанныеПользователей.ТипСтроки = 1 Тогда
		
		ПользователиПодразделения.Добавить(ТекущиеДанныеПользователей.Пользователь);
		
	ИначеЕсли ТекущиеДанныеПользователей.ТипСтроки = 0 Тогда
		
		ЗаполнитьМассивПользователей(Элементы.ДеревоПользователей.ТекущаяСтрока, ПользователиПодразделения);
		
	КонецЕсли;
	
	Для Каждого ПользовательПодразделения Из ПользователиПодразделения Цикл 
		ОтборПоПользователю = Новый Структура("Пользователь", ПользовательПодразделения);
		СтрокиКОбновлению = НастройкиДоступности.НайтиСтроки(ОтборПоПользователю);
		
		Для Каждого СтрокаКОбновлению Из СтрокиКОбновлению Цикл 
			НастройкиДоступности.Удалить(СтрокаКОбновлению);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗаполнитьВыбранныеВариантыАнализа(ПользователиПодразделения);
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСоставДоступностиВверх(ИдентификаторСтроки)
	
	ТекущиеДанные = ДеревоВариантовАнализа.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	ТекущиеДанныеРодитель = ТекущиеДанные.ПолучитьРодителя();
	
	Если НЕ ТекущиеДанныеРодитель = Неопределено Тогда
		ЭлементыРодителя = ТекущиеДанныеРодитель.ПолучитьЭлементы();
		
		КоличествоНулей = 0;
		КоличествоЕдиниц = 0;
		КоличествоДвоек = 0;
		Для Каждого ЭлементРодителя Из ЭлементыРодителя Цикл 
			Если ЭлементРодителя.ТипСтроки = 0 Тогда 
				ЗначениеДоступности = ЭлементРодителя.ДоступностьПоЦели;
				
			ИначеЕсли ЭлементРодителя.ТипСтроки = 1 Тогда 
				ЗначениеДоступности = ЭлементРодителя.Доступность;
				
			КонецЕсли;
			
			Если ЗначениеДоступности = 0 Тогда
				КоличествоНулей = КоличествоНулей + 1;
				
			ИначеЕсли ЗначениеДоступности = 1 Тогда
				КоличествоЕдиниц = КоличествоЕдиниц + 1;
				
			ИначеЕсли ЗначениеДоступности = 2 Тогда
				КоличествоДвоек = КоличествоДвоек + 1;
				
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоЭлементов = ЭлементыРодителя.Количество();
		
		Если КоличествоНулей = 0 Тогда
			Если КоличествоЕдиниц = КоличествоЭлементов Тогда
				ТекущиеДанныеРодитель.ДоступностьПоЦели = 1;
				
			Иначе
				ТекущиеДанныеРодитель.ДоступностьПоЦели = 2;
				
			КонецЕсли;
		Иначе
			Если КоличествоНулей = КоличествоЭлементов Тогда
				ТекущиеДанныеРодитель.ДоступностьПоЦели = 0;
				
			Иначе
				ТекущиеДанныеРодитель.ДоступностьПоЦели = 2;
				
			КонецЕсли;
		КонецЕсли;
		
		ОбновитьСоставДоступностиВверх(ТекущиеДанныеРодитель.ПолучитьИдентификатор());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ОбновитьСоставДоступностиВниз(ИдентификаторСтроки, Состояние)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		КоллекцияВариантовАнализа = ДеревоВариантовАнализа.ПолучитьЭлементы();
		
	Иначе
		ТекущиеДанные = ДеревоВариантовАнализа.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		Состояние = ?(Состояние = 2, 0, Состояние);
		
		Если ТекущиеДанные.ТипСтроки = 0 Тогда
			ТекущиеДанные.ДоступностьПоЦели = Состояние;
			
		ИначеЕсли ТекущиеДанные.ТипСтроки = 1 Тогда
			ТекущиеДанные.Доступность = Состояние;
			
		КонецЕсли;
		
		КоллекцияВариантовАнализа = ТекущиеДанные.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Для каждого ЭлементКоллекцииВариантовАнализа Из КоллекцияВариантовАнализа Цикл
		Если ЭлементКоллекцииВариантовАнализа.ТипСтроки = 0 Тогда
			ЭлементКоллекцииВариантовАнализа.ДоступностьПоЦели = Состояние;
			
			ОбновитьСоставДоступностиВниз(ЭлементКоллекцииВариантовАнализа.ПолучитьИдентификатор(), Состояние);
			
		ИначеЕсли ЭлементКоллекцииВариантовАнализа.ТипСтроки = 1 Тогда
			ЭлементКоллекцииВариантовАнализа.Доступность = Состояние;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере 
Процедура ЗаписатьНастройкиСервер()
	
	НастройкиДоступностиЗначение = РеквизитФормыВЗначение("НастройкиДоступности");
	НастройкиДоступностиЗначение.Индексы.Добавить("ВариантАнализа");
	
	ВариантыАнализаСохраненные = ПолучитьВариантыАнализа(, Ложь, Истина);
	ВариантыАнализаСохраненные.Свернуть("ВариантАнализа");
	
	Для Каждого СтрокаВариантАнализа Из ВариантыАнализаСохраненные Цикл 
		
		ОтборПоВариантуАнализа = Новый Структура("ВариантАнализа", СтрокаВариантАнализа.ВариантАнализа);
		ЗаписываемыеНастройки = НастройкиДоступностиЗначение.НайтиСтроки(ОтборПоВариантуАнализа);
		
		ВариантАнализаОбъект = СтрокаВариантАнализа.ВариантАнализа.ПолучитьОбъект();
		ВариантАнализаОбъект.НастройкиДоступности.Очистить();
		
		Если ЗаписываемыеНастройки.Количество() > 0 Тогда
			Для Каждого ЗаписываемаяНастройка Из ЗаписываемыеНастройки Цикл 
				НоваяСтрока = ВариантАнализаОбъект.НастройкиДоступности.Добавить();
				НоваяСтрока.Пользователь = ЗаписываемаяНастройка.Пользователь;
				НоваяСтрока.ВариантОтображения = ЗаписываемаяНастройка.ВариантАнализа.ВариантОтображенияПоУмолчанию;
				
			КонецЦикла;
			
		КонецЕсли;
		
		ВариантАнализаОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьВыбранныеВариантыАнализа(ПользователиПодразделения, ИдентификаторСтроки = Неопределено, ВключаяНедоступные = Ложь)
	Если ИдентификаторСтроки = Неопределено Тогда
		// Обработка всех
		КоллекцияВариантовАнализа = ДеревоВариантовАнализа.ПолучитьЭлементы();
	Иначе
		ТекущиеДанные = ДеревоВариантовАнализа.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		КоллекцияВариантовАнализа = ТекущиеДанные.ПолучитьЭлементы();
	КонецЕсли;
	
	Для каждого ЭлементКоллекцииВариантовАнализа Из КоллекцияВариантовАнализа Цикл
		ИдентификаторЭлемента = ЭлементКоллекцииВариантовАнализа.ПолучитьИдентификатор();
		
		Если ЭлементКоллекцииВариантовАнализа.ТипСтроки = 0 Тогда
			ЗаполнитьВыбранныеВариантыАнализа(ПользователиПодразделения, ИдентификаторЭлемента, ВключаяНедоступные);
		ИначеЕсли ЭлементКоллекцииВариантовАнализа.ТипСтроки = 1 И (ЭлементКоллекцииВариантовАнализа.Доступность ИЛИ ВключаяНедоступные) Тогда
			Для Каждого ПользовательПодразделения Из ПользователиПодразделения Цикл 
				НовыйВыбранныйВариантАнализа = НастройкиДоступности.Добавить();
				НовыйВыбранныйВариантАнализа.ВариантАнализа = ЭлементКоллекцииВариантовАнализа.ВариантАнализа;
				НовыйВыбранныйВариантАнализа.Пользователь = ПользовательПодразделения;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДеревоВариантовАнализаСервер()
	
	Если НЕ Элементы.ДеревоПользователей.ВыделенныеСтроки.Количество() = 0 Тогда
		ВариантыАнализаЗначение = ПолучитьВариантыАнализа(Элементы.ДеревоПользователей.ВыделенныеСтроки);
		
	Иначе
		ВариантыАнализаЗначение = Неопределено;
		
	КонецЕсли;

	Если НЕ ВариантыАнализаЗначение = Неопределено Тогда
		ЗначениеВДанныеФормы(ВариантыАнализаЗначение, ДеревоВариантовАнализа);
		
		Элементы.СтраницыВариантовАнализа.ТекущаяСтраница = Элементы.СтраницаДеревоВариантовАнализа;
		Элементы.ФормаСохранитьНастройкиИЗакрыть.Доступность = Истина;
		Элементы.ФормаСохранитьНастройки.Доступность = Истина;
		
	Иначе
		ОтобразитьСтраницуСообщенияДоступностиВариантов(Элементы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьДеревоПользователей()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Пользователи.Ссылка КАК Пользователь,
	|	Пользователи.Подразделение КАК Подразделение,
	|	Пользователи.Подразделение.ПометкаУдаления КАК ПодразделениеПометкаУдаления,
	|	1 КАК ТипСтроки,
	|	ВЫБОР
	|		КОГДА Пользователи.Ссылка.ПометкаУдаления
	|			ТОГДА 2
	|		ИНАЧЕ 3
	|	КОНЕЦ КАК НестандартнаяКартинка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	НЕ Пользователи.Недействителен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Пользователи.Подразделение.Наименование,
	|	Пользователи.Наименование
	|ИТОГИ
	|	СРЕДНЕЕ(ВЫБОР
	|			КОГДА Пользователь ЕСТЬ NULL
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ТипСтроки,
	|	СРЕДНЕЕ(ВЫБОР
	|			КОГДА ПодразделениеПометкаУдаления
	|				ТОГДА 1
	|			КОГДА НЕ ПодразделениеПометкаУдаления
	|					ИЛИ ПодразделениеПометкаУдаления ЕСТЬ NULL
	|				ТОГДА 0
	|			КОГДА ПодразделениеПометкаУдаления ЕСТЬ NULL
	|				ТОГДА 0
	|		КОНЕЦ) КАК НестандартнаяКартинка
	|ПО
	|	Подразделение ИЕРАРХИЯ";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ДеревоПользователейЗначение = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		ДеревоПользователейЗначение.Колонки.Удалить(ДеревоПользователейЗначение.Колонки.Найти("ПодразделениеПометкаУдаления"));
		ЗначениеВДанныеФормы(ДеревоПользователейЗначение, ДеревоПользователей);
		
		Элементы.ДеревоПользователей.ТекущаяСтрока = 0;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ЗаполнитьМассивПользователей(ИдентификаторСтроки, МассивПользователей)
	
	Если ИдентификаторСтроки = Неопределено Тогда
		КоллекцияПользователей = ДеревоПользователей.ПолучитьЭлементы();
		
	Иначе
		ТекущиеДанные = ДеревоПользователей.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		КоллекцияПользователей = ТекущиеДанные.ПолучитьЭлементы();
		
	КонецЕсли;
	
	Для каждого ЭлементКоллекцииПользователей Из КоллекцияПользователей Цикл
		Если ЭлементКоллекцииПользователей.ТипСтроки = 0 Тогда
			ЗаполнитьМассивПользователей(ЭлементКоллекцииПользователей.ПолучитьИдентификатор(), МассивПользователей);
			
		ИначеЕсли ЭлементКоллекцииПользователей.ТипСтроки = 1 Тогда
			МассивПользователей.Добавить(ЭлементКоллекцииПользователей.Пользователь);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьНастройкиДоступности()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Ссылка КАК ВариантАнализа,
	|	ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Пользователь КАК Пользователь,
	|	ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Пользователь.Подразделение КАК Подразделение
	|ИЗ
	|	Справочник.ВариантыАнализаЦелевыхПоказателей.НастройкиДоступности КАК ВариантыАнализаЦелевыхПоказателейНастройкиДоступности
	|ГДЕ
	|	НЕ ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Пользователь.Ссылка ЕСТЬ NULL
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Ссылка.Владелец.РеквизитДопУпорядочиванияИерархического,
	|	ВариантыАнализаЦелевыхПоказателейНастройкиДоступности.Ссылка.РеквизитДопУпорядочивания,
	|	Пользователь";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		НастройкиДоступностиОбъект = РезультатЗапроса.Выгрузить();
		ЗначениеВДанныеФормы(НастройкиДоступностиОбъект, НастройкиДоступности);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста  
Процедура ОтобразитьСтраницуСообщенияДоступностиВариантов(Элементы)
	Элементы.СтраницыВариантовАнализа.ТекущаяСтраница = Элементы.СтраницаСообщение;
	Элементы.ФормаСохранитьНастройкиИЗакрыть.Доступность = Ложь;
	Элементы.ФормаСохранитьНастройки.Доступность = Ложь;
	
КонецПроцедуры

&НаСервере 
Процедура ПодготовитьДеревоВариантовАнализа(ДеревоВариантовАнализа, НачальнаяСтрокаПроверки = Неопределено)
	
	Если НачальнаяСтрокаПроверки = Неопределено Тогда
		СтрокиДерева = ДеревоВариантовАнализа.Строки;
	Иначе
		СтрокиДерева = НачальнаяСтрокаПроверки.Строки;
	КонецЕсли;
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл 
		Если НЕ СтрокаДерева.Цель = NULL И НЕ СтрокаДерева.ВариантАнализа = NULL Тогда
			СтрокаДерева.Строки.Очистить();
			
		ИначеЕсли СтрокаДерева.Строки.Количество() Тогда
			ПодготовитьДеревоВариантовАнализа(ДеревоВариантовАнализа, СтрокаДерева);
			
		КонецЕсли;
		
		Если НЕ СтрокаДерева.Родитель = Неопределено И СтрокаДерева.Цель = СтрокаДерева.Родитель.Цель Тогда
			СтрокиТекущейСтрокиДерева = СтрокаДерева.Строки;
			
			ПозицияВставки = СтрокиДерева.Индекс(СтрокаДерева);
			Для Каждого СтрокаТекущейСтрокиДерева Из СтрокиТекущейСтрокиДерева Цикл 
				ПеренесеннаяСтрока = СтрокаДерева.Родитель.Строки.Вставить(ПозицияВставки);
				ЗаполнитьЗначенияСвойств(ПеренесеннаяСтрока, СтрокаТекущейСтрокиДерева);
				
				ПозицияВставки = ПозицияВставки + 1;
				
			КонецЦикла;
			
			СтрокаДерева.Строки.Очистить();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере 
Функция ПолучитьТекстИтогов()
	
	Текст = "ИТОГИ
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 1
	|			ТОГДА 1
	|		КОГДА МАКСИМУМ(Доступность) = 0
	|				И МИНИМУМ(Доступность) = 0
	|			ТОГДА 0
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 0
	|			ТОГДА 2
	|	КОНЕЦ КАК ДоступностьПоЦели,
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 1
	|			ТОГДА 1
	|		КОГДА МАКСИМУМ(Доступность) = 0
	|				И МИНИМУМ(Доступность) = 0
	|			ТОГДА 0
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 0
	|			ТОГДА 2
	|	КОНЕЦ КАК Доступность,
	|	ВЫБОР
	|		КОГДА ВариантАнализа ЕСТЬ NULL
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ТипСтроки
	|ПО
	|	Цель ИЕРАРХИЯ,
	|	ВариантАнализа";
	
	Возврат Текст;
	
КонецФункции

&НаСервере 
Функция ПолучитьТекстИтоговЕслиЕстьПодразделение()
	
	Текст = "ИТОГИ
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(ДоступностьПоЦели) = 2
	|			ТОГДА 2
	|		КОГДА МАКСИМУМ(ДоступностьПоЦели) = 1
	|				И МИНИМУМ(ДоступностьПоЦели) = 0
	|			ТОГДА 2
	|		КОГДА МАКСИМУМ(ДоступностьПоЦели) = 1
	|				И МИНИМУМ(ДоступностьПоЦели) = 1
	|			ТОГДА 1
	|		КОГДА МАКСИМУМ(ДоступностьПоЦели) = 0
	|			ТОГДА 0
	|	КОНЕЦ КАК ДоступностьПоЦели,
	|	ВЫБОР
	|		КОГДА МАКСИМУМ(Доступность) = 2
	|			ТОГДА 2
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 0
	|			ТОГДА 2
	|		КОГДА МАКСИМУМ(Доступность) = 1
	|				И МИНИМУМ(Доступность) = 1
	|			ТОГДА 1
	|		КОГДА МАКСИМУМ(Доступность) = 0
	|			ТОГДА 0
	|	КОНЕЦ КАК Доступность,	
	|	ВЫБОР
	|		КОГДА ВариантАнализа ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ТипСтроки
	|ПО
	|	Цель ИЕРАРХИЯ,
	|	ВариантАнализа";
	
	Возврат Текст;
	
КонецФункции

&НаСервере 
Функция ПолучитьТекстПакетаПользователей()
	
	Возврат "ВЫБРАТЬ
	        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Пользователи.Ссылка) КАК КоличествоПользователей
	        |ПОМЕСТИТЬ Пользователи
	        |ИЗ
	        |	Справочник.Пользователи КАК Пользователи
	        |ГДЕ
			|	НЕ Пользователи.Недействителен
	        |	И Пользователи.Подразделение В ИЕРАРХИИ (&Подразделения)
			|;";
	
КонецФункции

&НаСервере 
Функция ПолучитьТекстПакетаПользователейБезПараметров()
	
	Возврат "ВЫБРАТЬ
	        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Пользователи.Ссылка) КАК КоличествоПользователей
	        |ПОМЕСТИТЬ Пользователи
	        |ИЗ
	        |	Справочник.Пользователи КАК Пользователи
	        |ГДЕ
			|	НЕ Пользователи.Недействителен
			|;";
	
КонецФункции

&НаСервере 
Функция ПолучитьТекстПакетаПользователейПоПользователю()
	
	Возврат "ВЫБРАТЬ
	        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Пользователи.Ссылка) КАК КоличествоПользователей
	        |ПОМЕСТИТЬ Пользователи
	        |ИЗ
	        |	Справочник.Пользователи КАК Пользователи
	        |ГДЕ
			|	НЕ Пользователи.Недействителен
	        |	И Пользователи.Ссылка = &Пользователь
			|;";
	
КонецФункции

&НаСервере 
Функция ПолучитьТекстПакетаПользователейПустогоПодразделения()
	
	Возврат "ВЫБРАТЬ
	        |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Пользователи.Ссылка) КАК КоличествоПользователей
	        |ПОМЕСТИТЬ Пользователи
	        |ИЗ
	        |	Справочник.Пользователи КАК Пользователи
	        |ГДЕ
			|	НЕ Пользователи.Недействителен
	        |	И Пользователи.Подразделение = &Подразделение
			|;";
	
КонецФункции

&НаСервере 
Функция ПолучитьВариантыАнализа(ЗНАЧ ПараметрыОтбора = Неопределено, РезультатВДерево = Истина, ВсеВариантыАнализа = Ложь)
	
	ВариантыАнализаЗначение = Неопределено;
	
	Запрос = Новый Запрос;
	
	НастройкиДоступностиЗначение = РеквизитФормыВЗначение("НастройкиДоступности");
	
	Если ИспользоватьНесохраненныеНастройки Тогда
		Запрос.УстановитьПараметр("НесохраненныеНастройкиДоступности", НастройкиДоступностиЗначение);
		Запрос.Текст = "%ПакетПользователей%
		|ВЫБРАТЬ
		|	НесохраненныеНастройкиДоступности.Пользователь,
		|	НесохраненныеНастройкиДоступности.Подразделение,
		|	НесохраненныеНастройкиДоступности.ВариантАнализа
		|ПОМЕСТИТЬ НесохраненныеНастройкиДоступности
		|ИЗ
		|	&НесохраненныеНастройкиДоступности КАК НесохраненныеНастройкиДоступности
		|
		| %ПараметрОтбораНесохраненных%
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВариантыАнализаЦелевыхПоказателей.Владелец КАК Цель,
		|	ВЫБОР
		|		КОГДА Пользователи.КоличествоПользователей = КОЛИЧЕСТВО(НесохраненныеНастройкиДоступности.ВариантАнализа)
		|			ТОГДА 1
		|		КОГДА КОЛИЧЕСТВО(НесохраненныеНастройкиДоступности.ВариантАнализа) = 0
		|			ТОГДА 0
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК ДоступностьПоЦели,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка КАК ВариантАнализа,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.ТипАнализа КАК ТипАнализа,
		|	ВЫБОР
		|		КОГДА Пользователи.КоличествоПользователей = КОЛИЧЕСТВО(НесохраненныеНастройкиДоступности.ВариантАнализа)
		|			ТОГДА 1
		|		КОГДА КОЛИЧЕСТВО(НесохраненныеНастройкиДоступности.ВариантАнализа) = 0
		|			ТОГДА 0
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Доступность,
		|	2 КАК ТипСтроки
		|	%ПолеПользователя%
		|	%ПолеКоличествоПользователей%
		|ИЗ
		|	Справочник.ВариантыАнализаЦелевыхПоказателей КАК ВариантыАнализаЦелевыхПоказателей
		|		ЛЕВОЕ СОЕДИНЕНИЕ НесохраненныеНастройкиДоступности КАК НесохраненныеНастройкиДоступности
		|		ПО (НесохраненныеНастройкиДоступности.ВариантАнализа = ВариантыАнализаЦелевыхПоказателей.Ссылка)
		|	%ТаблицаПользователей%
		|
		|ГДЕ
		|	(НЕ ВариантыАнализаЦелевыхПоказателей.Ссылка.ПометкаУдаления)
		|	%ОтборЕслиПолеПользователя%
		|
		|СГРУППИРОВАТЬ ПО
		|	ВариантыАнализаЦелевыхПоказателей.Владелец,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.ТипАнализа,
		|	Пользователи.КоличествоПользователей,
		|	ВЫБОР
		|		КОГДА НесохраненныеНастройкиДоступности.Пользователь ЕСТЬ NULL 
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ
		|	%ГруппировкаПользователей%
		|
		|УПОРЯДОЧИТЬ ПО 
		|	ВариантыАнализаЦелевыхПоказателей.Владелец.РеквизитДопУпорядочиванияИерархического, 
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.РеквизитДопУпорядочивания
		|
		|%ПараметрыИтогов%";
		
	Иначе
		Запрос.Текст = "%ПакетПользователей%
		|ВЫБРАТЬ
		|	ВАЦПНастройкиДоступности.Ссылка КАК ВариантАнализа,
		|	ВАЦПНастройкиДоступности.Пользователь,
		|	ВАЦПНастройкиДоступности.Пользователь.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ ВАЦПНастройкиДоступности
		|ИЗ
		|	Справочник.ВариантыАнализаЦелевыхПоказателей.НастройкиДоступности КАК ВАЦПНастройкиДоступности
		|
		| %ПараметрОтбора%
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВариантыАнализаЦелевыхПоказателей.Владелец КАК Цель,
		|	ВЫБОР
		|		КОГДА Пользователи.КоличествоПользователей = КОЛИЧЕСТВО(ВАЦПНастройкиДоступности.ВариантАнализа)
		|			ТОГДА 1
		|		КОГДА КОЛИЧЕСТВО(ВАЦПНастройкиДоступности.ВариантАнализа) = 0
		|			ТОГДА 0
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК ДоступностьПоЦели,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка КАК ВариантАнализа,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.ТипАнализа КАК ТипАнализа,
		|	ВЫБОР
		|		КОГДА Пользователи.КоличествоПользователей = КОЛИЧЕСТВО(ВАЦПНастройкиДоступности.ВариантАнализа)
		|			ТОГДА 1
		|		КОГДА КОЛИЧЕСТВО(ВАЦПНастройкиДоступности.ВариантАнализа) = 0
		|			ТОГДА 0
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Доступность,
		|	2 КАК ТипСтроки
		|	%ПолеПользователя%
		|	%ПолеКоличествоПользователей%
		|ИЗ
		|	Справочник.ВариантыАнализаЦелевыхПоказателей КАК ВариантыАнализаЦелевыхПоказателей
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВАЦПНастройкиДоступности КАК ВАЦПНастройкиДоступности
		|		ПО (ВАЦПНастройкиДоступности.ВариантАнализа = ВариантыАнализаЦелевыхПоказателей.Ссылка)
		|	%ТаблицаПользователей%
		|
		|ГДЕ
		|	(НЕ ВариантыАнализаЦелевыхПоказателей.Ссылка.ПометкаУдаления)
		|	%ОтборЕслиПолеПользователя%
		|
		|СГРУППИРОВАТЬ ПО
		|	ВариантыАнализаЦелевыхПоказателей.Владелец,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка,
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.ТипАнализа,
		|	Пользователи.КоличествоПользователей,
		|	ВЫБОР
		|		КОГДА ВАЦПНастройкиДоступности.Пользователь ЕСТЬ NULL 
		|			ТОГДА 0
		|		ИНАЧЕ 1
		|	КОНЕЦ
		|	%ГруппировкаПользователей%
		|
		|УПОРЯДОЧИТЬ ПО 
		|	ВариантыАнализаЦелевыхПоказателей.Владелец.РеквизитДопУпорядочиванияИерархического, 
		|	ВариантыАнализаЦелевыхПоказателей.Ссылка.РеквизитДопУпорядочивания
		|
		|%ПараметрыИтогов%";
		
	КонецЕсли;
	
	// Проверим какие типы значений встречаются в параметре отбора
	ЕстьПодразделения = Ложь;
	ЕстьПустыеПодразделения = Ложь;
	ЕстьПользователи = Ложь;
	КонечноеПодразделение = Истина;
	
	Если НЕ ПараметрыОтбора = Неопределено Тогда
		ПодразделенияОтбора = Новый Массив;
		ПользователиОтбора = Новый Массив;
		
		Для Каждого ПараметрОтбора Из ПараметрыОтбора Цикл 
			Строка = ДеревоПользователей.НайтиПоИдентификатору(ПараметрОтбора);
			
			Если ЗначениеЗаполнено(Строка.Пользователь) Тогда 
				ЕстьПользователи = Истина;
				ПользователиОтбора.Добавить(Строка.Пользователь);
			ИначеЕсли ЗначениеЗаполнено(Строка.Подразделение) Тогда 
				ЕстьПодразделения = Истина;
				ПодразделенияОтбора.Добавить(Строка.Подразделение);
			ИначеЕсли НЕ ЗначениеЗаполнено(Строка.Подразделение) Тогда 
				ЕстьПустыеПодразделения = Истина;
				ПодразделенияОтбора.Добавить(Строка.Подразделение);
			КонецЕсли;
			
			Если Строка.ТипСтроки = 0 И ЗначениеЗаполнено(Строка.Подразделение) Тогда
				ПодчиненныеСтроки = Строка.ПолучитьЭлементы();
				
				Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл 
					Если ПодчиненнаяСтрока.Подразделение <> Строка.Подразделение Тогда
						КонечноеПодразделение = Ложь;
					КонецЕсли;
				КонецЦикла;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЕстьПользователи Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПакетПользователей%", ПолучитьТекстПакетаПользователейПоПользователю());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТаблицаПользователей%", ",Пользователи КАК Пользователи");
	ИначеЕсли ВсеВариантыАнализа Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПакетПользователей%", ПолучитьТекстПакетаПользователейБезПараметров());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТаблицаПользователей%", ",Пользователи КАК Пользователи");
	ИначеЕсли ЕстьПустыеПодразделения ИЛИ КонечноеПодразделение Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПакетПользователей%", ПолучитьТекстПакетаПользователейПустогоПодразделения());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТаблицаПользователей%", ",Пользователи КАК Пользователи");
	ИначеЕсли ЕстьПодразделения Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПакетПользователей%", ПолучитьТекстПакетаПользователей());
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ТаблицаПользователей%", ",Пользователи КАК Пользователи");
	КонецЕсли;
	
	Если НЕ ВсеВариантыАнализа Тогда
		Если ЕстьПустыеПодразделения Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбора%", "ГДЕ ВАЦПНастройкиДоступности.Пользователь.Подразделение = &Подразделение");
			Если ИспользоватьНесохраненныеНастройки Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Подразделение = &Подразделение");
			Иначе
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Пользователь.Подразделение  = &Подразделение");
			КонецЕсли;
			Запрос.УстановитьПараметр("Подразделение", Справочники.СтруктураПредприятия.ПустаяСсылка());
			
		ИначеЕсли ЕстьПодразделения И КонечноеПодразделение Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбора%", "ГДЕ ВАЦПНастройкиДоступности.Пользователь.Подразделение = &Подразделение");
			Если ИспользоватьНесохраненныеНастройки Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Подразделение = &Подразделение");
			Иначе
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Пользователь.Подразделение  = &Подразделение");
			КонецЕсли;
			Запрос.УстановитьПараметр("Подразделение", ПодразделенияОтбора[0]);
			
		ИначеЕсли ЕстьПодразделения Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбора%", "ГДЕ ВАЦПНастройкиДоступности.Пользователь.Подразделение В ИЕРАРХИИ(&Подразделения)");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Подразделение В ИЕРАРХИИ(&Подразделения)");
			Запрос.УстановитьПараметр("Подразделения", ПодразделенияОтбора);
			
		ИначеЕсли ЕстьПользователи Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбора%", "ГДЕ ВАЦПНастройкиДоступности.Пользователь = &Пользователь");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "ГДЕ НесохраненныеНастройкиДоступности.Пользователь = &Пользователь");
			Запрос.УстановитьПараметр("Пользователь", ПользователиОтбора[0]);
			
		КонецЕсли;
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбора%", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрОтбораНесохраненных%", "");
		
	КонецЕсли;
	
	Если РезультатВДерево Тогда
		Если ЕстьПустыеПодразделения ИЛИ ЕстьПодразделения Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрыИтогов%", ПолучитьТекстИтоговЕслиЕстьПодразделение());
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеКоличествоПользователей%", ",Пользователи.КоличествоПользователей КАК КоличествоПользователей");
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрыИтогов%", ПолучитьТекстИтогов());
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеКоличествоПользователей%", "");
		КонецЕсли;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПользователя%", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборЕслиПолеПользователя%", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ГруппировкаПользователей%", "");
		
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПараметрыИтогов%", "");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеКоличествоПользователей%", "");
		
		Если ИспользоватьНесохраненныеНастройки Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПользователя%", ", НесохраненныеНастройкиДоступности.Пользователь КАК Пользователь, НесохраненныеНастройкиДоступности.Подразделение КАК Подразделение");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ГруппировкаПользователей%", ", НесохраненныеНастройкиДоступности.Пользователь, НесохраненныеНастройкиДоступности.Подразделение");
			Если ВсеВариантыАнализа Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборЕслиПолеПользователя%", "");
			Иначе
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборЕслиПолеПользователя%", "И НЕ (НесохраненныеНастройкиДоступности.Пользователь Есть NULL)");
			КонецЕсли;
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПользователя%", ", ВАЦПНастройкиДоступности.Пользователь КАК Пользователь, ВАЦПНастройкиДоступности.Подразделение КАК Подразделение");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ГруппировкаПользователей%", ", ВАЦПНастройкиДоступности.Пользователь, ВАЦПНастройкиДоступности.Подразделение");
			Если ВсеВариантыАнализа Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборЕслиПолеПользователя%", "");
			Иначе
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ОтборЕслиПолеПользователя%", "И НЕ (ВАЦПНастройкиДоступности.Пользователь Есть NULL)");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Если РезультатВДерево Тогда
			ВариантыАнализаЗначение = РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
			
			ПодготовитьДеревоВариантовАнализа(ВариантыАнализаЗначение);
			
			УдалитьСтрокиБезПодчиненных(ВариантыАнализаЗначение);
			
		Иначе
			ВариантыАнализаЗначение = РезультатЗапроса.Выгрузить().Скопировать(, "ВариантАнализа, Пользователь, Подразделение");
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВариантыАнализаЗначение;
	
КонецФункции

&НаСервере 
Процедура УстановитьДоступностьЭлементовФормы()
	
	Если ДеревоПользователей.ПолучитьЭлементы().Количество() = 0 Тогда
		Элементы.СтраницыДеревоПользователей.ТекущаяСтраница = Элементы.СтраницаСообщениеОПользователях;
		Элементы.СтраницыВариантовАнализа.Видимость = Ложь;
		Элементы.ФормаСохранитьНастройкиИЗакрыть.Доступность = Ложь;
		Элементы.ФормаСохранитьНастройки.Доступность = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура УдалитьСтрокиБезПодчиненных(ДеревоВариантовАнализа, НачальнаяСтрокаПроверки = Неопределено)
	
	Если НачальнаяСтрокаПроверки = Неопределено Тогда
		СтрокиДерева = ДеревоВариантовАнализа.Строки;
	Иначе
		СтрокиДерева = НачальнаяСтрокаПроверки.Строки;
	КонецЕсли;
	
	ИндексСтроки = СтрокиДерева.Количество() - 1;
	Пока ИндексСтроки >= 0 Цикл 
		ПроверяемаяСтрока = СтрокиДерева[ИндексСтроки];
		
		Если ПроверяемаяСтрока.ТипСтроки = 1 Тогда
			ИндексСтроки = ИндексСтроки - 1;
			Продолжить;
			
		КонецЕсли;
		
		Если ПроверяемаяСтрока.Строки.Количество() Тогда
			УдалитьСтрокиБезПодчиненных(ДеревоВариантовАнализа, ПроверяемаяСтрока);
			
		Иначе
			СтрокиДерева.Удалить(ПроверяемаяСтрока);
			
		КонецЕсли;
		
		ИндексСтроки = ИндексСтроки - 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиДереваПользователей()

	ЗаполнитьДеревоВариантовАнализаСервер();
	
	Элементы.ДеревоВариантовАнализа.ТекущаяСтрока = 0;
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти

