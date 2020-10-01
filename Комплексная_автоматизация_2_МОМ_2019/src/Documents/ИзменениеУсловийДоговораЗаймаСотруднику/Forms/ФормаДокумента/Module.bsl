
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный, Месяц", 
			"Объект.Организация", "Объект.Ответственный", "Объект.ДатаИзменений");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаОтсрочки(ЭтаФорма, ДатаПредоставления);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПрочитатьДанныеФормы(ТекущийОбъект);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеУсловийДоговораЗаймаСотруднику", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
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
	
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорЗаймаПриИзменении(Элемент)
	ЗаполнитьПоДоговоруЗайма();
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	// Изменяется:
	// - размер погашения (при дифференцированных)
	// - размер платежа (при аннуитетных)
	// - размер процентов (при погашении только процентов).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, Объект.Сумма, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);

КонецПроцедуры

&НаКлиенте
Процедура СрокПриИзменении(Элемент)
	
	// Изменяется:
	// - дата окончания
	// - размер погашения (при дифференцированных)
	// - размер платежа (при аннуитетных).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаИзменений", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ПолныйСрок, Объект.ДатаОкончания, ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
КонецПроцедуры

&НаКлиенте
Процедура ПроцентнаяСтавкаПриИзменении(Элемент)
	
	// Изменяется:
	// - размер платежа (при аннуитетных)
	// - размер процентов (при погашении только процентов).
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, ВидПлатежей, ОстатокЗадолженности, Объект.ПроцентнаяСтавка);
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерПлатежаПриИзменении(Элемент)
	
	// изменяется:
	// - срок и дата окончания
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, СпособПогашения, ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьОграниченияПлатежа(ЭтаФорма, ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаИзменений", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	
КонецПроцедуры

&НаКлиенте
Процедура РазмерПогашенияПриИзменении(Элемент)
	
	// изменяется:
	// - срок и дата окончания
	Объект.ОграничениеПлатежа = ?(ПредоставляетсяОтсрочкаПлатежа, Макс(Объект.РазмерПогашения, Объект.ОграничениеПлатежа), 0);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, СпособПогашения, ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаИзменений", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредоставляетсяОтсрочкаПлатежаПриИзменении(Элемент)
	
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаОтсрочки(ЭтаФорма, Объект.ДатаИзменений);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьОграниченияПлатежа(ЭтаФорма, ВидПлатежей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОграничениеПлатежаПриИзменении(Элемент)

	// Нужно скорректировать размер погашения основного долга.
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);

	// Изменяется:
	// - срок и дата окончания
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПолногоПогашенияЗайма(ЭтаФорма, СпособПогашения, ВидПлатежей, Срок, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ЭтаФорма, "Объект.ДатаИзменений", "Объект.ДатаОкончания", "МесяцОкончания", Срок);
	
КонецПроцедуры

#Область МесяцИзменений

&НаКлиенте
Процедура МесяцИзмененийПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаИзменений", "МесяцИзменений", Модифицированность);
	
	ПриИзмененииМесяцаИзменений();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцИзмененийНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаИзменений", "МесяцИзменений", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененийНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаИзменений();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаИзменений", "МесяцИзменений", Направление, Модифицированность);
	
	ПриИзмененииМесяцаИзменений();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененийАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцИзмененийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область МесяцОкончания

&НаКлиенте
Процедура МесяцОкончанияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", Модифицированность);
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцОкончанияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания", Направление, Модифицированность);
	
	ПриИзмененииМесяцаОкончания();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцОкончанияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область МесяцНачалаПогашенияПослеОтсрочки

&НаКлиенте
Процедура МесяцНачалаПогашенияПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", Модифицированность);
	
	ПриИзмененииМесяцаНачалаПогашения();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачалаПогашенияНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаНачалаПогашения();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения", Направление, Модифицированность);
	
	ПриИзмененииМесяцаНачалаПогашения();

КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачалаПогашенияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область МесяцПредоставленияТранша

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", Модифицированность);
	
	ПриИзмененииМесяцаПредоставленияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаПредоставленияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные, "ДатаПредоставления", "МесяцПредоставленияСтрокой", Направление, Модифицированность);
	
	ПриИзмененииМесяцаПредоставленияТранша();

КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаМесяцПредоставленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТраншиЗайма

#Область МесяцОкончанияПогашенияТранша

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", Модифицированность);
	
	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		Элементы.ТраншиЗайма.ТекущиеДанные, "ДатаПогашения", "МесяцПогашенияСтрокой", Направление, Модифицированность);
	
	ПриИзмененииМесяцаПогашенияТранша();
	
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаМесяцПогашенияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ПолеПогашениеТраншей

&НаКлиенте
Процедура ТраншиЗаймаСрокПриИзменении(Элемент)
		
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ТекущаяСтрока, "ДатаПредоставления", "ДатаПогашения", "МесяцПогашенияСтрокой", ТекущаяСтрока.Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
		
КонецПроцедуры

&НаКлиенте
Процедура ТраншиЗаймаРазмерПогашенияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоРазмеруПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуОкончанияПоСроку(ТекущаяСтрока, "ДатаПредоставления", "ДатаПогашения", "МесяцПогашенияСтрокой", ТекущаяСтрока.Срок);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикПредоставленияЗайма

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ЗаймыСотрудникамКлиентСервер.ГрафикПредоставленияЗаймаВосстановитьПорядокСтрок(Объект.ТраншиЗайма, "ДатаПредоставления", Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьПредставлениеТранша(ЭтаФорма, Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Тогда 
		Возврат;
	КонецЕсли;
		
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьДатуТраншаПоУмолчанию(ТекущаяСтрока, Объект.ТраншиЗайма, ДатаПредоставления, Объект.ДатаОкончания);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафикПредоставленияЗаймаСуммаТраншаПриИзменении(Элемент)
	
	Объект.Сумма = Объект.ТраншиЗайма.Итог("Сумма");
	
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, ВидПлатежей, Объект.Сумма, Объект.ПроцентнаяСтавка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = Неопределено)
	
	ПрочитатьДанныеФормы(ТекущийОбъект);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаИзменений", "МесяцИзменений");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаНачалаПогашения", "МесяцНачалаПогашения");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаИзменений()
	
	ОстатокЗадолженности = ОстатокПоДоговоруЗайма(Объект.ДоговорЗайма, Объект.ДатаИзменений);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(Срок, Объект.ДатаОкончания, Объект.ДатаИзменений);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ПолныйСрок, Объект.ДатаОкончания, ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаОкончания()
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(Срок, Объект.ДатаОкончания, Объект.ДатаИзменений);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ПолныйСрок, Объект.ДатаОкончания, ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаПогашенияТранша()
	
	ТекущаяСтрока = Элементы.ТраншиЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(ТекущаяСтрока.РазмерПогашения, ТекущаяСтрока.Сумма, ТекущаяСтрока.Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаНачалаПогашения()
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПогашения(Объект.РазмерПогашения, ОстатокЗадолженности, Срок, ВидПлатежей, Объект.ОграничениеПлатежа);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииМесяцаПредоставленияТранша()
	
	ТекущаяСтрока = Элементы.ГрафикПредоставленияЗайма.ТекущиеДанные;
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(
		ТекущаяСтрока.Срок, ТекущаяСтрока.ДатаПогашения, ТекущаяСтрока.ДатаПредоставления);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПлатежа(Объект.РазмерПлатежа, Срок, ВидПлатежей, ДанныеЗайма());
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеФормы(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда 
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	ПрочитатьДанныеДоговораЗайма();
	
	ПредоставляетсяОтсрочкаПлатежа = ЗначениеЗаполнено(ТекущийОбъект.ДатаНачалаПогашения);
	ОстатокЗадолженности = ОстатокПоДоговоруЗайма(ТекущийОбъект.ДоговорЗайма, ТекущийОбъект.ДатаИзменений);
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(Срок, ТекущийОбъект.ДатаОкончания, Объект.ДатаИзменений);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокПоДатеОкончания(ПолныйСрок, Объект.ДатаОкончания, ДатаПредоставления);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаТраншей(ЭтаФорма, СпособПредоставления);
	ЗаймыСотрудникамКлиентСервер.УстановитьЭлементыВводаРазмераПогашения(ЭтаФорма, ВидПлатежей);
	ЗаймыСотрудникамКлиентСервер.УстановитьДоступностьНастройкиПогашения(ЭтаФорма, СпособПогашения, ВидПлатежей, Объект.ДатаИзменений);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьРазмерПроцентов(РазмерПроцентов, ВидПлатежей, ОстатокЗадолженности, Объект.ПроцентнаяСтавка);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ТраншиЗайма, "ДатаПредоставления", "МесяцПредоставленияСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Объект.ТраншиЗайма, "ДатаПогашения", "МесяцПогашенияСтрокой");
	
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьПредставленияТраншей(ЭтаФорма);
	ЗаймыСотрудникамКлиентСервер.ЗаполнитьСрокиПогашенияТраншей(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеДоговораЗайма()
	
	// Выполняется чтение параметров договора займа, которые не изменяются, 
	// но хранятся в данных формы для оформления других полей.
	
	РеквизитыДоговора = Новый Массив;
	РеквизитыДоговора.Добавить("СпособПредоставления");
	РеквизитыДоговора.Добавить("СпособПогашения");
	РеквизитыДоговора.Добавить("ВидПлатежей");
	РеквизитыДоговора.Добавить("ДатаПредоставления");

	Если Не ЗначениеЗаполнено(Объект.ДоговорЗайма) Тогда
		Для Каждого РеквизитДоговора Из РеквизитыДоговора Цикл
			ЭтаФорма[РеквизитДоговора] = Неопределено;
		КонецЦикла;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			Объект.ДоговорЗайма, 
			СтрСоединить(РеквизитыДоговора, ", ")));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДоговоруЗайма()
	
	// Заполнение объекта документ.
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.ЗаполнитьПоДоговоруЗайма(Объект.ДоговорЗайма, Объект.ДатаИзменений);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ДатаОкончания", "МесяцОкончания");
	
	ЗаполнитьДанныеФормыПоОрганизации();
	
	ПрочитатьДанныеФормы();
	
	// Заполнение прежних значений для отображения в форме.
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаКлиенте
Функция ДанныеЗайма()
	
	ДанныеЗайма = Новый Структура;
	ДанныеЗайма.Вставить("МесяцПредоставления", Объект.ДатаИзменений);
	ДанныеЗайма.Вставить("МесяцОкончания", Объект.ДатаОкончания);
	ДанныеЗайма.Вставить("ГодоваяСтавка", Объект.ПроцентнаяСтавка);
	ДанныеЗайма.Вставить("СуммаЗайма", ОстатокЗадолженности);
	ДанныеЗайма.Вставить("СпособПредоставления", СпособПредоставления);
	ДанныеЗайма.Вставить("ТраншиЗайма", Объект.ТраншиЗайма);
	ДанныеЗайма.Вставить("СпособПогашения", СпособПогашения);
	ДанныеЗайма.Вставить("ВидПлатежей", ВидПлатежей);
	ДанныеЗайма.Вставить("РазмерПлатежа", Объект.РазмерПлатежа);
	ДанныеЗайма.Вставить("РазмерПогашения", Объект.РазмерПогашения);
	ДанныеЗайма.Вставить("МесяцНачалаПогашения", Объект.ДатаНачалаПогашения);
	ДанныеЗайма.Вставить("ОграничениеПлатежа", Объект.ОграничениеПлатежа);
	
	Возврат ДанныеЗайма;
	
КонецФункции

&НаСервереБезКонтекста
Функция ОстатокПоДоговоруЗайма(ДоговорЗайма, ДатаИзменений)
	
	Возврат ЗаймыСотрудникам.ОстатокЗадолженности(ДоговорЗайма, ДатаИзменений).СуммаЗайма;
	
КонецФункции

#КонецОбласти
