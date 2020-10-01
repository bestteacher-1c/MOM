#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

// Обработчик обновления БРО 1.1.12.17
//
Процедура ИзменитьВидИКодКонтролирующегоОрганаПодтвержденийВидаДеятельности(Параметры = Неопределено) Экспорт
	
	ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЖурналОтчетовСтатусы.Ссылка,
	|	ЖурналОтчетовСтатусы.Организация
	|ИЗ
	|	РегистрСведений.ЖурналОтчетовСтатусы КАК ЖурналОтчетовСтатусы
	|ГДЕ
	|	ЖурналОтчетовСтатусы.Ссылка.ИсточникОтчета = &ИсточникОтчета
	|	И ЖурналОтчетовСтатусы.ВидКонтролирующегоОргана <> &ВидКонтролирующегоОргана";
	
	Запрос.УстановитьПараметр("ИсточникОтчета", "РегламентированныйОтчетПодтверждениеВидаДеятельности");
	Запрос.УстановитьПараметр("ВидКонтролирующегоОргана", ВидКонтролирующегоОргана);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаписьЖОС = РегистрыСведений.ЖурналОтчетовСтатусы.СоздатьМенеджерЗаписи();
		ЗаписьЖОС.Ссылка = Выборка.Ссылка;
		ЗаписьЖОС.Организация = Выборка.Организация;
		ЗаписьЖОС.Прочитать();
		
		Если ЗаписьЖОС.Выбран() Тогда
			
			НачатьТранзакцию();
			
			ЗаписьЖОС.ВидКонтролирующегоОргана = ВидКонтролирующегоОргана;
			
			КодОргана = "";
			ДанныеОтчета = Выборка.Ссылка.ДанныеОтчета.Получить();
			Если ТипЗнч(ДанныеОтчета) = Тип("Структура") Тогда
				ПоказателиОтчета = Неопределено;
				ДанныеОтчета.Свойство("ПоказателиОтчета", ПоказателиОтчета);
				Если ТипЗнч(ПоказателиОтчета) = Тип("Структура") Тогда
					ДанныеПриложения1 = Неопределено;
					ПоказателиОтчета.Свойство("ПолеТабличногоДокументаПриложение1", ДанныеПриложения1);
					Если ТипЗнч(ДанныеПриложения1) = Тип("Структура") Тогда
						Если ДанныеПриложения1.Свойство("КодПодчиненности") Тогда
							КодОргана = СокрЛП(ДанныеПриложения1.КодПодчиненности);
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			КодОргана = ?(НЕ ЗначениеЗаполнено(КодОргана), СокрЛП(Выборка.Организация.КодПодчиненностиФСС), КодОргана);
			КодОргана = Лев(КодОргана, 4);
			ЗаписьЖОС.КодКонтролирующегоОргана = КодОргана;
			
			ЗаписьЖОС.ПредставлениеКонтролирующегоОргана = "ФСС" + ?(ЗначениеЗаполнено(КодОргана), " " + КодОргана, "");
			
			ЗаписьЖОС.Записать();
			
			ЗафиксироватьТранзакцию();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.12.17
//
Процедура ИзменитьВидКонтролирующегоОрганаСоответствийУсловийТруда(Параметры = Неопределено) Экспорт
	
	ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.Роструд;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЖурналОтчетовСтатусы.Ссылка,
	|	ЖурналОтчетовСтатусы.Организация
	|ИЗ
	|	РегистрСведений.ЖурналОтчетовСтатусы КАК ЖурналОтчетовСтатусы
	|ГДЕ
	|	ЖурналОтчетовСтатусы.Ссылка.ИсточникОтчета = &ИсточникОтчета
	|	И ЖурналОтчетовСтатусы.ВидКонтролирующегоОргана <> &ВидКонтролирующегоОргана";
	
	Запрос.УстановитьПараметр("ИсточникОтчета", "РегламентированныйОтчетСоответствиеУсловийТруда");
	Запрос.УстановитьПараметр("ВидКонтролирующегоОргана", ВидКонтролирующегоОргана);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ЗаписьЖОС = РегистрыСведений.ЖурналОтчетовСтатусы.СоздатьМенеджерЗаписи();
		ЗаписьЖОС.Ссылка = Выборка.Ссылка;
		ЗаписьЖОС.Организация = Выборка.Организация;
		ЗаписьЖОС.Прочитать();
		
		Если ЗаписьЖОС.Выбран() Тогда
			
			ЗаписьЖОС.ВидКонтролирующегоОргана = ВидКонтролирующегоОргана;
			ЗаписьЖОС.ПредставлениеКонтролирующегоОргана = "Роструд";
			
			ЗаписьЖОС.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.11.37
//
Процедура ИзменитьНаименованияДекларацийПоКосвеннымНалогам(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета(
		"Косвенные налоги при импорте товаров из государств - членов таможенного союза",
		"Косвенные налоги при импорте товаров");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.11.9
//
Процедура ИзменитьСтатусыНеОтправлявшихсяРеглОтчетов(Параметры = Неопределено) Экспорт
	
	ИмяОбъекта = "УдалитьСтатусыРегламентированныхОтчетов";// имена регистра сведении и перечисления совпадают
	
	РегистрСведенийУдалитьСтатусыРегламентированныхОтчетов = Метаданные.РегистрыСведений.Найти(ИмяОбъекта);
	
	ПеречислениеУдалитьСтатусыРегламентированныхОтчетов = Метаданные.Перечисления.Найти(ИмяОбъекта);
	
	// Переменная для обработки перехода с конфигурации на обычных формах на конфигурацию на управляемых формах.
	ОбрабатыватьСтатусыРегламентированныхОтчетовСтарогоОбразца
	= РегистрСведенийУдалитьСтатусыРегламентированныхОтчетов <> Неопределено
	И ПеречислениеУдалитьСтатусыРегламентированныхОтчетов <> Неопределено;
	
	ВыборкаЖОС = РегистрыСведений.ЖурналОтчетовСтатусы.Выбрать();
	
	Пока ВыборкаЖОС.Следующий() Цикл
		
		Если ВыборкаЖОС.Организация <> Null И ВыборкаЖОС.Ссылка <> Null
			И НЕ ПустаяСтрока(Строка(ВыборкаЖОС.Организация)) И НЕ ПустаяСтрока(Строка(ВыборкаЖОС.Ссылка)) Тогда
			
			Если НЕ РегламентированнаяОтчетностьКлиентСервер.ОбъектНеОтправлялсяЧерез1СОтчетность(
				ВыборкаЖОС.СостояниеСдачиОтчетности) Тогда
				Продолжить;
			КонецЕсли;
			
			НовыйСтатус = НСтр("ru = 'В работе'");
			
			Если ТипЗнч(ВыборкаЖОС.Ссылка)
				= Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда
				
				НовыйСтатус = НСтр("ru = 'Подготовлено'");
				
			Иначе
				
				Если ТипЗнч(ВыборкаЖОС.Ссылка) <> Тип("СправочникСсылка.МакетыПенсионныхДел") Тогда
					
					Если ОбрабатыватьСтатусыРегламентированныхОтчетовСтарогоОбразца Тогда
						
						ВыборкаСтатусыРО = РегистрыСведений[ИмяОбъекта].Выбрать(Новый Структура("Отчет", ВыборкаЖОС.Ссылка));
						
						Если ВыборкаСтатусыРО.Следующий() Тогда
							
							ПрежнийСтатус = ВыборкаСтатусыРО.Статус;
							
							Если ПрежнийСтатус = Перечисления[ИмяОбъекта].Сдан Тогда
								
								НовыйСтатус = НСтр("ru = 'Сдано'");
								
							ИначеЕсли ПрежнийСтатус = Перечисления[ИмяОбъекта].Подготовлен Тогда
								
								НовыйСтатус = НСтр("ru = 'Подготовлено'");
								
							КонецЕсли;
							
						Иначе
							
							СтатусыОбъекта
							= РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе(
							ВыборкаЖОС.Ссылка);
							
							ТекСтатус = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = '%1'"), ВыборкаЖОС.Статус);
							
							Если СтатусыОбъекта.Найти(ТекСтатус) <> Неопределено Тогда
								Продолжить;
							КонецЕсли;
							
						КонецЕсли;
						
					Иначе
						
						СтатусыОбъекта
						= РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе(
						ВыборкаЖОС.Ссылка);
						
						ТекСтатус = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = '%1'"), ВыборкаЖОС.Статус);
						
						Если СтатусыОбъекта.Найти(ТекСтатус) <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ЗаписьЖОС = ВыборкаЖОС.ПолучитьМенеджерЗаписи();
			ЗаписьЖОС.Статус = НовыйСтатус;
			ЗаписьЖОС.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбрабатыватьСтатусыРегламентированныхОтчетовСтарогоОбразца Тогда
		
		НаборЗаписейСтатусыРО = РегистрыСведений[ИмяОбъекта].СоздатьНаборЗаписей();
		НаборЗаписейСтатусыРО.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.22
//
Процедура ИсправитьРеквизитыОтправкиСправокОРублевыхИВалютныхСчетах(Параметры = Неопределено) Экспорт
	
	ВыборкаЖОС = РегистрыСведений.ЖурналОтчетовСтатусы.Выбрать();
	
	Пока ВыборкаЖОС.Следующий() Цикл
		
		Если ТипЗнч(ВыборкаЖОС.Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
			
			ИсточникОтчета = ВыборкаЖОС.Ссылка.ИсточникОтчета;
			
			Если СтрНачинаетсяС(ИсточникОтчета, "РегламентированныйОтчетСведенияОСчетахвВиностраннойВалюте")
				ИЛИ СтрНачинаетсяС(ИсточникОтчета, "РегламентированныйОтчетСведенияОрублевыхСчетах") Тогда
				
				ЗаписьЖОС = ВыборкаЖОС.ПолучитьМенеджерЗаписи();
				
				ЗаписьЖОС.НеОтправляетсяВКонтролирующийОрган = Истина;
				Если ЗаписьЖОС.Статус = "Не отправлено" Тогда
					ЗаписьЖОС.Статус = "Не отправлялся";
				КонецЕсли;
				
				ЗаписьЖОС.Записать();
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.18
//
Процедура ЗаполнитьИндексКартинкиРеглОтчетов(Параметры = Неопределено) Экспорт
	
	ВыборкаЖОС = РегистрыСведений.ЖурналОтчетовСтатусы.Выбрать();

	Пока ВыборкаЖОС.Следующий() Цикл
		
        ЗаписьЖОС = ВыборкаЖОС.ПолучитьМенеджерЗаписи();
		
        Если РегламентированнаяОтчетность.ЕстьФайлыПрисоединенныеКОбъекту(ЗаписьЖОС.Ссылка) Тогда
            ЗаписьЖОС.ИндексКартинки = ?(ЗаписьЖОС.ПометкаУдаления, 1, 3);
        Иначе
            ЗаписьЖОС.ИндексКартинки = ?(ЗаписьЖОС.ПометкаУдаления, 0, 2);
		КонецЕсли;
		
        ЗаписьЖОС.Записать();
		
    КонецЦикла;
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.13
//
Процедура ИзменитьНаименованияДекларацийПоАлкоголю(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Производство и оборот этилового спирта",
						 "Прил. 01: Производство и оборот этилового спирта");
	
	ИзменитьНаименованиеРеглОтчета("Использование этилового спирта",
						 "Прил. 02: Использование этилового спирта");
	
	ИзменитьНаименованиеРеглОтчета("Производство и оборот алкогольной продукции",
						 "Прил. 03: Производство и оборот алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Использование алкогольной и спиртосодержащей продукции",
						 "Прил. 04: Использование алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Оборот этилового спирта, алкогольной и спиртосодержащей продукции",
						 "Прил. 05: Оборот этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Поставки спирта и алкогольной продукции",
						 "Прил. 06: Поставка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Закупки спирта и алкогольной продукции",
						 "Прил. 07: Закупка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Объем перевозки этилового спирта, алкогольной и спиртосодержащей продукции",
						 "Прил. 08: Объем перевозки этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Перевозка этилового спирта и спиртосодержащей продукции",
						 "Прил. 09: Перевозка этилового спирта, алкогольной и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Использование мощностей по производству этилового спирта и алкогольной продукции",
						 "Прил. 10: Использование мощностей по производству этилового спирта и алкогольной продукции");
	
	ИзменитьНаименованиеРеглОтчета("Розничная продажа алкогольной (за исключением пива и пивных напитков) и спиртосодержащей продукции",
						 "Прил. 11: Розничная продажа алкогольной (за исключением пива и пивных напитков) и спиртосодержащей продукции");
	
	ИзменитьНаименованиеРеглОтчета("Розничная продажа пива и пивных напитков",
						 "Прил. 12: Розничная продажа пива и пивных напитков");
	
	ИзменитьНаименованиеРеглОтчета("Объем собранного винограда для производства винодельческой продукции",
						 "Прил. 13: Объем собранного винограда для производства винодельческой продукции");
	
	ИзменитьНаименованиеРеглОтчета("Объем винограда, использованного для производства вина, игристого вина (шампанского)",
						 "Прил. 14: Объем винограда, использованного для производства вина, игристого вина (шампанского)");
	
	ИзменитьНаименованиеРеглОтчета("Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллято",
						 "Прил. 15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов");
	
КонецПроцедуры

// Обработчик обновления БРО 1.2.1.11
//
Процедура ИзменитьНаименованияДекларацийПоАлкоголю4кв2019(Параметры = Неопределено) Экспорт
	
		
	ИзменитьНаименованиеРеглОтчета("Прил. 13: Объем собранного винограда для производства винодельческой продукции",
						 "(до 2019 г.) Алко Прил.13: Объем собранного винограда для производства винодельческой продукции");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 14: Объем винограда, использованного для производства вина, игристого вина (шампанского)",
						 "(до 2019 г.) Алко Прил.14: Объем винограда, использованного для производства вина, игристого вина (шампанского)");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов",
						 "(до 2019 г.) Алко Прил.15: Объем винограда, использованного для производства винодельческой продукции с защищенным географическим указанием, с защищенным наименованием места происхождения и полного цикла производства дистиллятов");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.10.65, 1.1.11.54, 1.1.12.20, 1.1.13.1
//
Процедура ИзменитьНаименованияДекларацийПоФармАлкоголю(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Прил. 01: Объем производства и поставки фармсубстанции спирта этилового",
						 		"Объем производства и поставки фармсубстанции спирта этилового");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 02: Объем использования для собственных нужд фармсубстанции спирта этилового",
						 		"Объем использования для собственных нужд фармсубстанции спирта этилового");
	
	ИзменитьНаименованиеРеглОтчета("Прил. 03: Объем поставки фармсубстанции спирта этилового",
						 		"Объем поставки фармсубстанции спирта этилового");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.13
//
Процедура ИзменитьНаименованияРеестровПоНДС(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 1", "Реестр по НДС: Приложение 01");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 2", "Реестр по НДС: Приложение 02");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 3", "Реестр по НДС: Приложение 03");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 4", "Реестр по НДС: Приложение 04");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 5", "Реестр по НДС: Приложение 05");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 6", "Реестр по НДС: Приложение 06");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 7", "Реестр по НДС: Приложение 07");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 8", "Реестр по НДС: Приложение 08");
	ИзменитьНаименованиеРеглОтчета("Реестр по НДС: Приложение 9", "Реестр по НДС: Приложение 09");
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.9.7
//
Процедура ОчиститьБезРегистрацииИзменений(Параметры = Неопределено) Экспорт
	
	НаборЗаписей = РегистрыСведений.ЖурналОтчетовСтатусы.СоздатьНаборЗаписей();
	НаборЗаписей.Очистить();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Обработчик обновления БРО 1.1.7.12
//
Процедура ИзменитьПредставлениеФинансовогоПериода(Параметры = Неопределено) Экспорт
	
	ВыборкаЖурналаОтчетовСтатусы = РегистрыСведений.ЖурналОтчетовСтатусы.Выбрать();
	
	Пока ВыборкаЖурналаОтчетовСтатусы.Следующий() Цикл
		
		Если ТипЗнч(ВыборкаЖурналаОтчетовСтатусы.Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет")
		   И ВыборкаЖурналаОтчетовСтатусы.Ссылка.Периодичность = Перечисления.Периодичность.Месяц Тогда
			
			ЗаписьЖурналаОтчетовСтатусы = ВыборкаЖурналаОтчетовСтатусы.ПолучитьМенеджерЗаписи();
									
			ЗаписьЖурналаОтчетовСтатусы.ФинансовыйПериод = РегламентированнаяОтчетностьВызовСервера.ПредставлениеФинансовогоПериода(ЗаписьЖурналаОтчетовСтатусы.ДатаНачала, ЗаписьЖурналаОтчетовСтатусы.ДатаОкончания, "Ложь");
			
			ЗаписьЖурналаОтчетовСтатусы.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
						
КонецПроцедуры

// Обработчик обновления БРО 1.1.7.12
//
Процедура ИзменитьНаименованияБухгалтерскихРеглОтчетов(Параметры = Неопределено) Экспорт
	
	ИзменитьНаименованиеРеглОтчета("Бухгалтерская отчетность СО НКО", "Бухгалтерская отчетность СО НКО (до 2015 года)");
	
	ИзменитьНаименованиеРеглОтчета("Бухгалтерская отчетность малых предприятий", "Бухгалтерская отчетность упрощенная");
	
	ИзменитьНаименованиеРеглОтчета("Статистика: Форма учета перемещения товаров", "Статистическая форма учета перемещения товаров");
				
КонецПроцедуры

Процедура ИзменитьНаименованиеРеглОтчета(СтароеНаим, НовоеНаим)
	
	ЖурналОтчетовСтатусы = РегистрыСведений.ЖурналОтчетовСтатусы;
	
	ОтборЖурналОтчетовСтатусы = Новый Структура("НаименованиеОтчета");
	
	ОтборЖурналОтчетовСтатусы.НаименованиеОтчета = СтароеНаим;
	
	ВыборкаЖурналаОтчетовСтатусы = ЖурналОтчетовСтатусы.Выбрать(ОтборЖурналОтчетовСтатусы);
	
	Пока ВыборкаЖурналаОтчетовСтатусы.Следующий() Цикл
		
		ЗаписьЖурналаОтчетовСтатусы = ВыборкаЖурналаОтчетовСтатусы.ПолучитьМенеджерЗаписи();
		
		ЗаписьЖурналаОтчетовСтатусы.НаименованиеОтчета = НовоеНаим;
		
		ЗаписьЖурналаОтчетовСтатусы.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли