#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		
		ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ДополнительныеСвойства.Вставить("ДляПроведения", Новый Структура);
	ДополнительныеСвойства.ДляПроведения.Вставить("СтруктураВременныеТаблицы", Новый Структура("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц));
	
	Если НЕ Отказ Тогда
		ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект,
		Новый Структура("ОтражениеРасходов"),
		НепроверяемыеРеквизиты,
		Отказ);
		
	ПроверитьЧтоОсновныеСредстваСоответствуютВидуНалога(Отказ);
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи();
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи();
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
КонецПроцедуры

Процедура ОбработкаЗаполненияОбъектЭксплуатации(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОсновноеСредство", ДанныеЗаполнения);
	Запрос.УстановитьПараметр("Период", ?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()));
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистрацияЗемельныхУчастковСрезПоследних.Организация,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодКатегорииЗемель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастровыйНомер,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КадастроваяСтоимость,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ОбщаяСобственность,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляВПравеОбщейСобственностиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ЖилищноеСтроительство,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаНачалаПроектирования,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДатаРегистрацииПравНаОбъектНедвижимости,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПостановкаНаУчетВНалоговомОргане,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговыйОрган,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодПоОКАТО,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НалоговаяЛьготаПоНалоговойБазе,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	РегистрацияЗемельныхУчастковСрезПоследних.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыПоСтатье391,
	|	РегистрацияЗемельныхУчастковСрезПоследних.УменьшениеНалоговойБазыНаСумму,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	РегистрацияЗемельныхУчастковСрезПоследних.НеОблагаемаяНалогомСумма,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СниженнаяНалоговаяСтавка,
	|	РегистрацияЗемельныхУчастковСрезПоследних.ПроцентУменьшенияСуммыНалога,
	|	РегистрацияЗемельныхУчастковСрезПоследних.СуммаУменьшенияСуммыНалога
	|ИЗ
	|	РегистрСведений.РегистрацияЗемельныхУчастков.СрезПоследних(&Период, ОсновноеСредство = &ОсновноеСредство) КАК РегистрацияЗемельныхУчастковСрезПоследних";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() > 0 Тогда
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
		ЗаполнитьЗначенияСвойств(ОС.Добавить(), Выборка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ЗаданияКЗакрытиюМесяца

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПередЗаписью()

	Если ДополнительныеСвойства.ЭтоНовый 
		ИЛИ (ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение 
			И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Дата КАК Период,
	|	ТаблицаПередЗаписью.Организация КАК Организация,
	|	ТаблицаПередЗаписью.ВидНалога
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.Подразделение,
	|	ТаблицаПередЗаписью.НаправлениеДеятельности,
	|	ТаблицаПередЗаписью.СтатьяРасходов,
	|	ТаблицаПередЗаписью.АналитикаРасходов,
	|	ТаблицаПередЗаписью.Коэффициент
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПередЗаписью.Ссылка.Дата КАК Период,
	|	ТаблицаПередЗаписью.ОсновноеСредство
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПередЗаписью
	|ГДЕ
	|	ТаблицаПередЗаписью.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Ссылка.Проведен";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляФормированияЗаданияКЗакрытиюМесяцаПриЗаписи()

	Если ДополнительныеСвойства.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;

	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НАЧАЛОПЕРИОДА(ТаблицаПередЗаписью.Период, МЕСЯЦ) КАК Период
	|ИЗ
	|	ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.НаправлениеДеятельности = ТаблицаПослеЗаписи.НаправлениеДеятельности
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|			И (ТаблицаПослеЗаписи.Ссылка = &Ссылка)
	|			И (ТаблицаПослеЗаписи.Ссылка.Проведен)
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка ЕСТЬ NULL
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ)
	|ИЗ
	|	Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОтражениеРасходов КАК ТаблицаПослеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью КАК ТаблицаПередЗаписью
	|		ПО ТаблицаПередЗаписью.Подразделение = ТаблицаПослеЗаписи.Подразделение
	|			И ТаблицаПередЗаписью.НаправлениеДеятельности = ТаблицаПослеЗаписи.НаправлениеДеятельности
	|			И ТаблицаПередЗаписью.СтатьяРасходов = ТаблицаПослеЗаписи.СтатьяРасходов
	|			И ТаблицаПередЗаписью.АналитикаРасходов = ТаблицаПослеЗаписи.АналитикаРасходов
	|			И ТаблицаПередЗаписью.Коэффициент = ТаблицаПослеЗаписи.Коэффициент
	|ГДЕ
	|	ТаблицаПослеЗаписи.Ссылка = &Ссылка
	|	И ТаблицаПередЗаписью.Подразделение ЕСТЬ NULL
	|	И ТаблицаПослеЗаписи.Ссылка.Проведен";
	
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВидНалога", ВидНалога);
	Запрос.УстановитьПараметр("Дата", Дата);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		// Реквизиты документа не изменились.
		Возврат;
	КонецЕсли;
	
	// Реквизиты документа изменились.
	// Нужно сформировать задания по ОС указанным в ТЧ до записи и после записи.
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_НалогНаИмуществоИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ТранспортныйНалогИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ТранспортныйНалог)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Период           КАК Период,
	|	Таблица.Организация      КАК Организация,
	|	Таблица.ОсновноеСредство КАК ОсновноеСредство,
	|	ИСТИНА                   КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                     КАК ОтражатьВУпрУчете,
	|	&Ссылка                  КАК Документ
	|ПОМЕСТИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ЗемельныйНалогИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ШапкаПередЗаписью.Период              КАК Период,
	|		ШапкаПередЗаписью.Организация         КАК Организация,
	|		ТаблицаПередЗаписью.ОсновноеСредство  КАК ОсновноеСредство
	|	ИЗ
	|		ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью КАК ТаблицаПередЗаписью
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью КАК ШапкаПередЗаписью
	|			ПО ИСТИНА
	|	ГДЕ
	|		ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество)
	|			ИЛИ ШапкаПередЗаписью.ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка)
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		&Дата,
	|		&Организация,
	|		ТаблицаПриЗаписи.ОсновноеСредство
	|	ИЗ
	|		Документ.ИзменениеСпособаОтраженияИмущественныхНалогов.ОС КАК ТаблицаПриЗаписи
	|	ГДЕ
	|		ТаблицаПриЗаписи.Ссылка = &Ссылка
	|		И (&ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ЗемельныйНалог)
	|			ИЛИ &ВидНалога = ЗНАЧЕНИЕ(Перечисление.ВидыИмущественныхНалогов.ПустаяСсылка))
	|
	|	) КАК Таблица
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОтражениеРасходов_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ОС_ПередЗаписью
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ИзменениеСпособаОтраженияИмущественныхНалогов_ПередЗаписью";
	Запрос.Текст = ТекстЗапроса;
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// НалогНаИмущество
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_НалогНаИмуществоИзменение", Выборка.Количество > 0);
	
	// ТранспортныйНалог
	Выборка = РезультатЗапроса[1].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_ТранспортныйНалогИзменение", Выборка.Количество > 0);
	
	// ЗемельныйНалог
	Выборка = РезультатЗапроса[2].Выбрать();
	Выборка.Следующий();
	
	СтруктураВременныеТаблицы.Вставить("ИзменениеСпособаОтраженияИмущественныхНалогов_ЗемельныйНалогИзменение", Выборка.Количество > 0);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьЧтоОсновныеСредстваСоответствуютВидуНалога(Отказ)

	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат;
	КонецЕсли; 
	
	Если ВидНалога = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" не должно относиться к группе ОС ""Земельные участки"".'");
		ШаблонСообщенияАмГруппа = НСтр("ru = 'Основное средство ""%1"" не должно относиться к первой или второй амортизационным группам.'");
		ШаблонСообщенияНедвижимоеИмущество = НСтр("ru = 'Основное средство ""%1"" должно относиться к недвижимому имуществу.'");
	ИначеЕсли ВидНалога = Перечисления.ВидыИмущественныхНалогов.ТранспортныйНалог Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" должно относиться к группе ОС ""Транспортные средства"", ""Машины и оборудование (кроме офисного)"".'");
	ИначеЕсли ВидНалога = Перечисления.ВидыИмущественныхНалогов.ЗемельныйНалог Тогда
		ШаблонСообщенияГруппаОС = НСтр("ru = 'Основное средство ""%1"" должно относиться к группе ОС ""Земельные участки"".'");
	КонецЕсли; 
	
	Результат = Документы.ИзменениеСпособаОтраженияИмущественныхНалогов.ОсновныеСредстваКоторыеНеСоответствуютВидуНалога(
					ВидНалога, ОС.ВыгрузитьКолонку("ОсновноеСредство"), Дата);
	
	Для каждого ЭлементКоллекции Из Результат Цикл
		
		ДанныеСтроки = ОС.Найти(ЭлементКоллекции.Ссылка, "ОсновноеСредство");
		
		Если ВидНалога = Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество Тогда
			
			Если Дата < '201901010000'
				И (ЭлементКоллекции.АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы.ПерваяГруппа
					ИЛИ ЭлементКоллекции.АмортизационнаяГруппа = Перечисления.АмортизационныеГруппы.ВтораяГруппа) Тогда
			
				ТекстСообщения = СтрШаблон(ШаблонСообщенияАмГруппа, ЭлементКоллекции.Наименование);
			Иначе
				ТекстСообщения = СтрШаблон(ШаблонСообщенияНедвижимоеИмущество, ЭлементКоллекции.Наименование);
			КонецЕсли;
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли; 
		
		Если ВидНалога <> Перечисления.ВидыИмущественныхНалогов.НалогНаИмущество
			ИЛИ ЭлементКоллекции.ГруппаОС = Перечисления.ГруппыОС.ЗемельныеУчастки Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщенияГруппаОС, ЭлементКоллекции.Наименование);
			
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли; 
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
