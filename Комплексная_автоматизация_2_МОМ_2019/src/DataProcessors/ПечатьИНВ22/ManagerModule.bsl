#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИНВ22") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ИНВ22",
			НСтр("ru = 'ИНВ-22 (приказ)'"),
			СформироватьПечатнуюФормуИНВ22(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуИНВ22(СтруктураТипов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.АвтоМасштаб			= Истина;
	ТабДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабДокумент.ИмяПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияРасчетовСКонтрагентами_ИНВ22";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
			
		Если СтруктураОбъектов.Ключ <> "Документ.ИнвентаризацияОС" И СтруктураОбъектов.Ключ <> "Документ.ИнвентаризацияРасчетов" Тогда 
			ТекстСообщения = НСтр("ru = 'Формирование печатной формы ""ИНВ-22"" доступно только для документов %ТипДокументов%.'");
			МассивСинонимовДоступныхДокументов = Новый Массив;
			МассивСинонимовДоступныхДокументов.Добавить(""""+Метаданные.Документы.ИнвентаризацияОС.Синоним+"""");
			МассивСинонимовДоступныхДокументов.Добавить(""""+Метаданные.Документы.ИнвентаризацияРасчетов.Синоним+"""");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипДокументов%", СтрСоединить(МассивСинонимовДоступныхДокументов, " ,"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Продолжить;
		КонецЕсли;
				
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ДанныеДляПечатнойФормыИНВ22(ПараметрыПечати, СтруктураОбъектов.Значение);
		Если Не ДанныеДляПечати.Пустой() Тогда
			ЗаполнитьТабличныйДокументИНВ22(ТабДокумент, ДанныеДляПечати, ОбъектыПечати);
		КонецЕсли;
	
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТабДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументИНВ22(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьИНВ22.ПФ_MXL_ИНВ22_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;

	ПервыйДокумент = Истина;
	
	// Варианты заголовков разделов с подписями печатной формы	
	ЗаголовокРазделаПодписей = Новый Структура();
	ЗаголовокРазделаПодписей.Вставить("ПредседательКомиссии", НСтр("ru = 'Председатель комиссии'", Метаданные.Языки.Русский.КодЯзыка));
	ЗаголовокРазделаПодписей.Вставить("ЧленыКомиссии",        НСтр("ru = 'Члены комиссии'", Метаданные.Языки.Русский.КодЯзыка));
	
	// Получаем области макета для вывода в табличный документ
	Шапка   = Макет.ПолучитьОбласть("Шапка");
	Подпись = Макет.ПолучитьОбласть("Подпись");
	Подвал  = Макет.ПолучитьОбласть("Подвал");
	
	ВыборкаШапок = ДанныеДляПечати.Выбрать();
	
	Пока ВыборкаШапок.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТаблицаИнвентаризационнаяКомиссия = ВыборкаШапок.ИнвентаризационнаяКомиссия.Выгрузить();
		
		// Выведем шапку документа
		
		Шапка.Параметры.Заполнить(ВыборкаШапок);
		Шапка.Параметры.НаименованиеИмуществаОбязательств = ВыборкаШапок.НаименованиеИмуществаОбязательствШапка;
		Шапка.Параметры.НомерДокумента = ?(ЗначениеЗаполнено(ВыборкаШапок.ДокументОснованиеНомер), ВыборкаШапок.ДокументОснованиеНомер,
			ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаШапок.Номер, Истина, Ложь));
		Шапка.Параметры.ДатаДокумента = ?(ЗначениеЗаполнено(ВыборкаШапок.ДокументОснованиеДата), ВыборкаШапок.ДокументОснованиеДата,
			ВыборкаШапок.Дата);
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаШапок.Организация, ВыборкаШапок.Дата);
		Шапка.Параметры.Организация          = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации);
		Шапка.Параметры.ОрганизацияКодПоОКПО = СведенияОбОрганизации.КодПоОКПО;
		
		ТабличныйДокумент.Вывести(Шапка);		
		
		// Выведем подпись председателя инвентаризационной комиссии
		ПредседательКомиссии = ТаблицаИнвентаризационнаяКомиссия.Найти(Истина, "Председатель");
		
		Если ПредседательКомиссии <> Неопределено Тогда
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = ПредседательКомиссии.Должность;
	    	Подпись.Параметры.НаименованиеЧленаКомисси = ПредседательКомиссии.ФИОПолные;
			
		Иначе
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ЗаголовокРазделаПодписей.ПредседательКомиссии;
			Подпись.Параметры.Должность                = "";
			Подпись.Параметры.НаименованиеЧленаКомисси = "";
			
		КонецЕсли;
			
		ТабличныйДокумент.Вывести(Подпись);
		
		// Выведем подписи членов комиссии
		ВыводитьЗаголовок = Истина;
		
		// Сначала выведем членов комиссии из выборки
		КоличествоЧленовКомиссии = 0;
		Для Каждого ЧленКомиссии Из ТаблицаИнвентаризационнаяКомиссия Цикл
			
			Если ЧленКомиссии.Председатель Тогда
				Продолжить;
			КонецЕсли;
			
			Если НЕ ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, ЗаголовокРазделаПодписей.ЧленыКомиссии, "");
			Подпись.Параметры.Должность                = ЧленКомиссии.Должность;
		    Подпись.Параметры.НаименованиеЧленаКомисси = ЧленКомиссии.ФИОПолные;
			
			ТабличныйДокумент.Вывести(Подпись);
			
			ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
			КоличествоЧленовКомиссии = КоличествоЧленовКомиссии + 1;
			
		КонецЦикла;
		
		// Затем выведем пустые места для подписей (чтобы в итоге получилось не менее 3-х
		// подписей, как в форме, утвержденной Госкомстатом).
		Если КоличествоЧленовКомиссии < 3 Тогда
			
			Если НЕ ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, Подпись) Тогда
				
				// Выведем разрыв страницы
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				ВыводитьЗаголовок = Истина; // на новой странице выведем заголовок набора подписей
			
			КонецЕсли;
			
			Для Итератор = (КоличествоЧленовКомиссии + 1) По 3 Цикл
				
				Подпись.Параметры.ЗаголовокРазделаПодписей = ?(ВыводитьЗаголовок, ЗаголовокРазделаПодписей.ЧленыКомиссии, "");
				Подпись.Параметры.Должность                = "";
				Подпись.Параметры.НаименованиеЧленаКомисси = "";
				
				ТабличныйДокумент.Вывести(Подпись);
				
				ВыводитьЗаголовок = Ложь; // в следующей итерации вывод заголовка не нужен
				
			КонецЦикла;
		
		КонецЕсли;
		
		// Выведем подвал приказа
		Если НЕ ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента(ТабличныйДокумент, Подвал) Тогда
			
			// Выведем разрыв страницы
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		Подвал.Параметры.НаименованиеИмуществаОбязательств = ВыборкаШапок.НаименованиеИмуществаОбязательствПодвал;
		Подвал.Параметры.ДатаНачалаИнвентаризации          = Формат(ВыборкаШапок.ДатаНачалаИнвентаризации, "ДЛФ=DD");
		Подвал.Параметры.ДатаОкончанияИнвентаризации       = Формат(ВыборкаШапок.ДатаОкончанияИнвентаризации, "ДЛФ=DD");
		Подвал.Параметры.ПричинаПроведенияИнвентаризации   = ВыборкаШапок.ПричинаПроведенияИнвентаризации;
		
		Руководители = ОтветственныеЛицаБП.ОтветственныеЛица(
			ВыборкаШапок.Организация, ВыборкаШапок.Дата, ВыборкаШапок.ПодразделениеОрганизации);
		Подвал.Параметры.ДолжностьРуководителя          = Руководители.РуководительДолжностьПредставление;
		Подвал.Параметры.РасшифровкаПодписиРуководителя = Руководители.РуководительПредставление;
		
		ТабличныйДокумент.Вывести(Подвал);

		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаШапок.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли