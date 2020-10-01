
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОтборНабораЗаписей = Параметры.Отбор;
	
	Если НЕ ЗначениеЗаполнено(ОтборНабораЗаписей.Организация) ИЛИ НЕ ЗначениеЗаполнено(ОтборНабораЗаписей.ТорговаяТочка) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаПользователя = ОбщегоНазначения.ТекущаяДатаПользователя();
	
	ЗагрузитьТаблицуЛьгот();
	УстановитьОтборСтрок();
	УправлениеФормой();
	
	НаборЗаписей.Сортировать("Период");
	УстановитьИдентификаторПоследнейЗаписи(ЭтотОбъект);
	Элементы.НаборЗаписей.ТекущаяСтрока = ИдентификаторПоследнейЗаписи;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, НСтр("ru='Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

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
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНаборЗаписей

&НаКлиенте
Процедура НаборЗаписейПередУдалением(Элемент, Отказ)
	
	Если НаборЗаписей.Количество() = 1 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийТорговыеТочки.Регистрация") Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элемент.ТекущиеДанные;
		
		ПоследняяЗапись = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторПоследнейЗаписи);
		ИсключаемыеПоля = "Уведомление, ДатаПодачиУведомления, ВидОперации, РасшифровкаРасчета, Ставка, СуммаЛьготы, СуммаСбора";
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПоследняяЗапись, , ИсключаемыеПоля);
		ТекущиеДанные.Период = ТекущаяДатаПользователя;
		ТекущиеДанные.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийТорговыеТочки.ИзменениеПараметров");
		РассчитатьСуммуСбора(ТекущиеДанные.ПолучитьИдентификатор());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные.Период < '20150701' Тогда
		ТекущиеДанные.Период = '20150701';
		ТекстСообщения = НСтр("ru='Дата начала использования торговой точки не может быть ранее 01 июля 2015 г.'");
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = ТекстСообщения;
		СообщениеПользователю.Сообщить();
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.Сортировать("Период");
	Элементы.НаборЗаписей.ТекущаяСтрока = Элемент.ТекущиеДанные.ПолучитьИдентификатор();
	УстановитьИдентификаторПоследнейЗаписи(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПослеУдаления(Элемент)
	
	УстановитьИдентификаторПоследнейЗаписи(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлощадьТорговогоЗалаПриИзменении(Элемент)
	
	РассчитатьСуммуСбора(Элементы.НаборЗаписей.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура НалоговаяЛьготаПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.НаборЗаписей.ТекущиеДанные;
	
	НалоговаяЛьготаПриИзмененииНаСервере(ДанныеСтроки.ПолучитьИдентификатор());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НалоговаяЛьготаПриИзмененииНаСервере(ИдентификаторЗаписи)
	
	ПараметрыТорговойТочки = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторЗаписи);
	
	ПараметрыТорговойТочки.КодНалоговойЛьготы = КодНалоговойЛьготы(
		ПараметрыТорговойТочки.НалоговаяЛьгота,
		ПараметрыТорговойТочки.ТипТорговойТочки);
	
	РассчитатьСуммуСбора(ИдентификаторЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСтрок()
	
	Для Каждого Запись Из НаборЗаписей Цикл
		Запись.НалоговаяЛьгота = РегистрыСведений.ПараметрыТорговыхТочек.НаименованиеПоКодуЛьготы(
			Льготы,
			Запись.КодНалоговойЛьготы,
			Запись.ТипТорговойТочки);
		Запись.ПоказыватьЗапись = Запись.ВидОперации <> Перечисления.ВидыОперацийТорговыеТочки.СнятиеСУчета;
	КонецЦикла;
	
	ОтборСтрок = Новый Структура;
	ОтборСтрок.Вставить("ПоказыватьЗапись", Истина);
	Элементы.НаборЗаписей.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.РегистрыСведений.ПараметрыТорговыхТочек)
		ИЛИ Параметры.ТолькоПросмотр Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПараметрыВидимостиРеквизитов =
		ТорговыйСборКлиентСервер.ПараметрыВидимостиРеквизитовПоТипуТорговойТочки(Параметры.ТипТорговойТочки);
		
	Элементы.НаборЗаписей.ПодчиненныеЭлементы.ПлощадьТорговогоЗала.Видимость =
		ПараметрыВидимостиРеквизитов.ГруппаПлощадьТорговогоЗала;
		
	Элементы.НаборЗаписей.ПодчиненныеЭлементы.НалоговаяЛьгота.Видимость =
		ПараметрыВидимостиРеквизитов.ГруппаНалоговыеЛьготы;
		
КонецПроцедуры

&НаСервере
Функция КодНалоговойЛьготы(НалоговаяЛьгота, ТипТорговойТочки)
	
	Результат = РегистрыСведений.ПараметрыТорговыхТочек.КодЛьготыПоНаименованию(Льготы, НалоговаяЛьгота, ТипТорговойТочки);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИдентификаторПоследнейЗаписи(ЭтотОбъект)
	
	НаборЗаписей = ЭтотОбъект.НаборЗаписей;
	ЭтотОбъект.ИдентификаторПоследнейЗаписи = НаборЗаписей[НаборЗаписей.Количество() - 1].ПолучитьИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть()
	
	ДанныеИзменены = Модифицированность;
	Записать();
	Закрыть(ДанныеИзменены);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(ОтветПользователя, ДопПараметры) Экспорт
	
	Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
		ЗаписатьИЗакрыть();
	ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#Область РасчетСтавки

&НаСервере
Процедура РассчитатьСуммуСбора(ИдентификаторЗаписи)
	
	ЗагрузитьПоставляемыеДанные();
	
	ПараметрыТорговойТочки = НаборЗаписей.НайтиПоИдентификатору(ИдентификаторЗаписи);
	РегистрыСведений.ПараметрыТорговыхТочек.РассчитатьСуммуСбора(ПараметрыТорговойТочки, СтавкиСбора, Территории);
	
КонецПроцедуры

#КонецОбласти

#Область ПоставляемыеДанные

&НаСервере
Процедура ЗагрузитьПоставляемыеДанные()
	
	ЗагрузитьТаблицуЛьгот();
	ЗагрузитьТаблицуТерриторий();
	ЗагрузитьТаблицуСтавок();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуЛьгот()
	
	Если ЗначениеЗаполнено(Льготы) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаЛьгот = ТорговыйСбор.ПрочитатьТаблицуЛьгот();
	Льготы.Загрузить(ТаблицаЛьгот);
	
	Элементы.НаборЗаписей.ПодчиненныеЭлементы.НалоговаяЛьгота.СписокВыбора.Очистить();
	
	Для Каждого Льгота Из Льготы Цикл
		Если Льгота.ТипТорговойТочки <> Параметры.ТипТорговойТочки Тогда
			Продолжить;
		КонецЕсли;
		
		Если Льгота.ДействуетС <= Параметры.ДатаДействияЛьготы И Льгота.ДействуетПо >= Параметры.ДатаДействияЛьготы Тогда
			Элементы.НаборЗаписей.ПодчиненныеЭлементы.НалоговаяЛьгота.СписокВыбора.Добавить(Льгота.Наименование);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуТерриторий()
	
	Если ЗначениеЗаполнено(Территории) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаТерриторий = ТорговыйСбор.ПрочитатьТаблицуТерриторий();
	Территории.Загрузить(ТаблицаТерриторий);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьТаблицуСтавок()
	
	Если ЗначениеЗаполнено(СтавкиСбора) Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСтавок = ТорговыйСбор.ПрочитатьТаблицуСтавок();
	СтавкиСбора.Загрузить(ТаблицаСтавок);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


