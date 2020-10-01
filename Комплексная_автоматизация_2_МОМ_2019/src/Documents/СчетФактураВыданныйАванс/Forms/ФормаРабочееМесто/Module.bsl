
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьЗначенияПоУмолчанию();
	УстановитьЗначенияПоПараметрамФормы(Параметры);
	
	ПриИзмененииОтбора();
	
	ТаблицаНеиспользуемыеСчетаФактуры.Параметры.УстановитьЗначениеПараметра("НеиспользуемыеСчетаФактуры", Новый Массив);
	
	ИспользоватьЗаказыКлиентов = ПолучитьФункциональнуюОпцию("ИспользоватьЗаказыКлиентов");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МассивМенеджеровРасчетаСмТакжеВРаботе = Новый Массив();
	МассивМенеджеровРасчетаСмТакжеВРаботе.Добавить("Обработка.ЖурналДокументовНДС");
	СмТакжеВРаботе = ОбщегоНазначенияУТ.СформироватьГиперссылкуСмТакжеВРаботе(МассивМенеджеровРасчетаСмТакжеВРаботе, Неопределено);
	
	Если Параметры.Свойство("ЗаполнитьПриОткрытии") Тогда
		ЗаполнитьПолученныеАвансыНаСервере();
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "ЭлектронныеДокументы"
	Если ИмяСобытия = "ОбновитьСостояниеЭД" Тогда
		Элементы.ПолученныеАвансы.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ПриИзмененииОтбора()
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОтбора()
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПолученныеАвансыСтавкаНДСПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПолученныеАвансы.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученныеАвансыСуммаАвансаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПолученныеАвансы.ТекущиеДанные;
	
	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
	ТекущаяСтрока.ВалютнаяСумма = ТекущаяСтрока.Сумма;
	
	// Проверим валюту, если она отличается от валюты регл. учета, то пересчитаем суммы
	ВалютаДанных = ТекущаяСтрока.ВалютаДокумента;
	Если ЗначениеЗаполнено(ВалютаДанных)
		И ВалютаДанных <> ВалютаРеглУчета Тогда
		
		ПолученныеАвансыСуммаАвансаПриИзмененииСервер(
			ВалютаРеглУчета,
			ВалютаДанных,
			ТекущаяСтрока.ДатаДокументаОснования,
			ТекущаяСтрока.Сумма,
			ТекущаяСтрока.ВалютнаяСумма);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученныеАвансыВалютнаяСуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПолученныеАвансы.ТекущиеДанные;
	
	ТекущаяСтрока.Сумма = ТекущаяСтрока.ВалютнаяСумма;
	
	// Проверим валюту, если она отличается от валюты регл. учета, то пересчитаем суммы
	ВалютаДанных = ТекущаяСтрока.ВалютаДокумента;
	Если ЗначениеЗаполнено(ВалютаДанных)
		И ВалютаДанных <> ВалютаРеглУчета Тогда
		
		ПолученныеАвансыВалютнаяСуммаПриИзмененииСервер(
			ВалютаРеглУчета,
			ВалютаДанных,
			ТекущаяСтрока.ДатаДокументаОснования, 
			ТекущаяСтрока.ВалютнаяСумма,
			ТекущаяСтрока.Сумма);
	КонецЕсли; 

	СтруктураПересчетаСуммы = ПересчетСуммыНДСВСтрокеТЧ();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученныеАвансыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если (Поле = Элементы.ПолученныеАвансыСчетФактура ИЛИ Поле.Родитель = Элементы.ПолученныеАвансыГруппаСФ) Тогда
		
		ТекущийСчетФактура = Элемент.ТекущиеДанные.СчетФактура;
		Если ЗначениеЗаполнено(ТекущийСчетФактура) Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(Неопределено, ТекущийСчетФактура);
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НеиспользуемыеСчетаФактурыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущийДокумент = Элемент.ТекущиеДанные.СчетФактура;
	
	Если ЗначениеЗаполнено(ТекущийДокумент) Тогда
		ПоказатьЗначение(Неопределено, ТекущийДокумент);
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", НачалоПериода, КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПолученныеАвансы(Команда)
	
	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ЗаполнитьПолученныеАвансыНаСервере();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСчетаФактуры(Команда)
	
	ФормированиеСчетовФактур();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНеиспользуемыеСчетаФактуры(Команда)
	
	УдалитьНеиспользуемыеСчетаФактурыСервер();	
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСчетФактуру(Команда)
	
	ДанныеАванса = Элементы.ПолученныеАвансы.ТекущиеДанные;
	
	Если ДанныеАванса = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Необходимо выбрать полученный аванс!'"));
	Иначе
		ФормированиеСчетовФактур(ДанныеАванса.ПолучитьИдентификатор())
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДС18_118(Команда)
	
	Если СтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118") Тогда
		УстановитьСтавкуНДС("18%");
	Иначе
		УстановитьСтавкуНДС("20%");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДС10_110(Команда)
	
	УстановитьСтавкуНДС("10%");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтветственного(Команда)
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("РеквизитИмя", "Ответственный");
	ПараметрыОбработки.Вставить("РеквизитТип", "Справочник.Пользователи");
	ПараметрыОбработки.Вставить("РежимВыбора", Истина);
	
	УстановитьРеквизит(ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПодразделение(Команда)
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("РеквизитИмя", "Подразделение");
	ПараметрыОбработки.Вставить("РеквизитТип", "Справочник.СтруктураПредприятия");
	ПараметрыОбработки.Вставить("Отбор", Новый Структура("Организация", Организация));
	
	УстановитьРеквизит(ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРуководителя(Команда)
	
	СтруктураОтбора = Новый Структура("Владелец,ОтветственноеЛицо",
		Организация, ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.Руководитель"));
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("РеквизитИмя", "Руководитель");
	ПараметрыОбработки.Вставить("РеквизитТип", "Справочник.ОтветственныеЛицаОрганизаций");
	ПараметрыОбработки.Вставить("Отбор", СтруктураОтбора);
	
	УстановитьРеквизит(ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьГлавногоБухгалтера(Команда)
	
	СтруктураОтбора = Новый Структура("Владелец,ОтветственноеЛицо",
		Организация, ПредопределенноеЗначение("Перечисление.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер"));
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("РеквизитИмя", "ГлавныйБухгалтер");
	ПараметрыОбработки.Вставить("РеквизитТип", "Справочник.ОтветственныеЛицаОрганизаций");
	ПараметрыОбработки.Вставить("Отбор", СтруктураОтбора);
	
	УстановитьРеквизит(ПараметрыОбработки);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Для Каждого СтрокаАванса Из ПолученныеАвансы Цикл
		СтрокаАванса.Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Исключить(Команда)
	
	Для Каждого СтрокаАванса Из ПолученныеАвансы Цикл
		СтрокаАванса.Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенные(Команда)
	
	Для Каждого СтрокаАванса Из Элементы.ПолученныеАвансы.ВыделенныеСтроки Цикл
		Элементы.ПолученныеАвансы.ДанныеСтроки(СтрокаАванса).Выбран = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенные(Команда)
	
	Для Каждого СтрокаАванса Из Элементы.ПолученныеАвансы.ВыделенныеСтроки Цикл
		Элементы.ПолученныеАвансы.ДанныеСтроки(СтрокаАванса).Выбран = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ПолученныеАвансы);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ПолученныеАвансы, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ПолученныеАвансы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура СмТакжеВРаботеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ИмяКлючевойОперации = СтрШаблон("Обработка.СчетФактураВыданныйАванс.Форма.ФормаРабочееМесто.СмТакже.%1",
									НавигационнаяСсылкаФорматированнойСтроки);
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, ИмяКлючевойОперации);
	
	СтандартнаяОбработка = Ложь;
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	СтруктураБыстрогоОтбора = Новый Структура;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураБыстрогоОтбора.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("Организация", Организация);
	КонецЕсли;
	
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
	Период = Новый СтандартныйПериод;
	Период.ДатаНачала = НачалоПериода;
	Период.ДатаОкончания = КонецПериода;
	СтруктураБыстрогоОтбора.Вставить("Период", Период);
	СтруктураБыстрогоОтбора.Вставить("НачалоПериода", ?(ЗначениеЗаполнено(Период.ДатаНачала), Период.ДатаНачала, НачалоКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("НачалоПериода", СтруктураБыстрогоОтбора.НачалоПериода);
	СтруктураБыстрогоОтбора.Вставить("КонецПериода", ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, КонецКвартала(ТекущаяДата)));
	ПараметрыФормы.Вставить("КонецПериода", СтруктураБыстрогоОтбора.КонецПериода);
	
	ПараметрыФормы.Вставить("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОткрытьФорму(НавигационнаяСсылкаФорматированнойСтроки, ПараметрыФормы,ЭтаФорма, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервереБезКонтекста
Процедура ПолученныеАвансыСуммаАвансаПриИзмененииСервер(ВалютаРеглУчета, ВалютаДанных, ДатаДокументаОснования, Сумма, ВалютнаяСумма)
	
	СтруктураКурсаРегл = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРеглУчета, ДатаДокументаОснования);
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДанных, ДатаДокументаОснования);
	ВалютнаяСумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		Сумма,
		СтруктураКурсаРегл,
		СтруктураКурса);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолученныеАвансыВалютнаяСуммаПриИзмененииСервер(ВалютаРеглУчета, ВалютаДанных, ДатаДокументаОснования, ВалютнаяСумма, Сумма)
	
	СтруктураКурсаРегл = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаРеглУчета, ДатаДокументаОснования);
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаДанных, ДатаДокументаОснования);
	Сумма = РаботаСКурсамиВалютКлиентСервер.ПересчитатьПоКурсу(
		ВалютнаяСумма,
		СтруктураКурсаРегл,
		СтруктураКурса);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтбора()
	
	УстановитьПравилоОтбораПолученныхАвансов();
	ОбновитьТекстКомандыУстановкиСтавкиНДС();
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеФормы

&НаСервере
Процедура ЗаполнитьПолученныеАвансыНаСервере()
	
	Если Не ПолучитьФункциональнуюОпцию("НоваяАрхитектураВзаиморасчетов") Тогда
		//Актуализация расчетов с клиентами
		АналитикиРасчета = РаспределениеВзаиморасчетовВызовСервера.АналитикиРасчета();
		РаспределениеВзаиморасчетовВызовСервера.РаспределитьВсеРасчетыСКлиентами(КонецПериода, АналитикиРасчета);
	КонецЕсли;
	
	ПолученныеАвансы.Очистить();
	
	// Получим список счетов-фактур
	ЗаполнитьАвансы();
	
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьАвансы()
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ОтборАвансов = Документы.СчетФактураВыданныйАванс.ОтборПолученныхАвансов();
	ЗаполнитьЗначенияСвойств(ОтборАвансов,ЭтаФорма);
	
	РасчетныеДокументыБезСчетаФактуры = Новый Массив;
	
	Документы.СчетФактураВыданныйАванс.ЗаполнитьПолученныеАвансыДляСФ(ОтборАвансов, ПолученныеАвансы, РасчетныеДокументыБезСчетаФактуры);
	
	ЗаполнитьНеиспользуемыеСчетаФактуры();
	
	// Сообщим пользователю, что есть расчетные документы по которым не получилось сформировать счет-фактуру.
	Для каждого ЭлКоллекции Из РасчетныеДокументыБезСчетаФактуры Цикл
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Для документа не предусмотрена регистрация счета-фактуры: %1'"), ЭлКоллекции);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭлКоллекции);
	КонецЦикла; 
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНеиспользуемыеСчетаФактуры()
	
	НеиспользуемыеСчетаФактуры.Очистить();
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	СчетФактураВыданныйАванс.Ссылка КАК Ссылка,
	|	СчетФактураВыданныйАванс.ДокументОснование,
	|	СчетФактураВыданныйАванс.Контрагент
	|ИЗ
	|	Документ.СчетФактураВыданныйАванс КАК СчетФактураВыданныйАванс
	|ГДЕ
	|	СчетФактураВыданныйАванс.Организация = &Организация
	|	И СчетФактураВыданныйАванс.Дата МЕЖДУ &НачалоПериода И &КонецПериода
	|	И НЕ СчетФактураВыданныйАванс.ПометкаУдаления
	|	И НЕ СчетФактураВыданныйАванс.Исправление
	|	И СчетФактураВыданныйАванс.ПравилоОтбораАванса <> ЗНАЧЕНИЕ(Перечисление.ПорядокРегистрацииСчетовФактурНаАванс.ВсеОплаты)
	|";
	 
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецДня(КонецПериода));
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ПараметрыОтбора = Новый Структура("ДокументОснование,Контрагент", Выборка.ДокументОснование, Выборка.Контрагент);
		Если ПолученныеАвансы.НайтиСтроки(ПараметрыОтбора).Количество() = 0 Тогда
			НоваяСтрока = НеиспользуемыеСчетаФактуры.Добавить(Выборка.Ссылка);
		КонецЕсли; 
	КонецЦикла;
	
	ТаблицаНеиспользуемыеСчетаФактуры.Параметры.УстановитьЗначениеПараметра("НеиспользуемыеСчетаФактуры", НеиспользуемыеСчетаФактуры.ВыгрузитьЗначения());
	УстановитьЗаголовокНеиспользуемыеСчетаФактуры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаДанныхФормы

&НаКлиенте
Процедура ФормированиеСчетовФактур(ТекущийАванс = Неопределено)
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущийАванс = Неопределено Тогда
		Результат = СформироватьСчетаФактурыСервер()
	Иначе
		Результат = СформироватьСчетаФактурыСервер(ТекущийАванс, Истина);
	КонецЕсли;
	
	ПоказатьОповещениеПользователя(НСтр("ru = 'Завершено формирование с/ф на аванс'"));
	ОповеститьОбИзменении(Тип("ДокументСсылка.СчетФактураВыданныйАванс"));
	
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'При формировании счетов-фактур возникли ошибки. Подробнее см. в журнале регистрации.'"));
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Функция СформироватьСчетаФактурыСервер(ДанныеСчетФактуры = Неопределено, ОбновитьБезусловно = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПолученныеАвансы.СФсформирован,
	|	ПолученныеАвансы.Контрагент,
	|	ПолученныеАвансы.Сумма,
	|	ПолученныеАвансы.СтавкаНДС,
	|	ПолученныеАвансы.НаправлениеДеятельности,
	|	ПолученныеАвансы.СуммаНДС,
	|	ПолученныеАвансы.ДокументОснование,
	|	ПолученныеАвансы.ДатаВыписки,
	|	ПолученныеАвансы.ВалютаДокумента,
	|	ПолученныеАвансы.ВалютнаяСумма,
	|	ПолученныеАвансы.СуммаСчетаФактуры,
	|	ПолученныеАвансы.СчетФактура,
	|	ПолученныеАвансы.Ответственный,
	|	ПолученныеАвансы.Подразделение,
	|	ПолученныеАвансы.Руководитель,
	|	ПолученныеАвансы.ГлавныйБухгалтер
	|ПОМЕСТИТЬ ТаблицаАвансы
	|ИЗ
	|	&ПолученныеАвансы КАК ПолученныеАвансы
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПолученныеАвансы.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////1
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	МАКСИМУМ(ИсторияКППКонтрагентов.Период) КАК Период,
	|	ИсторияКППКонтрагентов.Ссылка           КАК Ссылка
	|ПОМЕСТИТЬ ЗначенияКПП
	|ИЗ
	|	Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаАвансы КАК ТаблицаАвансы
	|	ПО ИсторияКППКонтрагентов.Ссылка = ТаблицаАвансы.Контрагент
	|		И ИсторияКППКонтрагентов.Период <= ТаблицаАвансы.ДатаВыписки
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсторияКППКонтрагентов.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////2
	|
	|ВЫБРАТЬ
	|	ИсторияКППКонтрагентов.КПП    КАК КПП,
	|	ИсторияКППКонтрагентов.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ИсторическоеЗначениеКПП
	|ИЗ
	|	ЗначенияКПП КАК ЗначенияКПП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты.ИсторияКПП КАК ИсторияКППКонтрагентов
	|		ПО ЗначенияКПП.Ссылка = ИсторияКППКонтрагентов.Ссылка
	|			И ЗначенияКПП.Период = ИсторияКППКонтрагентов.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////3
	|
	|ВЫБРАТЬ
	|	ТаблицаАвансы.СФсформирован,
	|	ТаблицаАвансы.Контрагент                                                         КАК Контрагент,
	|	ТаблицаАвансы.Контрагент.ЮрФизЛицо                                               КАК ЮрФизЛицо,
	|	ЕСТЬNULL(ЕСТЬNULL(ИсторическоеЗначениеКПП.КПП, Контрагенты.КПП), """")           КАК КППКонтрагента,
	|	ЕСТЬNULL(Контрагенты.ИНН, """")                                                  КАК ИННКонтрагента,
	|	ТаблицаАвансы.Сумма                                                              КАК Сумма,
	|	ТаблицаАвансы.СтавкаНДС,
	|	ТаблицаАвансы.НаправлениеДеятельности,
	|	ТаблицаАвансы.СуммаНДС,
	|	ТаблицаАвансы.ДокументОснование                                                  КАК ДокументОснование,
	|	&ИдентификаторГосКонтракта                                                       КАК ИдентификаторГосКонтракта,
	|	ТаблицаАвансы.ДатаВыписки,
	|	ТаблицаАвансы.ВалютаДокумента,
	|	ТаблицаАвансы.ВалютнаяСумма,
	|	ТаблицаАвансы.СуммаСчетаФактуры                                                  КАК СуммаСчетаФактуры,
	|	ТаблицаАвансы.СчетФактура,
	|	ТаблицаАвансы.Ответственный,
	|	ТаблицаАвансы.Подразделение,
	|	ТаблицаАвансы.Руководитель,
	|	ТаблицаАвансы.ГлавныйБухгалтер,
	|	ЕСТЬNULL(ВводОстатков.НомерРасчетногоДокумента, ДанныеПервичныхДокументов.Номер) КАК НомерПлатежноРасчетногоДокумента,
	|	ЕСТЬNULL(ВводОстатков.ДатаРасчетногоДокумента, ДанныеПервичныхДокументов.Дата)   КАК ДатаПлатежноРасчетногоДокумента
	|ИЗ
	|	ТаблицаАвансы КАК ТаблицаАвансы
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Документ.ВводОстатков.РасчетыСПартнерами КАК ВводОстатков
	|	ПО
	|		ТаблицаАвансы.ДокументОснование = ВводОстатков.Ссылка
	|		И ТаблицаАвансы.Контрагент = ВводОстатков.Контрагент
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ДанныеПервичныхДокументов КАК ДанныеПервичныхДокументов
	|	ПО
	|		ДанныеПервичныхДокументов.Организация = &Организация
	|		И ТаблицаАвансы.ДокументОснование = ДанныеПервичныхДокументов.Документ
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|			ПО Контрагенты.Ссылка = ТаблицаАвансы.Контрагент
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИсторическоеЗначениеКПП КАК ИсторическоеЗначениеКПП
	|			ПО ИсторическоеЗначениеКПП.Ссылка = Контрагенты.Ссылка
	|
	|	
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаАвансы.ДатаВыписки,
	|	ТаблицаАвансы.Контрагент,
	|	ТаблицаАвансы.ДокументОснование
	|
	|ИТОГИ
	|	СУММА(Сумма),
	|	СУММА(СуммаСчетаФактуры),
	|	МАКСИМУМ(СчетФактура),
	|	МАКСИМУМ(Ответственный),
	|	МАКСИМУМ(Подразделение),
	|	МАКСИМУМ(Руководитель),
	|	МАКСИМУМ(ГлавныйБухгалтер),
	|	МАКСИМУМ(ДатаВыписки),
	|	МАКСИМУМ(НомерПлатежноРасчетногоДокумента),
	|	МАКСИМУМ(ДатаПлатежноРасчетногоДокумента),
	|	МАКСИМУМ(ИдентификаторГосКонтракта)
	|ПО
	|	ДокументОснование, 
	|	Контрагент
	|";
	
	//++ НЕ УТ
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&ИдентификаторГосКонтракта",
		"ВЫРАЗИТЬ(ТаблицаАвансы.ДокументОснование КАК Документ.ПоступлениеБезналичныхДенежныхСредств).БанковскийСчет.ГосударственныйКонтракт.Код");
	//-- НЕ УТ
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, 
		"&ИдентификаторГосКонтракта",
		"НЕОПРЕДЕЛЕНО");
	
	Если ДанныеСчетФактуры <> Неопределено Тогда
		Строка = ПолученныеАвансы.НайтиПоИдентификатору(ДанныеСчетФактуры);
		Отбор = Новый Структура("ДокументОснование", Строка.ДокументОснование);
	Иначе
		Отбор = Новый Структура("Выбран", Истина);
	КонецЕсли;
	СтрокиАвансов = ПолученныеАвансы.НайтиСтроки(Отбор);
	Запрос.УстановитьПараметр("ПолученныеАвансы", ПолученныеАвансы.Выгрузить(СтрокиАвансов));
	Запрос.УстановитьПараметр("Организация",      Организация);
	
	ТаблицаОбработанных = Новый ТаблицаЗначений;
	ТаблицаОбработанных.Колонки.Добавить("ДокументОснование");
	ТаблицаОбработанных.Колонки.Добавить("Контрагент");
	ТаблицаОбработанных.Колонки.Добавить("ПараметрыСчетаФактуры");
	
	ТаблицаВозниклиОшибки = Новый ТаблицаЗначений;
	ТаблицаВозниклиОшибки.Колонки.Добавить("ДокументОснование");
	ТаблицаВозниклиОшибки.Колонки.Добавить("Контрагент");
	ТаблицаВозниклиОшибки.Колонки.Добавить("ТекстСообщения");
	
	ВыборкаДокументОснование = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументОснование.Следующий() Цикл
		ВыборкаКонтрагент = ВыборкаДокументОснование.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаКонтрагент.Следующий() Цикл
			ДатаСчетаФактуры = КонецДня(ВыборкаДокументОснование.ДатаВыписки);
			Если Не ЗначениеЗаполнено(ВыборкаКонтрагент.СчетФактура) Тогда
				СчетФактураОбъект = Документы.СчетФактураВыданныйАванс.СоздатьДокумент();
				СчетФактураОбъект.Организация = Организация;
				ВерсияКодовВидовОпераций = УчетНДСКлиентСервер.ВерсияКодовВидовОпераций(ДатаСчетаФактуры);
				Если ВерсияКодовВидовОпераций >= 3 И ТипЗнч(ВыборкаДокументОснование.ДокументОснование) = Тип("ДокументСсылка.ОперацияПоПлатежнойКарте")
					И ВыборкаКонтрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
					
					СчетФактураОбъект.КодВидаОперации = "26";
				Иначе
					СчетФактураОбъект.КодВидаОперации = "02";
				КонецЕсли;
			Иначе
				СчетФактураОбъект = ВыборкаКонтрагент.СчетФактура.ПолучитьОбъект();
			КонецЕсли; 
			
			ЗаполнитьЗначенияСвойств(СчетФактураОбъект, ВыборкаКонтрагент);
			СчетФактураОбъект.Дата = ДатаСчетаФактуры;
			СчетФактураОбъект.ДатаВыставления = ДатаСчетаФактуры;
			СчетФактураОбъект.ПравилоОтбораАванса = ПравилоОтбораАванса;
			
			Выборка = ВыборкаКонтрагент.Выбрать();
			ПараметрыСчетаФактуры = Новый Соответствие;
			
			Если ВыборкаКонтрагент.Сумма <> ВыборкаКонтрагент.СуммаСчетаФактуры ИЛИ ОбновитьБезусловно Тогда
				СчетФактураОбъект.Авансы.Очистить();
				Пока Выборка.Следующий() Цикл
					НоваяСтрокаАванса = СчетФактураОбъект.Авансы.Добавить();
					НоваяСтрокаАванса.ТипЗапасов              = Перечисления.ТипыЗапасов.Товар;
					НоваяСтрокаАванса.Сумма                   = Выборка.Сумма;
					НоваяСтрокаАванса.СтавкаНДС               = Выборка.СтавкаНДС;
					НоваяСтрокаАванса.СуммаНДС                = Выборка.СуммаНДС;
					НоваяСтрокаАванса.НаправлениеДеятельности = Выборка.НаправлениеДеятельности;
					
					ПараметрыСчетаФактуры.Вставить(НоваяСтрокаАванса.СтавкаНДС, Выборка.Сумма);
				КонецЦикла; 
			КонецЕсли;
			
			Выборка.Сбросить();
			Если Выборка.Следующий() Тогда
				СчетФактураОбъект.ИННКонтрагента = Выборка.ИННКонтрагента;
				СчетФактураОбъект.КППКонтрагента = Выборка.КППКонтрагента;
			КонецЕсли;
			
			Если ИспользоватьЗаказыКлиентов Тогда
				// Заполним товары счета-фактуры по заказам
				Товары = Документы.СчетФактураВыданныйАванс.ТоварыЗаказовКлиентов(СчетФактураОбъект.ДокументОснование);
				Если Товары.Количество() <> 0 Тогда
					ТаблицаАвансы = СчетФактураОбъект.Авансы.Выгрузить();
					Документы.СчетФактураВыданныйАванс.РаспределитьАвансыПоТоварам(ТаблицаАвансы, Товары, СчетФактураОбъект.ДокументОснование);
					СчетФактураОбъект.Авансы.Загрузить(ТаблицаАвансы);
				КонецЕсли;
			КонецЕсли;
		
			// Дозаполним остальные реквизиты документа
			СчетФактураОбъект.Заполнить(Неопределено);
			
			// Заполним отдельные реквизиты, так, как указали в рабочем месте.
			ЗаполнитьЗначенияСвойств(СчетФактураОбъект, ВыборкаКонтрагент, "Ответственный,Подразделение,Руководитель,ГлавныйБухгалтер");
			
			// Проведем счет-фактуру
			Попытка
				СчетФактураОбъект.Записать(РежимЗаписиДокумента.Проведение);
				ПараметрыСчетаФактуры.Вставить("СчетФактура", СчетФактураОбъект.Ссылка);
				
				НоваяСтрока = ТаблицаОбработанных.Добавить();
				НоваяСтрока.ДокументОснование = ВыборкаКонтрагент.ДокументОснование;
				НоваяСтрока.Контрагент = ВыборкаКонтрагент.Контрагент;
				НоваяСтрока.ПараметрыСчетаФактуры = ПараметрыСчетаФактуры;
				
			Исключение
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось выполнить по причине %1'"),
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Формирование счетов-фактур на аванс.'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					УровеньЖурналаРегистрации.Ошибка, , , ТекстСообщения); 
					
				НоваяСтрока = ТаблицаВозниклиОшибки.Добавить();
				НоваяСтрока.ДокументОснование = ВыборкаКонтрагент.ДокументОснование;
				НоваяСтрока.Контрагент = ВыборкаКонтрагент.Контрагент;
				НоваяСтрока.ТекстСообщения = ТекстСообщения;
				
			КонецПопытки;
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаОбработанных.Индексы.Добавить("ДокументОснование, Контрагент");
	ТаблицаВозниклиОшибки.Индексы.Добавить("ДокументОснование, Контрагент");
	
	// Обновим сведения о счетах-фактурах
	Если ДанныеСчетФактуры <> Неопределено Тогда
		Строка = ПолученныеАвансы.НайтиПоИдентификатору(ДанныеСчетФактуры);
		ОбновитьДанныеОСчетахФактурахВСтроке(Строка, ТаблицаОбработанных, ТаблицаВозниклиОшибки);
	Иначе
		Для каждого Строка Из ПолученныеАвансы Цикл
			ОбновитьДанныеОСчетахФактурахВСтроке(Строка, ТаблицаОбработанных, ТаблицаВозниклиОшибки);
		КонецЦикла;
	КонецЕсли;
	
	Результат = (ТаблицаВозниклиОшибки.Количество() = 0);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОбновитьДанныеОСчетахФактурахВСтроке(Строка, ТаблицаОбработанных,  ТаблицаВозниклиОшибки)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ДокументОснование", Строка.ДокументОснование);
	Отбор.Вставить("Контрагент",        Строка.Контрагент);
	
	РезультатПоискаОбработанных = ТаблицаОбработанных.НайтиСтроки(Отбор);
	РезультатПоискаОшибки = ТаблицаВозниклиОшибки.НайтиСтроки(Отбор);
	
	Если РезультатПоискаОбработанных.Количество() <> 0 Тогда
		Строка.СФсформирован = Истина;
		ПараметрыСчетаФактуры = РезультатПоискаОбработанных[0].ПараметрыСчетаФактуры;
		Если ПараметрыСчетаФактуры[Строка.СтавкаНДС] <> Неопределено Тогда
			Строка.СуммаСчетаФактуры = ПараметрыСчетаФактуры[Строка.СтавкаНДС];
		КонецЕсли;
		Строка.СчетФактура = ПараметрыСчетаФактуры["СчетФактура"];
	ИначеЕсли РезультатПоискаОшибки.Количество() <> 0 Тогда
		Строка.СФсформирован = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция УдалитьНеиспользуемыеСчетаФактурыСервер()
	
	Для каждого ДанныеСчетФактуры Из НеИспользуемыеСчетаФактуры Цикл
		ДокументОбъект = ДанныеСчетФактуры.Значение.ПолучитьОбъект();
		ДокументОбъект.УстановитьПометкуУдаления(Истина);
	КонецЦикла; 
	
	ЗаполнитьНеиспользуемыеСчетаФактуры();
	
КонецФункции	

#КонецОбласти

#Область Оформление

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПолученныеАвансыСтавкаНДС.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПолученныеАвансыСуммаНДС.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПолученныеАвансы.СФсформирован");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Указано в СФ'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПолученныеАвансыКонтрагент.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПолученныеАвансы.Контрагент");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Указано в СФ'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	НачалоПериода = НачалоКвартала(ТекущаяДатаСеанса());
	КонецПериода = КонецКвартала(ТекущаяДатаСеанса());
	
	Если НЕ ЗначениеЗаполнено(СтавкаНДС) Тогда
		СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(НачалоПериода, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	ЗаголовокОтчета = НСтр("ru='Учет НДС с полученных авансов'")
		+ БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(Форма.НачалоПериода, Форма.КонецПериода);
	
	Форма.Заголовок = ЗаголовокОтчета;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтаФорма, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ПриИзмененииОтбора();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура УстановитьСтавкуНДС(ТекстСтавкаНДС)
	
	Если Элементы.ПолученныеАвансы.ВыделенныеСтроки.Количество() = 0 Тогда
		// Пользователь не выбрал строки
		Возврат;
	КонецЕсли; 
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='В выбранных строках будет установлена ставка НДС ""%1"". Продолжить?'"),
		ТекстСтавкаНДС);
		
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтавкуНДСЗавершение", ЭтотОбъект, Новый Структура("ТекстСтавкаНДС", ТекстСтавкаНДС)), ТекстВопроса,РежимДиалогаВопрос.ДаНет); 
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтавкуНДСЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекстСтавкаНДС = ДополнительныеПараметры.ТекстСтавкаНДС;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекстСтавкаНДС = "10%" Тогда
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС10_110")
	ИначеЕсли ТекстСтавкаНДС = "18%" Тогда
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС18_118")
	Иначе
		ТекСтавкаНДС = ПредопределенноеЗначение("Перечисление.СтавкиНДС.НДС20_120")
	КонецЕсли;
	
	ТекПроцентНДС = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(ТекСтавкаНДС);
	Для каждого ИндексСтроки Из Элементы.ПолученныеАвансы.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ПолученныеАвансы.ДанныеСтроки(ИндексСтроки);
		Если ДанныеСтроки.СтавкаНДС <> ТекСтавкаНДС Тогда
			ДанныеСтроки.СтавкаНДС = ТекСтавкаНДС;
			ДанныеСтроки.СуммаНДС = УчетНДСУПКлиентСервер.РассчитатьСуммуНДС(ДанныеСтроки.Сумма, ТекПроцентНДС, Истина);
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРеквизит(ПараметрыОбработки)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьРеквизитЗавершение", ЭтотОбъект, ПараметрыОбработки);
	ОткрытьФорму(ПараметрыОбработки.РеквизитТип + ".ФормаВыбора", ПараметрыОбработки, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРеквизитЗавершение(Результат, ДополнительныеПарметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ИндексСтроки Из Элементы.ПолученныеАвансы.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ПолученныеАвансы.ДанныеСтроки(ИндексСтроки);
		Если ДанныеСтроки[ДополнительныеПарметры.РеквизитИмя] <> Результат Тогда
			ДанныеСтроки[ДополнительныеПарметры.РеквизитИмя] = Результат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПересчетСуммыНДСВСтрокеТЧ()

	СтруктураЗаполненияЦены = Новый Структура;
	СтруктураЗаполненияЦены.Вставить("ЦенаВключаетНДС", Истина);
	
	Возврат СтруктураЗаполненияЦены;

КонецФункции

&НаСервере
Процедура УстановитьПравилоОтбораПолученныхАвансов()
	
	// Получим значение из учетной политики
	ПравилоОтбораАванса = УчетнаяПолитика.ПравилоОтбораАвансовДляРегистрацииСчетовФактур(Организация, КонецПериода);
	
	// Сформируем список выбора с учетом выбранного периода
	СписокВыборка = Элементы.ПравилаОтборПолученныхАвансов.СписокВыбора;
	СписокВыборка.Очистить();
	
	СписокВыборка.Добавить(Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеДня);
	
	Если НачалоДня(КонецПериода) - НачалоДня(НачалоПериода) >= 5 * 86400 Тогда
		СписокВыборка.Добавить(Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеПятиДней);
	КонецЕсли;
	
	Если КонецДня(КонецПериода) = КонецМесяца(КонецПериода) Тогда
		СписокВыборка.Добавить(Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеМесяца);
	КонецЕсли;
	
	Если КонецДня(КонецПериода) = КонецКвартала(КонецПериода) Тогда
		СписокВыборка.Добавить(Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеНалоговогоПериода);
	КонецЕсли;
	
	Если СписокВыборка.НайтиПоЗначению(ПравилоОтбораАванса) = Неопределено Тогда
		ПравилоОтбораАванса = Перечисления.ПорядокРегистрацииСчетовФактурНаАванс.КромеЗачтенныхВТечениеДня;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекстКомандыУстановкиСтавкиНДС()
	
	СтавкаНДС = УчетНДСУП.СтавкаНДСПоУмолчанию(НачалоПериода, Истина);
	Если СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118 Тогда
		Элементы.УстановитьСтавкуНДС18.Заголовок = НСтр("ru = '18% / 118%'");
	Иначе
		Элементы.УстановитьСтавкуНДС18.Заголовок = НСтр("ru = '20% / 120%'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначенияПоПараметрамФормы(Параметры)
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("НачалоПериода", НачалоПериода);
		СтруктураБыстрогоОтбора.Свойство("КонецПериода", КонецПериода);
		СтруктураБыстрогоОтбора.Свойство("ПравилоОтбораАванса", ПравилоОтбораАванса);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Параметры.Свойство("ОтображатьСтраницуКОформлению") Тогда
		Элементы.ГруппаСтраницыАвансыПолученные.ТекущаяСтраница = Элементы.ФормированиеСчетовФактурНаАванс;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокНеиспользуемыеСчетаФактуры()
	
	Если НеиспользуемыеСчетаФактуры.Количество() = 0 Тогда
		ТекстЗаголовка = НСтр("ru = 'Неиспользуемые счета-фактуры'");
	Иначе
		ТекстЗаголовка = СтрШаблон(
			НСтр("ru = 'Неиспользуемые счета-фактуры (%1)'"), 
			НеиспользуемыеСчетаФактуры.Количество());
	КонецЕсли;
	
	Элементы.СтраницаНеиспользуемыеСчетаФактуры.Заголовок = ТекстЗаголовка;
КонецПроцедуры

#КонецОбласти

#КонецОбласти
