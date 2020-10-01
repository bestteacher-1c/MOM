#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

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
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Не ЗначениеЗаполнено(Объект.Валюта) Тогда
		Объект.Валюта = Константы.ВалютаРасценокВидовРабот.Получить();
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ВыработкаСотрудников.Форма.ПодборПоРаспоряжениям" Тогда
		
		ОбработкаПодбораРаспоряжений(ВыбранноеЗначение.АдресВХранилище);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ВыработкаСотрудников", ПараметрыЗаписи, Объект.Ссылка);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура БригадаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Бригада) Тогда
		БригадаПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНарядаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СохраненныеЗначения = Объект.ВидНаряда;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидНарядаПриИзменении(Элемент)
	
	Если СохраненныеЗначения = Объект.ВидНаряда Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Персональный") Тогда
		Объект.Работники.Очистить();
		Объект.Бригада = Неопределено;
	КонецЕсли;
	
	Объект.Автораспределение = Ложь;
	
	УстановитьВидимостьИДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьКТУПриИзменении(Элемент)
	
	Если Объект.ИспользоватьКТУ Тогда
		Для Каждого Строка Из Объект.Работники Цикл
			Строка.КТУ = 1;
		КонецЦикла;
	КонецЕсли;
	
	РаспределитьСуммуПоУчастникамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтработанноеВремяПриИзменении(Элемент)
	
	Если Не Объект.ИспользоватьОтработанноеВремя Тогда
		Объект.ИспользоватьТарифныеСтавки = Ложь;
	КонецЕсли;
	
	НастроитьФормуПоИспользуемымКадровымДанным(ЭтаФорма);
	
	РаспределитьСуммуПоУчастникамНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьТарифныеСтавкиПриИзменении(Элемент)
	РаспределитьСуммуПоУчастникамНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АвтораспределениеПриИзменении(Элемент)
	УстановитьВидимостьИДоступность();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыРабот

&НаКлиенте
Процедура ВидыРаботВидРаботПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРаценкуНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Расценка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботКвалификацияИсполнителяПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРаценкуНаСервере(ТекущиеДанные.ПолучитьИдентификатор());
	
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Расценка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботКоличествоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Расценка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботРасценкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	ТекущиеДанные.Сумма = ТекущиеДанные.Количество * ТекущиеДанные.Расценка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботСуммаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	
	Если ТекущиеДанные.Расценка > 0 Тогда
		ТекущиеДанные.Количество = ТекущиеДанные.Сумма / ТекущиеДанные.Расценка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВидыРабот.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И Поле = Элементы.ВидыРаботРаспоряжение Тогда
		Если ЗначениеЗаполнено(ТекущиеДанные.Распоряжение) Тогда
			ПоказатьЗначение(Неопределено, ТекущиеДанные.Распоряжение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Бригадный")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Персональный")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Ремонт")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйПоЗаказу21") Тогда
		
		Отказ = Истина;
		
		ПараметрыЗаполнения = ПараметрыЗаполнения();
		
		Если ПараметрыЗаполнения = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура("СтруктураОтбора", ПараметрыЗаполнения);
		ПараметрыФормы.Вставить("АдресВХранилище", ПоместитьВидыРаботВХранилище());
		ОткрытьФорму("Документ.ВыработкаСотрудников.Форма.ПодборПоРаспоряжениям", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыРаботПриИзменении(Элемент)
	
	Если (Объект.ИспользоватьКТУ
		Или Объект.ИспользоватьТарифныеСтавки
		Или Объект.ИспользоватьОтработанноеВремя
		Или Объект.Автораспределение) И Объект.Работники.Количество() > 0 Тогда
		РаспределитьСуммуПоУчастникамНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура РаботникиПриИзменении(Элемент)
	Если Объект.ИспользоватьКТУ Или Объект.ИспользоватьОтработанноеВремя Или Объект.ИспользоватьТарифныеСтавки Или Объект.Автораспределение Тогда
		РаспределитьСуммуПоУчастникамНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.Работники.ТекущиеДанные;
	
	Если НоваяСтрока И Объект.ИспользоватьКТУ Тогда
		ТекущиеДанные.КТУ = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСотрудникПриИзменении(Элемент)
	
	Если ИспользоватьНачислениеЗарплаты И (Объект.ИспользоватьТарифныеСтавки И Объект.ИспользоватьОтработанноеВремя) Тогда
		ВыделеннаяСтрока = Элементы.Работники.ТекущаяСтрока;
		ЗаполнитьКадровыеДанныеНаСервере(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыделеннаяСтрока));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиСуммаПриИзменении(Элемент)
	СуммаРаспределена = Объект.ВидыРабот.Итог("Сумма") = Объект.Работники.Итог("Сумма");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокумент(Команда)
	
	РеквизитыДляПроверки = Новый Массив;
	
	Если ИспользоватьНачислениеЗарплаты
		И Объект.ИспользоватьОтработанноеВремя
		И Объект.ВидНаряда <> ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Персональный") Тогда
		РеквизитыДляПроверки.Добавить("НачалоПериода");
		РеквизитыДляПроверки.Добавить("КонецПериода");
	КонецЕсли;
	
	ПараметрыЗаполнения = ПараметрыЗаполнения(РеквизитыДляПроверки);
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = Неопределено;
	
	Если Объект.ВидыРабот.Количество() > 0 И Объект.Работники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Списки работ и исполнителей будут перезаполнены. Продолжить?'");
	ИначеЕсли  Объект.ВидыРабот.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список выполненных работ будет перезаполнен. Продолжить?'");
	ИначеЕсли  Объект.Работники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список работников будет перезаполнен. Продолжить?'");
	КонецЕсли;
	
	Если ТекстВопроса <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьДокументНаКлиенте", ЭтотОбъект, ПараметрыЗаполнения);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьДокументНаКлиенте(КодВозвратаДиалога.Да, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокументНаКлиенте(ОтветНаВопрос, Параметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДокументНаСервере(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидыРабот(Команда)
	
	ПараметрыЗаполнения = ПараметрыЗаполнения();
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = Неопределено;
	
	Если Объект.ВидыРабот.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список работ будет перезаполнен. Продолжить?'");
	КонецЕсли;
	
	Если ТекстВопроса <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьВидыРаботНаКлиенте", ЭтотОбъект, ПараметрыЗаполнения);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьВидыРаботНаКлиенте(КодВозвратаДиалога.Да, ПараметрыЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВидыРаботНаКлиенте(ОтветНаВопрос, Параметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьВидыРаботНаСервере(Параметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПоРаспоряжениям(Команда)
	
	ПараметрыЗаполнения = ПараметрыЗаполнения();
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("СтруктураОтбора", ПараметрыЗаполнения);
	ПараметрыФормы.Вставить("АдресВХранилище", ПоместитьВидыРаботВХранилище());
	ОткрытьФорму("Документ.ВыработкаСотрудников.Форма.ПодборПоРаспоряжениям", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСотрудников(Команда)
	
	РеквизитыДляПроверки = Новый Массив;
	РеквизитыДляПроверки.Добавить("Бригада");
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(РеквизитыДляПроверки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = Неопределено;
	
	Если Объект.Работники.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список работников будет перезаполнен. Продолжить?'");
	КонецЕсли;
	
	Если ТекстВопроса <> Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСотрудниковНаКлиенте", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьСотрудниковНаКлиенте(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСотрудниковНаКлиенте(ОтветНаВопрос, Параметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРаботниковНаСервере();
	
	Если Объект.Работники.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Документы выработки для заполнения состава бригады не найдены. Заполните состав бригады вручную.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиЗаполнитьКадровыеДанные(Команда)
	
	РеквизитыДляПроверки = Новый Массив;
	
	Если ИспользоватьНачислениеЗарплаты
		И Объект.ИспользоватьОтработанноеВремя
		И Объект.ВидНаряда <> ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Персональный") Тогда
		РеквизитыДляПроверки.Добавить("НачалоПериода");
		РеквизитыДляПроверки.Добавить("КонецПериода");
	КонецЕсли;
	
	РеквизитыДляПроверки.Добавить("Организация");
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(РеквизитыДляПроверки, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ВыделенныеСтроки = Элементы.Работники.ВыделенныеСтроки;
	
	ЗаполнитьКадровыеДанныеНаСервере(ВыделенныеСтроки);
	
КонецПроцедуры

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
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект,
		Новый Структура("ДатаНачала, ДатаОкончания", "НачалоПериода", "КонецПериода"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// если КТУ не используются, то колонка не отображается
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиКТУ.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьКТУ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Автораспределение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// если тарифные ставки не используются, то колонка не отображается
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиТарифнаяСтавка.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьТарифныеСтавки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// если отработанное время не используется, то колонка не отображается
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиОтработано.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьОтработанноеВремя");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// сумма для сотрудников только для просмотра, если используется автораспределение
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СотрудникиСумма.Имя);
	
	ГруппаОтбораИЛИ = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьКТУ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьТарифныеСтавки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбораИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ИспользоватьОтработанноеВремя");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// подсветка красным, если сумма не распределена
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Распределено.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СуммаРаспределена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);
	
	// распоряжение оформляется цветом как гиперссылка
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыРаботРаспоряжение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВидыРабот.Распоряжение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);
	
	// распоряжение только для просмотра, если заполнено
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыРаботРаспоряжение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВидыРабот.КодСтрокиРаспоряжения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	// квалификация исполнителя, если соответствует виду работ
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыРаботКвалификацияИсполнителя.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ВидыРабот.КвалификацияИсполнителя");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<соответствует виду работ>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьСоставОпераций();
	
	Если ЗначениеЗаполнено(Объект.Валюта) Тогда
		Элементы.ВидыРаботРасценка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Расценка, %1'"), Объект.Валюта);
	Иначе
		Элементы.ГруппаПредупреждение.Видимость = Истина;
	КонецЕсли;
	
	УстановитьВидимостьИДоступность();
	
	НастроитьФормуПоИспользуемымКадровымДанным(ЭтаФорма);
	
	ИспользоватьНачислениеЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты");
	
	СуммаРаспределена = Объект.ВидыРабот.Итог("Сумма") = Объект.Работники.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьИДоступность()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ВыработкаСотрудников.ИменаРеквизитовПоВидуНаряда(
		Объект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьФормуПоИспользуемымКадровымДанным(Форма)
	
	Форма.Элементы.ИспользоватьТарифныеСтавки.Доступность = Форма.Объект.ИспользоватьОтработанноеВремя;
	
	Если Форма.Объект.ИспользоватьТарифныеСтавки И Форма.Объект.ИспользоватьОтработанноеВремя Тогда
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Заголовок = НСтр("ru = 'Ставки и отработанное время'");
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Видимость = Истина;
	ИначеЕсли Форма.Объект.ИспользоватьТарифныеСтавки Тогда
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Заголовок = НСтр("ru = 'Тарифные ставки'");
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Видимость = Истина;
	ИначеЕсли Форма.Объект.ИспользоватьОтработанноеВремя Тогда
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Заголовок = НСтр("ru = 'Отработанное время'");
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Видимость = Истина;
	Иначе
		Форма.Элементы.СотрудникиЗаполнитьКадровыеДанные.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРаценкуНаСервере(Идентификатор)
	
	ДанныеСтроки = Объект.ВидыРабот.НайтиПоИдентификатору(Идентификатор);
	
	ДанныеСтроки.Расценка = Справочники.ВидыРаботСотрудников.ДействующаяРасценкаВидаРабот(ДанныеСтроки.ВидРабот, Объект.Дата, ДанныеСтроки.КвалификацияИсполнителя);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРаботниковНаСервере()
	
	Документы.ВыработкаСотрудников.ЗаполнитьРаботников(Объект);
	
	СуммаРаспределена = Объект.ВидыРабот.Итог("Сумма") = Объект.Работники.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКадровыеДанныеНаСервере(ВыделенныеСтроки)
	
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		МассивСтрок = Новый Массив;
		
		Для Каждого Строка Из ВыделенныеСтроки Цикл
			МассивСтрок.Добавить(Объект.Работники.НайтиПоИдентификатору(Строка));
		КонецЦикла;
		
	Иначе
		МассивСтрок = Неопределено;
	КонецЕсли;
	
	Документы.ВыработкаСотрудников.ЗаполнитьКадровыеДанныеСотрудников(
		Объект,
		"Работники",
		Ложь,
		Объект.ИспользоватьТарифныеСтавки,
		Объект.ИспользоватьОтработанноеВремя,
		МассивСтрок);
		
	Документы.ВыработкаСотрудников.РаспределитьСуммуПоУчастникам(Объект);
	СуммаРаспределена = Объект.ВидыРабот.Итог("Сумма") = Объект.Работники.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Процедура РаспределитьСуммуПоУчастникамНаСервере()
	Документы.ВыработкаСотрудников.РаспределитьСуммуПоУчастникам(Объект);
	СуммаРаспределена = Объект.ВидыРабот.Итог("Сумма") = Объект.Работники.Итог("Сумма");
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗаполнения(РеквизитыДляПроверки = Неопределено)
	
	Если РеквизитыДляПроверки = Неопределено Тогда
		РеквизитыДляПроверки = Новый Массив;
	КонецЕсли;
	
	РеквизитыДляПроверки.Добавить("Организация");
	РеквизитыДляПроверки.Добавить("ВидНаряда");
	РеквизитыДляПроверки.Добавить("Подразделение");
	Если Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Бригадный") Или
		Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйПоЗаказу21") Тогда
		РеквизитыДляПроверки.Добавить("Бригада");
	КонецЕсли;
	
	Отказ = Ложь;
	ПроверитьЗаполнениеРеквизитов(РеквизитыДляПроверки, Отказ);
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Организация");
	ПараметрыЗаполнения.Вставить("Подразделение");
	ПараметрыЗаполнения.Вставить("ВидНаряда");
	ПараметрыЗаполнения.Вставить("НачалоПериода");
	ПараметрыЗаполнения.Вставить("КонецПериода");
	Если Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Бригадный")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.Ремонт")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйБезЗаказа21")
		Или Объект.ВидНаряда = ПредопределенноеЗначение("Перечисление.ВидыБригадныхНарядов.БригадныйПоЗаказу21") Тогда
		ПараметрыЗаполнения.Вставить("Бригада");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, Объект);
	
	ПараметрыЗаполнения.НачалоПериода = НачалоДня(ПараметрыЗаполнения.НачалоПериода);
	ПараметрыЗаполнения.КонецПериода = ?(ЗначениеЗаполнено(ПараметрыЗаполнения.КонецПериода), КонецДня(ПараметрыЗаполнения.КонецПериода), ПараметрыЗаполнения.КонецПериода);
	
	ПараметрыЗаполнения.Вставить("ДокументИсключение", Объект.Ссылка);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

&НаСервере
Функция ПоместитьВидыРаботВХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.ВидыРабот.Выгрузить(,"Распоряжение,КодСтрокиРаспоряжения,Количество"));
	
КонецФункции

&НаСервере
Процедура ЗаполнитьВидыРаботНаСервере(ПараметрыЗаполнения)
	
	Документы.ВыработкаСотрудников.ЗаполнитьВидыРаботПоОстаткам(Объект, ПараметрыЗаполнения);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументНаСервере(ПараметрыЗаполнения)
	
	ЗаполнитьВидыРаботНаСервере(ПараметрыЗаполнения);
	
	Если Объект.ВидНаряда <> Перечисления.ВидыБригадныхНарядов.Персональный Тогда
		Документы.ВыработкаСотрудников.ЗаполнитьРаботников(Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Подразделение, "ИспользоватьКТУ,ИспользоватьТарифныеСтавки,ИспользоватьОтработанноеВремя");
	
	ЗаполнитьЗначенияСвойств(Объект, Реквизиты);
	
	НастроитьФормуПоИспользуемымКадровымДанным(ЭтаФорма);
	
	Если (Объект.ИспользоватьКТУ
		Или Объект.ИспользоватьТарифныеСтавки
		Или Объект.ИспользоватьОтработанноеВремя) И Объект.Работники.Количество() > 0 Тогда
		РаспределитьСуммуПоУчастникамНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура БригадаПриИзмененииНаСервере()
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Бригада, "Подразделение, Организация");
	
	Объект.Подразделение = Реквизиты.Подразделение;
	Объект.Организация = Реквизиты.Организация;
	
	ПодразделениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаполнениеРеквизитов(СтруктураРеквизитов, Отказ = Ложь)
	
	ОчиститьСообщения();
	
	ШаблонСообщения = НСтр("ru = 'Поле ""%1"" не заполнено'");
	
	Для Каждого Реквизит Из СтруктураРеквизитов Цикл
		
		Если НЕ ЗначениеЗаполнено(Объект[Реквизит]) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Элементы[Реквизит].Заголовок);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Реквизит, "Объект", Отказ);
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораРаспоряжений(АдресВХранилище)
	
	Таблица = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Для Каждого Строка Из Таблица Цикл
		НоваяСтрока = Объект.ВидыРабот.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	Если (Объект.ИспользоватьКТУ
		Или Объект.ИспользоватьТарифныеСтавки
		Или Объект.ИспользоватьОтработанноеВремя) И Объект.Работники.Количество() > 0 Тогда
		РаспределитьСуммуПоУчастникамНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСоставОпераций()
	
	Поле = Элементы.ВидНаряда;
	Поле.СписокВыбора.Очистить();
	
	// Если вид наряда ПрочиеРаботы или Ремонт, то изменение вида наряда недоступно, это устаревшие виды нарядов.
	Если Объект.ВидНаряда = Перечисления.ВидыБригадныхНарядов.ПрочиеРаботы Тогда
		Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.ПрочиеРаботы, НСтр("ru = 'Прочим работам'"));
	ИначеЕсли  Объект.ВидНаряда = Перечисления.ВидыБригадныхНарядов.Ремонт Тогда
		Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.Ремонт, НСтр("ru = 'Ремонтам'"));
	// иначе в документе доступны только актуальные виды нарядов
	Иначе
		// если используется производство 2.2, то добавляем новые виды нарядов
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством2_2") Тогда
			Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.Бригадный, НСтр("ru = 'Бригаде'"));
			Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.Персональный, НСтр("ru = 'Работникам'"));
		КонецЕсли;
		
		// Если используется производство 2.1, то добавляем вид наряда по производству без распоряжений.
		Если ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством") Тогда
			Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
				Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21, НСтр("ru = 'Производству'"));
			ИначеЕсли ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеПроизводством2_2") Тогда
				Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйПоЗаказу21, НСтр("ru = 'Заказу на производство (2.1)'"));
				Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21, НСтр("ru = 'Производству без заказа (2.1)'"));
			Иначе
				Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйПоЗаказу21, НСтр("ru = 'Заказу на производство'"));
				Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21, НСтр("ru = 'Производству без заказа'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	
	Если Объект.ВидНаряда = Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21
		И Поле.СписокВыбора.НайтиПоЗначению(Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21) = Неопределено Тогда
		Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.БригадныйБезЗаказа21, НСтр("ru = 'Производству без заказа (2.1)'"));
	КонецЕсли;
	
	Если Объект.ВидНаряда = Перечисления.ВидыБригадныхНарядов.Бригадный
		И Поле.СписокВыбора.НайтиПоЗначению(Перечисления.ВидыБригадныхНарядов.Бригадный) = Неопределено Тогда
		Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.Бригадный, НСтр("ru = 'Бригаде'"));
	КонецЕсли;
	
	Если Объект.ВидНаряда = Перечисления.ВидыБригадныхНарядов.Персональный
		И Поле.СписокВыбора.НайтиПоЗначению(Перечисления.ВидыБригадныхНарядов.Персональный) = Неопределено Тогда
		Поле.СписокВыбора.Добавить(Перечисления.ВидыБригадныхНарядов.Персональный, НСтр("ru = 'Работникам'"));
	КонецЕсли;
	
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

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти

