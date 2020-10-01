
#Область ПрограммныйИнтерфейс

#Область ПоискНаФормахПодборов

// Процедура выполняет обновление индекса полнотекстового поиска в привилегированном режиме.
//
Процедура ОбновитьИндексПолнотекстовогоПоиска() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	ПолнотекстовыйПоиск.ОбновитьИндекс();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Функция возвращает упаковку хранения номенклатуры, т.е. упаковку с коэффициентом 1 и
//  единицей хранения соответствующей единице хранения номенклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура.
// 
// Возвращаемое значение:
//  СправочникСсылка.УпаковкиЕдиницыИзмерения - упаковка хранения или единица измерения номенклатуры.
//
Функция ПолучитьУпаковкуХранения(Номенклатура) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпрНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(СпрНоменклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|	ЕСТЬNULL(СпрУпаковки.Ссылка, НЕОПРЕДЕЛЕНО) КАК Упаковка,
	|	ПРЕДСТАВЛЕНИЕ(СпрУпаковки.Ссылка) КАК УпаковкаПредставление,
	|	ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) КАК ЕдиницаИзмеренияУпаковки,
	|	ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения.Представление, """") КАК ЕдиницаИзмеренияУпаковкиПредставление,
	|	ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 0) КАК Коэффициент
	|ИЗ
	|	Справочник.Номенклатура КАК СпрНоменклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК СпрУпаковки
	|		ПО (СпрУпаковки.Владелец = ВЫБОР
	|				КОГДА СпрНоменклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|					ТОГДА СпрНоменклатура.Ссылка
	|				КОГДА СпрНоменклатура.НаборУпаковок <> ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ПустаяСсылка)
	|					ТОГДА СпрНоменклатура.НаборУпаковок
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|			И (НЕ СпрУпаковки.ПометкаУдаления)
	|ГДЕ
	|	СпрНоменклатура.Ссылка = &Номенклатура
	|	И ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 0) = 1
	|	И ЕСТЬNULL(СпрУпаковки.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = СпрНоменклатура.ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Коэффициент,
	|	ЕдиницаИзмеренияУпаковкиПредставление";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"СпрУпаковки", Неопределено));
		
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Возврат Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
		
	КонецЕсли;
		
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Упаковка;
	
КонецФункции

// Возвращает структуру - информацию о цене продажи и остатках товара.
//
// Параметры:
//  Номенклатура	 - СправочникСсылка.Номенклатура			 - номенклатура,
//  Характеристика	 - СправочникСсылка.ХарактеристикиНоменклатуры	 - характеристика номенклатуры,
//  Соглашение		 - СправочникСсылка.СоглашенияСКлиентами		 - соглашение, на основании которого осуществляется продажа,
//  Валюта			 - СправочникСсылка.Валюты						 - валюта взаиморасчетов,
//  Склады			 - СправочникСсылка.Склады						 - склад, с которого осуществляется отпуск номенклатуры,
//  ВидыЦен			 - СправочникСсылка.ВидыЦен						 - вид цены.
// 
// Возвращаемое значение:
//  Структура - Структура с информацией о цене продажи и остатках товара.
//
Функция ЦенаПродажиИОстаткиТовара(Номенклатура, Характеристика, Соглашение, Валюта, Склады, ВидыЦен) Экспорт
	
	Перем СоставРазделовЗапроса;
	
	Запрос = Новый Запрос;
	ИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ИспользованиеХарактеристик");
	НесколькоХарактеристик = ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать;

	Запрос.Текст = ОбеспечениеСервер.ТекстЗапросаДоступныхОстатковПоДатамДляПодбора(
		ЗначениеЗаполнено(Характеристика), НесколькоХарактеристик, СоставРазделовЗапроса)
		+ ПодборТоваровСервер.РазделительПакетаЗапросов()
		+ ПодборТоваровСервер.ТекстЗапросаЦенаПродажиТовара(СоставРазделовЗапроса);
	
	Если ЗначениеЗаполнено(Характеристика) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура И Характеристика = &Характеристика");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{(Номенклатура)}", "И Номенклатура = &Номенклатура");
		Характеристика =  Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Склады", Склады);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("ВидыЦен", ВидыЦен);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", КонецДня(ТекущаяДатаСеанса()));
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Цена продажи.
	Коэффициент = 1;
	
	ЦенаПродажи = Новый Структура("ВидЦены, Цена, Упаковка, ЕдиницаИзмерения, Описание, СрокПоставки");
	
	ЦенаПродажи.ВидЦены = Справочники.ВидыЦен.ПустаяСсылка();
	ЦенаПродажи.Цена = 0;
	ЦенаПродажи.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаПродажи.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаПродажи.Описание = "";
	ЦенаПродажи.СрокПоставки = '00010101';
	
	Выборка = Результат[СоставРазделовЗапроса.Найти("ЦенаПродажиТовара")].Выбрать();
	Если Выборка.Следующий() Тогда
		
		Коэффициент = Выборка.Коэффициент;
		ЗаполнитьЗначенияСвойств(ЦенаПродажи, Выборка);
		
	КонецЕсли;
	
	// Планируемые остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ПланируемыеОстатки")].Выбрать();
	ПланируемыеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, Период, Доступно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.Доступно = НоваяСтрока.Доступно / Коэффициент;
		ПланируемыеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	// Текущие остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ДоступныеТовары")].Выбрать();
	ТекущиеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, ВНаличии, Свободно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.ВНаличии = НоваяСтрока.ВНаличии / Коэффициент;
		НоваяСтрока.Свободно = НоваяСтрока.Свободно / Коэффициент;
		
		ТекущиеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Новый Структура("ТекущиеОстатки, ПланируемыеОстатки, Цена", ТекущиеОстатки, ПланируемыеОстатки, ЦенаПродажи);
	
КонецФункции

// Возвращает структуру - информацию о цене закупки и остатках товара.
//
// Параметры:
//  Номенклатура	 - СправочникСсылка.Номенклатура			 - номенклатура,
//  Характеристика	 - СправочникСсылка.ХарактеристикиНоменклатуры	 - характеристика номенклатуры,
//  Соглашение		 - СправочникСсылка.СоглашенияСПоставщиками		 - соглашение, на основании которого осуществляется закупка,
//  Валюта			 - СправочникСсылка.Валюты						 - валюта взаиморасчетов,
//  Склады			 - СправочникСсылка.Склады						 - склад, на который осуществляется поставка номенклатуры.
// 
// Возвращаемое значение:
//  Структура - с информацией о цене закупки и остатках товара.
//
Функция ЦенаЗакупкиИОстаткиТовара(Номенклатура, Характеристика, Соглашение, Валюта, Склады) Экспорт
	
	Перем СоставРазделовЗапроса;
	
	ЦенаЗакупки = Новый Структура("Цена, Упаковка, ЕдиницаИзмерения");
	ЦенаЗакупки.Цена = 0;
	ЦенаЗакупки.Упаковка = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	ЦенаЗакупки.ЕдиницаИзмерения = Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	ИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ИспользованиеХарактеристик");
	НесколькоХарактеристик = ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать;

	Запрос.Текст = ОбеспечениеСервер.ТекстЗапросаДоступныхОстатковПоДатамДляПодбора(
		ЗначениеЗаполнено(Характеристика), НесколькоХарактеристик, СоставРазделовЗапроса) 
		+ ПодборТоваровСервер.РазделительПакетаЗапросов()
		+ ПодборТоваровСервер.ТекстЗапросаЦенаЗакупкиТовара(СоставРазделовЗапроса);
	
	Если ПодборТоваровСервер.ЕстьЗначенияЦенНоменклатурыПозжеДатыПодбора(ТекущаяДатаСеанса()) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{ЦеныНоменклатурыПоставщиковСрезПоследнихНаДату}","КОНЕЦПЕРИОДА(&ТекущаяДата, ДЕНЬ)");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "{ЦеныНоменклатурыПоставщиковСрезПоследнихНаДату}","");
	КонецЕсли;

	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Характеристика", Характеристика);
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Склады", Склады);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.ВыполнитьПакет();
	
	// Расчет цены закупки товара.
	Коэффициент = 1;
	
	Выборка = Результат[СоставРазделовЗапроса.Найти("ЦенаЗакупкиТовара")].Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Коэффициент = Выборка.Коэффициент;
		ЗаполнитьЗначенияСвойств(ЦенаЗакупки, Выборка);
		
	КонецЕсли;
	
	// Текущие остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ДоступныеТовары")].Выбрать();
	
	ТекущиеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, ВНаличии, Свободно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.ВНаличии = НоваяСтрока.ВНаличии / Коэффициент;
		НоваяСтрока.Свободно = НоваяСтрока.Свободно / Коэффициент;
		
		ТекущиеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	// Планируемые остатки.
	Выборка = Результат[СоставРазделовЗапроса.Найти("ПланируемыеОстатки")].Выбрать();
	
	ПланируемыеОстатки = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = Новый Структура("Склад, Период, Доступно");
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Выборка);
		
		НоваяСтрока.Доступно = НоваяСтрока.Доступно / Коэффициент;
		
		ПланируемыеОстатки.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	Возврат Новый Структура("ТекущиеОстатки, ПланируемыеОстатки, Цена", ТекущиеОстатки, ПланируемыеОстатки, ЦенаЗакупки);
	
КонецФункции

#КонецОбласти

#Область ОтборыВспомогательные

// Функция возвращает список строковых значений реквизита номенклатуры или
//  доп.реквизитов номенклатуры. Используется при навигации по виду номенклатуры
//  и дереву свойств вида номенклатуры.
//
// Параметры:
//  ВидНоменклатуры		 - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры,
//  ИмяРеквизита		 - Строка							 - имя реквизита,
//  ЭтоДопРеквизит		 - Булево, Истина					 - признак доп.реквизита,
//  ОтборПоНоменклатуре	 - Булево, Истина					 - признак отбора по номенклатуре.
// 
// Возвращаемое значение:
//  СписокЗначений - Список строковых значений реквизита или доп.реквизита.
//
Функция СписокЗначенийРеквизита(ВидНоменклатуры, ИмяРеквизита, ЭтоДопРеквизит, ОтборПоНоменклатуре) Экспорт
	
	ЗначенияРеквизита = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	
	Если Не ЭтоДопРеквизит Тогда
		
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 50
		|	Номенклатура." + ИмяРеквизита + " КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|ГДЕ
		|	Номенклатура.ВидНоменклатуры = &ВидНоменклатуры
		|	И Номенклатура." + ИмяРеквизита + " <> """"
		|	";
		
	ИначеЕсли ОтборПоНоменклатуре Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 50
		|	ДополнительныеРеквизиты.Значение КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.Номенклатура.ДополнительныеРеквизиты КАК ДополнительныеРеквизиты
		|ГДЕ
		|	ДополнительныеРеквизиты.Свойство.Наименование = &Свойство
		|	И ДополнительныеРеквизиты.Ссылка.ВидНоменклатуры = &ВидНоменклатуры";
		
		Запрос.УстановитьПараметр("Свойство", ИмяРеквизита);
		
	ИначеЕсли Не ОтборПоНоменклатуре Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ХарактеристикиДополнительныеРеквизиты.Значение КАК ЗначениеРеквизита
		|ИЗ
		|	Справочник.ХарактеристикиНоменклатуры.ДополнительныеРеквизиты КАК ХарактеристикиДополнительныеРеквизиты
		|ГДЕ
		|	ХарактеристикиДополнительныеРеквизиты.Свойство.Наименование = &Свойство
		|	И ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец) = ТИП(Справочник.ВидыНоменклатуры)
		|				ТОГДА ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец = &ВидНоменклатуры
		|			ИНАЧЕ ХарактеристикиДополнительныеРеквизиты.Ссылка.Владелец.ВидНоменклатуры = &ВидНоменклатуры
		|		КОНЕЦ";
		
		Запрос.УстановитьПараметр("Свойство", ИмяРеквизита);
		
	КонецЕсли;

	МассивЗначений = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ЗначениеРеквизита");
	ЗначенияРеквизита.ЗагрузитьЗначения(МассивЗначений);
	
	Возврат ЗначенияРеквизита;
	
КонецФункции

#КонецОбласти

#КонецОбласти
