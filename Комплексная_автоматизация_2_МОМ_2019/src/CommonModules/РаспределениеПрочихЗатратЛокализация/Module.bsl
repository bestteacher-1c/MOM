
#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытий

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый документ.
//  Отказ - Булево - Признак проведения документа.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то проведение документа выполнено не будет.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ОбработкаПроведения(Объект, Отказ, РежимПроведения) Экспорт
	
	Движения = Объект.Движения;
	ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	//++ НЕ УТ
	//++ Локализация
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(Объект, ДополнительныеСвойства, Движения, Отказ);
	//-- Локализация
	//-- НЕ УТ
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то будет выполнен отказ от продолжения работы после выполнения проверки заполнения.
//  ПроверяемыеРеквизиты - Массив - Массив путей к реквизитам, для которых будет выполнена проверка заполнения.
//
Процедура ОбработкаПроверкиЗаполнения(Объект, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект.
//  ДанныеЗаполнения - Произвольный - Значение, которое используется как основание для заполнения.
//  СтандартнаяОбработка - Булево - В данный параметр передается признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Объект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//
Процедура ОбработкаУдаленияПроведения(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина,
//                   то запись выполнена не будет и будет вызвано исключение.
//  РежимЗаписи - РежимЗаписиДокумента - В параметр передается текущий режим записи документа. Позволяет определить в теле процедуры режим записи.
//  РежимПроведения - РежимПроведенияДокумента - В данный параметр передается текущий режим проведения.
//
Процедура ПередЗаписью(Объект, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  Отказ - Булево - Признак отказа от записи.
//                   Если в теле процедуры-обработчика установить данному параметру значение Истина, то запись выполнена не будет и будет вызвано исключение.
//
Процедура ПриЗаписи(Объект, Отказ) Экспорт
	
	
КонецПроцедуры

// Вызывается из соответствующего обработчика документа
//
// Параметры:
//  Объект - ДокументОбъект - Обрабатываемый объект
//  ОбъектКопирования - ДокументОбъект.<Имя документа> - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Объект, ОбъектКопирования) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
КонецПроцедуры

// Добавляет команду создания документа "Авансовый отчет".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт


КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
КонецПроцедуры

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр)
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

//++ НЕ УТ
#Область ПроводкиРегУчета

//Регистрирует документ к отражению в регламентированном учете.
//Параметры:
//	Документ - ДокументСсылка.РаспределениеПрочихЗатрат - документ к отражению.
//
Процедура ЗарегистрироватьОтражениеДокумента(Документ) Экспорт
	
	//++ Локализация
	РеглУчетПроведениеСервер.ЗарегистрироватьОтражениеДокумента(Документ,
		Перечисления.СтатусыОтраженияДокументовВРеглУчете.КОтражениюВРеглУчете);
	//-- Локализация
				
КонецПроцедуры
			
// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	ТекстыОтражения = Новый Массив;
	
#Область РаспределениеРасходов //(Дт 20 :: Кт 25, 26)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Распределение расходов (Дт 20 :: Кт 25, 26)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	Строки.Сумма КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Производство) КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	Строки.МестоУчетаДт КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Строки.Подразделение КАК ПодразделениеДт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт2,
	|	Строки.ГруппаПродукции КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаНУ КАК СуммаНУДт,
	|	Строки.СуммаПР КАК СуммаПРДт,
	|	Строки.СуммаВР КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Операция.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка) КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаНУ КАК СуммаНУКт,
	|	Строки.СуммаПР КАК СуммаПРКт,
	|	Строки.СуммаВР КАК СуммаВРКт,
	|	""Распределение расходов"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеПрочихЗатрат КАК Операция
	|	ПО	
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПрочиеРасходыНЗП КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.ПорядокОтраженияПроизводства КАК Счета
	|	ПО 
	|		НЕ Счета.СчетУчета = ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|		И Счета.Организация = Операция.Организация
	|		И Счета.МестоПроизводства = Операция.Подразделение
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.ПорядокОтраженияРасходов КАК КорСчета
	|	ПО 
	|		КорСчета.Организация = Операция.Организация
	|		И КорСчета.Подразделение = Строки.Подразделение
	|		И КорСчета.СтатьяРасходов = Операция.СтатьяРасходов
	|	
	|ГДЕ
	|	(Строки.Сумма <> 0 ИЛИ Строки.СуммаНУ <> 0 ИЛИ Строки.СуммаВР <> 0 ИЛИ Строки.СуммаПР <> 0 ИЛИ Строки.СуммаУпр <> 0)
	|	И (ЕСТЬNULL(Счета.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ОсновноеПроизводство)) <> ЕСТЬNULL(КорСчета.СчетУчета, Операция.СтатьяРасходов.СчетУчета)
	|	    ИЛИ Операция.Подразделение <> Строки.Подразделение
	|	    ИЛИ Операция.НаправлениеДеятельности <> Строки.НаправлениеДеятельности
	|	    ИЛИ (&АналитическийУчетПоГруппамПродукции И Строки.ГруппаПродукции <> ЗНАЧЕНИЕ(Справочник.ГруппыАналитическогоУчетаНоменклатуры.ПустаяСсылка)))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ //// Распределение расходов (Дт 25, 26 :: Кт 25, 26)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ПрочиеРасходы.СуммаРегл КАК Сумма,
	|	ПрочиеРасходы.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаДт,
	|	ПрочиеРасходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	ПрочиеРасходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	ПрочиеРасходы.Подразделение КАК ПодразделениеДт,
	|	ПрочиеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	ПрочиеРасходы.СтатьяРасходов КАК СубконтоДт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоДт2,
	|	ПрочиеРасходы.АналитикаРасходов КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	ПрочиеРасходы.СуммаРегл - ПрочиеРасходы.ПостояннаяРазница - ПрочиеРасходы.ВременнаяРазница КАК СуммаНУДт,
	|	ПрочиеРасходы.ПостояннаяРазница КАК СуммаПРДт,
	|	ПрочиеРасходы.ВременнаяРазница КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Операция.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Операция.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	ПрочиеРасходы.СуммаРегл - ПрочиеРасходы.ПостояннаяРазница - ПрочиеРасходы.ВременнаяРазница КАК СуммаНУКт,
	|	ПрочиеРасходы.ПостояннаяРазница КАК СуммаПРКт,
	|	ПрочиеРасходы.ВременнаяРазница КАК СуммаВРКт,
	|	""Распределение расходов"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеПрочихЗатрат КАК Операция
	|	ПО	
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходы КАК ПрочиеРасходы
	|	ПО Операция.Ссылка = ПрочиеРасходы.ДокументДвижения
	|	   И ПрочиеРасходы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|	   И ПрочиеРасходы.Активность
	|	   И (ПрочиеРасходы.СуммаРегл <> 0 ИЛИ ПрочиеРасходы.ВременнаяРазница <> 0 ИЛИ ПрочиеРасходы.ПостояннаяРазница <> 0 ИЛИ ПрочиеРасходы.СуммаУпр <> 0)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);
	
#КонецОбласти

#Область СписаниеНаСтатьиАктивовПассивов //(Дт ХХ.ХХ :: Кт 20)
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание на прочие активы (Дт ХХ.ХХ :: Кт 20)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	ТаблицаСписание.НомерСтроки КАК ИдентификаторСтроки,
	|
	|	Строки.СуммаРегл КАК Сумма,
	|	Строки.СуммаУпр КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.ПрочиеАктивыПассивы) КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	ТаблицаСписание.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ТаблицаСписание.СчетУчета КАК СчетДт,
	|	ТаблицаСписание.Субконто1 КАК СубконтоДт1,
	|	ТаблицаСписание.Субконто2 КАК СубконтоДт2,
	|	ТаблицаСписание.Субконто3 КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	Строки.СуммаРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУДт,
	|	Строки.ПостояннаяРазница КАК СуммаПРДт,
	|	Строки.ВременнаяРазница КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	Операция.СтатьяРасходов КАК АналитикаУчетаКт,
	|	Строки.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Строки.Подразделение КАК ПодразделениеКт,
	|	Строки.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	Строки.СтатьяРасходов КАК СубконтоКт1,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт2,
	|	Строки.ГруппаПродукции КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	Строки.СуммаРегл - Строки.ПостояннаяРазница - Строки.ВременнаяРазница КАК СуммаНУКт,
	|	Строки.ПостояннаяРазница КАК СуммаПРКт,
	|	Строки.ВременнаяРазница КАК СуммаВРКт,
	|	""Списание на прочие активы"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеПрочихЗатрат КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК Строки
	|	ПО
	|		Операция.Ссылка = Строки.Регистратор
	|		И Строки.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
	|		И Строки.Активность
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.РаспределениеПрочихЗатрат.Списание КАК ТаблицаСписание
	|	ПО
	|		Операция.Ссылка = ТаблицаСписание.Ссылка
	|		И Строки.ИдентификаторСтроки = ТаблицаСписание.ИдентификаторСтроки
	|
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(ТаблицаСписание.СтатьяРасходов) = ТИП(ПланВидовХарактеристик.СтатьиАктивовПассивов)
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);

#КонецОбласти

#Область СписаниеКосвенныхРасходовОСНО
	ТекстСписаниеКосвенныхРасходовОСНО = "
	|ВЫБРАТЬ 
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	КосвенныеРасходы.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	СУММА(КосвенныеРасходы.СуммаРеглОСНО) КАК Сумма,
	|	СУММА(КосвенныеРасходы.СуммаУпрОСНО) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СписаниеРасходовОСНО) КАК ВидСчетаДт,
	|	КосвенныеРасходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	КосвенныеРасходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	КосвенныеРасходы.Подразделение КАК ПодразделениеДт,
	|	ВЫБОР 
	|		КОГДА &ИспользоватьУчетЗатратПоНаправлениямДеятельности ТОГДА
	|			КосвенныеРасходы.КорНаправлениеДеятельности
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	КосвенныеРасходы.СтатьяРасходов КАК СубконтоДт1,
	|	КосвенныеРасходы.АналитикаРасходов КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	СУММА(КосвенныеРасходы.СуммаРеглОСНО - КосвенныеРасходы.ПостояннаяРазницаОСНО - КосвенныеРасходы.ВременнаяРазницаОСНО) КАК СуммаНУДт,
	|	СУММА(КосвенныеРасходы.ПостояннаяРазницаОСНО) КАК СуммаПРДт,
	|	СУММА(КосвенныеРасходы.ВременнаяРазницаОСНО) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	КосвенныеРасходы.СтатьяРасходов КАК АналитикаУчетаКт,
	|	КосвенныеРасходы.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	КосвенныеРасходы.Подразделение КАК ПодразделениеКт,
	|	КосвенныеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	КосвенныеРасходы.СтатьяРасходов КАК СубконтоКт1,
	|	КосвенныеРасходы.АналитикаРасходов КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	СУММА(КосвенныеРасходы.СуммаРеглОСНО - КосвенныеРасходы.ПостояннаяРазницаОСНО - КосвенныеРасходы.ВременнаяРазницаОСНО) КАК СуммаНУКт,
	|	СУММА(КосвенныеРасходы.ПостояннаяРазницаОСНО) КАК СуммаПРКт,
	|	СУММА(КосвенныеРасходы.ВременнаяРазницаОСНО) КАК СуммаВРКт,
	|	""Списание косвенных расходов (ОСНО)"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеПрочихЗатрат КАК Реквизиты
	|	ПО ДокументыКОтражению.Ссылка = Реквизиты.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		КосвенныеРасходы КАК КосвенныеРасходы
	|	ПО
	|		ДокументыКОтражению.Ссылка = КосвенныеРасходы.Регистратор
	|ГДЕ
	|	(КосвенныеРасходы.СуммаРеглОСНО <> 0 
	|		ИЛИ КосвенныеРасходы.ПостояннаяРазницаОСНО <> 0
	|		ИЛИ КосвенныеРасходы.ВременнаяРазницаОСНО <> 0
	|		ИЛИ КосвенныеРасходы.СуммаУпрОСНО <> 0)
	|
	|СГРУППИРОВАТЬ ПО 
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата,
	|	КосвенныеРасходы.Организация,
	|	КосвенныеРасходы.СтатьяРасходов,
	|	КосвенныеРасходы.АналитикаРасходов,
	|	КосвенныеРасходы.Подразделение,
	|	КосвенныеРасходы.НаправлениеДеятельности,
	|	КосвенныеРасходы.КорНаправлениеДеятельности
	|";
	ТекстыОтражения.Добавить(ТекстСписаниеКосвенныхРасходовОСНО);
#КонецОбласти
	
#Область СписаниеКосвенныхРасходовЕНВД
	ТекстСписаниеКосвенныхРасходовЕНВД = "
	|ВЫБРАТЬ 
	|	Реквизиты.Ссылка КАК Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	КосвенныеРасходы.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	СУММА(КосвенныеРасходы.СуммаРеглЕНВД) КАК Сумма,
	|	СУММА(КосвенныеРасходы.СуммаУпрЕНВД) КАК СуммаУУ,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.СписаниеРасходовЕНВД) КАК ВидСчетаДт,
	|	КосвенныеРасходы.СтатьяРасходов КАК АналитикаУчетаДт,
	|	КосвенныеРасходы.Подразделение КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	КосвенныеРасходы.Подразделение КАК ПодразделениеДт,
	|	ВЫБОР 
	|		КОГДА &ИспользоватьУчетЗатратПоНаправлениямДеятельности ТОГДА
	|			КосвенныеРасходы.КорНаправлениеДеятельности
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)
	|	КОНЕЦ КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|
	|	КосвенныеРасходы.СтатьяРасходов КАК СубконтоДт1,
	|	КосвенныеРасходы.АналитикаРасходов КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	СУММА(КосвенныеРасходы.СуммаРеглЕНВД - КосвенныеРасходы.ПостояннаяРазницаЕНВД - КосвенныеРасходы.ВременнаяРазницаЕНВД) КАК СуммаНУДт,
	|	СУММА(КосвенныеРасходы.ПостояннаяРазницаЕНВД) КАК СуммаПРДт,
	|	СУММА(КосвенныеРасходы.ВременнаяРазницаЕНВД) КАК СуммаВРДт,
	|
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Расходы) КАК ВидСчетаКт,
	|	КосвенныеРасходы.СтатьяРасходов КАК АналитикаУчетаКт,
	|	КосвенныеРасходы.Подразделение КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	КосвенныеРасходы.Подразделение КАК ПодразделениеКт,
	|	КосвенныеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетКт,
	|
	|	КосвенныеРасходы.СтатьяРасходов КАК СубконтоКт1,
	|	КосвенныеРасходы.АналитикаРасходов КАК СубконтоКт2,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыЗатратРегл.Прочее) КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	СУММА(КосвенныеРасходы.СуммаРеглЕНВД - КосвенныеРасходы.ПостояннаяРазницаЕНВД - КосвенныеРасходы.ВременнаяРазницаЕНВД) КАК СуммаНУКт,
	|	СУММА(КосвенныеРасходы.ПостояннаяРазницаЕНВД) КАК СуммаПРКт,
	|	СУММА(КосвенныеРасходы.ВременнаяРазницаЕНВД) КАК СуммаВРКт,
	|	""Списание косвенных расходов (ЕНВД)"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеПрочихЗатрат КАК Реквизиты
	|	ПО ДокументыКОтражению.Ссылка = Реквизиты.Ссылка
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		КосвенныеРасходы КАК КосвенныеРасходы
	|	ПО
	|		ДокументыКОтражению.Ссылка = КосвенныеРасходы.Регистратор
	|ГДЕ
	|	(КосвенныеРасходы.СуммаРеглЕНВД <> 0 
	|		ИЛИ КосвенныеРасходы.ПостояннаяРазницаЕНВД <> 0
	|		ИЛИ КосвенныеРасходы.ВременнаяРазницаЕНВД <> 0
	|		ИЛИ КосвенныеРасходы.СуммаУпрЕНВД <> 0)
	|
	|СГРУППИРОВАТЬ ПО 
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата,
	|	КосвенныеРасходы.Организация,
	|	КосвенныеРасходы.СтатьяРасходов,
	|	КосвенныеРасходы.АналитикаРасходов,
	|	КосвенныеРасходы.Подразделение,
	|	КосвенныеРасходы.НаправлениеДеятельности,
	|	КосвенныеРасходы.КорНаправлениеДеятельности
	|";
	ТекстыОтражения.Добавить(ТекстСписаниеКосвенныхРасходовЕНВД);
#КонецОбласти

	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//   Строка - сформированный текст запроса.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ВыпускБезЗаказа.Ссылка,
	|	ВыпускБезЗаказа.КодСтроки,
	|	МАКСИМУМ(ВыпускБезЗаказа.Назначение.НаправлениеДеятельности) КАК НаправлениеДеятельности
	|ПОМЕСТИТЬ ВыпускиБезЗаказа
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Движения
	|		ПО ДокументыКОтражению.Ссылка = Движения.ДокументДвижения
	|			И Движения.Активность
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Товары КАК ВыпускБезЗаказа
	|		ПО (ВыпускБезЗаказа.Ссылка = Движения.ДокументВыпуска ИЛИ ВыпускБезЗаказа.Ссылка = Движения.ЗаказНаПроизводство)
	|		И ВыпускБезЗаказа.КодСтроки = Движения.КодСтрокиПродукция
	|ГДЕ
	|	НЕ ВыпускБезЗаказа.Ссылка.ВыпускПоРаспоряжениям
	|СГРУППИРОВАТЬ ПО
	|	ВыпускБезЗаказа.Ссылка,
	|	ВыпускБезЗаказа.КодСтроки
	|;
	|ВЫБРАТЬ
	|	Движения.ДокументДвижения     КАК Ссылка,
	|	(ВЫБОР
	|		КОГДА НЕ ЗаказыПереработчику.Партнер ЕСТЬ NULL ТОГДА ЗаказыПереработчику.Партнер
	|		КОГДА НЕ ОтчетПереработчика.Партнер ЕСТЬ NULL ТОГДА ОтчетПереработчика.Партнер
	|		ИНАЧЕ Движения.Подразделение КОНЕЦ) КАК МестоУчетаДт,
	|	Движения.Подразделение        КАК Подразделение,
	|	Движения.СтатьяРасходов       КАК СтатьяРасходов,
	|	Движения.ГруппаПродукции      КАК ГруппаПродукции,
	|	ВЫБОР
	|		КОГДА НЕ ВыпускБезЗаказа.НаправлениеДеятельности ЕСТЬ NULL
	|			ТОГДА ВыпускБезЗаказа.НаправлениеДеятельности
	|		ИНАЧЕ ЕСТЬNULL(СпрПартииПроизводства.НаправлениеДеятельности, Движения.НаправлениеДеятельности)
	|	КОНЕЦ                         КАК НаправлениеДеятельности,
	|	СУММА(Движения.СтоимостьРегл) КАК Сумма,
	|	СУММА(Движения.СтоимостьУпр)  КАК СуммаУпр,
	|	СУММА(Движения.СтоимостьРегл - Движения.ПостояннаяРазница - Движения.ВременнаяРазница) КАК СуммаНУ,
	|	СУММА(Движения.ПостояннаяРазница)   КАК СуммаПР,
	|	СУММА(Движения.ВременнаяРазница)    КАК СуммаВР
	|ПОМЕСТИТЬ ПрочиеРасходыНЗП
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПрочиеРасходыНезавершенногоПроизводства КАК Движения
	|		ПО ДокументыКОтражению.Ссылка = Движения.ДокументДвижения
	|			И Движения.Активность
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказПереработчику КАК ЗаказыПереработчику
	|		ПО ЗаказыПереработчику.Ссылка = Движения.ЗаказНаПроизводство
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.ОтчетПереработчика КАК ОтчетПереработчика
	|		ПО ОтчетПереработчика.Ссылка = Движения.ДокументВыпуска
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ ВыпускиБезЗаказа КАК ВыпускБезЗаказа
	|		ПО (ВыпускБезЗаказа.Ссылка = Движения.ДокументВыпуска ИЛИ ВыпускБезЗаказа.Ссылка = Движения.ЗаказНаПроизводство)
	|		И ВыпускБезЗаказа.КодСтроки = Движения.КодСтрокиПродукция
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|		ПО СпрПартииПроизводства.Ссылка = Движения.ПартияПроизводства
	|
	|СГРУППИРОВАТЬ ПО
	|	(ВЫБОР
	|		КОГДА НЕ ЗаказыПереработчику.Партнер ЕСТЬ NULL ТОГДА ЗаказыПереработчику.Партнер
	|		КОГДА НЕ ОтчетПереработчика.Партнер ЕСТЬ NULL ТОГДА ОтчетПереработчика.Партнер
	|		ИНАЧЕ Движения.Подразделение КОНЕЦ),
	|	Движения.ДокументДвижения,
	|	Движения.Подразделение,
	|	Движения.СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА НЕ ВыпускБезЗаказа.НаправлениеДеятельности ЕСТЬ NULL
	|			ТОГДА ВыпускБезЗаказа.НаправлениеДеятельности
	|		ИНАЧЕ ЕСТЬNULL(СпрПартииПроизводства.НаправлениеДеятельности, Движения.НаправлениеДеятельности)
	|	КОНЕЦ,
	|	Движения.ГруппаПродукции
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|ВЫБРАТЬ
	|	ДокументыКОтражению.Ссылка КАК Регистратор,
	|	КосвенныеРасходы.Организация КАК Организация,
	|	КосвенныеРасходы.Подразделение КАК Подразделение,
	|	КосвенныеРасходы.СтатьяРасходов КАК СтатьяРасходов,
	|	КосвенныеРасходы.АналитикаРасходов КАК АналитикаРасходов,
	|	КосвенныеРасходы.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	КосвенныеРасходы.КорНаправлениеДеятельности КАК КорНаправлениеДеятельности,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА КосвенныеРасходы.СуммаРегл
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА КосвенныеРасходы.СуммаРегл - ВЫРАЗИТЬ(КосвенныеРасходы.СуммаРегл * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаРеглОСНО,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА КосвенныеРасходы.СуммаРегл
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА ВЫРАЗИТЬ(КосвенныеРасходы.СуммаРегл * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаРеглЕНВД,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА КосвенныеРасходы.СуммаУпр
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА КосвенныеРасходы.СуммаУпр - ВЫРАЗИТЬ(КосвенныеРасходы.СуммаУпр * ЕСТЬNULL(Доли.ДоляЕНВД, 0) / КурсВалютыУпрУчета.Курс КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаУпрОСНО,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА КосвенныеРасходы.СуммаУпр
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА ВЫРАЗИТЬ(КосвенныеРасходы.СуммаУпр * ЕСТЬNULL(Доли.ДоляЕНВД, 0) / КурсВалютыУпрУчета.Курс КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК СуммаУпрЕНВД,
	|	
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ)
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА КосвенныеРасходы.ПостояннаяРазница
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА КосвенныеРасходы.ПостояннаяРазница - ВЫРАЗИТЬ(КосвенныеРасходы.ПостояннаяРазница * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК ПостояннаяРазницаОСНО,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА КосвенныеРасходы.ПостояннаяРазница
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА ВЫРАЗИТЬ(КосвенныеРасходы.ПостояннаяРазница * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК ПостояннаяРазницаЕНВД,
	|	
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ)
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА КосвенныеРасходы.ВременнаяРазница
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА КосвенныеРасходы.ВременнаяРазница - ВЫРАЗИТЬ(КосвенныеРасходы.ВременнаяРазница * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК ВременнаяРазницаОСНО,
	|	ВЫБОР 
	|		КОГДА НЕ ЕСТЬNULL(УчетнаяПолитикаОрганизаций.УчетнаяПолитика.ПрименяетсяЕНВД, ЛОЖЬ) 
	|			  ИЛИ СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения)
	|			ТОГДА 0
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения)
	|			ТОГДА КосвенныеРасходы.ВременнаяРазница
	|		КОГДА СтатьиРасходов.ВидДеятельностиДляНалоговогоУчетаЗатрат = ЗНАЧЕНИЕ(Перечисление.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты)
	|			ТОГДА ВЫРАЗИТЬ(КосвенныеРасходы.ВременнаяРазница * ЕСТЬNULL(Доли.ДоляЕНВД, 0) КАК ЧИСЛО(31,2))
	|	КОНЕЦ КАК ВременнаяРазницаЕНВД
	|
	|ПОМЕСТИТЬ КосвенныеРасходы 
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РаспределениеПрочихЗатрат КАК Реквизиты
	|	ПО ДокументыКОтражению.Ссылка = Реквизиты.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПрочиеРасходы КАК КосвенныеРасходы
	|	ПО
	|		ДокументыКОтражению.Ссылка = КосвенныеРасходы.Регистратор
	|		И КосвенныеРасходы.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РаспределениеРасходовПоНаправлениямДеятельности)
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|	ПО
	|		КосвенныеРасходы.СтатьяРасходов = СтатьиРасходов.Ссылка
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ 
	|		РегистрСведений.ПорядокОтраженияРасходов КАК ПорядокОтраженияРасходов
	|	ПО 
	|		КосвенныеРасходы.Организация = ПорядокОтраженияРасходов.Организация
	|		И КосвенныеРасходы.СтатьяРасходов = ПорядокОтраженияРасходов.СтатьяРасходов
	|		И КосвенныеРасходы.Подразделение = ПорядокОтраженияРасходов.Подразделение
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		УчетнаяПолитикаОрганизаций КАК УчетнаяПолитикаОрганизаций
	|	ПО
	|		ДокументыКОтражению.Ссылка = УчетнаяПолитикаОрганизаций.Ссылка
	|		И Реквизиты.Организация = УчетнаяПолитикаОрганизаций.Организация
	|		И НАЧАЛОПЕРИОДА(ДокументыКОтражению.Период, ДЕНЬ) = УчетнаяПолитикаОрганизаций.ДатаОтражения
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ДолиСписанияКосвенныхРасходов КАК Доли
	|	ПО
	|		Доли.Период МЕЖДУ НАЧАЛОПЕРИОДА(ДокументыКОтражению.Период, МЕСЯЦ) И КОНЕЦПЕРИОДА(ДокументыКОтражению.Период, МЕСЯЦ)
	|		И Доли.Организация = КосвенныеРасходы.Организация 
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = Доли.ПериодРасчета
	|		
	|ГДЕ
	|	КосвенныеРасходы.СтатьяРасходов <> ЗНАЧЕНИЕ(ПланВидовХарактеристик.СтатьиРасходов.ПогрешностьРасчетаСебестоимости)
	|	И НЕ ВЫБОР
	|			КОГДА ЕСТЬNULL(ПорядокОтраженияРасходов.СчетУчета, ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)) <> ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка)
	|				ТОГДА ПорядокОтраженияРасходов.СчетУчета
	|			ИНАЧЕ СтатьиРасходов.СчетУчета
	|		КОНЕЦ В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеДоходыИРасходы), 
	|						  ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.Продажи))
	|;
	|";
	
	Возврат ТекстЗапроса;
	
	//-- Локализация
	Возврат "";
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

// Процедура дополняет тексты запросов проведения документа.
//
// Параметры:
//  Запрос - Запрос - Общий запрос проведения документа.
//  ТекстыЗапроса - СписокЗначений - Список текстов запроса проведения.
//  Регистры - Строка, Структура - Список регистров проведения документа через запятую или в ключах структуры.
//
Процедура ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
