#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает сведения о нематериальном активе.
//
// Параметры:
//  НематериальныйАктив - СправочникСсылка.НематериальныеАктивы	 - Нематериальный актив для которого нужно получить сведения.
//  Период			 - Дата - На какую дату нужно получить сведения.
// 
// Возвращаемое значение:
//  Структура - Содержит сведения о нематериальном активе.
//
Функция ПервоначальныеСведения(НематериальныйАктив, Период = '000101010000') Экспорт
	
	ПервоначальныеСведения = НематериальныеАктивыЛокализация.ПервоначальныеСведения(НематериальныйАктив, Период);
	
	Если ПервоначальныеСведения = Неопределено Тогда
		
		ПервоначальныеСведения = Новый Структура;
		ПервоначальныеСведения.Вставить("Организация", Неопределено);
		ПервоначальныеСведения.Вставить("ДатаПринятияКУчетуУУ", '000101010000');
		ПервоначальныеСведения.Вставить("ДатаПринятияКУчетуБУ", '000101010000');
		ПервоначальныеСведения.Вставить("ДокументПринятияКУчетуУУ", Неопределено);
		ПервоначальныеСведения.Вставить("ДокументПринятияКУчетуБУ", Неопределено);
		ПервоначальныеСведения.Вставить("СостояниеУУ", Перечисления.ВидыСостоянийНМА.НеПринятКУчету);
		ПервоначальныеСведения.Вставить("СостояниеБУ", Перечисления.ВидыСостоянийНМА.НеПринятКУчету);
		
		Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА)
			ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМАУУ) Тогда
			
			Возврат ПервоначальныеСведения;
		КонецЕсли; 
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ПервоначальныеСведения.Организация,
		|	ПервоначальныеСведения.ДатаПринятияКУчетуУУ,
		|	ПервоначальныеСведения.ДокументПринятияКУчетуУУ,
		|	ЕСТЬNULL(ПорядокУчетаУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) КАК СостояниеУУ
		|ИЗ
		|	РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(&Период, НематериальныйАктив = &Ссылка) КАК ПервоначальныеСведения
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(&Период, НематериальныйАктив = &Ссылка) КАК ПорядокУчетаУУ
		|		ПО ПервоначальныеСведения.НематериальныйАктив = ПорядокУчетаУУ.НематериальныйАктив
		|			И ПервоначальныеСведения.Организация = ПорядокУчетаУУ.Организация";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", НематериальныйАктив);
		Запрос.УстановитьПараметр("Период", Период);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат ПервоначальныеСведения;
		КонецЕсли;
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		ЗаполнитьЗначенияСвойств(ПервоначальныеСведения, Выборка);
	
	КонецЕсли; 
	
	Возврат ПервоначальныеСведения;

КонецФункции

// Формирует сведения об учете нематериального актива
//
// Параметры:
//  НематериальныйАктив - СправочникСсылка.НематериальныеАктивы - Нематериальный актив для которого нужно получить сведения.
// 
// Возвращаемое значение:
//  Структура - Содержит свойства ОбщиеСведения,МестоУчета.
//
Функция СведенияОбУчете(НематериальныйАктив) Экспорт

	СведенияОбУчете = НематериальныеАктивыЛокализация.СведенияОбУчете(НематериальныйАктив);
	
	Если СведенияОбУчете = Неопределено Тогда
		
		Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.МестоУчетаНМА)
			ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА)
			ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМА)
			ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМАУУ)
			ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПараметрыАмортизацииНМАУУ) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаПринятияКУчетуБУ,
		|	ЕСТЬNULL(ПервоначальныеСведения.ДатаПринятияКУчетуУУ, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПринятияКУчетуУУ,
		|	НЕОПРЕДЕЛЕНО КАК ДокументПринятияКУчетуБУ,
		|	ЕСТЬNULL(ПервоначальныеСведения.ДокументПринятияКУчетуУУ, НЕОПРЕДЕЛЕНО) КАК ДокументПринятияКУчетуУУ,
		|	ЕСТЬNULL(ПервоначальныеСведения.ДокументСписания, НЕОПРЕДЕЛЕНО) КАК ДокументСписания,
		|	ЕСТЬNULL(ПервоначальныеСведения.ДокументСписания.Дата, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаСнятияСУчета,
		|	0 КАК ПервоначальнаяСтоимостьБУ,
		|	0 КАК ПервоначальнаяСтоимостьНУ,
		|	ЕСТЬNULL(ПорядокУчетаНМА.ГруппаФинансовогоУчета, НЕОПРЕДЕЛЕНО) КАК ГруппаФинансовогоУчета,
		|	ЕСТЬNULL(ПорядокУчетаНМА.ГруппаФинансовогоУчета.Представление, """") КАК ГруппаФинансовогоУчетаПредставление,
		|	ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету) КАК СостояниеБУ,
		|	ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) КАК СостояниеУУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.СрокИспользования, 0) КАК СрокИспользованияУУ,
		|	ЕСТЬNULL(ПараметрыАмортизацииНМАУУ.ЛиквидационнаяСтоимость, 0) КАК ЛиквидационнаяСтоимость,
		|	0 КАК СрокИспользованияБУ,
		|	0 КАК СрокИспользованияНУ,
		|	МестоУчетаНМА.Период КАК ПериодСведенийОМестеУчета,
		|	МестоУчетаНМА.Организация КАК Организация,
		|	ЕСТЬNULL(МестоУчетаНМА.Организация.Представление, """") КАК ОрганизацияПредставление,
		|	МестоУчетаНМА.Подразделение КАК Подразделение,
		|	МестоУчетаНМА.НематериальныйАктив.ВидОбъектаУчета КАК ВидОбъектаУчета,
		|	ЕСТЬNULL(МестоУчетаНМА.Подразделение.Представление, """") КАК ПодразделениеПредставление
		|ИЗ
		|	РегистрСведений.МестоУчетаНМА.СрезПоследних(, НематериальныйАктив = &Ссылка) КАК МестоУчетаНМА
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(, НематериальныйАктив = &Ссылка) КАК ПервоначальныеСведения
		|		ПО (ПервоначальныеСведения.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив)
		|			И (ПервоначальныеСведения.Организация = МестоУчетаНМА.Организация)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМА.СрезПоследних(, НематериальныйАктив = &Ссылка) КАК ПорядокУчетаНМА
		|		ПО (ПорядокУчетаНМА.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(, НематериальныйАктив = &Ссылка) КАК ПорядокУчетаНМАУУ
		|		ПО (ПорядокУчетаНМАУУ.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив)
		|			И (ПорядокУчетаНМАУУ.Организация = МестоУчетаНМА.Организация)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыАмортизацииНМАУУ.СрезПоследних(, НематериальныйАктив = &Ссылка) КАК ПараметрыАмортизацииНМАУУ
		|		ПО (ПараметрыАмортизацииНМАУУ.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив)
		|			И (ПараметрыАмортизацииНМАУУ.Организация = МестоУчетаНМА.Организация)";

		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("Ссылка", НематериальныйАктив);
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		СведенияОбУчете = Новый Структура;
		Для каждого КолонкаЗапроса Из Результат.Колонки Цикл
			СведенияОбУчете.Вставить(КолонкаЗапроса.Имя);
		КонецЦикла; 
		
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(СведенияОбУчете, Выборка);
		
	КонецЕсли; 
	
	Возврат СведенияОбУчете;

КонецФункции

#Область ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Команда = Документы.ПринятиеКУчетуНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	Команда = Документы.ИзменениеПараметровНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	Команда = Документы.ПеремещениеНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	Команда = Документы.ПереоценкаНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
		ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды(Команда, "ВидОбъектаУчета", Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив);
	КонецЕсли;
	
	Команда = Документы.ПодготовкаКПередачеНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	Команда = Документы.СписаниеНМА2_4.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
		Команда.РежимЗаписи = "";
	КонецЕсли;
	
	НематериальныеАктивыЛокализация.ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры);
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Команда = Отчеты.СправкаРасчетАмортизацииНМА2_4.ДобавитьКомандуОтчетаПоНМА(КомандыОтчетов);
	Если Команда <> Неопределено Тогда
		Команда.ВидимостьВФормах = "ФормаЭлемента, ФормаСпискаСоСведениями";
	КонецЕсли;
	
	НематериальныеАктивыЛокализация.ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры);
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	НематериальныеАктивыЛокализация.ДобавитьКомандыПечати(КомандыПечати);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
// Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" И ВнеоборотныеАктивыВызовСервера.ДоступенВыборНематериальныхАктивов2_4(Параметры) Тогда
		
		// В концепции 2.4 своя форма выбора
		ВыбраннаяФорма = "ФормаВыбора2_4";
		СтандартнаяОбработка = Ложь;
		Возврат;

	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ДанныеВыбора = ВнеоборотныеАктивыВызовСервера.ДанныеВыбораНематериальныхАктивов(Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ЕстьПраваНаЧтениеСведений() Экспорт

	Если НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4()
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.МестоУчетаНМА)
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА)
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМАУУ)
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.СтоимостьНМА)
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.АмортизацияНМА)
		ИЛИ НЕ НематериальныеАктивыЛокализация.ЕстьПраваНаЧтениеСведений() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПредставлениеСведенийОбУчете(СведенияОбУчете, СтоимостьИАмортизация, ВключитьНезаполненные = Истина) Экспорт

	ВалютаРегл = Константы.ВалютаРегламентированногоУчета.Получить();
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	
	ДоступенВыборОтраженияВУчетах = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	СведенияПринятКУчету1 = Новый Массив;
	СведенияПринятКУчету2 = Новый Массив;
	СведенияСрокИспользования1 = Новый Массив;
	СведенияСрокИспользования2 = Новый Массив;
	СведенияСрокИспользования3 = Новый Массив;
	СведенияЛиквидационнаяСтоимость = Новый Массив;
	СведенияСнятСУчета = Новый Массив;
	СведенияГФУ = Новый Массив;
	
	СведенияВосстановительнаяСтоимость = Новый Массив;
	СведенияНакопленнаяАмортизация = Новый Массив;
	СведенияОстаточнаяСтоимость = Новый Массив;
	
	СведенияМестоУчетаОрганизация = Новый Массив;
	СведенияМестоУчетаПодразделение = Новый Массив;
	Период = '000101010000';
	
	#Область ОбщиеСведения
	
	Если СведенияОбУчете <> Неопределено Тогда
		
		Если СведенияОбУчете.СостояниеУУ = Перечисления.ВидыСостоянийНМА.ПринятКУчету
			ИЛИ СведенияОбУчете.СостояниеБУ = Перечисления.ВидыСостоянийНМА.ПринятКУчету
			ИЛИ СведенияОбУчете.СостояниеУУ = Перечисления.ВидыСостоянийНМА.Списан
			ИЛИ СведенияОбУчете.СостояниеБУ = Перечисления.ВидыСостоянийНМА.Списан Тогда
		
			Если ЗначениеЗаполнено(СведенияОбУчете.ДатаПринятияКУчетуУУ) 
					И ЗначениеЗаполнено(СведенияОбУчете.ДатаПринятияКУчетуБУ)
					И СведенияОбУчете.ДатаПринятияКУчетуУУ = СведенияОбУчете.ДатаПринятияКУчетуБУ
				ИЛИ ЗначениеЗаполнено(СведенияОбУчете.ДатаПринятияКУчетуУУ) 
					И НЕ ДоступенВыборОтраженияВУчетах Тогда
				
				СведенияПринятКУчету1.Добавить(НСтр("ru = 'Дата принятия к учету:'"));
				СведенияПринятКУчету1.Добавить(" ");
				ДатаДокумента = Формат(СведенияОбУчете.ДатаПринятияКУчетуУУ, "ДЛФ=D");
				Если ЗначениеЗаполнено(СведенияОбУчете.ДокументПринятияКУчетуУУ) Тогда
					СсылкаНаОбъект = ПолучитьНавигационнуюСсылку(СведенияОбУчете.ДокументПринятияКУчетуУУ);
				Иначе
					СсылкаНаОбъект = Неопределено;
				КонецЕсли;
				СведенияПринятКУчету1.Добавить(Новый ФорматированнаяСтрока(ДатаДокумента,,,, СсылкаНаОбъект));
				
			Иначе
				
				Если ДоступенВыборОтраженияВУчетах Тогда
					СведенияПринятКУчету1.Добавить(НСтр("ru = 'Дата принятия в регл. учете:'"));
					СведенияПринятКУчету1.Добавить(" ");
					Если ЗначениеЗаполнено(СведенияОбУчете.ДатаПринятияКУчетуБУ) Тогда
						ДатаДокумента = Формат(СведенияОбУчете.ДатаПринятияКУчетуБУ, "ДЛФ=D");
						Если ЗначениеЗаполнено(СведенияОбУчете.ДокументПринятияКУчетуБУ) Тогда
							СсылкаНаОбъект = ПолучитьНавигационнуюСсылку(СведенияОбУчете.ДокументПринятияКУчетуБУ);
						Иначе
							СсылкаНаОбъект = Неопределено;
						КонецЕсли;
						СведенияПринятКУчету1.Добавить(Новый ФорматированнаяСтрока(ДатаДокумента,,,, СсылкаНаОбъект));
					Иначе	
						СведенияПринятКУчету1.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'принять к учету'"),,,, "#Создать"));
					КонецЕсли; 
				КонецЕсли;
				
				СведенияПринятКУчету2.Добавить(НСтр("ru = 'Дата принятия в упр. учете:'"));
				СведенияПринятКУчету2.Добавить(" ");
				Если ЗначениеЗаполнено(СведенияОбУчете.ДатаПринятияКУчетуУУ) Тогда
					ДатаДокумента = Формат(СведенияОбУчете.ДатаПринятияКУчетуУУ, "ДЛФ=D");
					Если ЗначениеЗаполнено(СведенияОбУчете.ДокументПринятияКУчетуУУ) Тогда
						СсылкаНаОбъект = ПолучитьНавигационнуюСсылку(СведенияОбУчете.ДокументПринятияКУчетуУУ);
					Иначе
						СсылкаНаОбъект = Неопределено;
					КонецЕсли;
					СведенияПринятКУчету2.Добавить(Новый ФорматированнаяСтрока(ДатаДокумента,,,, СсылкаНаОбъект));
				Иначе
					СведенияПринятКУчету2.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'принять к учету'"),,,, "#Создать"));
				КонецЕсли; 
				
			КонецЕсли;
			
			Если СведенияОбУчете.ЛиквидационнаяСтоимость <> 0 Тогда
				СведенияСтрокой = СтрШаблон(НСтр("ru = 'Ликвидационная стоимость: %1 %2'"), 
											Строка(СведенияОбУчете.ЛиквидационнаяСтоимость),
											Строка(Константы.ВалютаУправленческогоУчета.Получить()));
				СведенияЛиквидационнаяСтоимость.Добавить(СведенияСтрокой);
			КонецЕсли; 
			
			СрокИспользованияУУ = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СведенияОбУчете.СрокИспользованияУУ, Ложь);
			СрокИспользованияБУ = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СведенияОбУчете.СрокИспользованияБУ, Ложь);
			СрокИспользованияНУ = ВнеоборотныеАктивыКлиентСервер.РасшифровкаСрокаПолезногоИспользования(СведенияОбУчете.СрокИспользованияНУ, Ложь);
			
			Если СведенияОбУчете.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
				ШаблонСрок = НСтр("ru = 'Срок списания: %1'");
			Иначе
				ШаблонСрок = НСтр("ru = 'Срок использования: %1'");
			КонецЕсли; 
			
			Если СведенияОбУчете.СрокИспользованияБУ = СведенияОбУчете.СрокИспользованияНУ
					И СведенияОбУчете.СрокИспользованияБУ = СведенияОбУчете.СрокИспользованияУУ 
					И СведенияОбУчете.СрокИспользованияУУ <> 0
				ИЛИ СведенияОбУчете.СрокИспользованияУУ <> 0
					И СведенияОбУчете.СрокИспользованияБУ = 0
					И СведенияОбУчете.СрокИспользованияБУ = 0 Тогда
				
				СведенияСрокИспользования1.Добавить(СтрШаблон(ШаблонСрок, СрокИспользованияУУ));
				
			ИначеЕсли СведенияОбУчете.СрокИспользованияБУ <> 0
				И СведенияОбУчете.СрокИспользованияУУ = 0
				И (СведенияОбУчете.СрокИспользованияНУ = 0
					ИЛИ СведенияОбУчете.СрокИспользованияНУ = СведенияОбУчете.СрокИспользованияБУ) Тогда
					
				СведенияСрокИспользования1.Добавить(СтрШаблон(ШаблонСрок, СрокИспользованияБУ));
				
			ИначеЕсли СведенияОбУчете.СрокИспользованияНУ <> 0
				И СведенияОбУчете.СрокИспользованияУУ = 0
				И (СведенияОбУчете.СрокИспользованияБУ = 0
					ИЛИ СведенияОбУчете.СрокИспользованияБУ = СведенияОбУчете.СрокИспользованияНУ) Тогда				
					
				СведенияСрокИспользования1.Добавить(СтрШаблон(ШаблонСрок, СрокИспользованияНУ));
				
			Иначе
				
				Если СведенияОбУчете.СрокИспользованияБУ <> 0 Тогда
					Если СведенияОбУчете.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
						СведенияСрокИспользования1.Добавить(СтрШаблон(НСтр("ru = 'Срок списания (БУ):  %1'"), СрокИспользованияБУ));
					Иначе
						СведенияСрокИспользования1.Добавить(СтрШаблон(НСтр("ru = 'Срок использования (БУ):  %1'"), СрокИспользованияБУ));
					КонецЕсли;
				КонецЕсли;
				Если СведенияОбУчете.СрокИспользованияНУ <> 0 Тогда
					Если СведенияОбУчете.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
						СведенияСрокИспользования2.Добавить(СтрШаблон(НСтр("ru = 'Срок списания (НУ):  %1'"), СрокИспользованияНУ));
					Иначе
						СведенияСрокИспользования2.Добавить(СтрШаблон(НСтр("ru = 'Срок использования (НУ):  %1'"), СрокИспользованияНУ));
					КонецЕсли;
				КонецЕсли;
				Если СведенияОбУчете.СрокИспользованияУУ <> 0 Тогда
					Если СведенияОбУчете.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
						СведенияСрокИспользования3.Добавить(СтрШаблон(НСтр("ru = 'Срок списания (УУ):  %1'"), СрокИспользованияУУ));
					Иначе
						СведенияСрокИспользования3.Добавить(СтрШаблон(НСтр("ru = 'Срок использования (УУ):  %1'"), СрокИспользованияУУ));
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
				
			//
			Если СведенияОбУчете.СостояниеУУ = Перечисления.ВидыСостоянийНМА.Списан
				ИЛИ СведенияОбУчете.СостояниеБУ = Перечисления.ВидыСостоянийНМА.Списан Тогда
				СведенияСнятСУчета.Добавить(НСтр("ru = 'Дата списания:'"));
				СведенияСнятСУчета.Добавить(" ");
				ДатаДокумента = Формат(СведенияОбУчете.ДатаСнятияСУчета, "ДЛФ=D");
				Если ЗначениеЗаполнено(СведенияОбУчете.ДокументСписания) Тогда
					СсылкаНаОбъект = ПолучитьНавигационнуюСсылку(СведенияОбУчете.ДокументСписания);
				Иначе
					СсылкаНаОбъект = Неопределено;
				КонецЕсли;
				СведенияСнятСУчета.Добавить(Новый ФорматированнаяСтрока(ДатаДокумента,,,, СсылкаНаОбъект));
			КонецЕсли; 
			
			СведенияГФУ.Добавить(НСтр("ru = 'Группа финансового учета:'"));
			СведенияГФУ.Добавить(" ");
			Если ЗначениеЗаполнено(СведенияОбУчете.ГруппаФинансовогоУчета) Тогда
				СсылкаНаОбъект = ПолучитьНавигационнуюСсылку(СведенияОбУчете.ГруппаФинансовогоУчета);
			Иначе
				СсылкаНаОбъект = Неопределено;
			КонецЕсли;
			СведенияГФУ.Добавить(Новый ФорматированнаяСтрока(СведенияОбУчете.ГруппаФинансовогоУчетаПредставление,,,, СсылкаНаОбъект));
		
		КонецЕсли; 
		
	Иначе
		СведенияПринятКУчету1.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Принять к учету'"),,,, "#Создать"));
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Местонахождение
	
	Если СведенияОбУчете <> Неопределено Тогда
		
		Период = СведенияОбУчете.ПериодСведенийОМестеУчета; 
		
		СведенияМестоУчетаОрганизация.Добавить(СтрШаблон(НСтр("ru = 'Организация: %1'"), СведенияОбУчете.ОрганизацияПредставление));
		СведенияМестоУчетаПодразделение.Добавить(СтрШаблон(НСтр("ru = 'Подразделение: %1'"), СведенияОбУчете.ПодразделениеПредставление));
		
	КонецЕсли; 
	
	#КонецОбласти
	
	#Область Суммы
	
	Если НЕ ДоступенВыборОтраженияВУчетах 
		И ВалютаРегл = ВалютаУпр
		И СведенияОбУчете <> Неопределено Тогда
		
		Если СведенияОбУчете.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
			
			ПредставлениеСуммы = ВнеоборотныеАктивыСлужебный.ПредставлениеСуммы(
				СтоимостьИАмортизация.Стоимость, НСтр("ru = 'Первоначальная стоимость:'"), ВалютаУпр);
			СведенияВосстановительнаяСтоимость.Добавить(ПредставлениеСуммы);
			
			ПредставлениеСуммы = ВнеоборотныеАктивыСлужебный.ПредставлениеСуммы(
				СтоимостьИАмортизация.Амортизация, НСтр("ru = 'Погашенная стоимость:'"), ВалютаУпр);
			СведенияНакопленнаяАмортизация.Добавить(ПредставлениеСуммы);
		
		Иначе
			
			ПредставлениеСуммы = ВнеоборотныеАктивыСлужебный.ПредставлениеСуммы(
				СтоимостьИАмортизация.Стоимость, НСтр("ru = 'Восстановительная стоимость:'"), ВалютаУпр);
			СведенияВосстановительнаяСтоимость.Добавить(ПредставлениеСуммы);
			
			ПредставлениеСуммы = ВнеоборотныеАктивыСлужебный.ПредставлениеСуммы(
				СтоимостьИАмортизация.Амортизация, НСтр("ru = 'Накопленная амортизация:'"), ВалютаУпр);
			СведенияНакопленнаяАмортизация.Добавить(ПредставлениеСуммы);
			
			ПредставлениеСуммы = ВнеоборотныеАктивыСлужебный.ПредставлениеСуммы(
				СтоимостьИАмортизация.Стоимость - СтоимостьИАмортизация.Амортизация, НСтр("ru = 'Остаточная стоимость:'"), ВалютаУпр);
			СведенияОстаточнаяСтоимость.Добавить(ПредставлениеСуммы);
			
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	ПредставлениеСведений = Новый Структура;
	ПредставлениеСведений.Вставить("Период", Период);
	ПредставлениеСведений.Вставить("СведенияПринятКУчету1", СведенияПринятКУчету1);
	ПредставлениеСведений.Вставить("СведенияПринятКУчету2", СведенияПринятКУчету2);
	ПредставлениеСведений.Вставить("СведенияСрокИспользования1", СведенияСрокИспользования1);
	ПредставлениеСведений.Вставить("СведенияСрокИспользования2", СведенияСрокИспользования2);
	ПредставлениеСведений.Вставить("СведенияСрокИспользования3", СведенияСрокИспользования3);
	ПредставлениеСведений.Вставить("СведенияЛиквидационнаяСтоимость", СведенияЛиквидационнаяСтоимость);
	ПредставлениеСведений.Вставить("СведенияСнятСУчета", СведенияСнятСУчета);
	ПредставлениеСведений.Вставить("СведенияГФУ", СведенияГФУ);
	ПредставлениеСведений.Вставить("СведенияМестоУчетаОрганизация", СведенияМестоУчетаОрганизация);
	ПредставлениеСведений.Вставить("СведенияМестоУчетаПодразделение", СведенияМестоУчетаПодразделение);
	ПредставлениеСведений.Вставить("СведенияВосстановительнаяСтоимость", СведенияВосстановительнаяСтоимость);
	ПредставлениеСведений.Вставить("СведенияНакопленнаяАмортизация", СведенияНакопленнаяАмортизация);
	ПредставлениеСведений.Вставить("СведенияОстаточнаяСтоимость", СведенияОстаточнаяСтоимость);
	
	Возврат ПредставлениеСведений;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	НематериальныеАктивыЛокализация.Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры
	
#КонецОбласти

#Область Прочее

Функция ОписаниеЗапросаДляВыбора(Параметры, УстановитьВсеОтборы = Ложь) Экспорт

	ОписаниеЗапросаДляВыбора = НематериальныеАктивыЛокализация.ОписаниеЗапросаДляВыбора(Параметры, УстановитьВсеОтборы);
	
	Если ОписаниеЗапросаДляВыбора = Неопределено Тогда
		
		ДоступныеКонтексты = Новый Структура("УУ"); // По умолчанию доступны все контексты.
		Если Параметры.Свойство("Контекст") Тогда
			ДоступныеКонтексты = Новый Структура(Параметры.Контекст);
		КонецЕсли;
		
		ОтборСписка = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Отбор", Новый Структура);
		
		Если ОтборСписка.Свойство("ОтражатьВУпрУчете")
			И НЕ ОтборСписка.ОтражатьВУпрУчете
			И ДоступныеКонтексты.Свойство("УУ") Тогда
			ДоступныеКонтексты.Удалить("УУ"); // Доступен выбор отражения в учете и в упр. учете нет отражения.
		КонецЕсли; 
		
		Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.МестоУчетаНМА) Тогда
			ОтборСписка.Удалить("Подразделение");
			ОтборСписка.Удалить("Организация");
		КонецЕсли;
		
		ДополнительныеПоля = "";
		ТекстСоединения = "";
		ТекстОтборы = "";
		ПараметрыЗапроса = Новый Структура;
		ДоступныеПоля = Новый Массив;
		
		Если ДоступныеКонтексты.Свойство("УУ")
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.МестоУчетаНМА)
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМА) Тогда
			
			ПолеОрганизация = "ЕСТЬNULL(МестоУчетаНМА.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))";
			ПолеПодразделение = "ЕСТЬNULL(МестоУчетаНМА.Подразделение, ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))";
			ПолеГФУ = "ЕСТЬNULL(ПорядокУчетаНМА.ГруппаФинансовогоУчета, ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ПустаяСсылка))";
			
			ТекстСоединения = ТекстСоединения + "
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестоУчетаНМА.СрезПоследних(//ПАРАМЕТРЫ_СРЕЗАПОСЛЕДНИХ//) КАК МестоУчетаНМА
			|		ПО СправочникНематериальныеАктивы.Ссылка = МестоУчетаНМА.НематериальныйАктив
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМА.СрезПоследних(//ПАРАМЕТРЫ_СРЕЗАПОСЛЕДНИХ//) КАК ПорядокУчетаНМА
			|		ПО СправочникНематериальныеАктивы.Ссылка = ПорядокУчетаНМА.НематериальныйАктив
			|			И ПорядокУчетаНМА.Организация = МестоУчетаНМА.Организация";
			
		Иначе
			
			ПолеОрганизация = "ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
			ПолеПодразделение = "ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)";
			ПолеГФУ = "ЗНАЧЕНИЕ(Справочник.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ПустаяСсылка)";
			
		КонецЕсли; 
		
		Если (ДоступныеКонтексты.Свойство("БУ") ИЛИ ДоступныеКонтексты.Свойство("УУ"))
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПервоначальныеСведенияНМА)
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.МестоУчетаНМА)
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМА) Тогда
			
			ПолеДатаПринятияКУчетуРегл = "ДАТАВРЕМЯ(1, 1, 1)";
			ПолеДатаПринятияКУчетуУпр = "ЕСТЬNULL(ПервоначальныеСведенияНМА.ДатаПринятияКУчетуУУ, ДАТАВРЕМЯ(1, 1, 1))";
			
			ТекстСоединения = ТекстСоединения + "
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияНМА.СрезПоследних(//ПАРАМЕТРЫ_СРЕЗАПОСЛЕДНИХ//) КАК ПервоначальныеСведенияНМА
			|		ПО ПервоначальныеСведенияНМА.Организация = МестоУчетаНМА.Организация
			|			И ПервоначальныеСведенияНМА.НематериальныйАктив = МестоУчетаНМА.НематериальныйАктив";
			
		Иначе
			ПолеДатаПринятияКУчетуРегл = "ДАТАВРЕМЯ(1, 1, 1)";
			ПолеДатаПринятияКУчетуУпр = "ДАТАВРЕМЯ(1, 1, 1)";
		КонецЕсли;
		
		ДополнительныеПоля = ДополнительныеПоля + "
			|,%1 КАК Организация
			|,%2 КАК Подразделение
			|,%3 КАК ГруппаФинансовогоУчета
			|,%4 КАК ДатаПринятияКУчетуРегл
			|,%5 КАК ДатаПринятияКУчетуУпр";
		
		ДополнительныеПоля = СтрШаблон(
			ДополнительныеПоля, 
			ПолеОрганизация, 
			ПолеПодразделение, 
			ПолеГФУ,
			ПолеДатаПринятияКУчетуРегл,
			ПолеДатаПринятияКУчетуУпр);
			
		Если ДоступныеКонтексты.Свойство("УУ")
			И ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМАУУ) Тогда
			
			ДополнительныеПоля = ДополнительныеПоля + "
				|,ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) КАК СостояниеУУ";
			
			ТекстСоединения = ТекстСоединения + "
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПорядокУчетаНМАУУ.СрезПоследних(//ПАРАМЕТРЫ_СРЕЗАПОСЛЕДНИХ//) КАК ПорядокУчетаНМАУУ
			|		ПО СправочникНематериальныеАктивы.Ссылка = ПорядокУчетаНМАУУ.НематериальныйАктив
			|			И ПорядокУчетаНМАУУ.Организация = МестоУчетаНМА.Организация";
			
		Иначе
			
			ДополнительныеПоля = ДополнительныеПоля + ",ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету) КАК СостояниеУУ";
			
		КонецЕсли;
		
		ПараметрыСрезаПоследних = "";
		Если Параметры.Свойство("ДатаСведений") Тогда
			ПараметрыСрезаПоследних = "&ДатаСведений";
			ПараметрыЗапроса.Вставить("ДатаСведений", КонецДня(Параметры.ДатаСведений));
		КонецЕсли; 
		Если Параметры.Свойство("ТекущийРегистратор") Тогда
			ПараметрыСрезаПоследних = ПараметрыСрезаПоследних 
				+ ?(ПараметрыСрезаПоследних <> "", ", ", "") 
				+ "Регистратор <> &ТекущийРегистратор";
			ПараметрыЗапроса.Вставить("ТекущийРегистратор", Параметры.ТекущийРегистратор);
		КонецЕсли; 
		ТекстСоединения = СтрЗаменить(ТекстСоединения, "//ПАРАМЕТРЫ_СРЕЗАПОСЛЕДНИХ//", ПараметрыСрезаПоследних);
		
		ДоступенВыборУчета = ОтборСписка.Свойство("ОтражатьВРеглУчете") ИЛИ ОтборСписка.Свойство("ОтражатьВУпрУчете");
		
		Если ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПорядокУчетаНМАУУ) Тогда
		
			Если ОтборСписка.Свойство("Состояние") Тогда
				Если ДоступныеКонтексты.Свойство("УУ") Тогда
					ТекстОтборы = "
					|	ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) В(&Состояние)";
				КонецЕсли;
				Если ТипЗнч(ОтборСписка.Состояние) = Тип("ФиксированныйМассив") Тогда
					ПараметрыЗапроса.Вставить("Состояние", Новый Массив(ОтборСписка.Состояние));
				Иначе
					ПараметрыЗапроса.Вставить("Состояние", ОтборСписка.Состояние);
				КонецЕсли;
				Параметры.Отбор.Удалить("Состояние");
			Иначе
				Если ДоступныеКонтексты.Свойство("УУ") Тогда
					ТекстОтборы = "
					|	(ЕСТЬNULL(ПорядокУчетаНМАУУ.Состояние, ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.НеПринятКУчету)) = &Состояние
					|		ИЛИ &Состояние = ЗНАЧЕНИЕ(Перечисление.ВидыСостоянийНМА.ПустаяСсылка))";
				КонецЕсли;
				Если ТекстОтборы <> "" Тогда
					ПараметрыЗапроса.Вставить("Состояние", Перечисления.ВидыСостоянийНМА.ПустаяСсылка());
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если УстановитьВсеОтборы Тогда
			
			Для каждого КлючИЗначение Из ОтборСписка Цикл
				
				Если НЕ ЗначениеЗаполнено(КлючИЗначение.Значение) Тогда
					Продолжить;
				КонецЕсли;
				
				Если КлючИЗначение.Ключ = "Организация" Тогда
					ПутьКПолю = ПолеОрганизация;
				ИначеЕсли КлючИЗначение.Ключ = "Подразделение" Тогда
					ПутьКПолю = ПолеПодразделение;
				ИначеЕсли КлючИЗначение.Ключ = "ВидОбъектаУчета"
					ИЛИ КлючИЗначение.Ключ = "НаправлениеДеятельности" Тогда
					
					ПутьКПолю = "СправочникНематериальныеАктивы." + КлючИЗначение.Ключ;
				Иначе
					Продолжить;
				КонецЕсли;
				
				ЭтоМассив = ТипЗнч(КлючИЗначение.Значение) = Тип("ФиксированныйМассив") 
							ИЛИ ТипЗнч(КлючИЗначение.Значение) = Тип("Массив");
							
				ТекстОтборы = ТекстОтборы 
								+ Символы.ПС 
								+ ?(ТекстОтборы <> "", "И ","")
								+ ПутьКПолю 
								+ ?(ЭтоМассив, " В (&" + КлючИЗначение.Ключ + ")", " = &" + КлючИЗначение.Ключ);
								
				ПараметрыЗапроса.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла; 
			
		КонецЕсли; 
		
		ТекстПервые = "";
		Если Параметры.Свойство("СтрокаПоиска") Тогда
			ТекстОтборы = ТекстОтборы + "
			|" + ?(ТекстОтборы <> "", "И ","")
			+ "СправочникНематериальныеАктивы.Наименование ПОДОБНО &СтрокаПоиска
				|	И НЕ СправочникНематериальныеАктивы.ЭтоГруппа
				|	И НЕ СправочникНематериальныеАктивы.ПометкаУдаления";
			ТекстПервые = "РАЗРЕШЕННЫЕ ПЕРВЫЕ 10";
			ПараметрыЗапроса.Вставить("СтрокаПоиска", "%" + Параметры.СтрокаПоиска + "%");
		КонецЕсли;
		
		Если ТекстОтборы <> "" Тогда
			ТекстОтборы = "
			|ГДЕ
			|" + ТекстОтборы;
		КонецЕсли;
		
		ТекстЗапроса =
		"ВЫБРАТЬ //ПЕРВЫЕ//
		|	СправочникНематериальныеАктивы.Ссылка,
		|	СправочникНематериальныеАктивы.ПометкаУдаления,
		|	СправочникНематериальныеАктивы.Родитель,
		|	СправочникНематериальныеАктивы.ЭтоГруппа,
		|	СправочникНематериальныеАктивы.Код,
		|	СправочникНематериальныеАктивы.Наименование,
		|	СправочникНематериальныеАктивы.НаименованиеПолное,
		|	СправочникНематериальныеАктивы.ВидНМА,
		|	СправочникНематериальныеАктивы.ПрочиеСведения,
		|	СправочникНематериальныеАктивы.ВидОбъектаУчета,
		|	СправочникНематериальныеАктивы.НаправлениеДеятельности
		|	//ДОПОЛНИТЕЛЬНЫЕ_ПОЛЯ//
		|ИЗ
		|	Справочник.НематериальныеАктивы КАК СправочникНематериальныеАктивы
		|	//СОЕДИНЕНИЯ//
		|	//ОТБОРЫ//";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ДОПОЛНИТЕЛЬНЫЕ_ПОЛЯ//", ДополнительныеПоля);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//СОЕДИНЕНИЯ//", ТекстСоединения);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОТБОРЫ//", ТекстОтборы);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ПЕРВЫЕ//", ТекстПервые);

		ОписаниеЗапросаДляВыбора = Новый Структура("ТекстЗапроса,ПараметрыЗапроса,ДоступныеПоля", ТекстЗапроса, ПараметрыЗапроса, ДоступныеПоля);
	КонецЕсли; 
	
	Возврат ОписаниеЗапросаДляВыбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли