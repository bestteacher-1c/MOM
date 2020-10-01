#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВариантыОтчетов

// Для подсистемы "Варианты отчетов" при работе в модели сервиса.
Функция ВариантыНастроек() Экспорт
	
	Результат = Новый Массив;
	
	Вариант = Новый Структура;
	Вариант.Вставить("Имя",           "ТранспортныеРасходы");
	Вариант.Вставить("Представление", НСтр("ru = 'Транспортные расходы'"));
	Результат.Добавить(Вариант);
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Возврат Новый Структура("ИспользоватьПередКомпоновкойМакета,
	|ИспользоватьПослеКомпоновкиМакета,
	|ИспользоватьПослеВыводаРезультата,
	|ИспользоватьДанныеРасшифровки,
	|ИспользоватьПриВыводеЗаголовка",
	Истина, Истина, Истина, Ложь,Истина);
	
КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
	Макет = ПолучитьОбщийМакет("ОбщиеОбластиСтандартногоОтчета");
	ОбластьЗаголовок        = Макет.ПолучитьОбласть("ОбластьЗаголовок");
	ОбластьОрганизация      = Макет.ПолучитьОбласть("Организация");
	
	//Организация
	ТекстОрганизация = БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(ПараметрыОтчета.Организация, ПараметрыОтчета.ВключатьОбособленныеПодразделения);
	ОбластьОрганизация.Параметры.НазваниеОрганизации = ТекстОрганизация;
	Результат.Вывести(ОбластьОрганизация);
	
	//Заголовок
	ОбластьЗаголовок.Параметры.ЗаголовокОтчета = "" + ПолучитьТекстЗаголовка(ПараметрыОтчета) + " (" + ПараметрыОтчета.НазваниеНабораПоказателейОтчета + ")";
	Результат.Вывести(ОбластьЗаголовок);
	
	Результат.Область("R1:R" + Результат.ВысотаТаблицы).Имя = "Заголовок";
	
	// Единица измерения
	Если ПараметрыОтчета.Свойство("ВыводитьЕдиницуИзмерения")
		И ПараметрыОтчета.ВыводитьЕдиницуИзмерения Тогда
		ОбластьОписаниеЕдиницыИзмерения = Макет.ПолучитьОбласть("ОписаниеЕдиницыИзмерения");
		Результат.Вывести(ОбластьОписаниеЕдиницыИзмерения);
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиПоИмени(Структура, Имя)
	Группировка = Неопределено;
	Для каждого Элемент Из Структура Цикл
		Если ТипЗнч(Элемент) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
		Иначе
			Если Элемент.Имя = Имя Тогда
				Возврат Элемент;
			КонецЕсли;	
			Для каждого Поле Из Элемент.ПоляГруппировки.Элементы Цикл
				Если Не ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
					Если Поле.Поле = Новый ПолеКомпоновкиДанных(Имя) Тогда
						Возврат Элемент;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Элемент.Структура.Количество() = 0 Тогда
				Продолжить;
			Иначе
				Группировка = НайтиПоИмени(Элемент.Структура, Имя);
				Если Не Группировка = Неопределено Тогда
					Возврат	Группировка;
				КонецЕсли;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Группировка;
	
КонецФункции

Функция ПолучитьТекстЗаголовка(ПараметрыОтчета, ОрганизацияВНачале = Истина) Экспорт 
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Справка-расчет транспортных расходов %1'"),
		БухгалтерскиеОтчетыКлиентСервер.ПолучитьПредставлениеПериода(
			?(ПараметрыОтчета.СНачалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),
			ПараметрыОтчета.НачалоПериода),
			ПараметрыОтчета.КонецПериода));
	
КонецФункции

// В процедуре можно доработать компоновщик перед выводом в отчет
// Изменения сохранены не будут.
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", ?(ПараметрыОтчета.СначалаГода,НачалоГода(ПараметрыОтчета.НачалоПериода),НачалоДня(ПараметрыОтчета.НачалоПериода)));
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", КонецДня(ПараметрыОтчета.КонецПериода));
	КонецЕсли;
	
	КоличествоПоказателей = БухгалтерскиеОтчетыВызовСервера.КоличествоПоказателей(ПараметрыОтчета);
	
	ГруппировкаСтатьи = НайтиПоИмени(КомпоновщикНастроек.Настройки.Структура,"ГруппировкаСтатьяЗатрат");
	
	Таблица = НайтиПоИмени(ГруппировкаСтатьи.Структура,"ТранспортныеРасходы");
	
	Если ПараметрыОтчета.ПоказательНУ Тогда 
		Группировка 	= НайтиПоИмени(Таблица.Строки,"ГруппировкаНУ");
	ИначеЕсли ПараметрыОтчета.ПоказательВР Тогда					
		Группировка 	= НайтиПоИмени(Таблица.Строки,"ГруппировкаСРазницами");
	Иначе
		Группировка 	= НайтиПоИмени(Таблица.Строки,"ГруппировкаБУ");
	КонецЕсли;
	Группировка.Использование = Истина;
	
	Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
	Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
	БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Период");
	Если ПараметрыОтчета.ПоказательНУ Тогда	
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"НачальныйОстатокИПриобретениеТовары");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Реализация");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РеализацияПрочее");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"КонечныйОстаток");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"НачальныйОстатокИПриобретениеРасходы");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Реализация");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РеализацияПрочее");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Процент");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РасчетСписаниеРасходов");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"КонечныйОстатокРасходы");
		
	Иначе 
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"НачальныйОстатокИПриобретениеРасходы");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"РасчетСписаниеРасходов");
		БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,"Доля");
		
		Массив = Новый Массив;
		Массив.Добавить("НачальныйОстатокРасходы");
		Массив.Добавить("ПриобретениеРасходов");
		Массив.Добавить("СписаниеРасходов");
		Массив.Добавить("КонечныйОстатокРасходы");
		
		МассивПоказателей = Новый Массив;
		МассивПоказателей.Добавить("БУ");
		МассивПоказателей.Добавить("ПР");
		МассивПоказателей.Добавить("ВР");
		
		
		
		Если ПараметрыОтчета.ПоказательВР Тогда 
			Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
			ПодГруппа	= Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
			ПодГруппа.Расположение 		= РасположениеПоляКомпоновкиДанных.Вертикально;
			
			Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, "Показатели." + ИмяПоказателя);
			КонецЦикла;
			
		КонецЕсли;	
		
		
		Для Каждого ИмяПоказателя Из Массив Цикл
			
			
			Если ПараметрыОтчета.ПоказательВР Тогда
				Группа = Группировка.Выбор.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				Группа.Расположение = РасположениеПоляКомпоновкиДанных.ОтдельнаяКолонка;
				ПодГруппа = Группа.Элементы.Добавить(Тип("ГруппаВыбранныхПолейКомпоновкиДанных"));
				ПодГруппа.Расположение = РасположениеПоляКомпоновкиДанных.Вертикально;
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяПоказателя + "БУ");			
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяПоказателя + "ПР");
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(ПодГруппа, ИмяПоказателя + "ВР");
			Иначе
				БухгалтерскиеОтчетыКлиентСервер.ДобавитьВыбранноеПоле(Группа,ИмяПоказателя + "БУ");	
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ДобавитьОтборПоОрганизации(ПараметрыОтчета, КомпоновщикНастроек);
	
КонецПроцедуры

Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт
	
	ПараметрыПоиска = БухгалтерскиеОтчеты.ПараметрыПоискаВТелеМакетаКомпоновки();
	ПараметрыПоиска.МножественныйПодбор = Истина;
	ЭлементыТела = БухгалтерскиеОтчеты.ПодобратьЭлементыИзТелаМакета(
					МакетКомпоновки, "Группировка", ПараметрыПоиска);
	
	Для каждого ЭлементТела Из ЭлементыТела Цикл
	
		Если ЭлементТела.Имя = "ГруппировкаБУ"
			ИЛИ ЭлементТела.Имя = "ГруппировкаНУ"
			ИЛИ ЭлементТела.Имя = "ГруппировкаСРазницами" Тогда
			ЭлементТела.Тело.Удалить(ЭлементТела.Тело[1]);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
	Область = Результат.НайтиТекст("###",Результат.Область("r1c1"));
	Пока НЕ Область = Неопределено Цикл
		
		Область.Текст = Формат(СтрЗаменить(Область.Текст,"###",""),"ЧДЦ=2");
		Область.Примечание.Текст = НСтр(
			"ru = 'Ожидается изменение результатов
			|регламентной операции ""Списание косвенных расходов"",
			|рекомендуется выполнить ее повторно и
			|проверить проводки списания транспортных расходов'");
		Область.Примечание.ЦветФона = WebЦвета.АкварельноСиний;
		Область.Примечание.Шрифт = Метаданные.ЭлементыСтиля.ШрифтВажнойНадписи.Значение;
		Область = Результат.НайтиТекст("###",Область);
		
	КонецЦикла;
	
	БухгалтерскиеОтчетыВызовСервера.ОбработкаРезультатаОтчета(ПараметрыОтчета.ИдентификаторОтчета, Результат);
	
	Результат.ФиксацияСверху = 0;
	
	Результат.ФиксацияСлева = 0;
	
	
КонецПроцедуры

Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("БУ");
	НаборПоказателей.Добавить("НУ");
	НаборПоказателей.Добавить("ПР");
	НаборПоказателей.Добавить("ВР");
	
	Возврат НаборПоказателей;
	
КонецФункции

#КонецЕсли