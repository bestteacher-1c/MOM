
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначенияПервоначальногоЗаполнения());
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ЗаполнитьПризнакПринятоВПФР();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
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
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииНаСервере();	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ДобавитьСотрудниковВДокумент(ЭтотОбъект, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные.ПринятоВПФР Или ТекущиеДанные.ОтменаПринятаВПФР Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи", ЭтотОбъект, Команда);
	
	ИмяКоманды = Команда.Имя;
	АдресНастроек = ЭтотОбъект.ПараметрыПодключаемыхКоманд.АдресТаблицыКоманд;
	ОписаниеКоманды = ПодключаемыеКомандыКлиентПовтИсп.ОписаниеКоманды(ИмяКоманды, АдресНастроек);
	
	Если Объект.Ссылка.Пустая()
		Или (ОписаниеКоманды.РежимЗаписи <> "ЗаписыватьТолькоНовые" И Модифицированность) Тогда
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Данные еще не записаны.
				|Выполнение действия ""%1"" возможно только после записи данных.
				|Данные будут записаны.'"),
			ОписаниеКоманды.Представление);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		
		Возврат;
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, Неопределено);
	
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

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подбор(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ДатаПримененияОтбора", Объект.Дата);
	
	ПараметрыОткрытия = Новый Структура("Отбор", СтруктураОтбора);
	
	КадровыйУчетКлиент.ВыбратьФизическихЛицОрганизации(
		Элементы.Сотрудники,
		Объект.Организация,
		Истина,
		,
		АдресСпискаПодобранныхСотрудников(),
		,
		ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПодключаемуюКомандуПослеПодтвержденияЗаписи(РезультатВопроса, Команда) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда
		
		Отказ = Ложь;
		ПроверкаЗаполненияДокумента(Отказ);
		
		Если Не Отказ Тогда
			
			ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
			Записать(ПараметрыЗаписи);
			Если Объект.Ссылка.Пустая() Или Модифицированность Тогда
				Возврат; // Запись не удалась, сообщения о причинах выводит платформа.
			КонецЕсли;
			
			ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
			
		КонецЕсли;
		
		Возврат;
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
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

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияПервоначальногоЗаполнения()
	
	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Объект.Ответственный");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗапрашиваемыеЗначенияЗаполненияПоОрганизации()
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Объект.Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "Объект.ДолжностьРуководителя");
	
	Возврат ЗапрашиваемыеЗначения;
	
КонецФункции 	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Сотрудники.Очистить();

	ЗапрашиваемыеЗначения = ЗапрашиваемыеЗначенияЗаполненияПоОрганизации();
	Если Не ЗапрашиваемыеЗначения.Свойство("Организация") Тогда
		ЗапрашиваемыеЗначения.Вставить("Организация", "Объект.Организация");
	КонецЕсли; 
	
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЗаполненияДокумента(Отказ)
	
	ОчиститьСообщения();
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" не заполнено'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения, Объект.Ссылка, "Организация", "Объект", Отказ);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Руководитель) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Руководитель"" не заполнено'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения, Объект.Ссылка, "Руководитель", "Объект", Отказ);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.ДолжностьРуководителя) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Должность"" не заполнено'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения, Объект.Ссылка, "ДолжностьРуководителя", "Объект", Отказ);
		
	КонецЕсли;
	
	Если Объект.Сотрудники.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'не введено ни одной строки в список ""Сотрудники""'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			ТекстСообщения, Объект.Ссылка, "Сотрудники", "Объект", Отказ);
		
	Иначе
		
		Для Каждого СтрокаСотрудники Из Объект.Сотрудники Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаСотрудники.Сотрудник) Тогда
				
				
				ТекстСообщения = НСтр("ru = 'Поле ""Сотрудник"" не заполнено'");
				
				ОбщегоНазначенияКлиент.СообщитьПользователю(
					ТекстСообщения, Объект.Ссылка, "Сотрудники[" + Формат(СтрокаСотрудники.НомерСтроки - 1, "ЧГ=") + "].Сотрудник", "Объект", Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Объект.Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПризнакПринятоВПФР()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Сотрудники", Объект.Сотрудники.Выгрузить(, "Сотрудник").ВыгрузитьКолонку("Сотрудник"));
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Сотрудник КАК Сотрудник,
	               |	НЕ СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПродолженииОтмена КАК ПринятоВПФР,
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПродолженииОтмена КАК ОтменаПринятаВПФР
	               |ПОМЕСТИТЬ ВТДокументыПринятыеВПФР
	               |ИЗ
	               |	Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.Сотрудники КАК СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники
	               |ГДЕ
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Ссылка.Проведен
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Ссылка.ДокументПринятВПФР
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПродолжении = &Ссылка
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Сотрудник В(&Сотрудники)
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Сотрудник,
	               |	НЕ СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПредоставленииОтмена,
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПредоставленииОтмена
	               |ИЗ
	               |	Документ.СведенияОТрудовойДеятельностиРаботниковСЗВ_ТД.Сотрудники КАК СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники
	               |ГДЕ
	               |	СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Ссылка.Проведен
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Ссылка.ДокументПринятВПФР
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.ЗаявлениеОПредоставлении = &Ссылка
	               |	И СведенияОТрудовойДеятельностиРаботниковСЗВ_ТДСотрудники.Сотрудник В(&Сотрудники)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДокументыПринятыеВПФР.Сотрудник КАК Сотрудник,
	               |	МАКСИМУМ(ДокументыПринятыеВПФР.ПринятоВПФР) КАК ПринятоВПФР,
	               |	МАКСИМУМ(ДокументыПринятыеВПФР.ОтменаПринятаВПФР) КАК ОтменаПринятаВПФР
	               |ИЗ
	               |	ВТДокументыПринятыеВПФР КАК ДокументыПринятыеВПФР
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДокументыПринятыеВПФР.Сотрудник";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		НайденныеСтроки = Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Выборка.Сотрудник)); 
		Если НайденныеСтроки.Количество() > 0 Тогда
			ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], Выборка, "ПринятоВПФР,ОтменаПринятаВПФР");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Объект.Сотрудники.Очистить();
	
	СотрудникиБезЗаявления = ЭлектронныеТрудовыеКнижки.СотрудникиНеВыбравшиеСпособВеденияТрудовойКнижки(
		Объект.Организация, Объект.Дата);
	
	ДобавитьСотрудниковВДокумент(ЭтотОбъект, СотрудникиБезЗаявления);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьСотрудниковВДокумент(Форма, ДобавляемыеСотрудники)
	
	Для Каждого Сотрудник Из ДобавляемыеСотрудники Цикл
		
		Если Форма.Объект.Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник)).Количество() = 0 Тогда
			НоваяСтрокаСотрудника = Форма.Объект.Сотрудники.Добавить();
			НоваяСтрокаСотрудника.Сотрудник = Сотрудник;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
