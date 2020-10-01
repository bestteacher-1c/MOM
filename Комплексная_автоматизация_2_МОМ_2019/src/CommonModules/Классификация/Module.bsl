
#Область ПрограммныйИнтерфейс

#Область ПроцедурыОбработкиРегламентныхЗаданий

// Заполняет регистр сведений "ABCXYZКлассификацияКлиентов" результатами ABC классификации партнеров.
//
Процедура ВыполнитьABCКлассификациюПартнеров() Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ABCКлассификацияПартнеров);
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Справочники.Партнеры.ВыполнитьABCКлассификацию();

КонецПроцедуры

// Заполняет регистр сведений "ABCXYZКлассификацияКлиентов" результатами XYZ классификации партнеров.
//
Процедура ВыполнитьXYZКлассификациюПартнеров() Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.XYZКлассификацияПартнеров);
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Справочники.Партнеры.ВыполнитьXYZКлассификацию();

КонецПроцедуры

// Заполняет регистр сведений "ABCXYZКлассификацияНоменклатуры" результатами ABC классификации номенклатуры.
//
Процедура ВыполнитьABCКлассификациюНоменклатуры() Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ABCКлассификацияНоменклатуры);
	
	Справочники.Номенклатура.ВыполнитьABCКлассификацию();

КонецПроцедуры

// Заполняет регистр сведений "ABCXYZКлассификацияНоменклатуры" результатами XYZ классификации номенклатуры.
//
Процедура ВыполнитьXYZКлассификациюНоменклатуры() Экспорт

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.XYZКлассификацияНоменклатуры);
	
	Справочники.Номенклатура.ВыполнитьXYZКлассификацию();

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет классификацию объектов с использованием ABC-анализа.
// Исходными данными для анализа является таблица значений,
// содержащая значения параметра классификации для анализируемых объектов.
// Результат анализа помещается в добавляемую колонку "ABCКласс".
//
// Параметры:
//  ИсточникДанных - таблица значений с колонкой "ЗначениеПараметраКлассификации",
//                   содержащей значения параметра, по которому производится
//                   классификация, для текущего объекта.
//  ИмяПараметраКлассификации - имя колонки в источнике данных, содержащей значение
//                              параметра классификации.
//
Процедура ВыполнитьABCКлассификацию(ИсточникДанных, ИмяПараметраКлассификации) Экспорт
	
	// Источник данных пуст, классификация не требуется.
	Если ИсточникДанных.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	// Классификация без разделения.
	Если ИсточникДанных.Колонки.Найти("РазделительКлассификации") = Неопределено Тогда
		
		ИсточникДанных.Колонки.Добавить("РазделительКлассификации");
		ИсточникДанных.ЗаполнитьЗначения(0, "РазделительКлассификации");
		
	КонецЕсли;
	
	// Источник данных упорядочивается по возрастанию разделителя и убыванию параметра классификации.
	КолонкиСортировки = "РазделительКлассификации Возр";
	
	ЕстьРазделКлассификации = Ложь;
	
	Если ИсточникДанных.Колонки.Найти("РазделКлассификации") <> Неопределено Тогда
		
		КолонкиСортировки = КолонкиСортировки + ", РазделКлассификации Возр";
		ЕстьРазделКлассификации = Истина;
		
	КонецЕсли;
	
	КолонкиСортировки = КолонкиСортировки + ", " + ИмяПараметраКлассификации + " Убыв";
	
	Если ИсточникДанных.Колонки.Найти("Номенклатура") <> Неопределено Тогда
		
		КолонкиСортировки = КолонкиСортировки + ", Номенклатура Возр";
		
		Если ИсточникДанных.Колонки.Найти("Характеристика") <> Неопределено Тогда
			
			КолонкиСортировки = КолонкиСортировки + ", Характеристика Возр";
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИсточникДанных.Сортировать(КолонкиСортировки, Новый СравнениеЗначений);
	
	// В колонку "Класс" будет помещен результат классификации.
	Если ИсточникДанных.Колонки.Найти("Класс") = Неопределено Тогда
		
		ИсточникДанных.Колонки.Добавить("Класс");
		
	КонецЕсли;
	
	ИсточникДанных.ЗаполнитьЗначения(Перечисления.ABCКлассификация.CКласс, "Класс");
	
	// К колонку "ЗначениеПараметраКлассификации" будет помещено значение, по которому выполнена классификация.
	Если ИсточникДанных.Колонки.Найти("ЗначениеПараметраКлассификации") = Неопределено Тогда
		
		ИсточникДанных.Колонки.Добавить("ЗначениеПараметраКлассификации");
		
	КонецЕсли;
	
	ИсточникДанных.ЗаполнитьЗначения(0, "ЗначениеПараметраКлассификации");
	
	ЗначениеПараметраКлассификацииИтог = 0;
	ДоляНарастающимИтогом = Новый Массив;
	ТекущаяДоляНарастающимИтогом = 0;
	
	ИндексСтрокиИсточникаДанных = 0;
	СмещениеСтрокиИсточникаДанных = 0;
	
	Пока ИндексСтрокиИсточникаДанных < ИсточникДанных.Количество() Цикл
		
		// Общий итог по разделителю.
		ЗначениеПараметраКлассификацииИтог = ЗначениеПараметраКлассификацииИтог + ИсточникДанных[ИндексСтрокиИсточникаДанных][ИмяПараметраКлассификации];
		ДоляНарастающимИтогом.Добавить(ИсточникДанных[ИндексСтрокиИсточникаДанных][ИмяПараметраКлассификации]);
		ИсточникДанных[ИндексСтрокиИсточникаДанных].ЗначениеПараметраКлассификации = ИсточникДанных[ИндексСтрокиИсточникаДанных][ИмяПараметраКлассификации];
		
		// Последняя строка или данные по текущему разделителю или разделу классификации закончились.
		Если ИндексСтрокиИсточникаДанных = ИсточникДанных.Количество() - 1
			ИЛИ ИсточникДанных[ИндексСтрокиИсточникаДанных].РазделительКлассификации <> ИсточникДанных[ИндексСтрокиИсточникаДанных + 1].РазделительКлассификации
			ИЛИ (ЕстьРазделКлассификации И ИсточникДанных[ИндексСтрокиИсточникаДанных].РазделКлассификации <> ИсточникДанных[ИндексСтрокиИсточникаДанных + 1].РазделКлассификации) Тогда
			
			ДоляНарастающимИтогомСумма = 0;
			
			Для Индекс = 0 По ДоляНарастающимИтогом.ВГраница() Цикл
				
				Если ЗначениеПараметраКлассификацииИтог <> 0 Тогда
					
					ТекущаяДоляНарастающимИтогом = ТекущаяДоляНарастающимИтогом + ДоляНарастающимИтогом[Индекс] * 100 / ЗначениеПараметраКлассификацииИтог;
					
				КонецЕсли;
				
				ДоляНарастающимИтогом[Индекс] = ТекущаяДоляНарастающимИтогом;
				ДоляНарастающимИтогомСумма = ДоляНарастающимИтогомСумма + ТекущаяДоляНарастающимИтогом;
				
			КонецЦикла;
			
			СреднееЗначение = ДоляНарастающимИтогомСумма / (ДоляНарастающимИтогом.Количество() + 1);
			
			ТекущийКласс = Перечисления.ABCКлассификация.AКласс;
			
			Для Индекс = 0 По ДоляНарастающимИтогом.ВГраница() - 1 Цикл
				
				Если ДоляНарастающимИтогом[Индекс] > СреднееЗначение Тогда
					
					Если ТекущийКласс = Перечисления.ABCКлассификация.AКласс Тогда
						
						ТекущийКласс = Перечисления.ABCКлассификация.BКласс;
						
					Иначе
						
						Прервать;
						
					КонецЕсли;
					
					СреднееЗначение = ДоляНарастающимИтогомСумма / (ДоляНарастающимИтогом.Количество() - Индекс);
					
				КонецЕсли;
				
				ДоляНарастающимИтогомСумма = ДоляНарастающимИтогомСумма - ДоляНарастающимИтогом[Индекс];
				ИсточникДанных[СмещениеСтрокиИсточникаДанных + Индекс].Класс = ТекущийКласс;
				
			КонецЦикла;
			
			ЗначениеПараметраКлассификацииИтог = 0;
			ДоляНарастающимИтогом = Новый Массив;
			ТекущаяДоляНарастающимИтогом = 0;
			
			СмещениеСтрокиИсточникаДанных = ИндексСтрокиИсточникаДанных + 1;
			
		КонецЕсли;
		
		ИндексСтрокиИсточникаДанных = ИндексСтрокиИсточникаДанных + 1;
		
	КонецЦикла;
	
КонецПроцедуры

// Выполняет классификацию объектов с использованием XYZ-анализа.
// Исходными данными для анализа является результат запроса,
// содержащий итоговые значения параметра классификации по анализируемым
// объектам и периодам.
// Результат анализа помещается в добавляемую колонку "XYZКласс".
//
// Параметры:
//  ИсточникДанных - результат запроса, содержащий ключевые поля объекта классификации,
//                   периода и поле "ЗначениеПараметраКлассификации", содержащей
//                   значения параметра, по которому производится
//                   классификация, для текущего объекта.
//  ИмяПараметраКлассификации - имя колонки в источнике данных, содержащей значение
//                              параметра классификации.
//  КлючиОбъектаКлассификации - строка, содержащая список имен полей, разделенный запятыми,
//                              идентифицирующих объект классификации. 
//
// Возвращаемое значение: 
//  Таблица значений, содержащая результат классификации.
//
Функция ВыполнитьXYZКлассификацию(ИсточникДанных, ИмяПараметраКлассификации, Знач КлючиОбъектаКлассификации) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	
	Для каждого Колонка Из ИсточникДанных.ИсточникДанных.Колонки Цикл
		
		Результат.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		
	КонецЦикла;
	
	Результат.Колонки.Добавить("Класс", Новый ОписаниеТипов("ПеречислениеСсылка.XYZКлассификация, ПеречислениеСсылка.ABCКлассификация"));
	Результат.Колонки.Добавить("ЗначениеПараметраКлассификации", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповЧисла(15, 2));
	
	Если ИсточникДанных.ИсточникДанных.Пустой() Тогда
		
		Возврат Результат;
		
	КонецЕсли;
	
	ОбъектыКлассификацииВыборка = Новый Массив(СтрЧислоСтрок(СтрЗаменить(КлючиОбъектаКлассификации, ",", Символы.ПС)));
	
	ИндексОбъектаКлассификации = 0;
	ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации] = ИсточникДанных.ИсточникДанных.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Истина Цикл
		
		Если ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации] = Неопределено Тогда
			
			// Формирование новой выборки.
			ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации] = ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации - 1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
		КонецЕсли;
		
		Если ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации].Следующий() Тогда
			
			Если ИндексОбъектаКлассификации = ОбъектыКлассификацииВыборка.ВГраница() Тогда // Последний уровень.
				
				НоваяСтрока = Результат.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации]);
				
				ВыборкаПериод = ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период", "Все");
				
				КоличествоПериодов = ВыборкаПериод.Количество();
				СреднееЗначение = ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации][ИмяПараметраКлассификации] / КоличествоПериодов;
				ЗначениеПараметраКлассификации = 0;
				
				Пока ВыборкаПериод.Следующий() Цикл
					
					ЗначениеПараметраКлассификации = ЗначениеПараметраКлассификации + Pow((?(ВыборкаПериод[ИмяПараметраКлассификации] = Null, 0, ВыборкаПериод[ИмяПараметраКлассификации]) - СреднееЗначение), 2);
					
				КонецЦикла;
				
				НоваяСтрока[ИмяПараметраКлассификации] = ?(СреднееЗначение <> 0, Sqrt(ЗначениеПараметраКлассификации / КоличествоПериодов) * 100 / СреднееЗначение, 0);
				НоваяСтрока.ЗначениеПараметраКлассификации = НоваяСтрока[ИмяПараметраКлассификации];
				
			Иначе
				
				// Перейти на следующий уровень.
				ИндексОбъектаКлассификации = ИндексОбъектаКлассификации + 1;
				
			КонецЕсли;
			
		Иначе
			
			// На верхнем уровне записи закончились.
			// Обработка завершена.
			Если ИндексОбъектаКлассификации = 0 Тогда
				
				Прервать;
				
			// На текущем уровне записи закончились.
			// Необходимо перейти к следующей записи на предыдущем уровне.
			Иначе
			
				ОбъектыКлассификацииВыборка[ИндексОбъектаКлассификации] = Неопределено;
				ИндексОбъектаКлассификации = ИндексОбъектаКлассификации - 1;
				Продолжить;
				
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЦикла;
	
	Результат.ЗаполнитьЗначения(Перечисления.XYZКлассификация.XКласс, "Класс");
	
	КолонкиСортировки = "РазделительКлассификации Возр";
	
	ЕстьРазделКлассификации = Ложь;
	
	Если Результат.Колонки.Найти("РазделКлассификации") <> Неопределено Тогда
		
		КолонкиСортировки = КолонкиСортировки + ", РазделКлассификации Возр";
		ЕстьРазделКлассификации = Истина;
		
	КонецЕсли;
	
	КолонкиСортировки = КолонкиСортировки + ", " + ИмяПараметраКлассификации + " Убыв";
	
	Если Результат.Колонки.Найти("Номенклатура") <> Неопределено Тогда
		
		КолонкиСортировки = КолонкиСортировки + ", Номенклатура Возр";
		
		Если Результат.Колонки.Найти("Характеристика") <> Неопределено Тогда
			
			КолонкиСортировки = КолонкиСортировки + ", Характеристика Возр";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Результат.Сортировать(КолонкиСортировки, Новый СравнениеЗначений);
	
	ЗначениеПараметраКлассификацииИтог = 0;
	ДоляНарастающимИтогом = Новый Массив;
	ТекущаяДоляНарастающимИтогом = 0;
	
	ИндексСтрокиРезультата = 0;
	СмещениеСтрокиРезультата = 0;
	
	Пока ИндексСтрокиРезультата < Результат.Количество() Цикл
		
		// Общий итог по разделителю.
		ЗначениеПараметраКлассификацииИтог = ЗначениеПараметраКлассификацииИтог + Результат[ИндексСтрокиРезультата][ИмяПараметраКлассификации];
		ДоляНарастающимИтогом.Добавить(Результат[ИндексСтрокиРезультата][ИмяПараметраКлассификации]);
		Результат[ИндексСтрокиРезультата].ЗначениеПараметраКлассификации = Результат[ИндексСтрокиРезультата][ИмяПараметраКлассификации];
		
		// Последняя строка или данные по текущему разделителю или разделу классификации закончились.
		Если ИндексСтрокиРезультата = Результат.Количество() - 1
			ИЛИ Результат[ИндексСтрокиРезультата].РазделительКлассификации <> Результат[ИндексСтрокиРезультата + 1].РазделительКлассификации
			ИЛИ (ЕстьРазделКлассификации И Результат[ИндексСтрокиРезультата].РазделКлассификации <> Результат[ИндексСтрокиРезультата + 1].РазделКлассификации) Тогда
			
			ДоляНарастающимИтогомСумма = 0;
			
			Для Индекс = 0 По ДоляНарастающимИтогом.ВГраница() Цикл
				
				Если ЗначениеПараметраКлассификацииИтог <> 0 Тогда
					
					ТекущаяДоляНарастающимИтогом = ТекущаяДоляНарастающимИтогом + ?(ЗначениеПараметраКлассификацииИтог = 0, 0, ДоляНарастающимИтогом[Индекс] * 100 / ЗначениеПараметраКлассификацииИтог);
					
				КонецЕсли;
				
				ДоляНарастающимИтогом[Индекс] = ТекущаяДоляНарастающимИтогом;
				ДоляНарастающимИтогомСумма = ДоляНарастающимИтогомСумма + ТекущаяДоляНарастающимИтогом;
				
			КонецЦикла;
			
			СреднееЗначение = ДоляНарастающимИтогомСумма / (ДоляНарастающимИтогом.Количество() + 1);
			
			ТекущийКласс = Перечисления.XYZКлассификация.ZКласс;
			
			Для Индекс = 0 По ДоляНарастающимИтогом.ВГраница() - 1 Цикл
				
				Если ДоляНарастающимИтогом[Индекс] > СреднееЗначение Тогда
					
					Если ТекущийКласс = Перечисления.XYZКлассификация.ZКласс Тогда
						
						ТекущийКласс = Перечисления.XYZКлассификация.YКласс;
						
					Иначе
						
						Прервать;
						
					КонецЕсли;
					
					СреднееЗначение = ДоляНарастающимИтогомСумма / (ДоляНарастающимИтогом.Количество() - Индекс);
					
				КонецЕсли;
				
				ДоляНарастающимИтогомСумма = ДоляНарастающимИтогомСумма - ДоляНарастающимИтогом[Индекс];
				Результат[СмещениеСтрокиРезультата + Индекс].Класс = ТекущийКласс;
				
			КонецЦикла;
			
			ЗначениеПараметраКлассификацииИтог = 0;
			ДоляНарастающимИтогом = Новый Массив;
			ТекущаяДоляНарастающимИтогом = 0;
			
			СмещениеСтрокиРезультата = ИндексСтрокиРезультата + 1;
			
		КонецЕсли;
		
		ИндексСтрокиРезультата = ИндексСтрокиРезультата + 1;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Выполняет проверку, является ли дата выходным днем календаря.
