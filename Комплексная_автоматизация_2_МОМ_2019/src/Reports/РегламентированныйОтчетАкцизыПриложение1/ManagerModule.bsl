#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20110701' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату > '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2011Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 14.06.2011 №ММВ-7-3/369@.";
	НоваяФорма.РедакцияФормы      = "от 14.06.2011 №ММВ-7-3/369@.";
	НоваяФорма.ДатаНачалоДействия = '2011-07-01';
	НоваяФорма.ДатаКонецДействия  = '2013-11-30';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 14.06.2011 №ММВ-7-3/369@ (в ред. приказа ФНС России от 14 ноября 2013 г. № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14.11.2013 г. № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2013-12-01';
	НоваяФорма.ДатаКонецДействия  = '2016-05-31';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2011Кв2"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв4" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1 (многостраничный)
		// 010 - ОКАТО
		// - в доп. строках
		// 020 - КБК
		// 030 - Сумма
		
		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Раздел1") Тогда
			
			Раздел1 = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Раздел1;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			КодСтрокиОКАТО = "П000110001003";
			КодСтрокиКБК   = "П000110002020";
			КодСтрокиСумма = "П000110002030";
			
			Для Каждого Страница Из Раздел1 Цикл
				
				Шапка  = Страница.Данные;
				Строки = Страница.ДанныеДопСтрок;
				
				ОКАТО = Шапка[КодСтрокиОКАТО];
				
				Для Каждого Строка Из Строки Цикл
				
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = Период;
					Сумма.КБК    = Строка[КодСтрокиКБК];
					Сумма.ОКАТО  = ОКАТО;
					Сумма.Сумма  = Строка[КодСтрокиСумма];
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20110701 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151084", '20110614', "MMB-7-3/369@", "ФормаОтчета2011Кв2");
	ОпределитьФорматВДеревеФормИФорматов(Форма20110701, "5.01");
	
	Форма2013Кв4 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151084", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма2013Кв4, "5.02");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли