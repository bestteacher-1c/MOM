
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	КоличествоВсего         = Параметры.КоличествоВсего;
	КоличествоНеПроверенных = Параметры.КоличествоНеПроверенных;
	КоличествоОтложенных    = Параметры.КоличествоОтложенных;
	КоличествоОтсутствует   = Параметры.КоличествоОтсутствует;
	ЕстьРасхождения         = Параметры.ЕстьРасхождения;
	ПроверяемыйДокумент     = Параметры.ПроверяемыйДокумент;
	
	ИспользуютсяАктыОРасхожденияхПослеПриемки = ИнтеграцияИСМП.АктыОРасхожденияПослеПоступленияИспользуются(Параметры.ПроверяемыйДокумент);
	
	Если КоличествоНеПроверенных > 0 
		Или КоличествоОтложенных > 0 Тогда
		
		ЕстьВопросКакУчитывать = Истина;
		ПоказатьВопросКакУчитыватьНепроверенныеОтложенные(ЭтотОбъект);
		
	ИначеЕсли ЕстьРасхождения 
		И ИспользуютсяАктыОРасхожденияхПослеПриемки
		И ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоДокументПриобретения(ПроверяемыйДокумент) Тогда
			
		ПоказатьВопросПоИспользованиюАктов(ЭтотОбъект);
		
	КонецЕсли;

	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("КакУчитыватьНеПроверенныеОтложенные", Неопределено);
	ВозвращаемоеЗначение.Вставить("СоздаватьАктОРасхождениях", Ложь);
	
	Если Элементы.СтраницыВопросы.ТекущаяСтраница = Элементы.СтраницаКакУчитывать Тогда
		
		Если КакУчитыватьНеПроверенныеОтложенные = 0 Тогда
			
			Если ИспользуютсяАктыОРасхожденияхПослеПриемки
				И ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоДокументПриобретения(ПроверяемыйДокумент) Тогда
				ПоказатьВопросПоИспользованиюАктов(ЭтотОбъект);
				Возврат;
			КонецЕсли;
			
			ВозвращаемоеЗначение.КакУчитыватьНеПроверенныеОтложенные = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отсутствует");
			
		Иначе
			
			ВозвращаемоеЗначение.КакУчитыватьНеПроверенныеОтложенные = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии");
			
		КонецЕсли;
		
	Иначе
		
		Если КакОтражатьРасхождения = 0 Тогда
			ВозвращаемоеЗначение.СоздаватьАктОРасхождениях = Ложь;
		Иначе
			ВозвращаемоеЗначение.СоздаватьАктОРасхождениях = Истина;
		КонецЕсли;
		
		Если ЕстьВопросКакУчитывать Тогда
			
			Если КакУчитыватьНеПроверенныеОтложенные = 0 Тогда
				ВозвращаемоеЗначение.КакУчитыватьНеПроверенныеОтложенные = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.Отсутствует");
			Иначе
				ВозвращаемоеЗначение.КакУчитыватьНеПроверенныеОтложенные = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии");
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Закрыть(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьВопросКакУчитыватьНепроверенныеОтложенные(Форма)

	Форма.Элементы.СтраницыВопросы.ТекущаяСтраница = Форма.Элементы.СтраницаКакУчитывать;
	Форма.Элементы.ОККакУчитывать.КнопкаПоУмолчанию       = Истина;
	
	Если Форма.КоличествоНеПроверенных > 0
		И Форма.КоличествоОтложенных > 0 Тогда
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие пачек и упаковок - %1.
		                                        |Не проверено - %2. Отложено - %3.
		                                        |
		                                        |Отразить в результатах проверки отложенные и непроверенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоНеПроверенных,
		                            Форма.КоличествоОтложенных);
		
	ИначеЕсли Форма.КоличествоНеПроверенных > 0 Тогда
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие пачек и упаковок - %1.
		                                        |Не проверено - %2.
		                                        |
		                                        |Отразить в результатах проверки непроверенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоНеПроверенных);
		
	Иначе
		
		ТекстРезультаты = СтрШаблон(НСтр("ru = 'Требовалось проверить наличие пачек и упаковок - %1. 
		                                        |Отложено - %3.
		                                        |
		                                        |Отразить в результатах проверки отложенные как:'"),
		                            Форма.КоличествоВсего,
		                            Форма.КоличествоОтложенных);
		
	КонецЕсли;
	
	Форма.Элементы.ДекорацияВопросКакУчитывать.Заголовок = ТекстРезультаты;
	
	Если Форма.КоличествоВсего <> 0 
		И ((Форма.КоличествоНеПроверенных + Форма.КоличествоОтложенных) / Форма.КоличествоВсего > 0.5) Тогда
		
		Форма.КакУчитыватьНеПроверенныеОтложенные = 1;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьВопросПоИспользованиюАктов(Форма)
	
	Форма.КакОтражатьРасхождения = 1;
	
	Форма.Элементы.СтраницыВопросы.ТекущаяСтраница = Форма.Элементы.СтраницаИспользоватьАкт;
	Форма.Элементы.ОКРасхождения.КнопкаПоУмолчанию       = Истина;
	
КонецПроцедуры

#КонецОбласти
