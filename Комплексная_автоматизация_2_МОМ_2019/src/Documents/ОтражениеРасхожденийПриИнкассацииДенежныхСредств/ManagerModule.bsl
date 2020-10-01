#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
	ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Отражение расхождений при инкассации денежных средств".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	
	
	ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);

КонецПроцедуры

//++ НЕ УТ

// Возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

	Возврат ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ТекстОтраженияВРеглУчете();

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	ТекстЗапроса - Строка - текст запроса создания временных таблиц.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт

	Возврат ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();

КонецФункции

//-- НЕ УТ

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Выбранная хозяйственная операция
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции.
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СтатьяДоходов");
	МассивВсехРеквизитов.Добавить("АналитикаДоходов");
	МассивВсехРеквизитов.Добавить("СтатьяРасходов");
	МассивВсехРеквизитов.Добавить("АналитикаРасходов");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяДоходов");
		МассивРеквизитовОперации.Добавить("АналитикаДоходов");
	
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяРасходов");
		МассивРеквизитовОперации.Добавить("АналитикаРасходов");
		
	КонецЕсли;
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("СуммаВВалюте", "Сумма");
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
			ТекстЗапроса, ПолноеИмяДокумента, "", Ложь, ПереопределениеРасчетаПараметров);
	Иначе
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
			ТекстЗапроса, ПолноеИмяДокумента, "");
	КонецЕсли;
	
	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);

	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
	//++ НЕ УТ
	ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата                                                        КАК Период,
	|	ДанныеДокумента.Организация                                                 КАК Организация,
	|	ДанныеДокумента.ХозяйственнаяОперация                                       КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.БанковскийСчет                                              КАК БанковскийСчет,
	|	ДанныеДокумента.Касса                                                       КАК Касса,
	|	ДанныеДокумента.Сумма                                                       КАК СуммаВВалюте,
	|	ДанныеДокумента.Валюта                                                      КАК Валюта,    
	|	
	|	ДанныеДокумента.Подразделение                                               КАК Подразделение,
	|	ДанныеДокумента.БанковскийСчет.Подразделение                                КАК БанковскийСчетПодразделение,
	|	ДанныеДокумента.БанковскийСчет.НаправлениеДеятельности                      КАК НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяДоходов                                               КАК СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов                                            КАК АналитикаДоходов,
	|	ДанныеДокумента.СтатьяРасходов                                              КАК СтатьяРасходов,
	|	ДанныеДокумента.СтатьяРасходов.ПринятиеКНалоговомуУчету                     КАК ПринятиеКНалоговомуУчету,
	|	ДанныеДокумента.АналитикаРасходов                                           КАК АналитикаРасходов,
	|	
	|	ДанныеДокумента.СтатьяДвиженияДенежныхСредств                               КАК СтатьяДвиженияДенежныхСредств,
	|	
	|	ДанныеДокумента.Ответственный                                               КАК Ответственный,
	|	ДанныеДокумента.Номер                                                       КАК Номер,
	|	ДанныеДокумента.Комментарий                                                 КАК Комментарий,
	|	ДанныеДокумента.ПометкаУдаления                                             КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен                                                    КАК Проведен
	|	
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения(Реквизиты) Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)
	
	Значения = Новый Структура;
	Значения.Вставить("ИдентификаторМетаданных",                         ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств"));
	Значения.Вставить("ВалютаУправленческогоУчета",                      Константы.ВалютаУправленческогоУчета.Получить());
	Значения.Вставить("ВалютаРегламентированногоУчета",                  Константы.ВалютаРегламентированногоУчета.Получить());
	
	Если Реквизиты <> Неопределено Тогда
		Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
			Реквизиты.Валюта, Неопределено, Реквизиты.Период);
			
		Значения.Вставить("КоэффициентПересчетаВВалютуУпр",              Коэффициенты.КоэффициентПересчетаВВалютуУпр);
		Значения.Вставить("КоэффициентПересчетаВВалютуРегл",             Коэффициенты.КоэффициентПересчетаВВалютуРегл);
		Значения.Вставить("НомерНаПечать",                               ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

Функция ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	&Подразделение                               КАК Подразделение,
	|	&НаправлениеДеятельности                     КАК НаправлениеДеятельности,
	|	&СтатьяДоходов                               КАК СтатьяДоходов,
	|	&АналитикаДоходов                            КАК АналитикаДоходов,
	|	
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр КАК Сумма,
	|	ВЫБОР
	|		КОГДА &УправленческийУчетОрганизаций
	|			ТОГДА &СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр
	|		ИНАЧЕ 0
	|	КОНЕЦ                                        КАК СуммаУпр,
	|	ВЫБОР
	|		КОГДА &ИспользоватьУчетПрочихДоходовРасходовРегл
	|			ТОГДА &СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл
	|		ИНАЧЕ 0
	|	КОНЕЦ                                        КАК СуммаРегл,
	|	
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация
	|	
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	&Подразделение                               КАК Подразделение,
	|	&НаправлениеДеятельности                     КАК НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяРасходов               КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов            КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                 КАК ВидДеятельностиНДС,
	|	
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр КАК СуммаСНДС,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр КАК СуммаБезНДС,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр КАК СуммаБезНДСУпр,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл КАК СуммаСНДСРегл,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0                                            КАК ПостояннаяРазница,
	|	0                                            КАК ВременнаяРазница,
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО                                 КАК АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПартииПрочихРасходов";
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                            КАК ВидДвижения,
	|	&Период                                                           КАК Период,
	|	
	|	&Организация                                                      КАК Организация,
	|	&Подразделение                                                    КАК Подразделение,
	|	&Ссылка                                                           КАК ДокументПоступленияРасходов,
	|	ДанныеДокумента.СтатьяРасходов                                    КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов                                 КАК АналитикаРасходов,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаАктивовПассивов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)       КАК АналитикаУчетаПартий,
	|	&НаправлениеДеятельности                                          КАК НаправлениеДеятельности,
	|	НЕОПРЕДЕЛЕНО                                                      КАК АналитикаУчетаНоменклатуры,
	|	НЕОПРЕДЕЛЕНО                                                      КАК ВидДеятельностиНДС,
	|	
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр                   КАК Стоимость,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр                   КАК СтоимостьБезНДС,
	|	0                                                                 КАК НДСУпр,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл                  КАК СтоимостьРегл,	
	|	0                                                                 КАК ПостояннаяРазница,
	|	0                                                                 КАК ВременнаяРазница,
	|	0                                                                 КАК НДСРегл,
	|	&ХозяйственнаяОперация                                            КАК ХозяйственнаяОперация
	|
	|ПОМЕСТИТЬ ВтИсходныеПартииПрочихРасходов
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса) Экспорт
	
	ИмяРегистра = "ВтПартииПрочихРасходов";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтИсходныеПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаВтПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПартииПрочихРасходов.ТекстЗапросаТаблицаПартииПрочихРасходов();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                                     КАК ВидДвижения,
	|	&Период                                                                    КАК Период,
	|	
	|	&Организация                                                               КАК Организация,
	|	&БанковскийСчет                                                            КАК Получатель,
	|	&Касса                                                                     КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк)        КАК ВидПереводаДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО                                                               КАК Контрагент,
	|	&Валюта                                                                    КАК Валюта,
	|	
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СуммаВВалюте
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&СуммаВВалюте
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр
	|	КОНЕЦ КАК СуммаУпр,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	
	|	&ХозяйственнаяОперация                                                     КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств                                             КАК СтатьяДвиженияДенежныхСредств
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&БанковскийСчетПодразделение КАК Подразделение,
	|	&НаправлениеДеятельности     КАК НаправлениеДеятельностиДС,
	|	&Подразделение               КАК ПодразделениеДоходовРасходов,
	|
	|	ДанныеДокумента.Касса КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваВПути) КАК ТипДенежныхСредств,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	&Валюта КАК Валюта,
	|
	|	&НаправлениеДеятельности     КАК НаправлениеДеятельностиСтатьи,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяРасходов
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяДоходов
	|	КОНЕЦ КАК СтатьяДоходовРасходов,
	|	&АналитикаДоходов КАК АналитикаДоходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр КАК Сумма,
	|	&СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл КАК СуммаРегл,
	|	&СуммаВВалюте КАК СуммаВВалюте,
	|
	|	ДанныеДокумента.Касса КАК ИсточникГФУДенежныхСредств,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяРасходов
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяДоходов
	|	КОНЕЦ КАК ИсточникГФУДоходовРасходов
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПартииПрочихРасходов", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПартииПрочихРасходов(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеАктивыПассивы.ТекстЗапросаТаблицаПрочиеАктивыПассивы();
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

//++ НЕ УТ
Функция ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	0 КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	"""" КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	Документ.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ВЫБОР КОГДА &Валюта = &ВалютаРегламентированногоУчета
	|		ТОГДА &СуммаВВалюте
	|		ИНАЧЕ &СуммаВВалюте * &КоэффициентПересчетаВВалютуРегл
	|	КОНЕЦ КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	ВЫБОР КОГДА &Валюта = &ВалютаУправленческогоУчета
	|		ТОГДА &СуммаВВалюте
	|		ИНАЧЕ &СуммаВВалюте * &КоэффициентПересчетаВВалютуУпр
	|	КОНЕЦ КАК СуммаБезНДСУпр,
	|	0 КАК СуммаНДСУпр,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции
//-- НЕ УТ

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Организация                            КАК Организация,
	|	НЕОПРЕДЕЛЕНО                            КАК Партнер,
	|	&БанковскийСчет                         КАК МестоХранения,
	|	НЕОПРЕДЕЛЕНО                            КАК Контрагент,
	|	&Подразделение                          КАК Подразделение,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Ссылка                                 КАК Ссылка,
	
	|	&Номер                                  КАК НомерДокументаИБ,
	|	НЕОПРЕДЕЛЕНО                            КАК Статус,
	|	&Ответственный                          КАК Ответственный,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	НЕОПРЕДЕЛЕНО                            КАК Дополнительно,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&СуммаВВалюте                           КАК Сумма,
	|	&Валюта                                 КАК Валюта,
	|	НЕОПРЕДЕЛЕНО                            КАК Договор,
	|	НЕОПРЕДЕЛЕНО                            КАК НаправлениеДеятельности,
	|	&Период                                 КАК ДатаОтраженияВУчете
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Возврат;
	ОтражениеРасхожденийПриИнкассацииДенежныхСредствЛокализация.ДобавитьКомандыПечати(КомандыПечати);

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
