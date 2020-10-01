#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
		Если Объект.Строки.Количество() Тогда
			// Создаем новый документ сторнирования, укажем что для него время нельзя менять.
			ЭтотОбъект.АвтоВремя = РежимАвтоВремя.НеИспользовать;
		КонецЕсли;
	КонецЕсли;

	// Активизировать первую непустую табличную часть
	СписокТабличныхЧастей = Новый СписокЗначений;
	СписокТабличныхЧастей.Добавить("Строки", "Строки");
	СписокТабличныхЧастей.Добавить("Строки2", "Строки2");
	СписокТабличныхЧастей.Добавить("УменьшениеНалога", "УменьшениеНалога");
	СписокТабличныхЧастей.Добавить("УплаченныйТорговыйСбор", "УплаченныйТорговыйСбор");

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
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ДобавлениеНовойЗаписиСторноКУДиР" Тогда
		
		ДанныеДляДобавления = Объект["Строки"];
	
		НоваяСтрока = ДанныеДляДобавления.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Параметр);
		НоваяСтрока.ДатаНомер = Параметр.РеквизитыПервичногоДокумента;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаполнитьДобавленныеКолонкиТаблиц();

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)

	Если НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДатаДокумента) Тогда
		// Изменение времени не влияет на поведение документа.
		ТекущаяДатаДокумента = Объект.Дата;
		Возврат;
	КонецЕсли;

	// Общие проверки условий по датам.
	ТребуетсяВызовСервера = ОбщегоНазначенияБПКлиент.ТребуетсяВызовСервераПриИзмененииДатыДокумента(Объект.Дата, 
		ТекущаяДатаДокумента);
		
	// Если определили, что изменение даты может повлиять на какие-либо параметры, 
	// то передаем обработку на сервер.
	Если ТребуетсяВызовСервера Тогда
		ОрганизацияДатаПриИзмененииНаСервере();
	КонецЕсли;
	
	// Запомним новую дату документа.
	ТекущаяДатаДокумента = Объект.Дата;

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияДатаПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыСтроки

&НаКлиенте
Процедура СтрокиГрафа5ПриИзменении(Элемент)
	Элементы.Строки.ТекущиеДанные.Графа4 = Элементы.Строки.ТекущиеДанные.Графа5 + Элементы.Строки.ТекущиеДанные.ДоходЕНВД;
КонецПроцедуры

&НаКлиенте
Процедура СтрокиГрафа7ПриИзменении(Элемент)
	Элементы.Строки.ТекущиеДанные.Графа6 = Элементы.Строки.ТекущиеДанные.Графа7 + Элементы.Строки.ТекущиеДанные.РасходЕНВД;
КонецПроцедуры

&НаКлиенте
Процедура СтрокиДоходЕНВДПриИзменении(Элемент)
	Элементы.Строки.ТекущиеДанные.Графа4 = Элементы.Строки.ТекущиеДанные.Графа5 + Элементы.Строки.ТекущиеДанные.ДоходЕНВД;
КонецПроцедуры

&НаКлиенте
Процедура СтрокиРасходЕНВДПриИзменении(Элемент)
	Элементы.Строки.ТекущиеДанные.Графа6 = Элементы.Строки.ТекущиеДанные.Графа7 + Элементы.Строки.ТекущиеДанные.РасходЕНВД;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыУменьшениеНалога

&НаКлиенте
Процедура УменьшениеНалогаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		СтрокаТаблицы = Элементы.УменьшениеНалога.ТекущиеДанные;
		Если НЕ Копирование Тогда
			СтрокаТаблицы.ПериодНачисления = НачалоМесяца(Объект.Дата);
		КонецЕсли;
		ЗаполнитьДобавленныеКолонкиСтрокиУменьшениеНалога(СтрокаТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеНалогаПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтрокаТаблицы = Элементы.УменьшениеНалога.ТекущиеДанные;
	ИзменениеПериодаНачисления(СтрокаТаблицы, Направление, 1);
	Модифицированность = Истина;
	
	ЗаполнитьДобавленныеКолонкиСтрокиУменьшениеНалога(СтрокаТаблицы);
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшениеНалогаПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущееЗначение = Элементы.УменьшениеНалога.ТекущиеДанные.ПериодНачисления;
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода",
		НачалоМесяца(ТекущееЗначение), КонецМесяца(ТекущееЗначение));
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПериодНачисленияНачалоВыбораЗавершение", ЭтотОбъект, "УменьшениеНалога");
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбораПериода, ЭтотОбъект,,,, ОповещениеОЗакрытии);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыУплаченныйТорговыйСбор

&НаКлиенте
Процедура УплаченныйТорговыйСборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		СтрокаТаблицы = Элементы.УплаченныйТорговыйСбор.ТекущиеДанные;
		СтрокаТаблицы.ПериодНачисления = НачалоКвартала(Объект.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УплаченныйТорговыйСборПериодНачисленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущееЗначение = Элементы.УплаченныйТорговыйСбор.ТекущиеДанные.ПериодНачисления;
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода",
		НачалоКвартала(ТекущееЗначение), КонецКвартала(ТекущееЗначение));
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПериодНачисленияНачалоВыбораЗавершение", ЭтотОбъект, "УплаченныйТорговыйСбор");
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаКвартал", ПараметрыВыбораПериода, ЭтотОбъект,,,, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура УплаченныйТорговыйСборПериодНачисленияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТаблицы = Элементы.УплаченныйТорговыйСбор.ТекущиеДанные;
	ИзменениеПериодаНачисления(СтрокаТаблицы, Направление, 3);
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
// Конец МенюОтчеты

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

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ТекущаяДатаДокумента = Объект.Дата;

	УстановитьФункциональныеОпцииФормы();
	
	УстановитьЗаголовокФормы(ЭтаФорма);
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура УправлениеФормой(Форма)

	ОрганизацииНаУСН = УчетнаяПолитикаПереопределяемый.ОрганизацииНаУСНЗаПериод(НачалоДня(Объект.Дата), КонецДня(Объект.Дата));
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(ОрганизацииНаУСН);
	Элементы.ГруппаУменьшениеНалога.Видимость = Не ПолучитьФункциональнуюОпциюФормы("ПрименяетсяУСНДоходыМинусРасходы");
	Элементы.ГруппаУплаченныйТорговыйСбор.Видимость = Не ПолучитьФункциональнуюОпциюФормы("ПрименяетсяУСНДоходыМинусРасходы")
		И Объект.Дата >= УчетУСНСервер.ДатаНачалаФормирования5РазделаКУДиР();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()

	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма);
		
КонецПроцедуры

&НаСервере
Процедура ОрганизацияДатаПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
			
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()

	Для Каждого СтрокаТаблицы Из Объект.УменьшениеНалога Цикл
		
		ЗаполнитьДобавленныеКолонкиСтрокиУменьшениеНалога(СтрокаТаблицы);		
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьДобавленныеКолонкиСтрокиУменьшениеНалога(СтрокаТаблицы)
	
	СтрокаТаблицы.ПериодСтрокой = Формат(СтрокаТаблицы.ПериодНачисления, "ДФ='MMMM yyyy'");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокФормы(Форма)
	
	Объект	= Форма.Объект;
	
	ТекстЗаголовка	= НСтр("ru = 'Запись книги учета доходов и расходов (УСН)'");
	
	Если Объект.Ссылка.Пустая() Тогда
		Форма.Заголовок = ТекстЗаголовка + " " + НСтр("ru = '(создание)'");
	Иначе
		Форма.Заголовок = ТекстЗаголовка + " " + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 от %2'"), Объект.Номер, Объект.Дата);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменениеПериодаНачисления(СтрокаТаблицы, Направление, КоличествоМесяцев)
	
	СтрокаТаблицы.ПериодНачисления = ДобавитьМесяц(СтрокаТаблицы.ПериодНачисления, КоличествоМесяцев * Направление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачисленияНачалоВыбораЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Элементы[ДополнительныеПараметры].ТекущиеДанные;
	
	// Установим полученный период
	Если СтрокаТаблицы.ПериодНачисления <> РезультатЗакрытия.НачалоПериода Тогда
		СтрокаТаблицы.ПериодНачисления = РезультатЗакрытия.НачалоПериода;
		Модифицированность = Истина;
		Если ДополнительныеПараметры = "УменьшениеНалога" Тогда
			ЗаполнитьДобавленныеКолонкиСтрокиУменьшениеНалога(СтрокаТаблицы);
		КонецЕсли;
	КонецЕсли;
	
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

#КонецОбласти

