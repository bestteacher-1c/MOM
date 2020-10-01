#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	ИнициализацияПриСозданииНаСервере();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		ПриЧтенииСозданииНаСервере();
		
	КонецЕсли;
	
	#Область СтандартныеПодсистемы
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов2_4", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ОбновитьЗаголовокФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыМеждуОрганизациямиАрендаторПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("РасчетыМеждуОрганизациямиАрендатор");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменитьСтрокуОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ИзменитьСтрокуОС(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущийЭлемент <> Элементы.ОСНомерСтроки Тогда
		Отказ = Истина;
		ИзменитьСтрокуОС();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПодборНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСведения(Команда)
	
	ИзменитьСтрокуОС();
	
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ПараметрыПодбораОС = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.ОСОсновноеСредство, ЭтаФорма);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
					ПараметрыПодбораОС, Элементы.ОС,,,,, 
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

#Область ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)

	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	ДатаНачалаУчетаВнеоборотныхАктивов2_4 = ВнеоборотныеАктивыЛокализация.ДатаНачалаУчетаВнеоборотныхАктивов2_4();
	
	Если Объект.ОтражатьВУпрУчете И Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
	ИначеЕсли Объект.ОтражатьВУпрУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
	ИначеЕсли Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	КонецЕсли; 
	
	Элементы.РасчетыМеждуОрганизациямиАрендатор.ТолькоПросмотр = НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	ОбновитьЗаголовокФормы();
	
	НастроитьЗависимыеЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияПриСозданииНаСервере()

	Если Параметры.Свойство("АктивизироватьСтроку") Тогда
		АктивизироватьСтроку = Параметры.АктивизироватьСтроку;
		Если АктивизироватьСтроку <= Объект.ОС.Количество() И АктивизироватьСтроку > 0 Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаОС;
			Элементы.ОС.ТекущаяСтрока = АктивизироватьСтроку - 1;
		КонецЕсли; 
	КонецЕсли; 
	
	СписокРеквизитов = Новый Массив;
	Для каждого МетаданныеРеквизита Из Метаданные.Документы.ВводОстатковВнеоборотныхАктивов2_4.ТабличныеЧасти.ОС.Реквизиты Цикл
		СписокРеквизитов.Добавить(МетаданныеРеквизита.Имя);
	КонецЦикла; 

	РеквизитыОС = СтрСоединить(СписокРеквизитов, ",");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков(Объект);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуОС(НоваяСтрока = Ложь, Копирование = Ложь)
	
	ТекущиеДанные = Элементы.ОС.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено И НЕ Копирование И НЕ НоваяСтрока Тогда
		Возврат;
	КонецЕсли; 

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыФормы.Вставить("Дата", Объект.Дата);
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("Местонахождение", Объект.Местонахождение);
	ПараметрыФормы.Вставить("ОтражатьВРеглУчете", Объект.ОтражатьВРеглУчете);
	ПараметрыФормы.Вставить("ОтражатьВУпрУчете", Объект.ОтражатьВУпрУчете);
	ПараметрыФормы.Вставить("ОтражатьВБУиНУ", Объект.ОтражатьВБУиНУ);
	ПараметрыФормы.Вставить("ОтражатьВОперативномУчете", Объект.ОтражатьВОперативномУчете);
	ПараметрыФормы.Вставить("ОтражатьВУУ", Объект.ОтражатьВУУ);
	ПараметрыФормы.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	ПараметрыФормы.Вставить("РасчетыМеждуОрганизациямиАрендатор", Объект.РасчетыМеждуОрганизациямиАрендатор);
	ПараметрыФормы.Вставить("СохраняемыеРеквизиты", РеквизитыОС);
	ПараметрыФормы.Вставить("НоваяСтрока", НоваяСтрока);
	ПараметрыФормы.Вставить("Копирование", Копирование);
	
	ИдентификаторСтроки = Неопределено;
	Если ТекущиеДанные <> Неопределено Тогда
		ИдентификаторСтроки = ТекущиеДанные.ПолучитьИдентификатор();
		Если НЕ НоваяСтрока ИЛИ Копирование Тогда
			ЗначенияРеквизитов = Новый Структура(РеквизитыОС);
			ЗаполнитьЗначенияСвойств(ЗначенияРеквизитов, ТекущиеДанные);
			ПараметрыФормы.Вставить("ЗначенияРеквизитов", ЗначенияРеквизитов);
		КонецЕсли; 
		Если Копирование Тогда
			ЗначенияРеквизитов.ОсновноеСредство = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ДопПараметры = Новый Структура("НоваяСтрока,ИдентификаторСтроки", НоваяСтрока, ИдентификаторСтроки);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьСтрокуОСЗавершение", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("Документ.ВводОстатковВнеоборотныхАктивов2_4.Форма.РедактированияСтрокиОС", ПараметрыФормы,,,,,ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСтрокуОСЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.НоваяСтрока Тогда
		СтрокаТаблицы = Объект.ОС.Добавить();
	Иначе
		СтрокаТаблицы = Объект.ОС.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, РезультатЗакрытия);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизиты = "")

	ПриИзмененииРеквизитов(ИзмененныеРеквизиты);
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если ОбновитьВсе Тогда
		Элементы.КартинкаДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ДекорацияДокументПереходаНа2_4.Видимость = Ложь;
		Элементы.ВводОстатковПо.Видимость = Ложь;
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВОперативномУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВБУиНУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУУ")
		ИЛИ ОбновитьВсе Тогда
		
		Если Объект.ОтражатьВОперативномУчете Тогда
			
			Элементы.ВариантОтраженияВУчете.Видимость = Истина;
			
			// Условия должны совпадать с условиями в процедуре ПриИзмененииРеквизитов().
			Элементы.ВариантОтраженияВУчете.ТолькоПросмотр =
				Объект.ОтражатьВБУиНУ
					И НЕ Объект.ОтражатьВОперативномУчете 
					И НЕ Объект.ОтражатьВУУ
				ИЛИ Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВОперативномУчете 
					И НЕ Объект.ОтражатьВБУиНУ
				ИЛИ Объект.ОтражатьВОперативномУчете 
					И Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВБУиНУ
				ИЛИ Объект.ОтражатьВБУиНУ
					И Объект.ОтражатьВУУ
					И НЕ Объект.ОтражатьВОперативномУчете;
		Иначе
			Элементы.ВариантОтраженияВУчете.Видимость = Ложь;
		КонецЕсли; 
		
		ПараметрыВыбораОС = Новый Массив;
		
		ОтборСостояние = Новый Массив;
		Если Объект.ОтражатьВОперативномУчете Тогда
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.НеПринятоКУчету);
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.СнятоСУчета);
		Иначе
			ОтборСостояние.Добавить(Перечисления.СостоянияОС.ПринятоКУчету);
		КонецЕсли; 
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Отбор.Состояние", ОтборСостояние));
		ПараметрыВыбораОС.Добавить(Новый ПараметрВыбора("Контекст", "БУ,УУ"));
		
		Элементы.ОСОсновноеСредство.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораОС);
		
	КонецЕсли; 
	
	Если СтруктураИзмененныхРеквизитов.Свойство("РасчетыМеждуОрганизациямиАрендатор") 
		ИЛИ ОбновитьВсе Тогда
		
		Элементы.Арендатор.ОграничениеТипа = ?(
			Объект.РасчетыМеждуОрганизациямиАрендатор,
			Новый ОписаниеТипов("СправочникСсылка.Организации"),
			Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
		
	КонецЕсли;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаПереданныеВАрендуОсновныеСредства_НастроитьЗависимыеЭлементыФормы(
		ЭтаФорма, СтруктураИзмененныхРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитов(ИзмененныеРеквизиты)

	Если НЕ ЗначениеЗаполнено(ИзмененныеРеквизиты) Тогда
		Возврат; 
	КонецЕсли; 
	
	СписокРеквизитов = СтрРазделить(ИзмененныеРеквизиты, ",");
	
	Если СписокРеквизитов.Найти("ОтражатьВОперативномУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВБУиНУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУУ") <> Неопределено Тогда
		
		Если Объект.ОтражатьВБУиНУ
			И НЕ Объект.ОтражатьВОперативномУчете 
			И НЕ Объект.ОтражатьВУУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВОперативномУчете 
			И НЕ Объект.ОтражатьВБУиНУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВОперативномУчете 
			И Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВБУиНУ Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВБУиНУ
			И Объект.ОтражатьВУУ
			И НЕ Объект.ОтражатьВОперативномУчете Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
			
		ИначеЕсли Объект.ОтражатьВБУиНУ
			И Объект.ОтражатьВОперативномУчете Тогда
			
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах");
			СписокРеквизитов.Добавить("ВариантОтраженияВУчете");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если СписокРеквизитов.Найти("ВариантОтраженияВУчете") <> Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(ВариантОтраженияВУчете) Тогда
			ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете");
		КонецЕсли; 
		
		ОтражатьВУпрУчете = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
				
		ОтражатьВРеглУчете = 
			(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
				ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
				
		Если Объект.ОтражатьВУпрУчете <> ОтражатьВУпрУчете Тогда
			Объект.ОтражатьВУпрУчете = ОтражатьВУпрУчете;
			СписокРеквизитов.Добавить("ОтражатьВУпрУчете");
		КонецЕсли; 
		Если Объект.ОтражатьВРеглУчете <> ОтражатьВРеглУчете Тогда
			Объект.ОтражатьВРеглУчете = ОтражатьВРеглУчете;
			СписокРеквизитов.Добавить("ОтражатьВРеглУчете");
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если СписокРеквизитов.Найти("Дата") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("Организация") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВБУиНУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВОперативномУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУУ") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВРеглУчете") <> Неопределено
		ИЛИ СписокРеквизитов.Найти("ОтражатьВУпрУчете") <> Неопределено Тогда
		
		ЗаполнитьРеквизитыВзависимостиОтСвойств(Объект.ОС);
	КонецЕсли; 
	
	ИзмененныеРеквизиты = СтрСоединить(СписокРеквизитов, ",");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыВзависимостиОтСвойств(СписокСтрок)

	ВспомогательныеРеквизитыОбъекта = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(Объект, Ложь);
	
	Для каждого ДанныеСтроки Из СписокСтрок Цикл
		
		ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ДополнитьВспомогательныеРеквизитыПоДаннымСтроки(
											Объект, ДанныеСтроки, ВспомогательныеРеквизитыОбъекта);
		
		ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
										ДанныеСтроки, ВспомогательныеРеквизиты, "");
										
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьРеквизитыВзависимостиОтСвойств(
				ДанныеСтроки, ВспомогательныеРеквизиты, ПараметрыРеквизитовОбъекта);
				
		ВнеоборотныеАктивыКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ДанныеСтроки, ПараметрыРеквизитовОбъекта);
		
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьЗначенияПоУмолчанию(ДанныеСтроки, Объект);
		
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ПодборНаСервере(ВыбранноеЗначение)

	ДобавленныеСтроки = ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.ОС, "ОсновноеСредство", ВыбранноеЗначение);

	ВспомогательныеРеквизитыОбъекта = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(Объект, Ложь);
	
	Для каждого ДанныеСтроки Из ДобавленныеСтроки Цикл
		
		ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ДополнитьВспомогательныеРеквизитыПоДаннымСтроки(
										Объект, ДанныеСтроки, ВспомогательныеРеквизитыОбъекта);
		
		ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
										ДанныеСтроки, ВспомогательныеРеквизиты, "");
										
		Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьРеквизитыВзависимостиОтСвойств(
				ДанныеСтроки, ВспомогательныеРеквизиты, ПараметрыРеквизитовОбъекта);
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

