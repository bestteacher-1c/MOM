#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2020Кв2";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 15.10.2019 № ММВ-7-3/517@.";
	НоваяФорма.РедакцияФормы      = "от 15.10.2019 № ММВ-7-3/517@.";
	НоваяФорма.ДатаНачалоДействия = '2020-04-01';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета, ВключатьСуммыКВозврату = Ложь) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
	Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
		Возврат ТаблицаДанныхРеглОтчета;
	КонецЕсли;
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2020Кв2" Тогда
		
		Если ДанныеРеглОтчета.Свойство("ОкружениеСохранения") Тогда
			
			Возврат ТаблицаДанныхРеглОтчета; // отчет сохранен в 2.0
			
		ИначеЕсли ДанныеРеглОтчета.Свойство("ДанныеМногоуровневыхРазделов") Тогда
			
			ДанныеМнЧР1М1
			= ДанныеРеглОтчета.ДанныеМногоуровневыхРазделов["Раздел1"].Строки[0].ДанныеМногострочныхЧастей["П00001М1"];
			
			Для каждого СтрокаМнЧР1М1 Из ДанныеМнЧР1М1.Строки Цикл
				
				ОКТМО = СокрЛП(СтрокаМнЧР1М1.Данные["П00001М101000"]);
				
				ДанныеМнЧР1М2 = СтрокаМнЧР1М1.ДанныеМногострочныхЧастей["П00001М2"];
				
				Для каждого СтрокаМнЧР1М2 Из ДанныеМнЧР1М2.Строки Цикл
					
					Сумма = ТаблицаДанныхРеглОтчета.Добавить();
					Сумма.Период = ЭкземплярРеглОтчета.ДатаОкончания;
					Сумма.ОКАТО  = ОКТМО;
					Сумма.КБК    = СокрЛП(СтрокаМнЧР1М2.Данные.П00001М202000);
					Сумма.Сумма  = СтрокаМнЧР1М2.Данные.П00001М203000
					             - ?(ВключатьСуммыКВозврату = Истина, СтрокаМнЧР1М2.Данные.П00001М204000, 0);
					
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
	
	Форма2020Кв2 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151095", '2019-10-15', "ММВ-7-3/517@", "ФормаОтчета2020Кв2");
	ОпределитьФорматВДеревеФормИФорматов(Форма2020Кв2, "5.01");
	
	Возврат ФормыИФорматы;
	
КонецФункции

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

#КонецЕсли