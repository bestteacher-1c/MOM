
#Область ПрограммныйИнтерфейс

// Определяет объекты метаданных и отдельные реквизиты, которые исключаются из результатов поиска ссылок,
// не учитываются при монопольном удалении помеченных, замене ссылок и в отчете по местам использования.
//
// См. ОбщегоНазначения.ПриДобавленииИсключенийПоискаСсылок().
//
Процедура ПриДобавленииИсключенийПоискаСсылок(ИсключенияПоискаСсылок) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

// Определяет соответствие имен параметров сеанса и обработчиков для их установки.
//
// В указанных модулях должна быть размещена процедура обработчика, в которую передаются параметры
//  ИмяПараметра           - Строка - имя параметра сеанса, который требуется установить.
//  УстановленныеПараметры - Массив - имена параметров, которые уже установлены.
// 
// Далее пример процедуры обработчика для копирования в указанные модули.
//
//// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииОбработчиковУстановкиПараметровСеанса.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	//++ Локализация
	// ИнтеграцияЕГАИС
	Обработчики.Вставить("ИдентификаторСеансаЕГАИС" , "ИнтеграцияЕГАИС.УстановитьПараметрыСеанса");
	// Конец ИнтеграцияЕГАИС
	
	//++ НЕ ГОСИС
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ИнтеграцияС1СДокументооборотом
	
	//++ НЕ УТ
	// ЗарплатаКадрыРасширенный
	ЗарплатаКадрыРасширенный.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ЗарплатаКадрыРасширенный
	
	ОбщегоНазначенияБРО.ОбработчикиИнициализацииПараметровСеанса(Обработчики);
	//-- НЕ УТ
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	// Конец ЭлектронноеВзаимодействие
	
	//-- НЕ ГОСИС
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// конфигурации без дополнительных серверных вызовов.
// 
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента()
//
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
КонецПроцедуры

// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// 
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске()
//
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	//++ Локализация
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец ЭлектронноеВзаимодействие
	
	//++ НЕ УТ
	ОбщегоНазначенияБРО.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	// ЗарплатаКадрыРасширенный
	ЗарплатаКадрыРасширенный.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	// Конец ЗарплатаКадрыРасширенный
	//-- НЕ УТ
	//-- Локализация
	Возврат;
	
КонецПроцедуры

// Вызывается при обновлении информационной базы для учета переименований подсистем и ролей в конфигурации.
//  
// см. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных()
//
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт

	//++ Локализация
	//++ НЕ УТ
	ЗарплатаКадры.ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог);	
	//-- НЕ УТ
	
	// ЭлектронноеВзаимодействие
	ЭлектронноеВзаимодействие.ПриДобавленииПереименованийОбъектовМетаданных(Итог);
	// Конец ЭлектронноеВзаимодействие
	//-- Локализация
	Возврат;

КонецПроцедуры

// Определяет список версий программных интерфейсов, доступных через web-сервис InterfaceVersion.
// 
// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов()
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии) Экспорт

	//++ Локализация
	//++ НЕ УТ
	ОбщегоНазначенияБРО.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(ПоддерживаемыеВерсии);
	//-- НЕ УТ
	//-- Локализация
	Возврат;
	
КонецПроцедуры

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
//
// Позволяет задать значения параметров, необходимых для работы клиентского кода
// при запуске конфигурации (в обработчиках событий ПередНачаломРаботыСистемы и ПриНачалеРаботыСистемы) 
// без дополнительных серверных вызовов. 
// Для получения значений этих параметров из клиентского кода
// см. СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске.
//
// Важно: недопустимо использовать команды сброса кэша повторно используемых модулей, 
// иначе запуск может привести к непредсказуемым ошибкам и лишним серверным вызовам.
//
// Параметры:
//   Параметры - Структура - имена и значения параметров работы клиента при запуске, которые необходимо задать.
//                           Для установки параметров работы клиента при запуске:
//                           Параметры.Вставить(<ИмяПараметра>, <код получения значения параметра>);
//
Процедура ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт

	//++ Локализация
	
	//++ НЕ УТ
	ОбщегоНазначенияБРО.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	//-- НЕ УТ
	//-- Локализация

КонецПроцедуры

// Устарела. Следует использовать ПриДобавленииПараметровРаботыКлиента.
//
// см. ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиента()
//
Процедура ПараметрыРаботыКлиента(Параметры) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти