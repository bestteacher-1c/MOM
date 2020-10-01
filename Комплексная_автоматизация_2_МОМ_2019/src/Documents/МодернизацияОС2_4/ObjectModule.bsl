
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_МодернизацияОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	МодернизацияОСЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыРеквизитовОбъекта);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыСтроительства") Тогда
		ЗаполнитьНаОснованииОбъектаСтроительства(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.МодернизацияОС2_4") Тогда
		ЗаполнитьНаОснованииМодернизации(ДанныеЗаполнения);
	КонецЕсли;
	
	МодернизацияОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументВДругомУчете = Неопределено;
	Комментарий = "";
	
	ИнициализироватьДокументПередЗаполнением();
	
	МодернизацияОСЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	МодернизацияОСЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.МодернизацияОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	МодернизацияОСЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.МодернизацияОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	МодернизацияОСЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	МодернизацияОСЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа,НаправлениеДеятельности");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Создание модернизации на основании группы ОС невозможно.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиОСНеПринятоКУчету(Основание, Дата);
	
	МестонахождениеОС = ВнеоборотныеАктивы.МестонахождениеОС(Основание);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, МестонахождениеОС);
	Подразделение = МестонахождениеОС.Местонахождение;
	
	НаправлениеДеятельности = РеквизитыОснования.НаправлениеДеятельности;
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ);
	
	Документы.МодернизацияОС2_4.ЗаполнитьСуммуЗатрат(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаСтроительства(Основание)

	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Создание модернизации на основании группы объектов строительства невозможно.
			|Выберите объект строительства. Для раскрытия группы используйте клавиши Ctrl и стрелку внизю'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ВидАналитикиКапитализацииРасходов = Перечисления.ВидыАналитикиКапитализацииРасходов.ОбъектСтроительства;
	ОбъектСтроительства = Основание;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииМодернизации(Основание, ОсновноеСредство = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Для каждого СтрокаОснования Из ОснованиеОбъект.ОС Цикл
			СтрокаТабличнойЧасти = ОС.Добавить();
			СтрокаТабличнойЧасти.ОсновноеСредство = СтрокаОснования.ОсновноеСредство;
		КонецЦикла; 
		ОС.Загрузить(ОснованиеОбъект.ОС.Выгрузить());
	Иначе
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
	КонецЕсли; 
	
	Если ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
		Если ОснованиеОбъект.ОтражатьВРеглУчете Тогда
			ОтражатьВРеглУчете = Ложь;
			ОтражатьВУпрУчете  = Истина;
		Иначе
			ОтражатьВРеглУчете = Истина;
			ОтражатьВУпрУчете  = Ложь;
		КонецЕсли; 
	Иначе	
		ОтражатьВРеглУчете = Истина;
		ОтражатьВУпрУчете  = Истина;
	КонецЕсли;
	
	Документы.МодернизацияОС2_4.ЗаполнитьСуммуЗатрат(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ)

	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	ПроверятьСтоимостьБУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СтоимостьБУ") = Неопределено);
	ПроверятьСтоимостьУУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СтоимостьУУ") = Неопределено);
	
	ПредставлениеРеквизитов = Документы.МодернизацияОС2_4.ПредставлениеРеквизитов();
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""'");
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		НомерСтроки = Формат(ДанныеСтроки.НомерСтроки, "ЧГ=");
		
		Если ПроверятьСтоимостьБУ
			И ДанныеСтроки.СтоимостьБУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СтоимостьБУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьБУ");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
		Если ПроверятьСтоимостьУУ
			И ДанныеСтроки.СтоимостьУУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СтоимостьУУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СтоимостьУУ");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
	КонецЦикла; 
	
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьБУ");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьУУ");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

Процедура ЗаблокироватьЧитаемыеДанные()

	// Нужно заблокировать данные, которые используются при записи движений.
	// Например, данные регистров сведений, которые используются для заполнения недостающих ресурсов.
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Если ОтражатьВУпрУчете Тогда
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	КонецЕсли; 
	
	МодернизацияОСЛокализация.ДополнитьБлокировкуДанныхПриПроведении(ЭтотОбъект, Блокировка);
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПередЗаписью()

	ОчиститьНеиспользуемыеРеквизиты();
	
	Если ОтражатьВУпрУчете И ОтражатьВРеглУчете Тогда
		ДокументВДругомУчете = Неопределено;
	КонецЕсли;
	
	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И Константы.ВалютаУправленческогоУчета.Получить() = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.СтоимостьУУ = ДанныеСтроки.СтоимостьБУ;
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_МодернизацияОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС,ЦелевоеФинансирование");

КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ИспользоватьОбъектыСтроительства", ПолучитьФункциональнуюОпцию("ИспользоватьОбъектыСтроительства"));
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	ВспомогательныеРеквизиты.Вставить(
		"ЕстьУчетСебестоимости", 
		РасчетСебестоимостиПовтИсп.ФормироватьДвиженияПоРегистрамСебестоимости(Дата, Ложь));
	
	МодернизацияОСЛокализация.ДополнитьВспомогательныеРеквизиты(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