// Параметры:
//  ДатаКалендаря - проверяемая дата
//  Календарь - календарь, по которому выполняется проверка
//  ВыходныеДниКалендарей - полученные ранее данные о выходных днях календарей.
//
// Возвращаемое значение: 
// Булево
//  Дата является выходным днем календаря.
//
Функция ЭтоВыходнойДень(ДатаКалендаря, Календарь, ВыходныеДниКалендарей) Экспорт
	
	ГодКалендаря = Число(Формат(ДатаКалендаря, "ДФ=yyyy"));
	
	Если ВыходныеДниКалендарей.Получить(Календарь) = Неопределено Тогда
		
		ВыходныеДниКалендарей.Вставить(Календарь, Новый Соответствие);
		ВыходныеДниКалендарей[Календарь].Вставить(ГодКалендаря, ПолучитьВыходныеДниКалендарногоГрафика(Календарь, ГодКалендаря));
		
	ИначеЕсли ВыходныеДниКалендарей[Календарь].Получить(ГодКалендаря) = Неопределено Тогда
		
		ВыходныеДниКалендарей[Календарь].Вставить(ГодКалендаря, ПолучитьВыходныеДниКалендарногоГрафика(Календарь, ГодКалендаря));
		
	КонецЕсли;
	
	Возврат ВыходныеДниКалендарей[Календарь][ГодКалендаря].Найти(ДатаКалендаря) <> Неопределено;
	
КонецФункции

// Возвращает коэффициент уровня обслуживания по ссылке на значение перечисления
// Параметры:
//		УровеньОбслуживания - ПеречислениеСсылка.УровниОбслуживания
// Возвращаемое значение:
//		Число
Функция ПолучитьКоэффициентУровняОбслуживания(УровеньОбслуживания) Экспорт
	
	// Эти коэффициенты еще заданы в запросе динамического списка формы списка регистра ПрогнозыРасходаУпаковок.
	
	Если УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания50_0 Тогда

		Возврат 0;

	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания57_9 Тогда
		
		Возврат 0.2;
        	
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания65_5 Тогда

		Возврат 0.4;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания72_6 Тогда

		Возврат 0.6;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания78_8 Тогда

		Возврат 0.8;
  	
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания84_0 Тогда
		
		Возврат 1.0;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания88_5 Тогда
		
		Возврат 1.2;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания91_9 Тогда
		
		Возврат 1.4;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания94_5 Тогда
		
		Возврат 1.6;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания96_4 Тогда
		
		Возврат 1.8;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания97_7 Тогда
		
		Возврат 2.0;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания98_6 Тогда
		
		Возврат 2.2;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания99_2 Тогда
		
		Возврат 2.4;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания99_5 Тогда
		
		Возврат 2.6;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания99_7 Тогда
		
		Возврат 2.8;
		
	ИначеЕсли УровеньОбслуживания = Перечисления.УровниОбслуживания.УровеньОбслуживания99_9 Тогда
		
		Возврат 3.0;
		
	Иначе
		
		Возврат 1.0;
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВыходныеДниКалендарногоГрафика(Календарь, ГодКалендаря)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаКалендаря
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.Год = &ГодКалендаря
	|	И (НЕ КалендарныеГрафики.ДеньВключенВГрафик)");;
	
	Запрос.УстановитьПараметр("Календарь", Календарь);
	Запрос.УстановитьПараметр("ГодКалендаря", ГодКалендаря);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ДатаКалендаря");
	
КонецФункции

#КонецОбласти
