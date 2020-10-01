
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЗаявкиИзКэша = Документы.ЗаявкиНаЛьготныйКредит.ЗаявкиСНеправильнымиКонтактамиБанка(Истина);
	ЗаявкиИзБазы = Документы.ЗаявкиНаЛьготныйКредит.ЗаявкиСНеправильнымиКонтактамиБанка(Ложь);
	
	Если ЗаявкиИзКэша.Количество() = ЗаявкиИзБазы.Количество()
		И ЗаявкиИзКэша.Количество() > 0 Тогда
		
		ОбработатьЗаявки(ЗаявкиИзКэша);
		
	КонецЕсли;
	
	ИзменитьОформлениеФормы(ЗаявкиИзКэша);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура БольшеНеНапоминать(Команда)
	БольшеНеНапоминатьНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура БольшеНеНапоминатьНаСервере()
	
	ХранилищеОбщихНастроек.Сохранить(
		"ЛьготныеЗаявки_КонтактыБанка_БольшеНеНапоминать",
		,
		Истина);
	
КонецПроцедуры
	
&НаСервере
Процедура ОбработатьЗаявки(Заявки)
	
	НеправильныйТелефон = Документы.ЗаявкиНаЛьготныйКредит.НеправильныйТелефон();
	ПравильныйТелефон = Документы.ЗаявкиНаЛьготныйКредит.ПравильныйТелефон();
	
	Для каждого Заявка Из Заявки Цикл
		Попытка
			ЗаявкаОбъект = Заявка.ПолучитьОбъект();
			ЗаявкаОбъект.КонтактыБанка = СтрЗаменить(ЗаявкаОбъект.КонтактыБанка, НеправильныйТелефон, ПравильныйТелефон);
			ЗаявкаОбъект.Записать();
		Исключение
			
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ИнформацияОбОшибке = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявки на льготный кредит'", КодОсновногоЯзыка),УровеньЖурналаРегистрации.Ошибка,,,ИнформацияОбОшибке);
		
		КонецПопытки;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьОформлениеФормы(Заявки)
	
	Количество = Заявки.Количество();
	
	Подстрока1 = НСтр("ru = 'Ранее вы отправили '");
	Если Количество = 1 Тогда
		Ссылка = ПолучитьНавигационнуюСсылку(Заявки[0]);
		Подстрока2 = Новый ФорматированнаяСтрока(НСтр("ru = 'заявку'"),,,,Ссылка);
	Иначе
		Подстрока2 = Новый ФорматированнаяСтрока(НСтр("ru = 'заявки'"),,,,"e1cib/command/ОбщаяКоманда.ЛьготныеКредиты");
	КонецЕсли;
	
	Подстрока3 = НСтр("ru = ' на льготный кредит.'");
	Подстрока4 = НСтр("ru = 'Обратите внимание, в ответе был указан некорректный телефон банка.'");
	Подстрока5 = НСтр("ru = 'Правильный номер телефона: '");
	Подстрока6 = Новый ФорматированнаяСтрока(НСтр("ru = '8(800)200-7799'"), Новый Шрифт(,,Истина));
	Подстрока7 = НСтр("ru = 'Если вы ранее не дозвонились до банка, пожалуйста, позвоните по указанному номеру и назовите номер заявки.'");
	
	Элементы.Текст.Заголовок = Новый ФорматированнаяСтрока(
	Подстрока1,
	Подстрока2,
	Подстрока3,
	Символы.ПС,
	Подстрока4,
	Символы.ПС,
	Символы.ПС,
	Подстрока5,
	Подстрока6,
	Символы.ПС,
	Символы.ПС,
	Подстрока7);
	
КонецПроцедуры

#КонецОбласти






