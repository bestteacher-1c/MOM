
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтруктураБыстрогоОтбора") Тогда
		Параметры.СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
	КонецЕсли;
	
	КонтролироватьОстаткиТоваровОрганизаций = ПолучитьФункциональнуюОпцию("КонтролироватьОстаткиТоваровОрганизацийКОформлениюПоПоступлениям");
	ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс");
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Ложь;
	
	Если КонтролироватьОстаткиТоваровОрганизаций Тогда
		СвойстваСписка.ТекстЗапроса = ТекстЗапросаТаможеннаяДекларацияИмпортКОформлению();
	Иначе
		СвойстваСписка.ТекстЗапроса = ТекстЗапросаКОформлению();
	КонецЕсли;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.КОформлению, СвойстваСписка);
	
	Элементы.КОформлениюДокументПоступления.Видимость = КонтролироватьОстаткиТоваровОрганизаций;
	Элементы.КОформлениюОрганизация.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	УстановитьОтборПоДате(Период, ЭтаФорма);
	УстановитьОтборПоОрганизации();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ТаможеннаяДекларацияИмпорт" Тогда
		Элементы.КОформлению.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодВариантПриИзменении(Элемент)
	
	УстановитьОтборПоДате(Период, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодДатаОкончанияПриИзменении(Элемент)
	
	УстановитьОтборПоДате(Период, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	Если ОрганизацияСохраненноеЗначение <> Организация Тогда
		
		УстановитьОтборПоОрганизации();
		ОрганизацияСохраненноеЗначение = Организация;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналЗакупкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ДокументыЗакупки" Тогда
		ОбщегоНазначенияУТКлиент.ОткрытьЖурнал(ПараметрыЖурнала());
	Иначе
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("КлючВарианта", "ИмпортныеТоварыКОформлению");
		ПараметрыОткрытия.Вставить("КлючНазначенияИспользования", );
		ПараметрыОткрытия.Вставить("Отбор", );
		ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
		ПараметрыОткрытия.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
		
		ОткрытьФорму("Отчет.ИмпортныеТоварыКОформлению.Форма", ПараметрыОткрытия);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКОформлению

&НаКлиенте
Процедура КОформлениюВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "КОформлениюДокументПоступления" Тогда
		
		ПоказатьЗначение(Неопределено, Элементы.КОформлению.ТекущиеДанные.ДокументПоступления);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьТаможеннуюДекларацию(Команда)
	Строка = Элементы.КОформлению.ТекущиеДанные;
	
	Если Не ОбщегоНазначенияУТКЛиент.ВыбраныДокументыКОформлению(Строка,ПараметрыЖурнала()) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Текст = 
	"ВЫБРАТЬ
	|	Товары.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|	Товары.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|	Товары.АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
	|	Товары.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|	Товары.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|	Товары.ВидЗапасов КАК ВидЗапасов,
	|	НЕОПРЕДЕЛЕНО КАК Упаковка,
	|	Товары.КоличествоОстаток КАК Количество,
	|	Товары.КоличествоОстаток КАК КоличествоУпаковок,
	|	Товары.ДокументПоступления КАК ДокументПоступления,
	|	Товары.ДокументПоступления.ЗакупкаПодДеятельность КАК ЗакупкаПодДеятельность,
	|	Товары.ДокументПоступления.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	0 КАК Цена,
	|	Товары.СуммаОстаток КАК Сумма,
	|	0 КАК СуммаСНДС
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(
	|			&ДатаОстатков,
	|			Организация = &Организация
	|				И Поставщик = &Поставщик
	|				//%ДокументПоступления%) КАК Товары
	|ГДЕ
	|	Товары.КоличествоОстаток > 0";
	
	ДатаОстатков = ?(ЗначениеЗаполнено(Период.ДатаОкончания), Период.ДатаОкончания, '39991231');
	
	Основание = Новый Структура;
	Основание.Вставить("Организация", Строка.Организация);
	Основание.Вставить("Поставщик", Строка.Поставщик);
	Основание.Вставить("КонтрагентПоставщика", Строка.КонтрагентПоставщика);
	Основание.Вставить("ДатаОстатков", ДатаОстатков);
	Если КонтролироватьОстаткиТоваровОрганизаций Тогда
		Текст = СтрЗаменить(Текст, "//%ДокументПоступления%", "И ДокументПоступления В (&ДокументПоступления)");
		Основание.Вставить("ДокументПоступления", Строка.ДокументПоступления);
	Иначе
		Текст = СтрЗаменить(Текст, "//%ДокументПоступления%", "");
	КонецЕсли;
	Основание.Вставить("ЗапросТовары", Текст);
	
	ПараметрыОткрытия = Новый Структура("Основание", Основание);
	ОткрытьФорму("Документ.ТаможеннаяДекларацияИмпорт.ФормаОбъекта", ПараметрыОткрытия);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоДате(Период, Форма)
	ДатаОкончания =
		?(ЗначениеЗаполнено(Период.ДатаОкончания), КонецДня(Период.ДатаОкончания) + 1, '39991231235959');
	Форма.КОформлению.Параметры.УстановитьЗначениеПараметра("ДатаОкончания", ДатаОкончания);
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ТекстЗапросаКОформлению()
	
	Возврат "ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НЕОПРЕДЕЛЕНО КАК ДокументПоступления,
		|	НаДату.Поставщик,
		|	НаДату.Организация,
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК КонтрагентПоставщика
		|ИЗ
		|	РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(&ДатаОкончания, ) КАК НаДату
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(, ) КАК НаСейчас
		|		ПО НаДату.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
		|			И НаДату.Поставщик = НаСейчас.Поставщик
		|			И НаДату.Организация = НаСейчас.Организация
		|			И НаДату.ВидЗапасов = НаСейчас.ВидЗапасов
		|ГДЕ
		|	НаСейчас.КоличествоОстаток > 0"
	
КонецФункции

&НаСервере
Функция ТекстЗапросаТаможеннаяДекларацияИмпортКОформлению()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	НаДату.ДокументПоступления,
	|	НаДату.Поставщик,
	|	НаДату.Организация,
	|	ЕСТЬNULL(ПриобретениеТоваровУслуг.Контрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК КонтрагентПоставщика
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(&ДатаОкончания, ) КАК НаДату
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ТоварыКОформлениюТаможенныхДеклараций.Остатки(, ) КАК НаСейчас
	|		ПО НаДату.АналитикаУчетаНоменклатуры = НаСейчас.АналитикаУчетаНоменклатуры
	|			И НаДату.Поставщик = НаСейчас.Поставщик
	|			И НаДату.Организация = НаСейчас.Организация
	|			И НаДату.ВидЗапасов = НаСейчас.ВидЗапасов
	|			И НаДату.ДокументПоступления = НаСейчас.ДокументПоступления
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	|		ПО НаДату.ДокументПоступления = ПриобретениеТоваровУслуг.Ссылка
	|ГДЕ
	|	НаСейчас.КоличествоОстаток > 0
	|";
	
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	
	СписокОрганизаций = Новый СписокЗначений;
	СписокОрганизаций.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация)
		И ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс Тогда
		
		Запрос = Новый Запрос("
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.ОбособленноеПодразделение
		|	И Организации.ГоловнаяОрганизация = &Организация
		|	И Организации.ДопускаютсяВзаиморасчетыЧерезГоловнуюОрганизацию");
		Запрос.УстановитьПараметр("Организация", Организация);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СписокОрганизаций.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		КОформлению,
		"Организация",
		СписокОрганизаций,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЖурнала()
	
	СтруктураБыстрогоОтбора = Новый Структура;
	СтруктураБыстрогоОтбора.Вставить("Организация",Организация);
	ПараметрыЖурнала = Новый Структура;
	ПараметрыЖурнала.Вставить("СтруктураБыстрогоОтбора",СтруктураБыстрогоОтбора);
	ПараметрыЖурнала.Вставить("КлючНазначенияФормы", "ТаможенныеДекларацииИмпорт");
	ПараметрыЖурнала.Вставить("ИмяРабочегоМеста","ЖурналДокументовЗакупки");
	ПараметрыЖурнала.Вставить("СинонимЖурнала",НСтр("ru = 'Документы закупки'"));
	
	Возврат ПараметрыЖурнала;
	
КонецФункции

#КонецОбласти
