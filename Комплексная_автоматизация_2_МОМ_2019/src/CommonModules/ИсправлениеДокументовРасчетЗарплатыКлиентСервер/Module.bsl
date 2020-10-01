
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает доступны ли перерасчеты для переданной формы.
// Форма должна содержать "Объект".
//
Функция ПерерасчетыДоступны(Форма, ИмяРеквизитаПериодаРегистрации = "ПериодРегистрации", ИмяРеквизитаДатыНачала = "ДатаНачала",	ВозможноВытеснение = Истина) Экспорт
	
	ОписаниеДокумента = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	ОписаниеДокумента.НачисленияПерерасчетИмя = "НачисленияПерерасчет";
	ОписаниеДокумента.МесяцНачисленияИмя = ИмяРеквизитаПериодаРегистрации;
	ОписаниеДокумента.ДатаНачалаСобытияИмя = ИмяРеквизитаДатыНачала;
	
	Возврат ПерерасчетыДоступныПоОписанию(Форма, ОписаниеДокумента, ВозможноВытеснение);
	
КонецФункции

Функция ПерерасчетыДоступныПоОписанию(Форма, ОписаниеДокумента, ВозможноВытеснение = Истина) Экспорт
	
	Если ОписаниеДокумента.НачисленияПерерасчетИмя = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	ПараметрыИсправленного = Неопределено;
	ЭтоИсправление = ИсправлениеДокументовЗарплатаКадрыКлиентСервер.ЭтоИсправление(Форма, ПараметрыИсправленного);
	
	Если ЭтоИсправление Тогда
		Результат = Не ИсправлениеВТекущемПериоде(Форма, ОписаниеДокумента.МесяцНачисленияИмя)
			Или ПараметрыИсправленного.ВыполнилДоначисление;
	Иначе
		ДатаНачалаСобытия = ПолучитьДатуНачалаСобытияДокумента(Форма, ОписаниеДокумента);
		
		Результат =	ВозможноВытеснение
			И ЗначениеЗаполнено(ДатаНачалаСобытия)
			И Объект[ОписаниеДокумента.МесяцНачисленияИмя] > ДатаНачалаСобытия;
	КонецЕсли;
	
	ЕстьСтрокиПерерасчета = Объект[ОписаниеДокумента.НачисленияПерерасчетИмя].Количество() > 0;
	
	Возврат Результат Или ЕстьСтрокиПерерасчета;
	
КонецФункции

// Возвращает признак что исправление выполняется в текущем периоде.
//
Функция ИсправлениеВТекущемПериоде(Форма, ИмяРеквизитаПериодаРегистрации = "ПериодРегистрации") Экспорт
	
	ПараметрыИсправленного = Неопределено;
	ЭтоИсправление = ИсправлениеДокументовЗарплатаКадрыКлиентСервер.ЭтоИсправление(Форма, ПараметрыИсправленного);
	
	Возврат ЭтоИсправление И ПараметрыИсправленного.ПериодРегистрации = Форма.Объект[ИмяРеквизитаПериодаРегистрации];
	
КонецФункции

// Настраивает флаг ДоначислитьЗарплатуПриНеобходимости в зависимости от режима исправления.
//
Процедура УстановитьДоначислениеПриИсправлении(Форма, ПерерасчетыДоступны, ИмяРеквизитаПериодаРегистрации = "ПериодРегистрации") Экспорт
	
	ФлагДоначислить = Форма.Элементы.Найти("ДоначислитьЗарплатуПриНеобходимости");
	Если ФлагДоначислить = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИсправленного = Неопределено;
	ЭтоИсправление = ИсправлениеДокументовЗарплатаКадрыКлиентСервер.ЭтоИсправление(Форма, ПараметрыИсправленного);
	ПерерасчетыДоступныПриИсправлении = ПерерасчетыДоступны И ЭтоИсправление;
	ВыполнятьДоначисение = ПерерасчетыДоступныПриИсправлении И (ПараметрыИсправленного.ВыполнилДоначисление
		Или Не ИсправлениеВТекущемПериоде(Форма, ИмяРеквизитаПериодаРегистрации));
		
	ОбновитьРеквизитОбъекта = Ложь;
		
	Если ФлагДоначислить.Доступность <> ВыполнятьДоначисение Тогда
		ФлагДоначислить.Доступность = ВыполнятьДоначисение;
		ОбновитьРеквизитОбъекта = Истина;
	КонецЕсли;
	
	Если ФлагДоначислить.Видимость <> ПерерасчетыДоступныПриИсправлении Тогда
		ФлагДоначислить.Видимость = ПерерасчетыДоступныПриИсправлении;
		ОбновитьРеквизитОбъекта = Истина;
	КонецЕсли;
	
	Если ОбновитьРеквизитОбъекта Тогда
		Форма.Объект.ДоначислитьЗарплатуПриНеобходимости = ВыполнятьДоначисение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДатуНачалаСобытияДокумента(Форма, ОписаниеДокумента)
	
	Результат = Неопределено;
	
	Если Не ЗначениеЗаполнено(ОписаниеДокумента.ДатаНачалаСобытияИмя) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если Не Форма.Объект.Свойство(ОписаниеДокумента.ДатаНачалаСобытияИмя, Результат) Тогда
		
		// Поддержка "многосотрудниковых" документов, у которых даты начала события могут быть разные по сотрудникам.
		// Единая (минимальная) дата начала должна быть вычислена документом и храниться в реквизите формы.
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, ОписаниеДокумента.ДатаНачалаСобытияИмя) Тогда
			Результат = Форма[ОписаниеДокумента.ДатаНачалаСобытияИмя];
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти