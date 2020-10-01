&НаКлиенте
Перем НомерАктивизированнойСтроки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервереФормРазмещаемыхНаРабочемСтоле(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "Автообновление", Истина);
	ПериодАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "ПериодАвтообновления", 60);
	
	Элементы.ГруппаСтраницы.Доступность = Ложь;
	Элементы.ГруппаПодвал.Доступность = Ложь;
	Элементы.Автообновление.Доступность = Ложь;
	
	УстановитьОформлениеЗадач(УсловноеОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ДокументооборотЗадача" И Источник = ЭтаФорма Тогда
		ОбновитьСписокЗадачЧастично();
		РазвернутьГруппыЗадач();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтаФорма);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборот.Форма.АвторизацияВ1СДокументооборот";
	 
	ОткрытьФорму(ИмяФормыПараметров,, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыполненныеПриИзменении(Элемент)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаЗадачиОтМеня Тогда
		Если Не ЗадачиОтМеняСчитаны Тогда
			ОбновитьСписокЗадачНаСервере();
			РазвернутьГруппыЗадач();
			ЗадачиОтМеняСчитаны = Истина;
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		Если Не ЗадачиМнеСчитаны Тогда
			ОбновитьСписокЗадачНаСервере();
			РазвернутьГруппыЗадач();
			ЗадачиМнеСчитаны = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиМне

&НаКлиенте
Процедура ЗадачиМнеПриАктивизацииСтроки(Элемент)
	
	Если НомерАктивизированнойСтроки <> Элемент.ТекущаяСтрока Тогда
		
		НомерАктивизированнойСтроки = Элемент.ТекущаяСтрока;
		СтрокаЗадачи = Элементы.ЗадачиМне.ТекущиеДанные;
		Если СтрокаЗадачи = Неопределено Или СтрокаЗадачи.Группировка Тогда
			Элементы.ПринятьКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Доступность = Ложь;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Иначе
			Элементы.ПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Задача = Элементы.ЗадачиМне.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если НЕ Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("id", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", 
				ПараметрыФормы, ЭтаФорма, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеня
&НаКлиенте
Процедура ЗадачиОтМеняВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Задача = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если НЕ Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("id", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", ПараметрыФормы, ЭтаФорма, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Задача = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если НЕ Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("id", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", ПараметрыФормы, ЭтаФорма, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачу(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ТекущиеДанные.Группировка Тогда
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
			ТекущиеДанные.ЗадачаТип, ТекущиеДанные.ЗадачаID, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПредметТип,
		ТекущиеДанные.ПредметID,
		ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроцесс(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПроцессТип,
		ТекущиеДанные.ПроцессID,
		ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	Модифицированность = Ложь;
	Оповещение = Новый ОписаниеОповещения("СоздатьПроцессЗавершение", ЭтаФорма);
	ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцесс(,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПисьмо(Команда)

	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если Не ДоступенФункционалЗадачиОтМеня Тогда // так!
		ИнтеграцияС1СДокументооборотКлиент.ОткрытьОбъект("DMOutgoingEMail","", ЭтаФорма);
	Иначе
		ПараметрыФормы = новый Структура("Предмет", новый Структура);
		
		ПараметрыФормы.Предмет.Вставить("name", ТекущиеДанные.Задача);
		ПараметрыФормы.Предмет.Вставить("id", ТекущиеДанные.ЗадачаID);
		ПараметрыФормы.Предмет.Вставить("type", ТекущиеДанные.ЗадачаТип);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо",ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	ПринятьЗадачиКИсполнению();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	ОтменитьПринятиеЗадачКИсполнению();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("ВажностьСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("Предмет");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоИсполнителю(Команда)
	СгруппироватьПоКолонке("Исполнитель");
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросАвтору(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ЗадачиМне.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элементы.ЗадачиМне.ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("id", Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаID);
	ПараметрыФормы.Вставить("type", Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаТип);
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.БизнесПроцессРешениеВопросовНовыйВопрос", 
		ПараметрыФормы, ЭтаФорма, Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаID);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьПроцессЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	ОбновитьСписокЗадачЧастично();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппыЗадач()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		Дерево = ЗадачиМне;
		ЭлементДерево = Элементы.ЗадачиМне;
	Иначе
		Дерево = ЗадачиОтМеня;
		ЭлементДерево = Элементы.ЗадачиОтМеня;
	КонецЕсли;
	
	ЭлементыДерева = Дерево.ПолучитьЭлементы();
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Группировка Тогда
			ЭлементДерево.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(ИмяКолонки)
	
	Модифицированность = Ложь;
	СгруппироватьПоКолонкеНаСервере(ИмяКолонки);
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(ИмяКолонки)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
		ИмяСпискаЗадач = "ЗадачиМне";
		СписокЗадач = ЗадачиМне;
		РежимГруппировкиЗадачиМне = ИмяКолонки;
		РежимГруппировки = РежимГруппировкиЗадачиМне;
	Иначе
		ТаблицаЗадачСсылка = ТаблицаЗадачОтМеняСсылка;
		ИмяСпискаЗадач = "ЗадачиОтМеня";
		СписокЗадач = ЗадачиОтМеня;
		РежимГруппировкиЗадачиОтМеня = ИмяКолонки;
		РежимГруппировки = РежимГруппировкиЗадачиОтМеня;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяЗадача = Элементы.Найти(ИмяСпискаЗадач).ТекущаяСтрока;
	Если ТекущаяЗадача <> Неопределено Тогда
		СтрокаТекущейЗадачи = СписокЗадач.НайтиПоИдентификатору(ТекущаяЗадача);
		Если СтрокаТекущейЗадачи = Неопределено Тогда
			ТекущаяЗадача = Неопределено;
		Иначе
			ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение(ИмяСпискаЗадач);
	
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка);
	
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
    	ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для каждого СтрокаГруппировки из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(новый Структура(РежимГруппировки,СтрокаГруппировки[РежимГруппировки]));
			Для каждого Строка из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
			КонецЦикла;
			СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
		КонецЦикла;
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Дерево;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Для каждого Строка из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, ИмяСпискаЗадач);
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтроку(ЗадачаID) 
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ИмяСпискаЗадач = "ЗадачиМне";
		СписокЗадач = ЗадачиМне;
	Иначе
		ИмяСпискаЗадач = "ЗадачиОтМеня";
		СписокЗадач = ЗадачиОтМеня;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗадачаID) Тогда
		Если Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список Тогда
			СтрокиЗадачи = СписокЗадач.ПолучитьЭлементы();
			Для каждого СтрокаЗадачи из СтрокиЗадачи Цикл
				Если СтрокаЗадачи.ЗадачаId = ЗадачаID Тогда
					Элементы[ИмяСпискаЗадач].ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для каждого ГруппаДерева из СписокЗадач.ПолучитьЭлементы() Цикл
				СтрокиЗадачи = ГруппаДерева.ПолучитьЭлементы();
				Для каждого СтрокаЗадачи из СтрокиЗадачи Цикл
					Если СтрокаЗадачи.ЗадачаId = ЗадачаID Тогда
						Элементы[ИмяСпискаЗадач].ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьПодключениеЗавершение", ЭтаФорма, Неопределено);
	ИнтеграцияС1СДокументооборотКлиент.ПроверитьПодключение(
		ОписаниеОповещения, ЭтаФорма, "ПроверитьПодключение");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбработатьФормуСогласноВерсииСервиса();
		Если ВерсияСервиса <> "0.0.0.0" Тогда
			РазвернутьГруппыЗадач();
			#Если Не ВебКлиент Тогда
			Если ДоступенФункционалЗадачи Тогда
				Элементы.Автообновление.Доступность = Истина;
				Если Автообновление Тогда
					ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
				КонецЕсли;
			КонецЕсли;
			#КонецЕсли
		КонецЕсли;
	Иначе // не удалось подключиться к ДО
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьФормуСогласноВерсииСервиса()
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборот.ВерсияСервиса();
	
	Если ПустаяСтрока(ВерсияСервиса) Тогда // идет подключение
		
		Заголовок = НСтр("ru = 'Документооборот: Мои задачи (ожидается подключение...)'");
		
	Иначе
		
		Заголовок = НСтр("ru = 'Документооборот: Мои задачи'");
		
		Если ВерсияСервиса = "0.0.0.0" Тогда
			
			Элементы.ГруппаФункционалНеПоддерживается.Видимость = Истина;
			Элементы.ГруппаПроверкаАвторизации.Видимость = Истина;
			Элементы.ДекорацияФункционалНеПоддерживается.Заголовок = НСтр("ru = 'Нет доступа к 1С:Документообороту.'");
			
		Иначе // сервис доступен
			
			Заголовок = НСтр("ru = 'Документооборот: Мои задачи'");
			
			Элементы.ГруппаПроверкаАвторизации.Видимость = Ложь;
			Элементы.ГруппаФункционалНеПоддерживается.Видимость = Ложь;
			
			// задачи
			Если ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.2.6.2") Тогда
				Элементы.ГруппаСтраницы.Доступность = Истина;
				Элементы.ГруппаПодвал.Доступность = Истина;
				ДоступенФункционалЗадачи = Истина;
				ДоступенФункционалЗадачиОтМеня 
					= ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.3.2.3");
				ОбновитьСписокЗадачНаСервере();
			Иначе
				Элементы.ГруппаСтраницы.Доступность = Ложь;
				Элементы.ГруппаПодвал.Доступность = Ложь;
				ДоступенФункционалЗадачи = Ложь;
				ДоступенФункционалЗадачиОтМеня = Ложь;
				Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтаФорма);
				Элементы.Выполненные.ТолькоПросмотр = Истина;
			КонецЕсли;
			// решение вопросов
			Если НЕ ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.2.7.3") Тогда
				Элементы.ЗадатьВопросАвтору.Видимость = Ложь;
			КонецЕсли;
			// почта
			Если НЕ ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
				Элементы.СоздатьПисьмо.Видимость = Ложь;
				Элементы.СоздатьПисьмо2.Видимость = Ложь;
			КонецЕсли;
			// принятие задач к исполнению.
			Если Не ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("1.2.7.3.CORP") Тогда
				Элементы.ПринятьКИсполнению.Видимость = Ложь;
				Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Видимость = Ложь;
			КонецЕсли;
			// отмена принятия задач к исполнению.
			Если Не ИнтеграцияС1СДокументооборот.ДоступенФункционалВерсииСервиса("2.1.16.2.CORP") Тогда
				Элементы.ОтменитьПринятиеКИсполнению.Видимость = Ложь;
				Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Видимость = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ДоступенФункционалЗадачиОтМеня Тогда
			Элементы.ЗадачиОтМеня.Видимость = Ложь;
			Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Иначе
			Элементы.ЗадачиОтМеня.Видимость = Истина;
			Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Автообновление()
	
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновления()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Автообновление", Автообновление);
	ПараметрыФормы.Вставить("ПериодАвтообновления", ПериодАвтообновления);
	
	Оповещение = Новый ОписаниеОповещения("НастройкаАвтообновленияЗавершение", ЭтаФорма);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.НастройкаАвтообновления",
		ПараметрыФормы, ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = Результат.Автообновление;
	ПериодАвтообновления = Результат.ПериодАвтообновления;
	
	ОтключитьОбработчикОжидания("Автообновление");
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "Автообновление");
	Элемент.Вставить("Значение", Автообновление);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "ПериодАвтообновления");
	Элемент.Вставить("Значение", ПериодАвтообновления);
	МассивСтруктур.Добавить(Элемент);
	
	ИнтеграцияС1СДокументооборотКлиентПереопределяемый.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Если Автообновление Тогда
		ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПринятьЗадачиКИсполнению()
	
	Модифицированность = Ложь;
	МассивСтрок = Элементы.ЗадачиМне.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадачДО = Новый Массив;
		Для Каждого Элемент из МассивСтрок Цикл
			СтрокаЗадачи = ЗадачиМне.НайтиПоИдентификатору(Элемент);
			Если ЗначениеЗаполнено(СтрокаЗадачи.ЗадачаID) Тогда
				МассивЗадачДО.Добавить(СтрокаЗадачи.ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Если МассивЗадачДО.Количество() > 0 Тогда
			Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
			ИнтеграцияС1СДокументооборот.ПринятьЗадачуКИсполнению(Прокси, МассивЗадачДО);
			ОбновитьСписокЗадачЧастичноНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПринятиеЗадачКИсполнению()
	
	Модифицированность = Ложь;
	МассивСтрок = Элементы.ЗадачиМне.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадачДО = Новый Массив;
		Для Каждого Элемент из МассивСтрок Цикл
			СтрокаЗадачи = ЗадачиМне.НайтиПоИдентификатору(Элемент);
			Если ЗначениеЗаполнено(СтрокаЗадачи.ЗадачаID) Тогда
				МассивЗадачДО.Добавить(СтрокаЗадачи.ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Если МассивЗадачДО.Количество() > 0 Тогда
			Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
			ИнтеграцияС1СДокументооборот.ОтменитьПринятиеЗадачКИсполнению(Прокси, МассивЗадачДО);
			ОбновитьСписокЗадачЧастичноНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеЗадач(УсловноеОформление)
	
	// установка оформления для просроченных задач мне
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиМне");
	
	// установка оформления для просроченных задач от меня
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиОтМеняСрокИсполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадачЧастично()
	
	ОбновитьСписокЗадачЧастичноНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадачиМне(Прокси, Выполненные)
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "byUser";
	Условие.value = Истина;
	СписокУсловий.conditions.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Выполненные;
	СписокУсловий.conditions.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withDelayed";
	Условие.value = Ложь;
	СписокУсловий.conditions.Добавить(Условие);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMBusinessProcessTask";
	Запрос.query = СписокУсловий;
	
	Ответ = ИнтеграцияС1СДокументооборот.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗадачиОтМеня(Прокси, Выполненные)
	
	СписокУсловий = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListQuery");
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "author";
	Условие.value = "";
	СписокУсловий.conditions.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Выполненные;
	СписокУсловий.conditions.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withDelayed";
	Условие.value = Ложь;
	СписокУсловий.conditions.Добавить(Условие);
	
	Запрос = ИнтеграцияС1СДокументооборот.СоздатьОбъект(Прокси, "DMGetObjectListRequest");
	Запрос.type = "DMBusinessProcessTask";
	Запрос.query = СписокУсловий;
	
	Ответ = ИнтеграцияС1СДокументооборот.ВыполнитьЗапрос(Прокси, Запрос);
	ИнтеграцияС1СДокументооборот.ПроверитьВозвратВебСервиса(Прокси, Ответ);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокЗадач(ЗадачиXDTO)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ИмяСпискаЗадач =  "ЗадачиМне";
		РежимГруппировки = РежимГруппировкиЗадачиМне;
		ТекущаяЗадача = Элементы.ЗадачиМне.ТекущаяСтрока;
		Если ТекущаяЗадача <> Неопределено Тогда
			СтрокаТекущейЗадачи = ЗадачиМне.НайтиПоИдентификатору(ТекущаяЗадача);
			Если СтрокаТекущейЗадачи = Неопределено Тогда
				ТекущаяЗадача = Неопределено;
			Иначе
				ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ИмяСпискаЗадач =  "ЗадачиОтМеня";
		РежимГруппировки = РежимГруппировкиЗадачиОтМеня;
		ТекущаяЗадача = Элементы.ЗадачиОтМеня.ТекущаяСтрока;
		Если ТекущаяЗадача <> Неопределено Тогда
			СтрокаТекущейЗадачи = ЗадачиОтМеня.НайтиПоИдентификатору(ТекущаяЗадача);
			Если СтрокаТекущейЗадачи = Неопределено Тогда
				ТекущаяЗадача = Неопределено;
			Иначе
				ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение(ИмяСпискаЗадач);
	
	ТаблицаЗадач = новый ТаблицаЗначений;
	Для каждого Колонка из Дерево.Колонки Цикл
		ТаблицаЗадач.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	Для каждого ЗадачаXDTO из ЗадачиXDTO Цикл
		СтрокаЗадачи = ТаблицаЗадач.Добавить();
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO.object);
	КонецЦикла;
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Дерево;
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
    	ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для каждого СтрокаГруппировки из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(новый Структура(РежимГруппировки,СтрокаГруппировки[РежимГруппировки]));
			Для каждого Строка из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
				СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
			КонецЦикла;
		КонецЦикла;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список;
		Для каждого Строка из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, ИмяСпискаЗадач);
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачМнеСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		ЗадачиМнеСчитаны = Истина;
	Иначе
		ТаблицаЗадачОтМеняСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		ЗадачиОтМеняСчитаны = Истина;
	КонецЕсли;
	
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
	ЗаполнитьДекорацииЧислаЗадач();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДекорацииЧислаЗадач()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
	Иначе
		Возврат;
	КонецЕсли;
	
	Просрочено = 0;
	НеПринято = 0;
	ТекущаяДата = ТекущаяДатаСеанса();
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка);
	НеВыполненныеЗадачи = ТаблицаЗадач.НайтиСтроки(новый Структура("Выполнена", Ложь));
	
	Для каждого СтрокаЗадачи из НеВыполненныеЗадачи Цикл
		Если ЗначениеЗаполнено(СтрокаЗадачи.СрокИсполнения) И СтрокаЗадачи.СрокИсполнения < ТекущаяДата Тогда
			Просрочено = Просрочено + 1;
		КонецЕсли;
		Если НЕ СтрокаЗадачи.ПринятаКИсполнению Тогда
			НеПринято = НеПринято + 1;
		КонецЕсли;
	КонецЦикла;
		
	Элементы.ДекорацияОбщееЧислоЗадачМне.Заголовок = НеВыполненныеЗадачи.Количество();
	Элементы.ДекорацияЧислоПросроченныхЗадачМне.Заголовок = Просрочено;
	Элементы.ДекорацияЧислоНепринятыхЗадачМне.Заголовок = НеПринято;
	Элементы.ДекорацияРазделительЧислаЗадачМне1.Заголовок = "/";
	Элементы.ДекорацияРазделительЧислаЗадачМне2.Заголовок = "/";
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO)
	
	Важность = 1;
	Если ЗадачаXDTO.importance.objectId.id = "Низкая" Тогда
		Важность = 0;
	ИначеЕсли ЗадачаXDTO.importance.objectId.id = "Обычная" Тогда
		Важность = 1;
	ИначеЕсли ЗадачаXDTO.importance.objectId.id = "Высокая" Тогда 
		Важность = 2;
	КонецЕсли;
	
	СтрокаЗадачи.Важность = Важность;
	СтрокаЗадачи.ВажностьСтрокой = ЗадачаXDTO.importance.name;
	СтрокаЗадачи.КартинкаЗадачи = ?(ЗадачаXDTO.executed,1,0);
	СтрокаЗадачи.Выполнена = ЗадачаXDTO.executed;
	СтрокаЗадачи.ТочкаМаршрута = ЗадачаXDTO.businessProcessStep;
	СтрокаЗадачи.СрокИсполнения = ЗадачаXDTO.dueDate;
	СтрокаЗадачи.Записана = ЗадачаXDTO.beginDate;
	СтрокаЗадачи.Автор = ЗадачаXDTO.author.name;
	СтрокаЗадачи.ПринятаКИсполнению = ЗадачаXDTO.accepted;
	
	ИсполнительXDTO = ЗадачаXDTO.performer;
	Если ИсполнительXDTO.Установлено("user") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи, ИсполнительXDTO.user,"Исполнитель")
	ИначеЕсли ИсполнительXDTO.Установлено("role") Тогда
		Обработки.ИнтеграцияС1СДокументооборот.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи, ИсполнительXDTO.role,"Исполнитель")
	КонецЕсли;
	
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.parentBusinessProcess,"Процесс");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.target,"Предмет");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO,"Задача");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ЗадачиXDTO = ПолучитьЗадачиМне(Прокси, Выполненные);
	Иначе
		ЗадачиXDTO = ПолучитьЗадачиОтМеня(Прокси, Выполненные);
	КонецЕсли;
	ЗаполнитьСписокЗадач(ЗадачиXDTO);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачЧастичноНаСервере()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
	Иначе
		ТаблицаЗадачСсылка = ТаблицаЗадачОтМеняСсылка;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		ОбновитьСписокЗадачНаСервере();
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотПовтИсп.ПолучитьПрокси();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ЗадачиXDTO = ПолучитьЗадачиМне(Прокси, Выполненные);
	ИНаче
		ЗадачиXDTO = ПолучитьЗадачиОтМеня(Прокси, Выполненные);
	КонецЕсли;
	
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка);
	ЗадачиКУдалению = ТаблицаЗадач.ВыгрузитьКолонку("ЗадачаID");
	
	Для каждого ЗадачаXDTO из ЗадачиXDTO Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(новый Структура("ЗадачаID",ЗадачаXDTO.object.objectID.id));
		Если СтрокиЗадач.Количество() > 0 Тогда
			СтрокаЗадачи = СтрокиЗадач[0];
			ЗадачиКУдалению.Удалить(ЗадачиКУдалению.Найти(ЗадачаXDTO.object.objectID.id));
		Иначе
			СтрокаЗадачи = ТаблицаЗадач.Добавить();
		КонецЕсли;
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи,ЗадачаXDTO.object);
	КонецЦикла;
	
	Для каждого УдаляемаяЗадача из ЗадачиКУдалению Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(новый Структура("ЗадачаID",УдаляемаяЗадача));
		Если СтрокиЗадач.Количество() > 0 Тогда
			ТаблицаЗадач.Удалить(СтрокиЗадач[0]);
		КонецЕсли;
	КонецЦикла;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачМнеСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		СгруппироватьПоКолонкеНаСервере(РежимГруппировкиЗадачиМне);
	Иначе
		ТаблицаЗадачОтМеняСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		СгруппироватьПоКолонкеНаСервере(РежимГруппировкиЗадачиОтМеня);
	КонецЕсли;
	
	ЗаполнитьДекорацииЧислаЗадач();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектныйРеквизит(Приемник, Источник, ИмяРеквизита)
	
	Если Источник <> Неопределено Тогда
		Приемник[ИмяРеквизита] = Источник.name;
		Приемник[ИмяРеквизита + "ID"] = Источник.objectId.id;
		Приемник[ИмяРеквизита + "Тип"] = Источник.objectId.type;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
