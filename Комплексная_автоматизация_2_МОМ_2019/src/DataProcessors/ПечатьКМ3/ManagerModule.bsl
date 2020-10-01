#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КМ3") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КМ3", "КМ-3", СформироватьПечатнуюФормуКМ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуКМ3(СтруктураТипов, ОбъектыПечати, ПараметрыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Чек_КМ3";
	
	НомерТипаДокумента = 0;
	
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		Если НЕ (СтруктураОбъектов.Ключ = "Документ.ЧекККМВозврат"
			ИЛИ СтруктураОбъектов.Ключ = "Документ.ВозвратПодарочныхСертификатов"
			ИЛИ СтруктураОбъектов.Ключ = "Документ.ОтчетОРозничныхПродажах") Тогда
			
			Для Каждого Документ Из СтруктураОбъектов.Значение Цикл
				
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 печать Акта о возврате денежных сумм по неиспользованным чекам (КМ-3) не требуется.'"),
					Документ.Ссылка);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Документ.Ссылка);
				
			КонецЦикла;
			
			Продолжить;
		КонецЕсли;
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыКМ3(ПараметрыПечати, СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументКМ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументКМ3(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьКМ3.ПФ_MXL_КМ3_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ПервыйДокумент = Истина;
	
	Выборка = ДанныеДляПечати.РезультатЗапроса[0].Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ТипКассы = Перечисления.ТипыКассККМ.АвтономнаяККМ Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 с типом кассы ""Автономная ККМ"" печать Акта о возврате денежных сумм по неиспользованным чекам (КМ-3) не требуется.'"),
				Выборка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		
		ДокументНапечатан = Ложь;
		ВыборкаПоЧекамИтоги = ДанныеДляПечати.РезультатЗапроса[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Если ВыборкаПоЧекамИтоги.НайтиСледующий(Новый Структура("Документ", Выборка.Ссылка)) Тогда
			
			Если Не ПервыйДокумент Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			ДокументНапечатан = Истина;
			
			ПервыйДокумент = Ложь;
			НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
			
			Если ЗначениеЗаполнено(Выборка.КассирККМ) Тогда
				ФИОКассираОперациониста = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(Выборка.КассирККМ, Выборка.ДатаДокумента);
			КонецЕсли;

			ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
			ОбластьШапки.Параметры.Заполнить(Выборка);
			СведенияОбОрганизации = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(Выборка.Организация, Выборка.ДатаДокумента);
			ОбластьШапки.Параметры.ПредставлениеОрганизации  = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
			ОбластьШапки.Параметры.НомерДокумента            = "";
			ОбластьШапки.Параметры.ОрганизацияПоОКПО         = СведенияОбОрганизации.КодПоОКПО;
			ОбластьШапки.Параметры.ОрганизацияИНН            = СведенияОбОрганизации.ИНН;
			ОбластьШапки.Параметры.ВидДеятельностиПоОКДП     = "";
			ОбластьШапки.Параметры.ДолжностьРуководителя     = Выборка.ДолжностьРуководителя;
			ОбластьШапки.Параметры.ФИОКассираОперациониста   = ФИОКассираОперациониста;
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьШапки, Выборка.Ссылка);
			ТабличныйДокумент.Вывести(ОбластьШапки);
			
			ФИОРуководителя = Выборка.Руководитель;
			
			СуммаИтого     = 0;
			НомерПоПорядку = 0;
			ВыборкаПоЧекам = ВыборкаПоЧекамИтоги.Выбрать();
			Пока ВыборкаПоЧекам.Следующий() Цикл
				
				НомерПоПорядку = НомерПоПорядку + 1;
				ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
				ОбластьСтроки.Параметры.Заполнить(ВыборкаПоЧекам);
				ОбластьСтроки.Параметры.ФИОРуководителя = ФИОРуководителя;
				ОбластьСтроки.Параметры.Номер = НомерПоПорядку;
				ТабличныйДокумент.Вывести(ОбластьСтроки);
				
				СуммаИтого = СуммаИтого + ВыборкаПоЧекам.СуммаДокумента;
				
			КонецЦикла;
			
			ОбластьПодвала = Макет.ПолучитьОбласть("Подвал");
			
			ОбластьПодвала.Параметры.СуммаДокумента          = СуммаИтого;
			ОбластьПодвала.Параметры.СуммаПрописью           = РаботаСКурсамиВалют.СформироватьСуммуПрописью(СуммаИтого, Выборка.Валюта);
			ОбластьПодвала.Параметры.ФИОКассираОрганизации   = Выборка.ГлавныйБухгалтер;
			ОбластьПодвала.Параметры.ФИОКассираОперациониста = ФИОКассираОперациониста;
			ТабличныйДокумент.Вывести(ОбластьПодвала);
			
			УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);
		
		КонецЕсли;
		
		Если Не ДокументНапечатан Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Нет данных для печати Акта о возврате денежных сумм по неиспользованным чекам (КМ-3) по документу %1.'"),
				Выборка.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				Выборка.Ссылка);
			
			Продолжить;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Функция возвращает структуру с заголовками Скидка или Наценка для таблицы печатной формы,
// а также с флагами ЕстьСкидки и ТолькоНаценка.
//
Функция ЗаголовокСкидки(Знач Товары, ИспользоватьСкидки) Экспорт
	
	ЕстьНаценки = Ложь;
	ЕстьСкидки  = Ложь;
	
	СтруктураШапки = Новый Структура("Скидка, СуммаСкидки, ТолькоНаценка");
	
	Если ИспользоватьСкидки Тогда
		
		Пока Товары.Следующий() Цикл
			Если Товары.Скидка>0 Тогда
				ЕстьСкидки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Товары.Сбросить();
		
		Пока Товары.Следующий() Цикл
			Если Товары.Скидка<0 Тогда
				ЕстьНаценки = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ЕстьНаценки И ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Скидка (Наценка)'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма'") + Символы.ПС + НСтр("ru = 'без скидки (наценки)'"));
		ИначеЕсли ЕстьНаценки И НЕ ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Наценка'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма'") + Символы.ПС + НСтр("ru = 'без наценки'"));
		ИначеЕсли ЕстьСкидки Тогда
			СтруктураШапки.Вставить("Скидка", НСтр("ru = 'Скидка'"));
			СтруктураШапки.Вставить("СуммаСкидки", НСтр("ru = 'Сумма'") + Символы.ПС + НСтр("ru = 'без скидки'"));
		КонецЕсли;
		
		СтруктураШапки.Вставить("ТолькоНаценка", ЕстьНаценки);
		
	КонецЕсли;
	
	Возврат СтруктураШапки;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
