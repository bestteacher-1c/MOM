#Область ПрограммныйИнтерфейс

// Обработчик команды формы, требующей контекстного вызова сервера.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой выполняется команда.
//   ПараметрыВызова - Структура - параметры вызова.
//   Источник - ТаблицаФормы, ДанныеФормыСтруктура - объект или список формы с полем "Ссылка".
//   Результат - Структура - результат выполнения команды.
//
Процедура ВыполнитьПереопределяемуюКоманду(Знач Форма, Знач ПараметрыВызова, Знач Источник, Результат) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФорм

// Серверная переопределяемая процедура, вызываемая при заполнении реквизитов формы созданных ИСМП (при открытии)
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//
Процедура ЗаполнениеРеквизитовФормы(Форма) Экспорт
	
	//++ НЕ ГОСИС
	Если СтрНачинаетсяС(Форма.ИмяФормы,"Документ.ЧекККМ.")
		Или СтрНачинаетсяС(Форма.ИмяФормы,"Документ.ЧекККМВозврат.")
		Или СтрНачинаетсяС(Форма.ИмяФормы,"Справочник.ШаблоныЭтикетокИЦенников.") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыИнтеграции = Неопределено;
	Для Каждого ВидПродукции Из ИнтеграцияИСКлиентСервер.ВидыПродукцииИСМП(Истина) Цикл
		ПараметрыИнтеграции = Форма.ПараметрыИнтеграцииГосИС.Получить(ВидПродукции);
		Если ПараметрыИнтеграции <> Неопределено Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыИнтеграции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыИнтеграции.ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
		
		Объект = ПараметрыИнтеграции.ИмяРеквизитаФормыОбъект;
		Товары = ПараметрыИнтеграции.ИмяТабличнойЧастиТовары;
		
		ПараметрыЗаполненияРеквизитов = Новый Структура;
		ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
		ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
		НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Форма[Объект][Товары],ПараметрыЗаполненияРеквизитов);
		Для Каждого СтрокаТаблицы Из Форма[Объект][Товары] Цикл
			Если СтрокаТаблицы.МаркируемаяПродукция И СтрокаТаблицы.ВидПродукцииИС = Перечисления.ВидыПродукцииИС.Алкогольная Тогда
				СтрокаТаблицы.МаркируемаяПродукция = Ложь;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределение параметров интеграции ИСМП (расположения команды проверки и подбора)
//
// Параметры:
//   Форма                - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   СтандартнаяОбработка - Булево - стандартная работа с элементами проверки подбора
//
Процедура ПриОпределенииПараметровИнтеграции(Форма, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "ОбщаяФорма.ПроверкаЗаполненияДокументов"
		Или Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ПомощникНового"
		Или Форма.ИмяФормы = "Справочник.ШаблоныЭтикетокИЦенников.Форма.ФормаРедактированияШаблонаЭтикетокИЦенников" Тогда
			СтандартнаяОбработка = Ложь;
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
			СтандартнаяОбработка = Ложь;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

//Переопределение параметров интеграции ИСМП (расположения форматированной строки перехода к связанному объекту)
//
//Параметры:
//   Форма            - ФормаКлиентскогоПриложения - прикладная форма для встраивания форматированной строки
//   ПараметрыНадписи - Структура        - (см. СобытияФормИСМП.ПараметрыИнтеграцииГиперссылкиИСМП)
//
Процедура ПриОпределенииПараметровИнтеграцииГиперссылкиИСМП(Форма, ПараметрыНадписи) Экспорт
	
	//++ НЕ ГОСИС
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "Объект")
		И ТипЗнч(Форма.Объект) = Тип("ДанныеФормыСтруктура")
		И ИнтеграцияИСМП.ИспользуетсяИнтеграцияВФормеДокументаОснования(Форма, Форма.Объект) Тогда
		
		ПараметрыНадписи.Вставить("ИмяЭлементаФормы",  "ТекстДокументаИСМП");
		ПараметрыНадписи.Вставить("ИмяРеквизитаФормы", "ТекстДокументаИСМП");
		
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы, "ГруппаСостояние")
		//++ НЕ УТ
		И Форма.ИмяФормы <> "Документ.ЗаказПереработчику.Форма.ФормаДокумента" 
		//-- НЕ УТ
		Тогда
		ПараметрыНадписи.РазмещениеВ = "ГруппаСостояние";
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "ОбщаяФорма.ПроверкаЗаполненияДокументов" Тогда
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуПроверкиЗаполненияДокументов(Форма);
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуРМК(Форма);
	
	ИначеЕсли Форма.ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровОтКлиента.Форма.ФормаДокумента" Тогда
		
		СобытияФормИСМПКлиентСервер.ДополнительныеПараметрыИнтеграции(Форма, Истина);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	//++ НЕ ГОСИС
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		ИнтеграцияИСУТ.МодифицироватьИнициализироватьФормуРМК(Форма);
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФорм

// Серверная переопределяемая процедура, вызываемая из обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Строка           - имя элемента-источника события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	Если Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента" Тогда
		
		ПроверкаИПодборПродукцииИСМП.ПрименитьКешШтрихкодовУпаковок(Форма, Истина);
		
	ИначеЕсли Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		
		Если Элемент = "Событие" И СтрНачинаетсяС(ДополнительныеПараметры.ИмяСобытия,"ЗакрытиеФормыПроверкиИПодбораГосИС") Тогда
			
			ИндексВидаПродукции     = Число(СтрЗаменить(ДополнительныеПараметры.ИмяСобытия, "ЗакрытиеФормыПроверкиИПодбораГосИС", ""));
			ВидМаркируемойПродукции = ИнтеграцияИСКлиентСервер.ИндексВидаПродукцииИС(ИндексВидаПродукции);
				
			ПроверкаИПодборПродукцииИСМПУТ.ПриЗакрытииФормыПроверкиИПодбораВФормеРМК(
				Форма,
				ДополнительныеПараметры.Параметр,
				ВидМаркируемойПродукции);
			
		КонецЕсли;
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыВыбора

// Устанавливает параметры выбора номенклатуры.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора
//  ВидПродукцииИС - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
//  ИмяПоляВвода - Строка - имя поля ввода номенклатуры.
Процедура УстановитьПараметрыВыбораНоменклатуры(Форма, ВидПродукцииИС = Неопределено, ИмяПоляВвода = "ТоварыНоменклатура") Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = Новый Массив;
	ИнтеграцияИСМПУТКлиентСервер.ЗаполнитьПараметрыВыбораНоменклатурыПоВидуПродукции(ПараметрыВыбора, ВидПродукцииИС);
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Устанавливает параметры выбора шаблона этикетки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора,
//  ИмяПоляВвода - Строка - имя поля ввода шаблона этикетки.
Процедура УстановитьПараметрыВыбораШаблонаЭтикетки(Форма,  ИмяПоляВвода) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора, Ложь);
	
	Назначение = ПредопределенноеЗначение("Перечисление.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаКодМаркировкиИСМП");
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Назначение", Назначение));
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Устанавливает параметры выбора контрагента.
//
//Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, в которой нужно установить параметры выбора.
//   ТолькоЮрЛицаНерезиденты - Неопределено, Булево - Признак нерезидента.
//   ИмяПоляВвода            - Строка               - имя поля ввода номенклатуры.
//
Процедура УстановитьПараметрыВыбораКонтрагента(Форма, ТолькоЮрЛицаНерезиденты = Неопределено, ИмяПоляВвода = "Контрагент") Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыВыбора = ОбщегоНазначения.СкопироватьРекурсивно(Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора, Ложь);
	
	Если ТолькоЮрЛицаНерезиденты = Истина Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ЮрФизЛицо", Перечисления.ЮрФизЛицо.ЮрЛицоНеРезидент));
	КонецЕсли;
	
	Форма.Элементы[ИмяПоляВвода].ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет действия при изменении номенклатуры в строке табличной части.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - редактируемая строка таблицы,
//  КэшированныеЗначения   - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - Структура - (См. ПроверкаИПодборПродукцииМОТП.ПараметрыУказанияСерий).
Процедура ПриИзмененииНоменклатуры(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Характеристика") Тогда
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",
			ТекущаяСтрока.Характеристика);
			
		СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
			Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",
			Новый Структура("Номенклатура", "ТипНоменклатуры"));
		
		Если ПараметрыУказанияСерий <> Неопределено И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта) Тогда
			ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
		Иначе
			ИсточникЗначенийВФорме = Форма;
		КонецЕсли;
	
		Склад = Неопределено;
		Если ПараметрыУказанияСерий <> Неопределено И Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
		КонецЕсли;
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
			Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Артикул") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "ЕдиницаИзмерения") Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения", Новый Структура("Номенклатура", "ЕдиницаИзмерения"));
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС",   Новый Структура("НалогообложениеНДС, Дата", 
			ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС")));
	КонецЕсли;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", Истина);
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаНДС")
		И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СтавкаНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "СуммаСНДС") Тогда
		СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Сумма") Тогда
		СтруктураДействий.Вставить("ПересчитатьСумму");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "КодТНВЭД") Тогда
		СтруктураДействий.Вставить("ЗаполнитьКодТНВЭД");
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества (поле КоличествоУпаковок) в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
	
		Если Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
			СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
				Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад));
				
		КонецЕсли;
		
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении подобранного количества (поле Количество) в строке таблицы формы.
//
// Параметры:
//  Форма - ФормаУправляемогоПриложения - форма, в которой произошло событие,
//  ТекущаяСтрока - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура - сохраненные значения параметров, используемых при обработке,
//  ПараметрыУказанияСерий - ФиксированнаяСтруктура - параметры указаний серий формы
Процедура ПриИзмененииКоличестваЕдиниц(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Упаковка") Тогда
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ТекущаяСтрока, "Серия") Тогда
		ИсточникЗначенийВФорме = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта];
	
		Если Не ПустаяСтрока(ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			Склад = ИсточникЗначенийВФорме[ПараметрыУказанияСерий.ИмяПоляСклад];
			СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
				Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад));
				
		КонецЕсли;
		
	КонецЕсли;
	
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Заполняет табличную часть Товары подобранными товарами.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, в которой производится подбор,
//  ВыбранноеЗначение - Произвольный - данные, содержащие подобранную пользователем номенклатуру,
Процедура ОбработкаРезультатаПодбораНоменклатуры(Форма, ВыбранноеЗначение, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресТоваровВХранилище);
	КэшированныеЗначения = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения();
	
	ТекущаяСтрока = Неопределено;
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		ТекущаяСтрока = Форма.Объект.Товары.Добавить();
		
		СписокСвойств = "Номенклатура, Характеристика, Упаковка";
		Если ТекущаяСтрока.Свойство("КоличествоУпаковок") Тогда
			СписокСвойств = СписокСвойств + ", КоличествоУпаковок";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СтрокаТовара, СписокСвойств);
		
		СтруктураДействий = Новый Структура;
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
		
		Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиниц Тогда
			СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц");
		КонецЕсли;
		
		Если ПараметрыЗаполнения.ЗаполнитьИндексАкцизнойМарки Тогда
			СтруктураДействий.Вставить("ЗаполнитьИндексАкцизнойМарки");
		КонецЕсли;
		
		Если ПараметрыЗаполнения.ПересчитатьСумму Тогда
			СтруктураДействий.Вставить("ПересчитатьСумму");
		КонецЕсли;
		
		СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",
			Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, "Товары"));
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	КонецЦикла;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		Форма.Элементы.Товары.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти