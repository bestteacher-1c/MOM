
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
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
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
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПринятиеКУчетуНМА", ПараметрыЗаписи, Объект.Ссылка);
	
	ОповеститьОбИзменении(Объект.НематериальныйАктив);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	ОбщегоНазначенияУТКлиент.ВыполнитьДействияПослеЗаписи(ЭтаФорма, Объект, ПараметрыЗаписи);
	
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

	ЦелевоеФинансированиеЗаполнитьСлужебныеРеквизиты();
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
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
Процедура ВариантПримененияЦелевогоФинансированияПриИзменении(Элемент)
	
	ИзмененныеРеквизиты = "ВариантПримененияЦелевогоФинансирования";
	
	Если Объект.ВариантПримененияЦелевогоФинансирования = ПредопределенноеЗначение("Перечисление.ВариантыПримененияЦелевогоФинансирования.Полное")
		И Объект.ПорядокСписанияНИОКРНаРасходыНУ = ПредопределенноеЗначение("Перечисление.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету") Тогда
		
		Объект.ПорядокСписанияНИОКРНаРасходыНУ = ПредопределенноеЗначение("Перечисление.ПорядокСписанияНИОКРНУ.Равномерно");
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ПорядокСписанияНИОКРНаРасходыНУ";
	КонецЕсли;
	
	Если Объект.ВариантПримененияЦелевогоФинансирования = ПредопределенноеЗначение("Перечисление.ВариантыПримененияЦелевогоФинансирования.Полное")
		И Объект.ПорядокУчетаНУ = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету") Тогда
		
		Объект.ПорядокУчетаНУ = Элементы.ПорядокУчетаНУ.СписокВыбора.Получить(0);
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ПорядокУчетаНУ";
	КонецЕсли;
	
	ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектаУчетаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаполнитьЗначенияСвойств(Объект, СчетаУчетаНематериальныйАктивовПоУмолчанию(Объект.ВидОбъектаУчета));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюБУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НачислятьАмортизациюБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюНУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("НачислятьАмортизациюНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("СпособНачисленияАмортизацииБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСписанияНИОКРНаРасходыНУПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("ПорядокСписанияНИОКРНаРасходыНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияБУПриИзменении(Элемент)
	
	Если Объект.СрокИспользованияНУ = 0
		Или СрокИспользованияБУ = Объект.СрокИспользованияНУ Тогда
		
		Объект.СрокИспользованияНУ = Объект.СрокИспользованияБУ;
		СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияНУ);
		
	КонецЕсли;
	
	СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияБУ);
	
	СрокИспользованияБУ = Объект.СрокИспользованияБУ;
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУПриИзменении(Элемент)
	
	СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
		Объект.СрокИспользованияНУ);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
		СтатьяРасходовПриИзмененииНаСервере();
	Иначе
		АналитикаРасходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаздельногоУчетаНДСПриИзменении(Элемент)
	ОбновитьДоступностьЭлементовФормы("НДС");
КонецПроцедуры

&НаКлиенте
Процедура ПередаватьАмортизациюВДругуюОрганизациюПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("ПередаватьРасходыВДругуюОрганизацию");
	
	Если Не Объект.ПередаватьРасходыВДругуюОрганизацию Тогда
		Объект.ОрганизацияПолучательРасходов = Неопределено;
		Объект.СчетПередачиРасходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы("Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.СтатьяДоходов) Тогда
		СтатьяДоходовПриИзмененииНаСервере();
	Иначе
		АналитикаДоходовОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СтатьяДоходовПриИзмененииНаСервере()
	
	АналитикаДоходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяДоходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаНУПриИзменении(Элемент)
	ПорядокУчетаНУПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВидОбъектаУчетаПриИзменении(Элемент)
	
	Объект.НематериальныйАктив = ПредопределенноеЗначение("Справочник.НематериальныеАктивы.ПустаяСсылка");
	ОбновитьДоступностьЭлементовФормы("ВидОбъектаУчета");
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ВидОбъектаУчетаПриИзмененииЗавершение", ЭтаФорма),
		НСтр("ru='Установить значения счетов учета, используемые по умолчанию?'"),
		РежимДиалогаВопрос.ДаНет,,
		КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыЦелевоеФинансирование

&НаКлиенте
Процедура ЦелевоеФинансированиеСчетПриИзменении(Элемент)
	
	ЦелевоеФинансированиеЗаполнитьСлужебныеРеквизиты(Элементы.ЦелевоеФинансирование.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗаполнитьИсточникиФинансирования(Команда)
	
	ЗаполнитьИсточникиФинансированияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИсточникиФинансированияНаСервере()
	
	Объект.ЦелевоеФинансирование.Загрузить(ВнеоборотныеАктивыЛокализация.ДанныеЗаполненияЦелевогоФинансирования(Объект));
	
КонецПроцедуры

#Область СтандартныеПодсистемы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

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

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ЗакрытьФорму()
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	СрокИспользованияБУ = Объект.СрокИспользованияБУ;
	
	ОбновитьДоступностьЭлементовФормы();
	
	ЦелевоеФинансированиеЗаполнитьСлужебныеРеквизиты();
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	АналитикаДоходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяДоходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяДоходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	#Область ЦелевоеФинансирование
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто1");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто1Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто1.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто1Разрешено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто1Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто2.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто2");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто2Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто2.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто2Разрешено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто2Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто3.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто3");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто3Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЦелевоеФинансированиеСубконто3.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто3Разрешено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Объект.ЦелевоеФинансирование.Субконто3Заголовок"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты=Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	ЭтоНИОКР = (Объект.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ВидОбъектаУчета") Тогда
		
		СпособыНачисленияАмортизацииБУ = Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора;
		СпособыНачисленияАмортизацииБУ.Очистить();
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.Линейный);
		СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		
		Элементы.СпособПоступления.Видимость = Не ЭтоНИОКР;
		Элементы.СчетНачисленияАмортизации.Видимость = Не ЭтоНИОКР;
		Элементы.СпециальныйКоэффициентНУ.Видимость = Не ЭтоНИОКР;
		Элементы.НачислятьАмортизациюНУ.Видимость = Не ЭтоНИОКР;
		Элементы.ПорядокСписанияНИОКРНаРасходыНУ.Видимость = ЭтоНИОКР;
		Элементы.ПорядокУчетаНУ.Видимость = НЕ ЭтоНИОКР ИЛИ УчетнаяПолитика.ПрименяетсяУСНДоходыМинусРасходы(Объект.Организация, Объект.Дата);
		
		Если ЭтоНИОКР Тогда
			
			Элементы.СчетНачисленияАмортизации.Видимость = Ложь;
			Элементы.СчетАмортизацииЦФ.Видимость = Ложь;
			Элементы.СчетАмортизацииПустой.Видимость = Истина;
			Элементы.СчетАмортизацииПустойЦФ.Видимость = Истина;
			
			Элементы.СтраницаАмортизация.Заголовок = НСтр("ru='Списание расходов'");
			Элементы.СчетУчета.Заголовок = НСтр("ru='НИОКР'");
			Элементы.СчетУчетаЦФ.Заголовок = НСтр("ru='НИОКР'");
			Элементы.НематериальныйАктив.Заголовок = НСтр("ru='НИОКР'");
			Элементы.НачислятьАмортизациюБУ.Заголовок = НСтр("ru='Списание расходов'");
			Элементы.СрокИспользованияБУ.Заголовок= НСтр("ru='Срок списания (месяцев)'");
			Элементы.СпособНачисленияАмортизацииБУ.Заголовок= НСтр("ru='Способ списания расходов'");
			Элементы.СрокИспользованияНУ.Заголовок= НСтр("ru='Срок списания (месяцев)'");
			
			Элементы.НачислятьАмортизациюБУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не списывать''; БИ=Действует'");
			Элементы.НачислятьАмортизациюНУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не списывать''; БИ=Действует'");
			
			Реквизиты.Вставить("ПорядокСписанияНИОКРНаРасходыНУ");
			Реквизиты.Вставить("НачислятьАмортизациюБУ");
			
		Иначе
			
			Элементы.СчетНачисленияАмортизации.Видимость = Истина;
			Элементы.СчетАмортизацииЦФ.Видимость = Истина;
			Элементы.СчетАмортизацииПустой.Видимость = Ложь;
			Элементы.СчетАмортизацииПустойЦФ.Видимость = Ложь;
			
			СпособыНачисленияАмортизацииБУ.Добавить(Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
			Если Не ОбновитьВсе И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
				Объект.СпособНачисленияАмортизацииБУ = Неопределено;
			КонецЕсли;
			
			Элементы.СтраницаАмортизация.Заголовок = НСтр("ru='Амортизация'");
			Элементы.СчетУчета.Заголовок = НСтр("ru='Нематериального актива'");
			Элементы.СчетУчетаЦФ.Заголовок = НСтр("ru='Нематериального актива'");
			Элементы.НематериальныйАктив.Заголовок = НСтр("ru='Нематериальный актив'");
			Элементы.НачислятьАмортизациюБУ.Заголовок = НСтр("ru='Начисление амортизации'");
			Элементы.СрокИспользованияБУ.Заголовок= НСтр("ru='Срок использования (месяцев)'");
			Элементы.СпособНачисленияАмортизацииБУ.Заголовок= НСтр("ru='Способ начисления амортизации'");
			Элементы.СрокИспользованияНУ.Заголовок= НСтр("ru='Срок использования (месяцев)'");
			
			Элементы.НачислятьАмортизациюБУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не начислять''; БИ=Действует'");
			Элементы.НачислятьАмортизациюНУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не начислять''; БИ=Действует'");
			
			Реквизиты.Вставить("НачислятьАмортизациюБУ");
			Реквизиты.Вставить("НачислятьАмортизациюНУ");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НачислятьАмортизациюБУ") Тогда
		Элементы.СпособНачисленияАмортизацииБУ.Видимость = Объект.НачислятьАмортизациюБУ;
		Элементы.ГруппаСрокИспользованияБУ.Видимость = Объект.НачислятьАмортизациюБУ;
		
		Реквизиты.Вставить("СпособНачисленияАмортизацииБУ")
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НачислятьАмортизациюНУ") Тогда
		Элементы.СпециальныйКоэффициентНУ.Видимость = Объект.НачислятьАмортизациюНУ;
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НачислятьАмортизациюБУ") Или Реквизиты.Свойство("НачислятьАмортизациюНУ") Тогда
		Элементы.ОтражениеРасходов.Видимость = Объект.НачислятьАмортизациюБУ Или Объект.НачислятьАмортизациюНУ;
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СпособНачисленияАмортизацииБУ") Тогда
		
		Элементы.СрокИспользованияБУ.АвтоОтметкаНезаполненного = (
			Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			Или Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		
		Если Не Элементы.СрокИспользованияБУ.АвтоОтметкаНезаполненного Тогда
			Элементы.СрокИспользованияБУ.ОтметкаНезаполненного = Ложь;
		КонецЕсли;
		
		Элементы.ОбъемНаработкиБУ.Видимость = (
			Объект.НачислятьАмортизациюБУ
			И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		
		Элементы.КоэффициентБУ.Видимость = (
			Объект.НачислятьАмортизациюБУ
			И Объект.СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		
	КонецЕсли;
	
	Если ОбновитьВсе 
		Или Реквизиты.Свойство("ПорядокСписанияНИОКРНаРасходыНУ") 
		Или Реквизиты.Свойство("НачислятьАмортизациюНУ")
		Или Реквизиты.Свойство("ВидОбъектаУчета") Тогда
		
		Элементы.ГруппаСрокИспользованияНУ.Видимость = 
			Объект.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР
				И Объект.ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.Равномерно
			Или Объект.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив
				И Объект.НачислятьАмортизациюНУ;
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СрокИспользованияБУ") Тогда
		СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияБУ);
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СрокИспользованияНУ") Тогда
		СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(
			Объект.СрокИспользованияНУ);
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НДС") Тогда
		
		ТребуетсяЗаполнение = (Объект.ВариантРаздельногоУчетаНДС = Перечисления.ВариантыРаздельногоУчетаНДС.ИзДокумента);
		Элементы.НалогообложениеНДС.ТолькоПросмотр = Не ТребуетсяЗаполнение;
		Элементы.НалогообложениеНДС.АвтоОтметкаНезаполненного = ТребуетсяЗаполнение;
		Элементы.НалогообложениеНДС.ОтметкаНезаполненного = ТребуетсяЗаполнение И Не ЗначениеЗаполнено(Объект.НалогообложениеНДС);
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПередаватьРасходыВДругуюОрганизацию") Тогда
		
		Элементы.ОрганизацияПолучательРасходов.Доступность = Объект.ПередаватьРасходыВДругуюОрганизацию;
		Элементы.СчетПередачиРасходов.Доступность = Объект.ПередаватьРасходыВДругуюОрганизацию;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("Организация") Или Реквизиты.Свойство("Дата") Тогда
		
		ЕстьСвязанныеОрганизации = Справочники.Организации.ОрганизацияВзаимосвязанаСДругимиОрганизациями(Объект.Организация);
		Элементы.ПередаватьРасходыВДругуюОрганизацию.Видимость = ЕстьСвязанныеОрганизации;
		Элементы.ОрганизацияПолучательРасходов.Видимость = ЕстьСвязанныеОрганизации;
		Элементы.СчетПередачиРасходов.Видимость = ЕстьСвязанныеОрганизации;
		
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация, Период", Объект.Организация, Объект.Дата));		
		
		СписокВыбораНУ = Элементы.ПорядокУчетаНУ.СписокВыбора;
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ПлательщикНалогаНаПрибыль = ПолучитьФункциональнуюОпцию("ПлательщикНалогаНаПрибыль", ПолучитьПараметрыФункциональныхОпцийФормы());
			ЗначениеЭлемента = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации");
			ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьЗначенияСпискаВыбора(СписокВыбораНУ, ПлательщикНалогаНаПрибыль, ЗначениеЭлемента,, 0);
		КонецЕсли;
		
		ПрименяетсяУСНДоходыМинусРасходы = ПолучитьФункциональнуюОпцию("ПрименяетсяУСНДоходыМинусРасходы", ПолучитьПараметрыФункциональныхОпцийФормы());
		ЗначениеЭлемента = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключитьВСоставАмортизируемогоИмущества");
		ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьЗначенияСпискаВыбора(СписокВыбораНУ, ПрименяетсяУСНДоходыМинусРасходы, ЗначениеЭлемента,, 0);
		
		Если СписокВыбораНУ.НайтиПоЗначению(Объект.ПорядокУчетаНУ) = Неопределено
			И (ПлательщикНалогаНаПрибыль ИЛИ ПрименяетсяУСНДоходыМинусРасходы) Тогда
			Объект.ПорядокУчетаНУ = СписокВыбораНУ.Получить(0).Значение;
		КонецЕсли;
		
		Элементы.ПорядокУчетаНУ.Видимость = НЕ ЭтоНИОКР ИЛИ ПрименяетсяУСНДоходыМинусРасходы;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ВариантПримененияЦелевогоФинансирования") Тогда
		
		ТребуетсяЗаполнение = (ЗначениеЗаполнено(Объект.ВариантПримененияЦелевогоФинансирования)
			И (Объект.ВариантПримененияЦелевогоФинансирования<>Перечисления.ВариантыПримененияЦелевогоФинансирования.НеИспользуется));
		Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = ТребуетсяЗаполнение;
		Элементы.НаправлениеДеятельности.ОтметкаНезаполненного = ТребуетсяЗаполнение И Не ЗначениеЗаполнено(Объект.НаправлениеДеятельности);
		
		Элементы.СтраницаЦелевоеФинансирование.Видимость = ТребуетсяЗаполнение;
		
		Элементы.ЦелевоеФинансированиеСумма.Видимость = (Объект.ВариантПримененияЦелевогоФинансирования=Перечисления.ВариантыПримененияЦелевогоФинансирования.Частичное);
		
		СписокВыбора = Элементы.ПорядокСписанияНИОКРНаРасходыНУ.СписокВыбора;
		СписокВыбора.Очистить();
		СписокВыбора.Добавить(Перечисления.ПорядокСписанияНИОКРНУ.Равномерно);
		Если Объект.ВариантПримененияЦелевогоФинансирования<>Перечисления.ВариантыПримененияЦелевогоФинансирования.Полное Тогда
			СписокВыбора.Добавить(Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету);
		КонецЕсли;
		СписокВыбора.Добавить(Перечисления.ПорядокСписанияНИОКРНУ.НеСписывать);
		
		СписокВыбора = Элементы.ПорядокУчетаНУ.СписокВыбора;
		ВидимостьЭлемента = (Объект.ВариантПримененияЦелевогоФинансирования <>
			ПредопределенноеЗначение("Перечисление.ВариантыПримененияЦелевогоФинансирования.Полное"));
		ЗначениеЭлемента = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету");
		ВнеоборотныеАктивыКлиентСервер.УстановитьВидимостьЗначенияСпискаВыбора(СписокВыбора, ВидимостьЭлемента, ЗначениеЭлемента,, 1);
		
		Если СписокВыбора.НайтиПоЗначению(Объект.ПорядокУчетаНУ) = Неопределено И Не ОбновитьВсе Тогда
			Объект.ПорядокУчетаНУ = СписокВыбора.Получить(0).Значение;
		КонецЕсли;
		
	КонецЕсли;

	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокУчетаНУ") Или Реквизиты.Свойство("ВидОбъектаУчета") Тогда
		
		Если Объект.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации 
			ИЛИ ЭтоНИОКР Тогда
			Элементы.ГруппаНУ.Видимость = Истина;
		Иначе
			Элементы.ГруппаНУ.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СчетаУчетаНематериальныйАктивовПоУмолчанию(ВидОбъектаУчета)
	
	СчетаПоУмолчанию = Новый Структура("СчетУчета, СчетНачисленияАмортизации");
	
	Если ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив") Тогда
		СчетаПоУмолчанию.СчетНачисленияАмортизации = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов");
		СчетаПоУмолчанию.СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.НематериальныеАктивыОрганизации");
	Иначе
		СчетаПоУмолчанию.СчетНачисленияАмортизации = Неопределено;
		СчетаПоУмолчанию.СчетУчета = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.РасходыНаНИОКР");
	КонецЕсли;
	
	Возврат СчетаПоУмолчанию;
	
КонецФункции

&НаСервере
Процедура ЦелевоеФинансированиеЗаполнитьСлужебныеРеквизиты(Строка=Неопределено)
	
	ВнеоборотныеАктивыЛокализация.ЗаполнитьСлужебныеРеквизитыВТаблицеЦелевогоФинансирования(Объект, Строка);
	
КонецПроцедуры

&НаСервере
Процедура ПорядокУчетаНУПриИзмененииНаСервере()
	
	ИзмененныеРеквизиты = Новый Структура("ПорядокУчетаНУ");
	Если Объект.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.НачислениеАмортизации Тогда
		
		Элементы.ГруппаНУ.Видимость = Истина;
		Объект.НачислятьАмортизациюНУ = Истина;
		ИзмененныеРеквизиты.Вставить("НачислятьАмортизациюНУ");
		
	ИначеЕсли Объект.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету 
		ИЛИ Объект.ПорядокУчетаНУ = Перечисления.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.СтоимостьНеВключаетсяВРасходы Тогда
		
		Элементы.ГруппаНУ.Видимость = Ложь;
		Объект.НачислятьАмортизациюНУ = Ложь;
		ИзмененныеРеквизиты.Вставить("НачислятьАмортизациюНУ");
		
	КонецЕсли; 
	
	ОбновитьДоступностьЭлементовФормы(ИзмененныеРеквизиты);
	
КонецПроцедуры

#КонецОбласти
