#Область ПрограммныйИнтерфейс

// Вызывается из переопределяемого модуля.
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения()
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт

	//++ Локализация
	УчетНДСУП.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОперацияПоЯндексКассе",                "Дата", "Банк", "БанковскийСчет");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ТМЦВЭксплуатации",            "Период", "СписанияОприходованияТоваров", "Организация");
	
	//++ НЕ УТ
	ДатыЗапретаИзмененияБП.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	ЗарплатаКадры.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);

	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ТаможеннаяДекларацияЭкспорт",              "Дата", "ПродажиВозвратыОтКлиентов", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтчетОператораСистемыПлатон",              "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПриобретениеУслугПоЛизингу",            "Дата", "ЗакупкиВозвратыПоставщикамПеремещенияСборки", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеВЭксплуатации",             "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПогашениеСтоимостиТМЦВЭксплуатации",   "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НаработкаТМЦВЭксплуатации",            "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеИзЭксплуатации",               "Дата", "СписанияОприходованияТоваров", "Организация");

	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыбытиеДенежныхДокументов",				"Дата", "Банк", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеДенежныхДокументов",			"Дата", "Банк", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегламентнаяОперация",					"Дата", "РегламентныеОперации", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеЗатратНаВыпуск",					"Дата", "Производство", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзделияИЗатратыНЗП",						"Дата", "Производство", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыпускПродукции",						"Дата", "Производство", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеМатериаловВПроизводстве",		"Дата", "Производство", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПередачаМатериаловВПроизводство",        "Дата", "СписанияОприходованияТоваров", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратМатериаловИзПроизводства",        "Дата", "СписанияОприходованияТоваров", "Организация");
	
	// Учет ОС и НМА
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АмортизацияНМА",                  "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АмортизацияОС",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВводОстатковВнеоборотныхАктивов", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратОСОтАрендатора",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыработкаНМА",                    "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВыбытиеАрендованныхОС",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзменениеСостоянияОС",            "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияОС",                "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияНМА",               "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзменениеПараметровОС",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзменениеПараметровНМА",          "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.МодернизацияОС",                  "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПередачаОСАрендатору",            "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеОС",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереоценкаНМА",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереоценкаОС",                    "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПодготовкаКПередачеОС",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПодготовкаКПередачеНМА",          "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеАрендованныхОС",       "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПоступлениеПредметовЛизинга",     "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПринятиеКУчетуНМА",               "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПринятиеКУчетуОС",                "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеНМА",                     "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеОС",                      "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РазукомплектацияОС",                 "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияПорядкаНалогообложенияПоНалогуНаИмущество", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияЗемельныхУчастков", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияТранспортныхСредств", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтменаРегистрацииЗемельныхУчастков", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ОтменаРегистрацииТранспортныхСредств", "Дата", "ВнеоборотныеАктивы", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияЗемельныхУчастков",       "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.РегистрацияТранспортныхСредств",     "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АмортизацияНМА2_4",                  "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.АмортизацияОС2_4",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВводОстатковВнеоборотныхАктивов2_4", "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ВозвратОСОтАрендатора2_4",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзменениеПараметровОС2_4",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИзменениеПараметровНМА2_4",          "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.МодернизацияОС2_4",                  "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПередачаОСАрендатору2_4",            "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеОС2_4",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПеремещениеНМА2_4",                  "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереоценкаНМА2_4",                   "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПереоценкаОС2_4",                    "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПодготовкаКПередачеНМА2_4",          "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПодготовкаКПередачеОС2_4",           "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПринятиеКУчетуНМА2_4",               "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ПринятиеКУчетуОС2_4",                "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеНМА2_4",                     "Дата", "ВнеоборотныеАктивы", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.СписаниеОС2_4",                      "Дата", "ВнеоборотныеАктивы", "Организация");
	
	
	// Бухгалтерский учет
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрБухгалтерии.Хозрасчетный",					"Период" ,"БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.ОтражениеДокументовВРеглУчете",	"ДатаОтражения" ,"БухгалтерскийУчет", "Организация");
	
	// Учет УСН
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ЗаписьКУДиР",							"Дата" ,"БухгалтерскийУчет", "Организация");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеДивидендов",       "Дата",               "БухгалтерскийУчет", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеДивидендов",       "ДатаВыплаты",        "БухгалтерскийУчет", "");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.ИнвентаризацияРасчетов",    	"Дата",				  "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеСписаниеРезервовПоСомнительнымДолгам", "Дата", "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.НачислениеСписаниеРезервовПредстоящихРасходов",  "Дата", "БухгалтерскийУчет", "Организация");
	
	РегистрыСведений.ЗаданияКРасчетуАмортизацииОС.ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных);
	РегистрыСведений.ЗаданияКРасчетуАмортизацииНМА.ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных);
	РегистрыСведений.ЗаданияКРасчетуСтоимостиВНА.ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных);
	РегистрыСведений.ЗаданияКФормированиюДвиженийПоВНА.ОписаниеРегистровДляКонтроляДатЗапретаИзменения(ИсточникиДанных);
	//-- НЕ УТ
	//-- Локализация

КонецПроцедуры

// Позволяет изменить работу интерфейса при встраивании.
//
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.НастройкаИнтерфейса()
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	ДатыЗапретаИзмененияБП.НастройкаИнтерфейса(НастройкиРаботыИнтерфейса);
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// см. ОбщийМодуль.ПриЗаполненииРазделовДатЗапретаИзменения.НастройкаИнтерфейса()
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	ЗарплатаКадры.ПриЗаполненииРазделовДатЗапретаИзменения(Разделы);
	//-- НЕ УТ


	Раздел = Разделы.Добавить();
	Раздел.Имя  = "БухгалтерскийУчет";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("2bdf6479-8eaf-4ec0-93a1-412e8659a178");
	Раздел.Представление = НСтр("ru = 'Бухгалтерский учет'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	
	//++ НЕ УТ
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "ВнеоборотныеАктивы";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("1dc4b831-3ca1-11e7-9d6b-e0cb4ed5f5dc");
	Раздел.Представление = НСтр("ru = 'Внеоборотные активы'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры


// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
//
// см. ОбщийМодуль.ДатыЗапретаИзмененияПереопределяемый.ПередПроверкойЗапретаИзменения()
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	//++ Локализация
	Если ОбщегоНазначения.ЭтоРегистр(Объект.Метаданные())
	 И Объект.Отбор.Найти("Регистратор") <> Неопределено Тогда
		ТипРегистратора = ТипЗнч(Объект.Отбор.Регистратор.Значение); // это набор записей документа-регистратора
	Иначе
		ТипРегистратора = Неопределено;
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект);
		
	//++ НЕ УТ
	ЗарплатаКадры.ПередПроверкойЗапретаИзменения(
		Объект,
		ПроверкаЗапретаИзменения,
		УзелПроверкиЗапретаЗагрузки,
		ВерсияОбъекта);
	
	// Регл. учет
	// Для всех документов-регистраторов, если типом объекта является набор записей отражение документов в регл. учете, включаем проверку,
	//	так как проверка на форме дат запрета не распросраняется на проверку возможности формирования проводок:
	УстановленоСвойствоОтсутвияПроверки = Объект.ДополнительныеСвойства.Свойство("ПроверкаДатыЗапретаИзменения") И Не Объект.ДополнительныеСвойства.ПроверкаДатыЗапретаИзменения;
	Если Не ПроверкаЗапретаИзменения И ТипОбъекта = Тип("РегистрСведенийНаборЗаписей.ОтражениеДокументовВРеглУчете") И Не УстановленоСвойствоОтсутвияПроверки Тогда
		ПроверкаЗапретаИзменения = Истина;
	КонецЕсли;
	//-- НЕ УТ
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
