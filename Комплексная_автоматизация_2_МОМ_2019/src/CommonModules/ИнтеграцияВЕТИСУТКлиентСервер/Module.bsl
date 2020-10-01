#Область ПрограммныйИнтерфейс

#Область ИсходящаяТранспортнаяОперацияВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИсходящейТранспортнойОперации(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"РеализацияТоваровУслуг",            НСтр("ru = 'Реализацию товаров услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровПоставщику",          НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПеремещениеТоваров",                НСтр("ru = 'Перемещение товаров'"),                  "ИспользоватьПеремещениеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровМеждуОрганизациями",  НСтр("ru = 'Возврат товаров между организациями'"),  "ИспользоватьПередачиТоваровМеждуОрганизациями");
	// ++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ОтгрузкаТоваровСХранения",          НСтр("ru = 'Отгрузку товаров с хранения'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ДвижениеПродукцииИМатериалов",      НСтр("ru = 'Движение продукции и материалов'"),      "ИспользоватьУправлениеПроизводством2_2");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПередачаСырьяПереработчику",        НСтр("ru = 'Передачу сырья переработчику'"),         "ИспользоватьПроизводствоНаСтороне");
	// -- НЕ УТ
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"РеализацияТоваровУслуг",            НСтр("ru = 'Реализацию товаров услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровПоставщику",          НСтр("ru = 'Возврат товаров поставщику'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",                НСтр("ru = 'Перемещение товаров'"),                  "ИспользоватьПеремещениеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровМеждуОрганизациями",  НСтр("ru = 'Возврат товаров между организациями'"),  "ИспользоватьПередачиТоваровМеждуОрганизациями");
	// ++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ОтгрузкаТоваровСХранения",          НСтр("ru = 'Отгрузку товаров с хранения'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ДвижениеПродукцииИМатериалов",      НСтр("ru = 'Движение продукции и материалов'"),      "ИспользоватьУправлениеПроизводством2_2");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПередачаСырьяПереработчику",        НСтр("ru = 'Передачу сырья переработчику'"),         "ИспользоватьПроизводствоНаСтороне");
	// -- НЕ УТ
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИсходящейТранспортнойОперации(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ВариантОднаОрганизация = Ложь;
	ВариантОрганизации = Ложь;
	ВариантКонтрагенты = Ложь;
	Отправителей = 0;
	Для Каждого ЭлементСписка Из Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований Цикл
		Если ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			Если Форма.ГрузополучательСопоставлениеХСДляОтбораОснований.НайтиПоЗначению(ЭлементСписка.Значение)<>Неопределено Тогда
				ВариантОднаОрганизация = Истина;
			КонецЕсли;
			Отправителей = Отправителей + 1;
		КонецЕсли;
	КонецЦикла;
	Для Каждого ЭлементСписка Из Форма.ГрузополучательСопоставлениеХСДляОтбораОснований Цикл
		Если ТипЗнч(ЭлементСписка.Значение) = Тип("СправочникСсылка.Организации") 
			И (Отправителей > 1 Или Форма.ГрузоотправительСопоставлениеХСДляОтбораОснований.НайтиПоЗначению(ЭлементСписка.Значение)<>Неопределено) Тогда
				ВариантОрганизации = Истина;
		КонецЕсли;
		Если ТипЗнч(ЭлементСписка.Значение) <> Тип("СправочникСсылка.Организации") Тогда
			ВариантКонтрагенты = Истина;
		КонецЕсли;
	КонецЦикла;
	Если Не (ВариантОднаОрганизация Или ВариантОрганизации) Тогда
		ВариантКонтрагенты = Истина;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		
		Если  КлючИЗначение.Значение.ИмяМетаданных = "ДвижениеПродукцииИМатериалов" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантОднаОрганизация;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПеремещениеТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантОднаОрганизация ИЛИ ВариантОрганизации;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПередачаТоваровМеждуОрганизациями"
			ИЛИ КлючИЗначение.Значение.ИмяМетаданных = "ВозвратТоваровМеждуОрганизациями" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантОрганизации;
		Иначе 
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ВариантКонтрагенты;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ВходящаяТранспортнаяОперацияВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыВходящейТранспортнойОперации(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПриобретениеТоваровУслуг",          НСтр("ru = 'Приобретение товаров и услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратТоваровОтКлиента",           НСтр("ru = 'Возврат товаров от клиента'"));
	//++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПриемкаТоваровНаХранение",          НСтр("ru = 'Приемку товаров на хранение'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВыкупПринятыхНаХранениеТоваров",    НСтр("ru = 'Выкуп принятых на хранение товаров'"),   "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ПоступлениеОтПереработчика",        НСтр("ru = 'Поступление от переработчика'"),         "ИспользоватьПроизводствоНаСтороне");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды,"ВозвратСырьяОтПереработчика",       НСтр("ru = 'Возврат сырья от переработчика'"),       "ИспользоватьПроизводствоНаСтороне");
	//-- НЕ УТ
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриобретениеТоваровУслуг",          НСтр("ru = 'Приобретение товаров и услуг'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровОтКлиента",           НСтр("ru = 'Возврат товаров от клиента'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПеремещениеТоваров",                НСтр("ru = 'Перемещение товаров'"),                  "ИспользоватьПеремещениеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПередачаТоваровМеждуОрганизациями", НСтр("ru = 'Передачу товаров между организациями'"), "ИспользоватьПередачиТоваровМеждуОрганизациями");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратТоваровМеждуОрганизациями",  НСтр("ru = 'Возврат товаров между организациями'"),  "ИспользоватьПередачиТоваровМеждуОрганизациями");
	//++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПриемкаТоваровНаХранение",          НСтр("ru = 'Приемку товаров на хранение'"),          "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВыкупПринятыхНаХранениеТоваров",    НСтр("ru = 'Выкуп принятых на хранение товаров'"),   "ИспользоватьОтветственноеХранениеВПроцессеЗакупки");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ДвижениеПродукцииИМатериалов",      НСтр("ru = 'Движение продукции и материалов'"),      "ИспользоватьУправлениеПроизводством2_2");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ПоступлениеОтПереработчика",        НСтр("ru = 'Поступление от переработчика'"),         "ИспользоватьПроизводствоНаСтороне");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды,"ВозвратСырьяОтПереработчика",       НСтр("ru = 'Возврат сырья от переработчика'"),       "ИспользоватьПроизводствоНаСтороне");
	//-- НЕ УТ
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандВходящейТранспортнойОперации(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ПроизводственнаяОперацияВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыПроизводственнойОперации(Команды) Экспорт 
	
	// ++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ПроизводствоБезЗаказа", НСтр("ru = 'Производство без заказа'"),   "ИспользоватьУправлениеПроизводством2_2");
	// -- НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СборкаТоваров",         НСтр("ru = 'Сборку (разборку) товаров'"), "ИспользоватьСборкуРазборку");
	
	// ++ НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПроизводствоБезЗаказа", НСтр("ru = 'Производство без заказа'"),   "ИспользоватьУправлениеПроизводством2_2");
	// -- НЕ УТ
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СборкаТоваров",         НСтр("ru = 'Сборку (разборку) товаров'"), "ИспользоватьСборкуРазборку");
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандПроизводственнойОперации(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнвентаризацияПродукцииВЕТИС

// Заполняет структуру команд для динамического формирования доступных для создания документов на основании.
// 
// Параметры:
// 	Команды - Структура - Исходящий, структура команд динамически формируемых для создания документов на основании.
//
Процедура КомандыИнвентаризацииПродукции(Команды) Экспорт 
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ВнутреннееПотреблениеТоваров",      НСтр("ru = 'Внутреннее потребление товаров'"),        "ИспользоватьВнутреннееПотребление");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "СписаниеНедостачТоваров",           НСтр("ru = 'Списание недостач товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ПрочееОприходованиеТоваров",        НСтр("ru = 'Прочее оприходование товаров'"),          "ИспользоватьПрочееОприходованиеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуОформить(Команды, "ОприходованиеИзлишковТоваров",      НСтр("ru = 'Оприходование излишков товаров'"));
	
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ВнутреннееПотреблениеТоваров",      НСтр("ru = 'Внутреннее потребление товаров'"),        "ИспользоватьВнутреннееПотребление");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "СписаниеНедостачТоваров",           НСтр("ru = 'Списание недостач товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПересортицаТоваров",                НСтр("ru = 'Пересортицу товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПрочееОприходованиеТоваров",        НСтр("ru = 'Прочее оприходование товаров'"),          "ИспользоватьПрочееОприходованиеТоваров");
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ОприходованиеИзлишковТоваров",      НСтр("ru = 'Оприходование излишков товаров'"));
	ПодключаемыеКомандыИСКлиентСервер.ДобавитьКомандуВыбрать(Команды, "ПорчаТоваров",                      НСтр("ru = 'Порчу товаров'"),                         "ИспользоватьКачествоТоваров");
	
КонецПроцедуры

// Устанавливает видимость команд динамически формируемых для создания документов на основании.
// 
// Параметры:
// 	Форма   - ФормаКлиентскогоПриложения - Форма на которой находятся вызова команд.
// 	Команды - Структура - структура команд динамически формируемых для создания документов на основании.
//
Процедура УправлениеВидимостьюКомандИнвентаризацииПродукции(Форма, Команды) Экспорт
	
	Если ПодключаемыеКомандыИСКлиентСервер.УправлениеВидимостьюПоУмолчанию(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьРасход = Ложь;
	ЕстьПриход = Ложь;
	Для Каждого СтрокаТЧ Из Форма.Объект.Товары Цикл
		Если СтрокаТЧ.КоличествоИзменениеВЕТИС<0 Тогда 
			ЕстьРасход = Истина;
		ИначеЕсли СтрокаТЧ.КоличествоИзменениеВЕТИС>0 Тогда 
			ЕстьПриход = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из Форма.ВидимостьПодключаемыхКоманд Цикл
		Если ЗначениеЗаполнено(Форма.Объект.ДокументОснование)Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = Ложь;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ПересортицаТоваров"
			ИЛИ КлючИЗначение.Значение.ИмяМетаданных = "ПорчаТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = ЕстьПриход = ЕстьРасход;
		ИначеЕсли КлючИЗначение.Значение.ИмяМетаданных = "ОприходованиеИзлишковТоваров"
			ИЛИ КлючИЗначение.Значение.ИмяМетаданных = "ПрочееОприходованиеТоваров" Тогда
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьРасход;
		Иначе
			Форма.Элементы[КлючИЗначение.Ключ].Видимость = НЕ ЕстьПриход;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Функция ПересчитатьКоличествоЕдиницВЕТИС(Количество, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличествоВЕТИС = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ОбработкаТабличнойЧастиКлиентСерверЛокализация.ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура, 
										ЕдиницаИзмеренияВЕТИС, 
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины);
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличествоВЕТИС = Количество / ДанныеЕдиницыИзмерения.Коэффициент;
		
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличествоВЕТИС Тогда
				
				НовоеКоличествоВЕТИС = Окр(НовоеКоличествоВЕТИС, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличествоВЕТИС;
	
КонецФункции

Функция ПересчитатьКоличествоЕдиниц(КоличествоВЕТИС, Номенклатура, ЕдиницаИзмеренияВЕТИС, НужноОкруглять, КэшированныеЗначения, ТекстОшибки = Неопределено) Экспорт
	
	НовоеКоличество = Неопределено;
	ТекстОшибки = Неопределено;
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		ДанныеЕдиницыИзмерения = ОбработкаТабличнойЧастиКлиентСерверЛокализация.ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(
									ЕдиницаИзмеренияВЕТИС, 
									КэшированныеЗначения,
									Номенклатура);
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
			
			Если ДанныеЕдиницыИзмерения.КодОшибки <> 0 Тогда
				
				ТекстОшибки = ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(
										ДанныеЕдиницыИзмерения.КодОшибки,
										Номенклатура,
										ЕдиницаИзмеренияВЕТИС,
										ДанныеЕдиницыИзмерения.ТипИзмеряемойВеличины,
										"ВЕТИС");
				
				Возврат Неопределено;
				
			КонецЕсли;
			
			НовоеКоличество = КоличествоВЕТИС * ДанныеЕдиницыИзмерения.Коэффициент;
			
			Если НужноОкруглять
				И ДанныеЕдиницыИзмерения.НужноОкруглятьКоличество Тогда
				
				НовоеКоличество = Окр(НовоеКоличество, 0, РежимОкругления.Окр15как20);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

	Возврат НовоеКоличество;
	
КонецФункции

// Возвращает параметры оформления серии по данным строки (если использование условного оформления не возможно).
//
//	Параметры:
//		ОсобыйВариантУказанияСерий - Булево, Строка - Ложь, если серии указываются в отдельной ТЧ,
//			"СерииВсегдаВТЧТовары" - если у объекта нет специальной ТЧ для указания серий,
//			"СерииПриПланированииОтгрузкиУказываютсяВТЧТовары" - если серии могут указываться в разных ТЧ,
//				при этом серии с политикой учета "При планировании отгрузки" указываются в ТЧ Товары,
//		ДанныеСтроки - Структура, ДанныеФормыЭлементКоллекции - данные, в которых содержится информация по оформлению серии
//		ПутьКПолюОтбораСтатусУказанияСерий - Строка - имя поля в "ДанныеСтроки" к реквизиту "Статус указания серий",
//														если он отличается от "СтатусУказанияСерий"
//		ПутьКПолюОтбораТипНоменклатуры - Строка - имя поля в "ДанныеСтроки" к реквизиту "Тип номенклатуры",
//														если он отличается от "ТипНоменклатуры".
//
//	Возвращаемое значение:
//		Структура - структура, содержащая поля, на основании которых можно оформить элемент формы, содержит свойства:
//			ИмяЦветаТекста - Строка - имя цвета текста поля, которое в последствии можно назначить элементу
//								"Цвет текста" поля управляемой формы, значение по умолчанию "ЦветТекстаПоля";
//			ОтметкаНезаполненного - Булево - будет назначаться в аналогичный признак поля управляемой формы, значение по умолчанию Истина;
//			ТолькоПросмотр - Булево - будет назначаться в аналогичный признак поля управляемой формы, значение по умолчанию Ложь;
//			Текст - Строка - строка, которая может быть использована в качестве представления текущего значения серии.
//
Функция ПараметрыОформленияСерииПоДаннымСтроки(ОсобыйВариантУказанияСерий, ДанныеСтроки,
														ПутьКПолюОтбораСтатусУказанияСерий = "СтатусУказанияСерий",
														ПутьКПолюОтбораТипНоменклатуры = "ТипНоменклатуры") Экспорт
	
	// Значения по умолчанию:
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("ИмяЦветаТекста", "ЦветТекстаПоля");
	СтруктураВозврата.Вставить("ОтметкаНезаполненного", Истина);
	СтруктураВозврата.Вставить("ТолькоПросмотр", Ложь);
	
	ТипНоменклатуры = ДанныеСтроки[ПутьКПолюОтбораТипНоменклатуры];
	СтатусСерии = ДанныеСтроки[ПутьКПолюОтбораСтатусУказанияСерий];
	
	СерииВсегдаВТЧТовары = (ОсобыйВариантУказанияСерий = "СерииВсегдаВТЧТовары");
	СерииПриПланированииОтгрузкиУказываютсяВТЧТовары = (ОсобыйВариантУказанияСерий = "СерииПриПланированииОтгрузкиУказываютсяВТЧТовары");
	
	СписокТиповДляСерий = Новый СписокЗначений;
	СписокТиповДляСерий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	СписокТиповДляСерий.Добавить(ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
	
	// Для товаров
	Если СписокТиповДляСерий.НайтиПоЗначению(ТипНоменклатуры) = Неопределено Тогда
		СтруктураВозврата.Вставить("ИмяЦветаТекста", "ТекстЗапрещеннойЯчейкиЦвет");
		СтруктураВозврата.Вставить("ОтметкаНезаполненного", Ложь);
		СтруктураВозврата.Вставить("Текст", НСтр("ru = '<для товаров>'"));
		СтруктураВозврата.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	// Серия не указывается
	Если СписокТиповДляСерий.НайтиПоЗначению(ТипНоменклатуры) <> Неопределено И СтатусСерии = 0 Тогда
		СтруктураВозврата.Вставить("ИмяЦветаТекста", "ТекстЗапрещеннойЯчейкиЦвет");
		СтруктураВозврата.Вставить("ОтметкаНезаполненного", Ложь);
		СтруктураВозврата.Вставить("Текст", НСтр("ru = '<серия не указывается>'"));
		СтруктураВозврата.Вставить("ТолькоПросмотр", Истина);
	КонецЕсли;
	
	Если Не СерииВсегдаВТЧТовары Тогда
		
		СписокСтатусовСерий = Новый СписокЗначений;
		СписокСтатусовСерий.ЗагрузитьЗначения(НоменклатураКлиентСервер.СтатусыСерийСериюМожноУказать());
		СписокСтатусовСерий.Удалить(СписокСтатусовСерий.НайтиПоЗначению(15));
		Если СерииПриПланированииОтгрузкиУказываютсяВТЧТовары Тогда
			СписокСтатусовСерий.Удалить(СписокСтатусовСерий.НайтиПоЗначению(11));
		КонецЕсли;
		
		// Серия указывается отдельно
		Если СписокТиповДляСерий.НайтиПоЗначению(ТипНоменклатуры) <> Неопределено И СтатусСерии <> 0
			И (СтатусСерии <= ?(СерииПриПланированииОтгрузкиУказываютсяВТЧТовары, 8, 11)
			Или СписокСтатусовСерий.НайтиПоЗначению(СтатусСерии) <> Неопределено) Тогда
			СтруктураВозврата.Вставить("ИмяЦветаТекста", "ТекстЗапрещеннойЯчейкиЦвет");
			СтруктураВозврата.Вставить("ОтметкаНезаполненного", Ложь);
			СтруктураВозврата.Вставить("Текст", НСтр("ru = '<серия указывается отдельно>'"));
			СтруктураВозврата.Вставить("ТолькоПросмотр", Истина);
		КонецЕсли;
		
		СписокСтатусовСерий = Новый СписокЗначений;
		СписокСтатусовСерий.Добавить(15);
		Если СерииПриПланированииОтгрузкиУказываютсяВТЧТовары Тогда
			СписокСтатусовСерий.Добавить(11);
		КонецЕсли;
		
		//
		Если СписокТиповДляСерий.НайтиПоЗначению(ТипНоменклатуры) <> Неопределено
			И СписокСтатусовСерий.НайтиПоЗначению(СтатусСерии) <> Неопределено Тогда
			СтруктураВозврата.Вставить("ОтметкаНезаполненного", Ложь);
		КонецЕсли;		
		
	Иначе
		
		// Серия указывается в ТЧ Товары
		Если НоменклатураКлиентСервер.СтатусыСерийСериюМожноУказать().Найти(СтатусСерии) <> Неопределено Тогда
			СтруктураВозврата.Вставить("ОтметкаНезаполненного", Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураВозврата;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстОшибкиПересчетаЕдиницыИзмеренияВЕТИС(КодОшибки, Номенклатура, ЕдиницаИзмеренияВЕТИС, ТипИзмеряемойВеличины, СуффиксКоличества = "")
	
	ПересчетВЕТИС        = СокрЛП(СуффиксКоличества) = "ВЕТИС";
	ТекстЕдиницыХранения = ?(ПересчетВЕТИС, НСтр("ru = 'в единицу хранения'"), НСтр("ru = 'количества (ВетИС)'"));
	
	ШаблонСообщенияНеЗаполненаЕдиницаИзмерения    = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВетИС%""'");
	ШаблонСообщенияНеУказанТипИзмеряемойВеличины  = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%, т.к. в карточке номенклатуры ""%Номенклатура%"" выключена возможность указания количества в единицах измерения %ТипИзмеряемойВеличины%'");
	ШаблонСообщенияНеСопоставленыЕдиницыИзмерения = НСтр("ru = 'Не удалось выполнить пересчет %ЕдиницаХранения%. Приведите в соответствие единицу измерения в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВетИС%"" с единицей хранения номенклатуры ""%Номенклатура%"" или укажите %ТипКоличества% вручную'");
	
	Если КодОшибки = 1 Тогда
		ТекстСообщения = ШаблонСообщенияНеЗаполненаЕдиницаИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВетИС%", Строка(ЕдиницаИзмеренияВЕТИС));
	ИначеЕсли КодОшибки = 2 Тогда
		
		Если ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Вес") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'веса'");
		ИначеЕсли ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Объем") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'объема'");
		ИначеЕсли ТипИзмеряемойВеличины = ПредопределенноеЗначение("Перечисление.ТипыИзмеряемыхВеличин.Длина") Тогда
			ИмяТипаИзмеряемойВеличины = НСтр("ru = 'длины'");
		КонецЕсли;
		
		ТекстСообщения = ШаблонСообщенияНеУказанТипИзмеряемойВеличины;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипИзмеряемойВеличины%", ИмяТипаИзмеряемойВеличины);
		
	ИначеЕсли КодОшибки = 3 Тогда
		ТекстТипаКоличества = ?(ПересчетВЕТИС, НСтр("ru = 'количество'"), НСтр("ru = 'количество (ВетИС)'"));
		
		ТекстСообщения = ШаблонСообщенияНеСопоставленыЕдиницыИзмерения;
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаХранения%",       ТекстЕдиницыХранения);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВетИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%",          Строка(Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ТипКоличества%",         ТекстТипаКоличества);
	Иначе
		ТекстСообщения = "";
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

#КонецОбласти
