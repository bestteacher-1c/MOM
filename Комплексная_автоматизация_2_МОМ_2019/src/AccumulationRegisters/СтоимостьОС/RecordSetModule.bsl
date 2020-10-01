#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ПодготовитьДанныеДляФормированияЗаданийПередЗаписью();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьДанныеДляФормированияЗаданийПриЗаписи();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПодготовитьДанныеДляФормированияЗаданийПередЗаписью()

	Если НЕ ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Период КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ОсновноеСредство КАК ОсновноеСредство,
	|	ТаблицаПередЗаписью.Подразделение КАК Подразделение,
	|	ТаблицаПередЗаписью.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	|	ТаблицаПередЗаписью.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаПередЗаписью.Арендатор КАК Арендатор,
	|	ТаблицаПередЗаписью.Стоимость КАК Стоимость,
	|	ТаблицаПередЗаписью.СтоимостьРегл КАК СтоимостьРегл,
	|	ТаблицаПередЗаписью.СтоимостьНУ КАК СтоимостьНУ,
	|	ТаблицаПередЗаписью.СтоимостьПР КАК СтоимостьПР,
	|	ТаблицаПередЗаписью.СтоимостьВР КАК СтоимостьВР,
	|	ТаблицаПередЗаписью.СтоимостьЦФ КАК СтоимостьЦФ,
	|	ТаблицаПередЗаписью.СтоимостьНУЦФ КАК СтоимостьНУЦФ,
	|	ТаблицаПередЗаписью.СтоимостьПРЦФ КАК СтоимостьПРЦФ,
	|	ТаблицаПередЗаписью.СтоимостьВРЦФ КАК СтоимостьВРЦФ,
	|	ТаблицаПередЗаписью.АмортизационнаяПремия КАК АмортизационнаяПремия,
	|	ТаблицаПередЗаписью.ПредварительнаяСтоимость КАК ПредварительнаяСтоимость,
	|	ТаблицаПередЗаписью.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	ТаблицаПередЗаписью.ВидДвижения КАК ВидДвижения,
	|	ТаблицаПередЗаписью.АналитикаКапитализацииРасходов КАК АналитикаКапитализацииРасходов,
	|	ТаблицаПередЗаписью.ВидАналитикиКапитализацииРасходов КАК ВидАналитикиКапитализацииРасходов,
	|	ТаблицаПередЗаписью.ВариантПримененияЦелевогоФинансирования КАК ВариантПримененияЦелевогоФинансирования,
	|	ТаблицаПередЗаписью.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ТаблицаПередЗаписью.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете
	|ПОМЕСТИТЬ СтоимостьОСПередЗаписью
	|ИЗ
	|	РегистрНакопления.СтоимостьОС КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Регистратор = &Регистратор";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляФормированияЗаданийПриЗаписи()

	Если Не ДополнительныеСвойства.Свойство("ДляПроведения") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапросаИзменения = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период             КАК Период,
	|	Таблица.Организация        КАК Организация,
	|	Таблица.ОсновноеСредство   КАК ОсновноеСредство,
	|	Таблица.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	Таблица.ОтражатьВУпрУчете  КАК ОтражатьВУпрУчете,
	|	&Регистратор               КАК Документ
	|ПОМЕСТИТЬ СтоимостьОСИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПередЗаписью.Период              КАК Период,
	|		ТаблицаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство    КАК ОсновноеСредство,
	|		ТаблицаПередЗаписью.ОтражатьВРеглУчете  КАК ОтражатьВРеглУчете,
	|		ТаблицаПередЗаписью.ОтражатьВУпрУчете   КАК ОтражатьВУпрУчете
	|	ИЗ
	|		СтоимостьОСПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СтоимостьОС КАК ТаблицаПриЗаписи
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.Подразделение = ТаблицаПередЗаписью.Подразделение
	|				И ТаблицаПриЗаписи.ГруппаФинансовогоУчета = ТаблицаПередЗаписью.ГруппаФинансовогоУчета
	|				И ТаблицаПриЗаписи.НаправлениеДеятельности = ТаблицаПередЗаписью.НаправлениеДеятельности
	|				И ТаблицаПриЗаписи.Арендатор = ТаблицаПередЗаписью.Арендатор
	|				И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|		ГДЕ
	|			(ТаблицаПриЗаписи.Период ЕСТЬ NULL
	|				ИЛИ ТаблицаПриЗаписи.Стоимость <> ТаблицаПередЗаписью.Стоимость
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьРегл <> ТаблицаПередЗаписью.СтоимостьРегл
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьНУ <> ТаблицаПередЗаписью.СтоимостьНУ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьПР <> ТаблицаПередЗаписью.СтоимостьПР
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьВР <> ТаблицаПередЗаписью.СтоимостьВР
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьЦФ <> ТаблицаПередЗаписью.СтоимостьЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьНУЦФ <> ТаблицаПередЗаписью.СтоимостьНУЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьПРЦФ <> ТаблицаПередЗаписью.СтоимостьПРЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьВРЦФ <> ТаблицаПередЗаписью.СтоимостьВРЦФ
	|				ИЛИ ТаблицаПриЗаписи.АмортизационнаяПремия <> ТаблицаПередЗаписью.АмортизационнаяПремия
	|				ИЛИ ТаблицаПриЗаписи.ПредварительнаяСтоимость <> ТаблицаПередЗаписью.ПредварительнаяСтоимость)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаПриЗаписи.Период,
	|		ТаблицаПриЗаписи.Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство,
	|		ТаблицаПриЗаписи.ОтражатьВРеглУчете,
	|		ТаблицаПриЗаписи.ОтражатьВУпрУчете
	|	ИЗ
	|		РегистрНакопления.СтоимостьОС КАК ТаблицаПриЗаписи
	|			ЛЕВОЕ СОЕДИНЕНИЕ СтоимостьОСПередЗаписью КАК ТаблицаПередЗаписью
	|			ПО ТаблицаПриЗаписи.ОсновноеСредство = ТаблицаПередЗаписью.ОсновноеСредство
	|				И ТаблицаПриЗаписи.Организация = ТаблицаПередЗаписью.Организация
	|				И ТаблицаПриЗаписи.Подразделение = ТаблицаПередЗаписью.Подразделение
	|				И ТаблицаПриЗаписи.ГруппаФинансовогоУчета = ТаблицаПередЗаписью.ГруппаФинансовогоУчета
	|				И ТаблицаПриЗаписи.НаправлениеДеятельности = ТаблицаПередЗаписью.НаправлениеДеятельности
	|				И ТаблицаПриЗаписи.Арендатор = ТаблицаПередЗаписью.Арендатор
	|		ГДЕ
	|			(ТаблицаПередЗаписью.Период ЕСТЬ NULL
	|				ИЛИ ТаблицаПриЗаписи.Стоимость <> ТаблицаПередЗаписью.Стоимость
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьРегл <> ТаблицаПередЗаписью.СтоимостьРегл
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьНУ <> ТаблицаПередЗаписью.СтоимостьНУ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьПР <> ТаблицаПередЗаписью.СтоимостьПР
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьВР <> ТаблицаПередЗаписью.СтоимостьВР
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьЦФ <> ТаблицаПередЗаписью.СтоимостьЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьНУЦФ <> ТаблицаПередЗаписью.СтоимостьНУЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьПРЦФ <> ТаблицаПередЗаписью.СтоимостьПРЦФ
	|				ИЛИ ТаблицаПриЗаписи.СтоимостьВРЦФ <> ТаблицаПередЗаписью.СтоимостьВРЦФ
	|				ИЛИ ТаблицаПриЗаписи.АмортизационнаяПремия <> ТаблицаПередЗаписью.АмортизационнаяПремия
	|				ИЛИ ТаблицаПриЗаписи.ПредварительнаяСтоимость <> ТаблицаПередЗаписью.ПредварительнаяСтоимость)
	|			И ТаблицаПриЗаписи.Регистратор = &Регистратор
	|
	|	) КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период  КАК Период,
	|	Таблица.Документ КАК Регистратор,
	|	Таблица.Организация КАК Организация
	|ПОМЕСТИТЬ ИзмененениеСтоимостиОСПриПринятииКУчетуИлиМодернизации
	|ИЗ
	|	СтоимостьОСИзменение КАК Таблица
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(Таблица.Документ) = ТИП(Документ.ПринятиеКУчетуОС2_4)
	|		ИЛИ ТИПЗНАЧЕНИЯ(Таблица.Документ) = ТИП(Документ.МодернизацияОС2_4)
	|";
	МассивТекстовЗапроса.Добавить(ТекстЗапросаИзменения);
	
	ТекстЗапросаЗаданияКРасчетуСтоимости =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.АналитикаКапитализацииРасходов КАК ОбъектУчета,
	|	&Регистратор             КАК Документ
	|ПОМЕСТИТЬ СтоимостьОС_ЗаданияКРасчетуСтоимостиВНАИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаПередЗаписью.Период            КАК Период,
	|		ТаблицаПередЗаписью.Организация       КАК Организация,
	|		ТаблицаПередЗаписью.АналитикаКапитализацииРасходов  КАК АналитикаКапитализацииРасходов
	|	ИЗ
	|		СтоимостьОСПередЗаписью КАК ТаблицаПередЗаписью
	|	ГДЕ
	|		ТаблицаПередЗаписью.ХозяйственнаяОперация В (
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПринятиеКУчетуОС), 
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПринятиеКУчетуОСПоДоговоруЛизинга),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.МодернизацияОС),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РазукомплектацияОС),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеНДС))
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаПриЗаписи.Период,
	|		ТаблицаПриЗаписи.Организация,
	|		ТаблицаПриЗаписи.АналитикаКапитализацииРасходов
	|	ИЗ
	|		РегистрНакопления.СтоимостьОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Регистратор = &Регистратор
	|		И ТаблицаПриЗаписи.ХозяйственнаяОперация В (
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПринятиеКУчетуОС), 
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПринятиеКУчетуОСПоДоговоруЛизинга),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.МодернизацияОС),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РазукомплектацияОС),
	|					ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеНДС))
	|	) КАК Таблица
	|";
	МассивТекстовЗапроса.Добавить(ТекстЗапросаЗаданияКРасчетуСтоимости);
	
	МассивЗапросовЗаданийПоОперациям = Новый Массив;
	МассивЗапросовЗаданийПоОперациям.Добавить(
		УчетНДСУП.ТекстЗапросаФормированияЗаданийПриПринятииКУчетуИлиМодернизацииВНА("ИзмененениеСтоимостиОСПриПринятииКУчетуИлиМодернизации"));
	ТекстЗапросаЗаданийКЗакрытиюМесяца = ЗакрытиеМесяцаСервер.ТекстЗапросЗаданийКЗакрытиюМесяца("СтоимостьОС", МассивЗапросовЗаданийПоОперациям);
	МассивТекстовЗапроса.Добавить(ТекстЗапросаЗаданийКЗакрытиюМесяца);
	
	МассивТекстовЗапроса.Добавить("УНИЧТОЖИТЬ СтоимостьОСПередЗаписью");
	
	ТекстЗапроса = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначенияУТ.РазделительЗапросовПакета());
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("СтоимостьОСИзменение", Выборка.Количество > 0);
	
	//
	Выборка = РезультатЗапроса[1].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("СтоимостьОС_ЗаданияКРасчетуСтоимостиВНАИзменение", Выборка.Количество > 0);
	
КонецПроцедуры
 
#КонецОбласти

#КонецЕсли
