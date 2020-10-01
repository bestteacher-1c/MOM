#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Ищет характеристику идентичную переданной характеристике, если не находит - создает характеристику для переданной номенклатуры.
//
// Параметры:
//  НоменклатураИсходногоКачества	 - СправочникСсылка.Номенклатура		 - номенклатура, среди упаковок производится поиск,
//  Номенклатура					 - СправочникСсылка.Номенклатура		 - владелец новой упаковки,
//  ХарактеристикаВДокументе		 - СправочникСсылка.ХарактеристикиНоменклатуры	 - характеристика, указанная в документе.
// 
// Возвращаемое значение:
//  СправочникСсылка.ХарактеристикиНоменклатуры - ссылка на идентичную характеристику.
//
Функция ИдентичнаяХарактеристика(НоменклатураИсходногоКачества, Номенклатура, ХарактеристикаВДокументе) Экспорт
	
	ИдентичнаяХарактеристика = Справочники.ХарактеристикиНоменклатуры.НайтиПоНаименованию(ХарактеристикаВДокументе.Наименование,,, Номенклатура);
	Если ЗначениеЗаполнено(ИдентичнаяХарактеристика) Тогда 
		Возврат ИдентичнаяХарактеристика;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НоваяХарактеристика = Справочники.ХарактеристикиНоменклатуры.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НоваяХарактеристика, ХарактеристикаВДокументе,,"Родитель");
	НоваяХарактеристика.Владелец = Номенклатура;
	НоваяХарактеристика.ДополнительныеРеквизиты.Загрузить(ХарактеристикаВДокументе.ДополнительныеРеквизиты.Выгрузить());
	НоваяХарактеристика.Записать();
	
	Возврат НоваяХарактеристика.Ссылка; 
	
КонецФункции

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Наименование");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Для вызова в методе ЗначениеНастроекПовтИсп.ВсеРеквизитыХарактеристикНоменклатуры.
// Возвращает свойства реквизитов характеристики с учетом настроек сделанных
// в метаданных и доопределенных в модулях менеджера номенклатуры.
//
// Параметры:
//	ТипНоменклатуры - ПеречислениеСсылка.ТипыНоменклатуры - тип номенклатуры.
//	ОсобенностьУчета - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры - особенность учета номенклатуры.
//
// Возвращаемое значение:
//	ФиксированнаяСтруктура - структура, со следующими свойствами:
//		* Ключ - Строка - имя реквизита.
//		* Значение - ФиксированнаяСтруктура - см. Справочники.Номенклатура.ЗначениеСвойствРеквизита.
//
Функция ВсеРеквизиты(ТипНоменклатуры, ОсобенностьУчета) Экспорт
	
	НастройкиРеквизитовПоТипу = Справочники.Номенклатура.ЗависимостьРеквизитовОтТипаНоменклатуры(ТипНоменклатуры,
																								ОсобенностьУчета,
																								Истина,
																								Ложь,
																								Истина);
	
	РеквизитыОтключенныеПоФО = Справочники.Номенклатура.РеквизитыОтключенныеПоФО(Истина);
	
	ВсеРеквизиты = Новый Структура;
	
	Для Каждого Реквизит Из Метаданные.Справочники.ХарактеристикиНоменклатуры.Реквизиты Цикл
		ЗначениеСвойств = Справочники.Номенклатура.ЗначениеСвойствРеквизита();
		
		ЗначениеСвойств.Имя = Реквизит.Имя;
		СтрокаНастройки = НастройкиРеквизитовПоТипу.Найти(Реквизит, "Реквизит");
		
		Если СтрокаНастройки = Неопределено Тогда
			ЗначениеСвойств.Использование = РеквизитыОтключенныеПоФО.Найти(Реквизит.Имя) = Неопределено;
		Иначе
			ЗначениеСвойств.Использование = СтрокаНастройки.Использование
											И РеквизитыОтключенныеПоФО.Найти(Реквизит.Имя) = Неопределено;
		КонецЕсли;
		
		ПредставлениеРеквизита = Реквизит.Синоним;
		Если Не ЗначениеЗаполнено(ПредставлениеРеквизита) Тогда
			ПредставлениеРеквизита = Реквизит.Имя;
		КонецЕсли;
		
		ЗначениеСвойств.Представление = ПредставлениеРеквизита;	
		ЗначениеСвойств.Тип = Реквизит.Тип;
		ЗначениеСвойств.ОбязательныйДляЗаполнения = ЗначениеСвойств.Использование
													И (Реквизит.ПроверкаЗаполнения = ПроверкаЗаполнения.ВыдаватьОшибку);
		
		ЗначениеСвойств.ОбязательныйДляОтображенияПриСоздании = ЗначениеСвойств.Использование
																И ЗначениеСвойств.ОбязательныйДляЗаполнения;
		
		ВсеРеквизиты.Вставить(Реквизит.Имя, Новый ФиксированнаяСтруктура(ЗначениеСвойств));
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(ВсеРеквизиты);
	
