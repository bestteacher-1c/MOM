#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТТН") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ТТН",
			НСтр("ru = 'Товарно-транспортная накладная'"),
			СформироватьПечатнуюФормуТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));	
	КонецЕсли;
	
	ФормированиеПечатныхФорм.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТипДокументов = ТипЗнч(МассивОбъектов[0]);

	Если ТипДокументов <> Тип("ДокументСсылка.ТранспортнаяНакладная") Тогда 
		СтруктураВозврата = УправлениеПечатьюУТВызовСервераЛокализация.ПолучитьТранспортныеНакладныеНаПечать(МассивОбъектов);
		МассивНакладныхНаПечать = СтруктураВозврата.ТранспортныеНакладныеНаПечать;
		
		Для Каждого Документ Из СтруктураВозврата.МассивДокументовБезНакладных Цикл
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для документа %1 не создана ""Транспортная накладная"". Печать документа ""Товарно-транспортная накладная"" невозможна.'"),
					Документ);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					Текст,
					Документ)
					
		КонецЦикла
				
	Иначе
		МассивНакладныхНаПечать = МассивОбъектов;	
	КонецЕсли;
	
	ТаблицаНакладныхНаПечать = Новый ТаблицаЗначений;
	ОписаниеТипаТранспортнаяНакладная = Новый ОписаниеТипов("ДокументСсылка.ТранспортнаяНакладная");
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ТранспортнаяНакладная", ОписаниеТипаТранспортнаяНакладная);
	ТаблицаНакладныхНаПечать.Колонки.Добавить("ПорядковыйНомер", ОписаниеТипаЧисло);
	
	ПорядковыйНомер = 0;
	Для Каждого Накладная Из МассивНакладныхНаПечать Цикл 
		СтрокаТаблицы = ТаблицаНакладныхНаПечать.Добавить();	
		СтрокаТаблицы.ТранспортнаяНакладная = Накладная;
		СтрокаТаблицы.ПорядковыйНомер = ПорядковыйНомер;
		ПорядковыйНомер = ПорядковыйНомер  + 1;
	КонецЦикла;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ТТН";
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ.ТранспортнаяНакладная");
	ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыТТН(ТаблицаНакладныхНаПечать);
	
	ЗаполнитьТабличныйДокументТТН(
				ТабличныйДокумент,
				ДанныеДляПечати,
				ОбъектыПечати);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ОписаниеВодительскогоУдостоверения(Серия, Номер)
	
	ПредставлениеУдостоверения = "";
	Если Не ПустаяСтрока(Серия) Тогда
		ПредставлениеУдостоверения = СокрЛП(Серия) + ", ";
	КонецЕсли;
	
	ПредставлениеУдостоверения = ПредставлениеУдостоверения + Номер;
		
	Возврат ПредставлениеУдостоверения;
	
КонецФункции

Функция СтруктураИтоговыеСуммыТТН()
	
	Структура = Новый Структура;
	
	// Инициализация итогов по странице.
	Структура.Вставить("ИтогоМассаБруттоНаСтранице", 0);
	Структура.Вставить("ИтогоМестНаСтранице", 0);
	Структура.Вставить("ИтогоКоличествоНаСтранице", 0);
	Структура.Вставить("ИтогоСуммаНаСтранице", 0);
	Структура.Вставить("ИтогоМассаНеттоНаСтранице", 0);
	
	// Инициализация итогов по документу.
	Структура.Вставить("ИтогоМассаБрутто", 0);
	Структура.Вставить("ИтогоМест", 0);
	Структура.Вставить("ИтогоКоличество", 0);
	Структура.Вставить("ИтогоСумма", 0);
	Структура.Вставить("ИтогоМассаНетто", 0);
	
	Структура.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", 0);
	Структура.Вставить("СуммаПрописью", "");
	
	Возврат Структура;
	
КонецФункции // СтруктураИтоговыеСуммы()

Функция СтруктураДанныеСтрокиТТН()
	
	Структура = Новый Структура;
	Структура.Вставить("Номер", 0);
	Структура.Вставить("Мест", 0);
	Структура.Вставить("Количество", 0);
	Структура.Вставить("Цена", 0);
	Структура.Вставить("Сумма", 0);
	Структура.Вставить("МассаБрутто", 0);
	Структура.Вставить("МассаНетто", 0);
	
	Возврат Структура;
	
КонецФункции // СтруктураДанныеСтроки()

Процедура РассчитатьИтоговыеСуммыТТН(ИтоговыеСуммы, ДанныеСтроки)
	
	// Увеличим итоги по странице.
	ИтоговыеСуммы.ИтогоМестНаСтранице        = ИтоговыеСуммы.ИтогоМестНаСтранице        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = ИтоговыеСуммы.ИтогоКоличествоНаСтранице  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСуммаНаСтранице       = ИтоговыеСуммы.ИтогоСуммаНаСтранице       + ДанныеСтроки.Сумма;
	ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  + ДанныеСтроки.МассаНетто;
	
	// Увеличим итоги по документу.
	ИтоговыеСуммы.ИтогоМест        = ИтоговыеСуммы.ИтогоМест        + ДанныеСтроки.Мест;
	ИтоговыеСуммы.ИтогоКоличество  = ИтоговыеСуммы.ИтогоКоличество  + ДанныеСтроки.Количество;
	ИтоговыеСуммы.ИтогоСумма       = ИтоговыеСуммы.ИтогоСумма       + ДанныеСтроки.Сумма;
	ИтоговыеСуммы.ИтогоМассаБрутто = ИтоговыеСуммы.ИтогоМассаБрутто + ДанныеСтроки.МассаБрутто;
	ИтоговыеСуммы.ИтогоМассаНетто  = ИтоговыеСуммы.ИтогоМассаНетто  + ДанныеСтроки.МассаНетто;
	
КонецПроцедуры

Процедура ОбнулитьИтогиПоСтраницеТТН(ИтоговыеСуммы)
	
	ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = 0;
	ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = 0;
	ИтоговыеСуммы.ИтогоМестНаСтранице        = 0;
	ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = 0;
	ИтоговыеСуммы.ИтогоСуммаНаСтранице       = 0;
	
КонецПроцедуры

Процедура ДобавитьИтоговыеДанныеПодвалаТТН(ИтоговыеСуммы, ВсегоНомеров, ВалютаРегламентированногоУчета)
	
	ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ВсегоНомеров, ,",,,,,,,,0"));
	ИтоговыеСуммы.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСумма, ВалютаРегламентированногоУчета));
	
КонецПроцедуры

Процедура ДобавитьИтоговыеДанныеПодвалаТТНДляНесколькихНакладных(ИтоговыеСуммы, ВсегоНомеров, ВалютаРегламентированногоУчета)
	
	ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ВсегоНомеров, ,",,,,,,,,0"));
	ИтоговыеСуммы.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСумма, ВалютаРегламентированногоУчета));
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыСтрокиТовараТТН(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета, ЕдиницаИзмеренияВеса = Неопределено, КоэффициентПересчетаВТонны = 0)
	
	ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
	ДополнительныеПараметрыПолученияНаименованияДляПечати.ВозвратнаяТара = СтрокаТовары.ЭтоВозвратнаяТара;	
	
	ОбластьМакета.Параметры.ТоварНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
		СтрокаТовары.ТоварНаименование,
		СтрокаТовары.Характеристика,
		,
		,
		ДополнительныеПараметрыПолученияНаименованияДляПечати);
	
	ИспользоватьНаборы = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(СтрокаТовары, "ЭтоНабор");
	
	ДанныеДляРасчетаПостфикса = Новый Структура("ЭтоКомплектующие, ЭтоНабор, ПолныйНабор, 
		|ВариантПредставленияНабораВПечатныхФормах, ВариантРасчетаЦеныНабора, Количество");
	ЗаполнитьЗначенияСвойств(ДанныеДляРасчетаПостфикса, СтрокаТовары);
	ДанныеДляРасчетаПостфикса.Вставить("ЕдиницаИзмерения", СтрокаТовары.БазоваяЕдиницаНаименование);
	
	ПрефиксИПостфикс = НаборыСервер.ПолучитьПрефиксИПостфикс(ДанныеДляРасчетаПостфикса, ИспользоватьНаборы);
	
	ВыводитьЦены = Ложь;
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям
		   ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	ИначеЕсли ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = Перечисления.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие
		И (СтрокаТовары.ВариантРасчетаЦеныНабора = Перечисления.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих) Тогда
		// Область должна остаться незаполненной
		ОбластьМакета.Параметры.Заполнить(НаборыСервер.ПустыеДанные());
	Иначе
		ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
		ВыводитьЦены = Истина;
	КонецЕсли;
	
	ПредставлениеНоменклатуры =  ПрефиксИПостфикс.Префикс
		+ НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
			Строка(СтрокаТовары.ТоварНаименование),
			СтрокаТовары.Характеристика,
			,
			,
			ДополнительныеПараметрыПолученияНаименованияДляПечати)
		+ ПрефиксИПостфикс.Постфикс;
		
	ОбластьМакета.Параметры.ТоварНаименование = ПредставлениеНоменклатуры;
	
	Если ЕдиницаИзмеренияВеса <> Неопределено Тогда
		Если Не ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) Тогда
			ДанныеСтроки.МассаБрутто = 0;
			ДанныеСтроки.МассаНетто = 0;
		Иначе
			ДанныеСтроки.МассаБрутто = СтрокаТовары.МассаБрутто;
			ДанныеСтроки.МассаНетто = СтрокаТовары.МассаНетто;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеСтроки.Сумма = СтрокаТовары.Сумма + СтрокаТовары.СуммаНДС;
	ДанныеСтроки.Цена = ?(СтрокаТовары.Количество = 0, 0, ДанныеСтроки.Сумма / СтрокаТовары.Количество);
	
	Если СтрокаТовары.Весовой Тогда
		ДанныеСтроки.Мест = 0;
		ДанныеСтроки.Количество = 0;
		
		ОбластьМакета.Параметры.Количество = 0;
		ОбластьМакета.Параметры.КоличествоМест = 0;
		ОбластьМакета.Параметры.БазоваяЕдиницаНаименование = "";
		ОбластьМакета.Параметры.ВидУпаковки = "";
		
		Если ВыводитьЦены Тогда
			ОбластьМакета.Параметры.Цена = ДанныеСтроки.Цена / СтрокаТовары.КоэффициентПересчетаВТонны;
			ОбластьМакета.Параметры.Сумма = ДанныеСтроки.Сумма;
		КонецЕсли;
	Иначе
		Если СтрокаТовары.КоличествоМест - Цел(СтрокаТовары.КоличествоМест) > 0 Тогда
			ДанныеСтроки.Мест = Цел(СтрокаТовары.КоличествоМест) + 1;
		Иначе
			ДанныеСтроки.Мест = СтрокаТовары.КоличествоМест;
		КонецЕсли;
		ДанныеСтроки.Количество  = СтрокаТовары.Количество;
		
		ОбластьМакета.Параметры.Количество = ДанныеСтроки.Количество;
		ОбластьМакета.Параметры.КоличествоМест = ДанныеСтроки.Мест;
		ОбластьМакета.Параметры.БазоваяЕдиницаНаименование = СтрокаТовары.БазоваяЕдиницаНаименование;
		ОбластьМакета.Параметры.ВидУпаковки = СтрокаТовары.ВидУпаковки;
		
		Если ВыводитьЦены Тогда
			ОбластьМакета.Параметры.Цена = ДанныеСтроки.Цена;
			ОбластьМакета.Параметры.Сумма = ДанныеСтроки.Сумма;
		КонецЕсли;
	КонецЕсли;
	
	ОбластьМакета.Параметры.МассаНетто = Окр(СтрокаТовары.МассаНетто*КоэффициентПересчетаВТонны, 3, РежимОкругления.Окр15как20);
	
КонецПроцедуры // ЗаполнитьРеквизитыСтрокиТовара()

Процедура ЗаполнитьНомераНакладныхВСтрокеТовараТТН(ДанныеПечати, ВыборкаНомеровТН, ДанныеСтроки, ОбластьМакета)
	
	СтрокаНомеровНакладных = НСтр("ru = 'Товары по накладным: %НомерНакладной%'", Метаданные.Языки.Русский.КодЯзыка);
	СтруктураПоиска = Новый Структура("ТранспортнаяНакладная", ДанныеПечати.Ссылка);
	
	ПредставленияНакладных = Новый Массив;
	
	Пока ВыборкаНомеровТН.НайтиСледующий(СтруктураПоиска) Цикл
		СтруктураШапки = Новый Структура("Дата, Номер");
		ЗаполнитьЗначенияСвойств(СтруктураШапки, ВыборкаНомеровТН);
		ПредставленияНакладных.Добавить(ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(СтруктураШапки));
	КонецЦикла;
	СтрокаНомеровНакладных = СтрЗаменить(СтрокаНомеровНакладных, "%НомерНакладной%", СтрСоединить(ПредставленияНакладных, ", "));
	
	ОбластьМакета.Параметры.ТоварНаименование = СтрокаНомеровНакладных;
	
	ОбластьМакета.Параметры.ТоварКод = "";
	
	ДанныеСтроки.МассаБрутто = 0;
	ДанныеСтроки.МассаНетто = 0;
	ДанныеСтроки.Сумма = 0;	
	ДанныеСтроки.Цена = 0;	
	ДанныеСтроки.Мест = 0;
	ДанныеСтроки.Количество  = 0;
	
	ОбластьМакета.Параметры.Цена = "";
	ОбластьМакета.Параметры.Сумма = "";
	ОбластьМакета.Параметры.Количество = "";
	ОбластьМакета.Параметры.КоличествоМест = "";
	ОбластьМакета.Параметры.БазоваяЕдиницаНаименование = "";
	ОбластьМакета.Параметры.ВидУпаковки = "";
				
КонецПроцедуры

Процедура ЗаполнитьРеквизитыШапкиТТН(ДанныеПечати, Макет, ТабличныйДокумент)
	
	РеквизитыШапки = Новый Структура;
	
	// Выводим общие реквизиты шапки
	СведенияОПокупателе       = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Плательщик,ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетПлательщика);
	СведенияОГрузополучателе  = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата);
	СведенияОГрузоотправитель = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
	
	РеквизитыШапки.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер));
	РеквизитыШапки.Вставить("ДатаДокумента", ДанныеПечати.Дата);
	
	ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьМакета, ДанныеПечати.Ссылка);
		
	ПредставлениеОрганизации = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузоотправитель,
		   "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
	
	ПредставлениеГрузополучателя = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОГрузополучателе, 
		"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны");
	
	ПредставлениеПлательщика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПокупателе,
		"ПолноеНаименование,ЮридическийАдрес,НомерСчета,Банк,БИК,КоррСчет");
		
	РеквизитыШапки.Вставить("ПредставлениеОрганизации", 		ПредставлениеОрганизации);
	РеквизитыШапки.Вставить("ПредставлениеГрузополучателя", 	ПредставлениеГрузополучателя);
	РеквизитыШапки.Вставить("ПредставлениеПлательщика", 		ПредставлениеПлательщика);
	
	РеквизитыШапки.Вставить("ОрганизацияПоОКПО", 		СведенияОГрузоотправитель.КодПоОКПО);
	РеквизитыШапки.Вставить("ГрузополучательПоОКПО", 	СведенияОГрузополучателе.КодПоОКПО);
	РеквизитыШапки.Вставить("ПлательщикПоОКПО", 		СведенияОПокупателе.КодПоОКПО);
	
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, РеквизитыШапки);
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры // ЗаполнитьРеквизитыШапкиТТН()

Процедура ЗаполнитьРеквизитыПодвалаТТН(ДанныеПечати, ИтоговыеСуммы, Макет, ТабличныйДокумент, ЕдиницаИзмеренияВеса = Неопределено, КоэффициентПересчетаВТонны = 0)
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
	ОбластьМакета.Параметры.ПолнаяДатаДокумента = Формат(ДанныеПечати.Дата, "ДЛФ=DD");
	
	// Главный бухгалтер
	ОбластьМакета.Параметры.ФИОГлавБухгалтера 	  = ДанныеПечати.ГлавныйБухгалтер;
	
	ОбластьМакета.Параметры.ФИОРуководителя 	  = ДанныеПечати.Руководитель;
	ОбластьМакета.Параметры.ДолжностьРуководителя = ДанныеПечати.ДолжностьРуководителя;
	
	ОбластьМакета.Параметры.ФИОКладовщика 		  = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ДанныеПечати.Кладовщик, ДанныеПечати.Дата);
	ОбластьМакета.Параметры.ДолжностьКладовщика   = ДанныеПечати.ДолжностьКладовщика;
	
	// Доверенность
	ОбластьМакета.Параметры.ДоверенностьНомер     = ДанныеПечати.ДоверенностьНомер;
	ОбластьМакета.Параметры.ДоверенностьДата      = Формат(ДанныеПечати.ДоверенностьДата, "ДЛФ=DD");
	ОбластьМакета.Параметры.ДоверенностьВыдана    = ДанныеПечати.ДоверенностьВыдана;
	ОбластьМакета.Параметры.ДоверенностьЧерезКого = ДанныеПечати.ДоверенностьЛицо;
	
	Если ИтоговыеСуммы.ИтогоМест > 0 Тогда
		ОбластьМакета.Параметры.ВсегоМестПрописью = ЧислоПрописью(ИтоговыеСуммы.ИтогоМест, ,",,,,,,,,0");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) И ДанныеПечати.МассаБрутто > 0 Тогда
		ОбластьМакета.Параметры.МассаГрузаБуттоПрописью = ЧислоПрописью(ДанныеПечати.МассаБрутто, ,",,,,,,,,0")+ " " + СокрЛП(ЕдиницаИзмеренияВеса) + ".";
		Если КоэффициентПересчетаВТонны <> 0 Тогда
			ОбластьМакета.Параметры.МассаГрузаБрутто = Окр(ДанныеПечати.МассаБрутто * КоэффициентПересчетаВТонны,2,РежимОкругления.Окр15как20);
		КонецЕсли;                  
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) И ДанныеПечати.МассаНетто > 0 Тогда
		ОбластьМакета.Параметры.МассаГрузаНеттоПрописью = ЧислоПрописью(ДанныеПечати.МассаНетто, ,",,,,,,,,0")+ " " + СокрЛП(ЕдиницаИзмеренияВеса) + ".";
		Если КоэффициентПересчетаВТонны <> 0 Тогда
			ОбластьМакета.Параметры.МассаГрузаНетто = Окр(ДанныеПечати.МассаНетто * КоэффициентПересчетаВТонны,2,РежимОкругления.Окр15как20);
		КонецЕсли;                  
	КонецЕсли;
	
	ОбластьМакета.Параметры.КоличествоПорядковыхНомеровЗаписейПрописью = ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью;
	ОбластьМакета.Параметры.ВсегоНаименованийПрописью = ЧислоПрописью(ДанныеПечати.КоличествоНаименований, ,",,,,,,,,0");
	ОбластьМакета.Параметры.СуммаПрописью = ИтоговыеСуммы.СуммаПрописью;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
КонецПроцедуры // ЗаполнитьРеквизитыПодвалаТТН()

Процедура ЗаполнитьРеквизитыТранспортногоРазделаТТН(ДанныеПечати, Макет, ОбластьМакета)
	
	СведенияОПеревозчике = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.Перевозчик, ДанныеПечати.Дата,,ДанныеПечати.БанковскийСчетПеревозчика);
	СведенияОЗаказчикеПеревозок = ФормированиеПечатныхФорм.СведенияОЮрФизЛице(ДанныеПечати.ЗаказчикПеревозки, ДанныеПечати.Дата,,ДанныеПечати.БанковскийСчетЗаказчикаПеревозки);
	
	ОбластьМакета.Параметры.НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер);
	
	ОбластьМакета.Параметры.ПредставлениеПеревозчика = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОПеревозчике, 
		"ПолноеНаименование,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		
	ОбластьМакета.Параметры.ПредставлениеЗаказчикаПеревозок	 = ФормированиеПечатныхФорм.ОписаниеОрганизации(СведенияОЗаказчикеПеревозок, 
		"ПолноеНаименование,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		
	ОбластьМакета.Параметры.ПредставлениеВодителя     = ДанныеПечати.Водитель;	
	ОбластьМакета.Параметры.ВодительскоеУдостоверение = ОписаниеВодительскогоУдостоверения(
			ДанныеПечати.УдостоверениеСерия, 
			ДанныеПечати.УдостоверениеНомер);
			
	ОбластьМакета.Параметры.Заполнить(ДанныеПечати);	
	
	СтандартнаяКарточка  = ДанныеПечати.ЛицензионнаяКарточкаВид = "Стандартная";
	ОграниченнаяКарточка = ДанныеПечати.ЛицензионнаяКарточкаВид = "Ограниченная";
	
	Если СтандартнаяКарточка
		Или ОграниченнаяКарточка Тогда
		ШрифтСтандарт   = Новый Шрифт(ОбластьМакета.Области.Стандарт.Шрифт, , , , , ,Не СтандартнаяКарточка);
		ШрифтОграничено = Новый Шрифт(ОбластьМакета.Области.Стандарт.Шрифт, , , , , ,Не ОграниченнаяКарточка);
	КонецЕсли;

	ОбластьМакета.Области.Стандарт.Шрифт   = ШрифтСтандарт;
	ОбластьМакета.Области.Ограничено.Шрифт = ШрифтОграничено;
	
КонецПроцедуры

Процедура ЗаполнитьТабличныйДокументТТН(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати)
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ЕдиницаИзмеренияВеса           = Константы.ЕдиницаИзмеренияВеса.Получить(); 
	КоэффициентПересчетаВТонны     = НоменклатураСервер.КоэффициентПересчетаВТонны(Константы.ЕдиницаИзмеренияВеса.Получить());

	ДанныеПечати      					  = ДанныеДляПечати.РезультатПоШапке.Выбрать();
	ВыборкаПоДокументам					  = ДанныеДляПечати.РезультатПоТабличнойЧасти.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаПоНомерамТранспортныхНакладных = ДанныеДляПечати.РезультатПоНомерамНакладных.Выбрать();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьТТН.ПФ_MXL_ТТН_ru");
	Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеПечати.Следующий() Цикл
		
		// Если ТТН с доставкой и нашли связанные с доставкой ошибки - перейдем к следующему документу.
		СтруктураЗаданиеНаПеревозку = Новый Структура("НеНайденоЗаданиеНаПеревозку,
													  |БолееОдногоВхожденияВЗаданияНаПеревозку,
													  |РаспоряжениеНеПроведено",
													  Ложь,Ложь,Ложь);
		ЕстьОшибкиДоставки = Ложь;
		ЗаполнитьЗначенияСвойств(СтруктураЗаданиеНаПеревозку,ДанныеПечати);
		Если СтруктураЗаданиеНаПеревозку.НеНайденоЗаданиеНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для документа %1 не найдено задание на перевозку. Печать формы 1-Т для документов с доставкой возможна после включения документа в задание на перевозку.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		Если СтруктураЗаданиеНаПеревозку.БолееОдногоВхожденияВЗаданияНаПеревозку Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно напечатать форму 1-Т для %1, т.к. найдено более одного задания на перевозку, в которые включен этот документ.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		Если СтруктураЗаданиеНаПеревозку.РаспоряжениеНеПроведено Тогда
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Документ %1 не проведен. Печать товарно - транспортной накладной не будет выполнена.'"),
				ДанныеПечати.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			ЕстьОшибкиДоставки = Истина;
		КонецЕсли;
		Если ЕстьОшибкиДоставки Тогда
			Продолжить;
		КонецЕсли;
				
		// Найдем в выборке товары по текущему документу
		СтруктураПоиска = Новый Структура("ПорядковыйНомер", ДанныеПечати.ПорядковыйНомер);
		НайденСледующий = ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		КоличествоСтрок = СтрокаТовары.Количество();
		
		Если ДанныеПечати.ЕстьНепроведенныеДокументыОснования Тогда 
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В документе %1 присутствуют непроведенные документы-основания. Печать товарно - транспортной накладной невозможна.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			
			Продолжить;
			
		КонецЕсли;
		
		// Если в ТТН только услуги - перейдем к следующему документу
		Если КоличествоСтрок = 0 Тогда
			
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'По документу %1 отсутствуют Товары. Печать товарно - транспортной накладной не требуется.'"),
				ДанныеПечати.Ссылка);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				ДанныеПечати.Ссылка);
			
			Продолжить;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
			
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьРеквизитыШапкиТТН(ДанныеПечати, Макет, ТабличныйДокумент);
				
		НомерСтраницы = 1;
		ИтоговыеСуммы = СтруктураИтоговыеСуммыТТН();
		
		ДанныеСтроки = СтруктураДанныеСтрокиТТН();
		
		// Создаем массив для проверки вывода
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть докмента
		ОбластьЗаголовокТаблицы      = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ОбластьМакета                = Макет.ПолучитьОбласть("Строка");
		ОбластьМакетаСтандарт        = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице      = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего                 = Макет.ПолучитьОбласть("Всего");
		ОбластьПодвала               = Макет.ПолучитьОбласть("Подвал");
		ОбластьТранспортногоРаздела  = Макет.ПолучитьОбласть("ТранспортныйРаздел");
		ОбластьСведенийОГрузе        = Макет.ПолучитьОбласть("СведенияОГрузе");
		ОбластьПодвалаСведенийОГрузе = Макет.ПолучитьОбласть("ПодвалСведенийОГрузе");
		ОбластьПогрузочныхОпераций   = Макет.ПолучитьОбласть("ПогрузочныеОперации");
		ОбластьПрочихСведений        = Макет.ПолучитьОбласть("ПрочиеСведения");
		
		ИспользоватьНаборы = Ложь;
		Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(ВыборкаПоДокументам, "ЭтоНабор") Тогда
			ИспользоватьНаборы = Истина;
			ОбластьМакетаНабор         = Макет.ПолучитьОбласть("СтрокаНабор");
			ОбластьМакетаКомплектующие = Макет.ПолучитьОбласть("СтрокаКомплектующие");
		КонецЕсли;
		
		ВыводШапки = 0;
		
		Если ДанныеПечати.ВыводДанныхОТоварномСоставе = Перечисления.ВариантыВыводаДанныхОТоварномСоставе.ТоварныйСостав Тогда
			
			Пока СтрокаТовары.Следующий() Цикл
				
				ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
				
				Если НаборыСервер.ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
					ОбластьМакета = ОбластьМакетаНабор;
				ИначеЕсли НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
					ОбластьМакета = ОбластьМакетаКомплектующие;
				Иначе
					ОбластьМакета = ОбластьМакетаСтандарт;
				КонецЕсли;
				
				ЗаполнитьРеквизитыСтрокиТовараТТН(ДанныеПечати, СтрокаТовары, ДанныеСтроки, ОбластьМакета, ЕдиницаИзмеренияВеса, КоэффициентПересчетаВТонны);
				
				Если ДанныеСтроки.Номер = 1 Тогда // первая строка
				
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				Иначе
					
					МассивВыводимыхОбластей.Очистить();
					МассивВыводимыхОбластей.Добавить(ОбластьМакета);
					МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
					
					Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
						
						МассивВыводимыхОбластей.Добавить(ОбластьВсего);
						МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
						
					КонецЕсли;
					
					Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
						
						ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
						ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
						
						// Очистим итоги по странице.
						ОбнулитьИтогиПоСтраницеТТН(ИтоговыеСуммы);
						
						НомерСтраницы = НомерСтраницы + 1;
						ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
						ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
						ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
						
					КонецЕсли;
					
				КонецЕсли;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
				Если Не НаборыСервер.ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
					РассчитатьИтоговыеСуммыТТН(ИтоговыеСуммы, ДанныеСтроки);
				КонецЕсли;
				
			КонецЦикла;
			КоличествоПорядковыхНомеровЗаписей = ДанныеСтроки.Номер;
			
		Иначе
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ЗаполнитьНомераНакладныхВСтрокеТовараТТН(
					ДанныеПечати, 
					ВыборкаПоНомерамТранспортныхНакладных,
					ДанныеСтроки, 
					ОбластьМакета);
			
				
			ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
			ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
			ТабличныйДокумент.Вывести(ОбластьМакета);
					
			КоличествоПорядковыхНомеровЗаписей = 0;
			
		КонецЕсли;
		
		// Выводим итоги по последней странице
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
 
		Если ДанныеПечати.ВыводДанныхОТоварномСоставе = Перечисления.ВариантыВыводаДанныхОТоварномСоставе.ТоварныйСостав Тогда
			ДобавитьИтоговыеДанныеПодвалаТТН(ИтоговыеСуммы, КоличествоПорядковыхНомеровЗаписей, ВалютаРегламентированногоУчета);
		Иначе
			ДобавитьИтоговыеДанныеПодвалаТТНДляНесколькихНакладных(ИтоговыеСуммы, КоличествоПорядковыхНомеровЗаписей, ВалютаРегламентированногоУчета);
		КонецЕсли;
		ЗаполнитьРеквизитыПодвалаТТН(ДанныеПечати, ИтоговыеСуммы, Макет, ТабличныйДокумент, ЕдиницаИзмеренияВеса, КоэффициентПересчетаВТонны);
		
		ЗаполнитьРеквизитыТранспортногоРазделаТТН(ДанныеПечати, Макет, ОбластьТранспортногоРаздела);
		
		МассивВыводимыхОбластей.Очистить();
		МассивВыводимыхОбластей.Добавить(ОбластьТранспортногоРаздела);
		МассивВыводимыхОбластей.Добавить(ОбластьСведенийОГрузе);
		МассивВыводимыхОбластей.Добавить(ОбластьПодвалаСведенийОГрузе);
		МассивВыводимыхОбластей.Добавить(ОбластьПогрузочныхОпераций);
		Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьТранспортногоРаздела);
		ТабличныйДокумент.Вывести(ОбластьСведенийОГрузе);
		ТабличныйДокумент.Вывести(ОбластьПодвалаСведенийОГрузе);
		ТабличныйДокумент.Вывести(ОбластьПогрузочныхОпераций);
		
		МассивВыводимыхОбластей.Очистить();
		МассивВыводимыхОбластей.Добавить(ОбластьПрочихСведений);
		Если Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьПрочихСведений);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТабличныйДокументТТН()

#КонецОбласти

#КонецОбласти

#КонецЕсли
