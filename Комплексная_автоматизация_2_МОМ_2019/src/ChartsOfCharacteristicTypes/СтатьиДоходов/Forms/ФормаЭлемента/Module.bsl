
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	//++ НЕ УТ
	Если Не ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА() Тогда
		Список = Элементы.ТипЗначения.СписокВыбора;
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.ОбъектыЭксплуатации"));
		Список.Удалить(Список.НайтиПоЗначению("СправочникСсылка.НематериальныеАктивы"));
	КонецЕсли;
	//-- НЕ УТ
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	УстановитьВидимостьПолей();
	УстановитьВидимостьТиповЗначенийАналитики();
	
	Пояснение1 = НСтр("ru='Основная система налогообложения указывается в учетной политике.
		|Прибыли, накопленные в течение месяца, списываются на счет 99.01.1
		|""Прибыли и убытки по деятельности с основной системой налогообложения""'");
	Пояснение2 = НСтр("ru='Доходы по деятельности, порядок налогообложения которой не совпадает с основным.
		|В частности, по деятельности, переведенной на уплату ЕНВД или патентную систему налогообложения.
		|Прибыли, накопленные в течение месяца, списываются на счет 99.01.2 
		|""Прибыли и убытки по отдельным видам деятельности с особым порядком налогообложения""'");
	
	Если Метаданные.ПланыСчетов.Найти("Хозрасчетный") <> Неопределено Тогда
		Элементы.КорреспондирующийСчет.Видимость = Ложь;
	Иначе
		ЗаполнитьСписокВыбораКорСчета();
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		Элементы.СтраницаРегламентированныйУчет.Видимость = Ложь;
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
	//++ НЕ УТ
	ДоступныеСчетаУчетаПрочихДоходов();
	//-- НЕ УТ
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	//++ НЕ УТ
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям();
	//-- НЕ УТ
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ПустаяСтрока(ТипЗначения) Тогда
		ТекстСообщения = НСтр("ru = 'В поле ""Аналитика доходов"" не выбрано ни одного вида аналитики'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			, // ОбъектИлиСсылка
			"ТипЗначения",
			, // ПутьКДанным
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	Если Не ПустаяСтрока(ТипЗначения) Тогда
		ТекущийОбъект.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	//++ НЕ УТ
	Если ТипЗначения = "СправочникСсылка.ОбъектыЭксплуатации"
		Или ТипЗначения = "СправочникСсылка.НематериальныеАктивы" Тогда
		Объект.КонтролироватьЗаполнениеАналитики = Истина;
		Элементы.КонтролироватьЗаполнениеАналитики.Доступность = Ложь;
	Иначе
		Элементы.КонтролироватьЗаполнениеАналитики.Доступность = Истина;
	КонецЕсли;
	//-- НЕ УТ
	Возврат; // Обработчик используется только в УТ
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятиеКналоговомуУчетуПриИзменении(Элемент)
	
	//++ НЕ УТ
	ПринятиеКналоговомуУчетуПриИзмененииСервер();
	//-- НЕ УТ
	Возврат; // Обработчик используется только в УТ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСчетаРеглУчетаПоОрганизациямИПодразделениям(Команда)
	
	//++ НЕ УТ
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВопросЗаписиОбъекта", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Для продолжения необходимо записать объект. Записать?'");
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Записать'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
		Возврат;
	КонецЕсли;
	ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям();
	//-- НЕ УТ
	
	Возврат; // Чтобы в УТ был не пустой обработчик
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УстановитьВидимостьТиповЗначенийАналитики()
	
	МассивИсключаемыхТипов = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыПоставщикам") Тогда
		МассивИсключаемыхТипов.Добавить("ДокументСсылка.ЗаказПоставщику");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.НаправленияДеятельности");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		МассивИсключаемыхТипов.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.СтруктураПредприятия");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.Организации");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		МассивИсключаемыхТипов.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
	Для Каждого ИсключаемыйТип Из МассивИсключаемыхТипов Цикл
		ЭлементСписка = Элементы.ТипЗначения.СписокВыбора.НайтиПоЗначению(ИсключаемыйТип);
		Если ЭлементСписка <> Неопределено И ТипЗначения <> ИсключаемыйТип Тогда
			Элементы.ТипЗначения.СписокВыбора.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПолей()

	Если Объект.Ссылка = ПланыВидовХарактеристик.СтатьиДоходов.ВыручкаОтПродаж Тогда
		Элементы.СпособРаспределения.Видимость = Ложь;
	КонецЕсли;
	
	//++ НЕ УТ
	ДоходыПоАктивам = (ТипЗначения = "СправочникСсылка.ОбъектыЭксплуатации")
				  ИЛИ (ТипЗначения = "СправочникСсылка.НематериальныеАктивы");
	
	Элементы.КонтролироватьЗаполнениеАналитики.Доступность = Не ДоходыПоАктивам;
	
	ИспользуетсяЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД");
	РасходыПоОСНО = (Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения);
	
	Элементы.ГруппаВидДеятельностиДляНалоговогоУчетаЗатрат.Видимость = ИспользуетсяЕНВД ИЛИ НЕ РасходыПоОСНО;
	Элементы.ГруппаОтражениеВРеглУчете.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") И ПравоДоступа("Просмотр", Метаданные.ПланыСчетов.Хозрасчетный);
	Элементы.ВидДеятельностиДляНалоговогоУчетаЗатрат.Доступность = Объект.ПринятиеКналоговомуУчету;
	
	Элементы.ВидДоходов.АвтоОтметкаНезаполненного = Объект.ПринятиеКналоговомуУчету;
	//-- НЕ УТ
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьТипЗначения();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипЗначения()

	СписокТиповЗначений = Новый СписокЗначений;
	СписокТиповЗначений.Добавить("СправочникСсылка.Организации");
	СписокТиповЗначений.Добавить("СправочникСсылка.СтруктураПредприятия");
	СписокТиповЗначений.Добавить("СправочникСсылка.НаправленияДеятельности");
	СписокТиповЗначений.Добавить("СправочникСсылка.Партнеры");
	СписокТиповЗначений.Добавить("ДокументСсылка.ЗаказПоставщику");
	СписокТиповЗначений.Добавить("СправочникСсылка.ДоговорыКредитовИДепозитов");
	СписокТиповЗначений.Добавить("ПеречислениеСсылка.АналитикаКурсовыхРазниц");
	//++ НЕ УТ
	СписокТиповЗначений.Добавить("СправочникСсылка.ОбъектыЭксплуатации");
	СписокТиповЗначений.Добавить("СправочникСсылка.НематериальныеАктивы");
	//-- НЕ УТ

	Для Каждого ЭлементСписка Из СписокТиповЗначений Цикл
		Если Объект.ТипЗначения.СодержитТип(Тип(ЭлементСписка.Значение)) Тогда
			ТипЗначения = ЭлементСписка.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКорСчета()

	СписокВыбора = Элементы.КорреспондирующийСчет.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить("91.01", НСтр("ru='Прочие доходы (91.01)'"));

КонецПроцедуры

//++ НЕ УТ

&НаСервере
Процедура ПринятиеКналоговомуУчетуПриИзмененииСервер()
	
	Если Не Объект.ПринятиеКналоговомуУчету Тогда
		Объект.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения;
	КонецЕсли;
	
	УстановитьВидимостьПолей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросЗаписиОбъекта(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Не Записать() Тогда
			Возврат;
		КонецЕсли;
		ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтатьяДоходов", Объект.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям", ЭтотОбъект);
	
	ОткрытьФорму("РегистрСведений.ПорядокОтраженияДоходов.Форма.ФормаНастройки", 
		ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям(Результат, ДополнительныеПараметры) Экспорт
	
	ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям();
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСостояниеНастройкиСчетовРеглУчетаПоОрганизациямИПодразделениям()
	
	ЗаголовокКоманды = НСтр("ru = 'Посмотреть настройки счетов учета по организациям и подразделениям'");
	
	Если ПравоДоступа("Редактирование", Метаданные.РегистрыСведений.ПорядокОтраженияДоходов) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Количество
		|ИЗ
		|	РегистрСведений.ПорядокОтраженияДоходов КАК ПорядокОтражения
		|ГДЕ
		|	ПорядокОтражения.СтатьяДоходов = &СтатьяДоходов";
		Запрос.УстановитьПараметр("СтатьяДоходов", Объект.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ЗаголовокКоманды = НСтр("ru = 'Настроить счета учета по организациям и подразделениям'");
		Иначе
			ЗаголовокКоманды = НСтр("ru = 'Изменить настройку счетов учета по организациям и подразделениям'");
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.НастроитьСчетаРеглУчетаПоОрганизациямИПодразделениям.Заголовок = ЗаголовокКоманды; 
	
КонецПроцедуры

&НаСервере
Процедура ДоступныеСчетаУчетаПрочихДоходов()
	
	ПараметрыВыбораСчета = Новый Массив;
	
	Если ПравоДоступа("Просмотр", Метаданные.ПланыСчетов.Хозрасчетный) Тогда
		СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаПрочихДоходов();
		ПараметрыВыбораСчета.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаПрочихДоходов)));
	КонецЕсли;
	
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораСчета);
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#КонецОбласти
