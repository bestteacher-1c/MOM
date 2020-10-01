#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// По характеру договора определяет тип статьи (доходов или расходов)
//
// Параметры:
//  ХарактерДоговора - Перечисления.ХарактерыДоговоровФинансовыхИнструментов - характер договора кредита, депозита, займа.
//
// Возвращаемое значение:
//  Строка - "расходов" или "доходов".
//
Функция ТипСтатьи(ХарактерДоговора) Экспорт
	
	Возврат ?(ХарактерДоговора = Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм,НСтр("ru='расходов'"),НСтр("ru='доходов'"));
	
КонецФункции

// По хозяйственной операции определяет характер договора кредита, депозита, займа.
//
// Параметры:
//  ХозяйственнаяОперация - Перечисление.ХозяйственныеОперации - хозяйственная операция, по которой необходимо определить
//                                                               характер договора.
//
// Возвращаемое значение:
//   Перечисление.ХарактерыДоговоровФинансовыхИнструментов - характер договора кредита, депозита, займа.
//
Функция ХарактерДоговораПоОперации(ХозяйственнаяОперация) Экспорт
	
	ХозОперации = Перечисления.ХозяйственныеОперации;
	ХарактерыДоговоров = Перечисления.ХарактерыДоговоровФинансовыхИнструментов;
	Результат = Неопределено;
	Если ХозяйственнаяОперация = ХозОперации.НачисленияПоКредитам
		ИЛИ ХозяйственнаяОперация = ХозОперации.ПоступлениеДенежныхСредствПоКредитам
		ИЛИ ХозяйственнаяОперация = ХозОперации.ОплатаПоКредитам Тогда
		Результат = ХарактерыДоговоров.КредитИлиЗайм;
		
	ИначеЕсли ХозяйственнаяОперация = ХозОперации.НачисленияПоДепозитам 
		ИЛИ ХозяйственнаяОперация = ХозОперации.ПоступлениеДенежныхСредствПоДепозитам
		ИЛИ ХозяйственнаяОперация = ХозОперации.ПеречислениеНаДепозиты Тогда
		Результат = ХарактерыДоговоров.Депозит;
		
	ИначеЕсли ХозяйственнаяОперация = ХозОперации.НачисленияПоЗаймамВыданным
		ИЛИ ХозяйственнаяОперация = ХозОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным
		ИЛИ ХозяйственнаяОперация = ХозОперации.ВыдачаЗаймов Тогда
		Результат = ХарактерыДоговоров.ЗаймВыданный;
		
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// По характеру договора кредита, депозита, займа определяет хозяйственную операцию.
//
// Параметры:
//  ХарактерДоговора - Перечисление.ХарактерыДоговоровФинансовыхИнструментов - характер договора кредита, депозита, займа по
//      которому необходимо определить хозяйственную операцию.
//  ЭтоДокументПоступления - Булево - направление движения денежных средств.
//
// Возвращаемое значение:
//   Перечисление.ХозяйственныеОперации - хозяйственная операция.
//
Функция ОперацияПоХарактеруДоговора(ХарактерДоговора, ЭтоДокументПоступления = Ложь) Экспорт
	
	Результат = Неопределено;
	ХозОперации = Перечисления.ХозяйственныеОперации;
	ХарактерыДоговоров = Перечисления.ХарактерыДоговоровФинансовыхИнструментов;
	Если ХарактерДоговора = ХарактерыДоговоров.КредитИлиЗайм Тогда
		Результат = ?(ЭтоДокументПоступления, ХозОперации.ПоступлениеДенежныхСредствПоКредитам, ХозОперации.ОплатаПоКредитам);
		
	ИначеЕсли ХарактерДоговора = ХарактерыДоговоров.Депозит Тогда
		Результат = ?(ЭтоДокументПоступления, ХозОперации.ПоступлениеДенежныхСредствПоДепозитам, ХозОперации.ПеречислениеНаДепозиты);
		
	ИначеЕсли ХарактерДоговора = ХарактерыДоговоров.ЗаймВыданный Тогда
		Результат = ?(ЭтоДокументПоступления, ХозОперации.ПоступлениеДенежныхСредствПоЗаймамВыданным, ХозОперации.ВыдачаЗаймов);
		
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Подготавливает данные для заполнения документов движения денежных средств на основании договора кредита, депозита, займа.
//
// Параметры:
//  ДоговорКредитаДепозита - СправочникСсылка.ДоговорыКредитовИДепозитов - Договор на основании которого вводится
//                                                                         платежный документ.
//  ЭтоДокументПоступления - Булево - направление движения денежных средств.
//
// Возвращаемое значение:
//   Структура - данные для заполнения платежного документа.
//
Функция ДанныеЗаполненияДокументаДДС(ДоговорКредитаДепозита, ЭтоДокументПоступления = Ложь) Экспорт
	
	ДанныеЗаполнения = ДанныеШапкиДокументаДДС(ДоговорКредитаДепозита, ЭтоДокументПоступления);
	
	РасшифровкаПлатежа = ДанныеРасшифровкиПлатежаДокументаДДС(ДоговорКредитаДепозита, ЭтоДокументПоступления);
	Если РасшифровкаПлатежа.Количество() > 0 Тогда
		ДанныеЗаполнения.БанковскийСчетКонтрагента = РасшифровкаПлатежа[0].БанковскийСчетКонтрагента;
	КонецЕсли;
	ДанныеЗаполнения.Вставить("РасшифровкаПлатежа",РасшифровкаПлатежа);
	
	Возврат ДанныеЗаполнения;
	
КонецФункции

// Функция получает массив действующих договоров с контрагентом по заданным параметрам.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация, от имени которой заключен договор с контрагентом.
//	Контрагент - СправочникСсылка.Контрагенты - Контрагент, с которым заключен договор.
//	ХарактерДоговора - ПеречислениеСсылка.ХарактерыДоговоровФинансовыхИнструментов - характер договора.
//
// Возвращаемое значение:
//	Массив - массив договоров.
//
Функция ДействующиеДоговорыПоКонтрагенту(Организация, Контрагент, ХарактерДоговора) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка КАК Договор
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|ГДЕ
	|	ДоговорыКредитовИДепозитов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И ДоговорыКредитовИДепозитов.Организация = &Организация
	|	И ДоговорыКредитовИДепозитов.Контрагент = &Контрагент
	|	И ДоговорыКредитовИДепозитов.ХарактерДоговора = &ХарактерДоговора";
	
	Запрос.УстановитьПараметр("Контрагент",        Контрагент);
	Запрос.УстановитьПараметр("Организация",       Организация);
	Запрос.УстановитьПараметр("ХарактерДоговора",  ХарактерДоговора);
	
	МассивДоговоров = Новый Массив;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		МассивДоговоров.Добавить(Выборка.Договор);
	КонецЦикла;
	
	Возврат МассивДоговоров;
	
КонецФункции

// Функция возвращает таблицу расшифровки платежа по договору кредита / депозита.
//
// Параметры:
//	ДоговорКредитаДепозита - СправочникСсылка.ДоговорыКредитовИДепозитов - Договор, данные по которому требуется получить.
//	ЭтоДокументПоступления - Булево - Признак, определяющий направление движения денежных средств: выплата или поступление.
//	ДокументИсключение - ДокументСсылка.РасходныйКассовыйОрдер,
//                       ДокументСсылка.СписаниеБезналичныхДенежныхСредств,
//                       ДокументСсылка.ПриходныйКассовыйОрдер,
//                       ДокументСсылка.ПоступлениеБезналичныхДенежныхСредств - Документ, движения которого следует исключить.
//
// Возвращаемое значение:
//	ТаблицаЗначений - Расшифровка платежа.
//
Функция ДанныеРасшифровкиПлатежаДокументаДДС(ДоговорКредитаДепозита, ЭтоДокументПоступления = Ложь, ДокументИсключение = Неопределено) Экспорт
	
	СписокРеквизитов = "ВалютаВзаиморасчетов,ПорядокОплаты,ФормаОплаты,Касса,БанковскийСчет";
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДоговорКредитаДепозита,СписокРеквизитов);
	ВалютаДокумента = Реквизиты.ВалютаВзаиморасчетов;
	Если Реквизиты.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях Тогда
		ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли Реквизиты.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте Тогда
		Если Реквизиты.ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
			ВалютаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Касса,"ВалютаДенежныхСредств");
		Иначе
			ВалютаДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.БанковскийСчет,"ВалютаДенежныхСредств");
		КонецЕсли;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		ДоговорКредитаДепозита.ВалютаВзаиморасчетов,
		ВалютаДокумента,
		ТекущаяДатаСеанса());
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка КАК ДоговорКредитаДепозита,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПоступленияВыдачи КАК СтатьяДвиженияДенежныхСредств,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Транши) КАК ТипГрафика,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.ОсновнойДолг) КАК ТипСуммы,
	|	СУММА(ГрафикТраншейКредитовИДепозитов.Сумма) КАК СуммаГрафика,
	|	ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|ПОМЕСТИТЬ втДанныеГрафика
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикТраншейКредитовИДепозитов КАК ГрафикТраншейКредитовИДепозитов
	|		ПО ДоговорыКредитовИДепозитов.Ссылка = ГрафикТраншейКредитовИДепозитов.ВариантГрафика.Владелец
	|ГДЕ
	|	ГрафикТраншейКредитовИДепозитов.ВариантГрафика = &ВариантГрафика
	|	И ГрафикТраншейКредитовИДепозитов.Период <= &НаДату
	|	И &Транши
	|	И ГрафикТраншейКредитовИДепозитов.Сумма > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПоступленияВыдачи,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСОсновногоДолга,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Оплаты),
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.ОсновнойДолг),
	|	СУММА(ГрафикОплатКредитовИДепозитов.Сумма),
	|	ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикОплатКредитовИДепозитов КАК ГрафикОплатКредитовИДепозитов
	|		ПО ДоговорыКредитовИДепозитов.Ссылка = ГрафикОплатКредитовИДепозитов.ВариантГрафика.Владелец
	|ГДЕ
	|	ГрафикОплатКредитовИДепозитов.ВариантГрафика = &ВариантГрафика
	|	И ГрафикОплатКредитовИДепозитов.Период <= &НаДату
	|	И НЕ &Транши
	|	И ГрафикОплатКредитовИДепозитов.Сумма > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСОсновногоДолга,
	|	ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПроцентов,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Оплаты),
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты),
	|	СУММА(ГрафикОплатКредитовИДепозитов.Проценты),
	|	ВЫБОР
	|		КОГДА ДоговорыКредитовИДепозитов.БанковскийСчетПроцентов = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|			ТОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|		ИНАЧЕ ДоговорыКредитовИДепозитов.БанковскийСчетПроцентов
	|	КОНЕЦ
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикОплатКредитовИДепозитов КАК ГрафикОплатКредитовИДепозитов
	|		ПО ДоговорыКредитовИДепозитов.Ссылка = ГрафикОплатКредитовИДепозитов.ВариантГрафика.Владелец
	|ГДЕ
	|	ГрафикОплатКредитовИДепозитов.ВариантГрафика = &ВариантГрафика
	|	И ГрафикОплатКредитовИДепозитов.Период <= &НаДату
	|	И НЕ &Транши
	|	И ГрафикОплатКредитовИДепозитов.Проценты > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСПроцентов,
	|	ВЫБОР
	|		КОГДА ДоговорыКредитовИДепозитов.БанковскийСчетПроцентов = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|			ТОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|		ИНАЧЕ ДоговорыКредитовИДепозитов.БанковскийСчетПроцентов
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСКомиссии,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Оплаты),
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия),
	|	СУММА(ГрафикОплатКредитовИДепозитов.Комиссия),
	|	ВЫБОР
	|		КОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКомиссии = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|			ТОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|		ИНАЧЕ ДоговорыКредитовИДепозитов.БанковскийСчетКомиссии
	|	КОНЕЦ
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ГрафикОплатКредитовИДепозитов КАК ГрафикОплатКредитовИДепозитов
	|		ПО ДоговорыКредитовИДепозитов.Ссылка = ГрафикОплатКредитовИДепозитов.ВариантГрафика.Владелец
	|ГДЕ
	|	ГрафикОплатКредитовИДепозитов.ВариантГрафика = &ВариантГрафика
	|	И ГрафикОплатКредитовИДепозитов.Период <= &НаДату
	|	И НЕ &Транши
	|	И ГрафикОплатКредитовИДепозитов.Комиссия > 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.Подразделение,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКомиссии = ЗНАЧЕНИЕ(Справочник.БанковскиеСчетаКонтрагентов.ПустаяСсылка)
	|			ТОГДА ДоговорыКредитовИДепозитов.БанковскийСчетКонтрагента
	|		ИНАЧЕ ДоговорыКредитовИДепозитов.БанковскийСчетКомиссии
	|	КОНЕЦ,
	|	ДоговорыКредитовИДепозитов.СтатьяДДСКомиссии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДоговорКредитаДепозита,
	|	ТипСуммы,
	|	ТипГрафика,
	|	СтатьяДвиженияДенежныхСредств
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоФинансовымИнструментам.Договор КАК Договор,
	|	РасчетыПоФинансовымИнструментам.ТипСуммы КАК ТипСуммы,
	|	РасчетыПоФинансовымИнструментам.ТипГрафика КАК ТипГрафика,
	|	РасчетыПоФинансовымИнструментам.СтатьяАналитики КАК СтатьяАналитики,
	|	СУММА(РасчетыПоФинансовымИнструментам.Сумма) КАК СуммаВВалюте
	|ПОМЕСТИТЬ втОстатки
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам КАК РасчетыПоФинансовымИнструментам
	|ГДЕ
	|	РасчетыПоФинансовымИнструментам.Период <= &НаДату
	|	И РасчетыПоФинансовымИнструментам.Договор = &Ссылка
	|	И РасчетыПоФинансовымИнструментам.ТипГрафика <> ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Начисления)
	|	И РасчетыПоФинансовымИнструментам.Регистратор <> &ДокументИсключение
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоФинансовымИнструментам.СтатьяАналитики,
	|	РасчетыПоФинансовымИнструментам.ТипГрафика,
	|	РасчетыПоФинансовымИнструментам.ТипСуммы,
	|	РасчетыПоФинансовымИнструментам.Договор
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Договор,
	|	ТипСуммы,
	|	ТипГрафика,
	|	СтатьяАналитики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДоговора.Ссылка КАК ДоговорКредитаДепозита,
	|	ДанныеДоговора.Партнер,
	|	ВЫБОР КОГДА &Транши
	|		ТОГДА ДанныеДоговора.СтатьяДДСПоступленияВыдачи
	|		ИНАЧЕ ДанныеДоговора.СтатьяДДСОсновногоДолга
	|	КОНЕЦ КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеДоговора.Подразделение,
	|	ДанныеДоговора.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДоговора.БанковскийСчетКонтрагента,
	|	ВЫБОР КОГДА &Транши
	|		ТОГДА ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Транши)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Оплаты)
	|	КОНЕЦ ТипГрафика,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.ОсновнойДолг) КАК ТипСуммыКредитаДепозита
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДанныеДоговора
	|ГДЕ
	|	ДанныеДоговора.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втДанныеГрафика.ДоговорКредитаДепозита,
	|	втДанныеГрафика.Партнер,
	|	втДанныеГрафика.СтатьяДвиженияДенежныхСредств,
	|	втДанныеГрафика.Подразделение,
	|	втДанныеГрафика.ВалютаВзаиморасчетов,
	|	втДанныеГрафика.ТипГрафика,
	|	втДанныеГрафика.ТипСуммы,
	|	втДанныеГрафика.ТипСуммы КАК ТипСуммыКредитаДепозита,
	|	втДанныеГрафика.СуммаГрафика,
	|	ЕСТЬNULL(втОстатки.СуммаВВалюте, 0) КАК СуммаВВалюте,
	|	втДанныеГрафика.БанковскийСчетКонтрагента,
	|	ВЫБОР
	|		КОГДА втДанныеГрафика.СуммаГрафика - ЕСТЬNULL(втОстатки.СуммаВВалюте, 0) > 0
	|			ТОГДА (втДанныеГрафика.СуммаГрафика - ЕСТЬNULL(втОстатки.СуммаВВалюте, 0)) * &КоэффициентПересчетаВВалютуДокумента
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА втДанныеГрафика.СуммаГрафика - ЕСТЬNULL(втОстатки.СуммаВВалюте, 0) > 0
	|			ТОГДА втДанныеГрафика.СуммаГрафика - ЕСТЬNULL(втОстатки.СуммаВВалюте, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаВзаиморасчетов
	|ИЗ
	|	втДанныеГрафика КАК втДанныеГрафика
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОстатки КАК втОстатки
	|		ПО втДанныеГрафика.ДоговорКредитаДепозита = втОстатки.Договор
	|			И втДанныеГрафика.ТипСуммы = втОстатки.ТипСуммы
	|			И втДанныеГрафика.ТипГрафика = втОстатки.ТипГрафика
	|			И втДанныеГрафика.СтатьяДвиженияДенежныхСредств = втОстатки.СтатьяАналитики
	|ГДЕ
	|	втДанныеГрафика.СуммаГрафика - ЕСТЬNULL(втОстатки.СуммаВВалюте, 0) > 0";
	
	ХарактерыДоговоров = Перечисления.ХарактерыДоговоровФинансовыхИнструментов;
	Транши = ЭтоДокументПоступления И ДоговорКредитаДепозита.ХарактерДоговора = ХарактерыДоговоров.КредитИлиЗайм
				ИЛИ НЕ ЭтоДокументПоступления И (ДоговорКредитаДепозита.ХарактерДоговора = ХарактерыДоговоров.ЗаймВыданный
												ИЛИ ДоговорКредитаДепозита.ХарактерДоговора = ХарактерыДоговоров.Депозит);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("НаДату", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Ссылка", ДоговорКредитаДепозита);
	Запрос.УстановитьПараметр("ВариантГрафика", Справочники.ВариантыГрафиковКредитовИДепозитов.ТекущийВариантГрафика(ДоговорКредитаДепозита));
	Запрос.УстановитьПараметр("Транши", Транши);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуДокумента", Коэффициенты.КоэффициентПересчетаВВалютуВзаиморасчетов);
	Запрос.УстановитьПараметр("ДокументИсключение", ДокументИсключение);
	
	Результат = Запрос.ВыполнитьПакет();
	
	ДанныеРасшифровки = Результат[3].Выгрузить();// суммы по графику
	Если ДанныеРасшифровки.Количество() = 0 Тогда
		ДанныеРасшифровки = Результат[2].Выгрузить();// данные договора без сумм
	КонецЕсли;
	Возврат ДанныеРасшифровки;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив - имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ХарактерДоговора");
	Результат.Добавить("ТипДоговора");
	Результат.Добавить("Партнер");
	Результат.Добавить("Контрагент");
	Результат.Добавить("Организация");
	Результат.Добавить("ПорядокОплаты");
	Результат.Добавить("ВалютаВзаиморасчетов");
	Результат.Добавить("ТипКомиссии");
	
	Результат.Добавить("Подразделение");
	Результат.Добавить("НаправлениеДеятельности");
	
	Результат.Добавить("СтатьяДДСПоступленияВыдачи");
	Результат.Добавить("СтатьяДДСОсновногоДолга");
	Результат.Добавить("СтатьяДДСПроцентов");
	Результат.Добавить("СтатьяДДСКомиссии");
	
	Результат.Добавить("СтатьяДоходовРасходовПроцентов");
	Результат.Добавить("СтатьяДоходовРасходовКомиссии");
	
	Результат.Добавить("ГруппаФинансовогоУчетаДенежныхСредств");
	Результат.Добавить("ГруппаФинансовогоУчета");
	
	Возврат Результат;
	
КонецФункции

// По банковскому счету договора кредита, депозита, займа возвращает договор с контрагентом (организацией).
//
// Параметры:
//  ДоговорКредитовДепозитов - СправочникСсылка.ДоговорыКредитовИДепозитов - договор кредита, депозита, займа.
//
// Возвращаемое значение:
//   СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.ДоговорыМеждуОрганизациями - договор с заказчиком.
//
Функция ДоговорСЗаказчиком(ДоговорКредитовДепозитов) Экспорт 
	ДоговорСЗаказчиком = Неопределено;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.БанковскийСчет КАК Ссылка
	|ПОМЕСТИТЬ БанковскиеСчета
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|ГДЕ
	|	ДоговорыКредитовИДепозитов.Ссылка = &ДоговорКредитовДепозитов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	БанковскиеСчета КАК БанковскиеСчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|		ПО БанковскиеСчета.Ссылка = ДоговорыКонтрагентов.БанковскийСчет
	|ГДЕ
	|	ДоговорыКонтрагентов.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем)
	|	И ДоговорыКонтрагентов.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РеализацияКлиенту)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыМеждуОрганизациями.Ссылка
	|ИЗ
	|	БанковскиеСчета КАК БанковскиеСчета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыМеждуОрганизациями КАК ДоговорыМеждуОрганизациями
	|		ПО БанковскиеСчета.Ссылка = ДоговорыМеждуОрганизациями.БанковскийСчет
	|ГДЕ
	|	ДоговорыМеждуОрганизациями.ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоровМеждуОрганизациями.КупляПродажа)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ДоговорКредитовДепозитов", ДоговорКредитовДепозитов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
		ДоговорСЗаказчиком = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат ДоговорСЗаказчиком;
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК Т2 
	|	ПО Т2.Родитель = Т.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Партнер)
	|	И ЗначениеРазрешено(Т.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Определяет свойства полей формы в зависимости от данных
//
// Возвращаемое значение:
//    ТаблицаЗначений - таблица с колонками Поля, Условие, Свойства.
//
Функция НастройкиПолейФормы() Экспорт
	
	Финансы = ФинансоваяОтчетностьСервер;
	Настройки = ДенежныеСредстваСервер.ИнициализироватьНастройкиПолейФормы();
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("БанковскийСчет");
	Элемент.Поля.Добавить("БанковскийСчетКонтрагента");
	Элемент.Поля.Добавить("БанковскийСчетПроцентов");
	Элемент.Поля.Добавить("БанковскийСчетКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ФормаОплаты", Перечисления.ФормыОплаты.Безналичная);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("Касса");
	Финансы.НовыйОтбор(Элемент.Условие, "ФормаОплаты", Перечисления.ФормыОплаты.Наличная);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("Комиссия");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ТипКомиссии", Перечисления.ТипыКомиссииКредитовИДепозитов.Процент);
	Финансы.НовыйОтбор(ГруппаИли, "ТипКомиссии", Перечисления.ТипыКомиссииКредитовИДепозитов.Сумма);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяДДСКомиссии");
	Элемент.Поля.Добавить("СтатьяДоходовРасходовКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ТипКомиссии", Перечисления.ТипыКомиссииКредитовИДепозитов.Нет);
	Элемент.Свойства.Вставить("Видимость", Ложь);
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ФормаОплаты");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит);
	Элемент.Свойства.Вставить("ТолькоПросмотр");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ТипКомиссии");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит);
	Финансы.НовыйОтбор(ГруппаИли, "Дополнительно.ТипКомиссииЗаблокирован", Истина);
	Элемент.Свойства.Вставить("ТолькоПросмотр");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГруппаФинансовогоУчетаДенежныхСредств");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.Депозит);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СуммаЛимита");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.КонтролироватьЛимит", Ложь);
	Элемент.Свойства.Вставить("ТолькоПросмотр");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ИзменитьСтавкуПроцентов");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ЕстьИсторияСтавок", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтавкаПроцентов");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ЕстьИсторияСтавок", Истина);
	Элемент.Свойства.Вставить("ТолькоПросмотр");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ДатаПервогоТранша");
	Элемент.Поля.Добавить("ДатаПоследнегоПлатежа");
	Элемент.Поля.Добавить("СрокМес");
	Элемент.Поля.Добавить("СрокДней");
	Элемент.Поля.Добавить("СуммаТраншей");
	Элемент.Поля.Добавить("СуммаПроцентов");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВариантГрафика",,, ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Свойства.Вставить("Видимость", Ложь);
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СуммаКомиссии");
	ГруппаИли = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	Финансы.НовыйОтбор(ГруппаИли, "ТипКомиссии", Перечисления.ТипыКомиссииКредитовИДепозитов.Нет);
	Финансы.НовыйОтбор(ГруппаИли, "Дополнительно.ВариантГрафика",,, ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Свойства.Вставить("Видимость", Ложь);
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ДатаПервогоТраншаГрафика");
	Элемент.Поля.Добавить("ДатаПоследнегоПлатежаГрафика");
	Элемент.Поля.Добавить("СрокМесГрафика");
	Элемент.Поля.Добавить("СрокДнейГрафика");
	Элемент.Поля.Добавить("СуммаТраншейГрафика");
	Элемент.Поля.Добавить("СуммаПроцентовГрафика");
	Элемент.Поля.Добавить("СуммаКомиссииГрафика");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВариантГрафика",,, ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СуммаКомиссииГрафика");
	ГруппаНе = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаНе.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе;
	Финансы.НовыйОтбор(ГруппаНе, "ТипКомиссии", Перечисления.ТипыКомиссииКредитовИДепозитов.Нет);
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ВариантГрафика",,, ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Свойства.Вставить("Видимость");
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяДДСПоступления");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("Заголовок", НСтр("ru = 'Поступление'"));
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяДДСПоступления");
	ГруппаНе = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаНе.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе;
	Финансы.НовыйОтбор(ГруппаНе, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("Заголовок", НСтр("ru = 'Выплата'"));
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГруппаСтатьиДоходаРасхода");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("Заголовок", НСтр("ru = 'Статьи расходов'"));
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ГруппаСтатьиДоходаРасхода");
	ГруппаНе = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаНе.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе;
	Финансы.НовыйОтбор(ГруппаНе, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("Заголовок", НСтр("ru = 'Статьи доходов'"));
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяДоходовРасходовПроцентов");
	Элемент.Поля.Добавить("СтатьяДоходовРасходовКомиссии");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("ОграничениеТипа", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов"));
	
	//
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("СтатьяДоходовРасходовПроцентов");
	Элемент.Поля.Добавить("СтатьяДоходовРасходовКомиссии");
	ГруппаНе = Финансы.НовыйОтбор(Элемент.Условие,,, Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаНе.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе;
	Финансы.НовыйОтбор(ГруппаНе, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм);
	Элемент.Свойства.Вставить("ОграничениеТипа", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов"));
	
	//++ НЕ УТ
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("ПодтверждающиеДокументы");
	Финансы.НовыйОтбор(Элемент.Условие, "Дополнительно.ПлатежиПо275ФЗ", Истина);
	Элемент.Свойства.Вставить("Видимость");
	
	Элемент = Настройки.Добавить();
	Элемент.Поля.Добавить("КодРаздел7ДекларацииНДС");
	Финансы.НовыйОтбор(Элемент.Условие, "ХарактерДоговора", Перечисления.ХарактерыДоговоровФинансовыхИнструментов.ЗаймВыданный);
	Элемент.Свойства.Вставить("Видимость");
	//-- НЕ УТ
	
	Возврат Настройки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВводДокументовДвиженияДенежныхСредств

Функция ДанныеШапкиДокументаДДС(ДоговорКредитаДепозита, ЭтоДокументПоступления = Ложь)
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|		ДоговорКредитаДепозита.Организация КАК Организация,
	|		ДоговорКредитаДепозита.Ссылка КАК ДоговорКредитаДепозита,
	|		&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		0 КАК СуммаДокумента,
	|		ДоговорКредитаДепозита.Подразделение КАК Подразделение,
	|		ДоговорКредитаДепозита.Контрагент КАК Контрагент,
	|		ДоговорКредитаДепозита.Контрагент.Наименование КАК КонтрагентНаименование,
	|		ДоговорКредитаДепозита.Контрагент.НаименованиеПолное КАК КонтрагентНаименованиеПолное,
	|		ВЫБОР
	|			КОГДА ДоговорКредитаДепозита.ПорядокОплаты = ЗНАЧЕНИЕ(Перечисление.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях)
	|				ТОГДА &ВалютаРеглУчета
	|			КОГДА ДоговорКредитаДепозита.ПорядокОплаты = ЗНАЧЕНИЕ(Перечисление.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте)
	|				ТОГДА ВЫБОР КОГДА ДоговорКредитаДепозита.ФормаОплаты = ЗНАЧЕНИЕ(Перечисление.ФормыОплаты.Наличная)
	|							ТОГДА ДоговорКредитаДепозита.Касса.ВалютаДенежныхСредств
	|							ИНАЧЕ ДоговорКредитаДепозита.БанковскийСчет.ВалютаДенежныхСредств
	|						КОНЕЦ
	|			ИНАЧЕ ДоговорКредитаДепозита.ВалютаВзаиморасчетов
	|		КОНЕЦ КАК Валюта,
	|		ДоговорКредитаДепозита.ПорядокОплаты КАК ПорядокОплаты,
	|		ДоговорКредитаДепозита.ФормаОплаты КАК ФормаОплаты,
	|		ДоговорКредитаДепозита.Статус КАК Статус,
	|		ДоговорКредитаДепозита.Касса КАК Касса,
	|		ДоговорКредитаДепозита.БанковскийСчет КАК БанковскийСчет,
	|		ВЫБОР
	|			КОГДА ДоговорКредитаДепозита.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерыДоговоровФинансовыхИнструментов.КредитИлиЗайм)
	|				ИЛИ  ДоговорКредитаДепозита.ХарактерДоговора = ЗНАЧЕНИЕ(Перечисление.ХарактерыДоговоровФинансовыхИнструментов.Депозит)
	|				ТОГДА ЕСТЬNULL(ДоговорКредитаДепозита.БанковскийСчет.ОтдельныйСчетГОЗ, ЛОЖЬ)
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ПлатежиПо275ФЗ,
	|		ДоговорКредитаДепозита.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента
	|	ИЗ
	|		Справочник.ДоговорыКредитовИДепозитов КАК ДоговорКредитаДепозита
	|	ГДЕ
	|		ДоговорКредитаДепозита.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДоговорКредитаДепозита);
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ВалютаРеглУчета);
	Запрос.УстановитьПараметр("ХозяйственнаяОперация", ОперацияПоХарактеруДоговора(ДоговорКредитаДепозита.ХарактерДоговора, ЭтоДокументПоступления));
	
	РезультатЗапроса = Запрос.Выполнить();
	ДанныеШапки = Новый Структура;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ДанныеШапки.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеШапки, Выборка);
	
	Возврат ДанныеШапки;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.ВедомостьРасчетовПоФинансовымИнструментам.ДобавитьКомандуОтчета(КомандыОтчетов);
	Отчеты.ПланФактныйАнализФинансовыхИнструментов.ДобавитьКомандуОтчета(КомандыОтчетов, "ПланФактныйАнализКредитыДепозитыКонтекст");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
