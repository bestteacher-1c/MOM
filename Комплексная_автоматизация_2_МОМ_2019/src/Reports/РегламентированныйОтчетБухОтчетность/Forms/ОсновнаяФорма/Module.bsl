#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ДатаКонцаПериодаОтчетаОригинала = Неопределено;
	Если ЗначениеЗаполнено(мСкопированаФорма) Тогда
		Если мСохраненныйДок <> Неопределено Тогда
			ДатаКонцаПериодаОтчетаОригинала = мДатаКонцаПериодаОтчета;
		КонецЕсли;
	КонецЕсли;
	
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ИмяФормы);
	
	ОбновитьСписокДоступныхФормОтчета(Организация);
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		Элементы.НадписьОрганизация.Видимость = Ложь;
	КонецЕсли;
	
	ОрганизацияДатаРегистрации = ДатаРегистрацииОрганизации(Организация);
	
	Если мДатаКонцаПериодаОтчета <> Неопределено Тогда
		ИзменитьПериод(ЭтотОбъект, 0);
		ОбновитьСписокДоступныхФормОтчета(Организация);
	КонецЕсли;
	
	ОткорректироватьНачальныйПериод(Организация);
	
	ПоказатьПериод(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтотОбъект);
	
	УстановитьДоступностьКнопокПериода(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьДоступностьФлажкаБалансаНКО(ЭтотОбъект);
	Если БалансНекоммерческойОрганизации Тогда
		ПереключательНКО = 1;
	Иначе
		ПереключательНКО = 0;
	КонецЕсли;
	ВосстановитьНастройкиНКО(Организация);
	
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "http://v8.1c.ru/lawmonitor/lawchanges.jsp?";
	СпрРеглОтчетов = Справочники.РегламентированныеОтчеты;
	НайденнаяСсылка = СпрРеглОтчетов.НайтиПоРеквизиту("ИсточникОтчета", ИсточникОтчета);
	
	Если НайденнаяСсылка = СпрРеглОтчетов.ПустаяСсылка() Тогда
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
		
	Иначе
		УИДОтчета = НайденнаяСсылка.УИДОтчета;
		
		Фильтр1 = "regReportForm=" + УИДОтчета;
		Фильтр2 = "regReportOnly=true";
		УИДКонфигурации = "";
		РегламентированнаяОтчетностьПереопределяемый.ПолучитьУИДКонфигурации(УИДКонфигурации);
		Фильтр3 = "userConfiguration=" + УИДКонфигурации;
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
			+ Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;
		
	КонецЕсли;
	
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
	
	// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
		
		МодульОбработкаНовостей = ОбщегоНазначения.ОбщийМодуль("ОбработкаНовостей");
		
		МодульОбработкаНовостей.КонтекстныеНовости_ПриСозданииНаСервере(
			ЭтотОбъект,
			"БП.Отчет.РегламентированныйОтчетБухОтчетность",
			"ОсновнаяФорма",
			,
			НСтр("ru='Новости: Бухгалтерская отчетность'"),
			Ложь,
			Новый Структура("ПолучатьНовостиНаСервере, ХранитьМассивНовостейТолькоНаСервере", Истина, Ложь),
			ИдентификаторыСобытийПриОткрытии);
		
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтотОбъект);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
		Если ИмяСобытия = Заголовок Тогда
			Активизировать();
		КонецЕсли;
	КонецЕсли;
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИзменитьПериод(ЭтотОбъект, 0);
	
	ОбработатьВыбраннуюОрганизацию(ВыбранноеЗначение);
	
	ОбновитьСписокДоступныхФормОтчета(ВыбранноеЗначение);
	
	ПоказатьПериод(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтотОбъект);
	УстановитьДоступностьКнопокПериода(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	ВосстановитьНастройкиНКО(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательСпособСозданияОрганизацииПриИзменении(Элемент)
	
	мДатаНачалаПериодаОтчета = Неопределено;
	мДатаКонцаПериодаОтчета  = Неопределено;
	
	ОткорректироватьНачальныйПериод(Организация);
	
	ПоказатьПериод(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтотОбъект);
	УстановитьДоступностьКнопокПериода(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательНКОПриИзменении(Элемент)
	
	БалансНекоммерческойОрганизации = (ПереключательНКО = 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы", СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);
	
	Если МассивСтрок.Количество() > 0 Тогда
		ВыбраннаяФорма = МассивСтрок[0];
		мВыбраннаяФорма     = ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок = ВыбраннаяФорма.ОписаниеОтчета;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Фильтр4 - год.
	Фильтр4 = "currentYear=" + Формат(Год(мДатаКонцаПериодаОтчета),"ЧГ=0");
	
	// Фильтр5 - квартал.
	МесяцКонцаКварталаОтчета = Месяц(КонецКвартала(мДатаКонцаПериодаОтчета));
	КварталОтчета = МесяцКонцаКварталаОтчета/3;
	
	Фильтр5 = "currentQuartal=" + Строка(КварталОтчета);
	
	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства
		+ "&" + Фильтр4 + "&" + Фильтр5;
	
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(
		СсылкаИзмененияЗаконодательства);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтотОбъект, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКомандыНовости(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если мСкопированаФорма <> Неопределено Тогда
		// Документ скопирован, проверка совместимости форм.
		ФормыРазличаются = (мВыбраннаяФорма <> мСкопированаФорма);
		
		ЕстьИзмененияВнутриФормы = Ложь;
		Если ДатаКонцаПериодаОтчетаОригинала <> Неопределено Тогда
			Если мВыбраннаяФорма = "ФормаОтчета2019Кв1" Тогда
				ГраницыПерехода = Новый Массив;
				ГраницыПерехода.Добавить('2020-01-01');
				
				ЕстьИзмененияВнутриФормы = 
					ПереходЧерезГраницуПриКопировании(ГраницыПерехода, ДатаКонцаПериодаОтчетаОригинала, мДатаКонцаПериодаОтчета);
				
			Иначе
				ГраницыПерехода = Новый Массив;
				ГраницыПерехода.Добавить('2015-01-01');
				ГраницыПерехода.Добавить('2018-01-01');
				
				ЕстьИзмененияВнутриФормы = 
					ПереходЧерезГраницуПриКопировании(ГраницыПерехода, ДатаКонцаПериодаОтчетаОригинала, мДатаКонцаПериодаОтчета);
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ФормыРазличаются ИЛИ ЕстьИзмененияВнутриФормы Тогда
			ПоказатьПредупреждение( , НСтр("ru='Форма отчета изменилась, копирование невозможно'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1'"), РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	СохранитьНастройкиНКО(Организация);
	
	НачатьЗамерВремени();
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("РедакцияФормы",            ПолеРедакцияФормы);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ПараметрыФормы.Вставить("СпособСозданияОрганизации",
		?(СпособСозданияОрганизации = 1, "Реорганизация", "ВновьСозданная"));
	ПараметрыФормы.Вставить("ДатаСозданияОрганизации", НачалоДня(ОрганизацияДатаРегистрации));
	
	Если РеализованБалансНКО(ЭтотОбъект) Тогда
		ПараметрыФормы.Вставить("ЭтоБалансНекоммерческойОрганизации", БалансНекоммерческойОрганизации);
	КонецЕсли;
	
	Форма = ОткрытьФорму(СтрЗаменить(ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Если мВыбраннаяФорма = "ФормаОтчета2011Кв4" Тогда
		Форма.ОткрытьУведомление();
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ПереходЧерезГраницуПриКопировании(ГраницыПерехода, ИсходнаяДата, НоваяДата)
	
	ЕстьПереход = Ложь;
	
	Для Каждого ГраницаПерехода Из ГраницыПерехода Цикл
		ЕстьПереход = ЕстьПереход
			ИЛИ (ИсходнаяДата >= ГраницаПерехода И НоваяДата < ГраницаПерехода)
			ИЛИ (ИсходнаяДата < ГраницаПерехода И НоваяДата >= ГраницаПерехода);
	КонецЦикла;
		
	Возврат ЕстьПереход;
	
КонецФункции

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтотОбъект, -1);
	ОбновитьСписокДоступныхФормОтчета(Организация);
	
	ВидПериода = ВидПериодаОтчета(ЭтотОбъект, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтотОбъект);
	УстановитьДоступностьКнопокПериода(ЭтотОбъект, ОрганизацияДатаРегистрации);
	УстановитьДоступностьФлажкаБалансаНКО(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтотОбъект, 1);
	ОбновитьСписокДоступныхФормОтчета(Организация);
	
	ВидПериода = ВидПериодаОтчета(ЭтотОбъект, ОрганизацияДатаРегистрации);
	Если ВидПериода <> "Стандартный" Тогда
		мДатаНачалаПериодаОтчета = ОрганизацияДатаРегистрации;
	КонецЕсли;
	
	ПоказатьПериод(ЭтотОбъект, ОрганизацияДатаРегистрации);
	
	УстановитьВидимостьПереключателяСпособаСозданияОрганизации(ЭтотОбъект);
	УстановитьДоступностьКнопокПериода(ЭтотОбъект, ОрганизацияДатаРегистрации);
	УстановитьДоступностьФлажкаБалансаНКО(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма, ОргДатаРегистрации)
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода <> "Стандартный" Тогда
		СтрПериодОтчета = Формат(Форма.мДатаНачалаПериодаОтчета, "ДФ=dd.MM.yyyy")
			+ " - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'");
	Иначе
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			СтрПериодОтчета = Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		Иначе
			СтрПериодОтчета = "Январь - " + Формат(Форма.мДатаКонцаПериодаОтчета, "ДФ='ММММ гггг'") + " г.";
		КонецЕсли;
	КонецЕсли;
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	НастроитьГруппуВыбораРедакцииФормы(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьГруппуВыбораРедакцииФормы(Форма)
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		Форма.Элементы.ПолеРедакцияФормы.Видимость    = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
	Иначе
		Форма.Элементы.ПолеРедакцияФормы.Видимость    = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
	КонецЕсли;
	
	Форма.Элементы.ОткрытьФормуОтчета.КнопкаПоУмолчанию = Форма.Элементы.ОткрытьФормуОтчета.Доступность;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = (ГодПериода > 2012);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокДоступныхФормОтчета(ПоОрганизации)
	
	УчетОтложенногоНалогаБалансовымМетодом = 
		РегламентированнаяОтчетность.УчетОтложенногоНалогаБалансовымМетодом(ПоОрганизации, мДатаКонцаПериодаОтчета);
	
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ИмяФормы);
	ОбъектОтчета = РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета);
	ЗначениеВДанныеФормы(ОбъектОтчета.ТаблицаФормОтчета(УчетОтложенногоНалогаБалансовымМетодом),мТаблицаФормОтчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидПериодаОтчета(Форма, ОргДатаРегистрации)
	
	ДатаРегистрации = НачалоДня(ОргДатаРегистрации);
	ДатаРасширенногоПериода = Дата(Год(Форма.мДатаКонцаПериодаОтчета) - 1, 10, 1);
	ДатаНачалаОбычногоПериода = НачалоГода(Форма.мДатаКонцаПериодаОтчета);
	
	Если (ДатаРегистрации > ДатаНачалаОбычногоПериода И ДатаРегистрации < Форма.мДатаКонцаПериодаОтчета) Тогда
		Возврат "Сокращенный";
	ИначеЕсли Форма.СпособСозданияОрганизации = 0
		И (ДатаРегистрации >= ДатаРасширенногоПериода И ДатаРегистрации < ДатаНачалаОбычногоПериода) Тогда
		Возврат "Расширенный";
	Иначе
		Возврат "Стандартный";
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОткорректироватьНачальныйПериод(ВыбОрганизация)
	
	ПредставляетсяЗаГод = (ТекущаяДатаСеанса() >= '2013-01-01');
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) ИЛИ НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		Если ПредставляетсяЗаГод Тогда
			мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(КонецГода(ТекущаяДатаСеанса()), -12));
		Иначе
			мДатаКонцаПериодаОтчета = КонецКвартала(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		КонецЕсли;
		мДатаНачалаПериодаОтчета = НачалоГода(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	ДатаРегистрации = НачалоДня(ВыбОрганизация.ДатаРегистрации);
	РасширятьПериод = (ДатаРегистрации >= Дата(Год(ДатаРегистрации), 10, 1) И СпособСозданияОрганизации <> 1);
	
	Если мДатаКонцаПериодаОтчета < ДатаРегистрации Тогда
		// Период предшествует дате регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		Иначе
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДатаРегистрации);
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(ДатаРегистрации);
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	ИначеЕсли мДатаНачалаПериодаОтчета <= ДатаРегистрации И ДатаРегистрации <= мДатаКонцаПериодаОтчета Тогда
		// Период содержит дату регистрации.
		Если РасширятьПериод Тогда
			Если ПредставляетсяЗаГод Тогда
				мДатаКонцаПериодаОтчета = КонецГода(ДобавитьМесяц(ДатаРегистрации, 12));
			Иначе
				мДатаКонцаПериодаОтчета = КонецКвартала(НачалоГода(ДобавитьМесяц(ДатаРегистрации, 12)));
			КонецЕсли;
		КонецЕсли;
		мДатаНачалаПериодаОтчета = ДатаРегистрации;
	Иначе
		// Период следует за датой регистрации.
		Если РасширятьПериод Тогда
			ДатаРасширенногоПериода = Дата(Год(мДатаКонцаПериодаОтчета) - 1, 10, 1);
			Если ДатаРегистрации >= ДатаРасширенногоПериода Тогда
				мДатаНачалаПериодаОтчета = ДатаРегистрации;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьКнопокПериода(Форма, ОргДатаРегистрации)
	
	ВидПериода = ВидПериодаОтчета(Форма, ОргДатаРегистрации);
	
	Если ВидПериода = "Расширенный" Тогда
		Если Месяц(Форма.мДатаКонцаПериодаОтчета) = 1 Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	ИначеЕсли ВидПериода = "Сокращенный" Тогда
		Если КонецМесяца(Форма.мДатаКонцаПериодаОтчета) <= КонецМесяца(Форма.мДатаНачалаПериодаОтчета) Тогда
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Ложь;
		Иначе
			Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
		КонецЕсли;
	Иначе
		Форма.Элементы.УстановитьПредыдущийПериод.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьФлажкаБалансаНКО(Форма)
	
	Если Форма.мСохраненныйДок = Неопределено Тогда
		Если РеализованБалансНКО(Форма) Тогда
			Форма.Элементы.ПереключательНКО.Доступность = Истина;
		Иначе
			Форма.БалансНекоммерческойОрганизации = Ложь;
			Форма.ПереключательНКО = 0;
			Форма.Элементы.ПереключательНКО.Доступность = Ложь;
		КонецЕсли;
		
	Иначе
		// Отчет скопирован.
		Форма.Элементы.ПереключательНКО.Видимость = Ложь;
		Форма.Элементы.Баланс.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеализованБалансНКО(Форма)
	
	Возврат (Форма.мДатаКонцаПериодаОтчета >= '20111201');
	
КонецФункции

&НаКлиенте
Функция НачатьЗамерВремени()
	
	// СтандартныеПодсистемы.ОценкаПроизводительности
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		КлючеваяОперация = "ОткрытиеФормыБухгалтерскаяОтчетность";
		ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент").ЗамерВремени(КлючеваяОперация, , Истина);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ОценкаПроизводительности
	
КонецФункции

&НаСервере
Функция ДатаРегистрацииОрганизации(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(ВыбОрганизация, , "ДатаРегистрации");
	
	Если ЗначениеЗаполнено(ОргСведения) И ОргСведения.Свойство("ДатаРегистрации") Тогда
		Возврат ОргСведения["ДатаРегистрации"];
	Иначе
		Возврат РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ОбработатьВыбраннуюОрганизацию(ВыбОрганизация)
	
	ОрганизацияДатаРегистрации = ДатаРегистрацииОрганизации(ВыбОрганизация);
	
	ОткорректироватьНачальныйПериод(ВыбОрганизация);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройкиНКО(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
	ВыбОрганизация, мДатаКонцаПериодаОтчета, "НекоммерческаяОрганизация");
	
	Если ОргСведения.Свойство("НекоммерческаяОрганизация")
		И ТипЗнч(ОргСведения.НекоммерческаяОрганизация) = Тип("Булево") Тогда
		Элементы.ПризнакНекоммерческойОрганизации.Видимость = Ложь;
		БалансНекоммерческойОрганизации = ОргСведения.НекоммерческаяОрганизация;
		Возврат;
	КонецЕсли;
	
	Если НЕ (Элементы.ПереключательНКО.Доступность и Элементы.ПереключательНКО.Видимость) Тогда
		// Отчет скопирован или создан за период, в котором отдельного баланса НКО еще не было.
		Возврат;
	КонецЕсли;
	
	НастройкиНКОизНастроек = ХранилищеНастроекДанныхФорм.Загрузить(
		"Отчет.РегламентированныйОтчетБухОтчетность.Форма.ОсновнаяФорма", "НастройкиНКО");
	Если НастройкиНКОизНастроек <> Неопределено Тогда
		НастройкиНКО.Загрузить(НастройкиНКОизНастроек);
	КонецЕсли;
	
	БалансНекоммерческойОрганизации = Ложь;
	
	Для Каждого ТекНастройкаНКО Из НастройкиНКО Цикл
		Если ТекНастройкаНКО.ОрганизацияНКО = ВыбОрганизация Тогда
			БалансНекоммерческойОрганизации = ТекНастройкаНКО.БалансНКО;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если БалансНекоммерческойОрганизации Тогда
		ПереключательНКО = 1;
	Иначе
		ПереключательНКО = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиНКО(ВыбОрганизация)
	
	ОргСведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
	ВыбОрганизация, мДатаКонцаПериодаОтчета, "НекоммерческаяОрганизация");
	
	Если ОргСведения.Свойство("НекоммерческаяОрганизация")
		И ТипЗнч(ОргСведения.НекоммерческаяОрганизация) = Тип("Булево") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (Элементы.ПереключательНКО.Доступность и Элементы.ПереключательНКО.Видимость) Тогда
		// Отчет скопирован или создан за период, в котором отдельного баланса НКО еще не было.
		Возврат;
	КонецЕсли;
	
	Найден = Ложь;
	Для Каждого ТекНастройкаНКО Из НастройкиНКО Цикл
		Если ТекНастройкаНКО.ОрганизацияНКО = ВыбОрганизация Тогда
			ТекНастройкаНКО.БалансНКО = БалансНекоммерческойОрганизации;
			Найден = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не Найден Тогда
		
		НовыйЭлемент = НастройкиНКО.Добавить();
		НовыйЭлемент.ОрганизацияНКО = ВыбОрганизация;
		НовыйЭлемент.БалансНКО = БалансНекоммерческойОрганизации;
		
	КонецЕсли;
	
	НастройкиНКОдляНастроек = НастройкиНКО.Выгрузить();
	
	ХранилищеНастроекДанныхФорм.Сохранить(
		"Отчет.РегламентированныйОтчетБухОтчетность.Форма.ОсновнаяФорма",
		"НастройкиНКО", НастройкиНКОдляНастроек);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьПереключателяСпособаСозданияОрганизации(Форма)
	
	ПредельнаяДатаОтображения = КонецГода(ДобавитьМесяц(Форма.ОрганизацияДатаРегистрации, 24));
	
	ОтображатьПереключатель
		= Форма.ОрганизацияДатаРегистрации >= Дата(Год(Форма.ОрганизацияДатаРегистрации), 10, 1)
		И Форма.мДатаКонцаПериодаОтчета <= ПредельнаяДатаОтображения;
	
	Форма.Элементы.ПереключательСпособСозданияОрганизации.Видимость = ОтображатьПереключатель;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()
	
	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.Новости") Тогда
		МодульОбработкаНовостейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбработкаНовостейКлиент");
		МодульОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(
			ЭтотОбъект, ИдентификаторыСобытийПриОткрытии);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
