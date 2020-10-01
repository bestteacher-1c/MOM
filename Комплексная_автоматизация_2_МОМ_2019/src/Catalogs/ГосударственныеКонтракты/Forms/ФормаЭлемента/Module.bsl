
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	МакетПоставляемыеДанные = Справочники.ГосударственныеКонтракты.ПолучитьМакет("ИдентификаторыИнформацииОЗакупке").ПолучитьТекст();
	ИдентификаторыИнформацииОЗакупке = ОбщегоНазначения.ПрочитатьXMLВТаблицу(МакетПоставляемыеДанные).Данные;
	
	КодСпособаОпределенияПоставщикаСписокВыбора = Элементы.КодСпособаОпределенияПоставщика.СписокВыбора;
	Для каждого СтрокаТаблицы Из ИдентификаторыИнформацииОЗакупке Цикл
		КодСпособаОпределенияПоставщикаСписокВыбора.Добавить(Число(СтрокаТаблицы.Код), "(" + СтрокаТаблицы.Код + ") " + СтрокаТаблицы.Наименование);
	КонецЦикла;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	// Обработчик подсистемы запрета редактирования реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)

	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
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

&НаКлиенте
Процедура ЗаполнитьИдентификатор(Команда)
	
	Объект.Код = Прав(Строка(Год(Объект.ДатаЗаключения)), 2) +
		Прав(Строка(Объект.ГодОкончанияСрокаДействия), 2) +
		Объект.КодГосударственногоЗаказчика +
		Строка(Объект.КодСпособаОпределенияПоставщика) +
		Объект.ПорядковыйНомер +
		Объект.ВидЦены +
		Объект.ДополнительныеРазряды;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодГосударственногоЗаказчикаПриИзменении(Элемент)
	
	Объект.КодГосударственногоЗаказчика = СтрЗаменить(Объект.КодГосударственногоЗаказчика, " ", "0");
	
КонецПроцедуры

&НаКлиенте
Процедура КодГосударственногоЗаказчикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СтрокаПоиска", Объект.КодГосударственногоЗаказчика);
	СтруктураПараметров.Вставить("Заголовок",    НСтр("ru = 'Код государственного заказчика'"));
	СтруктураПараметров.Вставить("ГодПлатежа",   Год(Объект.ДатаЗаключения));
	ОткрытьФорму("Справочник.ГосударственныеКонтракты.Форма.ВыборКодаИзКлассификатора", СтруктураПараметров, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПриИзменении(Элемент)
	
	Объект.ПорядковыйНомер = СтрЗаменить(Объект.ПорядковыйНомер, " ", "0");
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеРазрядыПриИзменении(Элемент)
	
	Объект.ДополнительныеРазряды = СтрЗаменить(Объект.ДополнительныеРазряды, " ", "0");
	
КонецПроцедуры

&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	ОписаниеТипаДата = Новый ОписаниеТипов("Дата");
	
	Если ЗначениеЗаполнено(Объект.Код) Тогда
		Объект.ДатаЗаключения                   = ОписаниеТипаДата.ПривестиЗначение("20" + Лев(Объект.Код, 2) + "0101");
		Объект.ГодЗаключения                    = "20" + Лев(Объект.Код, 2);
		Объект.ГодОкончанияСрокаДействия        = "20" + Сред(Объект.Код, 3, 2);
		Объект.КодГосударственногоЗаказчика     = Сред(Объект.Код, 5, 3);
		Объект.КодСпособаОпределенияПоставщика  = Сред(Объект.Код, 8, 1);
		Объект.ПорядковыйНомер                  = Сред(Объект.Код, 9, 4);
		Объект.ВидЦены                          = Сред(Объект.Код, 13, 1);
		Объект.ДополнительныеРазряды            = Сред(Объект.Код, 14, 12);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗаключенияПриИзменении(Элемент)
	
	Объект.ГодЗаключения = Год(Объект.ДатаЗаключения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
