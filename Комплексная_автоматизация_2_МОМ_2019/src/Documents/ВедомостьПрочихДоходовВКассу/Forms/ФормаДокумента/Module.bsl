
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьПрочихДоходовФормы.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
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
	
	ВедомостьПрочихДоходовФормы.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
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
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	ВедомостьПрочихДоходовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ВедомостьПрочихДоходовФормы.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьПрочихДоходовФормы.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи); 
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ВедомостьПрочихДоходовВКассу", ПараметрыЗаписи, Объект.Ссылка);
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
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ВедомостьПрочихДоходовКлиент.ДатаПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтотОбъект);
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОснованийНажатие(Элемент, СтандартнаяОбработка)
	ВедомостьПрочихДоходовКлиент.ПредставлениеОснованийНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СпособВыплатыПриИзменении(Элемент)
	
	Если СпособВыплатыПрежнееЗначение <> Объект.СпособВыплаты Тогда
		Если Объект.Состав.Количество() > 0 Тогда
			ВедомостьПрочихДоходовКлиент.Очистить(ЭтотОбъект);
		КонецЕсли;
		ВедомостьПрочихДоходовКлиентСервер.УстановитьПредставлениеОснований(ЭтотОбъект);
	КонецЕсли;
	СпособВыплатыПрежнееЗначение = Объект.СпособВыплаты;
	
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Модифицированность);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОповещениеЗавершения = Новый ОписаниеОповещения("ПериодРегистрацииНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтотОбъект, ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой",, ОповещениеЗавершения);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтотОбъект, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой", Направление, Модифицированность);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ВнешниеХозяйственныеОперации

&НаКлиенте
Процедура ДатаВыплатыПриИзменении(Элемент)
	ВедомостьПрочихДоходовКлиент.ДатаВыплатыПриИзменении(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПеречислениеНДФЛВыполненоПриИзменении(Элемент)
	ВедомостьПрочихДоходовКлиент.ПеречислениеНДФЛВыполненоПриИзменении(ЭтотОбъект, Элемент);
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

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.КомментарийНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка)
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ВедомостьПрочихДоходовКлиент.СоставВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ВедомостьПрочихДоходовКлиент.Подобрать(ЭтотОбъект);
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	ВедомостьПрочихДоходовКлиент.СоставПередУдалением(ЭтотОбъект, Элемент, Отказ) 
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеПриИзменении(Элемент)
	СоставКВыплатеПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СоставКВыплатеОткрытие(Элемент, СтандартнаяОбработка)
	ВедомостьПрочихДоходовКлиент.СоставКВыплатеОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

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
Процедура Заполнить(Команда)
	ВедомостьПрочихДоходовКлиент.Заполнить(ЭтотОбъект)
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	АдресСпискаПодобранныхФизическихЛиц = Неопределено;
	Если Не ПодготовитьПодборНаСервере(АдресСпискаПодобранныхФизическихЛиц) Тогда
		Возврат;
	КонецЕсли;
	
	ФизическиеЛицаЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуПодбораФизическихЛицПоРоли(
		Элементы.Состав,
		Объект.Организация,
		ОписаниеПодбораПоРолям[Объект.СпособВыплаты],
		АдресСпискаПодобранныхФизическихЛиц);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПодборНаСервере(АдресСпискаПодобранныхФизическихЛиц)

	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	Если ТекущийОбъект.МожноЗаполнитьВыплаты() Тогда
		АдресСпискаПодобранныхФизическихЛиц = АдресСпискаПодобранныхФизическихЛиц();
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;

КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхФизическихЛиц()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Состав.Выгрузить(,"ФизическоеЛицо").ВыгрузитьКолонку("ФизическоеЛицо"), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьНДФЛ(Команда)
	ВедомостьНаВыплатуЗарплатыКлиент.ОбновитьНДФЛ(ЭтотОбъект);	
КонецПроцедуры

&НаКлиенте
Процедура ОплатыПредставлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	ВедомостьНаВыплатуЗарплатыКлиент.ОплатаПоказать(ЭтотОбъект, Элемент, НавигационнаяСсылка, СтандартнаяОбработка);
КонецПроцедуры

#Область ОграничениеДокумента

&НаКлиенте
Процедура Подключаемый_ОграничитьДокумент(Команда)
	
	ОграничитьДокументНаСервере();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВводДанныхОПеречисленииНДФЛ(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.ВвестиДанныеОПеречисленииНДФЛВБюджет(ЭтаФорма, Объект.Ссылка);
	
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

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Возврат ВедомостьПрочихДоходовФормы.КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении()
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Возврат ВедомостьПрочихДоходовФормы.КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов()
КонецФункции

#КонецОбласти

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение, СтандартнаяОбработка)
	ВедомостьПрочихДоходовФормы.СоставОбработкаВыбораНаСервере(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	ВедомостьПрочихДоходовФормы.СоставПослеУдаленияНаСервере(ЭтотОбъект)
КонецПроцедуры

&НаСервере
Процедура СоставКВыплатеПриИзмененииНаСервере()
	ВедомостьПрочихДоходовФормы.СоставКВыплатеПриИзмененииНаСервере(ЭтотОбъект)	
КонецПроцедуры

&НаСервере
Процедура ОграничитьДокументНаСервере()
	
	ОграничениеИспользованияДокументовФормы.ОграничитьДокумент(ЭтотОбъект);
	
КонецПроцедуры

#Область ОбратныеВызовы

// АПК:78-выкл Экспорт необходим для обращений из общей функциональности ведомостей.

&НаСервере
Процедура ЗаполнитьПервоначальныеЗначения() Экспорт
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ВедомостьПрочихДоходовФормы.ЗаполнитьПервоначальныеЗначения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект) Экспорт
	
	ВедомостьПрочихДоходовФормы.ПриПолученииДанныхНаСервере(ЭтотОбъект, ТекущийОбъект);
	ОграничениеИспользованияДокументовФормы.ПриПолученииДанныхНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	ВедомостьПрочихДоходовФормы.ПриПолученииДанныхСтрокиСостава(ЭтотОбъект, СтрокаСостава)
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставлениеОплаты() Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.УстановитьПредставлениеОплаты(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов() Экспорт
	ВедомостьПрочихДоходовФормы.УстановитьДоступностьЭлементов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю() Экспорт
	ВедомостьНаВыплатуЗарплатыФормыРасширенный.ОбработатьСообщенияПользователю(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере() Экспорт
	ВедомостьПрочихДоходовФормы.ЗаполнитьНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере() Экспорт
	ВедомостьПрочихДоходовФормы.ОчиститьНаСервере(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьНДФЛСтроки(ДанныеСтроки) Экспорт
	ВедомостьНаВыплатуЗарплатыКлиент.РедактироватьНДФЛСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьНДФЛСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьНаВыплатуЗарплатыФормы.РедактироватьНДФЛСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНДФЛПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьНаВыплатуЗарплатыФормы.АдресВХранилищеНДФЛПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции

&НаСервере
Процедура ОбновитьНДФЛНаСервере(ИдентификаторыСтрок) Экспорт
	ВедомостьПрочихДоходовФормы.ОбновитьНДФЛНаСервере(ЭтотОбъект, ИдентификаторыСтрок)
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьВыплатуСтроки(ДанныеСтроки) Экспорт
	ВедомостьПрочихДоходовКлиент.РедактироватьВыплатуСтроки(ЭтотОбъект, ДанныеСтроки);	
КонецПроцедуры

&НаСервере
Процедура РедактироватьВыплатуСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	ВедомостьПрочихДоходовФормы.РедактироватьВыплатуСтрокиЗавершениеНаСервере(ЭтотОбъект, РезультатыРедактирования) 
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеВыплатыПоСтроке(ИдентификаторСтроки) Экспорт
	Возврат ВедомостьПрочихДоходовФормы.АдресВХранилищеВыплатыПоСтроке(ЭтотОбъект, ИдентификаторСтроки)
КонецФункции	

// АПК:78-вкл

#КонецОбласти

#КонецОбласти

