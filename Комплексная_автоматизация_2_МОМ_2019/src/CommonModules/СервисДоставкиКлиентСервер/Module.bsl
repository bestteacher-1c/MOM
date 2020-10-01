////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиентСервер.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет многоуровневую структуру данными из одноуровневой структуры.
//
// Параметры:
//  Параметры         - Структура - многоуровневая структура, получатель данных.
//  Данные            - Структура, СтрокаТаблицыЗначений - одноуровневая структура данных, источник данных.
//  ОписаниеДанных    - Массив из Строка - имена колонок строки таблицы значений, для структуры данный параметр игнорируется.
//  Префикс           - Строка - префикс данных источника.
//
Процедура ЗаполнитьСтруктуруПоЛинейнымДанным(Параметры, Данные, ОписаниеДанных = Неопределено, Префикс = "") Экспорт
	
	Для Каждого Параметр Из Параметры Цикл
		ИмяКолонки = Префикс + Параметр.Ключ;
		Если ТипЗнч(Параметр.Значение) = Тип("Структура") Тогда
			ЗаполнитьСтруктуруПоЛинейнымДанным(Параметр.Значение, Данные, ОписаниеДанных, ИмяКолонки);
		Иначе
			Если ТипЗнч(Данные) = Тип("Структура") Тогда
				Если Данные.Свойство(ИмяКолонки) Тогда
					Данные.Свойство(ИмяКолонки, Параметры[Параметр.Ключ]);
				КонецЕсли;
			ИначеЕсли ОписаниеДанных.Найти(ИмяКолонки) <> Неопределено Тогда 
				Параметры[Параметр.Ключ] = Данные[ИмяКолонки];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Заполняет многоуровневую структуру данными из одноуровневой структуры.
//
// Параметры:
//  Параметры            - Структура - многоуровневая структура, источник данных.
//  Данные         - Структура - одноуровневая структура данных, получатель данных.
//  Префикс           - Строка - префикс данных получателя.
//
Процедура ЗаполнитьЛинейныеДанныеПоСтруктуре(Параметры, Данные, Префикс = "") Экспорт
	
	Для Каждого Параметр Из Параметры Цикл
		ИмяКолонки = Префикс + Параметр.Ключ;
		Если ТипЗнч(Параметр.Значение) = Тип("Структура") Тогда
			ЗаполнитьЛинейныеДанныеПоСтруктуре(Параметр.Значение, Данные, ИмяКолонки);
		Иначе
			Данные.Вставить(ИмяКолонки, Параметры[Параметр.Ключ]);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Словарь

Функция ИмяПроцедурыПолучитьЗаказНаДоставку() Экспорт
	Возврат "ПолучитьЗаказНаДоставку";
КонецФункции

Функция ИмяПроцедурыПолучитьУслугиТарифов() Экспорт
	Возврат "ПолучитьУслугиТарифов";
КонецФункции

Функция ИмяПроцедурыПолучитьТарифы() Экспорт
	Возврат "ПолучитьТарифы";
КонецФункции

Функция ИмяПроцедурыСоздатьИзменитьЗаказНаДоставку() Экспорт
	Возврат "СоздатьИзменитьЗаказНаДоставку";
КонецФункции

Функция ИмяПроцедурыОформитьЗаказНаДоставку() Экспорт
	Возврат "ОформитьЗаказНаДоставку";
КонецФункции

Функция ИмяПроцедурыОтменитьЗаказНаДоставку() Экспорт
	Возврат "ОтменитьЗаказНаДоставку";
КонецФункции

Функция ИмяПроцедурыПолучитьДоступныеПечатныеФормы() Экспорт
	Возврат "ПолучитьДоступныеПечатныеФормы";
КонецФункции

Функция ИмяПроцедурыПолучитьФайлыПечатныхФорм() Экспорт
	Возврат "ПолучитьФайлыПечатныхФорм";
КонецФункции

Функция ИмяПроцедурыПолучитьЗаказыНаДоставку() Экспорт
	Возврат "ПолучитьЗаказыНаДоставку";
КонецФункции

Функция ИмяПроцедурыПолучитьСостояния() Экспорт
	Возврат "ПолучитьСостояния";
КонецФункции

Функция ИмяПроцедурыПолучитьГрузоперевозчиков() Экспорт
	Возврат "ПолучитьГрузоперевозчиков";
КонецФункции

Функция ИмяПроцедурыПолучитьДоступныеТерминалы() Экспорт
	Возврат "ПолучитьДоступныеТерминалы";
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеГрузоперевозчика() Экспорт
	Возврат "ПолучитьДанныеГрузоперевозчика";
КонецФункции

Функция ИмяПроцедурыПолучитьДанныеТерминала() Экспорт
	Возврат "ПолучитьДанныеТерминала";
КонецФункции

Функция ИмяПроцедурыПолучитьГрафикДвиженияЗаказа() Экспорт
	Возврат "ПолучитьГрафикДвиженияЗаказа";
КонецФункции

Функция ИмяПроцедурыПолучитьГрафикДвиженияЗаказаПоТрекНомеру() Экспорт
	Возврат "ПолучитьГрафикДвиженияЗаказаПоТрекНомеру";
КонецФункции

#КонецОбласти

#КонецОбласти
