#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, 
												ДанныеЗаполнения.Ссылка, 
												"ДокументРассчитан", 
												"ДанныеОбИндексации,Начисления,НачисленияПерерасчет,НачисленияПерерасчетНулевыеСторно,
												|НДФЛ,ОтработанноеВремяДляСреднегоОбщий,
												|Показатели,ПримененныеВычетыНаДетейИИмущественные,
												|РаспределениеРезультатовНачислений,РаспределениеРезультатовУдержаний,
												|СреднийЗаработокОбщий,Удержания",
												ДанныеЗаполнения);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПоЗаявке" Тогда
			ЗаполнитьПоЗаявкеНаКомандировку(ДанныеЗаполнения);			
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьИзОбучения" Тогда
			Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда 
				МодульОбучениеРазвитие = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
				МодульОбучениеРазвитие.ЗаполнитьКомандировкуИзДокументаОбучения(ЭтотОбъект, ДанныеЗаполнения);
			КонецЕсли;
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			Если ДанныеЗаполнения.Свойство("ЗаполнитьПоПараметрамЗаполнения") И ДанныеЗаполнения.ЗаполнитьПоПараметрамЗаполнения Тогда
				ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения);
			Иначе
				ДанныеЗаполнения = ДанныеЗаполнения.Сотрудник;
			КонецЕсли;
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
			ЗаполнитьПослеПереноса(ДанныеЗаполнения);	
		Иначе
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.Командировка.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВнутрисменнаяКомандировка Тогда
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаКомандировки, "Объект.ДатаКомандировки", Отказ, НСтр("ru='Дата командировки'"), , , Ложь);
	Иначе
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Дата начала'"), , , Ложь);
	КонецЕсли;
	
	Если ОсвобождатьСтавку Тогда
		УправлениеШтатнымРасписанием.ПроверитьВозможностьПроведенияВременногоОсвобожденияСтавок(
			Ссылка, Проведен, Сотрудник, ДатаНачала, ДатаОкончания, Отказ, ИсправленныйДокумент);
	КонецЕсли;
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);	
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		
		Если ДокументРассчитан Тогда
			
			ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
			
			ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок);                                                                        
			
			ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
			ПроверитьПериодДействияНачислений(Отказ);
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("ПроверкаПересеченияПериодовВыполнена") Тогда
		ПроверитьПересечениеПериодовОтсутствия(Отказ);
	КонецЕсли;
	
	ПроверитьРегистрациюВнутрисменногоВремени(Отказ);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда 
		МодульСамообслуживаниеСотрудников = ОбщегоНазначения.ОбщийМодуль("СамообслуживаниеСотрудников");
		МодульСамообслуживаниеСотрудников.ПроверитьНаличиеКомандировкиПоЗаявкеСотрудника(ЗаявкаСотрудника, Сотрудник, Ссылка, Отказ, ИсправленныйДокумент);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Если ОсвобождатьСтавку Тогда
		УправлениеШтатнымРасписанием.ПроверитьВозможностьОтменыПроведения(Ссылка, Сотрудник, ДатаНачала, ДатаОкончания, Отказ);
	КонецЕсли;
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.Командировка.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетСреднегоЗаработка.ЗаписатьДатуНачалаСобытия(Ссылка, Сотрудник, ДатаНачалаСобытия);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.СохранитьВариантРасчетаСреднегоЗаработкаДокумента(ЭтотОбъект, ДатаНачалаСобытия);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.Командировка.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполненияДокумента

Функция ДокументГотовКРасчету(ВыводитьСообщения = Истина) Экспорт
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);
	
	ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, Истина);                                                                        
		
	КонтейнерСодержитОшибки = Ложь;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, КонтейнерСодержитОшибки);
	
	Если Не ВыводитьСообщения Тогда
		
		ПолучитьСообщенияПользователю(Истина);		
		
	КонецЕсли;
	
	Возврат Не КонтейнерСодержитОшибки;	
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок)
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан период регистрации.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПериодРегистрации", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана организация, по которой выполняется начисление.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран сотрудник.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Сотрудник", ТекстСообщения, "");
	КонецЕсли;
	
	Если ВнутрисменнаяКомандировка Тогда
		
		Если Не ЗначениеЗаполнено(ДатаКомандировки) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена дата командировки.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаКомандировки", ТекстСообщения, "");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОплачиватьЧасов) Тогда
			ТекстСообщения = НСтр("ru = 'Не указано количество часов внутрисменной командировки.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ОплачиватьЧасов", ТекстСообщения, "");
		КонецЕсли;
		
	Иначе 
		Если Не ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны даты командировки.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
		Иначе
			Если Не ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата начала командировки.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДатаОкончания) И ЗначениеЗаполнено(ДатаНачала) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата окончания командировки.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И ДатаНачала > ДатаОкончания Тогда
				ТекстСообщения = НСтр("ru = 'Дата окончания командировки не может быть меньше даты начала.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидРасчета) 
		И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОплатыКомандировки") Тогда
		ТекстСообщения = Документы.Командировка.ТекстСообщенияНеЗаполненВидРасчета(ВнутрисменнаяКомандировка);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидРасчета", ТекстСообщения, "");
	КонецЕсли;
	
  	ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом);

КонецПроцедуры

Процедура ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом)
	
	МассивНачисленийДокумента = Новый Массив;
	
	Если НЕ ПроверкаПередРасчетом Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, Начисления.ВыгрузитьКолонку("Начисление"), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента)
		И Не ЗначениеЗаполнено(ПланируемаяДатаВыплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Дата выплаты обязательна к заполнению при выплате в межрасчет.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПланируемаяДатаВыплаты", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru='Перерасчет прошлого периода'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru='Удержания'"), "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура ПроверитьРегистрациюВнутрисменногоВремени(Отказ)
	
	Если НЕ ВнутрисменнаяКомандировка Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОВремениДляПроверки = Документы.Командировка.ДанныеОВремени(ЭтотОбъект);
	ОшибкиВводаВремени = УчетРабочегоВремениРасширенный.ПроверитьРегистрациюВнутрисменногоВремени(Ссылка, ДанныеОВремениДляПроверки, ПериодРегистрации);
	Ошибки = Новый Соответствие;
	Для Каждого ОписаниеОшибки Из ОшибкиВводаВремени Цикл
		УчетРабочегоВремениРасширенный.ДобавитьОшибкуПоСотруднику(Ошибки, ОписаниеОшибки.Сотрудник, ОписаниеОшибки.ТекстОшибки, "", ОписаниеОшибки.Документ);		
	КонецЦикла;
	УчетРабочегоВремениРасширенный.ВывестиОшибкиПоСотрудникам(Ошибки, Отказ);
	
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаНачала");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОкончания");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаКомандировки");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОплачиватьЧасов");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");

КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьСотрудникаВТаблицахНачислений()
	
	ТаблицыНачислений = Новый Массив;
	ТаблицыНачислений.Добавить(Начисления);
	ТаблицыНачислений.Добавить(НачисленияПерерасчет);
	ТаблицыНачислений.Добавить(НачисленияПерерасчетНулевыеСторно);
	
	Для Каждого ТаблицаНачислений Из ТаблицыНачислений Цикл
		Для Каждого СтрокаТаблицы Из ТаблицаНачислений Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) Тогда
				СтрокаТаблицы.Сотрудник = Сотрудник;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоПараметрамЗаполнения(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	
	ЗаполняемыеЗначения = Новый Структура(
		"Месяц, 
		|Ответственный");
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения, ТекущаяДатаСеанса());
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения);
	
	ПериодРегистрации = ЗаполняемыеЗначения.Месяц;
	ДатаНачалаСобытия = ДатаНачала;
	ПланируемаяДатаВыплаты = РасчетЗарплатыРасширенныйКлиентСервер.ПланируемаяДатаВыплатыЗарплаты(Организация, ПериодРегистрации);
	
	ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета", , Истина);
	
	Если ЗначениеЗаполнено(ЗаявкаСотрудника) Тогда
		ЗаполнитьПоЗаявкеНаКомандировку(ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполняемыеЗначения = Новый Структура(
		"Организация,
		|Руководитель,
		|ДолжностьРуководителя");
	ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, ЭтотОбъект);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗаполняемыеЗначения, , "Организация");
	
КонецПроцедуры

Процедура ЗаполнитьПоЗаявкеНаКомандировку(ДанныеЗаполнения)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.СамообслуживаниеСотрудников") Тогда 
		МодульСамообслуживаниеСотрудников = ОбщегоНазначения.ОбщийМодуль("СамообслуживаниеСотрудников");
		МодульСамообслуживаниеСотрудников.ЗаполнитьКомандировкуПоЗаявкеСотрудника(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)
	
	Отбор = Новый Структура("ВидВремени");
	Если ВнутрисменнаяКомандировка Тогда
		Отбор.ВидВремени = Перечисления.ВидыРабочегоВремениСотрудников.ЧасовоеНеотработанное;
	Иначе	
		Отбор.ВидВремени = Перечисления.ВидыРабочегоВремениСотрудников.ЦелодневноеНеотработанное;
	КонецЕсли;
	ВидыРасчетаКомандировки = ПланыВидовРасчета.Начисления.НачисленияПоКатегории(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаКомандировки, Отбор);
	Если ВидыРасчетаКомандировки.Количество() > 0 Тогда
		ВидРасчета = ВидыРасчетаКомандировки[0];
	КонецЕсли;
	
	ПериодРасчетаСреднего = УчетСреднегоЗаработка.ПериодРасчетаОбщегоСреднегоЗаработкаСотрудника(ДатаНачалаСобытия, Сотрудник, ВидРасчета);
	ПериодРасчетаСреднегоЗаработкаНачало	= ПериодРасчетаСреднего.ДатаНачала;
	ПериодРасчетаСреднегоЗаработкаОкончание = ПериодРасчетаСреднего.ДатаОкончания;
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
	ЗапрашиваемыеЗначения.Вставить("ГлавныйБухгалтер", "ГлавныйБухгалтер");
	ЗапрашиваемыеЗначения.Вставить("Бухгалтер", "Бухгалтер");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));

КонецПроцедуры

Процедура ПроверитьПересечениеПериодовОтсутствия(Отказ)
	
	ИсходныеДанные = СостоянияСотрудников.ПустаяТаблицаДанныхСостоянийСотрудника();
	
	НоваяСтрока = ИсходныеДанные.Добавить();
	НоваяСтрока.Сотрудник = Сотрудник;
	НоваяСтрока.Состояние = Перечисления.СостоянияСотрудника.Командировка;
	НоваяСтрока.Начало = ДатаНачала;
	НоваяСтрока.Окончание = ДатаОкончания;
	
	РезультатПроверки = СостоянияСотрудников.ПроверитьПересечениеПериодовОтсутствия(ИсходныеДанные, Ссылка, ИсправленныйДокумент);
	
	ДанныеСотрудника = РезультатПроверки.ДанныеСотрудников.Получить(Сотрудник);
	Если ДанныеСотрудника = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РезультатПроверки.Отказ Тогда
		ТекстСообщения = НСтр("ru = 'На период %1 сотруднику уже зарегистрирована командировка документом %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ДанныеСотрудника.ПредставлениеПериода, ДанныеСотрудника.Регистратор);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли