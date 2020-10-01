#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую.
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "Склад,ВариантОформленияДокументов,ХозяйственнаяОперация,СтатусЗаказаКлиента,СтатусРеализацииТоваровУслуг,Дата";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе
//
// Параметры:
//  Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//  Структура - Состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Истина);
	
	Заказ = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	
	Заказ.ПолноеИмяОбъекта = "Обработка.ПомощникПродаж";
	Заказ.ИмяТЧСерии = "Товары";
	
	Если Объект.ВариантОформленияДокументов <> Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
		
		Заказ.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
		Заказ.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	Иначе
		Заказ.ИспользоватьСерииНоменклатуры  = Ложь;
		Заказ.УчитыватьСебестоимостьПоСериям = Ложь;
	КонецЕсли;
		
	Заказ.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	
	Заказ.ПоляСвязи.Добавить("ВариантОформления");
	Заказ.ПоляСвязи.Добавить("Склад");
	
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийНаСкладах");
	Заказ.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийПереданныхТоваров");
	
	Заказ.ЭтоЗаказ = Истина;
	
	Заказ.ПланированиеОтгрузки = Истина;
	Заказ.РегистрироватьСерии = Ложь;
	
	Заказ.Дата = ТекущаяДатаСеанса();
	
	Реализация = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	
	Реализация.ПолноеИмяОбъекта = "Обработка.ПомощникПродаж";
	
	ПередачаТоваровНаХранение = Ложь;
	РеализацияПоРеглУчету = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет;
	//++ НЕ УТ
	ПередачаТоваровНаХранение = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи;
	//-- НЕ УТ
	
	Если Объект.ВариантОформленияДокументов <> Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение Тогда
		Реализация.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
		
		Если РеализацияПоРеглУчету Тогда
			Реализация.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
		Иначе
			Реализация.ИспользоватьСерииНоменклатуры  = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
		КонецЕсли;	
	Иначе
		Реализация.ИспользоватьСерииНоменклатуры  = Ложь;
		Реализация.УчитыватьСебестоимостьПоСериям = Ложь;
	КонецЕсли;
	
	Реализация.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтгрузкаКлиенту);
	
	Реализация.ПоляСвязи.Добавить("ВариантОформления");
	Реализация.ПоляСвязи.Добавить("Склад");
	
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерий");
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийНаСкладах");
	Реализация.ИменаПолейСтатусУказанияСерий.Добавить("СтатусУказанияСерийПереданныхТоваров");
	
	Реализация.ЭтоНакладная = Истина;
	
	Реализация.ТолькоСерииДляСебестоимости = РеализацияПоРеглУчету;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыРеализацийТоваровУслуг") Тогда
		СтатусРеализации = Объект.СтатусРеализацииТоваровУслуг;
	Иначе
		СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
	КонецЕсли;
	
	Если ПередачаТоваровНаХранение Тогда
		Реализация.ПланированиеОтбора = Истина;
		Реализация.ФактОтбора         = Истина;
	Иначе
		Реализация.ПланированиеОтгрузки = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.КПредоплате;
		Реализация.ПланированиеОтбора = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
		Реализация.ФактОтбора = СтатусРеализации = Перечисления.СтатусыРеализацийТоваровУслуг.Отгружено;
	КонецЕсли;
	
	Реализация.РегистрироватьСерии = НоменклатураКлиентСервер.НеобходимоРегистрироватьСерии(Реализация);
	
	Реализация.Дата = ТекущаяДатаСеанса();
	
	ПараметрыУказанияСерий = Новый Структура;
	ПараметрыУказанияСерий.Вставить("Реализация", Реализация);
	ПараметрыУказанияСерий.Вставить("Заказ", Заказ);
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	Если ПараметрыУказанияСерий.ЭтоНакладная Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	Товары.Серия,
		|	Товары.Количество,
		|	Товары.СтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров,
		|	Товары.НомерСтроки
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика,
		|	Серии.Количество
		|ПОМЕСТИТЬ Серии
		|ИЗ
		|	&Серии КАК Серии
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	СУММА(Товары.Количество) КАК Количество,
		|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры
		|ПОМЕСТИТЬ ТоварыДляЗапроса
		|ИЗ
		|	Товары КАК Товары
		|
		|СГРУППИРОВАТЬ ПО
		|	Товары.ВариантОформления,
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Характеристика,
		|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика,
		|	СУММА(Серии.Количество) КАК Количество
		|ПОМЕСТИТЬ СерииДляЗапроса
		|ИЗ
		|	Серии КАК Серии
		|
		|СГРУППИРОВАТЬ ПО
		|	Серии.ВариантОформления,
		|	Серии.Склад,
		|	Серии.Номенклатура,
		|	Серии.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах КАК СтарыйСтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров КАК СтарыйСтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиента)
		|			ТОГДА Товары.СтатусУказанияСерий
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение)
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА &ТолькоСерииДляСебестоимости
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 10
		|					ИНАЧЕ 9
		|				КОНЕЦ
		|		КОГДА Склады.ИспользоватьОрдернуюСхемуПриОтгрузке
		|				И &Дата >= Склады.ДатаНачалаОрдернойСхемыПриОтгрузке
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
		|				И &ПланированиеОтбора
		|			ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
		|						ТОГДА ВЫБОР
		|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|										И ТоварыДляЗапроса.Количество > 0
		|									ТОГДА 6
		|								ИНАЧЕ 5
		|							КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|									И ТоварыДляЗапроса.Количество > 0
		|								ТОГДА 8
		|							ИНАЧЕ 7
		|						КОНЕЦ
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
		|				И &ФактОтбора
		|				И ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузкеКлиенту
		|			ТОГДА ВЫБОР
		|					КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
		|						ТОГДА ВЫБОР
		|								КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|										И ТоварыДляЗапроса.Количество > 0
		|									ТОГДА 4
		|								ИНАЧЕ 3
		|							КОНЕЦ
		|					ИНАЧЕ ВЫБОР
		|							КОГДА ТоварыДляЗапроса.Количество = ЕСТЬNULL(СерииДляЗапроса.Количество, 0)
		|									И ТоварыДляЗапроса.Количество > 0
		|								ТОГДА 2
		|							ИНАЧЕ 1
		|						КОНЕЦ
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий,
		|	ВЫБОР
		|		КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий ЕСТЬ NULL
		|				И НЕ &ИспользоватьПередачуНаОтветственноеХранение
		|			ТОГДА 0
		|		ИНАЧЕ
		|			ВЫБОР
		|				КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|					ТОГДА
		|						ВЫБОР
		|							КОГДА ТоварыДляЗапроса.ВидНоменклатуры.ПолитикаУчетаСерий.УчетСерийВПереданныхНаХранениеТоварах
		|								ТОГДА
		|									ВЫБОР
		|										КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|											ТОГДА 18
		|										ИНАЧЕ 17
		|									КОНЕЦ
		|								ИНАЧЕ 0
		|						КОНЕЦ
		|					ИНАЧЕ 0
		|			КОНЕЦ
		|	КОНЕЦ КАК СтатусУказанияСерийПереданныхТоваров
		|ПОМЕСТИТЬ Статусы
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыДляЗапроса КАК ТоварыДляЗапроса
		|			ЛЕВОЕ СОЕДИНЕНИЕ СерииДляЗапроса КАК СерииДляЗапроса
		|			ПО ТоварыДляЗапроса.Номенклатура = СерииДляЗапроса.Номенклатура
		|				И ТоварыДляЗапроса.Характеристика = СерииДляЗапроса.Характеристика
		|				И ТоварыДляЗапроса.Склад = СерииДляЗапроса.Склад
		|				И ТоварыДляЗапроса.ВариантОформления = СерииДляЗапроса.ВариантОформления
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
		|				ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
		|			ПО ПолитикиУчетаСерий.Склад = ТоварыДляЗапроса.Склад
		|				И ТоварыДляЗапроса.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
		|		ПО Товары.Номенклатура = ТоварыДляЗапроса.Номенклатура
		|			И Товары.Характеристика = ТоварыДляЗапроса.Характеристика
		|			И Товары.Склад = ТоварыДляЗапроса.Склад
		|			И Товары.ВариантОформления = ТоварыДляЗапроса.ВариантОформления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Статусы.НомерСтроки КАК НомерСтроки,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерийНаСкладах,
		|	Статусы.СтатусУказанияСерийПереданныхТоваров КАК СтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Статусы.СтатусУказанияСерий = 0
		|			ТОГДА Статусы.СтатусУказанияСерийПереданныхТоваров
		|		ИНАЧЕ Статусы.СтатусУказанияСерий
		|	КОНЕЦ КАК СтатусУказанияСерий
		|ИЗ
		|	Статусы КАК Статусы
		|ГДЕ
		|	ВЫБОР
		|		КОГДА Статусы.СтатусУказанияСерий = 0
		|			ТОГДА Статусы.СтатусУказанияСерийПереданныхТоваров
		|		ИНАЧЕ Статусы.СтатусУказанияСерий
		|	КОНЕЦ <> Статусы.СтарыйСтатусУказанияСерий
		|	ИЛИ Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерийНаСкладах
		|	ИЛИ Статусы.СтатусУказанияСерийПереданныхТоваров <> Статусы.СтарыйСтатусУказанияСерийПереданныхТоваров
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	ИначеЕсли ПараметрыУказанияСерий.ЭтоЗаказ Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Товары.Склад,
		|	Товары.Номенклатура,
		|	Товары.Серия,
		|	Товары.Отменено,
		|	Товары.ВариантОбеспечения,
		|	Товары.Количество,
		|	Товары.СтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров,
		|	Товары.НомерСтроки,
		|	Товары.ВариантОформления
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Товары.НомерСтроки КАК НомерСтроки,
		|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
		|	Товары.СтатусУказанияСерийНаСкладах КАК СтарыйСтатусУказанияСерийНаСкладах,
		|	Товары.СтатусУказанияСерийПереданныхТоваров КАК СтарыйСтатусУказанияСерийПереданныхТоваров,
		|	ВЫБОР
		|		КОГДА Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.РеализацияТоваровУслуг)
		//++ НЕ УТ
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ПередачаТоваровХранителю)
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаПередачаТоваровХранителю)
		//-- НЕ УТ
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаРеализацияТоваровУслуг)
		|			ТОГДА Товары.СтатусУказанияСерий
		|		КОГДА Товары.Отменено
		|				ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение)
		|				ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL
		|				ИЛИ НЕ Товары.ВариантОбеспечения В (
		|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада),
		|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.Отгрузить),
		|						ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.ОтгрузитьОбособленно))
		|			ТОГДА 0
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 14
		|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
		|						ТОГДА 15
		|					ИНАЧЕ 13
		|				КОНЕЦ
		|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
		|			ТОГДА ВЫБОР
		|					КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|						ТОГДА 10
		|					КОГДА Товары.ВариантОбеспечения = ЗНАЧЕНИЕ(Перечисление.ВариантыОбеспечения.СоСклада)
		|						ТОГДА 11
		|					ИНАЧЕ 9
		|				КОНЕЦ
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК СтатусУказанияСерий,
		|	0 КАК СтатусУказанияСерийПереданныхТоваров
		|ПОМЕСТИТЬ Статусы
		|ИЗ
		|	Товары КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
		|		ПО (ПолитикиУчетаСерий.Склад = Товары.Склад)
		|			И ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Статусы.НомерСтроки КАК НомерСтроки,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерийНаСкладах,
		|	Статусы.СтатусУказанияСерийПереданныхТоваров КАК СтатусУказанияСерийПереданныхТоваров,
		|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
		|ИЗ
		|	Статусы КАК Статусы
		|ГДЕ
		|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	Иначе
		ТекстИсключения = НСтр("ru = 'Ошибка определения текста запроса для заполнения статуса указания серий.'");
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	УсловиеЗапроса = "ЛОЖЬ";
	
	//++ НЕ УТ
	ИспользоватьПередачуНаОтветственноеХранение = ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	УсловиеЗапроса = ?(ИспользоватьПередачуНаОтветственноеХранение,
						"(Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ПередачаТоваровХранителю)
						|	ИЛИ Товары.ВариантОформления = ЗНАЧЕНИЕ(Перечисление.ВариантыОформленияДокументовПродажи.ЗаказКлиентаПередачаТоваровХранителю))",
						УсловиеЗапроса);
	//-- НЕ УТ
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИспользоватьПередачуНаОтветственноеХранение", УсловиеЗапроса);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС продажи.
//
// Параметры:
//  Объект - ОбработкаОбъект.ПомощникПродаж - документ, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
//
Функция ПараметрыЗаполненияНалогообложенияНДСПродажи(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.Дата = Объект.Дата;
	ПараметрыЗаполнения.Склад = Объект.Склад;
	ПараметрыЗаполнения.Договор = Объект.Договор;
	ПараметрыЗаполнения.НаправлениеДеятельности = Объект.НаправлениеДеятельности;
	
	Если Объект.ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.КоммерческоеПредложение Или
		Объект.ВариантОформленияДокументов = Перечисления.ВариантыОформленияДокументовПродажи.ЗаказКлиента Тогда
		
		ПараметрыЗаполнения.ЭтоЗаказ = Истина;
		
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту Или
		Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности  Тогда
		
		ПараметрыЗаполнения.РеализацияТоваров = Истина;
		ПараметрыЗаполнения.РеализацияРаботУслуг = Истина;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		
		ПараметрыЗаполнения.ПередачаНаКомиссию = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#Область ОснованиеДляПечати

// Возвращает таблицу значений по умолчанию для реквизита "Основание"
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, ДокументОбъект.ПомощникПродаж - Объект, по которму необходимо получить список выбора.
//
// Возвращаемое значение:
//	ТаблицаОснований - Таблица значений с реквизитами оснований.
//
Функция ТаблицаОснованийДляПечати(Объект) Экспорт
	
	ЭтоПередачаНаКомиссию = (Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию);
	ЭтоПередачаНаХранение = 
		(Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи);
	
	ТаблицаОснований = Новый ТаблицаЗначений;
	ТаблицаОснований.Колонки.Добавить("Основание",      Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(300)));
	ТаблицаОснований.Колонки.Добавить("ОснованиеДата",  Новый ОписаниеТипов("Дата",,,,,Новый КвалификаторыДаты(ЧастиДаты.Дата))); 
	ТаблицаОснований.Колонки.Добавить("ОснованиеНомер", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(128)));
	
	СтруктураОснования = СтруктураОснования(Объект, Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов);
	Если ЗначениеЗаполнено(СтруктураОснования.Основание) Тогда
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ЗаполнитьЗначенияСвойств(ДобавленнаяСтрока, СтруктураОснования);
		ДобавленнаяСтрока.Основание = СтруктураОснования.Основание
						+ ?(ЭтоПередачаНаКомиссию, ", " + НСтр("ru='передача на комиссию'"),
							?(ЭтоПередачаНаХранение, ", " + НСтр("ru='передача на хранение'"), ""));
	КонецЕсли;
	
	Если (ЭтоПередачаНаКомиссию
			Или ЭтоПередачаНаХранение)
		И ТаблицаОснований.Количество()=0 Тогда
		
		ДобавленнаяСтрока = ТаблицаОснований.Добавить();
		ДобавленнаяСтрока.Основание = ?(ЭтоПередачаНаКомиссию,
										НСтр("ru='Передача на комиссию'"),
										НСтр("ru='передача на хранение'"));
		
	КонецЕсли;
	
	Возврат ТаблицаОснований;
	
КонецФункции

// Возвращает текст основания по данными документа
//
// Параметры:
//	Объект - ДанныеФормыСтруктура, ДокументОбъект.ПомощникПродаж - Объект, по которму необходимо получить текст основания
//	ПорядокРасчетов - ПеречислениеСсылка.ПорядокРасчетов - порядок расчетов документа.
//
// Возвращаемое значение:
//	СтруктураОснование - Структура с наименованием, датой и номером основания.
//
Функция СтруктураОснования(Объект, ПорядокРасчетов) Экспорт
	
	СтруктураОснование = Новый Структура("Основание, ОснованиеНомер, ОснованиеДата");
	
	Если ЗначениеЗаполнено(Объект.Договор)
		И ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДоговорыКонтрагентов.НаименованиеДляПечати КАК Основание,
		|	ДоговорыКонтрагентов.Дата                  КАК ОснованиеДата,
		|	ДоговорыКонтрагентов.Номер                 КАК ОснованиеНомер
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Договор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			СтруктураОснование.Основание      = СокрЛП(Выборка.Основание);
			СтруктураОснование.ОснованиеДата  = Выборка.ОснованиеДата;
			СтруктураОснование.ОснованиеНомер = СокрЛП(Выборка.ОснованиеНомер);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураОснование; // Возврат значения по умолчанию
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныйПрограммныйИнтерфейс

#Область Обеспечение

// Используется для получения заполнения реквизитов табличной части документа, и реквизитов документа, связанных с
// управлением обеспечением.
//
// Параметры:
//  Объект           - ДанныеФормыСтруктура        - реквизит формы документа, содержащий объект, в списке товаров
//                                                   которого необходимо заполнить обеспечение.
//  Форма            - ФормаКлиентскогоПриложения            - форма документа, в таблице которой необходимо заполнить обеспечение.
//  Операция         - Строка                      - строка, обозначающая выполняемую операцию. Возможные значения
//                                                   операций заполнения обеспечения:
//                                                   "СтрокаТовары" - для одной строки из формы объекта, по
//                                                                    идентификатору строки,
//                                                   "СтрокиТовары" - для выбранных строк из формы объекта, по
//                                                                    идентификаторам строк,
//                                                   "Заказ" - для всех строк из формы документа, по идентификаторам строк
//  ДанныеЗаполнения - ТаблицаЗначений             - таблица с колонками, для заполнения обеспечения:
//    * Количество         - Число                                  - значение реквизита "Количество" для переноса в
//                                                                    строку списка.
//    * ВариантОбеспечения - ПеречислениеСсылка.ВариантыОбеспечения - значение реквизита "Вариант обеспечения" для
//                                                                    переноса в строку списка.
//    * Склад              - СправочникСсылка.Склады                - значение реквизита "Склад" для переноса в строку
//        списка, используется, например для заполнения по группе складов.
//    * Идентификатор      - Число                                  - индетификатор строки списка.
//    * ПараметрыУказанияСерий - Структура - структура параметров указания серий, для заполнения статусов указания серий
//                                           в изменяемых строках см. НоменклатураСервер.ПараметрыУказанияСерий
//  ЗависимыеРеквизиты     - Структура для заполнения реквизитов строки, зависящих от значения в реквизите "Количество".
//
// Возвращаемое значение:
//  Строка - Строка для вывода информационного сообщения о количестве обработанных строк в списке.
//
Функция ЗаполнитьВариантОбеспечения(Объект, Форма, Операция, ДанныеЗаполнения, ПараметрыУказанияСерий, ЗависимыеРеквизиты) Экспорт

	ЭтоВыборОбеспеченияСУчетомСерий = Операция = "СтрокаТовары"
		И ПолучитьФункциональнуюОпцию("ИспользоватьРасширеннуюФормуПодбораКоличестваИВариантовОбеспечения");
	
	Реквизиты = "КоличествоУпаковок, Сумма, СуммаНДС, СуммаСНДС, СуммаРучнойСкидки, СуммаАвтоматическойСкидки";
	СтруктураПересчетаСуммы = ОбработкаТабличнойЧастиКлиентСервер.СтруктураПересчетаСуммы(Реквизиты, ЗависимыеРеквизиты);

	СкладГруппа = Справочники.Склады.ЭтоГруппаИСкладыИспользуютсяВТЧДокументовПродажи(Объект.Склад);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьЗаполнитьСклад", ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруЗаполненияСкладаВСтрокеТЧ(Объект, СкладГруппа));
	Если Форма <> Неопределено Тогда
		СтруктураДействий.Вставить("ПриИзмененииТипаНоменклатурыИлиВариантаОбеспечения",
			Новый Структура("ЕстьРаботы, ЕстьОтменено", Истина, Ложь));
	КонецЕсли;
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();

	ЗаполнитьДатыОтгрузки = Ложь;
	ДатаПоУмолчанию = Макс(НачалоДня(ТекущаяДатаСеанса()), Объект.ЖелаемаяДатаОтгрузки);

	ТекСтрокаТовары = Неопределено;
	Идентификатор   = Неопределено;
	СтарыеЗначения = ОбеспечениеКлиентСервер.КлючОбеспечения();
	НовыеЗначения  = ОбеспечениеКлиентСервер.КлючОбеспечения();
	Счетчик = 0;
	
	ПараметрыОбновленияДатыОтгрузки = ОбеспечениеСервер.ПараметрыОбновленияДатыОтгрузкиВДокументе();
	ПараметрыОбновленияДатыОтгрузки.ОтгружатьОднойДатой    = Объект.НеОтгружатьЧастями;
	ПараметрыОбновленияДатыОтгрузки.ЖелаемаяДатаОтгрузки   = Объект.ЖелаемаяДатаОтгрузки;
	ПараметрыОбновленияДатыОтгрузки.ДатаОтгрузкиВДокументе = Объект.ДатаОтгрузки;
	
	ОбеспечениеСервер.СдвинутьДатыИСвернутьДублиСтрок(ДанныеЗаполнения, Операция, ПараметрыОбновленияДатыОтгрузки);
	
	Для Каждого СтрокаОбеспечения Из ДанныеЗаполнения Цикл

		// Выбор существующей, либо добавление новой строки.
		Если Идентификатор <> СтрокаОбеспечения.Идентификатор Тогда

			Идентификатор = СтрокаОбеспечения.Идентификатор;
			СтрокаТовары = Объект.Товары.НайтиПоИдентификатору(Идентификатор);
			ТекСтрокаТовары = СтрокаТовары;

			ОбработкаТабличнойЧастиКлиентСервер.ПересчитатьСуммы(СтруктураПересчетаСуммы);
			ОбработкаТабличнойЧастиКлиентСервер.ЗаполнитьСтруктуруПересчетаСуммы(СтруктураПересчетаСуммы, ТекСтрокаТовары);

		Иначе
			ТекСтрокаТовары = Объект.Товары.Вставить(Объект.Товары.Индекс(ТекСтрокаТовары) + 1);
			ЗаполнитьЗначенияСвойств(ТекСтрокаТовары, СтрокаТовары);
			ТекСтрокаТовары.КодСтроки = 0;
		КонецЕсли;

		// Заполнение полей обеспечения.
		ЗаполнитьЗначенияСвойств(СтарыеЗначения, ТекСтрокаТовары);

		ЗаполнитьЗначенияСвойств(ТекСтрокаТовары, СтрокаОбеспечения, "Количество, ВариантОбеспечения, Склад, ДатаОтгрузки");
		Если ЭтоВыборОбеспеченияСУчетомСерий Тогда
			ТекСтрокаТовары.Серия = СтрокаОбеспечения.Серия;
		КонецЕсли;
		
		Если Объект.НеОтгружатьЧастями Тогда
			ДатаОтгрузки = Макс(СтрокаОбеспечения.ДатаОтгрузки, ДатаПоУмолчанию);
			Если Операция = "Заказ" Или ДатаОтгрузки > Объект.ДатаОтгрузки И СтрокаОбеспечения.Отгружено = 0 Тогда
				Объект.ДатаОтгрузки = ДатаОтгрузки;
				ЗаполнитьДатыОтгрузки = Истина;
			КонецЕсли;
		КонецЕсли;

		ЗаполнитьЗначенияСвойств(НовыеЗначения, ТекСтрокаТовары);
		ОбеспечениеКлиентСервер.СчетИзменений(Счетчик, СтарыеЗначения, НовыеЗначения);

		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекСтрокаТовары, СтруктураДействий, КэшированныеЗначения);
		ОбработкаТабличнойЧастиКлиентСервер.ДобавитьСтрокуДляПересчетаСуммы(СтруктураПересчетаСуммы, ТекСтрокаТовары);

	КонецЦикла;

	ОбработкаТабличнойЧастиКлиентСервер.ПересчитатьСуммы(СтруктураПересчетаСуммы);

	Если ЗаполнитьДатыОтгрузки Тогда
		ОбеспечениеСервер.ЗаполнитьРеквизитВКоллекции(Объект.Товары, "ДатаОтгрузки", Объект.ДатаОтгрузки);
	КонецЕсли;

	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий.Реализация);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий.Заказ);

	Если Операция = "СтрокаТовары" Или Операция = "СтрокиТовары" Или Операция = "Заказ" Тогда
		Форма.Модифицированность = Истина;
	КонецЕсли;

	Возврат ОбеспечениеКлиентСервер.ТекстОбработаноСтрок(Счетчик);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область Прочее

// Возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект
// см. ОбщегоНазначения.ЗначениеРеквизитаОбъекта()
// Если полученное значение не имеет тип булево, возвращается значение Ложь.
//
Функция ЗначениеРеквизитаОбъектаТипаБулево(Ссылка, ИмяРеквизита) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		Результат = Ложь;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);	
	Возврат Результат
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
