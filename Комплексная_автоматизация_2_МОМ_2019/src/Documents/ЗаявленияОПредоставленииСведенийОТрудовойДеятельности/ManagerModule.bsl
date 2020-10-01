#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.Сотрудник, NULL КАК ИСТИНА)
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
	
	МетаданныеДокумента = Метаданные.Документы.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведенияДокумента(СсылкаНаДокумент) Экспорт
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", СсылкаНаДокумент);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Заявление.Ссылка.Дата КАК Период,
		|	Заявление.Ссылка.Организация КАК Организация,
		|	Заявление.Сотрудник КАК ФизическоеЛицо,
		|	МАКСИМУМ(Заявление.ВидЗаявления) КАК ВидЗаявления,
		|	Заявление.Ссылка КАК Заявление,
		|	МАКСИМУМ(Заявление.НомерСтроки) КАК НомерСтроки
		|ИЗ
		|	Документ.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.Сотрудники КАК Заявление
		|ГДЕ
		|	Заявление.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	Заявление.Сотрудник,
		|	Заявление.Ссылка.Дата,
		|	Заявление.Ссылка.Организация,
		|	Заявление.Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	ДанныеДляПроведения.Вставить("ЗаявленияОВеденииТрудовыхКнижек", Запрос.Выполнить().Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#Область ПроцедурыИФункцииПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ЗаявленияОПредоставленииСведенийОТрудовойДеятельности";
	КомандаПечати.Представление = НСтр("ru = 'Заявление'");
	КомандаПечати.Порядок = 10;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЗаявленияОПредоставленииСведенийОТрудовойДеятельности") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ПФ_MXL_ЗаявленияОПредоставленииСведенийОТрудовойДеятельности", 
			"Заявление о предоставлении сведений о трудовой деятельности", 
			ПечатнаяФормаПредоставленииСведенийОТрудовойДеятельности(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатнаяФормаПредоставленииСведенийОТрудовойДеятельности(МассивОбъектов, ОбъектыПечати)
	
	ВыборкаПоДокументам = ЗапросПоСотрудникамДляПечати(МассивОбъектов).Выбрать();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.ПФ_MXL_ЗаявленияОПредоставленииСведенийОТрудовойДеятельности");
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаявленияОПредоставленииСведенийОТрудовойДеятельности";
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ЭтоПервыйДокументКоллекции = Истина;
	
	Пока ВыборкаПоДокументам.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		НомерСтрокиНачало = ДокументРезультат.ВысотаТаблицы + 1;
		
		Пока ВыборкаПоДокументам.Следующий() Цикл
			
			Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
				ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ОбластьЗаявлений = Макет.ПолучитьОбласть("Бланк");
			ЗаполнитьЗначенияСвойств(ОбластьЗаявлений.Параметры, ВыборкаПоДокументам);
			ОбластьЗаявлений.Параметры.Номер = ЗарплатаКадрыОтчеты.НомерНаПечать(ОбластьЗаявлений.Параметры.Номер);
			
			ПараметрыЗаполнения = Новый Структура;
			ПараметрыЗаполнения.Вставить("Обращение", ?(ВыборкаПоДокументам.Пол = 2, НСтр("ru = 'Уважаемая'"), НСтр("ru = 'Уважаемый'")));
			ПараметрыЗаполнения.Вставить("ИмяОтчество",
				Сред(ВыборкаПоДокументам.ФИОСотрудника, СтрДлина(ВыборкаПоДокументам.СотрудникФамилия) + 2));
			
			ПараметрыЗаполнения.Вставить("ДолжностьСотрудникаВДательномПадеже", ВыборкаПоДокументам.ДолжностьНаименование);
			ПараметрыЗаполнения.Вставить("ФИОПолныеВДательномПадеже", ВыборкаПоДокументам.ФИОСотрудника);
			ПараметрыЗаполнения.Вставить("ДолжностьРуководителяВДательномПадеже", ВыборкаПоДокументам.ДолжностьРуководителяНаименование);
			ПараметрыЗаполнения.Вставить("ФИОРуководителяВДательномПадеже", ВыборкаПоДокументам.ФИОРуководителя);
			ПараметрыЗаполнения.Вставить("ФИОПолныеВРодительномПадеже", ВыборкаПоДокументам.ФИОСотрудника);
			
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.СклонениеПредставленийОбъектов") Тогда
				
				МодульСклонениеПредставленийОбъектов = ОбщегоНазначения.ОбщийМодуль("СклонениеПредставленийОбъектов");
				
				ДолжностьСотрудникаВДательномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьПредставление(
					ПараметрыЗаполнения.ДолжностьСотрудникаВДательномПадеже, 3, ВыборкаПоДокументам.Должность);
				
				Если ЗначениеЗаполнено(ДолжностьСотрудникаВДательномПадеже) Тогда
					ПараметрыЗаполнения.Вставить("ДолжностьСотрудникаВДательномПадеже", ДолжностьСотрудникаВДательномПадеже);
				КонецЕсли;
				
				ФИОПолныеВДательномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьФИО(
					ВыборкаПоДокументам.ФИОСотрудника, 3, ВыборкаПоДокументам.ФизическоеЛицо, ВыборкаПоДокументам.Пол);
				
				Если ЗначениеЗаполнено(ФИОПолныеВДательномПадеже)Тогда
					ПараметрыЗаполнения.Вставить("ФИОПолныеВДательномПадеже", ФИОПолныеВДательномПадеже);
				КонецЕсли;
				
				ДолжностьРуководителяВДательномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьПредставление(
					ПараметрыЗаполнения.ДолжностьРуководителяВДательномПадеже, 3, ВыборкаПоДокументам.ДолжностьРуководителя);
				
				Если ЗначениеЗаполнено(ДолжностьРуководителяВДательномПадеже) Тогда
					ПараметрыЗаполнения.Вставить("ДолжностьРуководителяВДательномПадеже", ДолжностьРуководителяВДательномПадеже);
				КонецЕсли;
				
				ФИОРуководителяВДательномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьФИО(
					ВыборкаПоДокументам.ФИОРуководителя, 3, ВыборкаПоДокументам.Руководитель,
						?(ВыборкаПоДокументам.ПолРуководителя = Перечисления.ПолФизическогоЛица.Женский, 2, 1));
				
				Если ЗначениеЗаполнено(ФИОРуководителяВДательномПадеже)Тогда
					ПараметрыЗаполнения.Вставить("ФИОРуководителяВДательномПадеже", ФИОРуководителяВДательномПадеже);
				КонецЕсли;
				
				ФИОПолныеВРодительномПадеже = МодульСклонениеПредставленийОбъектов.ПросклонятьФИО(
					ВыборкаПоДокументам.ФИОСотрудника, 2, ВыборкаПоДокументам.ФизическоеЛицо, ВыборкаПоДокументам.Пол);
				
				Если ЗначениеЗаполнено(ФИОПолныеВРодительномПадеже)Тогда
					ПараметрыЗаполнения.Вставить("ФИОПолныеВРодительномПадеже", ФИОПолныеВРодительномПадеже);
				КонецЕсли;
				
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ОбластьЗаявлений.Параметры, ПараметрыЗаполнения);
			
			ДокументРезультат.Вывести(ОбластьЗаявлений);
			
		КонецЦикла;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	Возврат ДокументРезультат;
	
КонецФункции

Функция ЗапросПоСотрудникамДляПечати(МассивСсылок) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Ссылка,
		|	Сотрудники.Ссылка.Организация КАК Организация,
		|	Сотрудники.Ссылка.Номер КАК Номер,
		|	Сотрудники.Ссылка.Дата КАК Дата,
		|	Сотрудники.Ссылка.Дата КАК Период,
		|	Сотрудники.Ссылка.Руководитель КАК Руководитель,
		|	Сотрудники.Ссылка.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|	Сотрудники.НомерСтроки КАК НомерСтроки,
		|	Сотрудники.Сотрудник КАК ФизическоеЛицо,
		|	ВЫБОР
		|		КОГДА Сотрудники.Сотрудник.Пол = ЗНАЧЕНИЕ(Перечисление.ПолФизическогоЛица.Мужской)
		|			ТОГДА 1
		|		ИНАЧЕ 2
		|	КОНЕЦ КАК Пол,
		|	Сотрудники.ВидЗаявления КАК ВидЗаявления,
		|	ОсновныеСотрудникиФизическихЛиц.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.ЗаявленияОПредоставленииСведенийОТрудовойДеятельности.Сотрудники КАК Сотрудники
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСотрудникиФизическихЛиц КАК ОсновныеСотрудникиФизическихЛиц
		|		ПО Сотрудники.Сотрудник = ОсновныеСотрудникиФизическихЛиц.ФизическоеЛицо
		|			И Сотрудники.Ссылка.Организация.ГоловнаяОрганизация = ОсновныеСотрудникиФизическихЛиц.ГоловнаяОрганизация
		|			И (Сотрудники.Ссылка.Дата МЕЖДУ ОсновныеСотрудникиФизическихЛиц.ДатаНачала И ОсновныеСотрудникиФизическихЛиц.ДатаОкончания)
		|ГДЕ
		|	Сотрудники.Ссылка В(&МассивСсылок)";
	
	Запрос.Выполнить();
	
	ИменаПолейОтветственныхЛиц = Новый Массив;
	ИменаПолейОтветственныхЛиц.Добавить("Руководитель");
	
	ЗарплатаКадры.СоздатьВТФИООтветственныхЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ИменаПолейОтветственныхЛиц, "ВТДанныеДокументов");
	
	Описатель = КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
		Запрос.МенеджерВременныхТаблиц, "ВТДанныеДокументов", "Сотрудник,Период");
	
	Описатель.ИмяВТКадровыеДанныеСотрудников = "ВТКадровыеДанныеСотрудниковДляЗаявления";
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(Описатель, Истина, "Должность,ФИОПолные,ИОФамилия,Фамилия");
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДокументов.Ссылка КАК Ссылка,
		|	ДанныеДокументов.Организация КАК Организация,
		|	ВЫРАЗИТЬ(ДанныеДокументов.Организация КАК Справочник.Организации).НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ВЫРАЗИТЬ(ДанныеДокументов.Организация КАК Справочник.Организации).НаименованиеСокращенное КАК ОрганизацияНаименованиеСокращенное,
		|	ДанныеДокументов.Номер КАК Номер,
		|	ДанныеДокументов.Дата КАК Дата,
		|	ДанныеДокументов.Руководитель КАК Руководитель,
		|	ЕСТЬNULL(ФИОПоследние.ФИОПолные, """") КАК ФИОРуководителя,
		|	ЕСТЬNULL(ФИОПоследние.РасшифровкаПодписи, """") КАК РуководительРасшифровкаПодписи,
		|	ЕСТЬNULL(ФИОПоследние.Пол, НЕОПРЕДЕЛЕНО) КАК ПолРуководителя,
		|	ДанныеДокументов.ДолжностьРуководителя КАК ДолжностьРуководителя,
		|	ДанныеДокументов.ДолжностьРуководителя.Наименование КАК ДолжностьРуководителяНаименование,
		|	ДанныеДокументов.НомерСтроки КАК НомерСтроки,
		|	ДанныеДокументов.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеДокументов.Пол КАК Пол,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ФИОПолные, """") КАК ФИОСотрудника,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.Фамилия, """") КАК СотрудникФамилия,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.ИОФамилия, """") КАК СотрудникРасшифровкаПодписи,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.Должность, """") КАК Должность,
		|	ЕСТЬNULL(КадровыеДанныеСотрудников.Должность.Наименование, """") КАК ДолжностьНаименование,
		|	ДанныеДокументов.ВидЗаявления КАК ВидЗаявления
		|ИЗ
		|	ВТДанныеДокументов КАК ДанныеДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФИООтветственныхЛиц КАК ФИОПоследние
		|		ПО ДанныеДокументов.Ссылка = ФИОПоследние.Ссылка
		|			И ДанныеДокументов.Руководитель = ФИОПоследние.ФизическоеЛицо
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудниковДляЗаявления КАК КадровыеДанныеСотрудников
		|		ПО ДанныеДокументов.Период = КадровыеДанныеСотрудников.Период
		|			И ДанныеДокументов.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка,
		|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли