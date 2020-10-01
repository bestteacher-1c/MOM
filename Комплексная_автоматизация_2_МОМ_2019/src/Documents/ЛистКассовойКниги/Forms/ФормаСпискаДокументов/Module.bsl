
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьНесколькоВалют = Константы.ИспользоватьНесколькоВалют.Получить();
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	НаименованиеВалютыРеглУчета = Строка(ВалютаРегламентированногоУчета);
	
	Элементы.СуммаПоступления.Заголовок = НСтр("ru='Приход ('") + НаименованиеВалютыРеглУчета +")";
	Элементы.СуммаВыдачи.Заголовок = НСтр("ru='Расход ('") + НаименованиеВалютыРеглУчета +")";
	Элементы.СуммаКонечныйОстаток.Заголовок = НСтр("ru='Конечный остаток ('") + НаименованиеВалютыРеглУчета +")";
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	СписокТипов = КассовыеКниги.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "КассовыеКниги";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.КассовыеКнигиКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	СписокТипов = ПриходныеКассовыеОрдера.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "ПриходныеКассовыеОрдера";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ПриходныеКассовыеОрдераКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	
	СписокТипов = РасходныеКассовыеОрдера.КомпоновщикНастроек.Настройки.Выбор.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка")).Тип;
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.Источники = СписокТипов;
	ПараметрыРазмещения.ПрефиксГрупп = "РасходныеКассовыеОрдера";
	ПараметрыРазмещения.КоманднаяПанель = Элементы.РасходныеКассовыеОрдераКоманднаяПанель;
	
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	КассоваяКнига = Настройки.Получить("КассоваяКнига");
	
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОрганизацияОтборПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияОтборПриИзмененииСервер()
	
	КассоваяКнига = Неопределено;
	ЗаполнитьСписокВыбораКассовыхКниг();
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", Организация));
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКассовойКнигиОтбор", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.КассовыеКниги.ФормаВыбора", ПараметрыФормы, ЭтаФорма,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКассовойКнигиОтбор(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		КассоваяКнига = Результат;
		КассоваяКнигаПредставление = Строка(КассоваяКнига);
		УстановитьОтборДинамическихСписков();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборОчистка(Элемент, СтандартнаяОбработка)
	
	КассоваяКнига = Неопределено;
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КассоваяКнигаОтборОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	КассоваяКнига = ВыбранноеЗначение;
	
	Если ВыбранноеЗначение = ПредопределенноеЗначение("Справочник.КассовыеКниги.ПустаяСсылка") Тогда
		ВыбранноеЗначение = НСтр("ru = '<Основная кассовая книга организации>'");
	КонецЕсли;
	
	УстановитьОтборДинамическихСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьДиначескиеСписки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКассовыеКниги

&НаКлиенте
Процедура КассовыеКнигиПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПриходныеОрдера Тогда
		Источник = Элементы.ПриходныеКассовыеОрдера;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходныеОрдера Тогда
		Источник = Элементы.РасходныеКассовыеОрдера;
	Иначе
		Источник = Элементы.КассовыеКниги;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Источник);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПриходныеОрдера Тогда
		Источник = Элементы.ПриходныеКассовыеОрдера;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходныеОрдера Тогда
		Источник = Элементы.РасходныеКассовыеОрдера;
	Иначе
		Источник = Элементы.КассовыеКниги;
	КонецЕсли;
	
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Источник, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаПриходныеОрдера Тогда
		Источник = Элементы.ПриходныеКассовыеОрдера;
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаРасходныеОрдера Тогда
		Источник = Элементы.РасходныеКассовыеОрдера;
	Иначе
		Источник = Элементы.КассовыеКниги;
	КонецЕсли;	
	
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Источник);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.КассовыеКниги);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиДенежныхСредств(Команда)
	
	ПараметрыФормы = Новый Структура("Отбор, КлючНазначенияИспользования, КлючВарианта, СформироватьПриОткрытии");
	
	Отбор = Новый Структура;
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.Вариант = ВариантСтандартногоПериода.ЭтотМесяц;
	Отбор.Вставить("ПериодОтчета", ПериодОтчета);
	
	ТипыДенежныхСредств = Новый СписокЗначений;
	ТипыДенежныхСредств.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные"));
	Отбор.Вставить("ТипДенежныхСредств", ТипыДенежныхСредств);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	ПараметрыФормы.Вставить("Отбор", Отбор);
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", "Документ.ЛистКассовойКниги");
	ПараметрыФормы.Вставить("КлючВарианта", "ВедомостьПоДенежнымСредствам");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ВедомостьПоДенежнымСредствам.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Списки = Новый Массив;
	Списки.Добавить(КассовыеКниги);
	Списки.Добавить(ПриходныеКассовыеОрдера);
	Списки.Добавить(РасходныеКассовыеОрдера);
	
	Для каждого Список Из Списки Цикл
	
		СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
		СписокУсловноеОформление.Элементы.Очистить();
	
		Элемент = СписокУсловноеОформление.Элементы.Добавить();
		Элемент.Представление = НСтр("ru = '<Основная кассовая книга организации>'");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("КассоваяКнига");
	
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("КассоваяКнига");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Справочники.КассовыеКниги.ПустаяСсылка();
	
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Основная кассовая книга организации>'"));
		
	КонецЦикла;
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "КассовыеКниги.Дата", Элементы.Дата.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ПриходныеКассовыеОрдера.Дата", Элементы.ДатаПКО.Имя);
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "РасходныеКассовыеОрдера.Дата", Элементы.ДатаРКО.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораКассовыхКниг()
	
	УстановитьПривилегированныйРежим(Истина);
	Справочники.КассовыеКниги.КассовыеКнигиОрганизации(Организация, Элементы.КассоваяКнигаОтбор.СписокВыбора);
	УстановитьПривилегированныйРежим(Ложь);
	
	Элементы.КассоваяКнигаОтбор.Доступность = Элементы.КассоваяКнигаОтбор.СписокВыбора.Количество();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	Для каждого ДинамическийСписок Из МассивДинамическихСписков() Цикл
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ДинамическийСписок, "КассоваяКнига", КассоваяКнига, ВидСравненияКомпоновкиДанных.Равно,, КассоваяКнига <> Неопределено);
	КонецЦикла;
	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЛистКассовойКниги.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ПриходныйКассовыйОрдер.ПустаяСсылка"));
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.РасходныйКассовыйОрдер.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		
		Ссылка = МассивСсылок[0];
		Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЛистКассовойКниги") Тогда
			Элементы.КассовыеКниги.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаКассоваяКнига;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.ПриходныйКассовыйОрдер") Тогда
			Элементы.ПриходныеКассовыеОрдера.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПриходныеОрдера;
		ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			Элементы.РасходныеКассовыеОрдера.ТекущаяСтрока = Ссылка;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаРасходныеОрдера;
		КонецЕсли;
		
		ПоказатьЗначение(Неопределено, Ссылка);
		
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция МассивДинамическихСписков()

	МассивСписков = Новый Массив;
	МассивСписков.Добавить(КассовыеКниги);
	МассивСписков.Добавить(ПриходныеКассовыеОрдера);
	МассивСписков.Добавить(РасходныеКассовыеОрдера);
	
	Возврат МассивСписков;

КонецФункции

&НаКлиенте
Процедура ОбновитьДиначескиеСписки()
	
	Элементы.КассовыеКниги.Обновить();
	Элементы.ПриходныеКассовыеОрдера.Обновить();
	Элементы.РасходныеКассовыеОрдера.Обновить();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
