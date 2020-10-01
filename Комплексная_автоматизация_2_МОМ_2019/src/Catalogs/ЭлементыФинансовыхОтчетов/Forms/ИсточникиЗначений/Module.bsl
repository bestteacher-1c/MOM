
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Перем Кэш;
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заполнение = Ложь;
	Если Параметры.Свойство("Заполнение") Тогда
		Заполнение = Параметры.Заполнение;
	КонецЕсли;
	
	ДеревоЭлементов = ПолучитьИзВременногоХранилища(Параметры.АдресЭлементовОтчета);
	СтрокаДерева = ФинансоваяОтчетностьСервер.ПодчиненныйЭлемент(ДеревоЭлементов, "АдресСтруктурыЭлемента", Параметры.АдресЭлементаВХранилище);
	СписокДоступныхЭлементов = БюджетнаяОтчетностьРасчетКэшаСервер.ИсточникиЗначенийЭлемента(Кэш, СтрокаДерева, Заполнение);
	
	ТаблицаПредыдущихИсточников = Параметры.ИсточникиЗначений.Выгрузить(Новый Структура("ДобавляемыеЗначенияДокумента", Ложь));
	ДеревоИсточников = РеквизитФормыВЗначение("ИсточникиЗначений");
	
	НоваяСтрока = Неопределено;
	Для Каждого СтрокаДоступныхЭлементов Из СписокДоступныхЭлементов Цикл
		Элемент = СтрокаДоступныхЭлементов.Элемент;
		Если ЗначениеЗаполнено(СтрокаДоступныхЭлементов.Родитель) Тогда
			МестоДобавления = ДеревоИсточников.Строки.Найти(СтрокаДоступныхЭлементов.Родитель, "Источник", Истина);
		Иначе
			МестоДобавления = ДеревоИсточников;
		КонецЕсли;
		НоваяСтрока = МестоДобавления.Строки.Добавить();
		НоваяСтрока.Источник = Элемент;
		Если ТипЗнч(Элемент) = Тип("Строка") Тогда
			РеквизитыОбъекта = ПолучитьИзВременногоХранилища(Элемент);
		Иначе
			РеквизитыОбъекта = Новый Структура("Ссылка", Элемент);
		КонецЕсли;
		НоваяСтрока.ВидЭлемента = СтрокаДоступныхЭлементов.ВидЭлемента;
		НоваяСтрока.Представление = СтрокаДоступныхЭлементов.Наименование;
		НоваяСтрока.НестандартнаяКартинка = ФинансоваяОтчетностьПовтИсп.НестандартнаяКартинка(НоваяСтрока.ВидЭлемента);
		Для Каждого СтрокаЭлемента Из ТаблицаПредыдущихИсточников Цикл
			Если СтрокаЭлемента.Источник = РеквизитыОбъекта.Ссылка ИЛИ СтрокаЭлемента.Источник = Элемент Тогда
				НоваяСтрока.Использование = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	ЗаполнитьФлагиПоПодчиненнымЭлементамНаСервере(ФинансоваяОтчетностьСервер.ПодчиненныеСтроки(ДеревоИсточников));
	
	ЗначениеВРеквизитФормы(ДеревоИсточников, "ИсточникиЗначений");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ИсточникиЗначений);
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		Элементы.ИсточникиЗначений.Развернуть(ПодчиненнаяСтрока.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормы

&НаКлиенте
Процедура ИсточникиЗначенийИспользованиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ИсточникиЗначений.ТекущиеДанные;
	Если ТекущиеДанные.Использование = 2 Тогда
		ТекущиеДанные.Использование = 0;
	КонецЕсли;
	
	ЗаполнитьФлагиПодчиненныхСтрок(ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ТекущиеДанные), ТекущиеДанные.Использование);
	
	Родитель = ФинансоваяОтчетностьКлиентСервер.РодительСтроки(ТекущиеДанные);
	Пока Родитель <> Неопределено Цикл
		ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(Родитель);
		Родитель.Использование = ЗаполнитьФлагиПоПодчиненнымЭлементам(ПодчиненныеСтроки, Ложь);
		Родитель = ФинансоваяОтчетностьКлиентСервер.РодительСтроки(Родитель);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Закрыть(ПолучитьРезультатВыбора());
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ЗаполнитьФлагиПодчиненныхСтрок(ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ИсточникиЗначений), 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	ЗаполнитьФлагиПодчиненныхСтрок(ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ИсточникиЗначений), 0);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе(Команда)

	ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ИсточникиЗначений);
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		Элементы.ИсточникиЗначений.Развернуть(ПодчиненнаяСтрока.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)

	ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(ИсточникиЗначений);
	СвернутьСтроку(ПодчиненныеСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьФлагиПодчиненныхСтрок(Строки, Флаг)
	
	Для Каждого Строка Из Строки Цикл
		Строка.Использование = Флаг;
		ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(Строка);
		ЗаполнитьФлагиПодчиненныхСтрок(ПодчиненныеСтроки, Флаг);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРезультатВыбора()
	
	Результат = Новый Массив;
	НайденныеСтроки = РеквизитФормыВЗначение("ИсточникиЗначений").Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
	МассивДоступныхВидов = Новый Массив;
	МассивДоступныхВидов.Добавить(Перечисления.ВидыЭлементовФинансовогоОтчета.СтатьяБюджетов);
	МассивДоступныхВидов.Добавить(Перечисления.ВидыЭлементовФинансовогоОтчета.ПоказательБюджетов);
	МассивДоступныхВидов.Добавить(Перечисления.ВидыЭлементовФинансовогоОтчета.НефинансовыйПоказатель);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Если НайденнаяСтрока.Строки.Количество() Тогда
			// Источники расположены на "нижнем" уровне дерева
			Продолжить;
		КонецЕсли;
		Если МассивДоступныхВидов.Найти(НайденнаяСтрока.ВидЭлемента) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Добавить(НайденнаяСтрока.Источник);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ЗаполнитьФлагиПоПодчиненнымЭлементам(СтрокиДерева, ВключаяПодчиненные = Истина)
	
	МассивФлаговТекущегоУровня = Новый Массив;
	Для Каждого Строка Из СтрокиДерева Цикл
		
		Если ВключаяПодчиненные Тогда
			ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(Строка);
		КонецЕсли;
		Если ВключаяПодчиненные И ПодчиненныеСтроки.Количество() Тогда
			Строка.Использование = ЗаполнитьФлагиПоПодчиненнымЭлементам(ПодчиненныеСтроки);
		КонецЕсли;
		МассивФлаговТекущегоУровня.Добавить(Строка.Использование);
		
	КонецЦикла;
	
	Результат = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивФлаговТекущегоУровня);
	Если Результат.Количество() = 2 Тогда
		Возврат 2;
	ИначеЕсли Результат.Количество() Тогда
		Возврат Результат[0];
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ЗаполнитьФлагиПоПодчиненнымЭлементамНаСервере(СтрокиДерева, ВключаяПодчиненные = Истина)
	
	МассивФлаговТекущегоУровня = Новый Массив;
	Для Каждого Строка Из СтрокиДерева Цикл
		
		Если ВключаяПодчиненные Тогда
			ПодчиненныеСтроки = ФинансоваяОтчетностьСервер.ПодчиненныеСтроки(Строка);
		КонецЕсли;
		Если ВключаяПодчиненные И ПодчиненныеСтроки.Количество() Тогда
			Строка.Использование = ЗаполнитьФлагиПоПодчиненнымЭлементамНаСервере(ПодчиненныеСтроки);
		КонецЕсли;
		МассивФлаговТекущегоУровня.Добавить(Строка.Использование);
		
	КонецЦикла;
	
	Результат = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивФлаговТекущегоУровня);
	Если Результат.Количество() = 2 Тогда
		Возврат 2;
	ИначеЕсли Результат.Количество() Тогда
		Возврат Результат[0];
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура СвернутьСтроку(СтрокиДерева)
	
	Для Каждого Строка Из СтрокиДерева Цикл
		ПодчиненныеСтроки = ФинансоваяОтчетностьКлиент.ПодчиненныеСтрокиЭлементаФормы(Строка);
		СвернутьСтроку(ПодчиненныеСтроки);
		Элементы.ИсточникиЗначений.Свернуть(Строка.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
