////////////////////////////////////////////////////////////////////////////////
// Отчетность по регистрам учета 
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Сохраняет табличный документ как регистр учета. Вызывается из формы отчета.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - открытая форма, поставляющая значения свойств.
//  Подписать    - Булево - нужно ли подписывать файл электронной подписью. Если не указано, то Ложь.
//
Процедура СохранитьРегистрУчета(Форма, Знач Подписать = Ложь) Экспорт
	
	Перем ДанныеСохранения;
	
	ТаблицаРегистра = Форма.Результат;
	Если Не ПроверитьВозможностьСохраненияРезультата(Форма, ТаблицаРегистра, Подписать) Тогда
		Возврат;
	КонецЕсли;
		
	Отчет = Форма.Отчет;
	
	СвойстваРегистраУчета = Новый Структура("ПодразделениеОрганизации, ВключатьОбособленныеПодразделения");
	Отчет.Свойство("Подразделение",                     СвойстваРегистраУчета.ПодразделениеОрганизации);
	Отчет.Свойство("ВключатьОбособленныеПодразделения", СвойстваРегистраУчета.ВключатьОбособленныеПодразделения);
	СвойстваРегистраУчета.Вставить("Организация",       Отчет.Организация);
	СвойстваРегистраУчета.Вставить("НачалоПериода",     Отчет.НачалоПериода);
	СвойстваРегистраУчета.Вставить("КонецПериода",      Отчет.КонецПериода);
	СвойстваРегистраУчета.Вставить("ВидРегистра",       Форма.ВидРегистра);
	СвойстваРегистраУчета.Вставить("ТаблицаРегистра",
		ПоместитьВоВременноеХранилище(ТаблицаРегистра, Новый УникальныйИдентификатор));
	
	ДанныеСохранения = РегистрыУчетаВызовСервера.СохранитьРегистрУчета(СвойстваРегистраУчета);
	Если ДанныеСохранения = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если Подписать Тогда
		
		РаботаСФайламиКлиент.ПодписатьФайл(ДанныеСохранения.ПрисоединенныйФайл, Форма.УникальныйИдентификатор);	
		
	КонецЕсли;
	
	Оповестить("Запись_ПрисоединенныйФайл", Новый Структура, ДанныеСохранения.ПрисоединенныйФайл);
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Сохранение'"),
		ПолучитьНавигационнуюСсылку(ДанныеСохранения.РегистрУчета),
		ДанныеСохранения.ОписаниеРегистра,
		БиблиотекаКартинок.Информация32);
	
КонецПроцедуры

// Открывает список сохраненных регистров учета с отбором. Вызывается из формы отчета.
//
// Параметры:
//  Форма        - ФормаКлиентскогоПриложения - открытая форма, поставляющая значения отборов.
//
Процедура ОткрытьАрхивРегистровУчета(Форма) Экспорт
	
	ВидРегистра = Форма.ВидРегистра;
	Если Не ЗначениеЗаполнено(ВидРегистра) Тогда
		Возврат;
	КонецЕсли;
	
	Отчет = Форма.Отчет;
	
	ОтборСписка = Новый Структура;
	ОтборСписка.Вставить("ВидРегистра",   ВидРегистра);
	ОтборСписка.Вставить("Организация",   Отчет.Организация);
	ОтборСписка.Вставить("НачалоПериода", Отчет.НачалоПериода);
	ОтборСписка.Вставить("КонецПериода",  Отчет.КонецПериода);
	
	ПараметрыОткрытияФормы = Новый Структура("Отбор", ОтборСписка);
		
	ОткрытьФорму("Документ.РегистрУчета.ФормаСписка", ПараметрыОткрытияФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет состояние табличного документа
//
Функция ПроверитьВозможностьСохраненияРезультата(Форма, ТаблицаРегистра, ПроверитьВозможностьПодписи = Ложь)
	
	
	// Проверка формы отчета.
	// Должна быть указана Организация.
	//
	// Должны стоять флаги:
	// - Выводить заголовок (Заголовок);
	// - Выводить подписи   (Подписи);
	// - Выводить единицу измерения (Единица измерения).
	
	Если Не ЗначениеЗаполнено(Форма.Отчет.Организация) Тогда
		
		ТекстСообщения = Нстр("ru = 'Для сохранения регистра учета, отчет должен быть сформирован по организации'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ПолеОрганизация");
		Возврат Ложь;
		
	КонецЕсли;
	
	СостояниеРегистра = Форма.Элементы.Результат.ОтображениеСостояния;
	
	Если СостояниеРегистра.Видимость Тогда
		ТекстСообщения = Нстр("ru = 'Отчет не может быть сохранен'");
		СостояниеРегистраТекст = СостояниеРегистра.Текст;
		Если ЗначениеЗаполнено(СостояниеРегистраТекст) Тогда
			ТекстСообщения = СостояниеРегистраТекст;
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,, "Результат");
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Форма.ВыводитьЗаголовок Тогда
		
		ТекстСообщения = Нстр("ru = 'Для сохранения регистра учета, флаг ""Заголовок"" должен быть установлен'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ВыводитьЗаголовок");
		ПоказатьСтраницуНастроек(Форма);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если Не Форма.ВыводитьПодвал Тогда
		
		ТекстСообщения = Нстр("ru = 'Для сохранения регистра учета, флаг ""Подписи"" должен быть установлен'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, , "ВыводитьПодвал");
		ПоказатьСтраницуНастроек(Форма);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если Не Форма.ВыводитьЕдиницуИзмерения Тогда
		
		ТекстСообщения = Нстр("ru = 'Для сохранения регистра учета, флаг ""Единица измерения"" должен быть установлен'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ВыводитьЕдиницуИзмерения");
		ПоказатьСтраницуНастроек(Форма);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Форма.ВидРегистра) Тогда
		
		ТекстСообщения = Нстр("ru = 'Для отчета не задан вид регистра в справочнике ""Виды регистров учета"", отчет не сохранен'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ТаблицаРегистра.ШиринаТаблицы = 0 Тогда
		ТекстСообщения = Нстр("ru = 'Отчет не может быть сохранен'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Результат");
		Возврат Ложь;
	КонецЕсли;

	Если ПроверитьВозможностьПодписи И НЕ Форма.ИспользуетсяЭП Тогда
		СообщениеОбОшибке = НСтр("ru='Для подписи регистра включите использование электронной подписи в настройках программы'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Показывает страницу настроек отчета
//
Процедура ПоказатьСтраницуНастроек(Форма)
	Если Форма.Элементы.Найти("РазделыОтчета") <> Неопределено Тогда
		Форма.Элементы.РазделыОтчета.ТекущаяСтраница		 = Форма.Элементы.НастройкиОтчета;
		Форма.Элементы.ПрименитьНастройки.КнопкаПоУмолчанию	 = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти