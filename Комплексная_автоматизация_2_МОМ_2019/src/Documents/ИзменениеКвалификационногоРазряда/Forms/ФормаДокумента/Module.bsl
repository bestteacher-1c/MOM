
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура(
			"Организация, Ответственный", "Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗначенияДляЗаполнения);
		
		Объект.ДатаИзменения = ТекущаяДатаСеанса();
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			УстановитьТекущиеДанныеСотрудника();
		КонецЕсли;
		
		УстановитьОтображениеНадписей();
		
		// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
		ЭлектронныеТрудовыеКнижки.ЗаполнитьНаименованиеДокумента(Объект, "ИзменениеКвалификационногоРазряда");
		// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
		
	КонецЕсли;
	
	Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("ИзменениеРазрядаЭлемент");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"РазрядКатегория",
		"Заголовок",
		РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитРазрядКатегорияВКадровыхДокументах"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЗначениеПоказателя",
		"Заголовок",
		РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитТарифВКадровыхДокументах"));
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтотОбъект, "Сотрудник");
	КонецЕсли; 
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижки.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПрочитатьВремяРегистрации();
	УстановитьОтображениеНадписей();
	
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеКвалификационногоРазряда", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтотОбъект Тогда
		ЗаполнитьНачисленияИзВРеменногоХранилища(Параметр.АдресВХранилище);
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
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

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры
	
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижкиКлиентСервер.УстановитьОтображениеНомеровДокумента(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияПриИзменении(Элемент)
	
	ДатаИзмененияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура РазрядКатегорияПриИзменении(Элемент)
	
	РазрядКатегорияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеПоказателяПриИзменении(Элемент)
	
	ЗначениеПоказателяПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачисленияУтвержденыПриИзменении(Элемент)
	
	НачисленияУтвержденыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НачисленияУтвержденыПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтотОбъект, "НачисленияУтверждены");
	
КонецПроцедуры

&НаКлиенте
Процедура УчитыватьКакИндексациюЗаработкаПриИзменении(Элемент)
	
	Объект.КоэффициентИндексации = 0;
	РассчитатьКоэффициентИндексацииЗаработка();
	УстановитьВидимостьКоэффициентаИндексации();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоэффициентаИндексации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КоэффициентИндексации", "Видимость", Объект.УчитыватьКакИндексациюЗаработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

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

// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки

&НаКлиенте
Процедура ОтразитьВТрудовойКнижкеПриИзменении(Элемент)
	
	УстановитьДоступностьОтображенияВТрудовойКнижке(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаПриИзменении(Элемент)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаПриИзменении(Объект.Организация, "ИзменениеКвалификационногоРазряда", Объект.НаименованиеДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаОбработкаВыбора(
		Объект.НаименованиеДокумента, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДокументаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ЭлектронныеТрудовыеКнижкиКлиент.НаименованиеДокументаАвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

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
Процедура ИзменитьФОТ(Команда)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний());
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		
		ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки

&НаКлиенте
Процедура Подключаемый_ИзменитьДокумент(Команда)
	
	ЭлектронныеТрудовыеКнижкиКлиент.ДопуститьИзменениеДокумента(ЭтотОбъект);
	
КонецПроцедуры

// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки

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
Процедура ПриПолученииДанныхНаСервере()
	
	УстановитьДоступностьРегистрацииНачислений();
	
	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПрочитатьВремяРегистрации();
	
	ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(
		ЭтотОбъект, НСтр("ru='Изменение разряда утверждено'"), , "НачисленияУтверждены");
		
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);	
		
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтотОбъект, "НачисленияУтверждены");
	
	Если ИспользуетсяРасчетЗарплаты И Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.НачисленияУтверждены Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПрочитатьКадровыеДанныеСотрудника();
	ПрочитатьТарифнуюСетку();
	УстановитьРазмерТекущейСовокупнойТарифнойСтавки();
	
	УстановитьВидимостьРасчетныхПолей();
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		РассчитатьФОТНаФорме(ЭтотОбъект);
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтотОбъект, ОписаниеТаблицыНачислений());
	ЗарплатаКадрыРасширенный.УстановитьРазмерностьСовокупнойТарифнойСтавки(ЭтотОбъект);
	ЗарплатаКадрыРасширенный.УстановитьКомментарийКРазмеруСовокупнойТарифнойСтавки(ЭтотОбъект, Объект.ВидТарифнойСтавки);
	
	УстановитьОтображениеНадписей();
	
	РазрядыКатегорииДолжностей.УстановитьСвязиПараметровВыбораРазрядаКадровогоПриказа(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(Объект.Показатель) Тогда 
		ПоказательИнфо = ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Объект.Показатель);
		ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧДЦ=%1", ПоказательИнфо["Точность"]);
	    ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗначениеПоказателя", "ФорматРедактирования", ФорматРедактирования);
	КонецЕсли;
	
	УстановитьВидимостьКоэффициентаИндексации();
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	УстановитьТекущиеДанныеСотрудника();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ДатаИзмененияПриИзмененииНаСервере()

	ПрочитатьВремяРегистрации();
	УстановитьТекущиеДанныеСотрудника();
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура РазрядКатегорияПриИзмененииНаСервере()
	
	ЗаполнитьЗначениеПоказателя();
	РассчитатьФОТПоДокументу();
	СформироватьОписаниеДолжности();
	
КонецПроцедуры

&НаСервере
Процедура ЗначениеПоказателяПриИзмененииНаСервере()
	
	РассчитатьФОТПоДокументу();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущиеДанныеСотрудника()
	
	ЗаполнитьНачисленияСотрудника();
	
	ПрочитатьКадровыеДанныеСотрудника();
	ПрочитатьТарифнуюСетку();
	ЗаполнитьРазрядСотрудника();
	ЗаполнитьЗначениеПоказателя();
	РассчитатьФОТНаФорме(ЭтотОбъект);
	
	ЗарплатаКадрыРасширенный.УстановитьТекущееЗначениеСовокупнойТарифнойСтавки(ЭтотОбъект, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтотОбъект, ОписаниеТаблицыНачислений(), ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений);
	
	УстановитьРазмерТекущейСовокупнойТарифнойСтавки();
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКадровыеДанныеСотрудника()
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "КоличествоСтавок", Объект.ДатаИзменения);
	Если КадровыеДанные.Количество() > 0 Тогда
		КоличествоСтавок = КадровыеДанные[0].КоличествоСтавок;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.Начисления.Очистить();
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = СотрудникиДаты.Добавить();
	НоваяСтрока.Сотрудник = Объект.Сотрудник;
	НоваяСтрока.Период = ВремяРегистрации;
	
	ДанныеНачислений = РасчетЗарплатыРасширенный.ДействующиеПлановыеНачисления(СотрудникиДаты, Объект.Ссылка);
	Объект.Начисления.Загрузить(ДанныеНачислений.Начисления);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТарифнуюСетку()
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "Должность,ДолжностьПоШтатномуРасписанию", ВремяРегистрации, , Ложь);
		Если ДанныеСотрудников.Количество() > 0 Тогда
			
			Должность = ДанныеСотрудников[0].Должность;
			ДолжностьПоШтатномуРасписанию = ДанныеСотрудников[0].ДолжностьПоШтатномуРасписанию;
			
			КадровыйУчетФормыРасширенный.УстановитьДанныеДолжностиВФорме(
				ЭтотОбъект, ВремяРегистрации, Должность, ДолжностьПоШтатномуРасписанию);
			
			РазрядыКатегорииДолжностей.ПрочитатьДанныеТарифныхСетокДолжностиВФорму(ЭтотОбъект, Должность, ДолжностьПоШтатномуРасписанию, ВремяРегистрации);
			
			СвойстваДолжности = ЭлектронныеТрудовыеКнижкиПовтИсп.СвойстваДолжности(Должность);
			ПредставлениеДолжности = СвойстваДолжности.Представление;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазрядСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.РазрядКатегория = Неопределено;
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	СписокСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
	
	ПоляОтбора = Новый Структура("РазрядыКатегорииСотрудников", Отбор);
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Ложь, СписокСотрудников, "РазрядКатегория", ВремяРегистрации, ПоляОтбора, Ложь);  
	
	Если КадровыеДанные.Количество() > 0 Тогда 
		Объект.РазрядКатегория = КадровыеДанные[0].РазрядКатегория;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначениеПоказателя()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.Показатель = Неопределено;
	Объект.ЗначениеПоказателя = 0;
	
	Если Не ЗначениеЗаполнено(Объект.Сотрудник) Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) Тогда 
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Массив;
	Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
	
	ПоляОтбора = Новый Структура("КадроваяИсторияСотрудников", Отбор);
	
	ТарифнаяСетка = Неопределено;
	ТарифнаяСеткаНадбавки = Неопределено;
	
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ТарифнаяСетка,ТарифнаяСеткаНадбавки", ВремяРегистрации, ПоляОтбора, Ложь);
	Если КадровыеДанныеСотрудника.Количество() > 0  Тогда
		ТарифнаяСетка = КадровыеДанныеСотрудника[0].ТарифнаяСетка;
		ТарифнаяСеткаНадбавки = КадровыеДанныеСотрудника[0].ТарифнаяСеткаНадбавки;
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении") Тогда 
		
		Если Не ЗначениеЗаполнено(ТарифнаяСеткаНадбавки) Тогда 
			Возврат;
		КонецЕсли;	
		
		Объект.Показатель = РазрядыКатегорииДолжностей.ПоказательТарифнойСеткиСотрудника( , ТарифнаяСеткаНадбавки, Объект.Начисления);	
		ТарифнаяСетка = ТарифнаяСеткаНадбавки;
		
	Иначе 
		
		Если Не ЗначениеЗаполнено(ТарифнаяСетка) Тогда 
			Возврат;
		КонецЕсли;	
		
		Объект.Показатель = РазрядыКатегорииДолжностей.ПоказательТарифнойСеткиСотрудника(ТарифнаяСетка, , Объект.Начисления);
		
	КонецЕсли;
	
	КоэффициентПересчета = 1;
	Если ЗначениеЗаполнено(Объект.Показатель) Тогда 
		ПоказательИнфо = ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Объект.Показатель);
		Если ПоказательИнфо.ВидТарифнойСтавки = Перечисления.ВидыТарифныхСтавок.МесячнаяТарифнаяСтавка Тогда
			КоэффициентПересчета = КоличествоСтавок;
		КонецЕсли; 
		ФорматРедактирования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧДЦ=%1", ПоказательИнфо["Точность"]);
	    ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЗначениеПоказателя", "ФорматРедактирования", ФорматРедактирования);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Период",  Объект.ДатаИзменения);
	Запрос.УстановитьПараметр("ТарифнаяСетка", ТарифнаяСетка);
	Запрос.УстановитьПараметр("РазрядКатегория", Объект.РазрядКатегория);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	&Период КАК Период,
	               |	&ТарифнаяСетка КАК ТарифнаяСетка,
	               |	&РазрядКатегория КАК РазрядКатегория
	               |ПОМЕСТИТЬ ВТДанныеДокумента";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = РазрядыКатегорииДолжностей.ПараметрыПостроенияВТЗначенияПоказателейТарифныхСеток("ВТДанныеДокумента");
	
	РазрядыКатегорииДолжностей.СоздатьВТЗначенияПоказателейТарифныхСеток(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПостроения);
	
	Запрос.УстановитьПараметр("КоэффициентПересчета", КоэффициентПересчета);
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияПоказателейТарифныхСеток.ЗначениеПоказателя * &КоэффициентПересчета КАК ЗначениеПоказателя
	               |ИЗ
	               |	ВТЗначенияПоказателейТарифныхСеток КАК ЗначенияПоказателейТарифныхСеток";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда 
		ЗаполнитьЗначенияСвойств(Объект, Выборка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений() 
	
	Возврат Новый Структура("ПутьКДанным", "Объект.Начисления");

КонецФункции

&НаСервере
Процедура РассчитатьФОТПоДокументу()

	Если Не ЗначениеЗаполнено(Объект.Сотрудник) 
		Или Не ЗначениеЗаполнено(Объект.ДатаИзменения) 
		Или Не ЗначениеЗаполнено(Объект.Показатель) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Объект.Организация);
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();

	МассивНачислений = ОбщегоНазначения.ВыгрузитьКолонку(Объект.Начисления, "Начисление", Истина);
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(МассивНачислений, ПланыВидовРасчета.Начисления.ПустаяСсылка());
	
	ИнформацияОВидахРасчета = ЗарплатаКадрыРасширенный.ИнформацияОВидахРасчета(МассивНачислений);
	
	ОснованияНачислений = Новый Массив;
	
	// Все начисления сотрудника
	Для Каждого СтрокаНачисления Из Объект.Начисления Цикл
		
		ВидРасчетаИнфо = ИнформацияОВидахРасчета[СтрокаНачисления.Начисление];
		Если ВидРасчетаИнфо = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ДанныеНачисления = ТаблицаНачислений.Добавить();
		ДанныеНачисления.Сотрудник = Объект.Сотрудник;
		ДанныеНачисления.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеНачисления.Период = ВремяРегистрации;
		ДанныеНачисления.Начисление = СтрокаНачисления.Начисление;
		ДанныеНачисления.ДокументОснование = СтрокаНачисления.ДокументОснование;
		ДанныеНачисления.Размер = ?(ВидРасчетаИнфо.Рассчитывается, 0, СтрокаНачисления.Размер);
		
		Для Каждого СведенияОПоказателе Из ВидРасчетаИнфо.Показатели Цикл 
			Если СведенияОПоказателе.Показатель = Объект.Показатель Тогда
				Если ОснованияНачислений.Найти(СтрокаНачисления.ДокументОснование) = Неопределено Тогда 
					ОснованияНачислений.Добавить(СтрокаНачисления.ДокументОснование);
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	
	КонецЦикла;
	
	Если ОснованияНачислений.Количество() = 0 Тогда 
		ДанныеПоказателя = ТаблицаПоказателей.Добавить();
		ДанныеПоказателя.Сотрудник = Объект.Сотрудник;
		ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
		ДанныеПоказателя.Период = ВремяРегистрации;

		ДанныеПоказателя.Показатель = Объект.Показатель;
		ДанныеПоказателя.ДокументОснование = Неопределено;
		ДанныеПоказателя.Значение = Объект.ЗначениеПоказателя;
	Иначе 
		Для Каждого ДокументОснование Из ОснованияНачислений Цикл 
			ДанныеПоказателя = ТаблицаПоказателей.Добавить();
			ДанныеПоказателя.Сотрудник = Объект.Сотрудник;
			ДанныеПоказателя.ГоловнаяОрганизация = ГоловнаяОрганизация;
			ДанныеПоказателя.Период = ВремяРегистрации;
			ДанныеПоказателя.Показатель = Объект.Показатель;
			ДанныеПоказателя.ДокументОснование = ДокументОснование;
			ДанныеПоказателя.Значение = Объект.ЗначениеПоказателя;
		КонецЦикла;
	КонецЕсли;
	
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей);
		
	Объект.Начисления.Очистить();
	
	Для Каждого ОписаниеНачисления Из ТаблицаНачислений Цикл
		
		НовоеНачисление = Объект.Начисления.Добавить();
		НовоеНачисление.Начисление = ОписаниеНачисления.Начисление;
		НовоеНачисление.ДокументОснование = ОписаниеНачисления.ДокументОснование;
		НовоеНачисление.Размер = ОписаниеНачисления.ВкладВФОТ;
		
	КонецЦикла;
	
	Если РассчитанныеДанные.ТарифныеСтавки.Количество() > 0 Тогда 
		Объект.СовокупнаяТарифнаяСтавка = РассчитанныеДанные.ТарифныеСтавки[0].СовокупнаяТарифнаяСтавка;
		Объект.ВидТарифнойСтавки = РассчитанныеДанные.ТарифныеСтавки[0].ВидТарифнойСтавки;
	Иначе 
		Объект.СовокупнаяТарифнаяСтавка = Неопределено;
		Объект.ВидТарифнойСтавки = Неопределено;
	КонецЕсли;
	
	РассчитатьКоэффициентИндексацииЗаработка();
	
	РассчитатьФОТНаФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьФОТНаФорме(Форма)
	
	Форма.ФОТ = Форма.Объект.Начисления.Итог("Размер");
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний()
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = Объект.Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	ДополнитьСтруктуруНачислениямиИПоказателями(ПараметрыОткрытия);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруНачислениямиИПоказателями(ПараметрыОткрытия)
	
	МассивНачислений = Новый Массив;
	МассивПоказателей = Новый Массив;
	
	ИдентификаторСтрокиВидаРасчета = 1;
	Для каждого СтрокаНачислений Из Объект.Начисления Цикл
		
		СтруктураНачисления = Новый Структура("Начисление,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		СтруктураНачисления.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
		МассивНачислений.Добавить(СтруктураНачисления);
		
		ОписаниеНачисления = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(СтруктураНачисления.Начисление);
		Для каждого ОписаниеПоказателя Из ОписаниеНачисления.Показатели Цикл
			Если ОписаниеПоказателя.ЗапрашиватьПриВводе Тогда
				
				Если ОписаниеПоказателя.Показатель = Объект.Показатель Тогда
					СтруктураПоказателя = Новый Структура("Показатель,ИдентификаторСтрокиВидаРасчета,Значение");
					СтруктураПоказателя.Показатель = ОписаниеПоказателя.Показатель;
					СтруктураПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
					СтруктураПоказателя.Значение = Объект.ЗначениеПоказателя;
					МассивПоказателей.Добавить(СтруктураПоказателя);
				КонецЕсли; 
				
			КонецЕсли; 
		КонецЦикла;
		
		ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	ПараметрыОткрытия.Показатели = МассивПоказателей;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияИзВРеменногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Если ДанныеИзХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
		
		СтрокиНачисления = Объект.Начисления.НайтиСтроки(Новый Структура("Начисление", НачислениеСотрудника.Начисление));
		Если СтрокиНачисления.Количество() > 0 Тогда
			СтрокиНачисления[0].Размер = НачислениеСотрудника.Размер;
		КонецЕсли;		
		
	КонецЦикла;
	
	РассчитатьФОТНаФорме(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, Объект.Сотрудник, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
								МассивСотрудников, Объект.Ссылка, ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений);
	
	УстановитьДоступностьОтображенияВТрудовойКнижке(ЭтотОбъект);
	
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижкиКлиентСервер.УстановитьОтображениеНомеровДокумента(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	
КонецПроцедуры

#Область ПроцедурыИФункцииМеханизмаМногофункциональныхДокументов

&НаСервере
Процедура УстановитьВидимостьРасчетныхПолей()
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("ГруппаФОТ");
	ИменаЭлементов.Добавить("ЗначениеПоказателя");
	ИменаЭлементов.Добавить("СовокупнаяТарифнаяСтавкаСтраница");
	ИменаЭлементов.Добавить("ИндексацияГруппа");
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтотОбъект, ИменаЭлементов);
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "ГруппаФОТ", "ТолькоПросмотр", Истина);
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "СовокупнаяТарифнаяСтавкаСтраница", "ТолькоПросмотр", Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КоэффициентИндексации", "ТолькоПросмотр", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей()
	
	БылиОграничения = ОграниченияНаУровнеЗаписей;
	УстановитьДоступностьРегистрацииНачислений();
	
	Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений
		Или БылиОграничения.ИзменениеБезОграничений <> ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений
		Или БылиОграничения.ИзменениеКадровыхДанных <> ОграниченияНаУровнеЗаписей.ИзменениеКадровыхДанных Тогда 
		
		Объект.ОтменаДоплатыУтверждена = ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
		
		УстановитьВидимостьРасчетныхПолей();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	ЗаполнитьДанныеФормыПоОрганизации();
	
	// ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	ЭлектронныеТрудовыеКнижки.ЗаполнитьНаименованиеДокумента(Объект, "ИзменениеКвалификационногоРазряда");
	// Конец ЗарплатаКадрыПодсистемы.КадровыйУчет.ЭлектронныеТрудовыеКнижки
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРазмерТекущейСовокупнойТарифнойСтавки()
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = СотрудникиДаты.Добавить();
	НоваяСтрока.Сотрудник = Объект.Сотрудник;
	НоваяСтрока.Период = ВремяРегистрации;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущиеДанныеОплатыТруда = ПлановыеНачисленияСотрудников.ТекущиеДанныеОплатыТрудаСотрудников(Объект.Ссылка, СотрудникиДаты);
	
	Если ТекущиеДанныеОплатыТруда.Количество() > 0 Тогда 
		ТекущаяСовокупнаяТарифнаяСтавка = ТекущиеДанныеОплатыТруда[0].СовокупнаяТарифнаяСтавка;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьКоэффициентИндексацииЗаработка()
	
	УстановитьПривилегированныйРежим(Истина);
	Объект.КоэффициентИндексации = УчетСреднегоЗаработкаКлиентСервер.КоэффициентИндексацииЗаработка(Объект.СовокупнаяТарифнаяСтавка, ТекущаяСовокупнаяТарифнаяСтавка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьОтображенияВТрудовойКнижке(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"СведенияТрудовойКнижкиГруппа",
		"Доступность",
		Форма.Объект.ОтразитьВТрудовойКнижке);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеДолжности()
	
	Объект.ОписаниеДолжностиДляЗаписиОТрудовойДеятельности =
		СтрШаблон(НСтр("ru = 'Присвоен %1 по специальности ""%2""'"), Объект.РазрядКатегория, ПредставлениеДолжности);
	
КонецПроцедуры

#КонецОбласти
