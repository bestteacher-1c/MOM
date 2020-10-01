#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.УнифицированнаяФормаТ2) Тогда
		Справочники.Сотрудники.ДобавитьКомандуПечатиЛичнойКарточкиТ2(КомандыПечати);
	КонецЕсли;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаТ1) Тогда
		Справочники.Сотрудники.ДобавитьКомандуПечатиПриказаОПриеме(КомандыПечати);
	КонецЕсли;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаТ5) Тогда
		Справочники.Сотрудники.ДобавитьКомандуПечатиПриказаОПереводе(КомандыПечати);
	КонецЕсли;
	
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаТ8) Тогда
		Справочники.Сотрудники.ДобавитьКомандуПечатиПриказаОбУвольнении(КомандыПечати);
	КонецЕсли;
	
	Отчеты.ПечатнаяФормаСправкаОСреднемЗаработке.ДобавитьКомандуПечати(КомандыПечати);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		Если Пользователи.РолиДоступны("ДобавлениеИзменениеНалоговИВзносов,ЧтениеНалоговИВзносов", , Ложь) Тогда
			Справочники.Сотрудники.ДобавитьКомандуПечатиКарточкиУчетаСтраховыхВзносов(КомандыПечати);
			Справочники.Сотрудники.ДобавитьКомандуПечатиРегистраНалоговогоУчетаПоНДФЛ(КомандыПечати);
		КонецЕсли;
		
	КонецЕсли;
	
	Отчеты.ПечатнаяФормаТрудовойДоговорМикропредприятий.ДобавитьКомандуПечати(КомандыПечати);
	
	ДобавитьКомандуПечатиСправкиПоОтпускамСотрудника(КомандыПечати);
	ДобавитьКомандуПечатиСправкиОДоходахПроизвольнаяФорма(КомандыПечати);
	ДобавитьКомандуПечатиСправкиСМестаРаботы(КомандыПечати);
	
	Справочники.Сотрудники.ДобавитьКомандуПечатиСогласияНаОбработкуПерсональныхДанных(КомандыПечати);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ДобавитьКомандыПечатиСправочникуСотрудники(КомандыПечати);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиСправкиПоОтпускамСотрудника(КомандыПечати)
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеОтпусков,ЧтениеОтпусков", , Ложь) Тогда
		// Справка по отпускам сотрудника.
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.Идентификатор = "СправкаПоОтпускамСотрудника";
		КомандаПечати.Представление = НСтр("ru = 'Справка по отпускам сотрудника'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиСправкиОДоходахПроизвольнаяФорма(КомандыПечати)
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная,ЧтениеНачисленнойЗарплатыРасширенная", , Ложь) Тогда
		// Справка о доходах (произвольная форма).
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_СправкаОДоходахПроизвольнаяФорма";
		КомандаПечати.Представление = НСтр("ru = 'Справка о доходах (произвольная форма)'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьКомандуПечатиСправкиСМестаРаботы(КомандыПечати)
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеКадровогоСостоянияРасширенная,ЧтениеКадровогоСостоянияРасширенная", , Ложь) Тогда
		// Справка с места работы
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_СправкаСМестаРаботы";
		КомандаПечати.Представление = НСтр("ru = 'Справка с места работы'");
	КонецЕсли;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СправкаПоОтпускамСотрудника") Тогда
		ДатаОстатков			= ?(ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("ДатаОстатков"), ПараметрыПечати.ДатаОстатков, '00010101');
		ЭтоРасчетПриУвольнении	= ?(ТипЗнч(ПараметрыПечати) = Тип("Структура") И ПараметрыПечати.Свойство("ЭтоРасчетПриУвольнении"), ПараметрыПечати.ЭтоРасчетПриУвольнении, Ложь);
		
		УстановитьПривилегированныйРежим(Истина);
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
						КоллекцияПечатныхФорм,
						"СправкаПоОтпускамСотрудника", НСтр("ru='Справка по отпускам сотрудника'"),
						ОстаткиОтпусков.СправкаПоОтпускамСотрудника(МассивОбъектов, ДатаОстатков, ЭтоРасчетПриУвольнении), ,
						ОстаткиОтпусков.ИмяМакетаДляПечати());
						
		УстановитьПривилегированныйРежим(Ложь);
		
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба")
		И ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба").НужноПечататьМакетСотрудника(КоллекцияПечатныхФорм) Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ПечататьМакетСотрудника(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ТрудовойДоговорМикропредприятий") Тогда
		
		Отчеты.ПечатнаяФормаТрудовойДоговорМикропредприятий.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
		
	Иначе
		СотрудникиБазовый.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийМодуляМенеджера

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
		Параметры.Отбор, 
		Справочники.Сотрудники.СтандартныйОтбор(),
		Ложь);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Если Параметры.Свойство("СтрокаПоиска") И Не ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
		СтрокаПоиска = Параметры.СтрокаПоиска;
	Иначе
		СтрокаПоиска = "";
	КонецЕсли;
	
	ДлинаСтрокиПоиска = СтрДлина(СтрокаПоиска);
	
	ТекстыУсловий = Новый Массив;
	
	// Отбор сотрудников по ФизическомуЛицу
	Если Параметры.Отбор.Свойство("ФизическоеЛицо") Тогда
		
		Запрос.УстановитьПараметр("ФизическоеЛицо", Параметры.Отбор.ФизическоеЛицо);
		ТекстыУсловий.Добавить("Сотрудники.ФизическоеЛицо В (&ФизическоеЛицо)");
		
		Параметры.Отбор.Удалить("ФизическоеЛицо");
		
	КонецЕсли;
	
	Если КадровыйУчетРасширенный.НастройкиКадровогоУчета().ВПоляхВводаСотрудниковУчитыватьИзмененияФамилии
		И Не ПустаяСтрока(СтрокаПоиска) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ФизическиеЛицаЗарплатаКадры.СоздатьВТПрежниеФИО(Запрос.МенеджерВременныхТаблиц, Ложь, СтрокаПоиска);
		УстановитьПривилегированныйРежим(Ложь);
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
			|	ПрежниеФИО.ФИО КАК ФИО,
			|	ПрежниеФИО.Фамилия КАК Фамилия,
			|	ПрежниеФИО.Имя КАК Имя,
			|	ПрежниеФИО.Отчество КАК Отчество,
			|	ПрежниеФИО.Инициалы КАК Инициалы,
			|	Сотрудники.Сотрудник КАК Сотрудник,
			|	МАКСИМУМ(ПрежниеФИО.Период) КАК Период,
			|	Сотрудники.ПометкаУдаления КАК ПометкаУдаления,
			|	Сотрудники.Код КАК Код,
			|	Сотрудники.Наименование КАК Наименование
			|ИЗ
			|	ВТПрежниеФИО КАК ПрежниеФИО
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
			|		ПО ПрежниеФИО.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
			|ГДЕ
			|	&УсловияБезСтрокиПоиска
			|
			|СГРУППИРОВАТЬ ПО
			|	ПрежниеФИО.ФИО,
			|	ПрежниеФИО.Фамилия,
			|	ПрежниеФИО.Имя,
			|	ПрежниеФИО.Отчество,
			|	ПрежниеФИО.Инициалы,
			|	Сотрудники.Сотрудник,
			|	Сотрудники.ПометкаУдаления,
			|	Сотрудники.Код,
			|	Сотрудники.Наименование
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
			|	"""",
			|	"""",
			|	"""",
			|	"""",
			|	"""",
			|	Сотрудники.Сотрудник,
			|	ДАТАВРЕМЯ(1, 1, 1),
			|	Сотрудники.ПометкаУдаления,
			|	Сотрудники.Код,
			|	Сотрудники.Наименование
			|ИЗ
			|	РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
			|ГДЕ
			|	&УсловияОтбораПоНаименованию";
		
		Если Не ПустаяСтрока(СтрокаПоиска) Тогда
			
			Запрос.Текст = Запрос.Текст + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
				|	"""",
				|	"""",
				|	"""",
				|	"""",
				|	"""",
				|	Сотрудники.Сотрудник,
				|	ДАТАВРЕМЯ(1, 1, 1),
				|	Сотрудники.ПометкаУдаления,
				|	Сотрудники.Код,
				|	Сотрудники.Наименование
				|ИЗ
				|	РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
				|ГДЕ
				|	&УсловияОтбораПоКоду";
			
		КонецЕсли;
		
	Иначе
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
			|	Сотрудники.Наименование КАК Наименование,
			|	Сотрудники.Сотрудник КАК Сотрудник,
			|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
			|	Сотрудники.Код КАК Код,
			|	Сотрудники.ПометкаУдаления КАК ПометкаУдаления
			|ИЗ
			|	РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
			|ГДЕ
			|	&УсловияОтбораПоНаименованию";
		
		Если Не ПустаяСтрока(СтрокаПоиска) Тогда
			
			Запрос.Текст = Запрос.Текст + "
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 51
				|	Сотрудники.Наименование,
				|	Сотрудники.Сотрудник,
				|	ДАТАВРЕМЯ(1, 1, 1),
				|	Сотрудники.Код,
				|	Сотрудники.ПометкаУдаления
				|ИЗ
				|	РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
				|ГДЕ
				|	&УсловияОтбораПоКоду";
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Отбор сотрудников "в архиве"
	Если Параметры.Отбор.Свойство("ВАрхиве") Тогда
		
		Если Параметры.Отбор.ВАрхиве = Истина Тогда
			ТекстыУсловий.Добавить("Сотрудники.ВАрхиве");
		Иначе
			ТекстыУсловий.Добавить("НЕ Сотрудники.ВАрхиве");
		КонецЕсли;
		
		Параметры.Отбор.Удалить("ВАрхиве");
		
	КонецЕсли;
	
	// Отбор по головной организации.
	Если Параметры.Отбор.Свойство("ГоловнаяОрганизация")
		И ЗначениеЗаполнено(Параметры.Отбор.ГоловнаяОрганизация) Тогда
		
		ТекстыУсловий.Добавить("Сотрудники.Организация = &ГоловнаяОрганизация");
		Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадры.ГоловнаяОрганизация(Параметры.Отбор.ГоловнаяОрганизация));
		
		Параметры.Отбор.Удалить("ГоловнаяОрганизация");
		
	КонецЕсли;
	
	// Удаление незаполненных значений отборов
	Если Параметры.Отбор.Свойство("ТекущаяОрганизация")
		И Не ЗначениеЗаполнено(Параметры.Отбор.ТекущаяОрганизация) Тогда
		
		Параметры.Отбор.Удалить("ТекущаяОрганизация");
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ТекущееПодразделение") Тогда
		
		Если Параметры.Свойство("УчитыватьОтборПоПодразделению")
			И Параметры.УчитыватьОтборПоПодразделению
			И ЗначениеЗаполнено(Параметры.Отбор.ТекущееПодразделение)
			И Не ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			
			Параметры.Отбор.Удалить("ТекущееПодразделение");
			
		ИначеЕсли Не ЗначениеЗаполнено(Параметры.Отбор.ТекущееПодразделение) Тогда
			Параметры.Отбор.Удалить("ТекущееПодразделение");
		КонецЕсли;
		
	КонецЕсли;
	
	ПоказыватьПодработки = Неопределено;
	Параметры.Отбор.Свойство("ПоказыватьПодработки", ПоказыватьПодработки);
	
	// Отбор по головному сотруднику.
	Если ПоказыватьПодработки <> Истина И НЕ Параметры.Отбор.Свойство("ГоловнойСотрудник") Тогда
		Запрос.УстановитьПараметр("ПоказыватьПодработки", Истина);
		ТекстыУсловий.Добавить("Сотрудники.ЭтоГоловнойСотрудник = ИСТИНА");
	ИначеЕсли Параметры.Отбор.Свойство("ПоказыватьТолькоПодработки") Тогда
		Запрос.УстановитьПараметр("ПоказыватьПодработки", Истина);
		ТекстыУсловий.Добавить("Сотрудники.ЭтоГоловнойСотрудник = ЛОЖЬ");
	Иначе
		Запрос.УстановитьПараметр("ПоказыватьПодработки", Ложь);
	КонецЕсли;
	
	Если Параметры.Свойство("ДоступныНеПринятые")
		И Параметры.ДоступныНеПринятые Тогда
		
		ТекстыУсловий.Добавить("Сотрудники.Начало = ДАТАВРЕМЯ(1, 1, 1)");
		ТекстыУсловий.Добавить("Сотрудники.Окончание = ДАТАВРЕМЯ(3999, 12, 31)");
		
		Если Параметры.Отбор.Свойство("ТекущаяОрганизация") 
			И ЗначениеЗаполнено(Параметры.Отбор.ТекущаяОрганизация) Тогда
		
			ТекстыУсловий.Добавить("Сотрудники.Организация = &ГоловнаяОрганизация");
			Запрос.УстановитьПараметр("ГоловнаяОрганизация", ЗарплатаКадры.ГоловнаяОрганизация(Параметры.Отбор.ТекущаяОрганизация));
			
		КонецЕсли;
		
	Иначе
		
		Если Параметры.Отбор.Свойство("ТекущаяОрганизация") Тогда
			
			Запрос.УстановитьПараметр("Филиал", Параметры.Отбор.ТекущаяОрганизация);
			ТекстыУсловий.Добавить("Сотрудники.Филиал = &Филиал");
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Отбор по текущему подразделению, если заполнено.
	Если Параметры.Отбор.Свойство("ТекущееПодразделение") 
		И ЗначениеЗаполнено(Параметры.Отбор.ТекущееПодразделение) Тогда
		
		ТекстыУсловий.Добавить("Сотрудники.Подразделение В ИЕРАРХИИ (&Подразделение)");
		Запрос.УстановитьПараметр("Подразделение", Параметры.Отбор.ТекущееПодразделение);
		
	КонецЕсли;
	
	ПараметрыОтбораПоПериоду = СотрудникиФормыРасширенный.ПараметрыОтбораПоПериодуПараметровОткрытияФормыСписка(Параметры);
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыОтбораПоПериоду.ПериодРаботы.ДатаНачала);
	Если ЗначениеЗаполнено(ПараметрыОтбораПоПериоду.ПериодРаботы.ДатаОкончания) Тогда
		Запрос.УстановитьПараметр("ДатаОкончания", ПараметрыОтбораПоПериоду.ПериодРаботы.ДатаОкончания);
	Иначе
		Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ТекущаяДатаСеанса()));
	КонецЕсли;
	ТекстыУсловий.Добавить("Сотрудники.Начало <= &ДатаОкончания");
	ТекстыУсловий.Добавить("Сотрудники.Окончание >= &ДатаНачала");
	ТекстыУсловий.Добавить("Сотрудники.ВидСобытия <> Значение(Перечисление.ВидыКадровыхСобытий.Увольнение)");
	
	// Отбор по виду занятости
	Если Параметры.Отбор.Свойство("ВидЗанятости") 
		И ЗначениеЗаполнено(Параметры.Отбор.ВидЗанятости) Тогда
		
		ТекстыУсловий.Добавить("Сотрудники.ВидЗанятости В (&ВидЗанятости)");
		Запрос.УстановитьПараметр("ВидЗанятости", Параметры.Отбор.ВидЗанятости);
		
	КонецЕсли;
	
	// Отбор по виду договора
	Если Параметры.Отбор.Свойство("ВидДоговора") 
		И ЗначениеЗаполнено(Параметры.Отбор.ВидДоговора)
			Или Параметры.Отбор.Свойство("НачислениеЗарплатыВоеннослужащим") Тогда
		
		ТекстыУсловий.Добавить("Сотрудники.ВидДоговора В (&ВидДоговора)");
		Если Параметры.Отбор.Свойство("НачислениеЗарплатыВоеннослужащим") Тогда
			
			Если Параметры.Отбор.НачислениеЗарплатыВоеннослужащим Тогда	
				Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровССотрудниками.ВидыДоговоровВоеннойСлужбы());
			Иначе
				Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоровССотрудниками.ВидыДоговоровКромеВоеннойСлужбы());
			КонецЕсли;
			
		Иначе
			Запрос.УстановитьПараметр("ВидДоговора", Параметры.Отбор.ВидДоговора);
		КонецЕсли;
		
	КонецЕсли;
	
	// Отбор по параметру РольСотрудника.
	Если Параметры.Отбор.Свойство("РольСотрудника") 
		И ЗначениеЗаполнено(Параметры.Отбор.РольСотрудника) Тогда
		
		ТекстСоединения = "РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РолиСотрудников Как РолиСотрудников
			|	По Сотрудники.Сотрудник = РолиСотрудников.Сотрудник";
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "РегистрСведений.ДанныеДляПодбораСотрудников КАК Сотрудники", ТекстСоединения);
		
		Если Параметры.Отбор.РольСотрудника = Перечисления.РолиСотрудников.Договорник Тогда
			ТекстыУсловий.Добавить("РолиСотрудников.РольСотрудника = ЗНАЧЕНИЕ(Перечисление.РолиСотрудников.Договорник)");
		ИначеЕсли Параметры.Отбор.РольСотрудника = Перечисления.РолиСотрудников.Работник Тогда
			ТекстыУсловий.Добавить("РолиСотрудников.РольСотрудника = ЗНАЧЕНИЕ(Перечисление.РолиСотрудников.Работник)");
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстыЗапроса = Новый Массив;
	Если Не ПустаяСтрока(СтрокаПоиска) Тогда
		
		Запрос.УстановитьПараметр("СтрокаПоиска", СтрокаПоиска + "%");
		Запрос.УстановитьПараметр("СтрокаПоискаПоКоду", "%" + СтрокаПоиска + "%");
		
		Если ТекстыУсловий.Количество() = 0 Тогда
			ТекстЗапроса = СтрЗаменить(Запрос.Текст, "&УсловияБезСтрокиПоиска", "(ИСТИНА)")
		Иначе
			ТекстЗапроса = СтрЗаменить(Запрос.Текст, "&УсловияБезСтрокиПоиска", СтрСоединить(ТекстыУсловий, Символы.ПС + "И "))
		КонецЕсли;
		
		ТекстыУсловийПоНаименованию = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ТекстыУсловий);
		ТекстыУсловийПоНаименованию.Добавить("(Сотрудники.Наименование ПОДОБНО &СтрокаПоиска)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловияОтбораПоНаименованию", СтрСоединить(ТекстыУсловийПоНаименованию, Символы.ПС + "И "));
		
		ТекстыУсловийПоКоду = ОбщегоНазначенияКлиентСервер.СкопироватьМассив(ТекстыУсловий);
		ТекстыУсловийПоКоду.Добавить("(Сотрудники.Код ПОДОБНО &СтрокаПоискаПоКоду)");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловияОтбораПоКоду", СтрСоединить(ТекстыУсловийПоКоду, Символы.ПС + "И "));
		
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
	Иначе
		
		Если ТекстыУсловий.Количество() = 0 Тогда
			ТекстыЗапроса.Добавить(СтрЗаменить(Запрос.Текст, "&УсловияОтбораПоНаименованию", "(ИСТИНА)"));
		Иначе
			ТекстыЗапроса.Добавить(СтрЗаменить(Запрос.Текст, "&УсловияОтбораПоНаименованию", СтрСоединить(ТекстыУсловий, Символы.ПС + "И ")));
		КонецЕсли;
		
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(
		"УПОРЯДОЧИТЬ ПО
		|	Сотрудники.Наименование");
	
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, Символы.ПС);
	ТаблицаСотрудников = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеДанныеСотрудников = Новый Соответствие;
	ЗапросСвойств = Новый Запрос;
	ЗапросСвойств.УстановитьПараметр("СотрудникиДляДопДанных", ТаблицаСотрудников.ВыгрузитьКолонку("Сотрудник"));
	
	ЗапросСвойств.Текст =
		"ВЫБРАТЬ
		|	Сотрудники.Ссылка КАК Сотрудник,
		|	ПРЕДСТАВЛЕНИЕ(Сотрудники.Ссылка) КАК СотрудникПредставление,
		|	Сотрудники.УточнениеНаименования КАК УточнениеНаименования,
		|	Сотрудники.ФизическоеЛицо.УточнениеНаименования КАК УточнениеНаименованияФизическогоЛица
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Ссылка В(&СотрудникиДляДопДанных)";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = ЗапросСвойств.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСотрудника = Новый Структура(
			"СотрудникПредставление,
			|УточнениеНаименования,
			|УточнениеНаименованияФизическогоЛица");
		ЗаполнитьЗначенияСвойств(ДанныеСотрудника, Выборка);
		ДополнительныеДанныеСотрудников.Вставить(Выборка.Сотрудник, ДанныеСотрудника);
		
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из ТаблицаСотрудников Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.Период) Тогда
			
			ПравилоФормированияПредставления = ПараметрыСеанса.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
			
			ДанныеДляФормированияПредставления = Новый Структура;
			ДанныеДляФормированияПредставления.Вставить("ПравилоФормированияПредставления", ПравилоФормированияПредставления);
			
			ДанныеСотрудника = ДополнительныеДанныеСотрудников.Получить(СтрокаТаблицы.Сотрудник);
			ФИО = Новый Структура("Фамилия,Имя,Отчество, Инициалы");
			ЗаполнитьЗначенияСвойств(ФИО, СтрокаТаблицы);
			
			ДанныеДляФормированияПредставления.Вставить("ФИО", ФИО);
			ДанныеДляФормированияПредставления.Вставить("ФИОПолные", СтрокаТаблицы.ФИО);
			ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияФизическогоЛица", ДанныеСотрудника.УточнениеНаименованияФизическогоЛица);
			ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияСотрудника", ДанныеСотрудника.УточнениеНаименования);
			
			ПредставлениеПоПрежнимДанным = СотрудникиКлиентСерверРасширенный.ПредставлениеЭлемента(
				ДанныеДляФормированияПредставления);
			
			Представление = Новый ФорматированнаяСтрока(
				Новый ФорматированнаяСтрока(
					Лев(ПредставлениеПоПрежнимДанным, ДлинаСтрокиПоиска),
					Новый Шрифт( , , Истина),
					WebЦвета.Зеленый),
				Сред(ПредставлениеПоПрежнимДанным, ДлинаСтрокиПоиска + 1));
			
			ПредставлениеСотрудника = ДанныеСотрудника.СотрудникПредставление;
			
			Представление = Новый ФорматированнаяСтрока(
				Представление,
				" (" + ПредставлениеСотрудника + " " 
					+ НСтр("ru='с'") + " " + Формат(СтрокаТаблицы.Период, "ДЛФ=D") + " (" + СтрокаТаблицы.Код + "))");
			
		Иначе
			
			ДанныеСотрудника = ДополнительныеДанныеСотрудников.Получить(СтрокаТаблицы.Сотрудник);
			Если Не ПустаяСтрока(СтрокаПоиска) И Не СтрНачинаетсяС(ВРег(ДанныеСотрудника.СотрудникПредставление), ВРег(СтрокаПоиска)) Тогда
				
				ПредставлениеСотрудника = "(" + СтрокаТаблицы.Код + ") " + ДанныеСотрудника.СотрудникПредставление;
				
				ПозицияСтрокиПоиска = СтрНайти(ВРег(ПредставлениеСотрудника), ВРег(СтрокаПоиска));
				Представление = Новый ФорматированнаяСтрока(
					Лев(ПредставлениеСотрудника, ПозицияСтрокиПоиска - 1),
					Новый ФорматированнаяСтрока(
						Сред(ПредставлениеСотрудника, ПозицияСтрокиПоиска, ДлинаСтрокиПоиска),
						Новый Шрифт( , , Истина),
						WebЦвета.Зеленый),
					Сред(ПредставлениеСотрудника, ПозицияСтрокиПоиска + ДлинаСтрокиПоиска));
				
			Иначе
				
				ПредставлениеСотрудника = ДанныеСотрудника.СотрудникПредставление + " (" + СтрокаТаблицы.Код + ")";
				
				Представление = Новый ФорматированнаяСтрока(
					Новый ФорматированнаяСтрока(
						Лев(ПредставлениеСотрудника, ДлинаСтрокиПоиска),
						Новый Шрифт( , , Истина),
						WebЦвета.Зеленый),
					Сред(ПредставлениеСотрудника, ДлинаСтрокиПоиска + 1));
				
			КонецЕсли;
			
		КонецЕсли;
		
		ДанныеВыбора.Добавить(СтрокаТаблицы.Сотрудник, Представление, СтрокаТаблицы.ПометкаУдаления);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьЗарплатаКадрыКорпоративнаяПодсистемы")
		И ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.КадровыйУчет.СпискиСотрудников") Тогда
		
		МодульСпискиСотрудников = ОбщегоНазначения.ОбщийМодуль("СпискиСотрудников");
		МодульСпискиСотрудников.ОбработкаПолученияФормыСпискаВыбораСотрудников(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
		
	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаСписка" Тогда
		ВыбраннаяФорма = "ФормаСписка";
	ИначеЕсли ВидФормы = "ФормаВыбора" Тогда
		ВыбраннаяФорма = "ФормаВыбора";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВыбраннаяФорма) Тогда
		
		СтандартнаяОбработка = Ложь;
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура);
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
			Параметры.Отбор, 
			Справочники.Сотрудники.СтандартныйОтбор(),
			Ложь);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт
	
	ПравилоФормированияПредставления = ПараметрыСеанса.ПравилоФормированияПредставленияЭлементовСправочникаСотрудники;
	Если ЗначениеЗаполнено(ПравилоФормированияПредставления)
		И ПравилоФормированияПредставления <> Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоДополнение Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		ДанныеДляФормированияПредставления = Новый Структура;
		ДанныеДляФормированияПредставления.Вставить("ПравилоФормированияПредставления", ПравилоФормированияПредставления);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("Сотрудник", Данные.Ссылка);
		Запрос.УстановитьПараметр("МаксимальнаяДата", ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
		ТребуетсяВидЗанятости   = Ложь;
		ТребуетсяДатаУвольнения = Ложь;
		ТребуетсяРольСотрудника = Ложь;
		
		Если ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоВидЗанятостиДополнение 
			Или ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОВидЗанятостиДополнение Тогда
			ТребуетсяВидЗанятости   = Истина;
			ТребуетсяРольСотрудника = Истина;
		ИначеЕсли ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоВидЗанятостиУволенДополнение
			Или ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОВидЗанятостиУволенДополнение Тогда
			ТребуетсяВидЗанятости   = Истина;
			ТребуетсяРольСотрудника = Истина;
			ТребуетсяДатаУвольнения = Истина;
		ИначеЕсли ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоУволенДополнение
			Или ПравилоФормированияПредставления = Перечисления.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОУволенДополнение Тогда
			ТребуетсяДатаУвольнения = Истина;
		КонецЕсли;
		
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Данные.ФизическоеЛицо, "ФИО,Фамилия,Имя,Отчество,Инициалы,УточнениеНаименования");
		ФИО = Новый Структура("Фамилия,Имя,Отчество,Инициалы");
		ЗаполнитьЗначенияСвойств(ФИО, ЗначенияРеквизитов);
		ДанныеДляФормированияПредставления.Вставить("ФИО", ФИО);
		ДанныеДляФормированияПредставления.Вставить("ФИОПолные", ЗначенияРеквизитов.ФИО);
		ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияФизическогоЛица", ЗначенияРеквизитов.УточнениеНаименования);
		
		Если ТребуетсяВидЗанятости Тогда
			Запрос.Текст =
				"ВЫБРАТЬ
				|	ТекущиеВидыЗанятостиСотрудников.ВидЗанятости КАК ВидЗанятости
				|ИЗ
				|	РегистрСведений.ВидыЗанятостиСотрудниковИнтервальный КАК ТекущиеВидыЗанятостиСотрудников
				|ГДЕ
				|	ТекущиеВидыЗанятостиСотрудников.Сотрудник = &Сотрудник
				|	И ТекущиеВидыЗанятостиСотрудников.ДатаОкончания = &МаксимальнаяДата";
			
			ВыборкаВидыЗанятости = Запрос.Выполнить().Выбрать();
			Если ВыборкаВидыЗанятости.Следующий() Тогда
				ДанныеДляФормированияПредставления.Вставить("ВидЗанятости", ВыборкаВидыЗанятости.ВидЗанятости);
				ТребуетсяРольСотрудника = Не ЗначениеЗаполнено(ВыборкаВидыЗанятости.ВидЗанятости);
			КонецЕсли;
		КонецЕсли;
		
		Если ТребуетсяРольСотрудника Тогда
			Запрос.Текст =
				"ВЫБРАТЬ
				|	РолиСотрудников.РольСотрудника КАК РольСотрудника
				|ИЗ
				|	РегистрСведений.РолиСотрудников КАК РолиСотрудников
				|ГДЕ
				|	РолиСотрудников.Сотрудник = &Сотрудник
				|	И РолиСотрудников.РольСотрудника = ЗНАЧЕНИЕ(Перечисление.РолиСотрудников.Договорник)";
			
			РезультатРолиСотрудников = Запрос.Выполнить();
			Если Не РезультатРолиСотрудников.Пустой() Тогда
				ДанныеДляФормированияПредставления.Вставить("РольСотрудникаДоговорник", Истина);
			КонецЕсли;
		КонецЕсли;
		
		Если ТребуетсяДатаУвольнения Тогда
			РабочаяДатаПользователя = ОбщегоНазначения.РабочаяДатаПользователя();
			Если Не ЗначениеЗаполнено(РабочаяДатаПользователя) Тогда
				РабочаяДатаПользователя = ТекущаяДатаСеанса();
			КонецЕсли;
			Запрос.УстановитьПараметр("РабочаяДатаПользователя", РабочаяДатаПользователя);
			Запрос.Текст =
				"ВЫБРАТЬ
				|	ВЫБОР
				|		КОГДА ТекущиеКадровыеДанныеГоловныхСотрудников.ДатаУвольнения > КОНЕЦПЕРИОДА(&РабочаяДатаПользователя, ДЕНЬ)
				|			ТОГДА ДАТАВРЕМЯ(1, 1, 1)
				|		ИНАЧЕ ТекущиеКадровыеДанныеГоловныхСотрудников.ДатаУвольнения
				|	КОНЕЦ КАК ДатаУвольнения
				|ИЗ
				|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеГоловныхСотрудников
				|ГДЕ
				|	ТекущиеКадровыеДанныеГоловныхСотрудников.Сотрудник = &Сотрудник";
			
			ВыборкаДатаУвольнения = Запрос.Выполнить().Выбрать();
			Если ВыборкаДатаУвольнения.Следующий() Тогда
				ДанныеДляФормированияПредставления.Вставить("ДатаУвольнения", ВыборкаДатаУвольнения.ДатаУвольнения);
			КонецЕсли;
		КонецЕсли;
		
		ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияСотрудника", Данные.УточнениеНаименования);
		Представление = СотрудникиКлиентСерверРасширенный.ПредставлениеЭлемента(ДанныеДляФормированияПредставления);
			
		Если Не ЗначениеЗаполнено(Представление) Тогда
			Представление = Данные.Наименование;
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Функция СтандартныйОтбор() Экспорт
	Отбор = СотрудникиБазовый.СтандартныйОтбор();
	Отбор.Вставить("ПоказыватьПодработки", Ложь);
	Возврат Отбор;
КонецФункции

Функция ПоследниеКадровыеПереводы(Сотрудники) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ИзмеренияДаты = Новый ТаблицаЗначений;
	ИзмеренияДаты.Колонки.Добавить("ДатаНачала",    Новый ОписаниеТипов("Дата"));
	ИзмеренияДаты.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));
	ИзмеренияДаты.Колонки.Добавить("Сотрудник",     Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	
	Для каждого Сотрудник Из Сотрудники Цикл
		ИзмеренияДаты.Добавить().Сотрудник = Сотрудник;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ИзмеренияДаты", ИзмеренияДаты);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзмеренияДаты.ДатаНачала КАК ДатаНачала,
		|	ИзмеренияДаты.ДатаОкончания КАК ДатаОкончания,
		|	ИзмеренияДаты.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТСотрудникиПериоды
		|ИЗ
		|	&ИзмеренияДаты КАК ИзмеренияДаты";
	
	Запрос.Выполнить();
	
	ПараметрыПостроения = ЗарплатаКадрыОбщиеНаборыДанных.ПараметрыПостроенияДляСоздатьВТИмяРегистра();
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(ПараметрыПостроения.Отборы, "ВидСобытия", "=", Перечисления.ВидыКадровыхСобытий.Перемещение);
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"КадроваяИсторияСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник"),
		ПараметрыПостроения,
		"ВТКадроваяИсторияСотрудников");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник"),
		,
		"ВТПлановыеНачисления");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ПлановыеАвансы",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник"),
		,
		"ВТПлановыеАвансы");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник"),
		,
		"ВТЗначенияПоказателей");
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистра(
		"ГрафикРаботыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра("ВТСотрудникиПериоды", "Сотрудник"),
		,
		"ВТГрафикРаботыСотрудников");
	
	ТипыКадровыхПереводов = Новый Массив;
	ТипыКадровыхПереводов.Добавить(Тип("ДокументСсылка.КадровыйПеревод"));
	ТипыКадровыхПереводов.Добавить(Тип("ДокументСсылка.КадровыйПереводСписком"));
	ТипыКадровыхПереводов.Добавить(Тип("ДокументСсылка.ПеремещениеВДругоеПодразделение"));
	
	Запрос.УстановитьПараметр("ТипыКадровыхПереводов", ТипыКадровыхПереводов);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(КадроваяИсторияСотрудников.ПериодЗаписи) КАК ПериодЗаписи,
		|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыКадроваяИсторияСотрудников
		|ИЗ
		|	ВТКадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|
		|СГРУППИРОВАТЬ ПО
		|	КадроваяИсторияСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ПлановыеНачисления.ПериодЗаписи) КАК ПериодЗаписи,
		|	ПлановыеНачисления.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыПлановыеНачисления
		|ИЗ
		|	ВТПлановыеНачисления КАК ПлановыеНачисления
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПлановыеНачисления.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПлановыеНачисления.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ПлановыеАвансы.ПериодЗаписи) КАК ПериодЗаписи,
		|	ПлановыеАвансы.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыПлановыеАвансы
		|ИЗ
		|	ВТПлановыеАвансы КАК ПлановыеАвансы
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПлановыеАвансы.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПлановыеАвансы.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ЗначенияПоказателей.ПериодЗаписи) КАК ПериодЗаписи,
		|	ЗначенияПоказателей.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыЗначенияПоказателей
		|ИЗ
		|	ВТЗначенияПоказателей КАК ЗначенияПоказателей
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ЗначенияПоказателей.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗначенияПоказателей.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ГрафикРаботыСотрудников.ПериодЗаписи) КАК ПериодЗаписи,
		|	ГрафикРаботыСотрудников.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыГрафикРаботыСотрудников
		|ИЗ
		|	ВТГрафикРаботыСотрудников КАК ГрафикРаботыСотрудников
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ГрафикРаботыСотрудников.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикРаботыСотрудников.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КадроваяИсторияСотрудников.ПериодЗаписи КАК Период,
		|	КадроваяИсторияСотрудников.Регистратор КАК Регистратор,
		|	КадроваяИсторияСотрудников.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТКадровыеПереводы
		|ИЗ
		|	ВТПериодыКадроваяИсторияСотрудников КАК ПериодыРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
		|		ПО ПериодыРегистра.ПериодЗаписи = КадроваяИсторияСотрудников.ПериодЗаписи
		|			И ПериодыРегистра.Сотрудник = КадроваяИсторияСотрудников.Сотрудник
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеНачисления.ПериодЗаписи,
		|	ПлановыеНачисления.Регистратор,
		|	ПлановыеНачисления.Сотрудник
		|ИЗ
		|	ВТПериодыПлановыеНачисления КАК ПериодыРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеНачисления КАК ПлановыеНачисления
		|		ПО ПериодыРегистра.ПериодЗаписи = ПлановыеНачисления.ПериодЗаписи
		|			И ПериодыРегистра.Сотрудник = ПлановыеНачисления.Сотрудник
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПлановыеНачисления.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПлановыеАвансы.ПериодЗаписи,
		|	ПлановыеАвансы.Регистратор,
		|	ПлановыеАвансы.Сотрудник
		|ИЗ
		|	ВТПериодыПлановыеАвансы КАК ПериодыРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПлановыеАвансы КАК ПлановыеАвансы
		|		ПО ПериодыРегистра.ПериодЗаписи = ПлановыеАвансы.ПериодЗаписи
		|			И ПериодыРегистра.Сотрудник = ПлановыеАвансы.Сотрудник
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ПлановыеАвансы.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗначенияПоказателей.ПериодЗаписи,
		|	ЗначенияПоказателей.Регистратор,
		|	ЗначенияПоказателей.Сотрудник
		|ИЗ
		|	ВТПериодыЗначенияПоказателей КАК ПериодыРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗначенияПоказателей КАК ЗначенияПоказателей
		|		ПО ПериодыРегистра.ПериодЗаписи = ЗначенияПоказателей.ПериодЗаписи
		|			И ПериодыРегистра.Сотрудник = ЗначенияПоказателей.Сотрудник
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ЗначенияПоказателей.Регистратор) В (&ТипыКадровыхПереводов)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ГрафикРаботыСотрудников.ПериодЗаписи,
		|	ГрафикРаботыСотрудников.Регистратор,
		|	ГрафикРаботыСотрудников.Сотрудник
		|ИЗ
		|	ВТПериодыГрафикРаботыСотрудников КАК ПериодыРегистра
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТГрафикРаботыСотрудников КАК ГрафикРаботыСотрудников
		|		ПО ПериодыРегистра.ПериодЗаписи = ГрафикРаботыСотрудников.ПериодЗаписи
		|			И ПериодыРегистра.Сотрудник = ГрафикРаботыСотрудников.Сотрудник
		|ГДЕ
		|	ТИПЗНАЧЕНИЯ(ГрафикРаботыСотрудников.Регистратор) В (&ТипыКадровыхПереводов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ЕСТЬNULL(КадровыеПереводы.Период, ДАТАВРЕМЯ(1, 1, 1))) КАК Период,
		|	СотрудникиПериоды.Сотрудник КАК Сотрудник
		|ПОМЕСТИТЬ ВТПериодыПереводов
		|ИЗ
		|	ВТСотрудникиПериоды КАК СотрудникиПериоды
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеПереводы КАК КадровыеПереводы
		|		ПО СотрудникиПериоды.Сотрудник = КадровыеПереводы.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	СотрудникиПериоды.Сотрудник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПериодыПереводов.Сотрудник КАК Сотрудник,
		|	МАКСИМУМ(КадровыеПереводы.Регистратор) КАК Регистратор
		|ИЗ
		|	ВТПериодыПереводов КАК ПериодыПереводов
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеПереводы КАК КадровыеПереводы
		|		ПО ПериодыПереводов.Период = КадровыеПереводы.Период
		|			И ПериодыПереводов.Сотрудник = КадровыеПереводы.Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	ПериодыПереводов.Сотрудник";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти
