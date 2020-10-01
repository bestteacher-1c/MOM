#Область ПрограммныйИнтерфейс

#Область ОписаниеПодписей

// Добавляет описание набора подписей объекта (документа) для организации.
//
// Параметры:
//  ОписаниеПодписей				 - ТаблицаЗначений	 - см. ОписаниеТаблицыПодписей.
//  СтрокаРолей						 - Строка			 - имена ролей, присутствующих в объекте, разделенные запятыми.
//  ПереопределяемыеИменаРеквизитов	 - Соответствие		 - имена реквизитов подписантов, где:
//  		* Ключ - Строка - имя роли
//  		* Значение - Структура - переопределяемые имена реквизитов, см. ОписаниеРеквизитовПодписанта.
//  ИмяРеквизитаОрганизация			 - Строка			 - имя реквизита объекта, который содержит Организацию, к которой относятся подключаемые роли.
//
Процедура ДобавитьОписаниеПодписейОрганизации(
	ОписаниеПодписей, 
	СтрокаРолей, 
	ПереопределяемыеИменаРеквизитов = Неопределено, 
	ИмяРеквизитаОрганизация = "Организация") Экспорт

	МассивРолей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаРолей, ",", Истина, Истина);
	МассивНеНайденныхРолей = Новый Массив;
	
	ОписаниеИменРеквизитов = ОписаниеИменПодписантовОбъекта(МассивРолей, ПереопределяемыеИменаРеквизитов);
	
	Для Каждого ИмяРоли Из МассивРолей Цикл
		ОписаниеИменРеквизитовРоли = ОписаниеИменРеквизитов.Получить(ИмяРоли);
		Если ОписаниеИменРеквизитовРоли = Неопределено Тогда
			МассивНеНайденныхРолей.Добавить(МассивРолей);
			Продолжить;
		КонецЕсли;
		
		ДобавитьОписаниеПодписи(ОписаниеПодписей, ОписаниеИменРеквизитовРоли, ИмяРоли, ИмяРеквизитаОрганизация);
	КонецЦикла; 
	
	Если МассивНеНайденныхРолей.Количество() > 0 Тогда
		Если МассивНеНайденныхРолей.Количество() = 1 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не найдено описания для подписей роли %1'"), ИмяРоли);
		ИначеЕсли МассивНеНайденныхРолей.Количество() > 1 Тогда
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не найдено описания для подписей ролей: %1'"), СтрСоединить(МассивНеНайденныхРолей, ", "));
		КонецЕсли;
		
		ВызватьИсключение(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

// Структура, описывающая триаду имен реквизитов подписанта.
// 
// Возвращаемое значение:
//  Структура - Имена реквизитов подписанта.
//
Функция ОписаниеРеквизитовПодписанта() Экспорт

	Описание = Новый Структура(
		"ФизическоеЛицо, 
		|Должность, 
		|ОснованиеПодписи");

	Возврат Описание;

КонецФункции

// Формирует соответствие с описанием роли уполномоченного лица, подписывающего документы.
//
// Параметры:
//  ИмяРеквизитаФизическоеЛицо	 - Строка	 - имя реквизита документа, в котором хранится ссылка на ответственное лицо,
//  ИмяРеквизитаДолжность		 - Строка	 - имя реквизита документа, в котором хранится должность ответственного лица,
//  ИмяРеквизитаОснованиеПодписи - Строка	 - имя реквизита документа, в котором хранится основание полномочий ответственного лица,
//  ИмяРоли						 - Строка	 - Необязательный, имя роли ответственного лица,
//  	если не задано, принимается равным ИмяРеквизитаФизическоеЛицо.
// 
// Возвращаемое значение:
//  Соответствие - ключом выступает имя роли, а значением описание (см. ОписаниеРеквизитовПодписанта).
//
Функция ИменаРеквизитовРолиПодписанта(
	ИмяРеквизитаФизическоеЛицо, 
	ИмяРеквизитаДолжность, 
	ИмяРеквизитаОснованиеПодписи, 
	ИмяРоли = Неопределено) Экспорт

	СтруктураИменРеквизитов = ОписаниеРеквизитовПодписанта();
	
	СтруктураИменРеквизитов.ФизическоеЛицо = ИмяРеквизитаФизическоеЛицо;
	СтруктураИменРеквизитов.Должность = ИмяРеквизитаДолжность;
	СтруктураИменРеквизитов.ОснованиеПодписи = ИмяРеквизитаОснованиеПодписи;
	
	Если ИмяРоли = Неопределено Тогда
		ИмяРоли = ИмяРеквизитаФизическоеЛицо;
	КонецЕсли;
	
	ОписаниеРоли = Новый Соответствие;
	ОписаниеРоли.Вставить(ИмяРоли, СтруктураИменРеквизитов);
	
	Возврат ОписаниеРоли;
	
КонецФункции

// Возвращает пустую таблиц значений для описания имен реквизитов формы, относящихся к подписям документа.
//
// Возвращаемое значение:
//		Таблица значений - содержит следующие колонки:
//			* Организация		 - признак принадлежности к той или иной организации в форме (их может быть более одной).
//			* Ключ				 - имя роли подписывающего лица (например "Руководитель")
//			* ФизическоеЛицо	 - имя реквизита, содержащего подписанта (например "Директор")
//			* Должность			 - имя реквизита, содержащего должность подписанта (например "ДолжностьДиректора")
//			* ОснованиеПодписи	 - имя реквизита, содержащего текст основания подписи (например "ОснованиеПодписиДиректора")
//
Функция ОписаниеТаблицыПодписей() Экспорт
	
	ОписаниеПодписей = Новый ТаблицаЗначений;
	
	// Организация и имя роли
	ОписаниеПодписей.Колонки.Добавить("Организация", Новый ОписаниеТипов("Строка"));
	ОписаниеПодписей.Колонки.Добавить("РольПодписанта", Новый ОписаниеТипов("Строка"));
	// Триада реквизитов подписанта, см. ОписаниеРеквизитовПодписанта()
	ОписаниеПодписей.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("Строка"));
	ОписаниеПодписей.Колонки.Добавить("Должность", Новый ОписаниеТипов("Строка"));
	ОписаниеПодписей.Колонки.Добавить("ОснованиеПодписи", Новый ОписаниеТипов("Строка"));
	
	Возврат ОписаниеПодписей;
	
КонецФункции

// Дополняет поддерживаемые идентификаторы значений по умолчанию идентификаторами ответственных лиц организаций.
//
// Параметры:
//  ПоддерживаемыеИдентификаторы - Массив - идентификаторы заполняемых по умолчанию значений.
//
Процедура ДобавитьИдентификаторыОтветственныхРаботниковОрганизаций(ПоддерживаемыеИдентификаторы) Экспорт 
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПоддерживаемыеИдентификаторы, ПоддерживаемыеРеквизитыОтветственныхРаботниковОрганизаций());
КонецПроцедуры

#КонецОбласти

#Область ПодписиДокументовФормы

// Расширение обработчика ПриСозданииНаСервере формы документа, в котором размещаются подписи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в котором размещаются подписи.
//	ОписаниеРеквизитовПодписей - ТаблицаЗначений - см. ПодписиДокументов.ОписаниеТаблицыПодписей(), 
//  ОписаниеФормыДляПодписей - Соответствие - где ключом является имя реквизита организации, 
//								а значением - его описание, созданное с помощью 
//								ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию().
//
Процедура ПриСозданииНаСервере(Форма, ОписаниеРеквизитовПодписей = Неопределено, ОписаниеФормыДляПодписей = Неопределено) Экспорт
	ПодписиДокументовФормы.ПриСозданииНаСервере(Форма, ОписаниеРеквизитовПодписей, ОписаниеФормыДляПодписей);
КонецПроцедуры

// Заполняет подписи документа в форме при смене организации.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в котором размещаются подписи.
//  ОписаниеФормыДляПодписей - Соответствие - где ключом является имя реквизита организации, 
//								а значением - его описание, созданное с помощью 
//								ПодписиДокументовКлиентСервер.ОписаниеФормыОбъектаДляОрганизацииПоУмолчанию().
//  ИмяРеквизитаОрганизация - Строка - имя реквизита, в котором хранится организация.
//
Процедура ЗаполнитьПодписиПоОрганизации(Форма, ОписаниеФормыДляПодписей = Неопределено, ИмяРеквизитаОрганизация = "Организация") Экспорт 
	ПодписиДокументовФормы.ЗаполнитьПодписиПоОрганизации(Форма, ОписаниеФормыДляПодписей, ИмяРеквизитаОрганизация);
КонецПроцедуры

// Расширение обработчика ПослеЗаписиНаСервере формы документа, в котором размещаются подписи.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма документа, в котором размещаются подписи.
//
Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	ПодписиДокументовФормы.ПослеЗаписиНаСервере(Форма);
КонецПроцедуры

#КонецОбласти  

// Вызывается из общей цепочки заполнения реквизитов, из ПолучитьЗначенияПоУмолчанию()
//
// Параметры:
//  ЗаполняемыеЗначения - Структура - значения по умолчанию, которые будут дополнены сведениями о подписях документа.
//
Процедура ЗаполнитьСведенияОПодписяхДокументовПоОрганизации(ЗаполняемыеЗначения) Экспорт

	Организация = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЗаполняемыеЗначения, "Организация");
	Если Организация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеПолейПодписантов = СоответствиеОписанийИменРеквизитовПоСтруктуре(ЗаполняемыеЗначения, Организация);
	
	СведенияОПодписях = СведенияОПодписяхДокументов(ОписаниеПолейПодписантов, Организация);
	
	ЗаполнитьСтруктуруЗаполняемыхЗначений(ЗаполняемыеЗначения, СведенияОПодписях);

КонецПроцедуры

// Добавляет текст из основания подписи физического лица в дополняемый текст.
//
// Параметры:
//   ДополняемыйТекст - Строка - текст, который необходимо дополнить.
//   ДокументСсылка - ДокументСсылка - ссылка на документ, в котором хранится подписант.
//   ИмяРеквизитаДокумента - Строка - имя реквизита документа.
//   
Процедура ДополнитьТекстОснованиемПодписиИзРеквизитаДокумента(ДополняемыйТекст, ДокументСсылка, ИмяРеквизитаДокумента) Экспорт

	ОснованиеПодписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, ИмяРеквизитаДокумента);
	ПодписиДокументовКлиентСервер.ДополнитьТекстОснованиемПодписи(ДополняемыйТекст, ОснованиеПодписи);

КонецПроцедуры

// Добавляет текст из основания подписи физического лица в дополняемый текст.
//
// Параметры:
//   ДополняемыйТекст - Строка - текст, который необходимо дополнить.
//   ДокументСсылка - ДокументСсылка - ссылка на документ, в котором хранится подписант.
//   ИмяРоли - Строка - имя роли подписанта.
//   ИмяРеквизитаОрганизация - Строка - имя реквизита "Организация" документа.
//   
Процедура ДополнитьТекстОснованиемПодписиПоИмениРоли(ДополняемыйТекст, ДокументСсылка, ИмяРоли, ИмяРеквизитаОрганизация = "Организация") Экспорт

	ТаблицаОписаний = ТаблицаОписанийПодписейОбъекта(ДокументСсылка);
	
	СтрокиОписания = ТаблицаОписаний.НайтиСтроки(Новый Структура("Организация, РольПодписанта", ИмяРеквизитаОрганизация, ИмяРоли));
	Если СтрокиОписания.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОснованиеПодписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, СтрокиОписания[0].ОснованиеПодписи);
	ПодписиДокументовКлиентСервер.ДополнитьТекстОснованиемПодписи(ДополняемыйТекст, ОснованиеПодписи);

КонецПроцедуры

// Позволяет получить описание подписей документа по его метаданным.
//
// Параметры:
//  МетаданныеОбъекта	 - ОбъектМетаданных		 - метаданные документа, для которого определяется состав подписей,
//  Организация			 - СправочникСсылка.Организации	 - организация, для которой определяются ответственные лица.
// 
// Возвращаемое значение:
//  Структура - см. СведенияОПодписяхДокументов.
//
Функция СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(МетаданныеОбъекта, Организация) Экспорт 

	ОписаниеПодписей = ОписаниеПодписейОбъектаПоМетаданным(МетаданныеОбъекта);
	Возврат СведенияОПодписяхДокументов(ОписаниеПодписей, Организация);

КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.РегистрыСведений.ОснованияПолномочийОтветственныхЛиц, Истина);
	
КонецПроцедуры

#КонецОбласти

// Получает сведения об используемости функциональности хранения основания полномочий.
//
Функция ИспользоватьОснованияПолномочий() Экспорт

	ИспользоватьОснованияПолномочий = Ложь;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ПодписиДокументовОснованияПолномочий") Тогда
		МодульПодписиДокументовОснованияПолномочий = ОбщегоНазначения.ОбщийМодуль("ПодписиДокументовОснованияПолномочий");
		МодульПодписиДокументовОснованияПолномочий.УстановитьИспользованиеОснованияПолномочий(ИспользоватьОснованияПолномочий);
	КонецЕсли;

	Возврат ИспользоватьОснованияПолномочий;

КонецФункции

// Возвращает структуру с полями "ОснованиеПодписи" и "Должность"
//
Функция ОснованияПолномочийФизическихЛиц(Организация, ФизическиеЛица) Экспорт 
	
	ВозвращаемоеСоответствие = Новый Соответствие;
	
	Если ТипЗнч(ФизическиеЛица) <> Тип("Массив") Тогда
		Если ЗначениеЗаполнено(ФизическиеЛица) Тогда
			ФизическиеЛицаМассив = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическиеЛица);
		Иначе
			ФизическиеЛицаМассив = Новый Массив;
		КонецЕсли;
	Иначе
		ФизическиеЛицаМассив = ФизическиеЛица;
	КонецЕсли;
	
	Если ФизическиеЛицаМассив.Количество() = 0 Тогда
		Возврат ВозвращаемоеСоответствие;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
		|	ЕСТЬNULL(ОснованияПолномочийОтветственныхЛиц.ОснованиеПодписи, """") КАК ОснованиеПодписи,
		|	ЕСТЬNULL(ОснованияПолномочийОтветственныхЛиц.Должность, ЗНАЧЕНИЕ(Справочник.Должности.ПустаяСсылка)) КАК Должность
		|ИЗ
		|	Справочник.ФизическиеЛица КАК ФизическиеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|		ПО ФизическиеЛица.Ссылка = ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо
		|			И (ОснованияПолномочийОтветственныхЛиц.Организация = &Организация)
		|ГДЕ
		|	ФизическиеЛица.Ссылка В(&ФизическиеЛица)";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ФизическиеЛица", ФизическиеЛицаМассив);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	ФизическиеЛицаБезДолжностей = Новый Массив;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		СтруктураРеквизитов = Новый Структура("Должность, ОснованиеПодписи");
		
		Если ЗначениеЗаполнено(Выборка.Должность) Тогда
			СтруктураРеквизитов.Должность = Выборка.Должность;
			СтруктураРеквизитов.ОснованиеПодписи = Выборка.ОснованиеПодписи;
		Иначе
			ФизическиеЛицаБезДолжностей.Добавить(Выборка.ФизическоеЛицо);
		КонецЕсли;
		
		ВозвращаемоеСоответствие.Вставить(Выборка.ФизическоеЛицо, СтруктураРеквизитов);
	КонецЦикла;
	
	ЗаполнитьДолжностиФизическихЛицПоКадровомуУчету(ВозвращаемоеСоответствие, ФизическиеЛицаБезДолжностей, Организация);
	
	Возврат ВозвращаемоеСоответствие;
	
КонецФункции

// АПК:299-выкл используется в расширенной версии библиотеки.

// Создает временную таблицу с данными об основаниях полномочий физических лиц.
//
Процедура СоздатьВТОснованияПолномочийФизическихЛиц(МенеджерВременныхТаблиц, ИмяОтбора = "ВТОрганизацииФизическиеЛица") Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОснованияПолномочийОтветственныхЛиц.Организация КАК Организация,
		|	ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ОснованияПолномочийОтветственныхЛиц.Должность КАК Должность,
		|	ОснованияПолномочийОтветственныхЛиц.ОснованиеПодписи КАК ОснованиеПодписи
		|ПОМЕСТИТЬ ВТОснованияПолномочийФизическихЛиц
		|ИЗ
		|	РегистрСведений.ОснованияПолномочийОтветственныхЛиц КАК ОснованияПолномочийОтветственныхЛиц
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ #ВТОрганизацииФизическиеЛица КАК ОрганизацииФизическиеЛица
		|		ПО ОснованияПолномочийОтветственныхЛиц.Организация = ОрганизацииФизическиеЛица.Организация
		|			И ОснованияПолномочийОтветственныхЛиц.ФизическоеЛицо = ОрганизацииФизическиеЛица.ФизическоеЛицо";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТОрганизацииФизическиеЛица", ИмяОтбора);
	
	Запрос.Выполнить();
		
КонецПроцедуры

// АПК:299-вкл

// См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.8.28";
	Обработчик.Процедура = "РегистрыСведений.ОснованияПолномочийОтветственныхЛиц.ЗаполнитьДолжностиФизическихЛицИзОтветственныхЛиц";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("5767a146-6116-44cf-873e-073b24491869");
	Обработчик.Комментарий = НСтр("ru = 'Заполнение реквизита Должность в основаниях полномочий из сведений об ответственных лицах.'");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОписаниеПодписей

// Возвращает соответствие поддерживаемых в системе ролей подписантов.
//
Функция ПредопределенныеИдентификаторыОписанийПодписей()
	Возврат ПодписиДокументовПовтИсп.ПредопределенныеИдентификаторыОписанийПодписей();
КонецФункции

// Возвращает массив поддерживаемых имен идентификаторов ответственных лиц организаций.
//
Функция ПоддерживаемыеРеквизитыОтветственныхРаботниковОрганизаций()

	ПоддерживаемыеИдентификаторы = Новый Массив;
	
	МассивИдентификаторов = ПредопределенныеИдентификаторыОписанийПодписей();
	ПредопределенныеИдентификаторы = СоответствиеИдентификаторовИзМассиваИдентификаторов(МассивИдентификаторов);
	
	Для Каждого ОписаниеРеквизитовПодписанта Из ПредопределенныеИдентификаторы Цикл
		Для Каждого ОписаниеРеквизитаПодписанта Из ОписаниеРеквизитовПодписанта.Значение Цикл
			ПоддерживаемыеИдентификаторы.Добавить(ОписаниеРеквизитаПодписанта.Значение);
		КонецЦикла;
	КонецЦикла; 

	Возврат ОбщегоНазначенияКлиентСервер.СвернутьМассив(ПоддерживаемыеИдентификаторы);
	
КонецФункции

// Добавляет описание подписи
//
Процедура ДобавитьОписаниеПодписи(ОписаниеПодписей, ОписаниеИменРеквизитов, РольПодписанта = Неопределено, ИмяРеквизитаОрганизация = "Организация") Экспорт

	Если РольПодписанта = Неопределено Тогда
		РольПодписанта = ОписаниеИменРеквизитов.ФизическоеЛицо;
	КонецЕсли;
	
	// Удаляем существующие строки с этой ролью.
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Организация", ИмяРеквизитаОрганизация);
	СтруктураПоиска.Вставить("РольПодписанта", РольПодписанта);
	
	СтрокиКУдалению = ОписаниеПодписей.НайтиСтроки(СтруктураПоиска);
	Для Каждого УдаляемаяСтрока Из СтрокиКУдалению Цикл
		ОписаниеПодписей.Удалить(УдаляемаяСтрока);
	КонецЦикла; 
	
	// Добавляем новую.
	
	НоваяСтрока = ОписаниеПодписей.Добавить();
	
	НоваяСтрока.Организация = ИмяРеквизитаОрганизация;
	НоваяСтрока.РольПодписанта = РольПодписанта;
	НоваяСтрока.ФизическоеЛицо = ОписаниеИменРеквизитов.ФизическоеЛицо;
	НоваяСтрока.Должность = ОписаниеИменРеквизитов.Должность;
	НоваяСтрока.ОснованиеПодписи = ОписаниеИменРеквизитов.ОснованиеПодписи;
	
КонецПроцедуры

// Возвращает соответствие с ролями подписантов структурами имен их реквизитов.
//
Функция ОписаниеИменПодписантовОбъекта(МассивРолей, ПереопределяемыеИменаРеквизитов = Неопределено)

	ОписаниеИменРеквизитов = Новый Соответствие;
	
	МассивИдентификаторов = ПредопределенныеИдентификаторыОписанийПодписей();
	ПредопределенныеОписания = СоответствиеИдентификаторовИзМассиваИдентификаторов(МассивИдентификаторов);
	
	ОписанияРолей = ОбщегоНазначения.СкопироватьРекурсивно(ПредопределенныеОписания);
	
	Для Каждого ИмяРоли Из МассивРолей Цикл
		ОписаниеИменРеквизитовРоли = ОписанияРолей.Получить(ИмяРоли);
		Если ОписаниеИменРеквизитовРоли = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПереопределяемыеИменаРеквизитов <> Неопределено Тогда
			ПереопределитьОписаниеПодписанта(ОписаниеИменРеквизитовРоли, ПереопределяемыеИменаРеквизитов.Получить(ИмяРоли));
		КонецЕсли;
		
		ОписаниеИменРеквизитов.Вставить(ИмяРоли, ОписаниеИменРеквизитовРоли);
	КонецЦикла; 
	
	Возврат ОписаниеИменРеквизитов;

КонецФункции

#КонецОбласти

Процедура ЗаписатьОснованияПолномочийОтветственныхЛиц(Организация, ФизическоеЛицо, ОснованиеПодписи, Должность) Экспорт 

	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.ОснованияПолномочийОтветственныхЛиц.СоздатьМенеджерЗаписи();
	
	МенеджерЗаписи.Организация = Организация;
	МенеджерЗаписи.ФизическоеЛицо = ФизическоеЛицо;
	МенеджерЗаписи.ОснованиеПодписи = ОснованиеПодписи;
	МенеджерЗаписи.Должность = Должность;
	
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Возвращает таблицу значений, заполненную ролям подписантов в объекте (документе).
// Формат таблицы значений - см. ОписаниеТаблицыПодписей()
//
Функция ТаблицаОписанийПодписейОбъекта(Ссылка) Экспорт
	Возврат ТаблицаОписанийПодписейПоМетаданным(Ссылка.Метаданные());
КонецФункции

// Функция создает соответствие описаний имен реквизитов из переданной структуры реквизитов
//
Функция СоответствиеОписанийИменРеквизитовПоСтруктуре(ЗаполняемыеЗначения, Организация)
	
	ЗаполненныеИдентификаторы = Новый Соответствие;
	
	Если ЗаполняемыеЗначения.Количество() = 0 Тогда
		Возврат ЗаполненныеИдентификаторы;
	КонецЕсли;
	
	ИдентификаторыКЗаполнению = Новый Массив;
	Для Каждого КлючИЗначение Из ЗаполняемыеЗначения Цикл
		Если Не ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
			ИдентификаторыКЗаполнению.Добавить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	// Дополняем идентификаторы теми, значения которых можно получить из ПодписейДокументов
	ЗаполнитьСоответствиеИдентификаторамиОтветственныхЛицОрганизаций(ИдентификаторыКЗаполнению, ЗаполненныеИдентификаторы);
	
	// На тот случай, если в настройках оказались какие-то роли, отличающиеся от предопределенных,
	ДополнитьСоответствиеИдентификаторамиИзНастроек(ИдентификаторыКЗаполнению, ЗаполненныеИдентификаторы, Организация);
	
	Возврат ЗаполненныеИдентификаторы;

КонецФункции

Процедура ЗаполнитьСоответствиеИдентификаторамиОтветственныхЛицОрганизаций(ОбрабатываемыеИдентификаторы, ЗаполненныеИдентификаторы)

	ИдентификаторыОтветственныхЛицОрганизаций = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.СведенияОбОтветственныхЛицах") Тогда
		МодульСведенияОбОтветственныхЛицах = ОбщегоНазначения.ОбщийМодуль("СведенияОбОтветственныхЛицах");
		ИдентификаторыОтветственныхЛицОрганизаций = МодульСведенияОбОтветственныхЛицах.ПоддерживаемыеИдентификаторыОтветственныхЛицОрганизаций();
	КонецЕсли;
	
	Если ИдентификаторыОтветственныхЛицОрганизаций = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Описание Из ИдентификаторыОтветственныхЛицОрганизаций Цикл
		Если ОбрабатываемыеИдентификаторы.Найти(Описание.Ключ) = Неопределено Тогда // идентификатор не заказан.
			Продолжить;
		КонецЕсли;
		Если ЗаполненныеИдентификаторы.Получить(Описание.Ключ) <> Неопределено Тогда // идентификатор уже заполнен.
			Продолжить;
		КонецЕсли;
		
		СтруктураИменРеквизитов = ОписаниеРеквизитовПодписанта();
		ЗаполнитьЗначенияСвойств(СтруктураИменРеквизитов, Описание.Значение);
		СтруктураИменРеквизитов.ФизическоеЛицо = Описание.Ключ;
		
		ЗаполненныеИдентификаторы.Вставить(Описание.Ключ, СтруктураИменРеквизитов);
	КонецЦикла;

КонецПроцедуры

Процедура ДополнитьСоответствиеИдентификаторамиИзНастроек(ОбрабатываемыеИдентификаторы, ЗаполненныеИдентификаторы, Организация)

	НастройкиОрганизации = НастройкиПодписейДокументовПользователяПоОрганизации(Организация);
	Если НастройкиОрганизации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого СтруктураНастроек Из НастройкиОрганизации Цикл
		Если ОбрабатываемыеИдентификаторы.Найти(СтруктураНастроек.Ключ) = Неопределено Тогда // идентификатор не заказан.
			Продолжить;
		КонецЕсли;
		Если ЗаполненныеИдентификаторы.Получить(СтруктураНастроек.Ключ) <> Неопределено Тогда // идентификатор уже заполнен.
			Продолжить;
		КонецЕсли;
		
		// Описателя триады реквизитов нет, формируем шаблонные наименования реквизитов.
		СтруктураИменРеквизитов = ОписаниеРеквизитовПодписанта();
		СтруктураИменРеквизитов.ФизическоеЛицо = СтруктураНастроек.Ключ;
		СтруктураИменРеквизитов.Должность = СтруктураНастроек.Ключ + "Должность";
		СтруктураИменРеквизитов.ОснованиеПодписи = СтруктураНастроек.Ключ + "ОснованиеПодписи";
		
		ЗаполненныеИдентификаторы.Вставить(СтруктураНастроек.Ключ, СтруктураИменРеквизитов);
	КонецЦикла;

КонецПроцедуры

// Функция заполняет структуру реквизитов из переданной структуры со значениями реквизитов
//
Процедура ЗаполнитьСтруктуруЗаполняемыхЗначений(ЗаполняемыеЗначения, СведенияОПодписях)

	// Заполняем форму полученными значениями
	Для Каждого ЗначениеРеквизитаПодписанта Из СведенияОПодписях Цикл // Цикл по ролям подписантов
		Если ЗаполняемыеЗначения.Свойство(ЗначениеРеквизитаПодписанта.Ключ) Тогда
			ЗаполняемыеЗначения[ЗначениеРеквизитаПодписанта.Ключ] = ЗначениеРеквизитаПодписанта.Значение;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьСведенияПоФизическимЛицамВПодписяхДокументов(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов)

	// Сведения об ответственных лицах.
	ЗаполнитьФизическихЛицВПодписяхПоСведениямОбОтветственныхЛицахОрганизации(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов);
	
	// Смотрим настройки пользователя.
	ЗаполнитьФизическихЛицВПодписяхИзНастроекПользователя(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов);
	
КонецПроцедуры

// Читает из настроек пользователя физическое лицо по переданной роли и заполняет им значение переданной структуры.
// Ключ структуры - имя реквизита объекта (не роль)
//
Процедура ЗаполнитьФизическихЛицВПодписяхИзНастроекПользователя(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов)

	НастройкиОрганизации = НастройкиПодписейДокументовПользователяПоОрганизации(Организация);
	Если НастройкиОрганизации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОписаниеПолейПодписанта Из ОписаниеПолейПодписантов Цикл
		РольПодписанта = ОписаниеПолейПодписанта.Ключ;
		ИмяРеквизитаФизическоеЛицоОбъекта = ОписаниеПолейПодписанта.Значение.ФизическоеЛицо;
		
		// Читаем настройки пользователя
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(НастройкиОрганизации, РольПодписанта);
		Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияПодписейДокументов.Вставить(ИмяРеквизитаФизическоеЛицоОбъекта, ФизическоеЛицо);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьФизическихЛицВПодписяхПоСведениямОбОтветственныхЛицахОрганизации(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов)
		
	МассивРолейПодписантов = ОбщегоНазначения.ВыгрузитьКолонку(ОписаниеПолейПодписантов, "Ключ", Истина);
	СтрокаСведений = СтрСоединить(МассивРолейПодписантов, ",");

	ОтветственныеЛица = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.СведенияОбОтветственныхЛицах") Тогда
		МодульСведенияОбОтветственныхЛицах = ОбщегоНазначения.ОбщийМодуль("СведенияОбОтветственныхЛицах");
		ОтветственныеЛица = МодульСведенияОбОтветственныхЛицах.ОтветственныеЛицаОрганизации(Организация, СтрокаСведений);
	КонецЕсли;
	
	Если ОтветственныеЛица = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ОписаниеПолейПодписанта Из ОписаниеПолейПодписантов Цикл
		РольПодписанта = ОписаниеПолейПодписанта.Ключ;
		ИмяРеквизитаФизическоеЛицоОбъекта = ОписаниеПолейПодписанта.Значение.ФизическоеЛицо;
		
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ОтветственныеЛица, РольПодписанта);
		Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначенияПодписейДокументов.Вставить(ИмяРеквизитаФизическоеЛицоОбъекта, ФизическоеЛицо);
	КонецЦикла; 

КонецПроцедуры

Процедура ЗаполнитьСведенияПоОснованиямПолномочийВПодписяхДокументов(ОписаниеПолейПодписантов, Организация, ЗначенияПодписейДокументов)

	// Подготовим массив заполненных физических лиц.
	МассивФизическихЛиц = Новый Массив;
	Для Каждого ОписаниеПолейПодписанта Из ОписаниеПолейПодписантов Цикл
		СтруктураИменРеквизитовОбъекта = ОписаниеПолейПодписанта.Значение;
		
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЗначенияПодписейДокументов, СтруктураИменРеквизитовОбъекта.ФизическоеЛицо);
		Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
			МассивФизическихЛиц.Добавить(ФизическоеЛицо);
		КонецЕсли;
	КонецЦикла;	
	
	// Запросим данные
	ЗначенияОснованийПолномочийФизическихЛиц = ОснованияПолномочийФизическихЛиц(Организация, МассивФизическихЛиц);
	
	// Заполним значения подписей
	Для Каждого ОписаниеПолейПодписанта Из ОписаниеПолейПодписантов Цикл
		СтруктураИменРеквизитовОбъекта = ОписаниеПолейПодписанта.Значение;
		
		ФизическоеЛицо = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ЗначенияПодписейДокументов, СтруктураИменРеквизитовОбъекта.ФизическоеЛицо);
		ДанныеФизическогоЛица = ЗначенияОснованийПолномочийФизическихЛиц.Получить(ФизическоеЛицо);
		
		Если ДанныеФизическогоЛица = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеФизическогоЛица.Должность) Тогда
			ЗначенияПодписейДокументов.Вставить(СтруктураИменРеквизитовОбъекта.Должность, ДанныеФизическогоЛица.Должность);
		КонецЕсли;
		Если ЗначениеЗаполнено(ДанныеФизическогоЛица.ОснованиеПодписи) Тогда
			ЗначенияПодписейДокументов.Вставить(СтруктураИменРеквизитовОбъекта.ОснованиеПодписи, ДанныеФизическогоЛица.ОснованиеПодписи);
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры

Функция НастройкиПодписейДокументовПользователяПоОрганизации(Организация)
	
	НастройкиПодписей = НастройкиПодписейДокументовПользователя();
	Возврат НастройкиПодписей.Получить(Организация);
	
КонецФункции

Процедура ЗаполнитьДолжностиФизическихЛицПоКадровомуУчету(ДанныеПолномочий, МассивФизическихЛиц, Организация)

	ДолжностиПоКадровомуУчету = ДолжностиФизическихЛицПоКадровомуУчету(МассивФизическихЛиц, Организация);
	
	Для Каждого ДолжностьФизическогоЛица Из ДолжностиПоКадровомуУчету Цикл
		ДанныеПолномочий[ДолжностьФизическогоЛица.Ключ].Должность = ДолжностьФизическогоЛица.Значение;
	КонецЦикла; 

КонецПроцедуры

Функция ДолжностиФизическихЛицПоКадровомуУчету(МассивФизическихЛиц, Организация)

	ДолжностиФизическихЛиц = Новый Соответствие;
	
	ТаблицаСотрудников = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(МассивФизическихЛиц, Истина, Организация, ТекущаяДатаСеанса());
	Если ТаблицаСотрудников.Количество() = 0 Тогда
		Возврат ДолжностиФизическихЛиц;
	КонецЕсли;
	
	ТаблицаКадровыхДанных = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ТаблицаСотрудников.ВыгрузитьКолонку("Сотрудник"), "Должность", ТекущаяДатаСеанса());
	Для Каждого СтрокаТаблицы Из ТаблицаКадровыхДанных Цикл
		ДолжностиФизическихЛиц.Вставить(СтрокаТаблицы.ФизическоеЛицо, СтрокаТаблицы.Должность);
	КонецЦикла; 
	
	Возврат ДолжностиФизическихЛиц;

КонецФункции

Функция СоответствиеИдентификаторовИзМассиваИдентификаторов(МассивИдентификаторов)

	СоответствиеИдентификаторов = Новый Соответствие;
	
	Для Каждого СоответствиеИдентификатор Из МассивИдентификаторов Цикл
		Для Каждого КлючИЗначение Из СоответствиеИдентификатор Цикл
			СоответствиеИдентификаторов.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла; 
	КонецЦикла; 
	
	Возврат СоответствиеИдентификаторов;

КонецФункции

// Возвращает таблицу значений, заполненную ролям подписантов в объекте (документе).
// Формат таблицы значений - см. ОписаниеТаблицыПодписей()
//
Функция ТаблицаОписанийПодписейПоМетаданным(МетаданныеОбъекта)
	
	ИмяОбъекта = МетаданныеОбъекта.Имя;
	
	ПолноеИмя = МетаданныеОбъекта.ПолноеИмя();
	ИмяТипаОбъекта = Лев(ПолноеИмя, СтрНайти(ПолноеИмя, ".") - 1);
	
	Если ИмяТипаОбъекта = "Справочник" Тогда
		ИмяТипаМетаданных = "Справочники";
	ИначеЕсли ИмяТипаОбъекта = "Документ" Тогда
		ИмяТипаМетаданных = "Документы";
	КонецЕсли;
	
	Возврат ПодписиДокументовПовтИсп.ОписаниеПодписейДокументаПоИмениОбъекта(ИмяОбъекта,  ИмяТипаОбъекта, ИмяТипаМетаданных);
	
КонецФункции

// Возвращает таблицу значений, заполненную ролям подписантов в объекте (документе).
//
Функция ОписаниеПодписейОбъектаПоМетаданным(МетаданныеОбъекта)
	
	ТаблицаОписаний = ТаблицаОписанийПодписейПоМетаданным(МетаданныеОбъекта);
	МассивСтруктурОписаний = ОбщегоНазначения.ТаблицаЗначенийВМассив(ТаблицаОписаний);
	
	ОписаниеПодписей = СоответствиеОписанийИзКоллекцииОписаний(МассивСтруктурОписаний);
	
	Возврат ОписаниеПодписей;
	
КонецФункции

// Функция возвращает структуру значений подписей документов по переданному описанию имен реквизитов
// 
// Параметры:
//  ОписаниеПодписей - Соответствие
//		* ключ			- имена ролей подписантов
//		* значение		- структура, содержащая 3 поля - "ФизическоеЛицо", "ОписаниеПолномочий", "Должность",
//							в которых содержатся имена переменных для возвращаемых значений реквизитов подписантов.
//
//  Организация - СправочникСсылка.Организации - организация, по которой будут получаться значения.
//
// Возвращаемое значение:
//  Структура - содержит имена (ключи) и значения затребованных реквизитов.
//
Функция СведенияОПодписяхДокументов(ОписаниеПодписей, Организация) Экспорт

	ЗначенияПодписей = Новый Структура;
	
	Если ОписаниеПодписей = Неопределено Или ОписаниеПодписей.Количество() = 0 Тогда
		Возврат ЗначенияПодписей;
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	
	ЗарплатаКадры.ЗаполнитьСведенияОПодписяхДокументов(ОписаниеПодписей, Организация, ЗначенияПодписей, СтандартнаяОбработка);
	ПодписиДокументовПереопределяемый.ЗаполнитьСведенияОПодписяхДокументов(ОписаниеПодписей, Организация, ЗначенияПодписей, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат ЗначенияПодписей;
	КонецЕсли;
	
	ЗаполнитьСведенияПоФизическимЛицамВПодписяхДокументов(ОписаниеПодписей, Организация, ЗначенияПодписей);
	ЗаполнитьСведенияПоОснованиямПолномочийВПодписяхДокументов(ОписаниеПодписей, Организация, ЗначенияПодписей);
	
	Возврат ЗначенияПодписей;

КонецФункции

Функция НастройкиПодписейДокументовПользователя() Экспорт 

	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПользователя", "ПодписиДокументов", Новый Соответствие);
	
КонецФункции

Процедура ПереопределитьОписаниеПодписанта(ОписаниеИменРеквизитовРоли, ПереопределяемыеИменаРеквизитовРоли)

	Если ПереопределяемыеИменаРеквизитовРоли = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ОписаниеРеквизита Из ПереопределяемыеИменаРеквизитовРоли Цикл
		Если ОписаниеИменРеквизитовРоли.Свойство(ОписаниеРеквизита.Ключ) Тогда
			ОписаниеИменРеквизитовРоли[ОписаниеРеквизита.Ключ] = ОписаниеРеквизита.Значение;
		КонецЕсли;
	КонецЦикла; 

КонецПроцедуры

Функция СоответствиеОписанийИзКоллекцииОписаний(КоллекцияОписанийРеквизитов, ПрефиксИменРеквизитов = "")

	Возврат ПодписиДокументовКлиентСервер.СоответствиеОписанийИзКоллекцииОписаний(КоллекцияОписанийРеквизитов, ПрефиксИменРеквизитов);
	
КонецФункции

#КонецОбласти