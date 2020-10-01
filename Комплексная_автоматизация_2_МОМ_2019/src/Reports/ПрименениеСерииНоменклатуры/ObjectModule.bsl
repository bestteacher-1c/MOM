#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - Структура - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.РазрешеноИзменятьВарианты = Ложь;
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("Номенклатура");
		Для каждого ЭлементПараметр Из КомпоновщикНастроекФормы.Настройки.ПараметрыДанных.Элементы Цикл
			Если ЭлементПараметр.Параметр = ЗначениеПоиска Тогда
				ЭлементПараметр.ПредставлениеПользовательскойНастройки = НСтр("ru = 'Комплектующая'");
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ОтборНоменклатура = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение;
	ОтборСерия = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение;
	
	Если НЕ ЗначениеЗаполнено(ОтборНоменклатура) Тогда
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
			ТекстСообщения = НСтр("ru = 'Поле ""Полуфабрикат или материал"" не заполнено.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Поле ""Комплектующая"" не заполнено.'");
		КонецЕсли; 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ОтборСерия) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Серия"" не заполнено.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ); 
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	#Область Инициализация
	ИспользоватьПроизводство = ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство");
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Номенклатура", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Номенклатура").Значение);
	ПараметрыОтчета.Вставить("Характеристика", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Характеристика").Значение);
	ПараметрыОтчета.Вставить("Серия", КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(НастройкиОсновнойСхемы, "Серия").Значение);
	
	СтруктураСерииДерево = ПрименениеСерииНоменклатуры(ПараметрыОтчета);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.ПрименениеСерииНоменклатуры.ПФ_MXL_ПрименениеСерииНоменклатуры");
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПараметры = Макет.ПолучитьОбласть("Параметры");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("ПустаяСтрока");
	#КонецОбласти
	
	// Вывод области Заголовок
	#Область ОбластьЗаголовок
	ПараметрыОбласти = Новый Структура("ТекстЗаголовка", НСтр("ru = 'Применение серии номенклатуры'"));
	ОбластьЗаголовок.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьЗаголовок);
	#КонецОбласти
	
	// Вывод области Параметры
	#Область ОбластьПараметры
	ПараметрыОбласти = Новый Структура;
	ПредставлениеНоменклатуры = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
										Строка(ПараметрыОтчета.Номенклатура), 
										Строка(ПараметрыОтчета.Характеристика));
										
	ПараметрыОбласти.Вставить("ОтборНоменклатура", ПредставлениеНоменклатуры);
	ПараметрыОбласти.Вставить("ОтборСерия", Строка(ПараметрыОтчета.Серия));
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Полуфабрикат или материал'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстМатериал", НСтр("ru = 'Комплектующая'"));
	КонецЕсли;
	ОбластьПараметры.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ДокументРезультат.Вывести(ОбластьПустаяСтрока, 1,, Истина);
	ДокументРезультат.Вывести(ОбластьПараметры, 2,, Истина);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	ДокументРезультат.Вывести(ОбластьПустаяСтрока);
	#КонецОбласти

	// Вывод области Шапка
	#Область ОбластьШапка
	ПараметрыОбласти = Новый Структура;
	Если ИспользоватьПроизводство Тогда
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Продукция или полуфабрикат'"));
		ПараметрыОбласти.Вставить("ТекстПроизведено", НСтр("ru = 'Произведено'"));
	Иначе
		ПараметрыОбласти.Вставить("ТекстПродукция", НСтр("ru = 'Комплект'"));
		ПараметрыОбласти.Вставить("ТекстПроизведено", НСтр("ru = 'Собрано'"));
	КонецЕсли;
	ОбластьШапка.Параметры.Заполнить(ПараметрыОбласти);
	ДокументРезультат.Вывести(ОбластьШапка);
	#КонецОбласти
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, 0, ДокументРезультат);
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПрименениеСерииНоменклатуры(Параметры)
	
	ПрименениеСерииНоменклатурыДерево = Новый ДеревоЗначений;
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("Произведено", Новый ОписаниеТипов("Число"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("ЕдиницаИзмерения", Новый ОписаниеТипов("Строка"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("НоменклатураПредставление", Новый ОписаниеТипов("Строка"));
	ПрименениеСерииНоменклатурыДерево.Колонки.Добавить("СерияПредставление", Новый ОписаниеТипов("Строка"));
	
	ПрименениеСерииКоллекция = ПрименениеСерииНоменклатурыДерево.Строки;
	
	СписокНоменклатуры = Новый ТаблицаЗначений;
	СписокНоменклатуры.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	СписокНоменклатуры.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	СписокНоменклатуры.Колонки.Добавить("Строки");
	
	НоваяСтрока = СписокНоменклатуры.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Параметры);
	НоваяСтрока.Строки = ПрименениеСерииКоллекция;
	
	// Для предотвращения зацикливания
	ОтработаннаяНоменклатура = Новый ТаблицаЗначений;
	ОтработаннаяНоменклатура.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ОтработаннаяНоменклатура.Колонки.Добавить("Серия", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	
	ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), Параметры);
	
	ОтборПоХарактеристике = ЗначениеЗаполнено(Параметры.Характеристика);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Пока СписокНоменклатуры.Количество() <> 0 Цикл
		
		НовыйСписокНоменклатуры = СписокНоменклатуры.СкопироватьКолонки();
		
		ПроизведенныеСерии = ПроизведенныеСерии(СписокНоменклатуры, ОтборПоХарактеристике);
		
		Если НЕ ОтборПоХарактеристике Тогда
			
			ОтборПоХарактеристике = Истина;
			
			СписокНоменклатуры.Очистить();
			
			Колонки = "НоменклатураСписка, ХарактеристикаСписка, СерияСписка";
			ПроизведенныеСерииКопия = ПроизведенныеСерии.Скопировать(, Колонки);
			ПроизведенныеСерииКопия.Свернуть(Колонки);
			
			Для каждого Строка Из ПроизведенныеСерииКопия Цикл
				
				НоваяСтрока = СписокНоменклатуры.Добавить();
				НоваяСтрока.Номенклатура = Строка.НоменклатураСписка;
				НоваяСтрока.Характеристика = Строка.ХарактеристикаСписка;
				НоваяСтрока.Серия = Строка.СерияСписка;
				НоваяСтрока.Строки = ПрименениеСерииКоллекция;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Для каждого СтрокаНоменклатура Из СписокНоменклатуры Цикл
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("НоменклатураСписка", СтрокаНоменклатура.Номенклатура);
			СтруктураПоиска.Вставить("ХарактеристикаСписка", СтрокаНоменклатура.Характеристика);
			СтруктураПоиска.Вставить("СерияСписка", СтрокаНоменклатура.Серия);
			
	  		СписокСтрок = ПроизведенныеСерии.НайтиСтроки(СтруктураПоиска);
			Для каждого СтрокаСерияИзделия Из СписокСтрок Цикл
				
				НоваяСерия = СтрокаНоменклатура.Строки.Добавить();
				
				ЗаполнитьЗначенияСвойств(НоваяСерия, СтрокаСерияИзделия);
				
				НоваяСерия.НоменклатураПредставление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
					СтрокаСерияИзделия.НоменклатураПредставление,
					СтрокаСерияИзделия.ХарактеристикаПредставление);
																
				Если ЗначениеЗаполнено(НоваяСерия.Серия) Тогда
					
					СтруктураПоиска = Новый Структура("Номенклатура, Характеристика, Серия");
					ЗаполнитьЗначенияСвойств(СтруктураПоиска, НоваяСерия);
					
					СписокСтрок = ОтработаннаяНоменклатура.НайтиСтроки(СтруктураПоиска);
					
					Если СписокСтрок.Количество() = 0 Тогда
						
						НоваяНоменклатура = НовыйСписокНоменклатуры.Добавить();
						ЗаполнитьЗначенияСвойств(НоваяНоменклатура, НоваяСерия);
						НоваяНоменклатура.Строки = НоваяСерия.Строки;
						
						ЗаполнитьЗначенияСвойств(ОтработаннаяНоменклатура.Добавить(), НоваяСерия);
						
					КонецЕсли;
					
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЦикла;
		
		СписокНоменклатуры = НовыйСписокНоменклатуры.Скопировать();
		
	КонецЦикла; 
	
	Возврат ПрименениеСерииНоменклатурыДерево;

КонецФункции

Функция ПроизведенныеСерии(СписокНоменклатуры, ОтборПоХарактеристике)
	
	ТекстыЗапроса = Новый Массив;
	
	#Область СписокНоменклатуры
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Номенклатура КАК Справочник.Номенклатура) КАК Номенклатура,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	|	ВЫРАЗИТЬ(СписокНоменклатуры.Серия КАК Справочник.СерииНоменклатуры) КАК Серия
	|ПОМЕСТИТЬ СписокНоменклатуры
	|ИЗ
	|	&СписокНоменклатуры КАК СписокНоменклатуры
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия");
	
	#КонецОбласти
	
	//++ НЕ УТ
	#Область РасходСерийПриПроизводстве21
	
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ДвижениеСерии.Документ КАК Документ
	|ПОМЕСТИТЬ СписаниеЗатратНаВыпускБезРаспоряжений
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			&ОтборПоСпискуНоменклатуры
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.СписаниеМатериаловНаЗатраты)
	|				И Документ ССЫЛКА Документ.СписаниеЗатратНаВыпуск) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ");
	
	#КонецОбласти
	//-- НЕ УТ
	
	
	//++ НЕ УТ
	#Область РасходСерийПриПроизводстве22
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ЕСТЬNULL(СпрПартииПроизводства.Документ, ДвижениеСерии.Документ) КАК Документ
	|ПОМЕСТИТЬ РасходСерийПриПроизводствеБезЗаказа
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			&ОтборПоСпискуНоменклатуры
	|				И (СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПотреблениеМатериаловПриПроизводстве)
	|						И ТИПЗНАЧЕНИЯ(Документ) = ТИП(Документ.ПроизводствоБезЗаказа)
	|					ИЛИ Документ В
	|						(ВЫБРАТЬ
	|							РаспределениеЗатрат.Ссылка КАК Ссылка
	|						ИЗ
	|							Документ.РаспределениеПроизводственныхЗатрат КАК РаспределениеЗатрат
	|						ГДЕ
	|							ИСТИНА В
	|								(ВЫБРАТЬ
	|									ИСТИНА
	|								ИЗ
	|									Документ.РаспределениеПроизводственныхЗатрат.ПартииПроизводства КАК ПартииПроизводства
	|										ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|										ПО
	|											ПартииПроизводства.ПартияПроизводства = СпрПартииПроизводства.Ссылка
	|								ГДЕ
	|									ПартииПроизводства.Ссылка = РаспределениеЗатрат.Ссылка
	|									И ТИПЗНАЧЕНИЯ(СпрПартииПроизводства.Документ) = ТИП(Документ.ПроизводствоБезЗаказа)
	|									И СпрПартииПроизводства.Документ <> ЗНАЧЕНИЕ(Документ.ПроизводствоБезЗаказа.ПустаяСсылка))))) КАК ДвижениеСерии
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РаспределениеПроизводственныхЗатрат.ПартииПроизводства КАК ПартииПроизводства
	|		ПО ДвижениеСерии.Документ = ПартииПроизводства.Ссылка
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииПроизводства КАК СпрПартииПроизводства
	|		ПО (ПартииПроизводства.ПартияПроизводства = СпрПартииПроизводства.Ссылка)
	|			И (ТИПЗНАЧЕНИЯ(СпрПартииПроизводства.Документ) = ТИП(Документ.ПроизводствоБезЗаказа))
	|			И (СпрПартииПроизводства.Документ <> ЗНАЧЕНИЕ(Документ.ПроизводствоБезЗаказа.ПустаяСсылка))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|");
	#КонецОбласти
	//-- НЕ УТ
	
	
	#Область РасходСерииПриСборке
	
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДвижениеСерии.Номенклатура КАК Номенклатура,
	|	ДвижениеСерии.Характеристика КАК Характеристика,
	|	ДвижениеСерии.Серия КАК Серия,
	|	ВЫРАЗИТЬ(ДвижениеСерии.Документ КАК Документ.СборкаТоваров) КАК Документ,
	|	ДвижениеСерии.КоличествоОборот КАК Количество
	|ПОМЕСТИТЬ РасходСерииПриСборке
	|ИЗ
	|	РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			&ОтборПоСпискуНоменклатуры
	|				И СкладскаяОперация В (ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКомплектующихДляСборки),
	|										ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки))) КАК ДвижениеСерии
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Документ");
	
	#КонецОбласти
	
	#Область ПриходСерий
	ТекстыЗапроса.Добавить(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.НоменклатураСписка КАК НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка КАК ХарактеристикаСписка, 
	|	ВложенныйЗапрос.СерияСписка КАК СерияСписка,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.Представление КАК НоменклатураПредставление,
	|	ВложенныйЗапрос.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.Характеристика.Представление КАК ХарактеристикаПредставление,
	|	ВложенныйЗапрос.Серия КАК Серия,
	|	ВложенныйЗапрос.Серия.Представление КАК СерияПредставление,
	|	СУММА(ВложенныйЗапрос.Произведено) КАК Произведено
	|ИЗ
	|(
	|	ВЫБРАТЬ
	|		РасходСерииПриСборке.Номенклатура КАК НоменклатураСписка,
	|		РасходСерииПриСборке.Характеристика КАК ХарактеристикаСписка,
	|		РасходСерииПриСборке.Серия КАК СерияСписка,
	|		ПоступлениеСерииПриСборке.Номенклатура КАК Номенклатура,
	|		ПоступлениеСерииПриСборке.Характеристика КАК Характеристика,
	|		ПоступлениеСерииПриСборке.Серия КАК Серия,
	|		ПоступлениеСерииПриСборке.КоличествоОборот КАК Произведено
	|	ИЗ 	
	|		РегистрНакопления.ДвиженияСерийТоваров.Обороты(
	|			,
	|			,
	|			,
	|			Документ В
	|					(ВЫБРАТЬ
	|						РасходСерииПриСборке.Документ
	|					ИЗ
	|						РасходСерииПриСборке КАК РасходСерииПриСборке)
	|				И СкладскаяОперация = ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ПриемкаПродукцииИзПроизводства)) КАК ПоступлениеСерииПриСборке
	|		ЛЕВОЕ СОЕДИНЕНИЕ РасходСерииПриСборке КАК РасходСерииПриСборке
	|		ПО РасходСерииПриСборке.Документ = ПоступлениеСерииПриСборке.Документ
	//++ НЕ УТ
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Номенклатура КАК НоменклатураСписка,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Характеристика КАК ХарактеристикаСписка,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Серия КАК СерияСписка,
	|		ТаблицаВыпуск.Номенклатура КАК Номенклатура,
	|		ТаблицаВыпуск.Характеристика КАК Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия 
	|		КОНЕЦ КАК Серия,
	|		СУММА(ЕСТЬNULL(ТаблицаСерии.Количество, ТаблицаВыпуск.Количество)) КАК Произведено
	|	ИЗ 
	|		СписаниеЗатратНаВыпускБезРаспоряжений КАК СписаниеЗатратНаВыпускБезРаспоряжений
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СписаниеЗатратНаВыпуск.ВыходныеИзделия КАК ТаблицаВыходныеИзделия
	|			ПО ТаблицаВыходныеИзделия.Ссылка = СписаниеЗатратНаВыпускБезРаспоряжений.Документ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Товары КАК ТаблицаВыпуск
	|			ПО ТаблицаВыпуск.Ссылка = ТаблицаВыходныеИзделия.Распоряжение
	|				И ТаблицаВыпуск.Номенклатура = ТаблицаВыходныеИзделия.Номенклатура
	|				И ТаблицаВыпуск.Характеристика = ТаблицаВыходныеИзделия.Характеристика
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыпускПродукции.Серии КАК ТаблицаСерии
	|			ПО ТаблицаСерии.Ссылка = ТаблицаВыпуск.Ссылка
	|				И ТаблицаСерии.Номенклатура = ТаблицаВыпуск.Номенклатура
	|				И ТаблицаСерии.Характеристика = ТаблицаВыпуск.Характеристика
	|				И ТаблицаСерии.Склад = ТаблицаВыпуск.Склад
	|				И ТаблицаСерии.Подразделение = ТаблицаВыпуск.Подразделение
	|
	|	СГРУППИРОВАТЬ ПО
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Номенклатура,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Характеристика,
	|		СписаниеЗатратНаВыпускБезРаспоряжений.Серия,
	|		ТаблицаВыпуск.Номенклатура,
	|		ТаблицаВыпуск.Характеристика,
	|		ВЫБОР
	|			КОГДА ТаблицаВыпуск.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|				ТОГДА ТаблицаВыпуск.Серия
	|			ИНАЧЕ ТаблицаСерии.Серия
	|		КОНЕЦ
	//-- НЕ УТ
	|) КАК ВложенныйЗапрос
	|ГДЕ
	|	НЕ(ВложенныйЗапрос.НоменклатураСписка = ВложенныйЗапрос.Номенклатура
	|		И ВложенныйЗапрос.ХарактеристикаСписка = ВложенныйЗапрос.Характеристика
	|		И ВложенныйЗапрос.СерияСписка = ВложенныйЗапрос.Серия)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.НоменклатураСписка,
	|	ВложенныйЗапрос.ХарактеристикаСписка,
	|	ВложенныйЗапрос.СерияСписка,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Характеристика,
	|	ВложенныйЗапрос.Серия
	|
	|УПОРЯДОЧИТЬ ПО
	|	НоменклатураПредставление,
	|	ХарактеристикаПредставление,
	|	СерияПредставление");
	#КонецОбласти
	
	Разделитель = 
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	
	ТекстЗапроса = СтрСоединить(ТекстыЗапроса, Разделитель);
	
	Если ОтборПоХарактеристике Тогда
		
		ОтборПоСпискуНенклатуры = 
		"(Номенклатура, Характеристика, Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Характеристика,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры)";
		
	Иначе
		
		ОтборПоСпискуНенклатуры = 
		"(Номенклатура, Серия) В
		|					(ВЫБРАТЬ
		|						СписокНоменклатуры.Номенклатура,
		|						СписокНоменклатуры.Серия
		|					ИЗ
		|						СписокНоменклатуры)";
		
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоСпискуНоменклатуры", ОтборПоСпискуНенклатуры);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СписокНоменклатуры", СписокНоменклатуры);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Результат.Индексы.Добавить("НоменклатураСписка,СерияСписка");
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьСтрокиРекурсивно(СтруктураСерииДерево, ОбластьСтрока, Уровень, ДокументРезультат)

	Для каждого СтрокаДерева Из СтруктураСерииДерево.Строки Цикл
		
		ПараметрыОбласти = Новый Структура("Номенклатура,Серия,НоменклатураПредставление,
											|СерияПредставление,ЕдиницаИзмерения,Произведено");
		ЗаполнитьЗначенияСвойств(ПараметрыОбласти, СтрокаДерева);
		
		СтруктураРасшифровки = Новый Структура("Номенклатура,Характеристика,Серия");
		ЗаполнитьЗначенияСвойств(СтруктураРасшифровки, СтрокаДерева);
		ПараметрыОбласти.Вставить("СтруктураРасшифровки", СтруктураРасшифровки);
		
		ОбластьСтрока.Параметры.Заполнить(ПараметрыОбласти);
		ДокументРезультат.Вывести(ОбластьСтрока, Уровень,, Истина);
		
		ЗаполнитьСтрокиРекурсивно(СтрокаДерева, ОбластьСтрока, Уровень + 1, ДокументРезультат);
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
