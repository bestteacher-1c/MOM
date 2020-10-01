
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПереоценкаОС2_4") Тогда
		ЗаполнитьНаОснованииПереоценки(ДанныеЗаполнения);
	КонецЕсли;
	
	ПереоценкаОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, НепроверяемыеРеквизиты, Отказ);
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект,, НепроверяемыеРеквизиты, Отказ);
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПереоценкаОС(
									ЭтотОбъект, ВспомогательныеРеквизиты());
									
	ВнеоборотныеАктивыСлужебный.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, НепроверяемыеРеквизиты);
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	ПереоценкаОСЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	ПереоценкаОСЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ПереоценкаОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
	ПереоценкаОСЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументВДругомУчете = Неопределено;
	
	ИнициализироватьДокумент();
	
	ПереоценкаОСЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПереоценкаОС2_4.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПереоценкаОСЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПереоценкаОСЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	
КонецПроцедуры

Процедура ЗаблокироватьЧитаемыеДанные()

	// Нужно заблокировать данные, которые используются при записи движений.
	// Например, данные регистров сведений, которые используются для заполнения недостающих ресурсов.
	
	Блокировка = Новый БлокировкаДанных;
	
	Если ОтражатьВУпрУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
	КонецЕсли; 
	
	ПереоценкаОСЛокализация.ДополнитьБлокировкуДанныхПриПроведении(ЭтотОбъект, Блокировка);
	
	Блокировка.Заблокировать(); 
	
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
	
	РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ЭтоГруппа");
	
	Если РеквизитыОснования.ЭтоГруппа Тогда
		
		ТекстСообщения = НСтр("ru = 'Переоценка на основании группы ОС невозможно.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиОСНеПринятоКУчету(Основание, Дата);

	МестонахождениеОС = ВнеоборотныеАктивы.МестонахождениеОС(Основание);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, МестонахождениеОС);
	Подразделение = МестонахождениеОС.Местонахождение;
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииПереоценки(Основание, ОсновноеСредство = Неопределено)

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
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ПереоценкаОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ВнеоборотныеАктивыКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС");

КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ИспользоватьОбъектыСтроительства", ПолучитьФункциональнуюОпцию("ИспользоватьОбъектыСтроительства"));
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	МодернизацияОСЛокализация.ДополнитьВспомогательныеРеквизиты(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецЕсли
