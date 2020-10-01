#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Склад)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Производит расчет доступных остатков планируемых поступлений и записывает их в одноименный регистр сведений.
//
// Параметры:
//  МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Содержит таблицу "ВтТовары", содержащую товары
//  для которых необходимо рассчитать доступные остатки.
//
Процедура РассчитатьОстаткиГрафикаДвиженияТоваров(МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;

	Запрос.Текст = ТекстРасчетаДоступныхОстатков();

	ПакетРезультатов = Запрос.ВыполнитьПакет();

	МенеджерВременныхТаблиц.Закрыть();

	ЗаписиРегистра = ПакетРезультатов[ПакетРезультатов.Количество() - 1].Выгрузить();
	ВсегоЗаписей = ЗаписиРегистра.Количество();
	Индекс = 0;

	ДоступныеОстатки = РегистрыНакопления.ГрафикПоступленияТоваров.ТаблицаДоступныеОстатки(
		ПакетРезультатов[ПакетРезультатов.Количество() - 2].Выбрать());

	КлючЗаписи = Новый Структура("Номенклатура, Характеристика, Склад");

	НаборЗаписей = РегистрыСведений.ДоступныеОстаткиПланируемыхПоступлений.СоздатьНаборЗаписей();
	Для Каждого Запись Из ДоступныеОстатки Цикл

		Если КлючИзменился(КлючЗаписи, Запись) Тогда

			Пока Индекс < ВсегоЗаписей И Не КлючИзменился(КлючЗаписи, ЗаписиРегистра[Индекс]) Цикл

				ЗаписатьНаборВРегистрДоступныеОстатки(НаборЗаписей, ЗаписиРегистра[Индекс], "Удаление");
				Индекс = Индекс + 1;

			КонецЦикла;

			ЗаполнитьЗначенияСвойств(КлючЗаписи, Запись);

		КонецЕсли;

		Пока Индекс < ВсегоЗаписей И Не КлючИзменился(КлючЗаписи, ЗаписиРегистра[Индекс])
			И ЗаписиРегистра[Индекс].ДатаДоступности > Запись.ДатаДоступности Цикл

				ЗаписатьНаборВРегистрДоступныеОстатки(НаборЗаписей, ЗаписиРегистра[Индекс], "Удаление");
				Индекс = Индекс + 1;

			КонецЦикла;
		
		Если Индекс < ВсегоЗаписей И Не КлючИзменился(КлючЗаписи, ЗаписиРегистра[Индекс])
			И Запись.ДатаДоступности = ЗаписиРегистра[Индекс].ДатаДоступности Тогда

			Если Запись.Количество = ЗаписиРегистра[Индекс].Количество Тогда
					Индекс = Индекс + 1;
				Продолжить;
			Иначе
				ЗаписатьНаборВРегистрДоступныеОстатки(НаборЗаписей, Запись, "Запись");
				Индекс = Индекс + 1;
			КонецЕсли;

		Иначе

			ЗаписатьНаборВРегистрДоступныеОстатки(НаборЗаписей, Запись, "Запись");

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстРасчетаДоступныхОстатков()
	
	Текст =
		РегистрыНакопления.ГрафикПоступленияТоваров.ТекстЗапросаОборотов(Ложь)
		+ РегистрыНакопления.ГрафикПоступленияТоваров.ТекстЗапросаОстатков(Ложь)
		+ "ВЫБРАТЬ
		|	Т.Номенклатура                                КАК Номенклатура,
		|	Т.Характеристика                              КАК Характеристика,
		|	Т.Склад                                       КАК Склад,
		|	ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)  КАК Назначение,
		|	ЕСТЬNULL(ОборотыГрафика.Период,
		|		ДАТАВРЕМЯ(1,1,1))                         КАК Период,
		|	ЕСТЬNULL(ОборотыГрафика.Количество,0)         КАК Оборот,
		|	ЕСТЬNULL(ОстаткиГрафика.Количество,0)         КАК Остаток
		|ИЗ
		|	ВтТовары КАК Т
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОстаткиГрафика КАК ОстаткиГрафика
		|		ПО Т.Номенклатура   = ОстаткиГрафика.Номенклатура
		|		 И Т.Характеристика = ОстаткиГрафика.Характеристика
		|		 И Т.Склад          = ОстаткиГрафика.Склад
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВтОборотыГрафика КАК ОборотыГрафика
		|		ПО Т.Номенклатура   = ОборотыГрафика.Номенклатура
		|		 И Т.Характеристика = ОборотыГрафика.Характеристика
		|		 И Т.Склад          = ОборотыГрафика.Склад
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика, Склад,
		|	Период УБЫВ
		|;
		|
		|/////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Т.Номенклатура                                КАК Номенклатура,
		|	Т.Характеристика                              КАК Характеристика,
		|	Т.Склад                                       КАК Склад,
		|	ДоступныеОстаткиДоИзменения.ДатаДоступности   КАК ДатаДоступности,
		|	ДоступныеОстаткиДоИзменения.Количество        КАК Количество
		|ИЗ
		|	ВтТовары КАК Т
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений КАК ДоступныеОстаткиДоИзменения
		|		ПО Т.Номенклатура   = ДоступныеОстаткиДоИзменения.Номенклатура
		|		 И Т.Характеристика = ДоступныеОстаткиДоИзменения.Характеристика
		|		 И Т.Склад          = ДоступныеОстаткиДоИзменения.Склад
		|УПОРЯДОЧИТЬ ПО
		|	Номенклатура, Характеристика, Склад,
		|	ДатаДоступности УБЫВ";
	
	Возврат Текст;
	
