#Область ПрограммныйИнтерфейс

// Возвращает Истина, если акцизная марка никогда раньше не продавалась. Ложь - в противном случае.
//
// Параметры:
//  Операция - Строка - текущая операция, для которой требуется осуществить контроль. Возможные значения:
//   "Продажа" - проверка пройдена, если продажи за минусом возвратов <= 0,
//   "Возврат" - проверка пройдена, если продажи за минусом возвратов >= 0,
//   "АктПостановкиНаБаланс" - проверка пройдена, если не было продаж, возвратов, актов постановок на баланс,
//   "АктСписания" - проверка пройдена, если продажи за минусом возвратов <= 0 и поставлено на баланс - списано >= 0.
//  КодАкцизнойМарки - Строка - код акцизной марки,
//  ТекстОшибки - Строка, ФорматированнаяСтрока - текст сообщения пользователю, если акцизная марка не уникальна. Выходной параметр.
Процедура ПроверитьУникальностьАкцизнойМарки(Операция, КодАкцизнойМарки, ТекстОшибки) Экспорт
	
	//++ НЕ ГОСИС
	Если Не ЗначениеЗаполнено(Операция) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Операция = "Продажа" ИЛИ Операция = "Возврат" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиПродажаВозврат(КодАкцизнойМарки, Операция);
	ИначеЕсли Операция = "АктПостановкиНаБаланс" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиАктПостановкиНаБаланс(КодАкцизнойМарки);
	ИначеЕсли Операция = "АктСписания" Тогда
		Запрос = АкцизныеМаркиЕГАИСУТ.ЗапросПроверкиУникальностиАктСписания(КодАкцизнойМарки);
	КонецЕсли;
	
	ВыборкаОбщийИтог = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ВыборкаОбщийИтог.Следующий();
	
	ТекстОшибки = "";
	Если ТипЗнч(ВыборкаОбщийИтог.Количество) = Тип("Число") И ВыборкаОбщийИтог.Количество > 0 Тогда
		
		Выборка = ВыборкаОбщийИтог.Выбрать();
		Выборка.Следующий();
		
		МассивСтрок = Новый Массив;
		МассивСтрок.Добавить(НСтр("ru='Считанная акцизная марка была реализована ранее в документе:'"));
		МассивСтрок.Добавить(Символы.ПС);
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(
			ОбщегоНазначенияУТ.ПолучитьПредставлениеДокумента(Выборка.Ссылка, Выборка.Номер, Выборка.Дата),,,,
			ПолучитьНавигационнуюСсылку(Выборка.Ссылка)));
		
		ТекстОшибки = Новый ФорматированнаяСтрока(МассивСтрок);
		
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

Процедура СлужебныеДанныеАлкогольнойПродукции(Товары, Результат) Экспорт
	
	//++ НЕ ГОСИС
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.НомерСтроки,
	|	Т.ИдентификаторСтроки,
	|	Т.Номенклатура,
	|	Т.АлкогольнаяПродукция,
	|	Т.Справка2,
	|	Т.Количество
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки          КАК НомерСтроки,
	|	Товары.ИдентификаторСтроки  КАК ИдентификаторСтроки,
	|	Товары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	Товары.Справка2             КАК Справка2,
	|	Товары.Количество           КАК Количество,
	|	0                           КАК КоличествоАкцизныхМарок,
	|	ВЫБОР
	|		КОГДА Товары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	|			И Товары.АлкогольнаяПродукция = ЗНАЧЕНИЕ(Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.ПустаяСсылка)
	|			ТОГДА ВЫБОР
	|				КОГДА Товары.Номенклатура.АлкогольнаяПродукцияВоВскрытойТаре
	|					ТОГДА ЛОЖЬ
	|				ИНАЧЕ
	|					ЕСТЬNULL(Товары.Номенклатура.ВидАлкогольнойПродукции.Маркируемый, ЛОЖЬ)
	|			КОНЕЦ
	|		ИНАЧЕ
	|			ЕСТЬNULL(Товары.АлкогольнаяПродукция.ВидПродукции.Маркируемый, ЛОЖЬ)
	|	КОНЕЦ КАК МаркируемаяПродукция,
	|	ЕСТЬNULL(Товары.АлкогольнаяПродукция.ТипПродукции, ЗНАЧЕНИЕ(Перечисление.ТипыПродукцииЕГАИС.Неупакованная))КАК ТипПродукции
	|ИЗ
	|	Товары КАК Товары
	|");
	
	Запрос.Параметры.Вставить("Товары", Товары);
	
	Результат = Запрос.Выполнить().Выгрузить();
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Определяет, является ли номенклатура алкогольной маркируемой продукцией.
//
// Параметры:
//  Маркируемая  - Булево - признак маркируемой продукции (Истина если является)
//  Номенклатура - ОпределяемыйТип.Номенклатура - номенклатура.
Процедура ЗаполнитьПризнакМаркируемойПродукции(Маркируемая, Номенклатура) Экспорт
	
	//++ НЕ ГОСИС
	Маркируемая = Ложь;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ВидыАлкогольнойПродукции.Маркируемый, ЛОЖЬ) КАК Маркируемый
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыАлкогольнойПродукции КАК ВидыАлкогольнойПродукции
	|		ПО Номенклатура.ВидАлкогольнойПродукции = ВидыАлкогольнойПродукции.Ссылка
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|");
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Маркируемая = Выборка.Маркируемый;
	КонецЕсли;
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#КонецОбласти