КонецФункции

// Проверяет уникальность рабочего наименование характеристики.
//
// Параметры:
//	Объект - СправочникОбъект.ХарактеристикиНоменклатуры - объект характеристика номенклатуры.
//
// Возвращаемое значение:
//	Булево - Истина, если рабочее наименование характеристики уникально.
//
Функция РабочееНаименованиеУникально(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка <> &Ссылка
	|	И ХарактеристикиНоменклатуры.Наименование = &Наименование
	|	И ХарактеристикиНоменклатуры.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Наименование", Объект.Наименование);
	Запрос.УстановитьПараметр("Владелец", Объект.Владелец);

	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой()
	
КонецФункции

// Возвращает описание настроек реквизита характеристики.
//
// Параметры:
//	Реквизит - Произвольный - реквизит справочника ХарактеристикиНоменклатуры.
//	ТипНоменклатуры - ПеречислениеСсылка.ТипыНоменклатуры - тип номенклатуры.
//	ОсобенностьУчета - ПеречислениеСсылка.ОсобенностиУчетаНоменклатуры - особенность учета номенклатуры.
//
// Возвращаемое значение:
//	Структура - описание настроек реквизит (см. Справочник.Номенклатура.ЗначениеСвойствРеквизита).
//
Функция РеквизитОписание(Реквизит, ТипНоменклатуры, ОсобенностьУчета) Экспорт
	
	Если ТипЗнч(Реквизит) = Тип("Строка")
		Или ТипЗнч(Реквизит) = Тип("ОбъектМетаданных") Тогда
		
		ВсеРеквизитыХарактеристик = ЗначениеНастроекПовтИсп.ВсеРеквизитыХарактеристикНоменклатуры(ТипНоменклатуры,
																									ОсобенностьУчета);
		
		Если ТипЗнч(Реквизит) = Тип("Строка") Тогда
			ИмяРеквизита = Реквизит;
		Иначе
			ИмяРеквизита = Реквизит.Имя;
		КонецЕсли;
		
		Возврат ВсеРеквизитыХарактеристик[ИмяРеквизита];
		
	ИначеЕсли ТипЗнч(Реквизит) = Тип("ФиксированнаяСтруктура") Тогда
		Возврат Реквизит;
	Иначе
		ТекстИсключения = НСтр("ru = 'Неожиданный тип параметра Реквизит.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецФункции

// Возвращает настройки видимости и заголовков элементов формы.
//
// Параметры:
//	Объект - СправочникОбъект.ХарактеристикиНоменклатуры, ДанныеФормыСтруктура - характеристика номенклатуры.
//	РеквизитыВидаНоменклатуры - Структура - описание реквизитов вида номенклатуры.
//
// Возвращаемое значение:
//	Структура - структура с ключами:
//		* ВидимостьЭлементов - Структура - настройки видимости элементов.
//		* ЗаголовкиЭлементов - Структура - описание заголовков элементов.
//
Функция НастройкиВидимостиИЗаголовков(Объект, РеквизитыВидаНоменклатуры) Экспорт
	
	ВидимостьЭлементов = ИспользованиеЭлементов(Объект, РеквизитыВидаНоменклатуры);
	
	УстановитьПривилегированныйРежим(Истина);
	ЗаголовкиЭлементов = ЗаголовкиЭлементов(Объект, ВидимостьЭлементов, РеквизитыВидаНоменклатуры);
	УстановитьПривилегированныйРежим(Ложь);
	
	НастройкиВидимостиИЗаголовков = Новый Структура;
	НастройкиВидимостиИЗаголовков.Вставить("ВидимостьЭлементов", ВидимостьЭлементов);
	НастройкиВидимостиИЗаголовков.Вставить("ЗаголовкиЭлементов", ЗаголовкиЭлементов);
	
	Возврат НастройкиВидимостиИЗаголовков;
	
КонецФункции

// Возвращает коллекцию имен непроверяемых реквизитов объекта.
//
// Параметры:
//	Объект - СправочникОбъект.ХарактеристикиНоменклатуры, ДанныеФормыСтруктура - характеристика номенклатуры.
//
// Возвращаемое значение:
//	Массив - имена непроверяемых реквизитов объекта:
//
Функция НепроверяемыеРеквизиты(Объект) Экспорт
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	РеквизитыСПереопределеннойОбязательностьюЗаполнения = РеквизитыСПереопределеннойОбязательностьюЗаполнения(Неопределено,
																												Объект);

	Для Каждого КлючЗначение Из РеквизитыСПереопределеннойОбязательностьюЗаполнения Цикл
		Если Не КлючЗначение.Значение Тогда
			МассивНепроверяемыхРеквизитов.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МассивНепроверяемыхРеквизитов;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ ИСТИНА
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	НоменклатураВызовСервера.ХарактеристикиНоменклатурыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ИспользованиеЭлементов(ПереданныйОбъект, РеквизитыВидаНоменклатуры)
	
	ИспользованиеЭлементов = Новый Структура;
	
	#Область НастройкаПоВидуНоменклатуры
		
	НастройкиРеквизитовПоВидуНоменклатуры = Справочники.Номенклатура.ТаблицаНастроекРеквизитов(РеквизитыВидаНоменклатуры.Ссылка,
																								РеквизитыВидаНоменклатуры.ТипНоменклатуры,
																								РеквизитыВидаНоменклатуры.ОсобенностьУчета,
																								РеквизитыВидаНоменклатуры.ИспользованиеХарактеристик,
																								Ложь,
																								"ХарактеристикиНоменклатуры");
	
	Для Каждого СтрТабл Из НастройкиРеквизитовПоВидуНоменклатуры Цикл
		
		ИмяРеквизита = СтрТабл.ИмяРеквизита;
		
		Если СтрТабл.ЭтоДопРеквизит Тогда
			ИмяЭлементаФормы = "ДополнительныйРеквизитЗначение_"
								+ СтрЗаменить(?(СтрТабл.ЭтоОбщийРеквизит,
												ВРег(Строка(СтрТабл.Набор.УникальныйИдентификатор())),
												ВРег(Строка(СтрТабл.НаборСвойств.УникальныйИдентификатор()))),
												"-",
												"x")
								+ "_"
								+ СтрЗаменить(ВРег(Строка(СтрТабл.Свойство.УникальныйИдентификатор())), "-", "x");
			
			ИспользованиеЭлементов.Вставить(ИмяЭлементаФормы, СтрТабл.Использование 
																И Справочники.Номенклатура.ВидимостьРеквизита(СтрТабл,
																												ИмяРеквизита,
																												Ложь,
																												СтрТабл));
		Иначе
			ИспользованиеЭлементов.Вставить(ИмяРеквизита, СтрТабл.Использование
															И (Справочники.Номенклатура.ВидимостьРеквизита(ИмяРеквизита,
																											ИмяРеквизита,
																											Ложь,
																											СтрТабл)));
		КонецЕсли;
		
	КонецЦикла;
	
	#КонецОбласти
	
	ИспользованиеЭлементов.Вставить("ГиперссылкаПерейтиСоставНабора",
									ПравоДоступа("Просмотр", Метаданные.Справочники.ВариантыКомплектацииНоменклатуры)
									И РеквизитыВидаНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Набор
									И РеквизитыВидаНоменклатуры.ИспользованиеХарактеристик = Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры);
	
	Возврат ИспользованиеЭлементов;
	
КонецФункции

Функция ЗаголовкиЭлементов(Объект, ВидимостьЭлементов, РеквизитыВидаНоменклатуры)
	
	ЗаголовкиЭлементов = Новый Структура;
	
	Если РеквизитыВидаНоменклатуры.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа Тогда
		ЗаголовкиЭлементов.Вставить("ГруппаАгентскиеУслуги", НСтр("ru='Работа выполняется по агентскому договору'"));
	Иначе
		ЗаголовкиЭлементов.Вставить("ГруппаАгентскиеУслуги", НСтр("ru='Услуга реализуется по агентскому договору'"));
	КонецЕсли;
	
	КартинкаПредупреждение = БиблиотекаКартинок.ПредупреждениеСНачалаСтроки;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВариантыКомплектацииНоменклатурыТовары.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	Справочник.ВариантыКомплектацииНоменклатуры.Товары КАК ВариантыКомплектацииНоменклатурыТовары
	|ГДЕ
	|	&ГиперссылкаПерейтиСоставНабора
	|	И ВариантыКомплектацииНоменклатурыТовары.Ссылка = &ВариантКомплектацииНоменклатуры
	|	И НЕ ВариантыКомплектацииНоменклатурыТовары.Ссылка.ПометкаУдаления";
	
	Если ВидимостьЭлементов.Свойство("ГиперссылкаПерейтиСоставНабора")
		И ВидимостьЭлементов["ГиперссылкаПерейтиСоставНабора"] Тогда
		ВариантКомплектацииНоменклатуры = НаборыВызовСервера.ВариантКомплектацииНоменклатурыПоУмолчанию(Объект.Владелец,
																										Объект.Ссылка);
		
		Запрос.УстановитьПараметр("ВариантКомплектацииНоменклатуры", ВариантКомплектацииНоменклатуры);
	Иначе
		Запрос.УстановитьПараметр("ВариантКомплектацииНоменклатуры",
									Справочники.ВариантыКомплектацииНоменклатуры.ПустаяСсылка());
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ВариантКомплектацииНоменклатуры", ВариантКомплектацииНоменклатуры);
	
	ПараметрыЗапроса = Запрос.НайтиПараметры();
	
	Для Каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
		Если СтрНайти(ПараметрЗапроса.Имя, "ГиперссылкаПерейти") <> 0 Тогда
			Запрос.УстановитьПараметр(ПараметрЗапроса.Имя,
									ВидимостьЭлементов.Свойство(ПараметрЗапроса.Имя)
									И ВидимостьЭлементов[ПараметрЗапроса.Имя]);
		КонецЕсли;
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Выборки = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ВидимостьЭлементов.Свойство("ГиперссылкаПерейтиСоставНабора")
		И ВидимостьЭлементов["ГиперссылкаПерейтиСоставНабора"] Тогда
	
		РезультатЗапроса	= Выборки[0];
		Количество			= РезультатЗапроса.Выбрать().Количество();
		
		Если Количество <> 0 Тогда
			ЗаголовокГиперссылки = Новый ФорматированнаяСтрока(НСтр("ru = 'Состав набора'") + " (" + Количество + ")"
																,
																,
																,
																,"СоставНабора");
		Иначе
			ЗаголовокГиперссылки = Новый ФорматированнаяСтрока(Новый ФорматированнаяСтрока(НСтр("ru = 'Настроить набор'")
																							,
																							,
																							,
																							,
																							"НастроитьНабор"),
																КартинкаПредупреждение);
		КонецЕсли;
		
		ЗаголовкиЭлементов.Вставить("ГиперссылкаПерейтиСоставНабора", ЗаголовокГиперссылки);
	КонецЕсли;
	
	Возврат ЗаголовкиЭлементов;
	
КонецФункции

Функция РеквизитыСПереопределеннойОбязательностьюЗаполнения(РеквизитыВидаНоменклатуры, Объект) Экспорт
	
	РеквизитыСПереопределеннойОбязательностьюЗаполнения = Новый Соответствие;
	
	Если РеквизитыВидаНоменклатуры = Неопределено Тогда
		ЗапрашиваемыеРеквизитыВидаНоменклатуры =
		"ШаблонРабочегоНаименованияХарактеристики,
		|ТипНоменклатуры,
		|ОсобенностьУчета";
		
		Если Объект = Неопределено
			Или Объект.Владелец = Неопределено Тогда
			РеквизитыВидаНоменклатуры = ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(
											Справочники.ВидыНоменклатуры.ПустаяСсылка(),
											ЗапрашиваемыеРеквизитыВидаНоменклатуры);
		Иначе
			Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ВидыНоменклатуры") Тогда
				ВидНоменклатуры = Объект.Владелец;	
			Иначе
				ВидНоменклатуры = ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(Объект.Владелец, "ВидНоменклатуры").ВидНоменклатуры;
			КонецЕсли;
			
			РеквизитыВидаНоменклатуры = ОбщегоНазначенияУТ.ЗначенияРеквизитовОбъектаПоУмолчанию(ВидНоменклатуры,
																								ЗапрашиваемыеРеквизитыВидаНоменклатуры);
		КонецЕсли;
	КонецЕсли;
	
	РеквизитыСПереопределеннойОбязательностьюЗаполнения.Вставить("Наименование",
														Не ЗначениеЗаполнено(РеквизитыВидаНоменклатуры.ШаблонРабочегоНаименованияХарактеристики));
	
	РеквизитыСПереопределеннойОбязательностьюЗаполнения.Вставить("Принципал",
																РеквизитыВидаНоменклатуры.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.ОрганизациейПоАгентскойСхеме
																	Или РеквизитыВидаНоменклатуры.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером);
																		
	РеквизитыСПереопределеннойОбязательностьюЗаполнения.Вставить("Контрагент",
																РеквизитыВидаНоменклатуры.ОсобенностьУчета = Перечисления.ОсобенностиУчетаНоменклатуры.Партнером);
	
	Возврат РеквизитыСПереопределеннойОбязательностьюЗаполнения;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ХарактеристикиНоменклатуры.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.4.12.23";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("df48aa22-5a42-456c-a39c-eb0bd8b919a9");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ХарактеристикиНоменклатуры.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит ""Вид номенклатуры"". Пока обработчик не отработал могут не корректно отрабатывать настройки проверки заполнения дополнительных реквизитов характеристик.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьПустойРеквизитЗначениемПоУмолчаниюЗарегистрироватьДанныеКОбработке(Параметры,
																												"Справочник.ХарактеристикиНоменклатуры",
																												"ВидНоменклатуры");
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта        = "Справочник.ХарактеристикиНоменклатуры";
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
	
	ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь,ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	ХарактеристикиНоменклатуры.ВерсияДанных,
	|	ВЫБОР
	|		КОГДА ХарактеристикиНоменклатуры.Владелец ССЫЛКА Справочник.Номенклатура
	|			ТОГДА ВЫРАЗИТЬ(ХарактеристикиНоменклатуры.Владелец КАК Справочник.Номенклатура).ВидНоменклатуры
	|		ИНАЧЕ ХарактеристикиНоменклатуры.Владелец
	|	КОНЕЦ КАК ВидНоменклатуры
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДляОбработкиХарактеристикиНоменклатуры
	|		ПО ХарактеристикиНоменклатуры.Ссылка = ВТДляОбработкиХарактеристикиНоменклатуры.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		НачатьТранзакцию();

		Попытка
			БлокировкаДанных = Новый БлокировкаДанных();

			ЭлементБлокировки = БлокировкаДанных.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);

			БлокировкаДанных.Заблокировать();

			СправочникОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
			Если СправочникОбъект = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;

			СправочникОбъект.ВидНоменклатуры = Выборка.ВидНоменклатуры;

			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);

			ЗафиксироватьТранзакцию();

		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
		КонецПопытки;
			
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли