////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки КомплекснаяАвтоматизация.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область СведенияОБиблиотекеИлиКонфигурации

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "КомплекснаяАвтоматизация";
	Описание.Версия = "2.4.12.64";
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	Описание.ИдентификаторИнтернетПоддержки = "ARAutomation";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновленияИнформационнойБазы

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.МонопольныйРежим    = Ложь;
//
// Параметры:
//  Обработчики - ТаблицаЗначений - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	ВнеоборотныеАктивыЛокализация.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ВводОстатковВнеоборотныхАктивов2_4.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ВозвратОСОтАрендатора2_4.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ВыкупТоваровХранителем.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ИнвентаризацияОС.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ОтражениеЗарплатыВФинансовомУчете.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПередачаОСАрендатору2_4.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПеремещениеОС2_4.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПоступлениеТоваровОтХранителя.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПринятиеКУчетуОС2_4.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ПроизводствоБезЗаказа.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.РаспределениеПрочихЗатрат.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.СписаниеТоваровУХранителя.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.ТаможеннаяДекларацияЭкспорт.ПриДобавленииОбработчиковОбновления(Обработчики);
	Документы.УведомлениеОКонтролируемыхСделках.ПриДобавленииОбработчиковОбновления(Обработчики);
	ОбновлениеИнформационнойБазыКА.ПриДобавленииОбработчиковОбновленияКА(Обработчики);
	РегистрыНакопления.ВыпускПродукции.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыНакопления.СебестоимостьТоваров.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыНакопления.ТоварыКПоступлению.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ДокументыПоОС.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.МестонахождениеОС.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ПервоначальныеСведенияОС.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.ПервоначальныеСведенияОСБухгалтерскийУчет.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СобытияОСОрганизаций.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СостоянияОСОрганизаций.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СтатусыПроверкиДокументов.ПриДобавленииОбработчиковОбновления(Обработчики);
	РегистрыСведений.СчетаБухгалтерскогоУчетаОС.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ВидыБюджетов.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ОбъектыЭксплуатации.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.ПравилаЛимитовПоДаннымБюджетирования.ПриДобавленииОбработчиковОбновления(Обработчики);
	Справочники.РесурсныеСпецификации.ПриДобавленииОбработчиковОбновления(Обработчики);

КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - (возвращаемое значение) если установить Истина,
//                                то будет выведена форма с описанием обновлений. По умолчанию, Истина.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
		ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "КомплекснаяАвтоматизация";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.ОбновлениеУТДоКА";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
	Обработчик.Процедура = "Справочники.НастройкиХозяйственныхОпераций.ЗаполнитьПредопределенныеНастройкиХозяйственныхОпераций";
	
	ДобавитьОбработчикиНачальногоЗаполненияЗарплаты(Обработчики);
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	
	Если ПредыдущееИмяКонфигурации = "УправлениеТорговлей" Тогда
		Параметры.ОчиститьСведенияОПредыдущейКонфигурации = Ложь;
		ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ(ПредыдущееИмяКонфигурации, ПредыдущаяВерсияКонфигурации, Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПереименованныеОбъектыМетаданных

// Заполняет переименования объектов метаданных (подсистемы и роли).
// Подробнее см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных().
// 
// Параметры:
//   Итог	- Структура - передается в процедуру подсистемой БазоваяФункциональность.
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	ОписаниеПодсистемы = Новый Структура("Имя, Версия, РежимВыполненияОтложенныхОбработчиков, ИдентификаторИнтернетПоддержки");
	ПриДобавленииПодсистемы(ОписаниеПодсистемы);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.19",
		"Роль.РазделПроизводство",
		"Роль.ПодсистемаПроизводство",
		ОписаниеПодсистемы.Имя);
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.59",
		"Подсистема.Производство.Подсистема.МежцеховоеУправление",
		"Подсистема.Производство.Подсистема.МежцеховоеУправление2_1",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.59",
		"Подсистема.Производство.Подсистема.ВнутрицеховоеУправление",
		"Подсистема.Производство.Подсистема.ВнутрицеховоеУправление2_1",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.59",
		"Подсистема.Производство.Подсистема.МатериальныйУчет",
		"Подсистема.Производство.Подсистема.МатериальныйУчет2_1",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.69",
		"Роль.ПроверкаДокументовПравоИзменения",
		"Роль.ИзменениеРазрешатьИзменятьПроверенныеДокументыПоРеглУчету",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.72",
		"Подсистема.Производство.Подсистема.ПроизводственныеЗатраты",
		"Подсистема.Производство.Подсистема.ПроизводственныеЗатраты2_1",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.1.1.72",
		"Подсистема.Производство.Подсистема.АнализСебестоимости",
		"Подсистема.Производство.Подсистема.АнализСебестоимости2_1",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.2.32",
		"Роль.ДобавлениеИзменениеПогашенийСтомостиТМЦВЭксплуатации",
		"Роль.ДобавлениеИзменениеПогашенийСтоимостиТМЦВЭксплуатации",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.7.14",
		"Роль.ИзменениеРазрешатьИзменятьПроверенныеДокументыПоРеглУчету",
		"Роль.ИзменениеСтатусыПроверкиДокументов",
		ОписаниеПодсистемы.Имя);
		
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.8.1",
		"Роль.ДобавлениеИзменениеРегистрацийНаработок",
		"Роль.ДобавлениеИзменениеНаработкиОбъектовЭксплуатации",
		ОписаниеПодсистемы.Имя);	
	
	ОбщегоНазначения.ДобавитьПереименование(Итог,
		"2.4.8.1",
		"Роль.ДобавлениеИзменениеРегистрацийНаработокТМЦВЭксплуатации",
		"Роль.ДобавлениеИзменениеНаработкиТМЦВЭксплуатации",
		ОписаниеПодсистемы.Имя);	
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаполненияПустойИБ

// Обработчик первого запуска КА.
//
Процедура ПервыйЗапуск() Экспорт
	
	УстановитьВалютуПлановыхЦен();
	УстановитьВалютуРасценокВидовРабот();
	
	ЗаполнитьКонстантуИспользоватьБюджетирование();
	ЗаполнитьКонстантуИспользоватьРеглУчет();
	ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ЗаполнитьПредопределенныеАналитикиСтатейБюджетов();
	УправлениеДоступомЛокализация.УстановитьРодителяПрофилейДоступаЗарплатаИКадры();
	Справочники.ТипыПлатежейФЗ275.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ВидыПодтверждающихДокументов.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
	ПланыСчетов.Хозрасчетный.ЗаполнитьПредопределенныеНастройки();
	Константы.ЗаполненыДвиженияАктивовПассивов.Установить(Истина);
	Константы.ИспользоватьВнеоборотныеАктивы2_4.Установить(Истина);
	Константы.ПорядокУчетаВНАВУпрУчете.Установить(Перечисления.ПорядокУчетаВНАВУпрУчете.ПоСтандартамМУ);
	
КонецПроцедуры

Процедура ОбновлениеУТДоКА() Экспорт
	
	ПланыВидовХарактеристик.АналитикиСтатейБюджетов.ЗаполнитьПредопределенныеАналитикиСтатейБюджетов();
	УправлениеДоступомЛокализация.УстановитьРодителяПрофилейДоступаЗарплатаИКадры();
	Справочники.ТипыПлатежейФЗ275.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ВидыПодтверждающихДокументов.ЗаполнитьПредопределенныеЭлементы();
	Справочники.ДрагоценныеМатериалы.ЗаполнитьПредопределенныеДрагоценныеМатериалы();
	ПланыСчетов.Хозрасчетный.ЗаполнитьПредопределенныеНастройки();
	Константы.ЗаполненыДвиженияАктивовПассивов.Установить(Истина);
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЗначениеРазделенияПоОбластямДанных();
	
	ЗначенияКонстант = Новый Структура;
	ЗначенияКонстант.Вставить("УправлениеТорговлей", Ложь);
	ЗначенияКонстант.Вставить("КомплекснаяАвтоматизация", Истина);
	
	Для Каждого КлючИЗначение Из ЗначенияКонстант Цикл
		Константы[КлючИЗначение.Ключ].Установить(КлючИЗначение.Значение);
	КонецЦикла; 
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

// Обработчики инициализации зарплатной подсистемы при переходе с УТ
Процедура ДобавитьОбработчикиНачальногоЗаполненияЗарплаты(Обработчики)
	
	ВсеОбработчикиЗарплаты = ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления();
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПриДобавленииОбработчиковОбновления(ВсеОбработчикиЗарплаты);
	ОбновлениеИнформационнойБазыЗарплатаКадрыРасширенный.ПриДобавленииОбработчиковОбновления(ВсеОбработчикиЗарплаты);
	
	ОбработчикиНачальногоЗаполнения = ВсеОбработчикиЗарплаты.НайтиСтроки(Новый Структура("НачальноеЗаполнение", Истина));
	Для Каждого ОбработчикНачальногоЗаполнения Из ОбработчикиНачальногоЗаполнения Цикл
		Обработчик = Обработчики.Добавить();
		Обработчик.ПредыдущееИмяКонфигурации = "УправлениеТорговлей";
		Обработчик.Процедура = ОбработчикНачальногоЗаполнения.Процедура;
	КонецЦикла;
	
КонецПроцедуры

// Процедура устанавливает значение валюты плановых цен.
// Вызывается при первоначальном заполнении ИБ.
//
Процедура УстановитьВалютуПлановыхЦен()
	
	Если НЕ ЗначениеЗаполнено(Константы.ВалютаПлановойСебестоимостиПродукции.Получить())
		И Не Константы.ИспользоватьНесколькоВалют.Получить()Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 2
			|	Валюты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Валюты КАК Валюты
			|ГДЕ
			|	НЕ Валюты.ПометкаУдаления");
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				Выборка.Следующий();
				
				Константы.ВалютаПлановойСебестоимостиПродукции.Установить(Выборка.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает значение валюты расценок видов работ.
// Вызывается при первоначальном заполнении ИБ.
//
Процедура УстановитьВалютуРасценокВидовРабот()
	
	Если НЕ ЗначениеЗаполнено(Константы.ВалютаРасценокВидовРабот.Получить())
		И Не Константы.ИспользоватьНесколькоВалют.Получить()Тогда
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 2
			|	Валюты.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Валюты КАК Валюты
			|ГДЕ
			|	НЕ Валюты.ПометкаУдаления");
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				Выборка.Следующий();
				
				Константы.ВалютаРасценокВидовРабот.Установить(Выборка.Ссылка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновленияКА(Обработчики) Экспорт

#Область ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ОбработатьДанныеДляПереходаНаНовуюВерсию

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.4.11.22";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("168df6f8-0609-4308-8d39-f33f28b35cea");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "ОбновлениеИнформационнойБазыКА.ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Установка константы ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах. Влияет на движения в регистре накопления КнигаУчетаДоходовИРасходов для документов ОтчетОРозничныхПродажах (начинает делать движения) и ПриходныйКассовыйОрдер с хозяйственной операцией ПоступлениеДенежныхСредствИзКассыККМ (прекращает делать движения)'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ОтчетОРозничныхПродажах.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Документы.ПриходныйКассовыйОрдер.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.КнигаУчетаДоходовИРасходов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.УчетныеПолитикиОрганизаций.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Константы.ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.УчетныеПолитикиОрганизаций.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

#КонецОбласти

#Область ПервыйЗапуск

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.ПервыйЗапуск";
	Обработчик.Версия = "";
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Комментарий = НСтр("ru = ''");

#КонецОбласти

#Область УстановитьИспользованиеВедомостейПрочихДоходов

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыКА.УстановитьИспользованиеВедомостейПрочихДоходов";
	Обработчик.Версия = "2.4.9.16";
	Обработчик.РежимВыполнения = "Оперативно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("9bba4be1-7b86-47f6-9241-e1a3d85133b7");
	Обработчик.Комментарий = НСтр("ru = 'Включает использование ведомостей прочих доходов при использовании зарплаты'");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");

#КонецОбласти

КонецПроцедуры

// Обработчик первого запуска КА.
// Включает константу "ИспользоватьБюджетирование".
//
Процедура ЗаполнитьКонстантуИспользоватьБюджетирование() Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьБюджетирование.Установить(Истина);
	Константы.ИнтерфейсВерсии82.Установить(Ложь);
	
КонецПроцедуры

// Обработчик первого запуска КА.
// Включает константу "ИспользоватьРеглУчет".
//
Процедура ЗаполнитьКонстантуИспользоватьРеглУчет() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьРеглУчет.Установить(Истина);
	
КонецПроцедуры

// Процедура включает использование ведомостей прочих доходов при обновлении
// в зависимости от использования учета зарплаты.
//
Процедура УстановитьИспользованиеВедомостейПрочихДоходов() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплатыУТ") Тогда
		НаборЗаписей = РегистрыСведений.НастройкиВзаиморасчетовПоПрочимДоходам.СоздатьНаборЗаписей();
		Настройка = НаборЗаписей.Добавить();
		Настройка.ИспользоватьВзаиморасчетыПоПрочимДоходам = Истина;
		Настройка.ИспользоватьВедомостиДляВыплатыПрочихДоходов = Истина;
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

#Область УстановкаКонстанты_ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах

Процедура ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	// Регистрация не требуется
	Возврат;
	
КонецПроцедуры

Процедура ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах_ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МенеджерЗначения = Константы.ДатаНачалаПризнанияДоходовОтчетомОРозничныхПродажах.СоздатьМенеджерЗначения();
	Запрос = Новый Запрос;
	МассивТекстовЗапроса = Новый Массив;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОрганизацииНаУСН.Организация КАК Организация,
	|	ОрганизацииНаУСН.Период КАК НачалоПериода,
	|	МИНИМУМ(ЕСТЬNULL(ОстальныеОрганизации.Период, ДАТАВРЕМЯ(2120, 1, 1))) КАК КонецПериода
	|ПОМЕСТИТЬ ВТДанныеПоОрганизациямНаУСН
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК ОрганизацииНаУСН
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаОрганизаций КАК ОстальныеОрганизации
	|		ПО ОрганизацииНаУСН.Организация = ОстальныеОрганизации.Организация
	|			И ОрганизацииНаУСН.Период < ОстальныеОрганизации.Период
	|			И (НЕ ОстальныеОрганизации.ПрименяетсяУСН)
	|ГДЕ
	|	ОрганизацииНаУСН.ПрименяетсяУСН
	|
	|СГРУППИРОВАТЬ ПО
	|	ОрганизацииНаУСН.Организация,
	|	ОрганизацииНаУСН.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	МАКСИМУМ(ЕСТЬNULL(ВложенныйЗапрос.Дата, ДАТАВРЕМЯ(1,1,1))) КАК Дата
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		МАКСИМУМ(КнигаУчетаДоходовИРасходов.Период) КАК Дата
	|	ИЗ
	|		РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПриходныйКассовыйОрдер КАК ПриходныйКассовыйОрдер
	|			ПО (ПриходныйКассовыйОрдер.Ссылка = КнигаУчетаДоходовИРасходов.Регистратор)
	|				И (ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзКассыККМ)
	|					ИЛИ ПриходныйКассовыйОрдер.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойКассы)
	|						И ПриходныйКассовыйОрдер.КассаОтправитель ССЫЛКА Справочник.КассыККМ)
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		МАКСИМУМ(ОтчетОРозничныхПродажах.Дата)
	|	ИЗ
	|		ВТДанныеПоОрганизациямНаУСН КАК ОрганизациямНаУСН
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|			ПО ОрганизациямНаУСН.Организация = ОтчетОРозничныхПродажах.Организация
	|				И (ОтчетОРозничныхПродажах.Дата >= ОрганизациямНаУСН.НачалоПериода)
	|				И (ОтчетОРозничныхПродажах.Дата < ОрганизациямНаУСН.КонецПериода)) КАК ВложенныйЗапрос";
	МассивТекстовЗапроса.Добавить(ТекстЗапроса);
	Запрос.Текст = СтрСоединить(МассивТекстовЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		НовоеЗначение = ?(ЗначениеЗаполнено(Выборка.Дата), ДобавитьМесяц(НачалоМесяца(Выборка.Дата),1), Выборка.Дата); // начало следующего месяца
		МенеджерЗначения.Значение = НовоеЗначение;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(МенеджерЗначения);
	КонецЕсли;
	Параметры.ОбработкаЗавершена = Истина
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
