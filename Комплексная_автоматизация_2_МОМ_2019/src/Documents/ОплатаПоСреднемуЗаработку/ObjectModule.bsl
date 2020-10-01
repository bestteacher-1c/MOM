#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ВосстановлениеВДолжности") Тогда
		
		РеквизитыДанныхЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, "Организация,Сотрудник,ДатаУвольнения,ДатаВосстановления,Проведен");
			
		Если РеквизитыДанныхЗаполнения.Проведен Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДанныхЗаполнения);
			
			ДатаНачала = КонецДня(РеквизитыДанныхЗаполнения.ДатаУвольнения) + 1;
			ДатаОкончания = НачалоДня(РеквизитыДанныхЗаполнения.ДатаВосстановления) - 1;
			ДатаНачалаСобытия = ДатаНачала;
			
			РасчетДенежногоСодержания = Ложь;
			ЗарплатаКадрыРасширенный.УстановитьВариантРасчетаДокументаПоСреднемуЗаработку(ЭтотОбъект);
			
			ДопПараметры = Документы.ОплатаПоСреднемуЗаработку.ДополнительныеПараметрыВыбораНачислений(ЭтотОбъект, "ВидРасчета");
			ДопПараметры.Вставить("Отбор.Код", НСтр("ru = 'ОВП'"));
			ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета", ДопПараметры);
			Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
				ДопПараметры.Удалить("Отбор.Код");
				ПланыВидовРасчета.Начисления.УстановитьНачислениеПоУмолчаниюВОбъекте(ЭтотОбъект, "ВидРасчета", ДопПараметры);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
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
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
			ЗаполнитьПослеПереноса(ДанныеЗаполнения);	
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ЗаполнитьОплатуПоСреднемуПоНаправлениюНаМедицинскийОсмотр(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ДатаНачалаСобытия = ДатаНачала;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОплатаПоСреднемуЗаработку.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВнутрисменноеОтсутствие Тогда
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОтсутствия, "Объект.ДатаОтсутствия", Отказ, НСтр("ru='Дата отсутствия'"), , , Ложь);
	Иначе
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Дата начала'"), , , Ложь);
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
	
	ПроверитьРегистрациюВнутрисменногоВремени(Отказ);
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	ПредставлениеПериода = ЗарплатаКадрыРасширенный.ПредставлениеПериодаРасчетногоДокумента(ДатаНачала, ДатаОкончания);
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
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
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеДляБухучета = Документы.ОплатаПоСреднемуЗаработку.ДанныеДляБухучетаЗарплатыПервичныхДокументов(ЭтотОбъект);
	ОтражениеЗарплатыВБухучетеРасширенный.ЗарегистрироватьБухучетЗарплатыПервичныхДокументов(ДанныеДляБухучета);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

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
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Сотрудник"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Сотрудник", ТекстСообщения, "");
	КонецЕсли;
	
	Если ВнутрисменноеОтсутствие Тогда
		Если Не ЗначениеЗаполнено(ДатаОтсутствия) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнена дата отсутствия.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОтсутствия", ТекстСообщения, "");
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОплачиватьЧасов) Тогда
			ТекстСообщения = НСтр("ru = 'Не указано количество часов внутрисменного отсутствия.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ОплачиватьЧасов", ТекстСообщения, "");
		КонецЕсли;
	Иначе 				
		Если Не ЗначениеЗаполнено(ДатаНачала) И Не ЗначениеЗаполнено(ДатаОкончания) Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны даты оплаты по среднему заработку.'");
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
		Иначе
			Если Не ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата начала оплаты по среднему заработку.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачала", ТекстСообщения, "");
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ДатаОкончания) И ЗначениеЗаполнено(ДатаНачала) Тогда
				ТекстСообщения = НСтр("ru = 'Не заполнена дата окончания оплаты по среднему заработку.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДатаНачала) И ЗначениеЗаполнено(ДатаОкончания) И ДатаНачала > ДатаОкончания Тогда
				ТекстСообщения = НСтр("ru = 'Дата окончания оплаты по среднему заработку не может быть меньше даты начала.'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаОкончания", ТекстСообщения, "");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидВремени) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан вид отсутствия.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидВремени", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ТекстСообщения = НСтр("ru = 'Не указана дата начала периода сохранения среднего заработка.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДатаНачалаСобытия", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПроцентОплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан процент оплаты.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПроцентОплаты", ТекстСообщения, "");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидРасчета) Тогда
		ТекстСообщения = Документы.ОплатаПоСреднемуЗаработку.ТекстСообщенияНеЗаполненВидРасчета(ВнутрисменноеОтсутствие);
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
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Начисления", НСтр("ru='Начисления'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru='Удержания'"), "Удержание"));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru='Перерасчет прошлого периода'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура ПроверитьРегистрациюВнутрисменногоВремени(Отказ)
	
	Если НЕ ВнутрисменноеОтсутствие Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОВремениДляПроверки = Документы.ОплатаПоСреднемуЗаработку.ДанныеОВремени(ЭтотОбъект);
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
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДатаОтсутствия");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОплачиватьЧасов");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПроцентОплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидВремени");
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

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)
	
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

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли