#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату >= '20120101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату >= '20070101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия400;
	ИначеЕсли НаДату >= '20050101' Тогда
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2007Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приказ Минфина РФ от 13.04.2006  № 65н (в редакции приказа Минфина РФ от 19.12.2006 г. № 180н).";
	НоваяФорма.РедакцияФормы      = "от 19.12.2006 г. № 180н.";
	НоваяФорма.ДатаНачалоДействия = '2007-01-01';
	НоваяФорма.ДатаКонецДействия  = '2011-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.02.2012 № ММВ-7-11/99@.";
	НоваяФорма.РедакцияФормы      = "от 20.02.2012 № ММВ-7-11/99@.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2012-01-01';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2012Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.02.2012 № ММВ-7-11/99@.";
	НоваяФорма.РедакцияФормы      = "от 20.02.2012 № ММВ-7-11/99@.";
	НоваяФорма.ДатаНачалоДействия = '2012-01-01';
	НоваяФорма.ДатаКонецДействия  = '2012-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв4";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.02.2012 № ММВ-7-11/99@ (в ред. приказа ФНС России от 14.11.2013 № ММВ-7-3/501@).";
	НоваяФорма.РедакцияФормы      = "от 14.11.2013 № ММВ-7-3/501@.";
	НоваяФорма.ДатаНачалоДействия = '2013-01-01';
	НоваяФорма.ДатаКонецДействия  = '2013-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 20.02.2012 № ММВ-7-11/99@ (в ред. приказа ФНС России от 25.04.2014 № ММВ-7-11/254@).";
	НоваяФорма.РедакцияФормы      = "от 25.04.2014 № ММВ-7-11/254@.";
	НоваяФорма.ДатаНачалоДействия = '2014-01-01';
	НоваяФорма.ДатаКонецДействия  = '2016-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 05.12.2016 № ММВ-7-21/668@.";
	НоваяФорма.РедакцияФормы      = "от 05.12.2016 № ММВ-7-21/668@.";
	НоваяФорма.ДатаНачалоДействия = '2016-01-01';
	НоваяФорма.ДатаКонецДействия  = '2018-12-31';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 05.12.2016 № ММВ-7-21/668@ (в ред. приказа ФНС России от 26.11.2018 № ММВ-7-21/664@).";
	НоваяФорма.РедакцияФормы      = "от 26.11.2018 № ММВ-7-21/664@.";
	НоваяФорма.ДатаНачалоДействия = '2019-01-01';
	НоваяФорма.ДатаКонецДействия  = '2020-12-31';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2012Кв4"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2013Кв4"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2014Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2016Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2019Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1 (многостраничный).
		// На странице:
		// - 010 - КБК;
		// - три комплекта строк (с одинаковыми номерами):
		//	020 - ОКТМО,
		//	030 - сумма.
		
		ИмяКБК   = "П000010001003";
		ИмяОКАТО = "П000010002003";
		ИмяСумма = "П000010003003";
		
		Если ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Свойство("Раздел1") Тогда
			
			Раздел1 = ДанныеРеглОтчета.ДанныеМногостраничныхРазделов.Раздел1;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			
			Для Каждого Страница Из Раздел1 Цикл
				
				Данные = Страница.Данные;
				КБК    = Данные[ИмяКБК];
				
				Для НомерКомплекта = 1 По 3 Цикл
					
					ПостфиксКомплекта = "_" + НомерКомплекта;
					
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = Период;
					Сумма.КБК    = КБК;
					Сумма.ОКАТО  = Данные[ИмяОКАТО + ПостфиксКомплекта];
					Сумма.Сумма  = Данные[ИмяСумма + ПостфиксКомплекта];
					
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
	
	Форма20070101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2006-12-19', "180н", "ФормаОтчета2007Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20070101, "4.01");
	
	Форма20120101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2012-02-20', "ММВ-7-11/99@", "ФормаОтчета2012Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20120101, "5.01");
	
	Форма20121001 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2012-02-20', "ММВ-7-11/99@", "ФормаОтчета2012Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20121001, "5.01");
	
	Форма20131231 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2013-11-14', "ММВ-7-3/501@", "ФормаОтчета2013Кв4");
	ОпределитьФорматВДеревеФормИФорматов(Форма20131231, "5.02");
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2014-04-25', "ММВ-7-11/254@", "ФормаОтчета2014Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "5.03");
	
	Форма20160101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2016-12-05', "ММВ-7-21/668@", "ФормаОтчета2016Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20160101, "5.04");
	
	Форма20190101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152004", '2018-11-26', "ММВ-7-21/664@", "ФормаОтчета2019Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20190101, "5.05");
	
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