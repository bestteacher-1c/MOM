#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ЧекККМ") Тогда
		
		Если ЕстьВозвратПоЧекуККМ(ДанныеЗаполнения) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Чек ККМ на возврат. Ввод Чека ККМ коррекции запрещен!'");
		КонецЕсли;
		
		Если ЕстьКоррекцияПоЧекуККМ(ДанныеЗаполнения) Тогда
			ВызватьИсключение НСтр("ru = 'По Чеку ККМ введен Чек ККМ коррекции. Ввод нового Чека ККМ коррекции запрещен!'");
		КонецЕсли;
		
		ЗаполнитьДокументПоЧекуККМ(ДанныеЗаполнения);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("Товары") Тогда
		
		ЗаполнитьДокументПоЧекуККМ(ДанныеЗаполнения);
		Товары.Очистить();
		
		ВозвращаемыеТовары = ПолучитьИзВременногоХранилища(ДанныеЗаполнения.Товары);
		
		Для Каждого СтрокаТЧ Из ВозвращаемыеТовары Цикл
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
			
			НоваяСтрока.КоличествоДо = СтрокаТЧ.Количество;
			НоваяСтрока.КоличествоУпаковокДо = СтрокаТЧ.КоличествоУпаковок;
			НоваяСтрока.ЦенаДо = СтрокаТЧ.Цена;
			НоваяСтрока.СуммаДо = СтрокаТЧ.Сумма;
			НоваяСтрока.СтавкаНДСДо = СтрокаТЧ.СтавкаНДС;
			НоваяСтрока.СуммаНДСДо = СтрокаТЧ.СуммаНДС;
		КонецЦикла;

	ИначеЕсли ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если Не ДанныеЗаполнения.Свойство("ЧтениеКомандФормы") Тогда
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(ЧекККМ) Тогда
			ВызватьИсключение НСтр("ru = 'Чек ККМ коррекции необходимо вводить на основании чека ККМ'");
		КонецЕсли;
		
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторДляРМК();
		Если ЗначениеЗаполнено(КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		Иначе
			ВызватьИсключение НСтр("ru = 'Для текущего рабочего места не настроено подключаемое оборудование: Фискальный регистратор'");
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыЧековККМ.Отложен;
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru='Чек ККМ пробит. Отмена проведения невозможна'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ОбщегоНазначенияУТ.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ));
	
	РозничныеПродажи.СопоставитьАлкогольнуюПродукциюСНоменклатурой(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ЧекККМКоррекции.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства); // Ссылка = ЧекККМ
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ЗапасыСервер.ОтразитьСвободныеОстатки(ДополнительныеСвойства, Движения, Отказ);
	ЗапасыСервер.ОтразитьТоварыНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СформироватьСписокРегистровДляКонтроля();
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ВызватьИсключение НСтр("ru = 'Копирование документа ""Чек ККМ коррекции"" запрещено!'");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	ИспользуетсяРегистрацияРозничныхПродажВЕГАИС = ИнтеграцияЕГАИСВызовСервера.ИспользуетсяРегистрацияРозничныхПродажВЕГАИС(
		Организация, Склад, Дата);
	Если ИспользуетсяРегистрацияРозничныхПродажВЕГАИС Тогда
		РозничныеПродажи.ПроверитьЗаполнениеАкцизныхМарокЧека(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	
	Кассир = Пользователи.ТекущийПользователь();
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	ПараметрыЗаполнения.Организация = Организация;
	ПараметрыЗаполнения.Дата = Дата;
	ПараметрыЗаполнения.Склад = Склад;
	ПараметрыЗаполнения.РозничнаяПродажа = Истина;
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	ОрганизацияЕГАИС = РозничныеПродажи.ПолучитьОрганизациюЕГАИС(Склад, Организация);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,,"Кассир");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоЧекуККМ(ДокументОснование)
	
	// Заполним данные шапки документа.
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЧекККМ.Валюта КАК Валюта,
	|	ЧекККМ.Ссылка КАК ЧекККМ,
	|	ЧекККМ.Дата КАК ДатаЧекаККМ,
	|	ЧекККМ.ВидЦены КАК ВидЦены,
	|	ЧекККМ.Организация КАК Организация,
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.Склад КАК Склад,
	|	ЧекККМ.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЧекККМ.НалогообложениеНДС КАК НалогообложениеНДС,
	|	ЧекККМ.ПолученоНаличными КАК ПолученоНаличными,
	|	ЧекККМ.Статус КАК Статус,
	|	ЧекККМ.Проведен КАК Проведен,
	|	ЧекККМ.Партнер КАК Партнер,
	|	ЧекККМ.ФормаОплаты КАК ФормаОплаты
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	ВЫРАЗИТЬ(ВЫБОР
	|			КОГДА Товары.СуммаРучнойСкидки + Товары.СуммаАвтоматическойСкидки + Товары.СуммаБонусныхБалловКСписаниюВВалюте = 0
	|					ИЛИ Товары.КоличествоУпаковок = 0
	|				ТОГДА Товары.Цена
	|			ИНАЧЕ Товары.Сумма / Товары.КоличествоУпаковок
	|		КОНЕЦ КАК ЧИСЛО(31, 2)) КАК Цена,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	Товары.Помещение КАК Помещение,
	|	Товары.Продавец КАК Продавец
	|ПОМЕСТИТЬ врТовары
	|ИЗ
	|	Документ.ЧекККМ.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НоменклатураЕГАИС КАК НоменклатураЕГАИС,
	|	Товары.НоменклатураНабора КАК НоменклатураНабора,
	|	Товары.ХарактеристикаНабора КАК ХарактеристикаНабора,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Упаковка КАК Упаковка,
	|	Товары.СтавкаНДС КАК СтавкаНДС,
	|	Товары.Цена КАК Цена,
	|	Товары.Помещение КАК Помещение,
	|	Товары.Продавец КАК Продавец,
	|	Товары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Товары.Количество КАК Количество,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СуммаНДС КАК СуммаНДС
	|ИЗ
	|	врТовары КАК Товары
	|ГДЕ
	|	Товары.Количество > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Серия КАК Серия,
	|	Серии.Помещение КАК Помещение,
	|	Серии.Количество КАК Количество
	|ПОМЕСТИТЬ врСерии
	|ИЗ
	|	Документ.ЧекККМ.Серии КАК Серии
	|ГДЕ
	|	Серии.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Номенклатура КАК Номенклатура,
	|	Серии.Характеристика КАК Характеристика,
	|	Серии.Серия КАК Серия,
	|	Серии.Помещение КАК Помещение,
	|	СУММА(Серии.Количество) КАК Количество
	|ИЗ
	|	врСерии КАК Серии
	|
	|СГРУППИРОВАТЬ ПО
	|	Серии.Номенклатура,
	|	Серии.Характеристика,
	|	Серии.Серия,
	|	Серии.Помещение
	|
	|ИМЕЮЩИЕ
	|	СУММА(Серии.Количество) > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АкцизныеМарки.АкцизнаяМарка КАК АкцизнаяМарка,
	|	АкцизныеМарки.Справка2 КАК Справка2,
	|	АкцизныеМарки.ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	|	АкцизныеМарки.КодАкцизнойМарки КАК КодАкцизнойМарки
	|ИЗ
	|	Документ.ЧекККМ.АкцизныеМарки КАК АкцизныеМарки
	|ГДЕ
	|	АкцизныеМарки.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОплатаПлатежнымиКартами.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	ОплатаПлатежнымиКартами.КодАвторизации КАК КодАвторизации,
	|	ОплатаПлатежнымиКартами.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	ОплатаПлатежнымиКартами.Сумма КАК Сумма,
	|	ОплатаПлатежнымиКартами.СсылочныйНомер КАК СсылочныйНомер,
	|	ОплатаПлатежнымиКартами.НомерЧекаЭТ КАК НомерЧекаЭТ
	|ИЗ
	|	Документ.ЧекККМ.ОплатаПлатежнымиКартами КАК ОплатаПлатежнымиКартами
	|ГДЕ
	|	ОплатаПлатежнымиКартами.Ссылка = &Ссылка
	|	И НЕ (ОплатаПлатежнымиКартами.ЭквайринговыйТерминал, ОплатаПлатежнымиКартами.КодАвторизации, ОплатаПлатежнымиКартами.НомерПлатежнойКарты, ОплатаПлатежнымиКартами.Сумма) В
	|				(ВЫБРАТЬ
	|					Т.ЭквайринговыйТерминал,
	|					Т.КодАвторизации,
	|					Т.НомерПлатежнойКарты,
	|					Т.Сумма
	|				ИЗ
	|					Документ.ЧекККМВозврат.ОплатаПлатежнымиКартами КАК Т
	|				ГДЕ
	|					Т.Ссылка.ЧекККМ = &Ссылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЧекККМПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ЧекККМПодарочныеСертификаты.Сумма КАК Сумма,
	|	ЧекККМПодарочныеСертификаты.СуммаВВалютеСертификата КАК СуммаВВалютеСертификата
	|ИЗ
	|	Документ.ЧекККМ.ПодарочныеСертификаты КАК ЧекККМПодарочныеСертификаты
	|ГДЕ
	|	ЧекККМПодарочныеСертификаты.Ссылка = &Ссылка";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[0].Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, ,"Статус, Проведен");
	ДатаСовершенияКорректируемогоРасчета = Выборка.ДатаЧекаККМ;
	
	СтруктураСостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(Выборка.КассаККМ);
	КассоваяСмена = СтруктураСостояниеКассовойСмены.КассоваяСмена;
	
	Если Не Выборка.Проведен Тогда
		ТекстОшибки = НСтр("ru='Чек ККМ не проведен. Ввод на основании невозможен.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Выборка.Статус <> Перечисления.СтатусыЧековККМ.Пробит Тогда
		ТекстОшибки = НСтр("ru='Чек ККМ не пробит. Ввод на основании невозможен.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Товары.Загрузить(РезультатЗапроса[2].Выгрузить());
	Серии.Загрузить(РезультатЗапроса[4].Выгрузить());
	АкцизныеМарки.Загрузить(РезультатЗапроса[5].Выгрузить());
	ОплатаПлатежнымиКартами.Загрузить(РезультатЗапроса[6].Выгрузить());
	ПодарочныеСертификаты.Загрузить(РезультатЗапроса[7].Выгрузить());
	
	Статус = Перечисления.СтатусыЧековККМ.Отложен;
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ЕстьВозвратПоЧекуККМ(ЧекККМ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекККМВозврат.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекККМВозврат КАК ЧекККМВозврат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
	|		ПО ЧекККМВозврат.Ссылка = ФискальныеОперации.ДокументОснование
	|			И (ФискальныеОперации.НомерЧекаККМ <> &ПустаяСтрока)
	|ГДЕ
	|	ЧекККМВозврат.Проведен
	|	И ЧекККМВозврат.ЧекККМ = &ЧекККМ";
	Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
	Запрос.УстановитьПараметр("ПустаяСтрока", "");
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ЕстьКоррекцияПоЧекуККМ(ЧекККМ)
	
	// По документу ЧекККМ нет ранее созданного документа ЧекККМКоррекция
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЧекККМКоррекции.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ЧекККМКоррекции КАК ЧекККМКоррекции
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ФискальныеОперации КАК ФискальныеОперации
	|		ПО ЧекККМКоррекции.ЧекККМ = ФискальныеОперации.ДокументОснование
	|			И (ФискальныеОперации.НомерЧекаККМ <> &ПустаяСтрока)
	|ГДЕ
	|	ЧекККМКоррекции.Проведен
	|	И ЧекККМКоррекции.ЧекККМ = &ЧекККМ";
	Запрос.УстановитьПараметр("ЧекККМ", ЧекККМ);
	Запрос.УстановитьПараметр("ПустаяСтрока", "");
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Процедура формирует список регистров для контроля.
//
Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.СвободныеОстатки);
		Массив.Добавить(Движения.ТоварыНаСкладах);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
