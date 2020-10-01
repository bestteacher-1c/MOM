
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	ДанныеУведомления = Новый Структура;
	
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	Параметры.Свойство("Данные", Данные);
	НужноОповещатьОСоздании = Ложь;
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
	Иначе
		Организация = Параметры.Организация;
		Объект.Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	ТитульнаяСтраница = Новый Структура;
	Для Каждого Обл Из Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2015_1").Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник и Обл.СодержитЗначение = Истина Тогда 
			ТитульнаяСтраница.Вставить(Обл.Имя);
		КонецЕсли;
	КонецЦикла;
	ЗагрузитьДанные();
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	СформироватьМакетНаСервере();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьТитульный();
		СформироватьМакетНаСервере();
		Элементы.НаименованиеЭтапа.Заголовок = "В работе";
	Иначе
		Статус = РегламентированнаяОтчетность.СохраненныйСтатусОтправкиУведомления(Объект.Ссылка);
		Если Статус <> Неопределено Тогда
			Элементы.НаименованиеЭтапа.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), Статус);
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2015_1");
	ТекущееИДНаименования = "Титульная";
	
	ОТС = Новый ОписаниеТипов("Строка");
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник 
			И Обл.СодержитЗначение = Истина
			И Обл.ТипЗначения = ОТС Тогда 
			
			Попытка
				Обл.ЭлементУправления.МногострочныйРежим = Истина;
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ЗагрузитьДанные()
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ТитульнаяСтраница = ОбщегоНазначения.СкопироватьРекурсивно(СтруктураПараметров.Титульный);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеРанееПредставленныеДокументы;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник и Обл.СодержитЗначение = Истина Тогда 
			Если ТитульнаяСтраница.Свойство(Обл.Имя) Тогда 
				ТитульнаяСтраница[Обл.Имя] = Обл.Значение;
			Иначе 
				ТитульнаяСтраница.Вставить(Обл.Имя, Обл.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура("Титульный", ТитульнаяСтраница);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТитульный()
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		СтрокаСведений = "ИННЮЛ,КПП,ОГРН,НаимЮЛПол,АдрЮР,АдресЭлектроннойПочтыОрганизации,ТелОрганизации,ДолжнРук,ФИОРук";
		ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		ТитульнаяСтраница.Телефон = СведенияОбОрганизации.ТелОрганизации;
		ТитульнаяСтраница.Должность = СведенияОбОрганизации.ДолжнРук;
		ТитульнаяСтраница.ФИО = СведенияОбОрганизации.ФИОРук;
		ТитульнаяСтраница.ЭлектроннаяПочта = СведенияОбОрганизации.АдресЭлектроннойПочтыОрганизации;
		ТитульнаяСтраница.НаимОргПолн = СведенияОбОрганизации.НаимЮЛПол + " " + "ИНН " + СведенияОбОрганизации.ИННЮЛ + " КПП " + СведенияОбОрганизации.КПП;
	Иначе 
		СтрокаСведений = "ИННФЛ,ФИО,ТелОрганизации,АдрПрописки,АдресЭлектроннойПочтыОрганизации,ДолжнРук,ФИОРук";
		ДП = ?(ЗначениеЗаполнено(Объект.ДатаПодписи), Объект.ДатаПодписи, ТекущаяДатаСеанса());
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, ДП, СтрокаСведений);
		ТитульнаяСтраница.Телефон = СведенияОбОрганизации.ТелОрганизации;
		ТитульнаяСтраница.Должность = "индивидуальный предприниматель";
		ТитульнаяСтраница.ФИО = СведенияОбОрганизации.ФИО;
		ТитульнаяСтраница.ЭлектроннаяПочта = СведенияОбОрганизации.АдресЭлектроннойПочтыОрганизации;
		ТитульнаяСтраница.НаимОргПолн = СведенияОбОрганизации.ФИО + " " + "ИНН " + СведенияОбОрганизации.ИННФЛ;
	КонецЕсли;
	
	ТитульнаяСтраница.Дата = ДП;
КонецПроцедуры

&НаСервере
Процедура СформироватьМакетНаСервере()
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2015_1");
	Область = Макет.ПолучитьОбласть("Титульный");
	
	ПредставлениеУведомления.Очистить();
	ПредставлениеУведомления.Вывести(Область);
	ПредставлениеУведомления.ВыделенныеОбласти.Очистить();
	ТекущийЭлемент = Элементы.ПредставлениеУведомления;
	Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Область(1,1,1,1);
	
	Для Каждого КЗ Из ТитульнаяСтраница Цикл 
		О1 = ПредставлениеУведомления.Области.Найти(КЗ.Ключ);
		Если О1 <> Неопределено И О1.СодержитЗначение Тогда 
			О1.Значение = КЗ.Значение;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	Если ТитульнаяСтраница.Свойство(Область.Имя) Тогда 
		ТитульнаяСтраница[Область.Имя] = Область.Значение;
	Иначе
		ТитульнаяСтраница.Вставить(Область.Имя, Область.Значение);
	КонецЕсли;
	
	Если Область.Имя = "Дата" Тогда 
		Объект.ДатаПодписи = Область.Значение;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтандартнаяОбработка Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеСтатусаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ПустаяСсылка"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
#КонецОбласти