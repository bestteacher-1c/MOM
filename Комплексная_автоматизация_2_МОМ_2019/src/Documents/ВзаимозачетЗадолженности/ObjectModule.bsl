#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипОснования = Тип("ДокументСсылка.ОперацияПоЯндексКассе") Тогда
		ЗаполнитьПоОперацииПоЯндексКассе(ДанныеЗаполнения, ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	ДебиторскаяБезРазбиения=Ложь;
	Если ДополнительныеСвойства.Свойство("ДебиторскаяБезРазбиения")
		И ДополнительныеСвойства.ДебиторскаяБезРазбиения Тогда
		ДебиторскаяБезРазбиения = Истина;
	КонецЕсли;
	
	КредиторскаяБезРазбиения=Ложь;
	Если ДополнительныеСвойства.Свойство("КредиторскаяБезРазбиения")
		И ДополнительныеСвойства.КредиторскаяБезРазбиения Тогда
		КредиторскаяБезРазбиения = Истина;
	КонецЕсли;
	
	Документы.ВзаимозачетЗадолженности.ЗаполнитьИменаРеквизитовПоВидуОперации(
		ВидОперации,
		МассивВсехРеквизитов, 
		МассивРеквизитовОперации);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
	
	// Проверим соответствие сумм документа и табличной части.
	Если ДебиторскаяЗадолженность.Итог("СуммаРегл") <> КредиторскаяЗадолженность.Итог("СуммаРегл") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма регламентированного учета по строкам в табличной части ""Задолженность дебитора"" должна равняться сумме регламентированного учета по строкам в табличной части ""Задолженность перед кредитором""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
	КонецЕсли;
	
	// Проверим соответствие сумм документа и табличной части.
	Если ДебиторскаяЗадолженность.Итог("СуммаУпр") <> КредиторскаяЗадолженность.Итог("СуммаУпр") Тогда
		ТекстСообщения = НСтр("ru = 'Сумма управленческого учета по строкам в табличной части ""Задолженность дебитора"" должна равняться сумме управленческого учета по строкам в табличной части ""Задолженность перед кредитором""'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			, // Поле
			,
			Отказ);
	КонецЕсли;
	
	Если ДебиторскаяБезРазбиения И ДебиторскаяЗадолженность.Количество() > 0 И НЕ ЗначениеЗаполнено(ДебиторскаяЗадолженность[0].ВалютаВзаиморасчетов) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена Валюта взаиморасчетов Дебиторской задолженности'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.ДебиторскаяЗадолженность.ТекущиеДанные.ВалютаВзаиморасчетов",
			,
			Отказ);
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.ВалютаВзаиморасчетов");
	КонецЕсли;
	
	Если КредиторскаяБезРазбиения И КредиторскаяЗадолженность.Количество() > 0 И НЕ ЗначениеЗаполнено(КредиторскаяЗадолженность[0].ВалютаВзаиморасчетов) Тогда
		ТекстСообщения = НСтр("ru = 'Не заполнена Валюта взаиморасчетов Кредиторской задолженности'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"Элементы.КредиторскаяЗадолженность.ТекущиеДанные.ВалютаВзаиморасчетов",
			,
			Отказ);
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.ВалютаВзаиморасчетов");
	КонецЕсли;
	
	Если ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		Или ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДебиторскаяЗадолженность.Партнер");
	КонецЕсли;
	Если ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
		Или ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КредиторскаяЗадолженность.Партнер");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СтруктураПредставлений = Документы.ВзаимозачетЗадолженности.ПредставлениеРекизитовПоВидуОперации(ВидОперации);
	ПроверитьСовпадениеЮрЛиц("КонтрагентДебитор", СтруктураПредставлений.КонтрагентДебитор, Отказ);
	Если МассивНепроверяемыхРеквизитов.Найти("КонтрагентКредитор") = Неопределено Тогда
		ПроверитьСовпадениеЮрЛиц("КонтрагентКредитор", СтруктураПредставлений.КонтрагентКредитор, Отказ);
	КонецЕсли;
	Если МассивНепроверяемыхРеквизитов.Найти("ОрганизацияКредитор") = Неопределено Тогда
		ПроверитьСовпадениеЮрЛиц("ОрганизацияКредитор", СтруктураПредставлений.ОрганизацияКредитор, Отказ);
	КонецЕсли;
	
	ВзаимозачетЗадолженностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если ЗначениеЗаполнено(ВидОперации)
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.МеждуКлиентами
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.МеждуПоставщиками
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер
		И ВидОперации <> Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Произвольный Тогда
		
		КонтрагентКредитор = КонтрагентДебитор;
		ТипКредитора = ТипДебитора;
		
	ИначеЕсли ЗначениеЗаполнено(ВидОперации)
		И ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер Тогда
		
		КонтрагентКредитор = КонтрагентДебитор;
		
	КонецЕсли;
	
	СформироватьСписокЗависимыхЗаказов();
	
	// Заполнение реквизитов в табличных частях.
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаполнитьСуммыРеглУпр();
		
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(ДебиторскаяЗадолженность);
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(КредиторскаяЗадолженность);
		
		// В дебиторской задолженности могут быть задолженности клиентов и авансы поставщикам.
		// Дополнительно нужно проверять ТипРасчетов, это делается в ДенежныеСредстваСервер.ЗаполнитьВладельцаОбъектаРасчета
		ЭтоОрганизацияПоставщик = (ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик)
			ИЛИ ТипЗнч(КонтрагентДебитор) = Тип("СправочникСсылка.Организации");
		
		ДенежныеСредстваСервер.ЗаполнитьВладельцаОбъектаРасчета(ЭтотОбъект, ЭтоОрганизацияПоставщик, "ДебиторскаяЗадолженность");
		
		// В кредиторской задолженности могут быть задолженности поставщиков и авансы клиентов.
		// Дополнительно нужно проверять ТипРасчетов, это делается в ДенежныеСредстваСервер.ЗаполнитьВладельцаОбъектаРасчета
		ЭтоОрганизацияПоставщик = (ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик)
			ИЛИ ТипЗнч(КонтрагентКредитор) = Тип("СправочникСсылка.Организации");
		
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.КлиентаМеждуОрганизациями
			Или ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПоставщикаМеждуОрганизациями Тогда
			ДенежныеСредстваСервер.ЗаполнитьВладельцаОбъектаРасчета(ЭтотОбъект, ЭтоОрганизацияПоставщик, "КредиторскаяЗадолженность", ОрганизацияКредитор);
		Иначе
			ДенежныеСредстваСервер.ЗаполнитьВладельцаОбъектаРасчета(ЭтотОбъект, ЭтоОрганизацияПоставщик, "КредиторскаяЗадолженность");
		КонецЕсли;
		
		ЗаполнитьТипРасчетовВТабличнойЧасти(ДебиторскаяЗадолженность, ТипДебитора);
		ЗаполнитьТипРасчетовВТабличнойЧасти(КредиторскаяЗадолженность, ТипКредитора);
		
		РасчетыМеждуОрганизациямиДебитор =
			ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
			Или ТипДебитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик;
		
		РасчетыМеждуОрганизациямиКредитор =
			ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент
			Или ТипКредитора = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияПоставщик;
		
		Если Не РасчетыМеждуОрганизациямиДебитор И ЗначениеЗаполнено(КонтрагентДебитор) Тогда
			ПартнерДебитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(КонтрагентДебитор);
			ЗаполнитьПартнераВТабличнойЧасти(ДебиторскаяЗадолженность, ПартнерДебитор, РасчетыМеждуОрганизациямиДебитор);
			Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Клиента
				ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.КлиентаМеждуОрганизациями
				ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер
				ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Поставщика
				ИЛИ ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.ПоставщикаМеждуОрганизациями Тогда
				ЗаполнитьПартнераВТабличнойЧасти(КредиторскаяЗадолженность, ПартнерДебитор, РасчетыМеждуОрганизациямиКредитор);
			КонецЕсли;
		КонецЕсли;
		
		Если Не РасчетыМеждуОрганизациямиКредитор И ЗначениеЗаполнено(КонтрагентКредитор) Тогда
			ПартнерКредитор = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(КонтрагентКредитор);
			ЗаполнитьПартнераВТабличнойЧасти(КредиторскаяЗадолженность, ПартнерКредитор, РасчетыМеждуОрганизациямиКредитор);
		КонецЕсли;
		
	КонецЕсли;
	
	ВзаимозачетЗадолженностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ВзаимозачетЗадолженности.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по расчетам с поставщиками и клиентами.
	ВзаиморасчетыСервер.ОтразитьРасчетыСКлиентами(ДополнительныеСвойства, Движения, Отказ);
	ВзаиморасчетыСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	
	ВзаиморасчетыСервер.ОтразитьСуммыДокументаВВалютеРегл(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияКонтрагентКонтрагент(ДополнительныеСвойства, Движения, Отказ);
	
	
	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ВзаимозачетЗадолженностиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовПоставщикам.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	СформироватьСписокРегистровДляКонтроля();

	// Запись наборов записей
	ВзаимозачетЗадолженностиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);

	РегистрыСведений.СостоянияЗаказовКлиентов.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	РегистрыСведений.СостоянияЗаказовПоставщикам.ОтразитьСостояниеЗаказа(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;  	
	
	ВзаимозачетЗадолженностиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь()
		И Пользователи.РолиДоступны("ДобавлениеИзменениеДокументовКорректировкиЗадолженностиЗачетОплаты") Тогда
		ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Клиента;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура СформироватьСписокРегистровДляКонтроля()

	Массив = Новый Массив;
	Массив.Добавить(Движения.РасчетыСКлиентами);

	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);

КонецПроцедуры

Процедура СформироватьСписокЗависимыхЗаказов()
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В (&МассивЗаказовДеб)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В(&МассивЗаказовКред)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В(&МассивЗаказовДеб)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В(&МассивЗаказовКред)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В
		|		(ВЫБРАТЬ
		|			ДебиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.ДебиторскаяЗадолженность КАК ДебиторскаяЗадолженность
		|		ГДЕ
		|			ДебиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаказКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В
		|		(ВЫБРАТЬ
		|			КредиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.КредиторскаяЗадолженность КАК КредиторскаяЗадолженность
		|		ГДЕ
		|			КредиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В
		|		(ВЫБРАТЬ
		|			ДебиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.ДебиторскаяЗадолженность КАК ДебиторскаяЗадолженность
		|		ГДЕ
		|			ДебиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка" 
		+ "
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказКлиента.Ссылка КАК ЗаказКлиента
		|ИЗ
		|	Документ.ЗаявкаНаВозвратТоваровОтКлиента КАК ЗаказКлиента
		|ГДЕ
		|	ЗаказКлиента.Ссылка В
		|		(ВЫБРАТЬ
		|			КредиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.КредиторскаяЗадолженность КАК КредиторскаяЗадолженность
		|		ГДЕ
		|			КредиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказКлиента.Ссылка;
		|
		|ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.Ссылка В(&МассивЗаказовДеб)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщику.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.Ссылка В(&МассивЗаказовКред)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщику.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.Ссылка В
		|		(ВЫБРАТЬ
		|			ДебиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.ДебиторскаяЗадолженность КАК ДебиторскаяЗадолженность
		|		ГДЕ
		|			ДебиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщику.Ссылка
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЗаказПоставщику.Ссылка КАК ЗаказПоставщику
		|ИЗ
		|	Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|ГДЕ
		|	ЗаказПоставщику.Ссылка В
		|		(ВЫБРАТЬ
		|			КредиторскаяЗадолженность.Заказ
		|		ИЗ
		|			Документ.ВзаимозачетЗадолженности.КредиторскаяЗадолженность КАК КредиторскаяЗадолженность
		|		ГДЕ
		|			КредиторскаяЗадолженность.Ссылка = &Ссылка)
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаказПоставщику.Ссылка
		|";
	
	Запрос.УстановитьПараметр("МассивЗаказовДеб", ЭтотОбъект.ДебиторскаяЗадолженность.ВыгрузитьКолонку("Заказ"));
	Запрос.УстановитьПараметр("МассивЗаказовКред", ЭтотОбъект.КредиторскаяЗадолженность.ВыгрузитьКолонку("Заказ"));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.ВыполнитьПакет();
	
	МассивЗависимыхЗаказов = Результат[0].Выгрузить().ВыгрузитьКолонку("ЗаказКлиента");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовКлиентов", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
	МассивЗависимыхЗаказов = Результат[1].Выгрузить().ВыгрузитьКолонку("ЗаказПоставщику");
	ЭтотОбъект.ДополнительныеСвойства.Вставить("МассивЗависимыхЗаказовПоставщикам", Новый ФиксированныйМассив(МассивЗависимыхЗаказов));
	
КонецПроцедуры

Процедура ПроверитьСовпадениеЮрЛиц(Реквизит, Представление, Отказ)
	
	ЮрЛицо = ЭтотОбъект[Реквизит];
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ЮрЛицо) И (Организация = ЮрЛицо) Тогда
		Текст = НСтр("ru='Организация и %Контрагент% должны различаться.'");
		Текст = СтрЗаменить(Текст,"%Контрагент%", Представление);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, Реквизит,, Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьТипРасчетовВТабличнойЧасти(ТабличнаяЧасть, ТипКонтрагента)
	
	Если ЗначениеЗаполнено(ТипКонтрагента) Тогда
		
		Если ВидОперации = Перечисления.ВидыОперацийВзаимозачетаЗадолженности.Бартер Тогда
			
			Если ТабличнаяЧасть = ДебиторскаяЗадолженность Тогда
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
			Иначе
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
			КонецЕсли;
			
		Иначе
			
			Если ТипКонтрагента = Перечисления.ТипыУчастниковВзаимозачета.Клиент
				Или ТипКонтрагента = Перечисления.ТипыУчастниковВзаимозачета.ОрганизацияКлиент Тогда
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом;
			Иначе
				ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого СтрокаТаблицы Из ТабличнаяЧасть Цикл
			СтрокаТаблицы.ТипРасчетов = ТипРасчетов;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоОперацииПоЯндексКассе(Знач ДокументОснование, ДанныеЗаполнения)
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
						  | // Данные шапки документа
						  |
						  |	КОНЕЦПЕРИОДА(ДанныеДокумента.Дата, ДЕНЬ) КАК Дата,
	                      |	ЗНАЧЕНИЕ(Перечисление.ВидыОперацийВзаимозачетаЗадолженности.МеждуКлиентами) КАК ВидОперации,
						  |
	                      |	ЗНАЧЕНИЕ(Перечисление.ТипыУчастниковВзаимозачета.Клиент) КАК ТипКредитора,
	                      |	ЗНАЧЕНИЕ(Перечисление.ТипыУчастниковВзаимозачета.Клиент) КАК ТипДебитора,
						  |
						  |	ДанныеДокумента.Организация КАК Организация,
	                      |	ДанныеДокумента.Подразделение КАК Подразделение,
						  |
	                      |	ДанныеДокумента.Контрагент КАК КонтрагентКредитор,
	                      |	ДанныеДокумента.Эквайер КАК КонтрагентДебитор,
						  |
	                      |	ДанныеДокумента.Валюта КАК Валюта,
						  |
	                      |	&Ссылка КАК ДокументОснование,
						  |
						  | // Данные табличных частей
						  |
						  | ЗНАЧЕНИЕ(Перечисление.ТипыРасчетовСПартнерами.РасчетыСКлиентом) КАК ТипРасчетов,
						  |
						  |	ДанныеДокумента.ОбъектРасчетов КАК ЗаказКредитора,
						  |
						  |	ДанныеДокумента.Контрагент.Партнер КАК ПартнерКредитор,
						  |	ДанныеДокумента.Эквайер.Партнер КАК ПартнерДебитор
	                      | 
	                      |ИЗ
	                      |	Документ.ОперацияПоЯндексКассе КАК ДанныеДокумента
	                      |ГДЕ
	                      |	ДанныеДокумента.Ссылка = &Ссылка
	                      |	И ДанныеДокумента.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента)");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);

	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеЗаполнения = Новый Структура;
	Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ДанныеЗаполнения.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
	
	Если ДанныеЗаполнения.ДокументОснование = Неопределено Тогда 
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Не требуется вводить Взаимозачет задолженности на основании документа %1, поскольку ввод доступен только на основании операций Поступления оплаты от клиента'"),
		ДокументОснование);
		ВызватьИсключение Текст;
	КонецЕсли;
	
	Подразделение     = ДанныеЗаполнения.Подразделение;
	ДокументОснование = ДанныеЗаполнения.ДокументОснование;
	Ответственный     = Пользователи.ТекущийПользователь();
	
	// Дебиторская задолженность
	НоваяСтрока = ДебиторскаяЗадолженность.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеЗаполнения);
	НоваяСтрока.Партнер = ДанныеЗаполнения.ПартнерДебитор;
	
	// Кредиторская задолженность
	НоваяСтрока = КредиторскаяЗадолженность.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеЗаполнения);
	НоваяСтрока.Партнер = ДанныеЗаполнения.ПартнерКредитор;
	НоваяСтрока.Заказ = ДанныеЗаполнения.ЗаказКредитора;
	
КонецПроцедуры

Процедура ЗаполнитьСуммыРеглУпр()
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	
	Для Каждого СтрокаЗадолженности Из ДебиторскаяЗадолженность Цикл
		Если СтрокаЗадолженности.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
			СтрокаЗадолженности.СуммаРегл = СтрокаЗадолженности.СуммаВзаиморасчетов;
		КонецЕсли;
		
		Если СтрокаЗадолженности.ВалютаВзаиморасчетов = ВалютаУправленческогоУчета Тогда
			СтрокаЗадолженности.СуммаУпр = СтрокаЗадолженности.СуммаВзаиморасчетов;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого СтрокаЗадолженности Из КредиторскаяЗадолженность Цикл
		Если СтрокаЗадолженности.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
			СтрокаЗадолженности.СуммаРегл = СтрокаЗадолженности.СуммаВзаиморасчетов;
		КонецЕсли;
		
		Если СтрокаЗадолженности.ВалютаВзаиморасчетов = ВалютаУправленческогоУчета Тогда
			СтрокаЗадолженности.СуммаУпр = СтрокаЗадолженности.СуммаВзаиморасчетов;
		КонецЕсли;
	КонецЦикла;
	
	СуммаРегл = ДебиторскаяЗадолженность.Итог("СуммаРегл");
	СуммаУпр = ДебиторскаяЗадолженность.Итог("СуммаУпр");
	
КонецПроцедуры

Процедура ЗаполнитьПартнераВТабличнойЧасти(ОбъектТабличнаяЧасть, ПартнерСсылка, РасчетыМеждуОрганизациями)
	Для Каждого СтрокаТаблицы Из ОбъектТабличнаяЧасть Цикл
		Если РасчетыМеждуОрганизациями Тогда
			СтрокаТаблицы.Партнер = Неопределено;
		ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.Партнер) Тогда
			СтрокаТаблицы.Партнер = ПартнерСсылка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
