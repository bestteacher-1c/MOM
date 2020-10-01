
#Область ПрограммныйИнтерфейс

// Процедура возвращает надпись "Валюты" для формы документа.
//
// Параметры:
//	ПараметрыДокумента - Структура - Структура параметров вызывающей формы, конструктор ВзаиморасчетыКлиентСервер.ПараметрыНадписиВалюты.
// 
Функция СформироватьНадписьВалюты(ПараметрыДокумента) Экспорт

	Если ПараметрыДокумента.СуммаДокумента = 0 Тогда
		ТекстСуммаДокумента = "";
	Иначе
		ТекстСуммаДокумента = " " + Формат(ПараметрыДокумента.СуммаДокумента, "ЧДЦ=2");
	КонецЕсли;
	
	Если ПараметрыДокумента.ВалютаДокумента = ПараметрыДокумента.ВалютаВзаиморасчетов ИЛИ ПараметрыДокумента.НеПоказыватьРасчеты Тогда
		
		НадписьВалюты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Документ и расчеты:%1 %2'"),
				ТекстСуммаДокумента,
				ПараметрыДокумента.ВалютаДокумента);
		
	Иначе
		
		ТекстДокумент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Документ%1 %2'"),
				ТекстСуммаДокумента,
				ПараметрыДокумента.ВалютаДокумента);
		
		Если ПараметрыДокумента.СуммаВзаиморасчетов = 0 Тогда
			ТекстСуммаВзаиморасчетов = "";
		Иначе
			ТекстСуммаВзаиморасчетов = " " + Формат(ПараметрыДокумента.СуммаВзаиморасчетов, "ЧДЦ=2");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыДокумента.ВалютаВзаиморасчетов) Тогда
			ТекстВалютаВзаиморасчетов = ПараметрыДокумента.ВалютаВзаиморасчетов;
		Иначе
			ТекстВалютаВзаиморасчетов = НСтр("ru='<Не выбрана>'")
		КонецЕсли;
		
		ТекстРасчеты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru=', Расчеты%1 %2'"),
				ТекстСуммаВзаиморасчетов,
				ТекстВалютаВзаиморасчетов);
		
		Если НЕ ЗначениеЗаполнено(ПараметрыДокумента.ВалютаВзаиморасчетов) Тогда
			
			ТекстРасшифровка = "";
			
		ИначеЕсли ПараметрыДокумента.ВалютаДокумента = ПараметрыДокумента.ВалютаРеглУчета
			ИЛИ ПараметрыДокумента.ВалютаВзаиморасчетов = ПараметрыДокумента.ВалютаРеглУчета Тогда
			
			ВалютаНадписи = ?(ПараметрыДокумента.ВалютаРеглУчета = ПараметрыДокумента.ВалютаДокумента,
							ПараметрыДокумента.ВалютаВзаиморасчетов,
							ПараметрыДокумента.ВалютаДокумента);
			
			Если ПараметрыДокумента.Кратность = 1 Тогда
				
					ТекстРасшифровка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						"(%1=%2 %3)",
						ВалютаНадписи,
						ПараметрыДокумента.Курс,
						ПараметрыДокумента.ВалютаРеглУчета);
				
				Иначе
					
					ТекстРасшифровка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='(%1 %2 за %3 %4)'"),
						ПараметрыДокумента.Курс,
						ПараметрыДокумента.ВалютаРеглУчета,
						ПараметрыДокумента.Кратность,
						ВалютаНадписи);
					
			КонецЕсли;
			
		Иначе
			
			Если ПараметрыДокумента.Кратность = 1 Тогда
				
				ТекстРасшифровка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"(%1=%2 %3)",
					ПараметрыДокумента.ВалютаДокумента,
					ПараметрыДокумента.Курс,
					ПараметрыДокумента.ВалютаВзаиморасчетов);
			Иначе
				
				ТекстКурс = Строка(ПараметрыДокумента.Курс) + " " + ПараметрыДокумента.ВалютаВзаиморасчетов;
				
				ТекстКратность= Строка(ПараметрыДокумента.Кратность);
				
				ТекстРасшифровка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"(%1=%2 %3)",
					ТекстКурс,
					ТекстКратность,
					ПараметрыДокумента.ВалютаДокумента);
					
			КонецЕсли;
			
		КонецЕсли;
		
		НадписьВалюты = ТекстДокумент + " " + ТекстРасчеты + " " + ТекстРасшифровка;
		
	КонецЕсли;
	
	Возврат НадписьВалюты;
	
КонецФункции

// Возвращает пустую структуру параметров формирования надписи Валюты и курсы документа.
//
// Возвращаемое значение:
//  Структура - параметры для заполнения в форме.
//
Функция ПараметрыНадписиВалюты() Экспорт
	
	Возврат Новый Структура("НеПоказыватьРасчеты,
							|ВалютаДокумента,
							|ВалютаВзаиморасчетов,
							|ВалютаРеглУчета,
							|СуммаДокумента,
							|СуммаВзаиморасчетов,
							|Курс,
							|Кратность", ЛОЖЬ);
	
КонецФункции

Процедура РассчитатьКонечноеСальдоПоФинансовымИнструментам(Группировка, ДетальныеЗаписи) Экспорт
	
	Отбор = Новый Структура("Договор");
	ЗаполнитьЗначенияСвойств(Отбор, Группировка);
	
	ДеталиГруппировки = ДетальныеЗаписи.НайтиСтроки(Отбор);
	
	ОборотАктив = Новый Структура("Дт, Кт", 0, 0);
	ОборотПассив = Новый Структура("Дт, Кт", 0, 0);
	Для Каждого Запись Из ДеталиГруппировки Цикл
		Если Группировка.ТипРасчетов = ПредопределенноеЗначение("Перечисление.ТипыРасчетовСПартнерами.РасчетыСЛизингодателем") Тогда
			ДобавитьОборот(ОборотПассив, Запись, "АрендныеОбязательства");
			ДобавитьОборот(ОборотАктив, Запись, "ОбеспечительныйПлатеж");
			ДобавитьОборот(ОборотПассив, Запись, "ЛизинговыйПлатеж");
			ДобавитьОборот(ОборотПассив, Запись, "ВыкупПредметаЛизинга");
			
		ИначеЕсли Группировка.ТипРасчетов = ПредопределенноеЗначение("Перечисление.ТипыРасчетовСПартнерами.РасчетыСКредитором") Тогда
			ДобавитьОборот(ОборотПассив, Запись, "ОсновнойДолг");
			ДобавитьОборот(ОборотПассив, Запись, "Проценты");
			ДобавитьОборот(ОборотПассив, Запись, "Комиссия");
			
		Иначе
			ДобавитьОборот(ОборотАктив, Запись, "ОсновнойДолг");
			ДобавитьОборот(ОборотАктив, Запись, "Проценты");
			ДобавитьОборот(ОборотАктив, Запись, "Комиссия");
			
		КонецЕсли;
	КонецЦикла;
	
	Группировка.КонечноеСальдоДт = Группировка.НачальноеСальдоДт + ОборотАктив.Дт - ОборотАктив.Кт;
	Группировка.КонечноеСальдоКт = Группировка.НачальноеСальдоКт - ОборотПассив.Дт + ОборотПассив.Кт;
	Группировка.ОборотПриход = ОборотАктив.Дт + ОборотПассив.Дт;
	Группировка.ОборотРасход = ОборотАктив.Кт + ОборотПассив.Кт;
	
	// установим конечное сальдо, если не было начального
	Если Группировка.НачальноеСальдоДт = 0 Тогда
		Группировка.КонечноеСальдоДт = ОборотАктив.Дт - ОборотАктив.Кт;
	КонецЕсли;
		
	Если Группировка.НачальноеСальдоКт = 0 Тогда
		Группировка.КонечноеСальдоКт = -ОборотПассив.Дт + ОборотПассив.Кт;
	КонецЕсли;
	
	Если Группировка.ТипРасчетов <> ПредопределенноеЗначение("Перечисление.ТипыРасчетовСПартнерами.РасчетыСЛизингодателем") Тогда
		КонечноеСальдо = Группировка.КонечноеСальдоДт - Группировка.КонечноеСальдоКт;
		Если КонечноеСальдо > 0 Тогда
			Группировка.КонечноеСальдоДт = КонечноеСальдо;
			Группировка.КонечноеСальдоКт = 0;
		Иначе
			Группировка.КонечноеСальдоДт = 0;
			Группировка.КонечноеСальдоКт = -КонечноеСальдо;
		КонецЕсли;
	КонецЕсли;
	
	Если Группировка.КонечноеСальдоДт < 0 Тогда
		Группировка.КонечноеСальдоКт = Группировка.КонечноеСальдоКт - Группировка.КонечноеСальдоДт;
		Группировка.КонечноеСальдоДт = 0;
	КонецЕсли;
	Если Группировка.КонечноеСальдоКт < 0 Тогда
		Группировка.КонечноеСальдоДт = Группировка.КонечноеСальдоДт - Группировка.КонечноеСальдоКт;
		Группировка.КонечноеСальдоКт = 0;
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьКонечноеСальдоПоВзаиморасчетам(Группировка, ДетальныеЗаписи) Экспорт
	
	Отбор = Новый Структура("ТипРасчетов,Партнер,ОбъектРасчетов");
	ЗаполнитьЗначенияСвойств(Отбор, Группировка);
	
	ДеталиГруппировки = ДетальныеЗаписи.НайтиСтроки(Отбор);
	Обороты = Новый Структура("Приход, Расход",0,0);
	Для Каждого Запись Из ДеталиГруппировки Цикл
			
		Если Запись.СуммаДолг > 0 Тогда
			Обороты.Приход = Обороты.Приход + Запись.СуммаДолг;
		Иначе
			Обороты.Расход = Обороты.Расход + (-Запись.СуммаДолг);
		КонецЕсли;
		
		Если Запись.СуммаАванс > 0 Тогда
			Обороты.Расход = Обороты.Расход + Запись.СуммаАванс;
		Иначе
			Обороты.Приход = Обороты.Приход + (-Запись.СуммаАванс);
		КонецЕсли;
		
	КонецЦикла;
	
	Группировка.ОборотПриход = Обороты.Приход;
	Группировка.ОборотРасход = Обороты.Расход;
	Группировка.КонечноеСальдо = Группировка.НачальноеСальдо + Группировка.ОборотПриход - Группировка.ОборотРасход;
	
КонецПроцедуры

Процедура РассчитатьКонечноеСальдоРегл(Группировка, ДетальныеЗаписи, КэшКурсов) Экспорт
	
	Отбор = Новый Структура("ТипРасчетов,Партнер,ОбъектРасчетов");
	ЗаполнитьЗначенияСвойств(Отбор, Группировка);
	
	ДеталиГруппировки = ДетальныеЗаписи.НайтиСтроки(Отбор);
	Обороты = Новый Структура("Приход, Расход", 0,0);
	Для Каждого Запись Из ДеталиГруппировки Цикл
		
		КурсВалюты = КэшКурсов[Группировка.Валюта];
		Если Запись.СуммаДолг > 0 Тогда
			Обороты.Приход = Обороты.Приход + Запись.СуммаДолг * КурсВалюты.Курс/КурсВалюты.Кратность;
		Иначе
			Обороты.Расход = Обороты.Расход + (-Запись.СуммаДолг * КурсВалюты.Курс/КурсВалюты.Кратность);
		КонецЕсли;
		
		Если Запись.СуммаАванс > 0 Тогда
			Обороты.Расход = Обороты.Расход + Запись.СуммаАвансРегл;
		Иначе
			Обороты.Приход = Обороты.Приход + (-Запись.СуммаАвансРегл);
		КонецЕсли;
		
	КонецЦикла;
	
	Группировка.КонечноеСальдоРегл = Группировка.НачальноеСальдоРегл + Обороты.Приход - Обороты.Расход;
	
КонецПроцедуры

// Возвращет список типов договоро договоров с клиентами.
// 
// Возвращаемое значение:
// 	СписокЗначений - Список типов договоров с контрагентом, как с клиентом.
Функция ТипыДоговоровСКлиентом() Экспорт
	
	Типы = Новый СписокЗначений;
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПокупателем"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомиссионером"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СХранителем"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СДавальцем"));
	
	Возврат Типы;
КонецФункции

// Возвращет список типов договоро договоров с поставщиками.
// 
// Возвращаемое значение:
// 	СписокЗначений - Список типов договоров с контрагентом, как с поставщиком.
Функция ТипыДоговоровСПоставщиком() Экспорт
	
	Типы = Новый СписокЗначений;
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоставщиком"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.Импорт"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПереработчиком"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СПоклажедателем"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.СКомитентом"));
	Типы.Добавить(ПредопределенноеЗначение("Перечисление.ТипыДоговоров.ВвозИзЕАЭС"));
	
	Возврат Типы;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОборот(Обороты, Запись, ИмяРесурса)
	
	ЗначениеРесурса = Запись[ИмяРесурса];
	Если ЗначениеРесурса > 0 Тогда
		Обороты.Дт = Обороты.Дт + ЗначениеРесурса;
	Иначе
		Обороты.Кт = Обороты.Кт + (-ЗначениеРесурса);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти