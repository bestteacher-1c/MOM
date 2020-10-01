#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	
	ОписаниеСостава = ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта();
	ОписаниеСостава.ЗаполнятьФизическиеЛицаПоСотрудникам = Ложь;
	ОписаниеСостава.ИспользоватьКраткийСостав = Ложь;
	
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"СовмещающийСотрудник");
		
	ЗарплатаКадрыСоставДокументов.ДобавитьОписаниеХраненияСотрудниковФизическихЛиц(
		ОписаниеСостава.ОписаниеХраненияСотрудниковФизическихЛиц,
		,
		,
		"ОтсутствующийСотрудник");
	
	Возврат ОписаниеСостава;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.Совмещение);
	
КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Приказ на совмещение
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.Совмещение";
	КомандаПечати.Идентификатор = "ПФ_MXL_ПриказНаСовмещение";
	КомандаПечати.Представление = НСтр("ru = 'Приказ на совмещение'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Дополнительное соглашение
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь) Тогда
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Документ.Совмещение";
		КомандаПечати.Идентификатор = "ПФ_MXL_ДополнительноеСоглашение";
		КомандаПечати.Представление = НСтр("ru = 'Дополнительное соглашение'");
		КомандаПечати.Порядок = 20;
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
	КонецЕсли;

КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьПриказ = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ПриказНаСовмещение");
	
	Если НужноПечататьПриказ Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ПриказНаСовмещение",
			НСтр("ru = 'Приказ на совмещение'"), ПечатьПриказа(МассивОбъектов, ОбъектыПечати), ,
			"Документ.Совмещение.ПФ_MXL_ПриказНаСовмещение");
	КонецЕсли;
	
	НужноПечататьСоглашение = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ДополнительноеСоглашение");
	
	Если НужноПечататьСоглашение Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ДополнительноеСоглашение",
			НСтр("ru = 'Дополнительное соглашение'"), ПечатьСоглашения(МассивОбъектов, ОбъектыПечати), ,
			"Документ.Совмещение.ПФ_MXL_ДополнительноеСоглашение");
	КонецЕсли;
						
КонецПроцедуры								

Функция ПечатьСоглашения(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Совмещение_ДополнительноеСоглашение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Совмещение.ПФ_MXL_ДополнительноеСоглашение");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;	
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Верх = Макет.ПолучитьОбласть("Верх");
		Верх.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(Верх);
		
		Если ЗначениеЗаполнено(ДанныеПечати.Значение.ДатаОкончания) Тогда
			Срок = Макет.ПолучитьОбласть("Срок");
		Иначе
			Срок = Макет.ПолучитьОбласть("СрокСДатаНачала");
		КонецЕсли;
		
		Срок.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(Срок);
		
		
		Низ = Макет.ПолучитьОбласть("Низ");
		Низ.Параметры.Заполнить(ДанныеПечати.Значение);
		ТабличныйДокумент.Вывести(Низ);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции
	
Функция ПечатьПриказа(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Совмещение_ПриказНаСовмещение";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Совмещение.ПФ_MXL_ПриказНаСовмещение");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьСовмещениеПрофессийДолжностей = Макет.ПолучитьОбласть("ОснованиеСовмещениеПрофессийДолжностей");
	ОбластьИсполнениеОбязанностей = Макет.ПолучитьОбласть("ОснованиеИсполнениеОбязанностей");
	ОбластьУвеличениеОбъемаРабот = Макет.ПолучитьОбласть("ОснованиеУвеличениеОбъемаРабот");
	ОбластьПриказНачало = Макет.ПолучитьОбласть("ПриказНачало");
	ОбластьСрокДействия = Макет.ПолучитьОбласть("СрокДействия");
	ОбластьСрокДействияСДатаНачала = Макет.ПолучитьОбласть("СрокДействияСДатаНачала");
	ОбластьПриказОкончание = Макет.ПолучитьОбласть("ПриказОкончание");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьШапка.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьСовмещениеПрофессийДолжностей.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьИсполнениеОбязанностей.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьУвеличениеОбъемаРабот.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьПриказНачало.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьСрокДействия.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьСрокДействияСДатаНачала.Параметры.Заполнить(ДанныеПечати.Значение);
		ОбластьПриказОкончание.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		Если ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.СовмещениеПрофессийДолжностей Тогда
			ТабличныйДокумент.Вывести(ОбластьСовмещениеПрофессийДолжностей);
		ИначеЕсли ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.ИсполнениеОбязанностей Тогда
			ТабличныйДокумент.Вывести(ОбластьИсполнениеОбязанностей);
		ИначеЕсли ДанныеПечати.Значение.ПричинаСовмещения = Перечисления.ПричиныСовмещения.УвеличениеОбъемаРабот Тогда
			ТабличныйДокумент.Вывести(ОбластьУвеличениеОбъемаРабот);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПриказНачало);
		
		Если ЗначениеЗаполнено(ДанныеПечати.Значение.ДатаОкончания) Тогда
			ТабличныйДокумент.Вывести(ОбластьСрокДействия);
		Иначе
			ТабличныйДокумент.Вывести(ОбластьСрокДействияСДатаНачала);
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьПриказОкончание);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Совмещение.Ссылка,
	|	Совмещение.Номер,
	|	Совмещение.Дата,
	|	Совмещение.ПричинаСовмещения,
	|	Совмещение.Организация,
	|	Совмещение.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	|	Совмещение.СовмещающийСотрудник КАК СовмещающийСотрудник,
	|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо КАК СовмещающееФизическоеЛицо,
	|	Совмещение.ОтсутствующийСотрудник КАК ОтсутствующийСотрудник,
	|	Совмещение.ОтсутствующийСотрудник.ФизическоеЛицо КАК ОтсутствующееФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА Совмещение.СовмещаемаяДолжность ЕСТЬ NULL 
	|				ИЛИ Совмещение.ПричинаСовмещения <> ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.СовмещениеПрофессийДолжностей)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)
	|		ИНАЧЕ Совмещение.СовмещаемаяДолжность.Должность
	|	КОНЕЦ КАК СовмещаемаяДолжность,
	|	Совмещение.ДатаНачала,
	|	Совмещение.ДатаОкончания,
	|	Совмещение.РазмерДоплаты,
	|	Совмещение.Руководитель,
	|	Совмещение.ДолжностьРуководителя
	|ИЗ
	|	Документ.Совмещение КАК Совмещение
	|ГДЕ
	|	Совмещение.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ДокументДляПечати Из РезультатыЗапроса Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДокументДляПечати);
		ДанныеПечати.Вставить("ФИОРуководителяСокращенное", Строка(ДанныеПечати.Руководитель));
		ДанныеПечати.Вставить("ФИОРуководителяСклоняемое", Строка(ДанныеПечати.Руководитель));
		ДанныеПечати.Вставить("ДатаНачала", Формат(ДанныеПечати.ДатаНачала, "ДЛФ=DD"));
		ДанныеПечати.Вставить("ДатаОкончания", Формат(ДанныеПечати.ДатаОкончания, "ДЛФ=DD"));
		ДанныеПечати.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=D");
		
		// Подготовка номера документа.
		ДанныеПечати.Номер = КадровыйУчетРасширенный.НомерКадровогоПриказа(ДанныеПечати.Номер);
		
		Если ЗначениеЗаполнено(ДанныеПечати.Руководитель) Тогда
			
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПечати.Руководитель), 
				"Фамилия, Имя, Отчество, Пол", ДокументДляПечати.Дата);
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				
				ДанныеФИО = Новый Структура("Фамилия,Имя,Отчество");
				ЗаполнитьЗначенияСвойств(ДанныеФИО, ДанныеФизическогоЛица[0]);
				
				ДанныеПечати.ФИОРуководителяСокращенное = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ДанныеФИО);
				
				Если ДанныеФизическогоЛица[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
					ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующего'"));
				Иначе
					ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующей'"));
				КонецЕсли;
				
				ФизическиеЛицаЗарплатаКадры.Просклонять(ДанныеПечати.ФИОРуководителяСклоняемое,
					2, ДанныеПечати.ФИОРуководителяСклоняемое, ДанныеФизическогоЛица[0].Пол, ДанныеФизическогоЛица[0].ФизическоеЛицо);
				
			КонецЕсли;
		КонецЕсли;
		
		// Юридический адрес организации.
		ДанныеПечати.Вставить("АдресОрганизации", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ДанныеПечати.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
			ДокументДляПечати.Дата));
		
		// Данные совмещающего сотрудника.
		ДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.СовмещающийСотрудник), 
			"ТрудовойДоговорНомер, ТрудовойДоговорДата, Должность,ФИОПолные, Пол, АдресПоПрописке, ДокументВид, ДокументСерия, ДокументНомер", ДокументДляПечати.Дата);
		
		Если ДанныеСотрудника.Количество() > 0 Тогда
				
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(
					ДанныеСотрудника[0].АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			АдресПоПрописке = "";
			УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, АдресПоПрописке);
			
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудника", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаСокращенное", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаРодительный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаДательный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИОСовмещающегоСотрудникаТворительный", ДанныеСотрудника[0].ФИОПолные);
			ДанныеПечати.Вставить("АдресСотрудника", АдресПоПрописке);
			ДанныеПечати.Вставить("ДокументВид", ДанныеСотрудника[0].ДокументВид);
			ДанныеПечати.Вставить("ДокументСерия", ДанныеСотрудника[0].ДокументСерия);
			ДанныеПечати.Вставить("ДокументНомер", ДанныеСотрудника[0].ДокументНомер);
			
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаРодительный),
				2, ДанныеПечати.ФИОСовмещающегоСотрудникаРодительный, ДанныеСотрудника[0].Пол, ДанныеСотрудника[0].ФизическоеЛицо);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаДательный),
				3, ДанныеПечати.ФИОСовмещающегоСотрудникаДательный, ДанныеСотрудника[0].Пол, ДанныеСотрудника[0].ФизическоеЛицо);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИОСовмещающегоСотрудникаТворительный),
				5, ДанныеПечати.ФИОСовмещающегоСотрудникаТворительный, ДанныеСотрудника[0].Пол, ДанныеСотрудника[0].ФизическоеЛицо);
			
			ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное = ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное);
			
			Если ДанныеСотрудника[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ДанныеПечати.Вставить("Именуемый", НСтр("ru = 'именуемый'"));
				ДанныеПечати.Вставить("Занимающий", НСтр("ru = 'занимающий'"));
			Иначе
				ДанныеПечати.Вставить("Именуемый", НСтр("ru = 'именуемая'"));
				ДанныеПечати.Вставить("Занимающий", НСтр("ru = 'занимающая'"));
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДанныеСотрудника.Количество() > 0 Тогда
			ДанныеПечати.Вставить("НомерДоговора", ДанныеСотрудника[0].ТрудовойДоговорНомер);
			ДанныеПечати.Вставить("ДатаДоговора", Формат(ДанныеСотрудника[0].ТрудовойДоговорДата, "ДЛФ=D"));
			ДанныеПечати.Вставить("ДатаДоговораПолная", Формат(ДанныеСотрудника[0].ТрудовойДоговорДата, "ДЛФ=DD"));
			ДанныеПечати.Вставить("ДолжностьСовмещающегоСотрудника", ДанныеСотрудника[0].Должность);
		КонецЕсли;
		
		// Данные отсутствующего сотрудника.
		ДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ОтсутствующийСотрудник), 
			"Должность", ДокументДляПечати.Дата);
		
		Если ДокументДляПечати.ПричинаСовмещения = Перечисления.ПричиныСовмещения.СовмещениеПрофессийДолжностей Тогда
			ДанныеПечати.Вставить("ДолжностьОтсутствующегоСотрудника", ДокументДляПечати.СовмещаемаяДолжность);
		ИначеЕсли ДанныеСотрудника.Количество() > 0 Тогда
			ДанныеПечати.Вставить("ДолжностьОтсутствующегоСотрудника", ДанныеСотрудника[0].Должность);
		КонецЕсли;
		
		// Данные отсутствующего физического лица.
		ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ОтсутствующееФизическоеЛицо), 
			"ФИОПолные,Пол", ДокументДляПечати.Дата);
		
		Если ДанныеФизическогоЛица.Количество() > 0 Тогда				
			ДанныеПечати.Вставить("ФИООтсутствующегоСотрудника", ДанныеФизическогоЛица[0].ФИОПолные);
			ДанныеПечати.Вставить("ФИООтсутствующегоСотрудникаРодительный", ДанныеФизическогоЛица[0].ФИОПолные);
			ФизическиеЛицаЗарплатаКадры.Просклонять(Строка(ДанныеПечати.ФИООтсутствующегоСотрудникаРодительный),
				2, ДанныеПечати.ФИООтсутствующегоСотрудникаРодительный, ДанныеФизическогоЛица[0].Пол, ДанныеФизическогоЛица[0].ФизическоеЛицо);
		КонецЕсли;
		
		// Сумма договора и валюта
		ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		СуммаПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДокументДляПечати.РазмерДоплаты, ВалютаУчета);
		ДанныеПечати.Вставить("НаименованиеВалюты", ВалютаУчета);
		ДанныеПечати.Вставить("РазмерДоплатыПрописью", СуммаПрописью);
		
		// Приведение значений к требуемому формату.
		Если Не ДанныеПечати.Свойство("ДолжностьСовмещающегоСотрудника") Тогда
			ДанныеПечати.Вставить("ДолжностьСовмещающегоСотрудника", "________________________");
		ИначеЕсли Не ЗначениеЗаполнено(ДанныеПечати.ДолжностьСовмещающегоСотрудника) Тогда
			ДанныеПечати.ДолжностьСовмещающегоСотрудника =  "________________________";
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеПечати.ФИОРуководителяСклоняемое) Тогда
			ДанныеПечати.ФИОРуководителяСклоняемое =  "__________________________________";
		КонецЕсли;
		
		Если Не ДанныеПечати.Свойство("Именуемый") Тогда
			ДанныеПечати.Вставить("Именуемый", НСтр("ru = 'именуемый(ая)'"));
		КонецЕсли;
		Если Не ДанныеПечати.Свойство("Занимающий") Тогда
			ДанныеПечати.Вставить("Занимающий", НСтр("ru = 'занимающим(ей)'"));
		КонецЕсли;
		Если Не ДанныеПечати.Свойство("Действующего") Тогда
			ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующего(ей)'"));
		КонецЕсли;
		Если ВалютаУчета = Справочники.Валюты.НайтиПоКоду("643") Тогда
			ДанныеПечати.НаименованиеВалюты = "руб.";
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное) Тогда
			ДанныеПечати.ФИОСовмещающегоСотрудникаСокращенное = "_________________";
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(ДанныеПечати.ФИОРуководителяСокращенное) Тогда
			ДанныеПечати.ФИОРуководителяСокращенное = "_________________";
		КонецЕсли; 
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(ДокументДляПечати.Ссылка, ДанныеПечати);
		
	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

#КонецОбласти

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 

	ФизическоеЛицо = ?(ЗначениеЗаполнено(Объект.СовмещающийСотрудник), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СовмещающийСотрудник, "ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 

	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'совмещение'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'совмещения'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "СовмещающийСотрудник";
	ОписаниеДокумента.ИмяРеквизитаОтсутствующийСотрудник = "ОтсутствующийСотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаНачала";
	ОписаниеДокумента.ИмяРеквизитаДатаОкончанияСобытия	 = "ДатаОкончания";
	
	Возврат ОписаниеДокумента;

КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента, "ДатаНачала");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	Совмещение.Ссылка КАК Ссылка,
		|	Совмещение.Дата КАК Дата
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|ГДЕ
		|	Совмещение.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Совмещение.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Процедура ЗаполнитьДвиженияЗанятостьПозицийШтатногоРасписания(ПараметрыОбновления = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	Совмещение.СовмещающийСотрудник КАК Сотрудник,
		|	Совмещение.СовмещающийСотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	Совмещение.СовмещающийСотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Совмещение.СовмещаемаяДолжность КАК ПозицияШтатногоРасписания,
		|	Совмещение.ОтсутствующийСотрудник КАК ЗамещаемыйСотрудник,
		|	Совмещение.Ссылка КАК Регистратор,
		|	Совмещение.ДатаНачала КАК Начало,
		|	Совмещение.ДатаОкончания КАК Окончание,
		|	Совмещение.ИсправленныйДокумент КАК ИсправленныйДокумент,
		|	Совмещение.КоличествоСтавок КАК КоличествоСтавок,
		|	Совмещение.ПричинаСовмещения КАК ПричинаСовмещения
		|ПОМЕСТИТЬ ВТДанныеСовмещенийПредварительно
		|ИЗ
		|	Документ.Совмещение КАК Совмещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписания КАК ЗанятостьПозицийШтатногоРасписания
		|		ПО Совмещение.Ссылка = ЗанятостьПозицийШтатногоРасписания.Регистратор
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр КАК ЗанятостьПозицийШтатногоРасписанияИспр
		|		ПО Совмещение.Ссылка = ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение
		|ГДЕ
		|	Совмещение.Проведен
		|	И ЗанятостьПозицийШтатногоРасписания.Регистратор ЕСТЬ NULL
		|	И ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДанныеСовмещений.Сотрудник КАК Сотрудник
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений";
	
	Если ПараметрыОбновления = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1000", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
		Возврат;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПродолжитьОбработчик(ПараметрыОбновления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеСовмещений.ЗамещаемыйСотрудник КАК Сотрудник,
		|	ДанныеСовмещений.Начало КАК Период
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений
		|ГДЕ
		|	ДанныеСовмещений.ПричинаСовмещения = ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.ИсполнениеОбязанностей)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеСовмещений.Сотрудник,
		|	ДанныеСовмещений.Начало
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений
		|ГДЕ
		|	ДанныеСовмещений.ПричинаСовмещения = ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.УвеличениеОбъемаРабот)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	СотрудникиПериоды.Сотрудник КАК Сотрудник
		|ИЗ
		|	ВТСотрудникиПериоды КАК СотрудникиПериоды";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
			|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК Сотрудник,
			|	ЗНАЧЕНИЕ(Справочник.ШтатноеРасписание.ПустаяСсылка) КАК ДолжностьПоШтатномуРасписанию,
			|	1 КАК КоличествоСтавок
			|ПОМЕСТИТЬ ВТКадровыеДанныеСотрудников
			|ГДЕ
			|	ЛОЖЬ";
		
		Запрос.Выполнить();
		
	Иначе
		
		ОписательТаблиц = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			Запрос.МенеджерВременныхТаблиц, "ВТСотрудникиПериоды");
		
		КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
			ОписательТаблиц,
			Ложь,
			"ДолжностьПоШтатномуРасписанию,КоличествоСтавок");
		
	КонецЕсли;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеСовмещений.Начало КАК Начало,
		|	ДанныеСовмещений.Регистратор КАК Регистратор,
		|	ДанныеСовмещений.Сотрудник КАК Сотрудник,
		|	ДанныеСовмещений.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ДанныеСовмещений.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеСовмещений.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ВЫБОР
		|		КОГДА ДанныеСовмещений.КоличествоСтавок = 0
		|			ТОГДА 1
		|		ИНАЧЕ ДанныеСовмещений.КоличествоСтавок
		|	КОНЕЦ КАК КоличествоСтавок,
		|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка) КАК ЗамещаемыйСотрудник,
		|	ДанныеСовмещений.Окончание КАК Окончание,
		|	ДанныеСовмещений.ИсправленныйДокумент КАК ИсправленныйДокумент,
		|	ДанныеСовмещений.ПричинаСовмещения КАК ПричинаСовмещения
		|ПОМЕСТИТЬ ВТДанныеСовмещений
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений
		|ГДЕ
		|	ДанныеСовмещений.ПричинаСовмещения = ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.СовмещениеПрофессийДолжностей)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеСовмещений.Начало,
		|	ДанныеСовмещений.Регистратор,
		|	ДанныеСовмещений.Сотрудник,
		|	ДанныеСовмещений.ГоловнаяОрганизация,
		|	ДанныеСовмещений.ФизическоеЛицо,
		|	КадровыеДанныеСотрудников.ДолжностьПоШтатномуРасписанию,
		|	ДанныеСовмещений.КоличествоСтавок,
		|	ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка),
		|	ДанныеСовмещений.Окончание,
		|	ДанныеСовмещений.ИсправленныйДокумент,
		|	ДанныеСовмещений.ПричинаСовмещения
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеСовмещений.Начало = КадровыеДанныеСотрудников.Период
		|			И ДанныеСовмещений.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|ГДЕ
		|	ДанныеСовмещений.ПричинаСовмещения = ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.УвеличениеОбъемаРабот)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеСовмещений.Начало,
		|	ДанныеСовмещений.Регистратор,
		|	ДанныеСовмещений.Сотрудник,
		|	ДанныеСовмещений.ГоловнаяОрганизация,
		|	ДанныеСовмещений.ФизическоеЛицо,
		|	КадровыеДанныеСотрудников.ДолжностьПоШтатномуРасписанию,
		|	КадровыеДанныеСотрудников.КоличествоСтавок,
		|	ДанныеСовмещений.ЗамещаемыйСотрудник,
		|	ДанныеСовмещений.Окончание,
		|	ДанныеСовмещений.ИсправленныйДокумент,
		|	ДанныеСовмещений.ПричинаСовмещения
		|ИЗ
		|	ВТДанныеСовмещенийПредварительно КАК ДанныеСовмещений
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
		|		ПО ДанныеСовмещений.Начало = КадровыеДанныеСотрудников.Период
		|			И ДанныеСовмещений.ЗамещаемыйСотрудник = КадровыеДанныеСотрудников.Сотрудник
		|ГДЕ
		|	ДанныеСовмещений.ПричинаСовмещения = ЗНАЧЕНИЕ(Перечисление.ПричиныСовмещения.ИсполнениеОбязанностей)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДанныеСовмещений.Начало КАК Период,
		|	ДанныеСовмещений.Регистратор КАК Регистратор,
		|	ДанныеСовмещений.Сотрудник КАК Сотрудник,
		|	ДанныеСовмещений.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ДанныеСовмещений.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеСовмещений.Регистратор КАК ДокументОснование,
		|	ДанныеСовмещений.ПозицияШтатногоРасписания КАК ПозицияШтатногоРасписания,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыЗанятостиПозицийШтатногоРасписания.Совмещена) КАК ВидЗанятостиПозиции,
		|	ДанныеСовмещений.КоличествоСтавок КАК КоличествоСтавок,
		|	ВЫБОР
		|		КОГДА ДанныеСовмещений.Окончание = ДАТАВРЕМЯ(1, 1, 1)
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДанныеСовмещений.Окончание, ДЕНЬ, 1)
		|	КОНЕЦ КАК ДействуетДо,
		|	ДанныеСовмещений.ЗамещаемыйСотрудник КАК ЗамещаемыйСотрудник,
		|	ВЫБОР
		|		КОГДА ДанныеСовмещенийИсправленные.ИсправленныйДокумент ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ИсправленныеДвижения,
		|	ДанныеСовмещенийИсправленные.Регистратор КАК РегистраторИзмерение,
		|	ДанныеСовмещений.ПричинаСовмещения КАК ПричинаСовмещения
		|ИЗ
		|	ВТДанныеСовмещений КАК ДанныеСовмещений
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеСовмещений КАК ДанныеСовмещенийИсправленные
		|		ПО ДанныеСовмещений.Регистратор = ДанныеСовмещенийИсправленные.ИсправленныйДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр КАК ЗанятостьПозицийШтатногоРасписанияИспр
		|		ПО ДанныеСовмещений.Регистратор = ЗанятостьПозицийШтатногоРасписанияИспр.РегистраторИзмерение
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбработчик(ПараметрыОбновления);
	Иначе
		
		МассивРегистраторов = Новый Массив;
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПродолжитьОбработчик(ПараметрыОбновления);
		
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
			
			НачатьТранзакцию();
			
			Если ПараметрыОбновления <> Неопределено Тогда
				
				Блокировка = Новый БлокировкаДанных;
				
				Если Выборка.ИсправленныеДвижения Тогда
					ИмяПространстваБлокировки = "РегистрСведений.ЗанятостьПозицийШтатногоРасписанияИспр";
					ПолеБлокировки = "РегистраторИзмерение";
				Иначе
					ИмяПространстваБлокировки = "РегистрСведений.ЗанятостьПозицийШтатногоРасписания.НаборЗаписей";
					ПолеБлокировки = "Регистратор";
				КонецЕсли;
				
				ЭлементБлокировки = Блокировка.Добавить(ИмяПространстваБлокировки);
				ЭлементБлокировки.УстановитьЗначение(ПолеБлокировки, Выборка[ПолеБлокировки]);
				
				ЭлементБлокировки = Блокировка.Добавить("Документ.Совмещение");
				ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Регистратор);
				
				Попытка 
					Блокировка.Заблокировать();
				Исключение
					ОтменитьТранзакцию();
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы.Ошибка блокировки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
						УровеньЖурналаРегистрации.Предупреждение, , Выборка.Регистратор, НСтр("ru='РегистрСведений.ЗанятостьПозицийШтатногоРасписания'"));
					Продолжить;
				КонецПопытки;
				
			КонецЕсли;
			
			Если Выборка.ИсправленныеДвижения Тогда
				
				НаборЗаписей = РегистрыСведений.ЗанятостьПозицийШтатногоРасписанияИспр.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.РегистраторИзмерение.Установить(Выборка.РегистраторИзмерение);
				
			Иначе
				
				МассивРегистраторов.Добавить(Выборка.Регистратор);
				
				НаборЗаписей = РегистрыСведений.ЗанятостьПозицийШтатногоРасписания.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
				
			КонецЕсли;
			
			Пока Выборка.Следующий() Цикл
				
				Запись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(Запись, Выборка);
				
				Если Выборка.ИсправленныеДвижения Тогда
					Запись.ПериодИзмерение = Выборка.Период;
				КонецЕсли;
				
			КонецЦикла;
			
			НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ОбъектДокумента = Выборка.Регистратор.ПолучитьОбъект();
			ОбъектДокумента.КоличествоСтавок = Выборка.КоличествоСтавок;
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента, , , РежимЗаписиДокумента.Запись);
			
			ЗафиксироватьТранзакцию();
			
		КонецЦикла;
		
		РегистрыСведений.ЗанятостьПозицийШтатногоРасписания.СформироватьДвиженияИнтервальногоРегистраПоМассивуРегистраторов(
			МассивРегистраторов, ПараметрыОбновления);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли