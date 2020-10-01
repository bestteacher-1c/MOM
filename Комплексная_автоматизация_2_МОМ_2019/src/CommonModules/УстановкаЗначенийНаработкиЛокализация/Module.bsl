////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Установка значений наработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ТекстЗапросаДляЗаполненияНаОснованииОбъектаЭксплуатации() Экспорт

	ТекстЗапроса = Неопределено;
	
	//++ Локализация
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Объекты.Ссылка КАК ОбъектЭксплуатации,
	|	ЕСТЬNULL(ЕСТЬNULL(ПервоначальныеСведенияОС.ПоказательНаработки, ПорядокУчетаОС.ПоказательНаработки), ЗНАЧЕНИЕ(Справочник.ПоказателиНаработки.ПустаяСсылка)) КАК ПоказательНаработки,
	|	Объекты.Статус КАК Статус,
	|	ЛОЖЬ КАК ЕстьОшибкиСтатус,
	|	Объекты.ПометкаУдаления КАК ЕстьОшибкиУдален,
	|	Объекты.ЭтоГруппа КАК ЕстьОшибкиГруппа
	|ИЗ
	|	Справочник.ОбъектыЭксплуатации КАК Объекты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.СрезПоследних(
	|				&Дата,
	|				НЕ &ИспользуетсяУправлениеВНА_2_4
	|					И ОсновноеСредство В (&ОбъектЭксплуатации)) КАК ПервоначальныеСведенияОС
	|		ПО Объекты.Ссылка = ПервоначальныеСведенияОС.ОсновноеСредство
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаОС.СрезПоследних(
	|				&Дата,
	|				&ИспользуетсяУправлениеВНА_2_4
	|					И ОсновноеСредство В (&ОбъектЭксплуатации)) КАК ПорядокУчетаОС
	|		ПО Объекты.Ссылка = ПорядокУчетаОС.ОсновноеСредство
	|ГДЕ
	|	Объекты.Ссылка В (&ОбъектЭксплуатации)";
	
	//-- Локализация
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
