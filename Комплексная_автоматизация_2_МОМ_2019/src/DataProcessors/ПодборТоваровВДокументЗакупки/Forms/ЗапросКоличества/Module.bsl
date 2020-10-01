
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Цена              = Параметры.Цена;
	Дата              = Параметры.Дата;
	Упаковка          = Параметры.Упаковка;
	Склад             = Параметры.Склад;
	Валюта            = Параметры.Валюта;
	Соглашение        = Параметры.Соглашение;
	ЦенаВключаетНДС   = Параметры.ЦенаВключаетНДС;
	Партнер           = Параметры.Партнер;
	Номенклатура      = Параметры.Номенклатура;
	Характеристика    = Параметры.Характеристика;
	ВидЦеныПоставщика = Параметры.ВидЦеныПоставщика;
	
	ОбщегоНазначенияУТКлиентСервер.ДобавитьПараметрВыбора(Элементы.Склад, "Ссылка", Параметры.Склады);
	Элементы.Склад.Видимость = (Параметры.Склады.Количество() > 1) И Параметры.ИспользоватьСкладыВТабличнойЧасти;
	
	СтруктураНоменклатуры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "ЕдиницаИзмерения, ИспользоватьУпаковки");
	
	Если Упаковка.Пустая()
		И СтруктураНоменклатуры.ИспользоватьУпаковки Тогда 
		Упаковка = ПодборТоваровВызовСервера.ПолучитьУпаковкуХранения(Номенклатура);
	КонецЕсли;

	СтараяУпаковка = Упаковка;
	КоличествоУпаковок = 1;
	
	Элементы.Цена.ТолькоПросмотр = НЕ Параметры.РедактироватьЦену;
	
	НаименованиеТовара = "" + Параметры.Номенклатура + ?(ЗначениеЗаполнено(Параметры.Характеристика), " (" + Параметры.Характеристика + ")","");
	
	Если Параметры.СкрытьЦену Тогда
		Элементы.Цена.Видимость              = Ложь;
		Элементы.Валюта.Видимость            = Ложь;
		ЭтаФорма.АвтоЗаголовок               = Ложь;
		ЭтаФорма.Заголовок                   = НСтр("ru = 'Ввод количества'");
		Элементы.ВидЦеныПоставщика.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Упаковка.Видимость              = ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
	Элементы.ЕдиницаИзмерения.Видимость      = Не ЗначениеЗаполнено(Номенклатура.НаборУпаковок);
	Элементы.Упаковка.ПодсказкаВвода         = СтруктураНоменклатуры.ЕдиницаИзмерения;
	
	Если СтруктураНоменклатуры.ИспользоватьУпаковки Тогда
		Элементы.Упаковка.ПодсказкаВвода = СтруктураНоменклатуры.ЕдиницаИзмерения;
	КонецЕсли;

	Если Параметры.ЭтоУслуга Тогда
		Склад                    = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		Элементы.Склад.Видимость = Ложь;
	КонецЕсли;
	
	КоличествоУпаковок = 1;
	Элементы.КоличествоУпаковок.Доступность = Истина;
	
	Упаковка = СтараяУпаковка;
	
	// Настроить видимость и установить значения реквизитов для редактирования ручных скидок, наценок.
	СуммаДокумента = КоличествоУпаковок * Цена;
	
	Если Не Параметры.ИспользоватьРучныеСкидкиВЗакупках Или Параметры.СкрыватьРучныеСкидки Тогда
		
		Элементы.ГруппаПараметрыСкидкиНаценки.Видимость = Ложь;
		
	Иначе
		
		// Установить свойства элементов относящихся к скидкам (наценкам).
		ИспользоватьОграниченияРучныхСкидок = Истина;
		
		Если ИспользоватьОграниченияРучныхСкидок Тогда
			
			СтруктураТаблиц = ПолучитьИзВременногоХранилища(Параметры.АдресВоВременномХранилище);
				
			МаксимальныйПроцентСкидки  = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойСкидки;
			МаксимальныйПроцентНаценки = СтруктураТаблиц.Ограничения[0].МаксимальныйПроцентРучнойНаценки;
			
			Если МаксимальныйПроцентСкидки > 0 Тогда
				Элементы.ПроцентСкидки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентСкидки.СписокВыбора.Добавить(МаксимальныйПроцентСкидки, Формат(МаксимальныйПроцентСкидки, "ЧДЦ=2"));
			КонецЕсли;
			
			Если МаксимальныйПроцентНаценки > 0 Тогда
				Элементы.ПроцентНаценки.КнопкаСпискаВыбора = Истина;
				Элементы.ПроцентНаценки.СписокВыбора.Добавить(МаксимальныйПроцентНаценки, Формат(МаксимальныйПроцентНаценки, "ЧДЦ=2"));
			КонецЕсли;
			
		КонецЕсли;
		
		Элементы.НадписьМаксимальнаяРучнаяСкидка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Макс. скидка: %1%2'"),
			МаксимальныйПроцентСкидки,
			"%");
		
		Элементы.НадписьМаксимальнаяРучнаяНаценка.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Макс. наценка: %1%2'"),
			МаксимальныйПроцентНаценки,
			"%");
		
		// Установить варианты выбора ручной скидки (наценки).
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(1, НСтр("ru = 'Скидка'"));
		Элементы.ВариантПредоставления.СписокВыбора.Добавить(2, НСтр("ru = 'Наценка'"));
		
		// Установить значение варианта предоставления при открытии.
		ВариантПредоставления = 1; // Скидка
		
		УстановитьВидимостьСкидокНаценок();
		
	КонецЕсли;
	
	ВидЦеныПоставщикаПриИзмененииНаСервере();
	
	УстановитьВидимостьКоличествоЕдиницХранения();

	ОбновитьКоличетсво();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПоставщикаПриИзменении(Элемент)
	
	ВидЦеныПоставщикаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОчистка(Элемент, СтандартнаяОбработка)
	
	УпаковкаПриИзмененииНаСервере(СтараяУпаковка);
	СтараяУпаковка = Упаковка;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПредоставленияПриИзменении(Элемент)
	
	УстановитьВидимостьСкидокНаценок();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоУпаковокПриИзменении(Элемент)
	
	ОбновитьКоличетсво();
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	ОбновитьКоличетсвоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Отказ = Ложь;
	ОчиститьСообщения();
	
	Если КоличествоУпаковок = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнено количество'"),,"КоличествоУпаковок",,Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктур = Новый Массив;
	
	НоваяСтрока = Новый Структура;
	НоваяСтрока.Вставить("Номенклатура",          Номенклатура);
	НоваяСтрока.Вставить("Характеристика",        Характеристика);
	НоваяСтрока.Вставить("ВидЦеныПоставщика",     ВидЦеныПоставщика);
	НоваяСтрока.Вставить("Цена",                  Цена);
	
	НоваяСтрока.Вставить("Упаковка",              Упаковка);
	НоваяСтрока.Вставить("КоличествоУпаковок",    КоличествоУпаковок);
	НоваяСтрока.Вставить("Склад",                 Склад);
	
	Если ВариантПредоставления = 1 Тогда
		НоваяСтрока.Вставить("ПроцентРучнойСкидки", ПроцентРучнойСкидкиНаценки);
	Иначе
		НоваяСтрока.Вставить("ПроцентРучнойСкидки", -ПроцентРучнойСкидкиНаценки);
	КонецЕсли;
	
	МассивСтруктур.Добавить(НоваяСтрока);
	
	Закрыть(МассивСтруктур);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Округлить(Команда)
	
	Количество = Окр(Количество, 0, РежимОкругления.Окр15как20);
	ОбновитьКоличетсвоУпаковок();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентСкидки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентСкидки");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПроцентНаценки.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьОграниченияРучныхСкидок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПроцентРучнойСкидкиНаценки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйПроцентНаценки");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НоменклатураЕдиницаИзмерения.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Количество.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УказаноДробноеКоличествоВБазовыхЕдиницах");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

КонецПроцедуры

&НаСервере
Процедура УпаковкаПриИзмененииНаСервере(СтараяУпаковка)
	
	УстановитьВидимостьКоличествоЕдиницХранения();
	ОбновитьКоличетсво();
	
	Цена = Цена * 
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура) /
		Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(СтараяУпаковка, Номенклатура);
	
КонецПроцедуры

&НаСервере
Процедура ВидЦеныПоставщикаПриИзмененииНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(
	|		ЦеныНоменклатурыСрезПоследних.Цена * КурсыСрезПоследних.Курс / КурсыСрезПоследних.Кратность / КурсыСрезПоследнихВалютаЦены.Курс * КурсыСрезПоследнихВалютаЦены.Кратность
	|		* ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки1, 1) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) КАК ЧИСЛО(31,2)) КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(
	|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|			Номенклатура = &Номенклатура
	|				И Характеристика = &Характеристика
	|				И ВидЦеныПоставщика = &ВидЦеныПоставщика) КАК ЦеныНоменклатурыСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, ) КАК КурсыСрезПоследних
	|		ПО (КурсыСрезПоследних.Валюта = ЦеныНоменклатурыСрезПоследних.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыСрезПоследнихВалютаЦены
	|		ПО (ИСТИНА)");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения)", "ЦеныНоменклатурыСрезПоследних.Номенклатура"));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыСрезПоследних.Упаковка",
			"ЦеныНоменклатурыСрезПоследних.Номенклатура"));
	
	Запрос.УстановитьПараметр("ВидЦеныПоставщика", ВидЦеныПоставщика);
	Запрос.УстановитьПараметр("Дата",              Дата);
	Запрос.УстановитьПараметр("Номенклатура",      Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",    Характеристика);
	Запрос.УстановитьПараметр("Упаковка",          Упаковка);
	Запрос.УстановитьПараметр("Валюта",            Валюта);
	
	Цена = 0;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Если ЗначениеЗаполнено(Выборка.Цена) Тогда
			Цена = Выборка.Цена;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличетсво()
	
	Количество = КоличествоУпаковок*Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоличетсвоУпаковок()
	
	КоличествоУпаковок = Количество/Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Упаковка, Номенклатура);
	УстановитьВидимостьОкруглить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКоличествоЕдиницХранения()
	
	ЕдиницаИзмеренияТипИзмеряемойВеличины = "";
	УпаковкаТипИзмеряемойВеличины = "";
	ЕдиницаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения"),
																			ЕдиницаИзмеренияТипИзмеряемойВеличины);
																			
	УпаковкаМерная = Справочники.УпаковкиЕдиницыИзмерения.ЭтоМернаяЕдиница(Упаковка,
																			УпаковкаТипИзмеряемойВеличины);
	Если ЕдиницаМерная
		И УпаковкаТипИзмеряемойВеличины <> ЕдиницаИзмеренияТипИзмеряемойВеличины
		И УпаковкаТипИзмеряемойВеличины <> "Упаковка"
		И УпаковкаТипИзмеряемойВеличины <> ""
		Или ЕдиницаИзмеренияТипИзмеряемойВеличины = "КоличествоШтук" 
		И УпаковкаМерная Тогда 
		
		Элементы.Количество.Видимость = Истина;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Истина;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Ложь;
		
	Иначе
		
		Элементы.Количество.Видимость = Ложь;
		Элементы.НоменклатураЕдиницаИзмерения.Видимость = Ложь;
		Элементы.ДекорацияКоличествоОкруглить.Видимость = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьОкруглить()
	
	Если Количество <> Цел(Количество) И Элементы.Количество.Видимость И Не ЕдиницаМерная Тогда
		УказаноДробноеКоличествоВБазовыхЕдиницах = Истина;
		Элементы.Округлить.Видимость = Истина;
	Иначе
		УказаноДробноеКоличествоВБазовыхЕдиницах = Ложь;
		Элементы.Округлить.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСкидокНаценок()
	
	Элементы.ПроцентСкидки.Видимость  = ВариантПредоставления = 1;
	Элементы.ПроцентНаценки.Видимость = ВариантПредоставления = 2;
	
	Элементы.НадписьМаксимальнаяРучнаяСкидка.Видимость = ИспользоватьОграниченияРучныхСкидок
																И ВариантПредоставления = 1;
	Элементы.НадписьМаксимальнаяСкидкаНеОграничена.Видимость = Не ИспользоватьОграниченияРучныхСкидок
																И ВариантПредоставления = 1;
	Элементы.НадписьМаксимальнаяРучнаяНаценка.Видимость = ИспользоватьОграниченияРучныхСкидок
																И ВариантПредоставления = 2;
	Элементы.НадписьМаксимальнаяНаценкаНеОграничена.Видимость = Не ИспользоватьОграниченияРучныхСкидок
																И ВариантПредоставления = 2;
	
КонецПроцедуры

#КонецОбласти
