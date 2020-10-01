#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20110101' Тогда	
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 29.08.2013 № 349.";
	НоваяФорма.РедакцияФормы	  = "от 29.08.2013 № 349.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 24.09.2014 № 580.";
	НоваяФорма.РедакцияФормы	  = "от 24.09.2014 № 580.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 25.09.2015 № 442.";
	НоваяФорма.РедакцияФормы	  = "от 25.09.2015 № 442.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 05.08.2016 № 391.";
	НоваяФорма.РедакцияФормы	  = "от 05.08.2016 № 391.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 30.08.2017 № 563.";
	НоваяФорма.РедакцияФормы	  = "от 30.08.2017 № 563.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 06.08.2018 № 487.";
	НоваяФорма.РедакцияФормы	  = "от 06.08.2018 № 487.";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 30.12.2019 № 825 (в редакции приказа Росстата от 17.01.2020 № 11).";
	НоваяФорма.РедакцияФормы	  = "от 30.12.2019 № 825.";
	НоваяФорма.ДатаНачалоДействия = '20190101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
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
	
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20130829', "349", "ФормаОтчета2013Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20140924', "580", "ФормаОтчета2014Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20150925', "442", "ФормаОтчета2015Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20160805', "391", "ФормаОтчета2016Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20170830', "563", "ФормаОтчета2017Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20180806', "487", "ФормаОтчета2018Кв1");
	Форма20190101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "604017", '20191230', "825", "ФормаОтчета2019Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма4Инновация", "ФормаОтчета2019Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20190101, ВерсияВыгрузки);
	
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

#КонецОбласти

#КонецЕсли
