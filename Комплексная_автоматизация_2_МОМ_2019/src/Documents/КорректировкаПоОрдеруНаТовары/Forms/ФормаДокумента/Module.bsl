#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	КонецЕсли;
	
	ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(Объект.Склад, Объект.Помещение);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// Обработчик механизма "Назначения"
	Справочники.Назначения.ФормаДокументаПриСозданииНаСервере(ЭтаФорма);

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

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары,ПараметрыЗаполненияРеквизитов);
	
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	ПриИзмененииСкладаПомещенияДаты();
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	ПриИзмененииСкладаПомещенияДаты();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ПриИзмененииСкладаПомещенияДаты();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура();
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,	СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	Перем ТекущаяСтрока;
	Перем СтруктураДействий;

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;

	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий", Объект.Склад, ПараметрыУказанияСерий));

	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		ЭтаФорма.ИмяФормы, "Товары"));

	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = Элементы.Товары.ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)	
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);

КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура();
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока,	СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма);

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");

	//

	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУпаковка.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьАдресноеХранение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНоменклатуры.Товар;

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУпаковка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьАдресноеХранение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.ТипНоменклатуры");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыНоменклатуры.Товар;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеНазначенияНоменклатуры(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",
											Новый Структура("Номенклатура", "ТипНоменклатуры"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",
											Новый Структура("Номенклатура", "Артикул"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, ПараметрыЗаполненияРеквизитов);
	ПриИзмененииСкладаПомещенияДаты(Истина);
	Элементы.ГруппаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ПриИзмененииСкладаПомещенияДаты(ВызовПриЧтенииСоздании = Ложь)
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад, Помещение", Объект.Склад, Объект.Помещение));
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.КорректировкаПоОрдеруНаТовары));
	
	Если Не ВызовПриЧтенииСоздании Тогда
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	Элементы.Помещение.Видимость      = СкладыСервер.ИспользоватьСкладскиеПомещения(Объект.Склад,Объект.Дата);
	Элементы.ТоварыСерия.Видимость    = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "")
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст)Тогда
		
		ТекущиеДанныеИдентификатор = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
		
		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение",
														ЭтотОбъект,
														ПараметрыФормыУказанияСерий);

		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,
					ПараметрыФормыУказанияСерий,
					ЭтаФорма,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ПараметрыФормыУказанияСерий) Экспорт
     
	Если Результат <> Неопределено Тогда
        ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий, КэшированныеЗначения);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий, КэшированныеЗначения)
	
	Действия = Новый Структура;
	Действия.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	Действия.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	Действия.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	Действия.Вставить("ПроверитьСериюРассчитатьСтатус", Новый Структура("Склад, ПараметрыУказанияСерий",
																				Объект.Склад, ПараметрыУказанияСерий));
	
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект,ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий,Действия,КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

#КонецОбласти

#КонецОбласти
