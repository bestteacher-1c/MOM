
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьТекущиеЗначенияРеквизитов();
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ОтражениеАмортизационныхРасходов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ИзменениеПараметровНМА", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.НематериальныеАктивы.Форма.ФормаВыбора" Тогда
		Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
			Объект.НМА.Добавить().НематериальныйАктив = ЭлементМассива;
		КонецЦикла;
		ЗаполнитьТекущиеЗначенияРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СпециальныйКоэффициентНУФлагПриИзменении(Элемент)
	
	ФлагПриИзменении(Элемент.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовФлагПриИзменении(Элемент)
	
	Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.НМАОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
	
	Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
	
	КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(Объект.ОтражениеАмортизационныхРасходовФлаг, 1, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыОтражениеРасходов

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеАмортизационныхРасходов.ТекущиеДанные;
	Если ЗначениеЗаполнено(СтрокаТаблицы.СтатьяРасходов) Тогда
		ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения);
	Иначе
		СтрокаТаблицы.АналитикаРасходов = Неопределено;
		СтрокаТаблицы.АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтражениеАмортизационныхРасходовСтатьяРасходовПриИзмененииНаСервере(КэшированныеЗначения)
	
	СтрокаТаблицы = Объект.ОтражениеАмортизационныхРасходов.НайтиПоИдентификатору(
		Элементы.ОтражениеАмортизационныхРасходов.ТекущаяСтрока);
	
	ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(
		Объект,
		СтрокаТаблицы.СтатьяРасходов,
		СтрокаТаблицы.АналитикаРасходов);
		
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна");
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражениеАмортизационныхРасходовПередаватьРасходыВДругуюОрганизациюПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ОтражениеАмортизационныхРасходов.ТекущиеДанные;
	Если Не СтрокаТаблицы.ПередаватьРасходыВДругуюОрганизацию Тогда
		СтрокаТаблицы.ОрганизацияПолучательРасходов = Неопределено;
		СтрокаТаблицы.СчетПередачиРасходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборНМА(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.ВидыСостоянийНМА.ПринятКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.НематериальныеАктивы.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(
		УсловноеОформление,
		Новый Структура("ОтражениеАмортизационныхРасходов", "СтатьяРасходов, АналитикаРасходов"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовСчетПередачиРасходов.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ОтражениеАмортизационныхРасходовОрганизацияПолучательРасходов.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ОтражениеАмортизационныхРасходов.ПередаватьРасходыВДругуюОрганизацию");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	//
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	ЦветФонаФормы = ЦветаСтиля.ЦветФонаФормы;
	ЦветФонаПоля = ЦветаСтиля.ЦветФонаПоля;
	
	Элементы.СпециальныйКоэффициентНУ.Доступность = Объект.СпециальныйКоэффициентНУФлаг;
	Элементы.НМАСпециальныйКоэффициентНУ.Видимость = Объект.СпециальныйКоэффициентНУФлаг;
	
	Элементы.ОтражениеАмортизационныхРасходов.ТолькоПросмотр = Не Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.НМАОтражениеАмортизационныхРасходов.Видимость = Объект.ОтражениеАмортизационныхРасходовФлаг;
	Элементы.ОтражениеАмортизационныхРасходов.ЦветФона = ?(Объект.ОтражениеАмортизационныхРасходовФлаг, ЦветФонаПоля, ЦветФонаФормы);
	
	УстановитьДоступностьПередачиАмортизационныхРасходов();
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Организация));
	
	ЗаполнитьТекущиеЗначенияРеквизитов();
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ОтражениеАмортизационныхРасходов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеЗначенияРеквизитов()
	
	УстановитьПривилегированныйРежим(Истина);
	
	КоличествоИзмененныхСвойств = ?(Объект.СпециальныйКоэффициентНУФлаг, 1, 0) + ?(Объект.ОтражениеАмортизационныхРасходовФлаг, 1, 0);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(ДанныеДокумента.НомерСтроки КАК ЧИСЛО) КАК НомерСтроки,
		|	ВЫРАЗИТЬ(ДанныеДокумента.НематериальныйАктив КАК Справочник.НематериальныеАктивы) КАК НематериальныйАктив
		|ПОМЕСТИТЬ ДанныеДокумента
		|ИЗ
		|	&ДанныеДокумента КАК ДанныеДокумента
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеДокумента.НомерСтроки КАК НомерСтроки,
		|	НачислениеАмортизацииНМАСпециальныйКоэффициентНУ.СпециальныйКоэффициент КАК СпециальныйКоэффициентНУ,
		|	СпособыОтраженияРасходовПоАмортизацииНМАБУ.СтатьяРасходов КАК СтатьяРасходов,
		|	СпособыОтраженияРасходовПоАмортизацииНМАБУ.АналитикаРасходов КАК АналитикаРасходов
		|ИЗ
		|	ДанныеДокумента КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НачислениеАмортизацииНМАСпециальныйКоэффициентНалоговыйУчет.СрезПоследних(
		|				&Дата,
		|				НематериальныйАктив В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.НематериальныйАктив
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК НачислениеАмортизацииНМАСпециальныйКоэффициентНУ
		|		ПО ДанныеДокумента.НематериальныйАктив = НачислениеАмортизацииНМАСпециальныйКоэффициентНУ.НематериальныйАктив
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпособыОтраженияРасходовПоАмортизацииНМАБухгалтерскийУчет.СрезПоследних(
		|				&Дата,
		|				НематериальныйАктив В
		|						(ВЫБРАТЬ
		|							ДанныеДокумента.НематериальныйАктив
		|						ИЗ
		|							ДанныеДокумента КАК ДанныеДокумента)
		|					И Регистратор <> &ТекущийРегистратор) КАК СпособыОтраженияРасходовПоАмортизацииНМАБУ
		|		ПО ДанныеДокумента.НематериальныйАктив = СпособыОтраженияРасходовПоАмортизацииНМАБУ.НематериальныйАктив");
	
	Запрос.УстановитьПараметр("Дата", Новый Граница(?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ДанныеДокумента", Объект.НМА.Выгрузить(, "НомерСтроки, НематериальныйАктив"));
	Запрос.УстановитьПараметр("ТекущийРегистратор", Объект.Ссылка);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Объект.НМА[Выборка.НомерСтроки-1], Выборка,, "НомерСтроки");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПриИзменении(ИмяФлага)
	
	ФлагУстановлен = Объект[ИмяФлага];
	Имя = СтрЗаменить(ИмяФлага, "Флаг", "");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, Имя, "Доступность", ФлагУстановлен);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НМА"+Имя, "Видимость", ФлагУстановлен);
	
	КоличествоИзмененныхСвойств = КоличествоИзмененныхСвойств + ?(ФлагУстановлен, 1, -1);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПередачиАмортизационныхРасходов()
	
	ЕстьСвязанныеОрганизации = Справочники.Организации.ОрганизацияВзаимосвязанаСДругимиОрганизациями(Объект.Организация);
	Элементы.ОтражениеАмортизационныхРасходовГруппаПередаватьРасходы.Видимость = ЕстьСвязанныеОрганизации;
	
КонецПроцедуры

#Область СтандартныеПодсистемыДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти




