#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.ЗагрузитьЗначения(ВсеЗначения())
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает все доступные категории доходов НДФЛ.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция ВсеЗначения() Экспорт
	
	Категории = ПоОсновнойСтавке();
	
	КатегорииДивидендов = Дивиденды();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Категории, КатегорииДивидендов, Истина);
	
	КатегорииАвторскиеРоялти = АвторскиеРоялти();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Категории, КатегорииАвторскиеРоялти);
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ, за исключением категорий доходов,
// исчисляемых по ставкам предусмотренными международными договорами РФ 
// об избежании двойного налогообложения.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция ПоОсновнойСтавке() Экспорт
	
	Категории = Новый Массив;
	Категории.Добавить(ОплатаТруда);
	Категории.Добавить(ДоходВНатуральнойФормеОтТрудовойДеятельности);
	Категории.Добавить(ПрочиеНатуральныеДоходы);
	Категории.Добавить(ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности);
	Категории.Добавить(ПрочиеДоходы);
	Категории.Добавить(Дивиденды);
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ по дивидендам.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция Дивиденды() Экспорт
	
	Категории = Новый Массив;
	Категории.Добавить(Дивиденды);
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяСтавкиНДФЛМеждународныхДоговоров") Тогда
		Категории.Добавить(ДивидендыПоСтавке05);
		Категории.Добавить(ДивидендыПоСтавке10);
		Категории.Добавить(ДивидендыПоСтавке12);
	КонецЕсли;
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ по ценным бумагам и авторским вознаграждениям,
// исчисляемых по ставкам предусмотренными международными договорами РФ об избежании
// двойного налогообложения.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция АвторскиеРоялти() Экспорт
	
	Категории = Новый Массив;
	
	Если ПолучитьФункциональнуюОпцию("ИспользуютсяСтавкиНДФЛМеждународныхДоговоров") Тогда
		Категории.Добавить(АвторскиеРоялтиПоСтавке03);
		Категории.Добавить(АвторскиеРоялтиПоСтавке06);
		Категории.Добавить(АвторскиеРоялтиПроцентыПоСтавке05);
		Категории.Добавить(АвторскиеРоялтиПроцентыПоСтавке07);
		Категории.Добавить(АвторскиеРоялтиПроцентыПоСтавке10);
		Категории.Добавить(АвторскиеРоялтиПроцентыПоСтавке15);
	КонецЕсли;
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ, для которых не переносятся даты получения дохода
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция СФиксированнойДатойПолученияДохода() Экспорт
	
	Категории = Новый Массив;
	Категории.Добавить(ОплатаТруда);
	Категории.Добавить(ДоходВНатуральнойФормеОтТрудовойДеятельности);
	Категории.Добавить(ПрочиеНатуральныеДоходы);
	Категории.Добавить(ДоходыПредыдущихРедакций);
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ по оплате труда.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция ОплатаТруда() Экспорт
	
	Категории = Новый Массив;
	Категории.Добавить(ОплатаТруда);
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории доходов НДФЛ по натуральным доходам.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция Натуральные() Экспорт
	
	Категории = Новый Массив;
	Категории.Добавить(ДоходВНатуральнойФормеОтТрудовойДеятельности);
	Категории.Добавить(ПрочиеНатуральныеДоходы);
	
	Возврат Категории;
	
КонецФункции

// Возвращает категории все доходов, кроме оплаты труда и натуральных доходов.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииДоходовНДФЛ
//
Функция Прочие() Экспорт
	
	НеПрочие = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НеПрочие, ОплатаТруда());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НеПрочие, Натуральные());

	Категории = ОбщегоНазначенияКлиентСервер.РазностьМассивов(ВсеЗначения(), НеПрочие); 
	
	Возврат Категории;
	
КонецФункции

#КонецОбласти

#КонецЕсли