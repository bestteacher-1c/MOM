
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ТекстОшибкиКонтроляКодовМаркировки) Тогда
		Заголовок = НСтр("ru = 'Контроль кодов маркировок'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки;
		
		Элементы.ТекстОшибкиКонтроляКодовМаркировки.Заголовок = Параметры.ТекстОшибкиКонтроляКодовМаркировки;
	Иначе
		Заголовок = НСтр("ru = 'Сканирование кода маркировки'");
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки;
	КонецЕсли;
	
	Номенклатура              = Параметры.Номенклатура;
	Характеристика            = Параметры.Характеристика;
	СоздаватьШтрихкодУпаковки = Параметры.СоздаватьШтрихкодУпаковки;
	ДанныеШтрихкода           = Параметры.ДанныеШтрихкода;
	ПараметрыСканирования     = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыСканирования, Ложь);
	Документ                  = Параметры.Документ;
	Серия                     = Параметры.Серия;

	ЭтоТестовыйПериод = ИнтеграцияИСМП.ЭтоТестовыйПериод(Перечисления.ВидыПродукцииИС.Табак);
	СерииИспользуются = ИнтеграцияИС.СерииИспользуются();
	
	ДобавлятьБезКодаМаркировки = Не ПараметрыСканирования.ТолькоМаркируемаяПродукция
		И Параметры.РазрешатьДобавлениеБезКодаМарки
		И ЭтоТестовыйПериод;
	
	Элементы.ДобавитьБезКодаМаркировки.Видимость = ДобавлятьБезКодаМаркировки;
	Элементы.ДекорацияПодсказка.Видимость        = ДобавлятьБезКодаМаркировки;
	
	Элементы.РаспечататьНовыйКодМаркировки.Видимость = ПараметрыСканирования.ДоступнаПечатьЭтикеток;
	ДопустимыйСпособВводаВОборот = ПараметрыСканирования.ДопустимыйСпособВводаВОборот;
	Организация                  = ПараметрыСканирования.Организация;
	
	Если Не ЗначениеЗаполнено(Документ) Тогда
		Документ = ПараметрыСканирования.СсылкаНаОбъект;
	КонецЕсли;
	
	ШтрихкодированиеИСПереопределяемый.ПриОпределенииСочетанияКлавишДобавитьБезМаркировкиВФормеСканирования(
		Команды.ДобавитьБезКодаМаркировки.СочетаниеКлавиш);
	
	НазначитьЗаголовокКомандыДобавитьБезМаркировкиСервер();
	СброситьРазмерыИПоложениеОкна();
	
	Если ЭтоАдресВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции) Тогда
		ДанныеКэша = ПолучитьИзВременногоХранилища(ПараметрыСканирования.КэшМаркируемойПродукции);
		КэшМаркируемойПродукции = ПоместитьВоВременноеХранилище(ДанныеКэша, УникальныйИдентификатор);
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	// Конец ПодключаемоеОборудование
	
	СобытияФормИСМПКлиент.ОпределитьИспользованиеХарактеристик(
		ЭтотОбъект,
		ЭтотОбъект,
		"Номенклатура", "ХарактеристикиИспользуются");
	
	ОбновитьПредставленияНоменклатуры();
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки Тогда
		ЭтотОбъект.ТекущийЭлемент = Элементы.СтраницаСканированиеКодаМаркировки;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Документ)
		И ВладелецФормы <> Неопределено
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ВладелецФормы, "Объект")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ВладелецФормы.Объект, "Ссылка") Тогда
		Документ = ВладелецФормы.Объект.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрольКодовМаркировки Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСканирования = ПараметрыСканирования();
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		ОповещениеПриЗавершении, ЭтотОбъект, Источник, Событие, Данные, ПараметрыСканирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВвестиКодМаркировки(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект));
		
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьБезМаркировки(Команда)
	
	ОбработатьБезВводаМарки = Истина;
	
	Комментарий = Нстр("ru='Отказ ввода кода маркировки по инициативе пользователя'");
	ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(Комментарий);
		
	ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(ВладелецФормы);
	ДанныеШтрихкодаБезМаркировки = ДанныеШтрихкода(ПараметрыСканирования);
	ДанныеШтрихкодаБезМаркировки.Номенклатура              = Номенклатура;
	ДанныеШтрихкодаБезМаркировки.Характеристика            = Характеристика;
	ДанныеШтрихкодаБезМаркировки.КоличествоПачек           = 1;
	ДанныеШтрихкодаБезМаркировки.ТипУпаковки               = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар");
	ДанныеШтрихкодаБезМаркировки.ОбработатьБезМаркировки   = Истина;
	ВидПродукции                                           = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак");
	ДанныеШтрихкодаБезМаркировки.ВидПродукции              = ВидПродукции;
	ДанныеШтрихкодаБезМаркировки.ВидыПродукцииКодаМаркировки.Добавить(ВидПродукции);
	ДанныеШтрихкодаБезМаркировки.Штрихкод                  = ДанныеШтрихкода.Штрихкод;
	
	ПоискПоШтрихкодуЗавершение(ДанныеШтрихкодаБезМаркировки, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОбработатьБезВводаМарки = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РаспечататьНовыйКодМаркировки(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьНовыйКодМаркировкиИВывестиНаПечать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыСканирования()
	
	Если ПараметрыСканирования = Неопределено Тогда
		ПараметрыСканирования = ШтрихкодированиеИСКлиент.ПараметрыСканирования(ВладелецФормы);
	КонецЕсли;
	
	ПараметрыСканирования.РазрешеноЗапрашиватьКодМаркировки = Ложь;
	ПараметрыСканирования.КэшМаркируемойПродукции           = КэшМаркируемойПродукции;
	ПараметрыСканирования.СопоставлятьНоменклатуру          = Ложь;
	ПараметрыСканирования.ВыводитьСообщенияОбОшибках        = Ложь;
	
	ДопустимыеВидыПродукции = Новый Массив;
	ДопустимыеВидыПродукции.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак"));
	ПараметрыСканирования.ДопустимыеВидыПродукции = ДопустимыеВидыПродукции;
	ДанныеУточнения = Новый Структура("Номенклатура, Характеристика, Серия", Номенклатура, Характеристика, Серия);
	ПараметрыСканирования.ДополнительныеПараметры.Вставить("ДанныеУточнения", ДанныеУточнения);
	
	Возврат ПараметрыСканирования;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидПродукцииИС()
	
	Возврат ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак");
	
КонецФункции

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.ТипУпаковки = ПредопределенноеЗначение("Перечисление.ТипыУпаковок.МаркированныйТовар")
		Или ДанныеШтрихкода.ВидУпаковки = ПредопределенноеЗначение("Перечисление.ВидыУпаковокИС.Групповая")
		Или ОбработатьБезВводаМарки Тогда
		
		ОбработатьШтрихкодКодаМаркировки(ДанныеШтрихкода, ДополнительныеПараметры);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Штрихкод не соответствует формату кода маркировки табачной продукции'");
		
		ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения);
		
		ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(ТекстСообщения, ДанныеШтрихкода.Штрихкод);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодКодаМаркировки(ДанныеШтрихкода, ДополнительныеПараметры)
	
	
	Если ЗначениеЗаполнено(ДанныеШтрихкода.Номенклатура)
		И ДанныеШтрихкода.Номенклатура <> Номенклатура Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Код маркировки не соответствует номенклатуре %1'"), Номенклатура);
			
			
			ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения);
			ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(ТекстСообщения, ДанныеШтрихкода.Штрихкод);
			
		Возврат;
	КонецЕсли;
	
	Если ПараметрыСканирования.ДополнительныеПараметры.Свойство("ДанныеУточнения")
		И ПараметрыСканирования.ДополнительныеПараметры.ДанныеУточнения.Свойство("ШаблонЭтикетки") Тогда
		ДанныеШтрихкода.ТребуетсяВыборСерии = Ложь;
	КонецЕсли;
	АдресРезультатаОбработкиШтрихкода = ПоместитьВоВременноеХранилище(ДанныеШтрихкода, УникальныйИдентификатор);
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСканированиеКодаМаркировки Тогда
		
		ПодключитьОбработчикОжидания("ЗакрытьФормуПриСканировании", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуПриСканировании()
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультатаОбработкиШтрихкода);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканирования = ПараметрыСканирования();
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ДополнительныеПараметры.Свойство("ОтключитьКонтрольСтатусов") Тогда
			ПараметрыСканирования.ЗапрашиватьСтатусыМОТП = Ложь;
			ПараметрыСканирования.ЗапрашиватьДанныеНеизвестныхУпаковокМОТП = Ложь;
		КонецЕсли;
		Если ДополнительныеПараметры.Свойство("ДанныеУточнения") Тогда
			ПараметрыСканирования.ДополнительныеПараметры.Вставить("ДанныеУточнения", ДополнительныеПараметры.ДанныеУточнения);
		КонецЕсли;
	КонецЕсли;
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("ПоискПоШтрихкодуЗавершение", ЭтотОбъект);
	
	ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(
		ОповещениеПриЗавершении, ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаСервере
Процедура ВывестиСообщениеНаСтраницеВводаКодаМаркировки(ТекстСообщения)
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	ДобавитьЭлементДекорацияНаФорму();
	Элементы[ИмяЭлемента].Заголовок = ТекстСообщения;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьЭлементДекорацияНаФорму()
	
	ИмяЭлемента = "ИнформацияВводаКодаМаркировки";
	
	Если Элементы.Найти(ИмяЭлемента) = Неопределено Тогда
		Элементы.Добавить(ИмяЭлемента, Тип("ДекорацияФормы"), Элементы.ГруппаИнформация);
		Элементы[ИмяЭлемента].ЦветТекста = ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС;
	КонецЕсли;
	
КонецПроцедуры

#Область Печать

&НаКлиенте
Процедура РаспечататьНовыйКодЗавершение(ДанныеОтветаРезервированияИПечати, ДополнительныеПараметры) Экспорт
	
	Если ДанныеОтветаРезервированияИПечати = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Количество() Тогда
		СтрокаРезультата = ДанныеОтветаРезервированияИПечати.РезультатРезервирования.Получить(0);
		
		Если ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ЗапомнитьВыбор Тогда
			ВладелецФормы.СохраненВыборПоМаркируемойПродукции = Истина;
			ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции = ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ДанныеВыбора;
			ШтрихкодированиеИСКлиентСервер.ОтобразитьСохраненныйВыборПоМаркируемойПродукции(ВладелецФормы);
		КонецЕсли;
		
		СтруктураДополнительныхПараметров = Новый Структура();
		СтруктураДополнительныхПараметров.Вставить("ОтключитьКонтрольСтатусов", Истина);
		СтруктураДополнительныхПараметров.Вставить("КонтролироватьВладельца",   Ложь);
		СтруктураДополнительныхПараметров.Вставить("ДанныеУточнения", ДанныеОтветаРезервированияИПечати.СохраняемыеНастройки.ДанныеВыбора);
		
		ДанныеШтрихкода = Новый Структура("Штрихкод, Количество", СтрокаРезультата.КодМаркировки, 1);
		РучнойВводШтрихкодаЗавершение(ДанныеШтрихкода, СтруктураДополнительныхПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Функция ДанныеШтрихкода(ПараметрыСканирования)
	
	ДанныеШтрихкода = ШтрихкодированиеИС.ИнициализироватьДанныеШтрихкода(ПараметрыСканирования);
	
	Возврат ДанныеШтрихкода;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьПредставленияНоменклатуры()
	
	ПараметрыПредставленияНоменклатуры = ИнтеграцияИСКлиентСервер.ПараметрыПредставленияНоменклатуры();
	ПараметрыПредставленияНоменклатуры.Номенклатура               = Номенклатура;
	ПараметрыПредставленияНоменклатуры.Характеристика             = Характеристика;
	ПараметрыПредставленияНоменклатуры.ХарактеристикиИспользуются = ХарактеристикиИспользуются;
	ПараметрыПредставленияНоменклатуры.Серия                      = Серия;
	ПараметрыПредставленияНоменклатуры.СерииИспользуются          = СерииИспользуются И ЗначениеЗаполнено(Серия);
	ПараметрыПредставленияНоменклатуры.ТолькоПросмотр             = Истина;
	
	Представление = ИнтеграцияИСКлиентСервер.ПредставлениеНоменклатурыФорматированнойСтрокой(ПараметрыПредставленияНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСообщениеДляЖурналаРегистрацииОНевозможностиВводаКодаМарки(Комментарий, КодМаркировки="")
	
	СтруктураСообщения = Новый Структура;
	
	СтруктураСообщения.Вставить("ИмяСобытия",     НСтр("ru='Отказ от сканирования кода маркировки'"));
	СтруктураСообщения.Вставить("Уровень",        "Информация");
	СтруктураСообщения.Вставить("Комментарий",    Комментарий);
	СтруктураСообщения.Вставить("Данные",         Неопределено);
	СтруктураСообщения.Вставить("СсылкаНаОбъект", Неопределено);
	СтруктураСообщения.Вставить("КодМаркировки",  КодМаркировки);
	
	ШтрихкодированиеИСКлиентПереопределяемый.ПриОпределенииИнформацииОбОтказеВводаКодаМаркиДляЖурналаРегистрации(
		ВладелецФормы, СтруктураСообщения);
	
	ДобавитьСообщениеДляЖурналаРегистрации(СтруктураСообщения);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДобавитьСообщениеДляЖурналаРегистрации(СтруктураСообщения)
	
	Если СтруктураСообщения.СсылкаНаОбъект <> Неопределено Тогда
		МетаданныеОбъекта = СтруктураСообщения.СсылкаНаОбъект.Метаданные();
	КонецЕсли;
	
	УровеньЖурнала = Неопределено;
	Если СтруктураСообщения.Уровень = "Информация" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Информация;
	ИначеЕсли СтруктураСообщения.Уровень = "Ошибка" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Ошибка;
	ИначеЕсли СтруктураСообщения.Уровень = "Предупреждение" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Предупреждение;
	ИначеЕсли СтруктураСообщения.Уровень = "Примечание" Тогда
		УровеньЖурнала = УровеньЖурналаРегистрации.Примечание;
	КонецЕсли;
	
	ЖурналРегистрации.ДобавитьСообщениеДляЖурналаРегистрации(
		СтруктураСообщения.ИмяСобытия, УровеньЖурнала, МетаданныеОбъекта, СтруктураСообщения.Данные, СтруктураСообщения.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура НазначитьЗаголовокКомандыДобавитьБезМаркировкиСервер()
	
	Клавиши = ЭтотОбъект.Команды.ДобавитьБезКодаМаркировки.СочетаниеКлавиш;
	ПредставлениеСочетанияКлавиш = "(";
	Если Клавиши.Ctrl Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Ctrl+";
	КонецЕсли;
	
	Если Клавиши.Alt Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Alt+";
	КонецЕсли;
	
	Если Клавиши.Shift Тогда
		ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + "Shift+";
	КонецЕсли;
	
	ПредставлениеСочетанияКлавиш = ПредставлениеСочетанияКлавиш + Клавиши.Клавиша + ")";
	
	Элементы.ДобавитьБезКодаМаркировки.Заголовок = Элементы.ДобавитьБезКодаМаркировки.Заголовок + " " + ПредставлениеСочетанияКлавиш;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ФормаВводаКодаМаркировки", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйКодМаркировкиИВывестиНаПечать()
	
	СтруктураПечатиЭтикетки                    = ПечатьЭтикетокИСМПКлиентСервер.СтруктураПечатиЭтикетки();
	СтруктураПечатиЭтикетки.Организация        = Организация;
	СтруктураПечатиЭтикетки.ВидПродукции       = ВидПродукцииИС();
	СтруктураПечатиЭтикетки.Номенклатура       = Номенклатура;
	СтруктураПечатиЭтикетки.Характеристика     = Характеристика;
	СтруктураПечатиЭтикетки.Серия              = Серия;
	СтруктураПечатиЭтикетки.СпособВводаВОборот = ДопустимыйСпособВводаВОборот;
	
	ОписаниеОповещенияРаспечататьНовыйКодЗавершение = Новый ОписаниеОповещения(
		"РаспечататьНовыйКодЗавершение", ЭтотОбъект);
	
	СтруктураПараметров = ПечатьЭтикетокИСМПКлиент.СтруктураПараметровПечатиНовогоКодаМаркировки(
		СтруктураПечатиЭтикетки, ЭтотОбъект, ОписаниеОповещенияРаспечататьНовыйКодЗавершение);

	Если ВладелецФормы.СохраненВыборПоМаркируемойПродукции Тогда
		ДанныеВыбора = ВладелецФормы.ДанныеВыбораПоМаркируемойПродукции;
		СтруктураПараметров.Шаблон         = ДанныеВыбора.ШаблонМаркировки;
		СтруктураПараметров.СразуНаПринтер = ДанныеВыбора.СразуНаПринтер;
		СтруктураПараметров.ШаблонЭтикетки = ДанныеВыбора.ШаблонЭтикетки;
	КонецЕсли;

	СтруктураПараметров.ПараметрыСканирования = ПараметрыСканирования;
	СтруктураПараметров.Организация    = Организация;
	СтруктураПараметров.ВидПродукции   = ВидПродукцииИС();
	СтруктураПараметров.Документ       = Документ;
	СтруктураПараметров.Номенклатура   = Номенклатура;
	СтруктураПараметров.Характеристика = Характеристика;
	СтруктураПараметров.Серия          = Серия;
	ПечатьЭтикетокИСМПКлиент.РаспечататьНовыйКодМаркировки(Истина, СтруктураПараметров);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОткрытьФормуУточненияДанных()
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("РучнойВводШтрихкодаЗавершение", ЭтотОбъект);
	ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(ЭтотОбъект, ОповещениеПриЗавершении);
	
КонецПроцедуры

#КонецОбласти