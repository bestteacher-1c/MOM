#Область СлужебныйПрограммныйИнтерфейс

#Область РазобратьКодМаркировкиСлужебный

Функция ЭлементКодаМаркировкиСоответствуетОписанию(Значение, ОписаниеЭлементаКМ, СоставКодаМаркировки, ПараметрыОписанияКодаМаркировки) Экспорт
	
	Если ОписаниеЭлементаКМ.Имя = "ШтрихкодАкцизнойМарки" Тогда
		
		ТипШтрихкода = Неопределено;
		Если Не ШтрихкодированиеЕГАИС.ЭтоШтрихкодАкцизнойМарки(Значение, ТипШтрихкода) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ТипШтрихкода = Перечисления.ТипыШтрихкодов.PDF417 Тогда
			КодАлкогольнойПродукции = АкцизныеМаркиВызовСервера.КодКлассификатораНоменклатурыЕГАИС(Значение);
			Если ЗначениеЗаполнено(КодАлкогольнойПродукции) Тогда
				НовоеОписаниеЭлементаКМ = ОписаниеЭлементаКодаМаркировки("", "КодАлкогольнойПродукции", 0);
				ШтрихкодированиеИССлужебный.ЗаполнитьСоставКодаМаркировки(СоставКодаМаркировки, НовоеОписаниеЭлементаКМ, КодАлкогольнойПродукции);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПреобразоватьЗначениеДляЗаполненияСоставаКодаМаркировки(ПараметрыОписанияКодаМаркировки, СоставКодаМаркировки, ОписаниеЭлементаКМ, Значение) Экспорт
	Возврат;
КонецПроцедуры

Функция НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки) Экспорт
	
	СоставКодаМаркировки = Новый Структура;
	
	Возврат СоставКодаМаркировки;
	
КонецФункции

Процедура ДополнитьНастройкиРазбораКодаМаркировки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля) Экспорт
	
	Если ВидПродукции <> Перечисления.ВидыПродукцииИС.Алкогольная Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеКодаМаркировкиАкцизнойМарки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля);
	ОписаниеКодаМаркировкиАкцизнойМаркиСтарыйФормат(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля);
	
	// Упаковки
	ОписаниеКодаМаркировкиЛогистическойУпаковки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля);
	ОписаниеКодаМаркировкиЛогистическойУпаковкиРасширенный(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля);
	
	// Код маркировки произвольной длины/состава оставляем без описания и определение
	// вида продукции выполняем в обработчике ЭтоНеФормализованныйКодМаркировки.
	
КонецПроцедуры

Функция ЭтоНеФормализованныйКодМаркировки(ПараметрыРазбораКодаМаркировки, Настройки, ДанныеРезультата) Экспорт
	
	ВидПродукции = Перечисления.ВидыПродукцииИС.Алкогольная;
	
	Если Настройки.ДоступныеВидыПродукции.Найти(ВидПродукции) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ФильтрПоВидуПродукции = ПараметрыРазбораКодаМаркировки.ФильтрПоВидуПродукции;
	Если ФильтрПоВидуПродукции.Использовать
		И ФильтрПоВидуПродукции.ВидыПродукции.Найти(ВидПродукции) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстОшибки = "";
	СтруктураШтрихкода = АкцизныеМаркиКлиентСервер.РазложитьШтрихкодСНомеромИСерией(ПараметрыРазбораКодаМаркировки.КодМаркировки, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидыПродукции = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВидПродукции));
	
	
	ТипШтрихкодаИВидУпаковки = ШтрихкодированиеИССлужебный.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix;
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = Перечисления.ВидыУпаковокИС.АкцизнаяМаркаСНомеромИСерией;
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	СоставКодаМаркировки.Вставить("ТипМарки",   СтруктураШтрихкода.ТипМарки);
	СоставКодаМаркировки.Вставить("СерияМарки", СтруктураШтрихкода.СерияМарки);
	СоставКодаМаркировки.Вставить("НомерМарки", СтруктураШтрихкода.НомерМарки);
	
	ДанныеРезультата = ШтрихкодированиеИССлужебный.НовыйРезультатРазбораКодаМаркировки();
	ДанныеРезультата.КодМаркировки        = ПараметрыРазбораКодаМаркировки.КодМаркировки;
	ДанныеРезультата.ТипШтрихкода         = ТипШтрихкодаИВидУпаковки.ТипШтрихкода;
	ДанныеРезультата.ВидУпаковки          = ТипШтрихкодаИВидУпаковки.ВидУпаковки;
	ДанныеРезультата.ВидыПродукции        = ВидыПродукции;
	ДанныеРезультата.СоставКодаМаркировки = СоставКодаМаркировки;
	
	НормализованныйКодМаркировки = ШтрихкодированиеИССлужебный.НормализоватьКодМаркировки(
		ДанныеРезультата, ВидПродукции);
	
	ДанныеРезультата.НормализованныйКодМаркировки = НормализованныйКодМаркировки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РазобратьКодМаркировкиСлужебный

Процедура ОписаниеКодаМаркировкиАкцизнойМарки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля)
	
	ОписаниеЭлементовКМ = Новый Структура("ШтрихкодАкцизнойМарки");
	ОписаниеЭлементовКМ.ШтрихкодАкцизнойМарки = ОписаниеЭлементаКодаМаркировки("", "ШтрихкодАкцизнойМарки", 150);
	
	ШаблоныСтрокой = Новый Массив;
	ШаблоныСтрокой.Добавить("ШтрихкодАкцизнойМарки");
	
	СписокШаблонов = ШтрихкодированиеИССлужебный.ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой);
	
	ТипШтрихкодаИВидУпаковки = ШтрихкодированиеИССлужебный.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = Перечисления.ТипыШтрихкодов.DataMatrix;
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = Перечисления.ВидыУпаковокИС.Потребительская;
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	
	Для Каждого ОписаниеШаблонаКодаМаркировки Из СписокШаблонов Цикл
		
		НастройкаОписанияКодаМаркировки = Новый Структура(
			"ВидПродукции, ТипШтрихкодаИВидУпаковки, СоставКодаМаркировки, ОписаниеШаблонаКодаМаркировки, ДанныеОбщегоМодуля");
		НастройкаОписанияКодаМаркировки.ВидПродукции                  = ВидПродукции;
		НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки      = ТипШтрихкодаИВидУпаковки;
		НастройкаОписанияКодаМаркировки.СоставКодаМаркировки          = СоставКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки = ОписаниеШаблонаКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля            = ДанныеОбщегоМодуля;
		
		ШтрихкодированиеИССлужебный.ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(
			НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОписаниеКодаМаркировкиАкцизнойМаркиСтарыйФормат(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля)
	
	ОписаниеЭлементовКМ = Новый Структура("ШтрихкодАкцизнойМарки");
	ОписаниеЭлементовКМ.ШтрихкодАкцизнойМарки = ОписаниеЭлементаКодаМаркировки("", "ШтрихкодАкцизнойМарки", 68);
	
	ШаблоныСтрокой = Новый Массив;
	ШаблоныСтрокой.Добавить("ШтрихкодАкцизнойМарки");
	
	СписокШаблонов = ШтрихкодированиеИССлужебный.ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой);
	
	ТипШтрихкодаИВидУпаковки = ШтрихкодированиеИССлужебный.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = Перечисления.ТипыШтрихкодов.PDF417;
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = Перечисления.ВидыУпаковокИС.Потребительская;
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	СоставКодаМаркировки.Вставить("КодАлкогольнойПродукции", "");
	
	Для Каждого ОписаниеШаблонаКодаМаркировки Из СписокШаблонов Цикл
		
		НастройкаОписанияКодаМаркировки = Новый Структура(
			"ВидПродукции, ТипШтрихкодаИВидУпаковки, СоставКодаМаркировки, ОписаниеШаблонаКодаМаркировки, ДанныеОбщегоМодуля");
		НастройкаОписанияКодаМаркировки.ВидПродукции                  = ВидПродукции;
		НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки      = ТипШтрихкодаИВидУпаковки;
		НастройкаОписанияКодаМаркировки.СоставКодаМаркировки          = СоставКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки = ОписаниеШаблонаКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля            = ДанныеОбщегоМодуля;
		
		ШтрихкодированиеИССлужебный.ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(
			НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОписаниеКодаМаркировкиЛогистическойУпаковки(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля)
	
	// Формат маркировки для паллеты
	
	Алфавит = НастройкиРазбораКодаМаркировки.Алфавит;
	
	ОписаниеЭлементовКМ = Новый Структура("КодФСРАР, ПорядковыйНомер");
	ОписаниеЭлементовКМ.КодФСРАР        = ОписаниеЭлементаКодаМаркировки("", "КодФСРАР",       12, Алфавит.Цифры);
	ОписаниеЭлементовКМ.ПорядковыйНомер = ОписаниеЭлементаКодаМаркировки("", "ПорядковыйНомер", 6, Алфавит.Цифры);
	
	ШаблоныСтрокой = Новый Массив;
	ШаблоныСтрокой.Добавить("КодФСРАР + ПорядковыйНомер");
	
	СписокШаблонов = ШтрихкодированиеИССлужебный.ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой);
	
	ТипШтрихкодаИВидУпаковки = ШтрихкодированиеИССлужебный.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = Перечисления.ТипыШтрихкодов.Code128;
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = Перечисления.ВидыУпаковокИС.Логистическая;
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	
	Для Каждого ОписаниеШаблонаКодаМаркировки Из СписокШаблонов Цикл
		
		НастройкаОписанияКодаМаркировки = Новый Структура(
			"ВидПродукции, ТипШтрихкодаИВидУпаковки, СоставКодаМаркировки, ОписаниеШаблонаКодаМаркировки, ДанныеОбщегоМодуля");
		НастройкаОписанияКодаМаркировки.ВидПродукции                  = ВидПродукции;
		НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки      = ТипШтрихкодаИВидУпаковки;
		НастройкаОписанияКодаМаркировки.СоставКодаМаркировки          = СоставКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки = ОписаниеШаблонаКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля            = ДанныеОбщегоМодуля;
		
		ШтрихкодированиеИССлужебный.ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(
			НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОписаниеКодаМаркировкиЛогистическойУпаковкиРасширенный(НастройкиРазбораКодаМаркировки, ВидПродукции, ДанныеОбщегоМодуля)
	
	// Формат маркировки для короба
	// http://egais.ru/files/format_tara6.pdf
	
	Алфавит = НастройкиРазбораКодаМаркировки.Алфавит;
	
	ОписаниеЭлементовКМ = Новый Структура("КодФСРАР, ТипЛогистическойЕдиницы, НомерПлощадки, Год, СерийныйНомер");
	ОписаниеЭлементовКМ.КодФСРАР                = ОписаниеЭлементаКодаМаркировки("", "КодФСРАР",               12, Алфавит.Цифры); // идентификатор организации в ЕГАИС, осуществляющей маркировку групповой тары (FSRAR_ID). (12 знаков).
	ОписаниеЭлементовКМ.ТипЛогистическойЕдиницы = ОписаниеЭлементаКодаМаркировки("", "ТипЛогистическойЕдиницы", 1, Алфавит.Цифры); // тип логистической единицы (1- короб, 2- паллет, 3-сборный короб, 4-сборный паллет).
	ОписаниеЭлементовКМ.НомерПлощадки           = ОписаниеЭлементаКодаМаркировки("", "НомерПлощадки",           2, Алфавит.БуквыЦифры); // номер линии розлива/площадки маркировки.
	ОписаниеЭлементовКМ.Год                     = ОписаниеЭлементаКодаМаркировки("", "Год",                     2, Алфавит.Цифры); // год, в который производится генерация групповой маркировки.
	ОписаниеЭлементовКМ.СерийныйНомер           = ОписаниеЭлементаКодаМаркировки("", "СерийныйНомер",           9, Алфавит.БуквыЦифры); // логистический идентификатор, счетчик, обнуляемый в начале каждого года.
	
	ШаблоныСтрокой = Новый Массив;
	ШаблоныСтрокой.Добавить("КодФСРАР + ТипЛогистическойЕдиницы + НомерПлощадки + Год + СерийныйНомер");
	
	СписокШаблонов = ШтрихкодированиеИССлужебный.ОписанияШаблоновКодаМаркировки(ОписаниеЭлементовКМ, ШаблоныСтрокой);
	
	ТипШтрихкодаИВидУпаковки = ШтрихкодированиеИССлужебный.ТипШтрихкодаИВидУпаковки();
	ТипШтрихкодаИВидУпаковки.ТипШтрихкода = Перечисления.ТипыШтрихкодов.Code128;
	ТипШтрихкодаИВидУпаковки.ВидУпаковки  = Перечисления.ВидыУпаковокИС.Логистическая;
	
	СоставКодаМаркировки = НовыйСоставКодаМаркировки(ТипШтрихкодаИВидУпаковки);
	
	Для Каждого ОписаниеШаблонаКодаМаркировки Из СписокШаблонов Цикл
		
		НастройкаОписанияКодаМаркировки = Новый Структура(
			"ВидПродукции, ТипШтрихкодаИВидУпаковки, СоставКодаМаркировки, ОписаниеШаблонаКодаМаркировки, ДанныеОбщегоМодуля");
		НастройкаОписанияКодаМаркировки.ВидПродукции                  = ВидПродукции;
		НастройкаОписанияКодаМаркировки.ТипШтрихкодаИВидУпаковки      = ТипШтрихкодаИВидУпаковки;
		НастройкаОписанияКодаМаркировки.СоставКодаМаркировки          = СоставКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ОписаниеШаблонаКодаМаркировки = ОписаниеШаблонаКодаМаркировки;
		НастройкаОписанияКодаМаркировки.ДанныеОбщегоМодуля            = ДанныеОбщегоМодуля;
		
		ШтрихкодированиеИССлужебный.ДобавитьОписаниеШаблонаКодаМаркировкиВидаПродукции(
			НастройкиРазбораКодаМаркировки, НастройкаОписанияКодаМаркировки);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОписаниеЭлементаКодаМаркировки(Код, Имя, КоличествоЗнаков, АлфавитДопустимыхСимволов = "")
	Возврат ШтрихкодированиеИССлужебный.ОписаниеЭлементаКодаМаркировки(Код, Имя, КоличествоЗнаков, АлфавитДопустимыхСимволов);
КонецФункции

#КонецОбласти

#КонецОбласти
