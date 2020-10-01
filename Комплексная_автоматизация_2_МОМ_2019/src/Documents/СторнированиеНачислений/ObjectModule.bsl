#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Сторнировать" Тогда
		ЗаполнитьПоСторнируемомуДокументу(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДополнительныеСвойства.Вставить("СторнируемыйДокумент", СторнируемыйДокумент);
	Документы.СторнированиеНачислений.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("Сторнирование", Истина);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьДокументОснование(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПериодДействияНачислений(Отказ);
	
	// Сторнирование производим следующим или текущим месяцем.
	ОписаниеДокумента = Документы.СторнированиеНачислений.ОписаниеСторнируемогоДокумента(СторнируемыйДокумент);
	ПериодРегистрацииСторнируемогоДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СторнируемыйДокумент, ОписаниеДокумента.МесяцНачисленияИмя);
	Если ПериодРегистрацииСторнируемогоДокумента <> Неопределено
		И ПериодРегистрацииСторнируемогоДокумента > ПериодРегистрации Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Период сторнирования не может быть меньше периода сторнируемого документа (%1 г.)'"),
			Формат(ПериодРегистрацииСторнируемогоДокумента, "ДФ='ММММ гггг'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"ПериодРегистрации",,Отказ);
	КонецЕсли;
	
	// Проверка корректности распределения по источникам финансирования
	ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "ДоначисленияИПерерасчеты,Сторнировано";
	
	ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
		ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
	
	// Проверка корректности распределения по территориям и условиям труда
	ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "ДоначисленияИПерерасчеты";
	
	РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
		ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("ДоначисленияИПерерасчеты", НСтр("ru = 'Доначисления и перерасчеты'")));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
	
КонецПроцедуры

Процедура ЗаполнитьПоСторнируемомуДокументу(ДанныеЗаполнения)
	
	Сторнировано.Очистить();
	ДоначисленияИПерерасчеты.Очистить();
	Показатели.Очистить();
	РаспределениеРезультатовНачислений.Очистить();
	РаспределениеПоТерриториямУсловиямТруда.Очистить();
	
	СторнируемыйДокумент = ДанныеЗаполнения.Ссылка;
	
	ОписаниеДокумента = Документы.СторнированиеНачислений.ОписаниеСторнируемогоДокумента(СторнируемыйДокумент);
	ДополнитьОписаниеСторнируемогоДокумента(ОписаниеДокумента, СторнируемыйДокумент);
	
	Если ОписаниеДокумента.РеквизитНачислениеДокумента = Неопределено Тогда
		ДополнительныеПараметры = Неопределено;
	Иначе
		// Начисление будет получено из "шапки" документа.
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("НачислениеДокумента", ОписаниеДокумента.РеквизитНачислениеДокумента);
		ДополнительныеПараметры.Вставить("ЗачетНормыВремени", ОписаниеДокумента.РеквизитНачислениеДокумента + ".ЗачетНормыВремени");
	КонецЕсли;
	
	ПараметрыСторнируемогоДокумента = Неопределено;
	ИсправлениеДокументовЗарплатаКадры.ЗаполнитьПараметрыИсправляемогоДокумента(
		ПараметрыСторнируемогоДокумента, СторнируемыйДокумент, ОписаниеДокумента.МесяцНачисленияИмя, ДополнительныеПараметры);
	
	Если ОписаниеДокумента.РеквизитНачислениеДокумента = Неопределено Тогда
		НачислениеДокумента = Неопределено;
	Иначе
		НачислениеДокумента = ПараметрыСторнируемогоДокумента["НачислениеДокумента"];
		НачислениеДокументаЗачетНормыВремени = ПараметрыСторнируемогоДокумента["ЗачетНормыВремени"];
	КонецЕсли;
	
	Организация = ПараметрыСторнируемогоДокумента.Организация;
	ИмяТаблицы = ОбщегоНазначения.ИмяТаблицыПоСсылке(СторнируемыйДокумент);
	
	Если ДанныеЗаполнения.Свойство("Период") Тогда
		ПериодРегистрации = ДанныеЗаполнения.Период;
	ИначеЕсли ДанныеЗаполнения.Свойство("ДопустимоИсправлениеВТекущемПериоде") И ДанныеЗаполнения.ДопустимоИсправлениеВТекущемПериоде Тогда
		ПериодРегистрации = ДанныеЗаполнения.ПериодРегистрацииИсправленногоДокумента;
	Иначе
		ЗаполняемыеЗначения = Новый Структура("Месяц");
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
		ПериодРегистрации = Макс(ЗаполняемыеЗначения.Месяц, ДобавитьМесяц(ПараметрыСторнируемогоДокумента.ПериодРегистрации, 1));
		ДоначислитьЗарплатуПриНеобходимости = Истина;
	КонецЕсли;
	
	ДоначислитьЗарплатуПриНеобходимости = ДоначислитьЗарплатуПриНеобходимости И (ПараметрыСторнируемогоДокумента.ПериодРегистрации < ПериодРегистрации);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", СторнируемыйДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Начисления.Регистратор КАК ДокументНачисления
		|ПОМЕСТИТЬ ВТДокументыНачисления
		|ИЗ
		|	РегистрРасчета.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.ДокументОснование = &Ссылка
		|	И Начисления.Регистратор <> &Ссылка";
	
	Если ОписаниеДокумента.ДокументБезДатаНачала И Не ОписаниеДокумента.ДокументСТаблицейНачисления Тогда
		// Это случай, когда сторнируется документ без таблицы "Начисления" (пример - ИндивидуальныйГрафик).
		ТекстПоСторнируемому = 
			"ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ ПЕРВЫЕ 0
			|	NULL КАК Сотрудник";
	Иначе
		ТекстПоСторнируемому = 
			"ВЫБРАТЬ
			|	*
			|ИЗ
			|	#Начисления КАК Начисления
			|ГДЕ
			|	Начисления.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	*
			|ИЗ
			|	#РаспределениеРезультатовНачислений КАК РаспределениеРезультатов
			|ГДЕ
			|	РаспределениеРезультатов.Ссылка = &Ссылка
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	*
			|ИЗ
			|	#РаспределениеПоТерриториямУсловиямТруда КАК РаспределениеПоТерриториям
			|ГДЕ
			|	РаспределениеПоТерриториям.Ссылка = &Ссылка";
		
		ТекстПоСторнируемому = СтрЗаменить(ТекстПоСторнируемому, "#Начисления", ИмяТаблицы + ".Начисления");
		ТекстПоСторнируемому = СтрЗаменить(ТекстПоСторнируемому, "#РаспределениеРезультатовНачислений", ИмяТаблицы + ".РаспределениеРезультатовНачислений");
		ТекстПоСторнируемому = СтрЗаменить(ТекстПоСторнируемому, "#РаспределениеПоТерриториямУсловиямТруда", ИмяТаблицы + ".РаспределениеПоТерриториямУсловиямТруда");
	КонецЕсли;
	
	ТекстПоОснованиям = 
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	Документ.НачислениеЗарплаты.Начисления КАК НачислениеЗарплаты
		|ГДЕ
		|	НачислениеЗарплаты.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТДокументыНачисления.ДокументНачисления
		|			ИЗ
		|				ВТДокументыНачисления)
		|	И НачислениеЗарплаты.ДокументОснование = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	*
		|ИЗ
		|	Документ.НачислениеЗарплаты.РаспределениеРезультатовНачислений КАК НачислениеЗарплаты
		|ГДЕ
		|	НачислениеЗарплаты.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТДокументыНачисления.ДокументНачисления
		|			ИЗ
		|				ВТДокументыНачисления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	*
		|ИЗ
		|	Документ.НачислениеЗарплаты.РаспределениеПоТерриториямУсловиямТруда КАК НачислениеЗарплаты
		|ГДЕ
		|	НачислениеЗарплаты.Ссылка В
		|			(ВЫБРАТЬ
		|				ВТДокументыНачисления.ДокументНачисления
		|			ИЗ
		|				ВТДокументыНачисления)";
	
	Запрос.Текст = Запрос.Текст
		+ ОбщегоНазначения.РазделительПакетаЗапросов() + ТекстПоСторнируемому
		+ ОбщегоНазначения.РазделительПакетаЗапросов() + ТекстПоОснованиям;
	Результаты = Запрос.ВыполнитьПакет();
	
	ВременныйРегистраторПерерасчета = Документы.НачислениеЗарплаты.ПолучитьСсылку();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УчитыватьСуммуВычета", Результаты[1].Колонки.Найти("СуммаВычета") <> Неопределено);
	ДополнительныеПараметры.Вставить("УчитыватьСкидкуПоВзносам", Результаты[1].Колонки.Найти("СкидкаПоВзносам") <> Неопределено);
	ДополнительныеПараметры.Вставить("РаспределениеРезультатов", Результаты[2].Выгрузить());
	ДополнительныеПараметры.Вставить("РаспределениеПоТерриториям", Результаты[3].Выгрузить());
	ДополнительныеПараметры.Вставить("НачислениеДокумента", НачислениеДокумента);
	ДополнительныеПараметры.Вставить("ДокументБезДатаНачала", ОписаниеДокумента.ДокументБезДатаНачала);
	ДополнительныеПараметры.Вставить("ВременныйРегистраторПерерасчета", ВременныйРегистраторПерерасчета);
	ДополнительныеПараметры.Вставить("ОтборСтрок", Новый Структура("ИдентификаторСтроки"));
	
	НачисленияЗаднимЧислом = ИсправлениеДокументовРасчетЗарплаты.ПустаяТаблицаНачисленийЗаднимЧислом();
	
	// Заполним сторнируемые начисления.
	ВыборкаНачислений = Результаты[1].Выбрать();
	Пока ВыборкаНачислений.Следующий() Цикл
		ДополнитьСторнируемыеНачисления(ВыборкаНачислений, НачисленияЗаднимЧислом, ДополнительныеПараметры);
	КонецЦикла;
	
	ДополнительныеПараметры.РаспределениеРезультатов = Результаты[5].Выгрузить();
	ДополнительныеПараметры.РаспределениеПоТерриториям = Результаты[6].Выгрузить();
	ДополнительныеПараметры.ОтборСтрок.Вставить("Ссылка");
	
	// Заполним сторнируемые начисления документов-оснований.
	ВыборкаНачисленийДокументовОснований = Результаты[4].Выбрать();
	Пока ВыборкаНачисленийДокументовОснований.СледующийПоЗначениюПоля("Ссылка") Цикл
		Пока ВыборкаНачисленийДокументовОснований.Следующий() Цикл
			ДополнитьСторнируемыеНачисления(ВыборкаНачисленийДокументовОснований, НачисленияЗаднимЧислом, ДополнительныеПараметры);
		КонецЦикла;
	КонецЦикла;
	
	Если ОписаниеДокумента.ДокументБезДатаНачала Тогда
		ЗарплатаКадрыРасширенный.СкорректироватьДатыНачисленийБезПериодаДействия(Сторнировано, ПараметрыСторнируемогоДокумента.ПериодРегистрации);
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если Не ОписаниеДокумента.ДокументБезДатаНачала 
		И (ДоначислитьЗарплатуПриНеобходимости Или ПараметрыСторнируемогоДокумента.ВыполнилДоначисление)
		И Не (НачислениеДокумента <> НеОпределено И Не НачислениеДокументаЗачетНормыВремени) Тогда
		
		НаборыЗаписей = ЗарплатаКадры.НаборыЗаписейРегистратора(Метаданные.Документы.НачислениеЗарплаты, ВременныйРегистраторПерерасчета);
		НаборДляЗаполненияПерерасчета = НаборыЗаписей["Начисления"];
		ЗначенияПоказателейНабор = НаборыЗаписей["ЗначенияПоказателейНачислений"];
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	МИНИМУМ(Начисления.НачалоСтарогоПериода) КАК НачалоСтарогоПериода,
			|	МАКСИМУМ(Начисления.ОкончаниеСтарогоПериода) КАК ОкончаниеСтарогоПериода,
			|	Начисления.Организация КАК Организация,
			|	Начисления.ПериодРегистрации КАК ПериодРегистрации
			|ИЗ
			|	(ВЫБРАТЬ
			|		Начисления.ДатаНачала КАК НачалоСтарогоПериода,
			|		ВЫБОР
			|			КОГДА Начисления.ДатаОкончания > &КонецПериодаРегистрации
			|				ТОГДА &КонецПериодаРегистрации
			|			ИНАЧЕ Начисления.ДатаОкончания
			|		КОНЕЦ КАК ОкончаниеСтарогоПериода,
			|		Начисления.Ссылка.Организация КАК Организация,
			|		Начисления.Ссылка.ПериодРегистрации КАК ПериодРегистрации,
			|		Начисления.Начисление КАК ВидРасчета
			|	ИЗ
			|		#Начисления КАК Начисления
			|	ГДЕ
			|		Начисления.Ссылка = &Ссылка
			|		И Начисления.ДатаНачала < &КонецПериодаРегистрации
			|	
			|	ОБЪЕДИНИТЬ ВСЕ
			|	
			|	ВЫБРАТЬ
			|		Начисления.ДатаНачала,
			|		Начисления.ДатаОкончания,
			|		Начисления.Ссылка.Организация,
			|		Начисления.Ссылка.МесяцНачисления,
			|		Начисления.Начисление
			|	ИЗ
			|		Документ.НачислениеЗарплаты.Начисления КАК Начисления
			|	ГДЕ
			|		Начисления.Ссылка В
			|				(ВЫБРАТЬ
			|					ВТДокументыНачисления.ДокументНачисления
			|				ИЗ
			|					ВТДокументыНачисления)
			|		И Начисления.ДокументОснование = &Ссылка) КАК Начисления
			|ГДЕ
			|	Начисления.ВидРасчета.ВидВремени <> ЗНАЧЕНИЕ(Перечисление.ВидыРабочегоВремениСотрудников.ДополнительноОплачиваемоеВПределахНормы)
			|
			|СГРУППИРОВАТЬ ПО
			|	Начисления.Организация,
			|	Начисления.ПериодРегистрации
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Начисления.Сотрудник КАК Сотрудник,
			|	Начисления.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация
			|ИЗ
			|	#Начисления КАК Начисления
			|ГДЕ
			|	Начисления.Ссылка = &Ссылка
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Начисления.Сотрудник,
			|	Начисления.Сотрудник.ГоловнаяОрганизация
			|ИЗ
			|	Документ.НачислениеЗарплаты.Начисления КАК Начисления
			|ГДЕ
			|	Начисления.Ссылка В
			|			(ВЫБРАТЬ
			|				ВТДокументыНачисления.ДокументНачисления
			|			ИЗ
			|				ВТДокументыНачисления)
			|	И Начисления.ДокументОснование = &Ссылка";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "#Начисления", ИмяТаблицы + ".Начисления");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Начисления.Ссылка.ПериодРегистрации", "Начисления.Ссылка." + ОписаниеДокумента.МесяцНачисленияИмя);
		Запрос.УстановитьПараметр("КонецПериодаРегистрации", КонецМесяца(ПериодРегистрации));
		
		Если НачислениеДокумента <> Неопределено Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Начисления.Начисление КАК ВидРасчета", "&НачислениеДокумента КАК ВидРасчета");
			Запрос.УстановитьПараметр("НачислениеДокумента", НачислениеДокумента);
		КонецЕсли;
		
		Результаты = Запрос.ВыполнитьПакет();
		
		ВыборкаДанныеСторнируемого = Результаты[0].Выбрать();
		Сотрудники = Результаты[1].Выгрузить().ВыгрузитьКолонку("Сотрудник");
		
		ИдентификаторСтрокиДоначисления = ЗарплатаКадрыРасширенный.МаксимальныйИдентификаторСтроки(
			Сторнировано, "ИдентификаторСтрокиВидаРасчета") + 1;
		
		Пока ВыборкаДанныеСторнируемого.Следующий() Цикл
			
			НачалоСтарогоПериода = ВыборкаДанныеСторнируемого.НачалоСтарогоПериода;
			
			Если ВыборкаДанныеСторнируемого.НачалоСтарогоПериода >= ПериодРегистрации Тогда
				ОкончаниеСтарогоПериода = ВыборкаДанныеСторнируемого.ОкончаниеСтарогоПериода;
			Иначе
				ОкончаниеСтарогоПериода = Мин(ВыборкаДанныеСторнируемого.ОкончаниеСтарогоПериода, ПериодРегистрации - 1);
			КонецЕсли;
			
			// Получим данные плановых начислений за исправляемый период.
			МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(ПериодРегистрации, ВыборкаДанныеСторнируемого.Организация);
			МенеджерРасчета.ИсключаемыйРегистратор = Ссылка;
			МенеджерРасчета.НастройкиРасчета.ИсключатьРанееОплаченныеПериоды = Ложь;
			ПлановыеНачисления = МенеджерРасчета.НачисленияЗарплатыЗаПериод(Сотрудники, НачалоСтарогоПериода, ОкончаниеСтарогоПериода);
			
			// Добавим во временный набор плановые начисления сторнируемого периода.
			Для Каждого СтрокаНачисления Из ПлановыеНачисления Цикл
				
				Если СтрокаНачисления.ДокументОснование = СторнируемыйДокумент Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрокаНачисленияЗаднимЧислом = НачисленияЗаднимЧислом.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаНачисленияЗаднимЧислом, СтрокаНачисления);
				НоваяСтрокаНачисленияЗаднимЧислом.ВидРасчета = СтрокаНачисления.Начисление;
				НоваяСтрокаНачисленияЗаднимЧислом.ПериодДействияНачало = СтрокаНачисления.ДатаНачала;
				НоваяСтрокаНачисленияЗаднимЧислом.ПериодДействияКонец = СтрокаНачисления.ДатаОкончания;
				
				НоваяСтрокаДоначислений = ДоначисленияИПерерасчеты.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрокаДоначислений, СтрокаНачисления);
				НоваяСтрокаДоначислений.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиДоначисления;
				Для Каждого СтрокаПоказателя Из СтрокаНачисления.Показатели Цикл
					НоваяСтрокаПоказателя = Показатели.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрокаПоказателя, СтрокаПоказателя);
					НоваяСтрокаПоказателя.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиДоначисления;
				КонецЦикла;
				ИдентификаторСтрокиДоначисления = ИдентификаторСтрокиДоначисления + 1;
				
			КонецЦикла;
			
		КонецЦикла;
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если Не ЭтоНовый() Тогда
			НачисленияНабор = РасчетЗарплатыРасширенный.НаборЗаписейНачисления(Ссылка);
			НачисленияНабор.Записать();
		КонецЕсли;
		
		НаборДляЗаполненияПерерасчета.Записать();
		ЗначенияПоказателейНабор.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Если ДоначислитьЗарплатуПриНеобходимости Или ПараметрыСторнируемогоДокумента.ВыполнилДоначисление Тогда
		
		ДанныеПерерасчетов = РасчетЗарплатыРасширенный.ПустаяТаблицаНачисления(Истина);
		
		ИсправлениеДокументовРасчетЗарплаты.ЗаполнитьНачисленияПерерасчетПоНачисленияЗаднимЧислом(
			Организация, ПериодРегистрации,	НачисленияЗаднимЧислом,	ДоначисленияИПерерасчеты,
			ВременныйРегистраторПерерасчета, ДанныеПерерасчетов, Показатели);
			
		Если ЗарплатаКадрыРасширенный.ИспользоватьРаспределениеПоТерриториямУсловиямТруда(Организация) Тогда
			Для Каждого Строка Из ДанныеПерерасчетов Цикл
				Для Каждого СтрокаТерритории Из Строка.РаспределениеПоТерриториямУсловиямТруда Цикл
					НоваяСтрока = РаспределениеПоТерриториямУсловиямТруда.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТерритории);
					НоваяСтрока.ИдентификаторСтроки = Строка.ИдентификаторСтрокиВидаРасчета;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ОтменитьТранзакцию();
	
КонецПроцедуры

Процедура ДополнитьОписаниеСторнируемогоДокумента(Описание, СторнируемыйДокумент)
	
	МетаданныеДокумента = СторнируемыйДокумент.Метаданные();
	
	ТаблицаНачисления = МетаданныеДокумента.ТабличныеЧасти.Найти("Начисления");
	
	Описание.Вставить("ДокументСТаблицейНачисления", ТаблицаНачисления <> Неопределено);
	Описание.Вставить("ДокументБезДатаНачала", Истина);
	Описание.Вставить("ДокументБезНачисление", Истина);
	Описание.Вставить("РеквизитНачислениеДокумента", Неопределено);
	
	Если Описание.ДокументСТаблицейНачисления Тогда
		Описание.ДокументБезДатаНачала = ТаблицаНачисления.Реквизиты.Найти("ДатаНачала") = Неопределено;
		Описание.ДокументБезНачисление = ТаблицаНачисления.Реквизиты.Найти("Начисление") = Неопределено;
	КонецЕсли;
	
	Если Описание.ДокументБезНачисление Тогда
		Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл
			Если Реквизит.Тип.Типы()[0] = Тип("ПланВидовРасчетаСсылка.Начисления") Тогда
				Описание.РеквизитНачислениеДокумента = Реквизит.Имя;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДополнитьСторнируемыеНачисления(ВыборкаНачислений, НачисленияЗаднимЧислом, ДополнительныеПараметры)
	
	УчитыватьСуммуВычета = ДополнительныеПараметры.УчитыватьСуммуВычета;
	УчитыватьСкидкуПоВзносам = ДополнительныеПараметры.УчитыватьСкидкуПоВзносам;
	НачислениеДокумента = ДополнительныеПараметры.НачислениеДокумента;
	ДокументБезДатаНачала = ДополнительныеПараметры.ДокументБезДатаНачала;
	ВременныйРегистраторПерерасчета = ДополнительныеПараметры.ВременныйРегистраторПерерасчета;
	ОтборСтрок = ДополнительныеПараметры.ОтборСтрок;
	
	СтрокаСторно = Сторнировано.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаСторно, ВыборкаНачислений);
	СтрокаСторно.Результат = - СтрокаСторно.Результат;
	Если УчитыватьСуммуВычета Тогда
		СтрокаСторно.СуммаВычета = - СтрокаСторно.СуммаВычета;
	КонецЕсли;
	Если УчитыватьСкидкуПоВзносам Тогда
		СтрокаСторно.СкидкаПоВзносам = - СтрокаСторно.СкидкаПоВзносам;
	КонецЕсли;
	СтрокаСторно.ОтработаноДней = - СтрокаСторно.ОтработаноДней;
	СтрокаСторно.ОтработаноЧасов = - СтрокаСторно.ОтработаноЧасов;
	СтрокаСторно.ОплаченоДней = - СтрокаСторно.ОплаченоДней;
	СтрокаСторно.ОплаченоЧасов = - СтрокаСторно.ОплаченоЧасов;
	Если ЗначениеЗаполнено(НачислениеДокумента) Тогда
		СтрокаСторно.Начисление = НачислениеДокумента;
	КонецЕсли;
	Если Не ДокументБезДатаНачала Тогда
		СтрокаСторно.ДатаНачала = ВыборкаНачислений.ДатаНачала;
		СтрокаСторно.ДатаОкончания = ВыборкаНачислений.ДатаОкончания;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(СтрокаСторно.ПериодДействия) Тогда
		СтрокаСторно.ПериодДействия = НачалоМесяца(СтрокаСторно.ДатаНачала);
	КонецЕсли;
	СтрокаСторно.Сторно = Истина;
	СтрокаСторно.ФиксРасчет = Истина;
	
	НовыйИдентификаторСтроки = Сторнировано.Количество();
	СтрокаСторно.ИдентификаторСтрокиВидаРасчета = НовыйИдентификаторСтроки;
	 
	СтрокаНачисленийЗаднимЧислом = НачисленияЗаднимЧислом.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаНачисленийЗаднимЧислом, ВыборкаНачислений);
	СтрокаНачисленийЗаднимЧислом.Регистратор = ВременныйРегистраторПерерасчета;
	СтрокаНачисленийЗаднимЧислом.ИдентификаторСтроки = 0;
	СтрокаНачисленийЗаднимЧислом.РегистраторПоказателей = Неопределено;
	СтрокаНачисленийЗаднимЧислом.ИдентификаторСтрокиПоказателей = Неопределено;
	Если ЗначениеЗаполнено(НачислениеДокумента) Тогда
		СтрокаНачисленийЗаднимЧислом.ВидРасчета = НачислениеДокумента;
	Иначе
		СтрокаНачисленийЗаднимЧислом.ВидРасчета = ВыборкаНачислений.Начисление;
	КонецЕсли;
	Если Не ДокументБезДатаНачала Тогда
		СтрокаНачисленийЗаднимЧислом.ПериодДействияНачало = ВыборкаНачислений.ДатаНачала;
		СтрокаНачисленийЗаднимЧислом.ПериодДействияКонец = ВыборкаНачислений.ДатаОкончания;
	КонецЕсли;
	СтрокаНачисленийЗаднимЧислом.Сторно = Истина;
		
	ОтборСтрок.ИдентификаторСтроки = ВыборкаНачислений.ИдентификаторСтрокиВидаРасчета;
	Если ОтборСтрок.Свойство("Ссылка") Тогда
		ОтборСтрок.Ссылка = ВыборкаНачислений.Ссылка;
	КонецЕсли;
	
	СтрокиРаспределения = ДополнительныеПараметры.РаспределениеРезультатов.НайтиСтроки(ОтборСтрок);
	Для каждого СтрокаРаспределения Из СтрокиРаспределения Цикл
		НоваяСтрока = РаспределениеРезультатовНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаРаспределения);
		НоваяСтрока.Результат = - НоваяСтрока.Результат;
		НоваяСтрока.ИдентификаторСтроки = НовыйИдентификаторСтроки;
	КонецЦикла;
	
	СтрокиТерриторий = ДополнительныеПараметры.РаспределениеПоТерриториям.НайтиСтроки(ОтборСтрок);
	Для каждого СтрокаТерритории Из СтрокиТерриторий Цикл
		НоваяСтрока = РаспределениеПоТерриториямУсловиямТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТерритории);
		НоваяСтрока.Результат = - НоваяСтрока.Результат;
		НоваяСтрока.СуммаВычета = - НоваяСтрока.СуммаВычета;
		НоваяСтрока.СкидкаПоВзносам = - НоваяСтрока.СкидкаПоВзносам;
		НоваяСтрока.ИдентификаторСтроки = НовыйИдентификаторСтроки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДокументОснование(Отказ)
	
	Если Не ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	Сведения = ИсправлениеДокументовЗарплатаКадры.СведенияОбИсправленииДокумента(СторнируемыйДокумент);
	
	Если Не Сведения.Проведен Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Сторнируемый документ не проведен.'"),,"Объект.СторнируемыйДокумент",,Отказ);
			
	ИначеЕсли Сведения.Исправлен Или Сведения.Сторнирован И Сведения.СторнирующийДокумент <> Ссылка Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Проведение запрещено.'")
				+ Символы.ПС + Сведения.ПредставлениеСостояния,,"Объект.СторнируемыйДокумент",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
