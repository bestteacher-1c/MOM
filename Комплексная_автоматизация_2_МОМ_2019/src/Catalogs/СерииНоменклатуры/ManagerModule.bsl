#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Рассчитывает максимальный номер серии который уже используется для вида номенклатуры
// или уже указан в ТаблицеЗначений "ТаблицаСерий".
//
// Параметры:
//	ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, для которого ищется номер серии.
//
// Возвращаемое значение:
//   Число - номер серии 
//
Функция ВычислитьМаксимальныйНомерСерии(ВидНоменклатуры)  Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СерииНоменклатуры.Номер
	|ИЗ
	|	Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|ГДЕ
	|	СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры
	|	И НЕ СерииНоменклатуры.ПометкаУдаления
	|	И СерииНоменклатуры.Номер ПОДОБНО ""[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]""
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номер УБЫВ";
	
	Запрос.УстановитьПараметр("ВидНоменклатуры", ВидНоменклатуры);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ОписаниеТипаЧисла = Новый ОписаниеТипов("Число");
	ЗначениеКодаЧислом = ОписаниеТипаЧисла.ПривестиЗначение(Выборка.Номер);
	
	Возврат ЗначениеКодаЧислом;
	
КонецФункции

// Возвращает таблицу отсутствующих номеров серий в указанном диапазоне.
//
// Параметры:
//	ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, для которого ищутся номера серий
//	НачальныйНомер - Число - начальный номер диапазона
//	КонечныйНомер - Число - начальный номер диапазона
//	Количество - Число - требуемое количество отсутствующих номеров.
//
// Возвращаемое значение:
//   ТаблицаЗначений - серии
//		Серия - СправочникСсылка.СерииНоменклатуры
//		Номер - Строка
//
Функция СгенерироватьНомераСерийВДиапазоне(ВидНоменклатуры, НачальныйНомер, КонечныйНомер, Количество) Экспорт
	
	ТаблицаНомеров = Новый ТаблицаЗначений;
	ТаблицаНомеров.Колонки.Добавить("Номер", Новый ОписаниеТипов("Строка"));
	
	ТекущийНачальныйНомер = НачальныйНомер;
	РазмерПорции = 10000; // диапазон номеров может быть очень большим, будем искать свободные номера небольшими порциями
	
	Пока ТекущийНачальныйНомер <= КонечныйНомер Цикл
		
		ПорцияНомеров = ПолучитьНомераСерийВДиапазоне(
			ВидНоменклатуры,
			ТекущийНачальныйНомер,
			Мин(ТекущийНачальныйНомер + РазмерПорции, КонечныйНомер),
			Ложь);
		
		Для Каждого ТекСтр Из ПорцияНомеров Цикл
			
			ТаблицаНомеров.Добавить().Номер = ТекСтр.Номер;
			Если ТаблицаНомеров.Количество() = Количество Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТаблицаНомеров.Количество() = Количество Тогда
			Прервать;
		КонецЕсли;
		
		ТекущийНачальныйНомер = ТекущийНачальныйНомер + РазмерПорции;
		
	КонецЦикла;
	
	Возврат ТаблицаНомеров;
	
КонецФункции

// Возвращает таблицу номеров серий в указанном диапазоне.
//
// Параметры:
//	ВидНоменклатуры - СправочникСсылка.ВидыНоменклатуры - вид номенклатуры, для которого ищутся номера серий
//	НачальныйНомер - Число - начальный номер диапазона
//	КонечныйНомер - Число - начальный номер диапазона
//	ФильтрСуществующие - Булево - отбор существующих/отсутствующих номеров серий; Неопределено - без отбора.
//
// Возвращаемое значение:
//   ТаблицаЗначений - серии
//		Серия - СправочникСсылка.СерииНоменклатуры
//		Номер - Строка
//
Функция ПолучитьНомераСерийВДиапазоне(ВидНоменклатуры, НачальныйНомер, КонечныйНомер, ФильтрСуществующие = Неопределено) Экспорт
	
	ТаблицаНомеров = Новый ТаблицаЗначений;
	ТаблицаНомеров.Колонки.Добавить("Номер", Новый ОписаниеТипов("Строка"));
	
	Для НомерСерии = НачальныйНомер По КонечныйНомер Цикл
		ТаблицаНомеров.Добавить().Номер = Формат(НомерСерии, "ЧЦ=8; ЧВН=; ЧГ=");
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(Т.Номер КАК СТРОКА(8)) КАК Номер
	|ПОМЕСТИТЬ ВТНомера
	|ИЗ
	|	&ТаблицаНомеров КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Серии.Серия,
	|	Серии.Номер
	|ИЗ
	|	(ВЫБРАТЬ
	|		СерииНоменклатуры.Ссылка КАК Серия,
	|		ВТНомера.Номер КАК Номер,
	|		ВЫБОР
	|			КОГДА СерииНоменклатуры.Ссылка ЕСТЬ NULL 
	|				ТОГДА ЛОЖЬ
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ КАК Существует
	|	ИЗ
	|		ВТНомера КАК ВТНомера
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СерииНоменклатуры КАК СерииНоменклатуры
	|			ПО ВТНомера.Номер = СерииНоменклатуры.Номер
	|				И (СерииНоменклатуры.ВидНоменклатуры = &ВидНоменклатуры)
	|				И (НЕ СерииНоменклатуры.ПометкаУдаления)) КАК Серии
	|ГДЕ
	|	(&ФильтрСуществующие = НЕОПРЕДЕЛЕНО
	|			ИЛИ Серии.Существует = &ФильтрСуществующие)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Серии.Номер";
	
	Запрос.УстановитьПараметр("ТаблицаНомеров", 	ТаблицаНомеров);
	Запрос.УстановитьПараметр("ВидНоменклатуры", 	ВидНоменклатуры);
	Запрос.УстановитьПараметр("ФильтрСуществующие", ФильтрСуществующие);
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

// Возвращает имена реквизитов, которые не должны отображаться в списке реквизитов обработки ГрупповоеИзменениеОбъектов.
//
//	Возвращаемое значение:
//		Массив - массив имен реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Номер");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	НоменклатураВызовСервера.СерииНоменклатурыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
		
		Если Параметры.Свойство("ПоОстаткам") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			Если НЕ Параметры.Свойство("Номенклатура") ИЛИ НЕ ЗначениеЗаполнено(Параметры.Номенклатура) Тогда
				ТекстИсключения = НСтр("ru = 'Перед указанием серии нужно выбрать номенклатуру.'");
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
			
			ВыбраннаяФорма = "ФормаВыбораПоОстаткам";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#КонецЕсли