КонецФункции

Процедура ЗаписатьНаборВРегистрДоступныеОстатки(НаборЗаписей, ДанныеЗаполнения, Операция)

	НаборЗаписей.Отбор.Номенклатура.Значение    = ДанныеЗаполнения.Номенклатура;
	НаборЗаписей.Отбор.Характеристика.Значение  = ДанныеЗаполнения.Характеристика;
	НаборЗаписей.Отбор.Склад.Значение           = ДанныеЗаполнения.Склад;
	НаборЗаписей.Отбор.ДатаДоступности.Значение = ДанныеЗаполнения.ДатаДоступности;

	НаборЗаписей.Отбор.Номенклатура.Использование    = Истина;
	НаборЗаписей.Отбор.Характеристика.Использование  = Истина;
	НаборЗаписей.Отбор.Склад.Использование           = Истина;
	НаборЗаписей.Отбор.ДатаДоступности.Использование = Истина;

	НаборЗаписей.Очистить();

	Если Операция = "Запись" Тогда
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьНабора, ДанныеЗаполнения);
	КонецЕсли;

	НаборЗаписей.Записать();

КонецПроцедуры

Функция КлючИзменился(Ключ, НовыйКлюч)

	Возврат Ключ.Номенклатура   <> НовыйКлюч.Номенклатура
		Или Ключ.Характеристика <> НовыйКлюч.Характеристика
		Или Ключ.Склад          <> НовыйКлюч.Склад;

КонецФункции

#Область ОбновлениеИнформационнойБазы

// Отмечает к обновлению данные одного из регистров, принадлежащих цепочке, на основе которой формируется "ДоступныеОстаткиПланируемыхПоступлений"
// 		или сам независимый регистр сведений "ДоступныеОстаткиПланируемыхПоступлений".
//
// Параметры:
// 		ПолноеИмяРегистра - Строка - полное имя регистра, для которого необходимо обновить движения.
// 		Параметры - Структура - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке.
//
Процедура ЗарегистрироватьКОбработкеПриОбновленииИБ(ПолноеИмяРегистра, Параметры) Экспорт
	
	// ВАЖНО. Используется АдаптированныйТекстЗапросаДвиженийПоРегистру("ГрафикОтгрузкиТоваров")
	// Тексты запроса не должны содержать временных таблиц.
	// В тексте запроса обязательно должны присутствовать все поля регистра, перечисленные в произвольном порядке.
	
	// ВАЖНО. Используется АдаптированныйТекстЗапросаДвиженийПоРегистру("ДвижениеТоваров")
	// Тексты запроса не должны содержать временных таблиц.
	// В тексте запроса обязательно должны присутствовать все поля регистра, перечисленные в произвольном порядке.
	
	// Регистраторы с неверными движениями по РН График отгрузки товаров.
	РегистраторыГрафикОтгрузки = Новый Массив();
	
	// Регистраторы с неверными движениями по РН Движение товаров.
	Регистраторы = Новый Массив();
	
	//++ НЕ УТ
	Регистраторы.Добавить(Документы.ЗаказПереработчику);
	Регистраторы.Добавить(Документы.ПоступлениеОтПереработчика);
	//-- НЕ УТ
	Регистраторы.Добавить(Документы.ЗаказПоставщику);
	Регистраторы.Добавить(Документы.ВозвратТоваровОтКлиента);
	Регистраторы.Добавить(Документы.ПриходныйОрдерНаТовары);
	Регистраторы.Добавить(Документы.АктОРасхожденияхПослеПеремещения);
	
	// Правильные и ошибочные распоряжения в РН Движения товаров для регистраторов с неверными движениями по РН Движение товаров.
	Распоряжения = Новый Массив();
	//++ НЕ УТ
	Распоряжения.Добавить(Документы.ЗаказПереработчику);
	Распоряжения.Добавить(Документы.ПоступлениеОтПереработчика);
	//-- НЕ УТ
	Распоряжения.Добавить(Документы.РегистраторГрафикаДвиженияТоваров);
	Распоряжения.Добавить(Документы.ЗаказПоставщику);
	
	Распоряжения.Добавить(Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	Распоряжения.Добавить(Документы.ВозвратТоваровОтКлиента);
	
	Распоряжения.Добавить(Документы.ПеремещениеТоваров);
	Распоряжения.Добавить(Документы.ЗаказНаПеремещение);
	
	ПараметрыАдаптированныхЗапросов = Новый Структура;
	
	ТекстОбъединитьВсе = "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|";
	
	#Область ГрафикОтгрузкиТоваров
	
	Если ПолноеИмяРегистра = "РегистрНакопления.ГрафикОтгрузкиТоваров" Тогда
		
		ТекстыЗапроса = Новый Массив();
		
		// Фактические данные регистраторов в РН График отгрузки товаров.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Регистратор             КАК Ссылка,
			|	Таблица.Период                  КАК Период,
			|	Таблица.Номенклатура            КАК Номенклатура,
			|	Таблица.Характеристика          КАК Характеристика,
			|	Таблица.Склад                   КАК Склад,
			|	Таблица.Назначение              КАК Назначение,
			|	Таблица.ДатаОтгрузки            КАК ДатаОтгрузки,
			|	Таблица.Распоряжение            КАК Распоряжение,
			|	Таблица.КоличествоИзЗаказов     КАК КоличествоИзЗаказов,
			|	Таблица.КоличествоПодЗаказ      КАК КоличествоПодЗаказ,
			|	Таблица.КоличествоНеобеспечено  КАК КоличествоНеобеспечено
			|ИЗ
			|	Регистрнакопления.ГрафикОтгрузкиТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность
			|	И Таблица.Регистратор ССЫЛКА Документ.%1";
		
		Для Каждого ДокументМенеджер Из РегистраторыГрафикОтгрузки Цикл
			ТекстыЗапроса.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
		КонецЦикла;
		
		// Тексты запроса исправленных (правильных) движений по РН График отгрузки товаров, взятые с отрицательным знаком.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Регистратор             КАК Ссылка,
			|	Таблица.Период                  КАК Период,
			|	Таблица.Номенклатура            КАК Номенклатура,
			|	Таблица.Характеристика          КАК Характеристика,
			|	Таблица.Склад                   КАК Склад,
			|	Таблица.Назначение              КАК Назначение,
			|	Таблица.ДатаОтгрузки            КАК ДатаОтгрузки,
			|	&Распоряжение                   КАК Распоряжение,
			|	-Таблица.КоличествоИзЗаказов    КАК КоличествоИзЗаказов,
			|	-Таблица.КоличествоПодЗаказ     КАК КоличествоПодЗаказ,
			|	-Таблица.КоличествоНеобеспечено КАК КоличествоНеобеспечено
			|ИЗ
			|	&АдаптированныйТекст КАК Таблица";
		
		РегистраторыСРаспоряжением = Новый Соответствие;
		//++ НЕ УТ
		РегистраторыСРаспоряжением.Вставить(Документы.ЗаказПереработчику, Истина);
		//-- НЕ УТ
		
		Для Каждого ДокументМенеджер Из РегистраторыГрафикОтгрузки Цикл
			
			РезультатАдаптацииЗапроса = ДокументМенеджер.АдаптированныйТекстЗапросаДвиженийПоРегистру("ГрафикОтгрузкиТоваров");
			
			ДополнитьОбщиеПараметрыАдаптированныхЗапросов(ПараметрыАдаптированныхЗапросов, РезультатАдаптацииЗапроса);
			
			АдаптированныйТекст = СтрЗаменить("(АдаптированныйТекст)", "АдаптированныйТекст", РезультатАдаптацииЗапроса.ТекстЗапроса);
			АдаптированныйТекст = СтрЗаменить(ТекстЗапроса, "&АдаптированныйТекст", АдаптированныйТекст);
			Если РегистраторыСРаспоряжением.Получить(ДокументМенеджер) = Истина Тогда
				АдаптированныйТекст = СтрЗаменить(АдаптированныйТекст, "&Распоряжение", "Таблица.Распоряжение");
			КонецЕсли;
			ТекстыЗапроса.Добавить(АдаптированныйТекст);
			
		КонецЦикла;
		
		// Регистраторы имеющие различия фактических движений в РН График отгрузки товаров от правильных.
		ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ТекстОбъединитьВсе);
		
		Объединение = СтрЗаменить("(ТекстЗапроса)", "ТекстЗапроса", ТекстЗапроса);
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Таблица.Ссылка КАК Ссылка
			|ИЗ
			|	&Объединение КАК Таблица
			|СГРУППИРОВАТЬ ПО
			|	Таблица.Ссылка,
			|	Таблица.Период,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Склад,
			|	Таблица.Назначение,
			|	Таблица.ДатаОтгрузки,
			|	Таблица.Распоряжение
			|ИМЕЮЩИЕ
			|	СУММА(Таблица.КоличествоИзЗаказов) <> 0
			|		ИЛИ СУММА(Таблица.КоличествоПодЗаказ) <> 0
			|		ИЛИ СУММА(Таблица.КоличествоНеобеспечено) <> 0";
		
		Запрос = Новый Запрос();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Объединение", Объединение);
		Запрос.УстановитьПараметр("Распоряжение", "");
		Для Каждого КлючИЗначение Из ПараметрыАдаптированныхЗапросов Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ДанныеКРегистрации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, ДанныеКРегистрации, "РегистрНакопления.ГрафикОтгрузкиТоваров");
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ДвижениеТоваров
	
	Если ПолноеИмяРегистра = "РегистрНакопления.ДвижениеТоваров" Тогда
		
		ТекстыЗапроса = Новый Массив();
		
		// Фактические данные регистраторов в РН Движение товаров.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Регистратор             КАК Ссылка,
			|	Таблица.Период                  КАК Период,
			|	Таблица.Номенклатура            КАК Номенклатура,
			|	Таблица.Характеристика          КАК Характеристика,
			|	Таблица.Склад                   КАК Склад,
			|	Таблица.Назначение              КАК Назначение,
			|	Таблица.ДатаРаспоряжения        КАК ДатаРаспоряжения,
			|	Таблица.Корректировка           КАК Корректировка,
			|	Таблица.Распоряжение            КАК Распоряжение,
			|	Таблица.ПланируемоеПоступление                           КАК ПланируемоеПоступление,
			|	Таблица.ПланируемоеПоступлениеПодЗаказ                   КАК ПланируемоеПоступлениеПодЗаказ,
			|	Таблица.ПланируемоеПоступлениеСНеподтвержденными         КАК ПланируемоеПоступлениеСНеподтвержденными,
			|	Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными
			|ИЗ
			|	Регистрнакопления.ДвижениеТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность
			|	И Таблица.Регистратор ССЫЛКА Документ.%1";
		
		Для Каждого ДокументМенеджер Из Регистраторы Цикл
			ТекстыЗапроса.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
		КонецЦикла;
		
		// Тексты запроса исправленных (правильных) движений по РН Движение товаров, взятые с отрицательным знаком.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Регистратор             КАК Ссылка,
			|	Таблица.Период                  КАК Период,
			|	Таблица.Номенклатура            КАК Номенклатура,
			|	Таблица.Характеристика          КАК Характеристика,
			|	Таблица.Склад                   КАК Склад,
			|	Таблица.Назначение              КАК Назначение,
			|	Таблица.ДатаРаспоряжения        КАК ДатаРаспоряжения,
			|	Таблица.Корректировка           КАК Корректировка,
			|	Таблица.Распоряжение            КАК Распоряжение,
			|	-Таблица.ПланируемоеПоступление                           КАК ПланируемоеПоступление,
			|	-Таблица.ПланируемоеПоступлениеПодЗаказ                   КАК ПланируемоеПоступлениеПодЗаказ,
			|	-Таблица.ПланируемоеПоступлениеСНеподтвержденными         КАК ПланируемоеПоступлениеСНеподтвержденными,
			|	-Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными КАК ПланируемоеПоступлениеПодЗаказСНеподтвержденными
			|ИЗ
			|	&АдаптированныйТекст КАК Таблица";
		
		Для Каждого ДокументМенеджер Из Регистраторы Цикл
			
			РезультатАдаптацииЗапроса = ДокументМенеджер.АдаптированныйТекстЗапросаДвиженийПоРегистру("ДвижениеТоваров");
			
			ДополнитьОбщиеПараметрыАдаптированныхЗапросов(ПараметрыАдаптированныхЗапросов, РезультатАдаптацииЗапроса);
			
			АдаптированныйТекст = СтрЗаменить("(АдаптированныйТекст)", "АдаптированныйТекст", РезультатАдаптацииЗапроса.ТекстЗапроса);
			ТекстыЗапроса.Добавить(СтрЗаменить(ТекстЗапроса, "&АдаптированныйТекст", АдаптированныйТекст));
		
		КонецЦикла;
		
		// Регистраторы имеющие различия фактических движений в РС Движение товаров от правильных.
		ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ТекстОбъединитьВсе);
		
		Объединение = СтрЗаменить("(ТекстЗапроса)", "ТекстЗапроса", ТекстЗапроса);
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Таблица.Ссылка КАК Ссылка
			|ИЗ
			|	&Объединение КАК Таблица
			|СГРУППИРОВАТЬ ПО
			|	Таблица.Ссылка,
			|	Таблица.Период,
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Склад,
			|	Таблица.Назначение,
			|	Таблица.ДатаРаспоряжения,
			|	Таблица.Корректировка,
			|	Таблица.Распоряжение
			|ИМЕЮЩИЕ
			|	СУММА(Таблица.ПланируемоеПоступление) <> 0
			|		ИЛИ СУММА(Таблица.ПланируемоеПоступлениеПодЗаказ) <> 0
			|		ИЛИ СУММА(Таблица.ПланируемоеПоступлениеСНеподтвержденными) <> 0
			|		ИЛИ СУММА(Таблица.ПланируемоеПоступлениеПодЗаказСНеподтвержденными) <> 0";
		
		Запрос = Новый Запрос();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Объединение", Объединение);
		Для Каждого КлючИЗначение Из ПараметрыАдаптированныхЗапросов Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ДанныеКРегистрации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, ДанныеКРегистрации, "РегистрНакопления.ДвижениеТоваров");
	КонецЕсли;
	
	#КонецОбласти
	
	ОбщиеТекстыЗапросов = Новый Массив();
	
	#Область ОбщиеТекстыЗапросов
	
	// Фактические данные в РН Движение товаров по исправляемым распоряжениям.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Распоряжение            КАК Ссылка,
		|	Таблица.Номенклатура            КАК Номенклатура,
		|	Таблица.Характеристика          КАК Характеристика,
		|	Таблица.Склад                   КАК Склад,
		|	Таблица.Назначение              КАК Назначение,
		|	
		|	0                               КАК КоличествоИзЗаказов,
		|	0                               КАК КоличествоПодЗаказ,
		|	
		|	ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступление
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступление
		|		КОНЕЦ КАК КоличествоИзЗаказовРасчетный,
		|	
		|	ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступлениеПодЗаказ
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступлениеПодЗаказ
		|		КОНЕЦ КАК КоличествоПодЗаказРасчетный
		|ИЗ
		|	Регистрнакопления.ДвижениеТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Активность
		|	И Таблица.Распоряжение ССЫЛКА Документ.%1";
	
	Для Каждого ДокументМенеджер Из Распоряжения Цикл
		ОбщиеТекстыЗапросов.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
	КонецЦикла;
	
	// Сторно фактических данных исправляемых регистраторов в РН Движение товаров.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Распоряжение            КАК Ссылка,
		|	Таблица.Номенклатура            КАК Номенклатура,
		|	Таблица.Характеристика          КАК Характеристика,
		|	Таблица.Склад                   КАК Склад,
		|	Таблица.Назначение              КАК Назначение,
		|	
		|	0                               КАК КоличествоИзЗаказов,
		|	0                               КАК КоличествоПодЗаказ,
		|	
		|	-ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступление
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступление
		|		КОНЕЦ КАК КоличествоИзЗаказовРасчетный,
		|	
		|	-ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступлениеПодЗаказ
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступлениеПодЗаказ
		|		КОНЕЦ КАК КоличествоПодЗаказРасчетный
		|ИЗ
		|	Регистрнакопления.ДвижениеТоваров КАК Таблица
		|ГДЕ
		|	Таблица.Активность
		|	И Таблица.Регистратор ССЫЛКА Документ.%1";
	
	Для Каждого ДокументМенеджер Из Регистраторы Цикл
		ОбщиеТекстыЗапросов.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
	КонецЦикла;
	
	// Исправленнные движения в РН Движение товаров по данным документов.
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Распоряжение            КАК Ссылка,
		|	Таблица.Номенклатура            КАК Номенклатура,
		|	Таблица.Характеристика          КАК Характеристика,
		|	Таблица.Склад                   КАК Склад,
		|	Таблица.Назначение              КАК Назначение,
		|	
		|	0                               КАК КоличествоИзЗаказов,
		|	0                               КАК КоличествоПодЗаказ,
		|	
		|	ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступление
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступление
		|		КОНЕЦ КАК КоличествоИзЗаказовРасчетный,
		|	
		|	ВЫБОР КОГДА Таблица.Корректировка ТОГДА
		|				-Таблица.ПланируемоеПоступлениеПодЗаказ
		|			ИНАЧЕ
		|				Таблица.ПланируемоеПоступлениеПодЗаказ
		|		КОНЕЦ КАК КоличествоПодЗаказРасчетный
		|ИЗ
		|	&АдаптированныйТекст КАК Таблица";
	
	Для Каждого ДокументМенеджер Из Регистраторы Цикл
		
		РезультатАдаптацииЗапроса = ДокументМенеджер.АдаптированныйТекстЗапросаДвиженийПоРегистру("ДвижениеТоваров");
		
		ДополнитьОбщиеПараметрыАдаптированныхЗапросов(ПараметрыАдаптированныхЗапросов, РезультатАдаптацииЗапроса);
		
		АдаптированныйТекст = СтрЗаменить("(АдаптированныйТекст)", "АдаптированныйТекст", РезультатАдаптацииЗапроса.ТекстЗапроса);
		//++ НЕ УТ
		Если ДокументМенеджер = Документы.ЗаказПереработчику Тогда
			АдаптированныйТекст = СтрЗаменить(АдаптированныйТекст, "ТаблицаДокументаОбновлениеИБ.Получатель",
				"ВЫБОР КОГДА ТаблицаДокументаОбновлениеИБ.УдалитьСклад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
				|	ТОГДА ТаблицаДокументаОбновлениеИБ.Получатель
				|	ИНАЧЕ ТаблицаДокументаОбновлениеИБ.УдалитьСклад
				|КОНЕЦ");
		КонецЕсли;
		//-- НЕ УТ
		ОбщиеТекстыЗапросов.Добавить(СтрЗаменить(ТекстЗапроса, "&АдаптированныйТекст", АдаптированныйТекст));
		
	КонецЦикла;
	
	#КонецОбласти
	
	#Область ГрафикПоступленияТоваров
	
	Если ПолноеИмяРегистра = "РегистрНакопления.ГрафикПоступленияТоваров" Тогда
		
		ТекстЗапроса = Неопределено;
		ТекстыЗапроса = Новый Массив();
		
		// Фактические данные распоряжений в РН График поступления товаров.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Регистратор             КАК Ссылка,
			|	Таблица.Номенклатура            КАК Номенклатура,
			|	Таблица.Характеристика          КАК Характеристика,
			|	Таблица.Склад                   КАК Склад,
			|	Таблица.Назначение              КАК Назначение,
			|	Таблица.КоличествоИзЗаказов     КАК КоличествоИзЗаказов,
			|	Таблица.КоличествоПодЗаказ      КАК КоличествоПодЗаказ,
			|	0                               КАК КоличествоИзЗаказовРасчетный,
			|	0                               КАК КоличествоПодЗаказРасчетный
			|ИЗ
			|	Регистрнакопления.ГрафикПоступленияТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность
			|	И Таблица.Регистратор ССЫЛКА Документ.%1";
			
		Для Каждого ДокументМенеджер Из Распоряжения Цикл
			ТекстыЗапроса.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
		КонецЦикла;
		
		// Расчетные данные распоряжений в РН График поступления товаров.
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ТекстыЗапроса, ОбщиеТекстыЗапросов);
		
		// Распоряжения имеющие различия фактических движений в РС График поступления товаров от правильных.
		ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ТекстОбъединитьВсе);
		
		Объединение = СтрЗаменить("(ТекстЗапроса)", "ТекстЗапроса", ТекстЗапроса);
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Таблица.Ссылка КАК Ссылка
			|ИЗ(
			|	ВЫБРАТЬ
			|		Таблица.Ссылка         КАК Ссылка,
			|		Таблица.Номенклатура   КАК Номенклатура,
			|		Таблица.Характеристика КАК Характеристика,
			|		Таблица.Склад          КАК Склад,
			|		Таблица.Назначение     КАК Назначение,
			|		
			|		СУММА(Таблица.КоличествоИзЗаказов)          КАК КоличествоИзЗаказов,
			|		СУММА(Таблица.КоличествоПодЗаказ)           КАК КоличествоПодЗаказ,
			|		СУММА(Таблица.КоличествоИзЗаказовРасчетный) КАК КоличествоИзЗаказовРасчетный,
			|		СУММА(Таблица.КоличествоПодЗаказРасчетный)  КАК КоличествоПодЗаказРасчетный
			|	ИЗ
			|		&Объединение КАК Таблица
			|	
			|	СГРУППИРОВАТЬ ПО
			|		Таблица.Ссылка,
			|		Таблица.Номенклатура,
			|		Таблица.Характеристика,
			|		Таблица.Склад,
			|		Таблица.Назначение) КАК Таблица
			|ГДЕ
			|	Таблица.Ссылка <> НЕОПРЕДЕЛЕНО
			|	И ВЫБОР КОГДА Таблица.КоличествоИзЗаказовРасчетный > 0 ТОГДА
			|				Таблица.КоличествоИзЗаказовРасчетный
			|			ИНАЧЕ
			|				0
			|		КОНЕЦ <> Таблица.КоличествоИзЗаказов
			|		
			|		ИЛИ ВЫБОР КОГДА Таблица.КоличествоПодЗаказРасчетный > 0 ТОГДА
			|					Таблица.КоличествоПодЗаказРасчетный
			|				ИНАЧЕ
			|					0
			|			КОНЕЦ <> Таблица.КоличествоПодЗаказ";
			
		Запрос = Новый Запрос();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Объединение", Объединение);
		Для Каждого КлючИЗначение Из ПараметрыАдаптированныхЗапросов Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ДанныеКРегистрации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(Параметры, ДанныеКРегистрации, "РегистрНакопления.ГрафикПоступленияТоваров");
	КонецЕсли;
	
	#КонецОбласти
	
	#Область ДоступныеОстаткиПланируемыхПоступлений
	
	Если ПолноеИмяРегистра = "РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений" Тогда
		
		ТекстЗапроса = Неопределено;
		
		ТекстыЗапроса = Новый Массив();
		
		// Фактические данные в РС Доступные остатки планируемых поступлений.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	МАКСИМУМ(Таблица.Количество) КАК Количество
			|ИЗ
			|	РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений КАК Таблица
			|СГРУППИРОВАТЬ ПО
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Склад";
		
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
		// Фактические данные в РН График поступления товаров, взятые с отрицательным знаком.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	-Таблица.КоличествоИзЗаказов КАК Количество
			|ИЗ
			|	РегистрНакопления.ГрафикПоступленияТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность";
		
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
		// Фактические данные в РН График отгрузки товаров взятые с дважды отрицательным знаком, так как для получения
		// доступных остатков они вычитаются.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	Таблица.КоличествоИзЗаказов  КАК Количество
			|ИЗ
			|	Регистрнакопления.ГрафикОтгрузкиТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность";
		
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
		// Сторно фактических данных в РН График отгрузки товаров, по исправляемым движениям.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	-Таблица.КоличествоИзЗаказов КАК Количество
			|ИЗ
			|	Регистрнакопления.ГрафикОтгрузкиТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность
			|		И Таблица.Регистратор ССЫЛКА Документ.%1";
		
		Для Каждого ДокументМенеджер Из РегистраторыГрафикОтгрузки Цикл
			ТекстыЗапроса.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
		КонецЦикла;
		
		// Исправленные данные в РН График отгрузки товаров по данным документов, взятые с дважды отрицательным знаком, так
		// как для получения доступных остатков они вычитаются.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	Таблица.КоличествоИзЗаказов  КАК Количество
			|ИЗ
			|	&АдаптированныйТекст КАК Таблица";
			
		Для Каждого ДокументМенеджер Из РегистраторыГрафикОтгрузки Цикл
			
			РезультатАдаптацииЗапроса = ДокументМенеджер.АдаптированныйТекстЗапросаДвиженийПоРегистру("ГрафикОтгрузкиТоваров");
			
			ДополнитьОбщиеПараметрыАдаптированныхЗапросов(ПараметрыАдаптированныхЗапросов, РезультатАдаптацииЗапроса);
			
			АдаптированныйТекст = СтрЗаменить("(АдаптированныйТекст)", "АдаптированныйТекст", РезультатАдаптацииЗапроса.ТекстЗапроса);
			ТекстыЗапроса.Добавить(СтрЗаменить(ТекстЗапроса, "&АдаптированныйТекст", АдаптированныйТекст));
			
		КонецЦикла;
		
		// Сторно фактических данных в РН График поступления товаров, по исправляемым распоряжениям.
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура         КАК Номенклатура,
			|	Таблица.Характеристика       КАК Характеристика,
			|	Таблица.Склад                КАК Склад,
			|	Таблица.КоличествоИзЗаказов  КАК Количество
			|ИЗ
			|	РегистрНакопления.ГрафикПоступленияТоваров КАК Таблица
			|ГДЕ
			|	Таблица.Активность
			|		И Таблица.Регистратор ССЫЛКА Документ.%1";
			
		Для Каждого ДокументМенеджер Из Распоряжения Цикл
			ТекстыЗапроса.Добавить(СтрШаблон(ТекстЗапроса, ДокументМенеджер.ПустаяСсылка().Метаданные().Имя));
		КонецЦикла;
		
		//////////////////////////////////////////////////////////////////////////////////////
		// Исправленные данные в РН График поступления товаров, по исправляемым распоряжениям.
		
		ТекстЗапроса = СтрСоединить(ОбщиеТекстыЗапросов, ТекстОбъединитьВсе);
		Объединение = СтрЗаменить("(ТекстЗапроса)", "ТекстЗапроса", ТекстЗапроса);
		
		ТекстЗапроса =
			"ВЫБРАТЬ
			|	Таблица.Номенклатура   КАК Номенклатура,
			|	Таблица.Характеристика КАК Характеристика,
			|	Таблица.Склад          КАК Склад,
			|	-Таблица.Количество    КАК Количество
			|ИЗ(
			|	ВЫБРАТЬ
			|		Таблица.Ссылка         КАК Ссылка,
			|		Таблица.Номенклатура   КАК Номенклатура,
			|		Таблица.Характеристика КАК Характеристика,
			|		Таблица.Склад          КАК Склад,
			|		СУММА(Таблица.КоличествоИзЗаказовРасчетный) КАК Количество
			|	ИЗ
			|		&Объединение КАК Таблица
			|	СГРУППИРОВАТЬ ПО
			|		Таблица.Ссылка,
			|		Таблица.Номенклатура,
			|		Таблица.Характеристика,
			|		Таблица.Склад
			|	ИМЕЮЩИЕ
			|		СУММА(Таблица.КоличествоИзЗаказовРасчетный) > 0) КАК Таблица";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Объединение", Объединение);
		ТекстыЗапроса.Добавить(ТекстЗапроса);
		
		// Товары имеющие различия фактических движений в РС Доступные остатки планируемых поступлений от правильных.
		ТекстЗапроса = СтрСоединить(ТекстыЗапроса, ТекстОбъединитьВсе);
		
		Объединение = СтрЗаменить("(ТекстЗапроса)", "ТекстЗапроса", ТекстЗапроса);
		
		ТекстЗапроса =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Таблица.Номенклатура   КАК Номенклатура,
			|	Таблица.Характеристика КАК Характеристика,
			|	Таблица.Склад          КАК Склад
			|ИЗ
			|	&Объединение КАК Таблица
			|СГРУППИРОВАТЬ ПО
			|	Таблица.Номенклатура,
			|	Таблица.Характеристика,
			|	Таблица.Склад
			|ИМЕЮЩИЕ
			|	СУММА(Таблица.Количество) <> 0";
		
		Запрос = Новый Запрос();
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "&Объединение", Объединение);
		Для Каждого КлючИЗначение Из ПараметрыАдаптированныхЗапросов Цикл
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ДанныеКРегистрации = Запрос.Выполнить().Выгрузить();
		
		ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
		ДополнительныеПараметры.Вставить("ЭтоНезависимыйРегистрСведений", Истина);
		ДополнительныеПараметры.Вставить("ПолноеИмяРегистра", "РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений");
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ДанныеКРегистрации, ДополнительныеПараметры);
		
	КонецЕсли;
	
	#КонецОбласти
	
КонецПроцедуры

Процедура ДополнитьОбщиеПараметрыАдаптированныхЗапросов(ПараметрыАдаптированныхЗапросов, РезультатАдаптацииЗапроса)
	
	НайденноеЗначение = Неопределено;
	
	Для Каждого КлючИЗначение Из РезультатАдаптацииЗапроса.ЗначенияПараметров Цикл
		
		Если ПараметрыАдаптированныхЗапросов.Свойство(КлючИЗначение.Ключ, НайденноеЗначение) Тогда
			Если НайденноеЗначение <> КлючИЗначение.Значение Тогда
				НовыйКлюч = КлючИЗначение.Ключ + Формат(ПараметрыАдаптированныхЗапросов.Количество()+1, "ЧГ=0");
				РезультатАдаптацииЗапроса.ТекстЗапроса = СтрЗаменить(РезультатАдаптацииЗапроса.ТекстЗапроса, "&"+КлючИЗначение.Ключ, "&"+НовыйКлюч);
				ПараметрыАдаптированныхЗапросов.Вставить(НовыйКлюч, КлючИЗначение.Значение);
			КонецЕсли;
		Иначе
			ПараметрыАдаптированныхЗапросов.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
