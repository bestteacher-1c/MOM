
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
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПереоценкаОС2_4", ПараметрыЗаписи, Объект.Ссылка);
	ОповеститьОбИзменении(Тип("СправочникСсылка.ОбъектыЭксплуатации"));
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование)
		И ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		Оповестить("ЗаписьДокументаНаОснованииИнвентаризации",, Объект.Ссылка);
	КонецЕсли;
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьИнформациюОДокументеВДругомУчете();
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПереоценкаОС2_4" Тогда
		ЗаполнитьИнформациюОДокументеВДругомУчете();
	КонецЕсли;
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантОтраженияВУчетеПриИзменении(Элемент)
	
	Объект.ОтражатьВУпрУчете = 
		(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете")
			ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
			
	Объект.ОтражатьВРеглУчете = 
		(ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете")
			ИЛИ ВариантОтраженияВУчете = ПредопределенноеЗначение("Перечисление.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах"));
			
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ОтражатьВУпрУчете,ОтражатьВРеглУчете");
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументНаОснованииПриИзменении(Элемент)
	
	Если Объект.ДокументНаОсновании Тогда
		
		ОтборСписка = Новый Структура;
		ОтборСписка.Вставить("Проведен", Истина);
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ОтборСписка.Вставить("Организация", Объект.Организация);
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Отбор", ОтборСписка);
		ОписаниеОповещения = Новый ОписаниеОповещения("ДокументНаОснованииПриИзмененииЗавершение", ЭтотОбъект);
		ОткрытьФорму("Документ.ИнвентаризацияОС.ФормаВыбора", ПараметрыФормы,,,,, ОписаниеОповещения);
		
	Иначе
		Объект.ДокументОснование = Неопределено;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	СтатьяДоходовРасходовПриИзмененииСервер("СтатьяРасходов");
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	СтатьяДоходовРасходовПриИзмененииСервер("СтатьяДоходов");
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОДокументеВДругомУчетеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "#СоздатьДокумент" Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
		ОткрытьФорму("Документ.ПереоценкаОС2_4.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОС

&НаКлиенте
Процедура ОСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВнеоборотныеАктивыКлиентСервер.ОбработкаВыбораЭлемента(Объект.ОС, "ОсновноеСредство", ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыПодбора = ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора(Элементы.ОСОсновноеСредство, ЭтаФорма);
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", 
					ПараметрыПодбора, 
					Элементы.ОС,,,,, 
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#Область УниверсальныеМеханизмы_Команды

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

#Область СтандартныеПодсистемы_Команды

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ИнициализацияФормыПриСозданииНаСервере();
	
	ЗаполнитьВариантОтраженияВУчете();
	
	ЗаполнитьИнформациюОДокументеВДругомУчете();
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормыПриСозданииНаСервере()

	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютыСовпадают = (ВалютаУпр = ВалютаРегл);
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Если ВедетсяРегламентированныйУчетВНА Тогда
		
		Элементы.ОССтоимостьУУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма упр. (%1)'"), Строка(ВалютаУпр));
		Элементы.ОССтоимостьБУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма регл. (%1)'"), Строка(ВалютаРегл));
		
	Иначе
		
		Если ВалютыСовпадают Тогда
			Элементы.ОССтоимостьУУ.Заголовок = НСтр("ru = 'Сумма'");
			Элементы.ОССтоимостьБУ.Заголовок = НСтр("ru = 'Сумма'");
		Иначе
			Элементы.ОССтоимостьУУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма (%1)'"), Строка(ВалютаУпр));
			Элементы.ОССтоимостьБУ.Заголовок = СтрШаблон(НСтр("ru = 'Сумма (%1)'"), Строка(ВалютаРегл));
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура СтатьяДоходовРасходовПриИзмененииСервер(ИмяСтатьи)
	
	Если ИмяСтатьи = "СтатьяДоходов" Тогда
			
		АналитикаРасходовОбязательна =
			ЗначениеЗаполнено(Объект.СтатьяДоходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
		ДоходыИРасходыСервер.СтатьяДоходовПриИзменении(Объект, Объект.СтатьяДоходов, Объект.Подразделение, Объект.АналитикаДоходов);
		
	КонецЕсли;
	
	Если ИмяСтатьи = "СтатьяРасходов" Тогда
		
		АналитикаРасходовОбязательна =
			ЗначениеЗаполнено(Объект.СтатьяРасходов)
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, Объект.СтатьяРасходов, Объект.АналитикаРасходов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, Знач ИзмененныеРеквизиты = "")

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = (СтруктураИзмененныхРеквизитов.Количество() = 0);
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", Форма.ВедетсяРегламентированныйУчетВНА);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", Форма.ВалютыСовпадают);
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПереоценкаОС(
										Объект, ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
	
	ВнеоборотныеАктивыКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОДокументеВДругомУчете()

	ВнеоборотныеАктивыСлужебный.ЗаполнитьИнформациюОДокументеВДругомУчете(Объект, Элементы);

КонецПроцедуры

&НаКлиенте
Процедура ДокументНаОснованииПриИзмененииЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.ДокументОснование = РезультатЗакрытия;
	Иначе
		Объект.ДокументНаОсновании = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ТекстВопроса = НСтр("ru = 'Заполнить документ по инвентаризации?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоДаннымОснованияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымОснованияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоДаннымОснованияНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымОснованияНаСервере()

	Объект.ОС.Очистить();
	
	ПереоценкаОСЛокализация.ЗаполнитьНаОснованииИнвентаризацииОС(Объект, Истина);

	ЗаполнитьВариантОтраженияВУчете();
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Организация,ОтражатьВУпрУчете,ОтражатьВРеглУчете");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВариантОтраженияВУчете()
	
	Если Объект.ОтражатьВУпрУчете И Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомИРегламентированномУчетах;
	ИначеЕсли Объект.ОтражатьВУпрУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.УправленческомУчете;
	ИначеЕсли Объект.ОтражатьВРеглУчете Тогда
		ВариантОтраженияВУчете = Перечисления.ВариантыОтраженияВУчетеВнеоборотныхАктивов.РегламентированномУчете;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти