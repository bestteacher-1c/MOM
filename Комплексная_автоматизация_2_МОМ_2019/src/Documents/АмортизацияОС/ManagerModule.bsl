#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
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

// Метод создает документы Амортизации ОС в указанном месяце.
//
// Параметры:
// 		Месяц - Дата - Начало месяца, в котором необходимо создать документы амортизации.
// 		Организация - Массив - Список организаций по которым формируются документы.
// 		Отказ - Булево - Используется при вызове из формы закрытия месяца. При установке в "Истина" - дальнейшие операции выполняться не будут.
//
Процедура СоздатьДокументыАмортизацииОС(Месяц, Организация = Неопределено, Отказ = Ложь) Экспорт
	
	ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Начисление амортизации ОС'"));
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкаАмортизации.Организация
	|ПОМЕСТИТЬ НачислениеАмортизации
	|ИЗ
	|	РегистрСведений.НачислениеАмортизацииОСБухгалтерскийУчет.СрезПоследних(
	|			&КонецПериода,
	|			Организация В (&Организация)) КАК НастройкаАмортизации
	|ГДЕ
	|	НастройкаАмортизации.НачислятьАмортизацию
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаАмортизации.Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.Проведен, ЛОЖЬ) = ИСТИНА
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаПроведен,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.Проведен, НЕОПРЕДЕЛЕНО) = ЛОЖЬ
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаНеПроведен,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ЕСТЬNULL(АмортизацияОС.ПометкаУдаления, ЛОЖЬ) = ИСТИНА
	|				ТОГДА АмортизацияОС.Ссылка
	|			ИНАЧЕ ЗНАЧЕНИЕ(Документ.АмортизацияОС.ПустаяСсылка)
	|		КОНЕЦ) КАК СсылкаУдален
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ НачислениеАмортизации КАК НачислениеАмортизации
	|		ПО (НачислениеАмортизации.Организация = Организации.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.АмортизацияОС КАК АмортизацияОС
	|		ПО Организации.Ссылка = АмортизацияОС.Организация
	|			И (АмортизацияОС.Дата >= &НачалоПериода)
	|			И (АмортизацияОС.Дата <= &КонецПериода)
	|ГДЕ
	|	Организации.Ссылка В (&Организация)
	|	И НЕ НачислениеАмортизации.Организация ЕСТЬ NULL
	|
	|СГРУППИРОВАТЬ ПО
	|	Организации.Ссылка,
	|	НЕ НачислениеАмортизации.Организация ЕСТЬ NULL";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Месяц));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Месяц));
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.СсылкаПроведен.Пустая()
			И Выборка.СсылкаНеПроведен.Пустая()
			И Выборка.СсылкаУдален.Пустая() Тогда
			
			ДокументОбъект = Документы.АмортизацияОС.СоздатьДокумент();
			
		ИначеЕсли НЕ Выборка.СсылкаПроведен.Пустая() Тогда
			
			ДокументОбъект = Выборка.СсылкаПроведен.ПолучитьОбъект();
			
		ИначеЕсли НЕ Выборка.СсылкаНеПроведен.Пустая() Тогда
			
			ДокументОбъект = Выборка.СсылкаНеПроведен.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			
		Иначе
			
			ДокументОбъект = Выборка.СсылкаУдален.ПолучитьОбъект();
			ДокументОбъект.ПометкаУдаления = Ложь;
			
		КонецЕсли; 
		
		ДокументОбъект.Организация = Выборка.Организация;
		ДокументОбъект.Дата = КонецМесяца(Месяц);
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
		
		Попытка
		
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		Исключение
			
			ТекстОшибки = НСтр("ru = 'Не удалось провести документ ""Амортизация ОС"" за %1.
                                |Чтобы получить более подробное описание ошибки необходимо провести документ вручную.'");
			
			ТекстОшибки = СтрШаблон(ТекстОшибки, Формат(КонецМесяца(Месяц), "ДЛФ=D"));
			
			ВнеоборотныеАктивыСлужебный.ЗарегистрироватьПроблемуВыполненияРасчета(
				Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииОС,
				Месяц,
				Выборка.Организация, 
				ТекстОшибки,,,
				Отказ);
			
		КонецПопытки; 
		
	КонецЦикла;
	
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
	
	ПолноеИмяДокумента = "Документ.АмортизацияОС";
	
	ВЗапросеЕстьИсточник = Истина;
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	ПереопределениеРасчетаПараметров.Вставить("Период", "КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)");
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		ВЗапросеЕстьИсточник = Ложь;
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	Если Регистры = Неопределено Тогда
		ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(НСтр("ru = 'Амортизация и износ основных средств'"));
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	ТекстыЗапроса = Новый СписокЗначений;
	УчетОСВызовСервера.ПрочиеРасходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПартииПрочихРасходов(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПрочиеДоходы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПрочиеАктивыПассивы(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ПорядокОтраженияПрочихОпераций(ТекстыЗапроса, Регистры);
	УчетОСВызовСервера.ОтражениеДокументовВРеглУчете(ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ) КАК Период,
	|	ДанныеДокумента.Ссылка           КАК Ссылка,
	|	ДанныеДокумента.Организация      КАК Организация,
	|	ДанныеДокумента.Номер            КАК Номер,
	|	ДанныеДокумента.Проведен         КАК Проведен,
	|	ДанныеДокумента.ПометкаУдаления  КАК ПометкаУдаления,
	|	ДанныеДокумента.Комментарий      КАК Комментарий,
	|	ДанныеДокумента.Ответственный    КАК Ответственный
	|ИЗ
	|	Документ.АмортизацияОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	УчетОСВызовСервера.ИнициализироватьПараметрыЗапросаПриОтраженииАмортизации(Запрос, ДополнительныеСвойства);
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Граница", Новый Граница(НачалоМесяца(Реквизиты.Период), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("КонецМесяца", Новый Граница(КонецМесяца(Реквизиты.Период), ВидГраницы.Включая));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
	РасчетСебестоимостиПрикладныеАлгоритмы.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.АмортизацияОС"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация",  Перечисления.ХозяйственныеОперации.АмортизацияОС);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Функция ТекстЗапросаТаблицаРеестрДокументов(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	&Период  КАК ДатаОтраженияВУчете";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстОтраженияВРеглУчете() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстОтраженияВРеглУчетеНачисленнойАмортизации();
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	Возврат УчетОСВызовСервера.ТекстЗапросаВТОтраженияВРеглУчетеНачисленнойАмортизации("АмортизацияОС") + ";";
	
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

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации)
	
	ВходящиеДанные = Новый Соответствие;
	
	УчетОСВызовСервера.ЗаполнитьВходящиеДанныеАмортизации(ВходящиеДанные);
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
