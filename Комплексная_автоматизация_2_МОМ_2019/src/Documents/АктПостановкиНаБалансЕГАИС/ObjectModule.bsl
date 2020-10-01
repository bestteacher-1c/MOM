#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ТТНВходящаяЕГАИС") Тогда
		
		ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3;
		ЗаполнитьНаОснованииТТНВходящейЕГАИС(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

	Иначе
		
		ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ИнтеграцияИС.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.АктПостановкиНаБалансЕГАИС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ИнтеграцияИС.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	ИнтеграцияИСПереопределяемый.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	ИнтеграцияИС.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
	ИнтеграцияИС.ОчиститьДополнительныеСвойстваДляПроведения(ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	АкцизныеМаркиЕГАИС.ПроверитьЗаполнениеАкцизныхМарок(ЭтотОбъект, Отказ);
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаПостановкиНаБаланс");
	КонецЕсли;
	
	Если ПричинаПостановкиНаБаланс <> Перечисления.ПричиныПостановкиНаБалансЕГАИС.Пересортица Тогда
		МассивНепроверяемыхРеквизитов.Добавить("АктСписанияЕГАИС");
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр3 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоСправке1");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерТТН");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаТТН");
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаРозлива");
	КонецЕсли;
	
	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр1
		Или ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВРегистр2 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Справка2");
	КонецЕсли;
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Идентификатор) Тогда
		Идентификатор = ИнтеграцияЕГАИС.НовыйИдентификаторДокумента();
	КонецЕсли;
	
	Если СтатусПроверкиИПодбора <> Перечисления.СтатусыПроверкиИПодбораИС.Выполняется Тогда
		ДанныеПроверкиИПодбора = Неопределено;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияЕГАИС.СопоставитьАлкогольнуюПродукциюСНоменклатурой(ЭтотОбъект);
	
	ИнтеграцияЕГАИСПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияЕГАИС.ЗаписатьСтатусДокументаЕГАИСПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование       = Неопределено;
	Идентификатор           = "";
	ИдентификаторЕГАИС      = "";
	ДатаРегистрацииДвижений = '00010101';
	
	Если Товары.Количество() > 0 Тогда
		Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "Справка2");
	КонецЕсли;
	
	СтатусПроверкиИПодбора = Перечисления.СтатусыПроверкиИПодбораИС.НеВыполнялось;
	ДанныеПроверкиИПодбора = Неопределено;
	АкцизныеМарки.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьНаОснованииТТНВходящейЕГАИС(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	РезультатыЗапроса = ИнтеграцияЕГАИС.РезультатыЗапросаПередачиВРегистры2и3ПоТТНВходящей(ДанныеЗаполнения);
	
	РеквизитыДокумента = РезультатыЗапроса[0].Выбрать();
	РеквизитыДокумента.Следующий();
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		
		ИнтеграцияИСПереопределяемый.ПроверитьВозможностьВводаНаОсновании(
			РеквизитыДокумента.ДокументОснование,,
			РеквизитыДокумента.ЕстьОшибкиПроведен,,);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДокумента);
		
	КонецЕсли;
	
	Товары.Очистить();
	АкцизныеМарки.Очистить();
	
	ТоварыАкцизныеМаркиОснования = РезультатыЗапроса[РезультатыЗапроса.Количество() - 1].Выгрузить();
	
	Если ТоварыАкцизныеМаркиОснования.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(
			НСтр("ru='В %1 отсутствует алкогольная продукция для заполнения.'"),
			ДанныеЗаполнения);
	КонецЕсли;
	
	Для Каждого СтрокаАкцизнойМарки Из ТоварыАкцизныеМаркиОснования Цикл
		ЗаполнитьЗначенияСвойств(АкцизныеМарки.Добавить(), СтрокаАкцизнойМарки);
	КонецЦикла;
	
	ТоварыАкцизныеМаркиОснования.Свернуть("Справка2,АлкогольнаяПродукция,Номенклатура,Характеристика,Серия", "Количество");
	
	Для Каждого СтрокаТовара Из ТоварыАкцизныеМаркиОснования Цикл
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТовара);
		НоваяСтрока.КоличествоУпаковок = НоваяСтрока.Количество;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
