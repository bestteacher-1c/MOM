
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", ПодключаемоеОборудование);
	
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(ПодключаемоеОборудование);
	
	времКаталогВыгрузки  = Неопределено;
	времКаталогЗагрузки = Неопределено;
	времИмяФайлаНастроек   = Неопределено;
	времИмяФайлаПрайсЛиста   = Неопределено;
	времИмяЗагружаемогоФайла = Неопределено;
	времКоличествоЭлементовВПакете = Неопределено;
	времВидОбмена = Неопределено;
	
	времКаталогОбмена = Неопределено;
	времИмяФайлаВыгрузки = Неопределено;
	времИмяФайлаЗагрузки = Неопределено;
	времВерсияФорматаОбмена = Неопределено;
	
	Если Параметры.ПараметрыОборудования.Свойство("ПараметрыДрайвераККМ") Тогда
		
		ПараметрыДрайвераККМ = Параметры.ПараметрыОборудования.ПараметрыДрайвераККМ;
		
		ПараметрыДрайвераККМ.Свойство("РазрешеноИспользоватьПлатежныеКарты",
			РазрешеноИспользоватьПлатежныеКарты);
		
		ПараметрыДрайвераККМ.Свойство("РазрешеноИспользоватьСкидки",
			РазрешеноИспользоватьСкидки);
		
	КонецЕсли;
	
	Параметры.ПараметрыОборудования.Свойство("КаталогВыгрузки", времКаталогВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("КаталогЗагрузки", времКаталогЗагрузки);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаПрайсЛиста", времИмяФайлаПрайсЛиста);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаНастроек", времИмяФайлаНастроек);
	Параметры.ПараметрыОборудования.Свойство("ИмяЗагружаемогоФайла",времИмяЗагружаемогоФайла);
	Параметры.ПараметрыОборудования.Свойство("КоличествоЭлементовВПакете",времКоличествоЭлементовВПакете);
	
	Параметры.ПараметрыОборудования.Свойство("КаталогОбмена", времКаталогОбмена);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаВыгрузки", времИмяФайлаВыгрузки);
	Параметры.ПараметрыОборудования.Свойство("ИмяФайлаЗагрузки", времИмяФайлаЗагрузки);
	Параметры.ПараметрыОборудования.Свойство("ВерсияФорматаОбмена", времВерсияФорматаОбмена);
	
	КаталогВыгрузки = ?(времКаталогВыгрузки = Неопределено, "", времКаталогВыгрузки);
	КаталогЗагрузки  = ?(времКаталогЗагрузки = Неопределено, "", времКаталогЗагрузки);
	ИмяФайлаНастроек = ?(времИмяФайлаНастроек = Неопределено, "Settings", времИмяФайлаНастроек);
	ИмяФайлаПрайсЛиста = ?(времИмяФайлаПрайсЛиста = Неопределено, "PriceList", времИмяФайлаПрайсЛиста);
	ИмяЗагружаемогоФайла = ?(времИмяЗагружаемогоФайла = Неопределено, "SalesReport", времИмяЗагружаемогоФайла);
	КоличествоЭлементовВПакете = ?(времКоличествоЭлементовВПакете = Неопределено, 0, времКоличествоЭлементовВПакете);
	
	КаталогОбмена = 	?(времКаталогОбмена = Неопределено, "", времКаталогОбмена);
	ИмяФайлаВыгрузки = 	?(времИмяФайлаВыгрузки = Неопределено, "ExportData", времИмяФайлаВыгрузки);
	ИмяФайлаЗагрузки = 	?(времИмяФайлаЗагрузки = Неопределено, "ImportData", времИмяФайлаЗагрузки);
	
	Если ЗначениеЗаполнено(ПодключаемоеОборудование.ВидТранспортаОфлайнОбмена) Тогда
		ВидОбмена = ПодключаемоеОборудование.ВидТранспортаОфлайнОбмена;
	Иначе
		ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE;
	КонецЕсли;
	
	Если ПодключаемоеОборудование.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ПрайсЧекер Тогда
		ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.WS;
		Элементы.ВидОбмена.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ИдентификаторWebСервисОборудования = ПодключаемоеОборудование.ИдентификаторWebСервисОборудования;
	
	ВерсииФорматовОбмена = МенеджерОфлайнОборудования.ДоступныеВерсииФорматовОбмена();
	ПоследняяВерсия = 0;
	Для ИндексФормата = 0 По ВерсииФорматовОбмена.Количество() - 1 Цикл 
		ФорматОбмена = ВерсииФорматовОбмена.Получить(ИндексФормата);
		Элементы.ВерсияФорматаОбмена.СписокВыбора.Добавить(ФорматОбмена.Значение, ФорматОбмена.Представление);
		
		Если ИндексФормата = ВерсииФорматовОбмена.Количество() - 1 Тогда
			ПоследняяВерсия = ФорматОбмена.Значение;
		КонецЕсли;
	КонецЦикла;
	
	ВерсияФорматаОбмена = ?(ЗначениеЗаполнено(времВерсияФорматаОбмена), времВерсияФорматаОбмена, ПоследняяВерсия);
	
	НастроитьЭлементыПоВерсииФормата();
	
	МенеджерОфлайнОборудованияПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСозданииНаСервере(ЭтотОбъект, ПодключаемоеОборудование);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE Тогда 
		
		НепроверяемыеРеквизиты.Добавить("ИдентификаторWebСервисОборудования");
		
		Если ВерсияФорматаОбмена > 2000 Тогда
			
			НепроверяемыеРеквизиты.Добавить("КаталогВыгрузки");
			НепроверяемыеРеквизиты.Добавить("КаталогЗагрузки");
			НепроверяемыеРеквизиты.Добавить("ИмяФайлаПрайсЛиста");
			НепроверяемыеРеквизиты.Добавить("ИмяЗагружаемогоФайла");
			
			Если НРег(ИмяФайлаВыгрузки) = НРег(ИмяФайлаЗагрузки) Тогда
				
				Отказ = Истина;
				ТекстСообщения = НСтр("ru='Имена файлов загрузки и выгрузки не должны совпадать'");
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
		Иначе // 1000
			
			НепроверяемыеРеквизиты.Добавить("КаталогОбмена");
			НепроверяемыеРеквизиты.Добавить("ИмяФайлаЗагрузки");
			НепроверяемыеРеквизиты.Добавить("ИмяФайлаВыгрузки");
			
		КонецЕсли;
		
	Иначе
		
		НепроверяемыеРеквизиты.Добавить("КаталогВыгрузки");
		НепроверяемыеРеквизиты.Добавить("КаталогЗагрузки");
		НепроверяемыеРеквизиты.Добавить("ИмяФайлаПрайсЛиста");
		НепроверяемыеРеквизиты.Добавить("ИмяЗагружаемогоФайла");
		
		НепроверяемыеРеквизиты.Добавить("КаталогОбмена");
		НепроверяемыеРеквизиты.Добавить("ИмяФайлаЗагрузки");
		НепроверяемыеРеквизиты.Добавить("ИмяФайлаВыгрузки");
		
	КонецЕсли;
	
	УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриОткрытии(ЭтотОбъект, ПодключаемоеОборудование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВерсияФорматаОбменаПриИзменении(Элемент)
	
	НастроитьЭлементыПоВерсииФормата();
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КаталогВыгрузкиНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайла(Оповещение, КаталогВыгрузки, "ВыборКаталога");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КаталогЗагрузкиНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайла(Оповещение, КаталогЗагрузки, "ВыборКаталога");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("КаталогОбменаНачалоВыбораЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.НачатьВыборФайла(Оповещение, КаталогОбмена, "ВыборКаталога");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗначениеПараметров = Новый Структура;
	НовыеЗначениеПараметров.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
	НовыеЗначениеПараметров.Вставить("ВидТранспортаОфлайнОбмена", ВидОбмена);
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		Если ВерсияФорматаОбмена > 2000 Тогда
			
			НовыеЗначениеПараметров.Вставить("КаталогОбмена", 		КаталогОбмена);
			НовыеЗначениеПараметров.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
			НовыеЗначениеПараметров.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
		Иначе
			
			НовыеЗначениеПараметров.Вставить("КаталогВыгрузки"           , КаталогВыгрузки);
			НовыеЗначениеПараметров.Вставить("ИмяФайлаНастроек"          , ИмяФайлаНастроек);
			НовыеЗначениеПараметров.Вставить("ИмяФайлаПрайсЛиста"        , ИмяФайлаПрайсЛиста);
			НовыеЗначениеПараметров.Вставить("КаталогЗагрузки"           , КаталогЗагрузки);
			НовыеЗначениеПараметров.Вставить("ИмяЗагружаемогоФайла"      , ИмяЗагружаемогоФайла);
			НовыеЗначениеПараметров.Вставить("КоличествоЭлементовВПакете", КоличествоЭлементовВПакете);
			
		КонецЕсли;
	Иначе
		НовыеЗначениеПараметров.Вставить("ИдентификаторWebСервисОборудования", ИдентификаторWebСервисОборудования);
		НовыеЗначениеПараметров.Вставить("КоличествоЭлементовВПакете", КоличествоЭлементовВПакете);
	КонецЕсли;
	
	ПараметрыККМ = Новый Структура;
	ПараметрыККМ.Вставить("РазрешеноИспользоватьСкидки", РазрешеноИспользоватьСкидки);
	ПараметрыККМ.Вставить("РазрешеноИспользоватьПлатежныеКарты", РазрешеноИспользоватьПлатежныеКарты);
	
	НовыеЗначениеПараметров.Вставить("ПараметрыДрайвераККМ", ПараметрыККМ);
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор", ПодключаемоеОборудование);
	Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
	
	МенеджерОфлайнОборудованияКлиентПереопределяемый.ФормаНастройкиОфлайнОборудованияПриСохраненииПараметров(
		ЭтотОбъект,
		ПодключаемоеОборудование,
		НовыеЗначениеПараметров
	);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	
	времПараметрыУстройства = Новый Структура;
	времПараметрыУстройства.Вставить("ВерсияФорматаОбмена", ВерсияФорматаОбмена);
	времПараметрыУстройства.Вставить("ВидОбмена", ВидОбмена);
	времПараметрыУстройства.Вставить("ИдентификаторУстройства", ПодключаемоеОборудование);
	
	Если ВидОбмена = ПредопределенноеЗначение("Перечисление.ВидыТранспортаОфлайнОбмена.FILE") Тогда
		
		Если ВерсияФорматаОбмена > 2000 Тогда
			
			времПараметрыУстройства.Вставить("КаталогОбмена", 		КаталогОбмена);
			времПараметрыУстройства.Вставить("ИмяФайлаЗагрузки", 	ИмяФайлаЗагрузки);
			времПараметрыУстройства.Вставить("ИмяФайлаВыгрузки", 	ИмяФайлаВыгрузки);
			
		Иначе
			
			времПараметрыУстройства.Вставить("КаталогВыгрузки"           , КаталогВыгрузки);
			времПараметрыУстройства.Вставить("ИмяФайлаНастроек"          , ИмяФайлаНастроек);
			времПараметрыУстройства.Вставить("ИмяФайлаПрайсЛиста"        , ИмяФайлаПрайсЛиста);
			времПараметрыУстройства.Вставить("КаталогЗагрузки"           , КаталогЗагрузки);
			времПараметрыУстройства.Вставить("ИмяЗагружаемогоФайла"      , ИмяЗагружаемогоФайла);
			времПараметрыУстройства.Вставить("КоличествоЭлементовВПакете", КоличествоЭлементовВПакете);
			
		КонецЕсли;
		
	Иначе
		времПараметрыУстройства.Вставить("ИдентификаторWebСервисОборудования", ИдентификаторWebСервисОборудования);
	КонецЕсли;
	
	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду(
		"ТестУстройства",
		ВходныеПараметры,
		ВыходныеПараметры,
		ПодключаемоеОборудование,
		времПараметрыУстройства
	);
	
	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
		И ВыходныеПараметры.Количество() >= 2,
		НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
		""
	);
	
	Если Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ПереводСтроки%",
			?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС)
		);
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ДополнительноеОписание%",
			?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание)
		);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ПереводСтроки%",
			?(ПустаяСтрока(ДополнительноеОписание), "", Символы.ПС)
		);
		
		ТекстСообщения = СтрЗаменить(
			ТекстСообщения,
			"%ДополнительноеОписание%",
			?(ПустаяСтрока(ДополнительноеОписание), "", ДополнительноеОписание)
		);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		КаталогВыгрузки = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогЗагрузкиНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		КаталогЗагрузки = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогОбменаНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		КаталогОбмена = Результат[0];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыПоВерсииФормата()
	
	Если НЕ ЗначениеЗаполнено(ВерсияФорматаОбмена) Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПустая;
		Возврат;
	КонецЕсли;
	
	Если ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.FILE Тогда
		
		Если ВерсияФорматаОбмена >= 2000 Тогда
			
			Элементы.СтраницаФормат2000.Видимость = Истина;
			
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаФормат2000;
			
			Элементы.СтраницаФормат1000.Видимость = Ложь;
		Иначе
			
			Элементы.СтраницаФормат1000.Видимость = Истина;
			
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаФормат1000;
			
			Элементы.СтраницаФормат2000.Видимость = Ложь;
		КонецЕсли;
		
	ИначеЕсли ВидОбмена = Перечисления.ВидыТранспортаОфлайнОбмена.WS Тогда
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаWebСервис;
		
		Элементы.СтраницаФормат2000.Видимость = Ложь;
		Элементы.СтраницаФормат1000.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ПодключаемоеОборудование.ТипОфлайнОборудования = Перечисления.ТипыОфлайнОборудования.ККМ Тогда
		Элементы.ПараметрыККМ.Видимость = Истина;
	Иначе
		Элементы.ПараметрыККМ.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьНепроверяемыеРеквизитыИзМассива(МассивРеквизитов, МассивНепроверяемыхРеквизитов)
	
	Для Каждого ЭлементМассива Из МассивНепроверяемыхРеквизитов Цикл
	
		ПорядковыйНомер = МассивРеквизитов.Найти(ЭлементМассива);
		Если ПорядковыйНомер <> Неопределено Тогда
			МассивРеквизитов.Удалить(ПорядковыйНомер);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбменаПриИзменении(Элемент)
	
	НастроитьЭлементыПоВерсииФормата();
	
КонецПроцедуры

#КонецОбласти