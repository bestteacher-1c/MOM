
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ИспользуетсяНесколькоКасс = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	ИспользуетсяНесколькоКассККМ = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ");
	
	Элементы.ГруппаВводОстатковПо.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	
	УстановитьЗаголовок();
	
	Если НЕ (ИспользуетсяНесколькоКасс ИЛИ ИспользуетсяНесколькоКассККМ ИЛИ ВозможностьОткрытияДокументаОтУстановленныхФО()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользуетсяНесколькоКасс Тогда
		ЕдинственнаяКасса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию();
		ВалютаКассы = ЕдинственнаяКасса.ВалютаДенежныхСредств;
		Если Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВКассах Тогда
			Если Объект.Кассы.Количество() > 0 Тогда
				ОстатокВКассе = Объект.Кассы[0].Сумма;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ИспользуетсяНесколькоКассККМ Тогда
		ЕдинственнаяКассаККМ = Справочники.КассыККМ.КассаККМПоУмолчанию();
		ВалютаКассыККМ = ЕдинственнаяКассаККМ.ВалютаДенежныхСредств;
		Если Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах
			ИЛИ Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке Тогда
			Если Объект.КассыККМ.Количество() > 0 Тогда
				ОстатокВКассе = Объект.КассыККМ[0].Сумма;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	УстановитьВидимость();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ИспользуетсяНесколькоКасс 
		И Объект.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиВКассах") Тогда
		Если НЕ ЗначениеЗаполнено(ЕдинственнаяКасса) Тогда
			ПодробноеПредставлениеОшибки =
				НСтр("ru = 'В информационной базе используется одна касса,
				|но ее свойства не настроены в разделе ""Нормативно-справочная информация"" - ""Настройки и справочники"" - ""Настройка кассы"".'")
			;
			Отказ = Истина;
			ВызватьИсключение ПодробноеПредставлениеОшибки;
		КонецЕсли;
		Объект.Кассы.Очистить();
		НоваяСтрока = Объект.Кассы.Добавить();
		НоваяСтрока.Касса = ЕдинственнаяКасса;
		НоваяСтрока.Сумма = ОстатокВКассе;
		КассыСуммаПриИзмененииСервер(
			НоваяСтрока.Сумма,
			НоваяСтрока.СуммаРегл,
			НоваяСтрока.СуммаУпр,
			НоваяСтрока.Касса);
	КонецЕсли;
		
	Если Не ИспользуетсяНесколькоКассККМ 
		И (Объект.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах")
		    ИЛИ Объект.ТипОперации = ПредопределенноеЗначение("Перечисление.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке")) Тогда
		Если НЕ ЗначениеЗаполнено(ЕдинственнаяКассаККМ) Тогда
			ПодробноеПредставлениеОшибки =
				НСтр("ru = 'В информационной базе используется одна касса ККМ,
				|но ее свойства не настроены в разделе ""Нормативно-справочная информация"" - ""Настройки и справочники"" - ""Настройка кассы ККМ"".'")
			;
			Отказ = Истина;
			ВызватьИсключение ПодробноеПредставлениеОшибки;
		КонецЕсли;
		Объект.КассыККМ.Очистить();
		НоваяСтрока = Объект.КассыККМ.Добавить();
		НоваяСтрока.КассаККМ = ЕдинственнаяКассаККМ;
		НоваяСтрока.Сумма = ОстатокВКассе;
		КассыСуммаПриИзмененииСервер(
			НоваяСтрока.Сумма,
			НоваяСтрока.СуммаРегл,
			НоваяСтрока.СуммаУпр,
			,
			НоваяСтрока.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовок();
	
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
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	
	УстановитьВидимость()
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	
	УстановитьВидимость()
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	
	УстановитьВидимость()
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКассы

&НаКлиенте
Процедура КассыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И НЕ ИспользуетсяНесколькоКасс Тогда
	
		Элемент.ТекущиеДанные.Касса = ЕдинственнаяКасса;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КассыКассаПриИзменении(Элемент)
	
	СтрокаКассаПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура КассыСуммаПриИзменении(Элемент)
	
	СтрокаКассаПриИзменении();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКассыККМ

&НаКлиенте
Процедура КассыККМКассаККМПриИзменении(Элемент)

	СтрокаКассаККМПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура КассыККМСуммаПриИзменении(Элемент)

	СтрокаКассаККМПриИзменении();
	
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

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	//++ НЕ УТ
	Если Объект.Кассы.Количество() Тогда
		ОповещениеВопросЗаполнитьПоОстаткам = Новый ОписаниеОповещения("ОбработчикОповещенияВопросЗаполнитьПоОстаткам", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'При заполнении текущие данные табличной части будут очищены. Продолжить?'");
		ПоказатьВопрос(ОповещениеВопросЗаполнитьПоОстаткам, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,  НСтр("ru = 'Ввод остатков регл. учета по данным оперативного'"));
	Иначе
		ЗаполнитьПоОстаткамНаСервере();
	КонецЕсли;
	//-- НЕ УТ
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ТипОперации);

КонецПроцедуры

&НаКлиенте
Процедура СтрокаКассаПриИзменении()
	
	СтрокаТаблЧасти = Элементы.Кассы.ТекущиеДанные;
	КассыСуммаПриИзмененииСервер(
		СтрокаТаблЧасти.Сумма,
		СтрокаТаблЧасти.СуммаРегл,
		СтрокаТаблЧасти.СуммаУпр,
		СтрокаТаблЧасти.Касса);
КонецПроцедуры

&НаКлиенте
Процедура СтрокаКассаККМПриИзменении()
	
	СтрокаТаблЧасти = Элементы.КассыККМ.ТекущиеДанные;
	КассыСуммаПриИзмененииСервер(
		СтрокаТаблЧасти.Сумма,
		СтрокаТаблЧасти.СуммаРегл,
		СтрокаТаблЧасти.СуммаУпр,
		,
		СтрокаТаблЧасти.КассаККМ);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаОднаКасса.Видимость = 
		(НЕ ИспользуетсяНесколькоКасс И Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВКассах)
		ИЛИ
		НЕ ИспользуетсяНесколькоКассККМ И (
			Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах
			ИЛИ Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке);

	Элементы.ГруппаКассы.Видимость = Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВКассах
																	И ИспользуетсяНесколькоКасс;
	Элементы.ГруппаКассыККМ.Видимость 	= 
		(Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах
		Или Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке)
		И ИспользуетсяНесколькоКассККМ;
		
	Элементы.КассыЗаполнитьПоОстаткам.Видимость = НЕ Объект.ОтражатьВОперативномУчете И (Объект.ОтражатьВБУиНУ ИЛИ Объект.ОтражатьВУУ);
	Элементы.КассыСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.КассыСуммаУпр.Видимость =  Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	
КонецПроцедуры

&НаСервере
Процедура КассыСуммаПриИзмененииСервер(Сумма, СуммаРегл, СуммаУпр, Касса = Неопределено, КассаККМ = Неопределено)
	
	ИмяОперации = Объект.ТипОперации;
	ДатаДокумента = Объект.Дата;
	
	Если ИмяОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВКассах Тогда
		Валюта = Справочники.Кассы.ПолучитьРеквизитыКассы(Касса).Валюта;
	ИначеЕсли ИмяОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах
			  ИЛИ ИмяОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке Тогда	
		Валюта = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ).Валюта;
	КонецЕсли;
	Если Валюта = ВалютаРегламентированногоУчета Тогда
		СуммаРегл = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаРегламентированногоУчета, ДатаДокумента);
		СуммаРегл = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	Если Валюта = ВалютаУправленческогоУчета Тогда
		СуммаУпр = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаУправленческогоУчета, ДатаДокумента);
		СуммаУпр = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ВозможностьОткрытияДокументаОтУстановленныхФО()
	
	Результат = Истина;
	
	Если Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВКассах Тогда
		
		Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию();
		Если Не ЗначениеЗаполнено(Касса) Тогда
			
			Запрос = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
			|	Кассы.Ссылка
			|ИЗ
			|	Справочник.Кассы КАК Кассы
			|ГДЕ
			|	НЕ Кассы.ПометкаУдаления");
			
			Если Запрос.Выполнить().Выбрать().Количество() = 2 Тогда
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Касса"". В информационной базе введено несколько касс,
				|Включите функциональную опцию ""Использовать несколько касс""!'");
			Иначе
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Касса"". Возможно, в информационной базе не введено ни одной кассы!'");
			КонецЕсли;
			Результат = Ложь;
			
		КонецЕсли;
		
	ИначеЕсли НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ")
		И (Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМКОформлениюОтчетовОРозничныхПродажах
		ИЛИ Объект.ТипОперации = Перечисления.ТипыОперацийВводаОстатков.ОстаткиВАвтономныхКассахККМПоРозничнойВыручке) Тогда
		
		Если НЕ ЗначениеЗаполнено(Справочники.КассыККМ.КассаККМПоУмолчанию()) Тогда
			
			Запрос = Новый Запрос("
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
			|	КассыККМ.Ссылка КАК КассаККМ
			|ИЗ
			|	Справочник.КассыККМ КАК КассыККМ
			|ГДЕ
			|	НЕ КассыККМ.ПометкаУдаления
			|");
			
			Если Запрос.Выполнить().Выбрать().Количество() = 2 Тогда
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Касса ККМ"". В информационной базе введено несколько касс ККМ,
				|Включите функциональную опцию ""Использовать несколько касс ККМ""!'");
			Иначе
				ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Касса ККМ"". Возможно, в информационной базе не введено ни одной кассы ККМ!'");
			КонецЕсли;
			Результат = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//++ НЕ УТ
&НаСервере
Процедура ЗаполнитьПоОстаткамНаСервере()
	
	ТабЧасть = РеквизитФормыВЗначение("Объект.Кассы");
	ТабЧасть.Очистить();
	КлючевыеПоля = Документы.ВводОстатков.КлючевыеПоляРеглУчетаПоТипуОперации(Объект.ТипОперации);
	Отбор = Новый Структура;
	Для каждого КлючевоеПоле Из КлючевыеПоля Цикл
		Если Не КлючевоеПоле = "Организация" И ЗначениеЗаполнено(Объект[КлючевоеПоле]) Тогда
			Отбор.Вставить(КлючевоеПоле, Объект[КлючевоеПоле]);
		КонецЕсли;
	КонецЦикла;
	
	Остатки = Документы.ВводОстатков.ОстаткиПоТипуОперации(Объект.Дата, Объект.ТипОперации, Объект.Организация, Отбор);
	
	Выборка = Остатки.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Стр = ТабЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(Стр, Выборка);
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещенияВопросЗаполнитьПоОстаткам(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПоОстаткамНаСервере();		
	КонецЕсли;
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти
