#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоНастройкиОбмена         = ОбменСКонтрагентамиСлужебныйВызовСервера.ЕстьПравоНастройкиОбмена();
	ИспользуютсяДоговорыКонтрагентов = ОбменСКонтрагентамиПовтИсп.ИспользуютсяДоговорыКонтрагентов();
	
	Элементы.НастройкиОтправкиСоздатьПоОрганизации.Видимость = ЕстьПравоНастройкиОбмена;
	Если Не ИспользуютсяДоговорыКонтрагентов Тогда
		Элементы.НастройкиОтправкиСоздатьПоОрганизации.Заголовок = НСтр("ru = 'Создать'");
		Элементы.НастройкиОтправкиОрганизация.Заголовок = НСтр("ru = 'Организация'");
	КонецЕсли;
	
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Видимость    = ЕстьПравоНастройкиОбмена И ИспользуютсяДоговорыКонтрагентов;
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("Контрагент", Контрагент);
	
	ЗаполнитьДеревоНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТекущиеДелаЭДО" Тогда
		 ЗаполнитьДеревоНастроек();
	ИначеЕсли ИмяСобытия = "ИзмененСтатусПриглашения" И Параметр = Контрагент Тогда
		 ЗаполнитьДеревоНастроек();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОтправки

&НаКлиенте
Процедура НастройкиОтправкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.НастройкиОтправки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация" , ТекущиеДанные.Организация);
	ПараметрыОткрытия.Вставить("Договор"     , ТекущиеДанные.Договор);
	ПараметрыОткрытия.Вставить("Контрагент"  , Контрагент);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьФормуНастройкиОтправкиЭДО(ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоОрганизации(Команда)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Контрагент", Контрагент);
	ПараметрыОткрытия.Вставить("СоздатьПоДоговору", Ложь);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьФормуНастройкиОтправкиЭДО(ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоДоговору(Команда)
	
	ТекущиеДанные = Элементы.НастройкиОтправки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Контрагент", Контрагент);
	ПараметрыОткрытия.Вставить("Организация", ТекущиеДанные.Организация);
	ПараметрыОткрытия.Вставить("СоздатьПоДоговору", Истина);
	
	ОбменСКонтрагентамиСлужебныйКлиент.ОткрытьФормуНастройкиОтправкиЭДО(ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Включен расширенный режим>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиОтправки.РасширенныйРежим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиОтправкиСпособОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНастроек()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументов.Договор) КАК КоличествоСтатусов
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Получатель = &Получатель
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор КАК Договор,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя) КАК КоличествоИдентификаторовОтправителя,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя) КАК КоличествоИдентификаторовПолучателя,
		|	ЕСТЬNULL(ПриглашенияКОбменуЭлектроннымиДокументами.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Отклонено)) КАК Статус
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|		ПО НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя = ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации
		|			И НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя = ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторКонтрагента
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель = &Получатель
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель,
		|	ЕСТЬNULL(ПриглашенияКОбменуЭлектроннымиДокументами.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Отклонено))";
	
	Запрос.УстановитьПараметр("Получатель", Контрагент);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ТаблицаОтправителей        = РезультатыЗапроса[0].Выгрузить();
	ТаблицаНастроекКонтрагента = РезультатыЗапроса[1].Выгрузить();
	ТаблицаНастроекКонтрагента.Индексы.Добавить("Отправитель");
	
	ЭлементыДерева = НастройкиОтправки.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Для Каждого СтрокаТЧ Из ТаблицаОтправителей Цикл
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Организация   = СтрокаТЧ.Отправитель;
		НоваяСтрока.Представление = СтрокаТЧ.Отправитель;
		
		Отбор = Новый Структура("Отправитель", СтрокаТЧ.Отправитель);
		НайденныеСтроки = ТаблицаНастроекКонтрагента.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() = 1 Тогда
			
			НоваяСтрока.Статус = НайденныеСтроки[0].Статус;
			НоваяСтрока.РасширенныйРежим = НайденныеСтроки[0].КоличествоИдентификаторовОтправителя <> 1
						Или НайденныеСтроки[0].КоличествоИдентификаторовПолучателя <> 1;
						
		ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
			
			Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаТаблицы.Договор) Тогда 
					НоваяСтрока.Статус = СтрокаТаблицы.Статус;
					НоваяСтрока.РасширенныйРежим = СтрокаТаблицы.КоличествоИдентификаторовОтправителя <> 1
						Или СтрокаТаблицы.КоличествоИдентификаторовПолучателя <> 1;
					Продолжить;
				КонецЕсли;
				
				Договор = НоваяСтрока.ПолучитьЭлементы().Добавить();
				Договор.Организация = СтрокаТаблицы.Отправитель;
				Договор.Договор = СтрокаТаблицы.Договор;
				Договор.Представление = СтрокаТаблицы.Договор;
				Договор.Статус = СтрокаТаблицы.Статус;
				НоваяСтрока.РасширенныйРежим = СтрокаТаблицы.КоличествоИдентификаторовОтправителя <> 1
						Или СтрокаТаблицы.КоличествоИдентификаторовПолучателя <> 1;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Доступность = НастройкиОтправки.ПолучитьЭлементы().Количество();
	
КонецПроцедуры

#КонецОбласти