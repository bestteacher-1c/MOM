#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);

	Возврат Результат;
	
КонецФункции

// Формирует текст, выводимый в заголовке отчета.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//
// Возвращаемое значение:
//   Строка - текст заголовка с учетом периода.
//
Функция ПолучитьТекстЗаголовка(ПараметрыОтчета) Экспорт 
	
	ТекстСубконто = "";
	Для Каждого ВидСубконто Из ПараметрыОтчета.СписокВидовСубконто Цикл
		ТекстСубконто = ТекстСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстСубконто) Тогда
		ТекстСубконто = Лев(ТекстСубконто, СтрДлина(ТекстСубконто) - 2);
	КонецЕсли;
	
	ТекстКорСубконто = "";
	Для Каждого ВидСубконто Из ПараметрыОтчета.СписокВидовКорСубконто Цикл
		ТекстКорСубконто = ТекстКорСубконто + ВидСубконто + ", ";	
	КонецЦикла;
	Если Не ПустаяСтрока(ТекстКорСубконто) Тогда
		ТекстКорСубконто = Лев(ТекстКорСубконто, СтрДлина(ТекстКорСубконто) - 2);
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстСубконто) Тогда
		ОбщийТекстСубконто = "...";
	Иначе
		ОбщийТекстСубконто = ТекстСубконто;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстКорСубконто) Тогда
		ОбщийТекстСубконто = ОбщийТекстСубконто + " и ...";
	Иначе
		ОбщийТекстСубконто = ОбщийТекстСубконто + " и " + ТекстКорСубконто;
	КонецЕсли;
	
	ПредставлениеПериодаОтчета = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
		ПараметрыОтчета.НачалоПериода, ПараметрыОтчета.КонецПериода);
	ЗаголовокОтчета = СтрШаблон(НСтр("ru = 'Обороты между субконто %1%2'"),
		ОбщийТекстСубконто, ПредставлениеПериодаОтчета);
	
	Возврат ЗаголовокОтчета;
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	КомпоновщикНастроек.Настройки.Выбор.Элементы.Очистить();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", НачалоДня(ПараметрыОтчета.НачалоПериода));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	МассивВидовСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из ПараметрыОтчета.СписокВидовСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	МассивВидовКорСубконто = Новый Массив;
	Для Каждого ЭлементСписка Из ПараметрыОтчета.СписокВидовКорСубконто Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда 
			МассивВидовКорСубконто.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если МассивВидовСубконто.Количество() > 0 Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовСубконто", МассивВидовСубконто);
	КонецЕсли;
	Если МассивВидовКорСубконто.Количество() > 0 Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "СписокВидовКорСубконто", МассивВидовКорСубконто);
	КонецЕсли;
	
	БухгалтерскиеОтчетыПереопределяемый.УстановитьПараметрыВалют(Схема, КомпоновщикНастроек, ПараметрыОтчета);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	// Колонка "показатели".
	ГруппаПоказатели = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаПоказатели.Заголовок     = БухгалтерскиеОтчеты.ЗаголовокГруппыПоказателей();
	ГруппаПоказатели.Использование = Истина;
	ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] И ИмяПоказателя <> "ВалютнаяСумма" Тогда 
			БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
		КонецЕсли;
	КонецЦикла;	
	
	ГруппаДт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = НСтр("ru = 'Дебет'");
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаКт = КомпоновщикНастроек.Настройки.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = НСтр("ru = 'Кредит'");
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] И ИмяПоказателя <> "ВалютнаяСумма" Тогда
			Если БухгалтерскиеОтчетыКлиентСервер.ПоказательДоступен(КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт") Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод.ПустаяЯчейкаДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод.ПустаяЯчейкаКт");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	// Дополнительные данные.
	БухгалтерскиеОтчетыВызовСервера.ДобавитьДополнительныеПоля(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформлениеАвтоотступа = Неопределено;
	Для каждого ЭлементОформления Из КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru = 'Уменьшенный автоотступ'") Тогда
			УсловноеОформлениеАвтоотступа = ЭлементОформления;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если УсловноеОформлениеАвтоотступа = Неопределено Тогда
		УсловноеОформлениеАвтоотступа = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();
		УсловноеОформлениеАвтоотступа.Представление = НСтр("ru = 'Уменьшенный автоотступ'");
		УсловноеОформлениеАвтоотступа.Оформление.УстановитьЗначениеПараметра("Автоотступ", 1);
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
		УсловноеОформлениеАвтоотступа.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		УсловноеОформлениеАвтоотступа.Поля.Элементы.Очистить();
	КонецЕсли;
	
	Структура = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Структура.Имя = "ШапкаОтчета";
	Первый = Истина;
	Для Каждого ПолеВыбраннойГруппировки Из ПараметрыОтчета.Группировка Цикл 
		Если ПолеВыбраннойГруппировки.Использование Тогда
			Если Не Первый Тогда 
				Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			КонецЕсли;
			Первый = Ложь;
			ПолеГруппировки = Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ПолеВыбраннойГруппировки.Поле);
			
			Если ПолеВыбраннойГруппировки.ТипГруппировки = 1 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия;
			ИначеЕсли ПолеВыбраннойГруппировки.ТипГруппировки = 2 Тогда
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия;
			Иначе
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			КонецЕсли;
			Структура.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
			
			ПолеОформления = УсловноеОформлениеАвтоотступа.Поля.Элементы.Добавить();
			ПолеОформления.Поле = ПолеГруппировки.Поле;
		КонецЕсли;
	КонецЦикла;
	Структура = Структура.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Структура.Имя = "Детали";
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Структура.Выбор,  "Счет");
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Структура.Выбор,  "КорСчет");
	
	// Колонка "показатели".
	Если КоличествоПоказателей > 1 Тогда
		ГруппаПоказатели = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
		ГруппаПоказатели.Заголовок     = БухгалтерскиеОтчеты.ЗаголовокГруппыПоказателей();
		ГруппаПоказатели.Использование = Истина;
		ГруппаПоказатели.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
		
		Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
			Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда 
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаПоказатели, "Показатели." + ИмяПоказателя);
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	ГруппаДт = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаДт.Заголовок     = "Дебет";
	ГруппаДт.Использование = Истина;
	ГруппаДт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	ГруппаКт = Структура.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	ГруппаКт.Заголовок     = "Кредит";
	ГруппаКт.Использование = Истина;
	ГруппаКт.Расположение  = РасположениеПоляКомпоновкиДанных.Вертикально;
	
	Для Каждого ИмяПоказателя Из ПараметрыОтчета.НаборПоказателей Цикл
		Если ПараметрыОтчета["Показатель" + ИмяПоказателя] Тогда
			Если БухгалтерскиеОтчетыКлиентСервер.ПоказательДоступен(КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт") Тогда
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод." + ИмяПоказателя + "ОборотКт");
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаДт, "ОборотыЗаПериод.ПустаяЯчейкаДт");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ГруппаКт, "ОборотыЗаПериод.ПустаяЯчейкаКт");
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Структура.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));  
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.НУОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ПРОборотДт");
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВРОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьНалоговыйУчет", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.КоличествоОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьКоличество", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	УсловноеОформление = КомпоновщикНастроек.Настройки.УсловноеОформление.Элементы.Добавить();	
	Поле = УсловноеОформление.Поля.Элементы.Добавить();
	Поле.Поле = Новый ПолеКомпоновкиДанных("ОборотыЗаПериод.ВалютнаяСуммаОборотДт");
	
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(УсловноеОформление.Отбор, "ЕстьВалюта", 0);
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(УсловноеОформление.Оформление, "МаксимальнаяВысота", 1);
	
	Если УсловноеОформлениеАвтоотступа.Поля.Элементы.Количество() = 0 Тогда
		УсловноеОформлениеАвтоотступа.Использование = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	МакетШапкиОтчета = БухгалтерскиеОтчеты.ПолучитьМакетШапки(МакетКомпоновки);
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	КоличествоГруппировок = 1;
	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл
		Если СтрокаТаблицы.Использование Тогда
			КоличествоГруппировок = КоличествоГруппировок + 1;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоСтрокПараметров = БухгалтерскиеОтчетыПереопределяемый.ВысотаВыводимыхПараметров(ПараметрыОтчета.СхемаКомпоновкиДанных);
	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 1);
	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокПараметров + КоличествоСтрокШапки);
	
	МассивДляУдаления = Новый Массив;
	Для Индекс = КоличествоСтрокШапки По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
		МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
	КонецЦикла;
	
	КоличествоСтрок = МакетШапкиОтчета.Макет.Количество();
	Для ИндексСтроки = 1 По КоличествоСтрок - 1 Цикл
		СтрокаМакета = МакетШапкиОтчета.Макет[ИндексСтроки];
		
		КоличествоКолонок = СтрокаМакета.Ячейки.Количество();
		
		Для ИндексКолонки = КоличествоКолонок - 5 По КоличествоКолонок - 1 Цикл
			Ячейка = СтрокаМакета.Ячейки[ИндексКолонки];
			БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоВертикали", Истина);
			Если ИндексКолонки = КоличествоКолонок - 1 ИЛИ ИндексКолонки = КоличествоКолонок - 3 Тогда
				БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(Ячейка.Оформление.Элементы, "ОбъединятьПоГоризонтали", Истина);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;	
	
	Для Каждого Элемент Из МассивДляУдаления Цикл
		МакетШапкиОтчета.Макет.Удалить(Элемент);
	КонецЦикла;
	
	ПараметрыПоиска = БухгалтерскиеОтчеты.ПараметрыПоискаВТелеМакетаКомпоновки();
	ПараметрыПоиска.ИскатьВДетальныхЗаписях  = Истина;
	ПараметрыПоиска.СвойствоДляИдентификации = "ПолеГруппировки";
	ПараметрыПоиска.ВозвращаемыйТип          = "Макет";
	
	МакетДетали = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(МакетКомпоновки, "Детали", ПараметрыПоиска);
	Если МакетДетали <> Неопределено Тогда
		Для Каждого СтрокаМакета Из МакетДетали.Макет Цикл
			Для Каждого Ячейка Из СтрокаМакета.Ячейки Цикл
				ЗначениеПараметра = БухгалтерскиеОтчетыКлиентСервер.ПолучитьПараметр(Ячейка.Оформление.Элементы, "Расшифровка");
				
				ПараметрРасшифровки = МакетДетали.Параметры.Найти(ЗначениеПараметра.Значение);
				Если ТипЗнч(ПараметрРасшифровки) = Тип("ПараметрОбластиРасшифровкаКомпоновкиДанных") Тогда 
					Если ПараметрРасшифровки.ВыраженияПолей.Найти("Счет") = Неопределено Тогда 
						ПараметрСчет = ПараметрРасшифровки.ВыраженияПолей.Добавить();
						ПараметрСчет.Поле      = "Счет";
						ПараметрСчет.Выражение = "ОсновнойНабор.Счет";
					КонецЕсли;
					Если ПараметрРасшифровки.ВыраженияПолей.Найти("КорСчет") = Неопределено Тогда
						ПараметрКорСчет = ПараметрРасшифровки.ВыраженияПолей.Добавить();
						ПараметрКорСчет.Поле      = "КорСчет";
						ПараметрКорСчет.Выражение = "ОсновнойНабор.КорСчет";
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если ПараметрыОтчета.ПоказательВалютнаяСумма Тогда
		Для Каждого Макет Из МакетКомпоновки.Макеты Цикл 
			Если Макет <> МакетДетали И Макет <> МакетШапкиОтчета Тогда
				Если Макет.Макет.Количество() >= КоличествоПоказателей Тогда
					Макет.Макет.Удалить(Макет.Макет[КоличествоПоказателей - 1]);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);

	Индекс = Результат.ВысотаТаблицы;
	Пока Индекс > 0 Цикл
		ИндексСтроки = "R" + Формат(Индекс,"ЧГ=0");
		Если Результат.Область(ИндексСтроки).ВысотаСтроки = 1 Тогда
			Результат.УдалитьОбласть(Результат.Область(ИндексСтроки), ТипСмещенияТабличногоДокумента.ПоВертикали);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
	Иначе
		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
	КонецЕсли;
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
		
	НаборПоказателей.Добавить("УУ");
	НаборПоказателей.Добавить("РазницаБУиУУ");
	
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
		
	НаборПоказателей.Добавить("ФО");
	
	НаборПоказателей.Добавить("ВалютнаяСумма");
	НаборПоказателей.Добавить("Количество");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецОбласти

#Область РасшифровкаСтандартныхОтчетов

// Заполняет настройки расшифровки (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки) для переданного экземпляра отчета.
//
// Параметры:
//  Настройки                - Структура                                - Настройки расшифровки отчета, которые нужно заполнить (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//  Объект                   - ОтчетОбъект                              - Отчет из данных которого нудно собрать универсальные настройки.
//  ДанныеРасшифровки        - ДанныеРасшифровкиКомпоновкиДанных        - Данные расшифровки отчета.
//  ИдентификаторРасшифровки - ИдентификаторРасшифровкиКомпоновкиДанных - Идентификатор расшифровки из ячейки для которой вызвана расшифровка.
//  РеквизитыРасшифровки     - Структура                                - Реквизиты отчета полученные из контекста расшифровываемой ячейки.
//
Процедура ЗаполнитьНастройкиРасшифровки(Настройки, Объект, ДанныеРасшифровки, ИдентификаторРасшифровки, РеквизитыРасшифровки) Экспорт

	БухгалтерскиеОтчетыРасшифровка.ЗаполнитьНастройкиРасшифровкиПоДаннымСтандартногоОтчета(Настройки, ДанныеРасшифровки, ИдентификаторРасшифровки, Объект, РеквизитыРасшифровки);
	
	БухгалтерскиеОтчетыПереопределяемый.ДополнитьНастройкуРасшифровкиПоказателямиУправленческогоУчетаИОтчетности(Настройки, Объект);
	
КонецПроцедуры

// Адаптирует переданные настройки для данного вида отчетов.
// Перед применением настроек расшифровки может возникнуть необходимость учесть особенности этого вида отчетов.
//
// Параметры:
//  Настройки - Структура - Настройки которые нужно адаптировать (см. БухгалтерскиеОтчетыКлиентСервер.НовыйУниверсальныеНастройки).
//
Процедура АдаптироватьНастройки(Настройки) Экспорт
	
КонецПроцедуры

// Устанавливает какими отчетами и при каких условиях может быть расшифрован этот вид отчетов.
//
// Параметры:
//  Правила - ТаблицаЗначений с правилами расшифровки этого отчета см. БухгалтерскиеОтчетыРасшифровка.НовыйПравилаРасшифровки.
//
Процедура ЗаполнитьПравилаРасшифровки(Правила) Экспорт

	Правило = Правила.Добавить();
	Правило.Отчет = "ОтчетПоПроводкам";
	Правило.ШаблонПредставления = НСтр("ru = 'Отчет по проводкам'");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли