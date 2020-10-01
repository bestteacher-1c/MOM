
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьТекстЗапросаСписка();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом
	
	УстановитьВидимость();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ЗакрытиеЗаказов" Тогда
		Элементы.Список.Обновить();
	КонецЕсли; 
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусЗакрыт(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСсылки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К выполнению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КВыполнению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К выполнению'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечению(Команда)
	
	ВыделенныеСсылки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	
	Если ВыделенныеСсылки.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заказов будет установлен статус ""К обеспечению"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОбеспечениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСсылки", ВыделенныеСсылки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОбеспечениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСсылки = ДополнительныеПараметры.ВыделенныеСсылки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        
        Возврат;
        
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСсылки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСсылки.Количество(),
    НСтр("ru = 'К обеспечению'"));

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьТекстЗапросаСписка()
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ЗаполнитьЗначенияСвойств(СвойстваСписка, Список);
	
	Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияВнутреннихЗаказов) Тогда
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаСборку.Ссылка,
		|	ДокументЗаказНаСборку.ПометкаУдаления,
		|	ДокументЗаказНаСборку.Номер,
		|	ДокументЗаказНаСборку.Дата,
		|	ДокументЗаказНаСборку.Проведен,
		|	ДокументЗаказНаСборку.Организация,
		|	ДокументЗаказНаСборку.Склад,
		|	ДокументЗаказНаСборку.ДокументОснование,
		|	ДокументЗаказНаСборку.Ответственный,
		|	ДокументЗаказНаСборку.Статус,
		|	ДокументЗаказНаСборку.Номенклатура,
		|	ДокументЗаказНаСборку.Характеристика,
		|	ДокументЗаказНаСборку.Упаковка,
		|	ДокументЗаказНаСборку.КоличествоУпаковок,
		|	ДокументЗаказНаСборку.Количество,
		|	ДокументЗаказНаСборку.ХозяйственнаяОперация,
		|	ДокументЗаказНаСборку.Комментарий,
		|	ДокументЗаказНаСборку.НачалоСборкиРазборки,
		|	ДокументЗаказНаСборку.ОкончаниеСборкиРазборки,
		|	ДокументЗаказНаСборку.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаСборку.ДлительностьСборкиРазборки,
		|	ДокументЗаказНаСборку.МаксимальныйКодСтроки,
		|	ДокументЗаказНаСборку.ВариантКомплектации,
		|	ДокументЗаказНаСборку.Сделка,
		|	ДокументЗаказНаСборку.Подразделение,
		|	ДокументЗаказНаСборку.СтатусУказанияСерий,
		|	ДокументЗаказНаСборку.Назначение,
		|	ДокументЗаказНаСборку.НазначениеТовары,
		|	ДокументЗаказНаСборку.Серия,
		|	ДокументЗаказНаСборку.ВариантОбеспечения,
		|	ДокументЗаказНаСборку.КоличествоУпаковокОтменено,
		|	ДокументЗаказНаСборку.КоличествоОтменено,
		|	ДокументЗаказНаСборку.Товары,
		|	ДокументЗаказНаСборку.Серии,
		|	ДокументЗаказНаСборку.МоментВремени,
		|	ВЫБОР
		|		КОГДА НЕ ДокументЗаказНаСборку.Проведен
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.ПустаяСсылка)
		|		ИНАЧЕ ЕСТЬNULL(СостоянияВнутреннихЗаказов.Состояние, ЗНАЧЕНИЕ(Перечисление.СостоянияВнутреннихЗаказов.Закрыт))
		|	КОНЕЦ КАК Состояние,
		|	ЕСТЬNULL(СостоянияВнутреннихЗаказов.ЕстьРасхожденияОрдерНакладная, ЛОЖЬ) КАК ЕстьРасхожденияОрдерНакладная
		|ИЗ
		|	Документ.ЗаказНаСборку КАК ДокументЗаказНаСборку
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияВнутреннихЗаказов КАК СостоянияВнутреннихЗаказов
		|		ПО (СостоянияВнутреннихЗаказов.Заказ = ДокументЗаказНаСборку.Ссылка)";
		
	Иначе
		
		СвойстваСписка.ТекстЗапроса =
		"ВЫБРАТЬ
		|	ДокументЗаказНаСборку.Ссылка,
		|	ДокументЗаказНаСборку.ПометкаУдаления,
		|	ДокументЗаказНаСборку.Номер,
		|	ДокументЗаказНаСборку.Дата,
		|	ДокументЗаказНаСборку.Проведен,
		|	ДокументЗаказНаСборку.Организация,
		|	ДокументЗаказНаСборку.Склад,
		|	ДокументЗаказНаСборку.ДокументОснование,
		|	ДокументЗаказНаСборку.Ответственный,
		|	ДокументЗаказНаСборку.Статус,
		|	ДокументЗаказНаСборку.Номенклатура,
		|	ДокументЗаказНаСборку.Характеристика,
		|	ДокументЗаказНаСборку.Упаковка,
		|	ДокументЗаказНаСборку.КоличествоУпаковок,
		|	ДокументЗаказНаСборку.Количество,
		|	ДокументЗаказНаСборку.ХозяйственнаяОперация,
		|	ДокументЗаказНаСборку.Комментарий,
		|	ДокументЗаказНаСборку.НачалоСборкиРазборки,
		|	ДокументЗаказНаСборку.ОкончаниеСборкиРазборки,
		|	ДокументЗаказНаСборку.ЖелаемаяДатаПоступления,
		|	ДокументЗаказНаСборку.ДлительностьСборкиРазборки,
		|	ДокументЗаказНаСборку.МаксимальныйКодСтроки,
		|	ДокументЗаказНаСборку.ВариантКомплектации,
		|	ДокументЗаказНаСборку.Сделка,
		|	ДокументЗаказНаСборку.Подразделение,
		|	ДокументЗаказНаСборку.СтатусУказанияСерий,
		|	ДокументЗаказНаСборку.Назначение,
		|	ДокументЗаказНаСборку.НазначениеТовары,
		|	ДокументЗаказНаСборку.Серия,
		|	ДокументЗаказНаСборку.ВариантОбеспечения,
		|	ДокументЗаказНаСборку.КоличествоУпаковокОтменено,
		|	ДокументЗаказНаСборку.КоличествоОтменено,
		|	ДокументЗаказНаСборку.Товары,
		|	ДокументЗаказНаСборку.Серии,
		|	ДокументЗаказНаСборку.МоментВремени
		|ИЗ
		|	Документ.ЗаказНаСборку КАК ДокументЗаказНаСборку";
		
	КонецЕсли;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	ПравоДоступаДобавление = Документы.ЗаказНаСборку.ПравоДоступаДобавление();
	ПланированиеСборкиРазборки = ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеСборкиРазборки");
	РасширенноеОбеспечениеПотребностей = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей");
	
	Элементы.ФормаСписокГруппа.Видимость = ПравоДоступаДобавление
		И (ПланированиеСборкиРазборки Или РасширенноеОбеспечениеПотребностей);
	Если Элементы.ФормаСписокГруппа.Видимость Тогда
		Элементы.ФормаСписокСоздать.Видимость = Ложь;
	КонецЕсли;
	
	ИспользоватьСтатусы = ПравоДоступа("Изменение", Метаданные.Документы.ЗаказНаСборку);
	Элементы.ГруппаУстановитьСтатус.Видимость = ИспользоватьСтатусы;
	
	Если ИспользоватьСтатусы Тогда
		ИспользоватьСтатусЗакрыт = ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыНаСборкуБезПолнойОтгрузки");
		Элементы.УстановитьСтатусЗакрыт.Видимость = ИспользоватьСтатусЗакрыт;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаСборку.ФормаСписка.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
