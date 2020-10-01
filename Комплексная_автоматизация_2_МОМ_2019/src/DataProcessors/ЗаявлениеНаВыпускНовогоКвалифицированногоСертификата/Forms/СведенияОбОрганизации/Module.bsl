///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем РеквизитыПроверкиАдреса;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СведенияОбОрганизации = Параметры.СведенияОбОрганизации;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СведенияОбОрганизации);
	
	Элементы.КПП.Видимость = Не ЭтоИндивидуальныйПредприниматель;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		ВидКонтактнойИнформации = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Адрес);
			
		ВидКонтактнойИнформации.НастройкиПроверки.ТолькоНациональныйАдрес = Истина;
		
		ВидКонтактнойИнформацииТелефон = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(
			Перечисления["ТипыКонтактнойИнформации"].Телефон);
		
	КонецЕсли;
	
	ПроверитьАдрес("ЮридическийАдрес");
	ПроверитьАдрес("ФактическийАдрес");
	
	УстановитьТолькоПросмотр();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РеквизитыПроверкиАдреса = Новый Структура;
	РеквизитыПроверкиАдреса.Вставить("ЮридическийАдрес", Ложь);
	РеквизитыПроверкиАдреса.Вставить("ФактическийАдрес", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	СтандартнаяОбработка = Ложь;
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РеквизитПриИзменении(Элемент)
	
	Модифицированность = Истина;
	ЭтотОбъект[Элемент.Имя] = СокрЛП(ЭтотОбъект[Элемент.Имя]);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоИндивидуальныйПредпринимательПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Если ЭтоИндивидуальныйПредприниматель Тогда
		ЭтотОбъект.КПП = Неопределено;
	КонецЕсли;
	
	Элементы.КПП.Видимость = Не ЭтоИндивидуальныйПредприниматель;
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ЮридическийАдрес", НСтр("ru = 'Юридический адрес организации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ЮридическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ЮридическийАдрес");
	
	Если Не ЗначениеЗаполнено(ФактическийАдрес) Тогда
		ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ФактическийАдрес");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеАдресаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"ФактическийАдрес", НСтр("ru = 'Фактический адрес организации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОчистка(Элемент, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "ФактическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийАдресОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеАдресаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "ФактическийАдрес");
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПредупреждениеНажатие(Элемент)
	
	ПоказатьПредупреждение(, Элемент.Подсказка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПредставлениеТелефонаНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка,
		"Телефон", НСтр("ru = 'Телефон организации'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОчистка(Элемент, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОчистка(ЭтотОбъект, Элемент, СтандартнаяОбработка, "Телефон");
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Модифицированность = Истина;
	ПредставлениеТелефонаОбработкаВыбора(ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, "Телефон");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СохранитьИзмененияИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗадатьВопросПередЗакрытием();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТолькоПросмотр()
	
	Элементы.ЭтоИндивидуальныйПредприниматель.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Элементы.НаименованиеСокращенное.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Элементы.НаименованиеПолное.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Элементы.ГруппаНомеров.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	Элементы.ГруппаКонтактнаяИнформацияОрганизации.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросПередЗакрытием()
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	КонецЕсли;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗакрытиеПослеОтветаНаВопрос", ЭтотОбъект),
		НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), РежимДиалогаВопрос.ДаНетОтмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеПослеОтветаНаВопрос(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьИзмененияИЗакрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзмененияИЗакрыть()
	
	Если Не Модифицированность Тогда
		Закрыть(Неопределено);
		Возврат;
	ИначеЕсли Не ПроверитьСведенияОбОрганизации() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ЗаполнитьЗначенияСвойств(СведенияОбОрганизации, ЭтотОбъект);
	
	СведенияОбОрганизации.Телефон = ЭтотОбъект.ТелефонXML;
	СведенияОбОрганизации.ФактическийАдрес = ЭтотОбъект.ФактическийАдресXML;
	СведенияОбОрганизации.ЮридическийАдрес = ЭтотОбъект.ЮридическийАдресXML;
	
	Закрыть(СведенияОбОрганизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	ВидКонтактнойИнформации.Наименование = ЗаголовокФормы;
	ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформации, ЭтотОбъект[ИмяРеквизита + "XML"], ЭтотОбъект[ИмяРеквизита]);
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "XML"] = "";
	Форма[ИмяРеквизита] = "";
	
	РеквизитыПроверкиАдреса[ИмяРеквизита] = Истина;
	ПодключитьОбработчикОжидания("ПроверитьАдресОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "XML"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
	РеквизитыПроверкиАдреса[ИмяРеквизита] = Истина;
	ПодключитьОбработчикОжидания("ПроверитьАдресОбработчикОжидания", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, ИмяРеквизита, ЗаголовокФормы)
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		Возврат;
	КонецЕсли;
	
	МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"УправлениеКонтактнойИнформациейКлиент");
	
	ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
		ВидКонтактнойИнформацииТелефон, ЭтотОбъект[ИмяРеквизита + "XML"], ЭтотОбъект[ИмяРеквизита]);
	
	ПараметрыФормы.Вставить("Заголовок", ЗаголовокФормы);
	
	МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОчистка(Форма, Элемент, СтандартнаяОбработка, ИмяРеквизита)
	
	Форма[ИмяРеквизита + "XML"] = "";
	Форма[ИмяРеквизита] = "";
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеТелефонаОбработкаВыбора(Форма, Элемент, ВыбранноеЗначение, СтандартнаяОбработка, ИмяРеквизита)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
		// Данные не изменены.
		Возврат;
	КонецЕсли;
	
	Форма[ИмяРеквизита + "XML"] = ВыбранноеЗначение.КонтактнаяИнформация;
	Форма[ИмяРеквизита] = ВыбранноеЗначение.Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьАдресОбработчикОжидания()
	
	Для Каждого КлючИЗначение Из РеквизитыПроверкиАдреса Цикл
		
		Если КлючИЗначение.Значение Тогда
			ПроверитьАдрес(КлючИЗначение.Ключ);
			РеквизитыПроверкиАдреса[КлючИЗначение.Ключ] = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьАдрес(ИмяРеквизита)
	
	Сообщение = Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПроверитьАдрес(ЭтотОбъект[ИмяРеквизита + "XML"]);
	Если ЗначениеЗаполнено(Сообщение) Тогда
		Элементы[ИмяРеквизита + "Предупреждение"].Подсказка = Сообщение;
		Элементы[ИмяРеквизита + "Предупреждение"].Видимость = Истина;
	Иначе
		Элементы[ИмяРеквизита + "Предупреждение"].Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьСведенияОбОрганизации()
	
	ПроверяемыеРеквизиты = Новый Массив;
	НеобязательныеРеквизиты = Новый Структура(
		"ЭтоИндивидуальныйПредприниматель, Организация, БИК, РасчетныйСчет, КорреспондентскийСчет");
	
	Для Каждого Реквизит Из СведенияОбОрганизации Цикл
		
		ИмяРеквизита = Реквизит.Ключ;
		Если СтрНайти(ИмяРеквизита, "XML") > 0
			Или НеобязательныеРеквизиты.Свойство(ИмяРеквизита)
			Или (ЭтоИндивидуальныйПредприниматель
			И ИмяРеквизита = "КПП") Тогда
			
			Продолжить;
		КонецЕсли;
		
		ПараметрыРеквизитаДляПроверки = Новый Структура;
		ПараметрыРеквизитаДляПроверки.Вставить("Имя", ИмяРеквизита);
		Если ИмяРеквизита = "Телефон"
			Или ИмяРеквизита = "ФактическийАдрес"
			Или ИмяРеквизита = "ЮридическийАдрес" Тогда
			
			ПараметрыРеквизитаДляПроверки.Вставить("Значение", ЭтотОбъект[ИмяРеквизита + "XML"]);
		Иначе
			ПараметрыРеквизитаДляПроверки.Вставить("Значение", ЭтотОбъект[ИмяРеквизита]);
		КонецЕсли;
		
		ПараметрыРеквизитаДляПроверки.Вставить("ПолеСообщения", ИмяРеквизита);
		ПараметрыРеквизитаДляПроверки.Вставить("ТекстНезаполненного",
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Поле ""%1"" не заполнено'"), Элементы[ИмяРеквизита].Заголовок));
			
		ПроверяемыеРеквизиты.Добавить(ПараметрыРеквизитаДляПроверки);
		
	КонецЦикла;
	
	Возврат Не Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПроверитьЗаполнениеРеквизитов(
		ПроверяемыеРеквизиты, ЭтоИндивидуальныйПредприниматель);
		
КонецФункции

#КонецОбласти