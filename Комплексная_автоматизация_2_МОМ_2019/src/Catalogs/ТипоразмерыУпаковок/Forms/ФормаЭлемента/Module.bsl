
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВысотаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура ШиринаПриИзменении(Элемент)
	ПересчитатьОбъем();
КонецПроцедуры

&НаКлиенте
Процедура БезразмернаяПриИзменении(Элемент)
	УправлениеФормой();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УправлениеФормой();	
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.Высота.Доступность  			= НЕ Объект.Безразмерная;
	Элементы.Глубина.Доступность 			= НЕ Объект.Безразмерная;
	Элементы.Ширина.Доступность  			= НЕ Объект.Безразмерная;
	Элементы.Объем.Доступность  			= НЕ Объект.Безразмерная;
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.ТипоразмерыУпаковок);
	
	Элементы.ОбъемЕдиницаИзмерения.Доступность 		= МожноРедактировать И НЕ Объект.Безразмерная;
	Элементы.ГлубинаЕдиницаИзмерения.Доступность 	= МожноРедактировать И НЕ Объект.Безразмерная;
	Элементы.ШиринаЕдиницаИзмерения.Доступность 	= МожноРедактировать И НЕ Объект.Безразмерная;
	Элементы.ВысотаЕдиницаИзмерения.Доступность 	= МожноРедактировать И НЕ Объект.Безразмерная;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьОбъем()
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(&ШиринаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ШиринаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентШирина,
	|	ВЫРАЗИТЬ(&ВысотаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ВысотаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентВысота,
	|	ВЫРАЗИТЬ(&ГлубинаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ГлубинаЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентГлубина,
	|	ВЫРАЗИТЬ(&ОбъемЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Числитель / ВЫРАЗИТЬ(&ОбъемЕдиницаИзмерения КАК Справочник.УпаковкиЕдиницыИзмерения).Знаменатель КАК КоэффициентОбъем";
	
	Запрос.УстановитьПараметр("ШиринаЕдиницаИзмерения", Объект.ШиринаЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ВысотаЕдиницаИзмерения", Объект.ВысотаЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ГлубинаЕдиницаИзмерения", Объект.ГлубинаЕдиницаИзмерения);
	Запрос.УстановитьПараметр("ОбъемЕдиницаИзмерения", Объект.ОбъемЕдиницаИзмерения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Объект.Объем = Объект.Высота * Выборка.КоэффициентВысота * Объект.Глубина * Выборка.КоэффициентГлубина *
			Объект.Ширина * Выборка.КоэффициентШирина / Выборка.КоэффициентОбъем;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВысотаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ВысотаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ШиринаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ШиринаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ГлубинаЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ГлубинаЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина"));
КонецПроцедуры

&НаКлиенте
Процедура ОбъемЕдиницаИзмеренияНажатие(Элемент, СтандартнаяОбработка)
	ЕдиницаИзмеренияНажатие("ОбъемЕдиницаИзмерения", СтандартнаяОбработка, ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Объем"));
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияНажатие(ИмяПоля, СтандартнаяОбработка, ТипИзмеряемойВеличины)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЕдиницаИзмеренияНажатиеЗавершение", ЭтотОбъект, Новый Структура("ИмяПоля", ИмяПоля));
	
	Отбор = Новый Структура;
	Отбор.Вставить("ТипИзмеряемойВеличины", ТипИзмеряемойВеличины);
	
	ОткрытьФорму("Справочник.УпаковкиЕдиницыИзмерения.ФормаВыбора",
				Новый Структура("Отбор", Отбор),
				ЭтотОбъект,
				,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияНажатиеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		
		Объект[ДополнительныеПараметры.ИмяПоля] = Результат;
		
		Если ДополнительныеПараметры.ИмяПоля = "ОбъемЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ГлубинаЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ШиринаЕдиницаИзмерения"
			Или ДополнительныеПараметры.ИмяПоля = "ВысотаЕдиницаИзмерения" Тогда
			
			ПересчитатьОбъем();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
