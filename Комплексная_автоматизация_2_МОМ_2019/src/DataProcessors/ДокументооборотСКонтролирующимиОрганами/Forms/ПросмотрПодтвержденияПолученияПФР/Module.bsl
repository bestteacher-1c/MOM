&НаСервере
Перем КонтекстЭДОСервер Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	// считываем текст из файла уведомления
	Попытка
		ПутьКФайлу = ПолучитьИмяВременногоФайла();
		ПолучитьИзВременногоХранилища(Параметры.ПодтверждениеПолучения).Записать(ПутьКФайлу);
		ЧтениеТекста = Новый ЧтениеТекста;
		КонтекстЭДОСервер.ЧтениеТекстаОткрытьНаСервере(ЧтениеТекста, ПутьКФайлу);
		СтрокаXML = ЧтениеТекста.Прочитать();
		ЧтениеТекста.Закрыть();
		ОперацииСФайламиЭДКО.УдалитьВременныйФайл(ПутьКФайлу); // xml-файл
	Исключение
		Отказ = Истина;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Ошибка чтения содержимого подтверждения из файла: %1'"),
			Символы.ПС + Символы.ПС + ИнформацияОбОшибке().Описание);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецПопытки;
	
	// загружаем XML из строки в дерево
	ДеревоXML = КонтекстЭДОСервер.ЗагрузитьСтрокуXMLВДеревоЗначений(СтрокаXML);
	Если ДеревоXML = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	//
	// определяем дату-время получения
	ЭтоУведомлениеОДоставке = Ложь;
	УзлыДатаВремяПолучения = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "датаВремяПолучения", "Э"), Истина);
	Если УзлыДатаВремяПолучения.Количество() = 0 Тогда
		КонтекстЭДОСервер.НайтиСтрокиДереваЗначений(ДеревоXML,, УзлыДатаВремяПолучения, "ДатаВремя", "Э");
		Если УзлыДатаВремяПолучения.Количество() <> 0 Тогда
			ЭтоУведомлениеОДоставке = Истина;
			
			ИмяУзлаДоставленныйПакетВРег = ВРег("ДоставленныйПакет");
			ИндексУзла = 0;
			Пока ИндексУзла < УзлыДатаВремяПолучения.Количество() Цикл
				ИмяУзлаРодителяВРег = ?(УзлыДатаВремяПолучения[ИндексУзла].Родитель = Неопределено, "",
					ВРег(УзлыДатаВремяПолучения[ИндексУзла].Родитель.Имя));
				ИмяУзлаРодителяВРег = СокрЛП(ИмяУзлаРодителяВРег);
				Если СтрЗаканчиваетсяНа(ИмяУзлаРодителяВРег, ИмяУзлаДоставленныйПакетВРег) Тогда
					ИндексУзла = ИндексУзла + 1;
				Иначе
					УзлыДатаВремяПолучения.Удалить(ИндексУзла);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Если УзлыДатаВремяПолучения.Количество() = 0 Тогда
		ДатаВремяПолучения = "";
	Иначе
		ДатаВремяПолучения = Формат(ДатаВремяИзСтрокиXML(УзлыДатаВремяПолучения[0].Значение), "ДЛФ=ДДВ; ДП=-");
	КонецЕсли;
	
	// определяем регистрационный номер организации
	УзлыРегистрационныйНомерОрганизации = ДеревоXML.Строки.НайтиСтроки(
		Новый Структура("Имя, Тип", "регистрационныйНомерОрганизации", "Э"), Истина);
	РегистрационныйНомерОператора = "";
	Если УзлыРегистрационныйНомерОрганизации.Количество() = 0 Тогда
		КонтекстЭДОСервер.НайтиСтрокиДереваЗначений(ДеревоXML,, УзлыРегистрационныйНомерОрганизации, "РегНомер", "Э"); // УОД
		Если УзлыРегистрационныйНомерОрганизации.Количество() <> 0 Тогда
			ЭтоУведомлениеОДоставке = Истина;
			
			ИмяУзлаСтраховательВРег = ВРег("Страхователь");
			ИмяУзлаОператорВРег = ВРег("Оператор");
			ИндексУзла = 0;
			Пока ИндексУзла < УзлыРегистрационныйНомерОрганизации.Количество() Цикл
				ИмяУзлаРодителяВРег = ?(УзлыРегистрационныйНомерОрганизации[ИндексУзла].Родитель = Неопределено, "",
					ВРег(УзлыРегистрационныйНомерОрганизации[ИндексУзла].Родитель.Имя));
				ИмяУзлаРодителяВРег = СокрЛП(ИмяУзлаРодителяВРег);
				
				Если СтрЗаканчиваетсяНа(ИмяУзлаРодителяВРег, ИмяУзлаСтраховательВРег) Тогда
					ИндексУзла = ИндексУзла + 1;
					
				Иначе
					Если СтрЗаканчиваетсяНа(ИмяУзлаРодителяВРег, ИмяУзлаОператорВРег)
						И НЕ ЗначениеЗаполнено(РегистрационныйНомерОператора) Тогда
						
						РегистрационныйНомерОператора = УзлыРегистрационныйНомерОрганизации[ИндексУзла].Значение;
					КонецЕсли;
					УзлыРегистрационныйНомерОрганизации.Удалить(ИндексУзла);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	Иначе
		ЭтоУведомлениеОДоставке = Ложь;
	КонецЕсли;
	Если УзлыРегистрационныйНомерОрганизации.Количество() = 0 Тогда
		РегистрационныйНомерОрганизации = "";
	Иначе
		РегистрационныйНомерОрганизации = УзлыРегистрационныйНомерОрганизации[0].Значение;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(РегистрационныйНомерОрганизации) И ЗначениеЗаполнено(РегистрационныйНомерОператора) Тогда
		Элементы.РегистрационныйНомерОрганизации.Заголовок = НСтр("ru = 'Регистрационный номер оператора'");
		РегистрационныйНомерОрганизации = РегистрационныйНомерОператора;
	КонецЕсли;
	
	// определяем, представлен ли отчет и заполняем связанные реквизиты, если не представлен
	УзлыОтчетПредставлен = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "отчетПредставлен", "Э"), Истина);
	Если УзлыОтчетПредставлен.Количество() = 0 Тогда
		ОтчетПредставлен = "";
		Элементы.ГруппаПредставление.Видимость = Ложь;
		Элементы.ГруппаПричинаОтказа.Видимость = Ложь;
		Элементы.ГруппаПротоколыПроверки.Видимость = Ложь;
	Иначе
		
		ЗначениеСтр = УзлыОтчетПредставлен[0].Значение;
		БулевоОтчетПредставлен = XMLЗначение(Тип("Булево"), ЗначениеСтр);
		ОтчетПредставлен = ?(БулевоОтчетПредставлен, "Да", "Нет");
		Если НЕ БулевоОтчетПредставлен Тогда
			Элементы.НадписьОтчетПредставлен.ЦветТекста = Новый Цвет(255, 0, 0);
		КонецЕсли;
		Элементы.ГруппаПредставление.Видимость = Истина;
		
		// если отчет не представлен, то выводим причину отказа в приеме
		Если НЕ БулевоОтчетПредставлен Тогда
			УзлыПричинаОтказа = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "причинаОтказа", "Э"), Истина);
			Если УзлыПричинаОтказа.Количество() = 0 Тогда
				Элементы.ГруппаПричинаОтказа.Видимость = Ложь;
			Иначе
				СтрПричинаОтказа = УзлыПричинаОтказа[0].Значение;
				Если СтрПричинаОтказа = "несоответствиеФормату" Тогда
					ПричинаОтказаВПриеме = "Полученный документ не соответствует формату.";
				ИначеЕсли СтрПричинаОтказа = "отсутствиеПолномочий" Тогда
					ПричинаОтказаВПриеме = "У подписанта документа отсутствуют соответствующие полномочия.";
				ИначеЕсли СтрПричинаОтказа = "ошибкаЭЦП" Тогда
					ПричинаОтказаВПриеме = "Ошибка при контроле электронной подписи.";
				Иначе
					ПричинаОтказаВПриеме = СтрПричинаОтказа;
				КонецЕсли;
				Элементы.ГруппаПричинаОтказа.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		// находим информацию о приложениях в XML
		УзлыПодтверждениеПриложения = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "подтверждениеПриложения", "Э"), Истина);
		Если УзлыПодтверждениеПриложения.Количество() > 0 Тогда
			
			УзелПодтверждениеПриложения = УзлыПодтверждениеПриложения[0];
			
			// перебираем приложения
			УзлыПриложение = УзелПодтверждениеПриложения.Строки.НайтиСтроки(Новый Структура("Имя", "приложение"));
			Если УзлыПриложение.Количество() > 0 Тогда
				
				Для Каждого УзелПриложение Из УзлыПриложение Цикл
					
					// находим подчиненный узел имяФайла
					УзелИмяФайла = УзелПриложение.Строки.Найти("имяФайла");
					УзелИдентификаторДокумента = УзелПриложение.Строки.Найти("идентификаторДокумента");
					Если УзелИмяФайла = Неопределено ИЛИ УзелИдентификаторДокумента = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					
					СтрПротокол = Протоколы.Добавить();
					СтрПротокол.ИмяФайла = УзелИмяФайла.Значение;
					СтрПротокол.Идентификатор = УзелИдентификаторДокумента.Значение;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Элементы.ГруппаПротоколыПроверки.Видимость = Истина;
			
		Иначе
			
			Элементы.ГруппаПротоколыПроверки.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// находим информацию о пачках в XML
	УзлыОписаниеПачек = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "описаниеПачек", "Э"), Истина);
	Если УзлыОписаниеПачек.Количество() > 0 Тогда
		
		УзелОписаниеПачек = УзлыОписаниеПачек[0];
		
		// перебираем пачки
		УзлыПачка = УзелОписаниеПачек.Строки.НайтиСтроки(Новый Структура("Имя", "пачка"));
		Если УзлыПачка.Количество() > 0 Тогда
			
			СтрПачки = Содержимое.ПолучитьЭлементы().Добавить();
			СтрПачки.Имя = "Пачки (" + Формат(УзлыПачка.Количество(), "ЧГ=") + "):";
			
			Для Каждого УзелПачка Из УзлыПачка Цикл
				
				СтрПачка = СтрПачки.ПолучитьЭлементы().Добавить();
				
				// находим подчиненный узел имяФайла
				УзелИмяФайла = УзелПачка.Строки.Найти("имяФайла");
				Если УзелИмяФайла <> Неопределено Тогда
					СтрПачка.Имя = УзелИмяФайла.Значение;
				КонецЕсли;
				
				// находим подчиненный узел идентификаторДокумента
				УзелИдентификаторДокумента = УзелПачка.Строки.Найти("идентификаторДокумента");
				Если УзелИдентификаторДокумента <> Неопределено Тогда
					СтрПачка.Идентификатор = УзелИдентификаторДокумента.Значение;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// находим информацию о приложениях в XML
	УзлыОписаниеПриложений = ДеревоXML.Строки.НайтиСтроки(Новый Структура("Имя, Тип", "описаниеПриложений", "Э"), Истина);
	Если УзлыОписаниеПриложений.Количество() > 0 Тогда
		
		УзелОписаниеПриложений = УзлыОписаниеПриложений[0];
		
		// перебираем приложения
		УзлыПриложение = УзелОписаниеПриложений.Строки.НайтиСтроки(Новый Структура("Имя", "приложение"));
		Если УзлыПриложение.Количество() > 0 Тогда
			
			ДеревоСодержимое = РеквизитФормыВЗначение("Содержимое");
			
			СтрПриложения = ДеревоСодержимое.Строки.Добавить();
			СтрПриложения.Имя = "Приложения (" + Формат(УзлыПриложение.Количество(), "ЧГ=") + "):";
			
			Для Каждого УзелПриложение Из УзлыПриложение Цикл
				
				СтрПриложение = СтрПриложения.Строки.Добавить();
				
				// находим подчиненный узел имяФайла
				УзелИмяФайла = УзелПриложение.Строки.Найти("имяФайла");
				Если УзелИмяФайла <> Неопределено Тогда
					СтрПриложение.Имя = УзелИмяФайла.Значение;
				КонецЕсли;
				
				// находим подчиненный узел идентификаторДокумента
				УзелИдентификаторДокумента = УзелПриложение.Строки.Найти("идентификаторДокумента");
				Если УзелИдентификаторДокумента <> Неопределено Тогда
					СтрПриложение.Идентификатор = УзелИдентификаторДокумента.Значение;
				КонецЕсли;
				
			КонецЦикла;
			
			ЗначениеВРеквизитФормы(ДеревоСодержимое, "Содержимое");
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОформитьСтроки(Содержимое);
	
	Если Содержимое.ПолучитьЭлементы().Количество() = 0 И ЭтоУведомлениеОДоставке Тогда
		Элементы.ГруппаСодержимое.Видимость = Ложь;
	КонецЕсли;
	
	Заголовок = ?(ЭтоУведомлениеОДоставке, НСтр("ru = 'Уведомление о доставке'"),
		НСтр("ru = 'Подтверждение получения'")) + " " + Параметры.ИмяФайла;
	
	Элементы.КнопкаПечать.Видимость = Параметры.ПечатьВозможна;
	Если Параметры.ПечатьВозможна Тогда
		ЦиклОбмена = Параметры.ЦиклОбмена;
		ФорматДокументооборота = Параметры.ЦиклОбмена.ФорматДокументооборота;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДатаВремяИзСтрокиXML(ЗначениеСтр)
	
	Попытка
		Возврат XMLЗначение(Тип("Дата"), ЗначениеСтр);
	Исключение
		Возврат '00010101';
	КонецПопытки;
	
КонецФункции

&НаСервере
Функция ОформитьСтроки(Содержимое)

	Для Каждого Узел Из Содержимое.ПолучитьЭлементы() Цикл
		ОформитьСтрокуСодержимого(Узел);
		ОформитьСтроки(Узел)
	КонецЦикла;

КонецФункции

&НаСервере
Процедура ОформитьСтрокуСодержимого(ДанныеСтроки)

	ДанныеСтроки.Уровень = УровеньЭлементаДерева(ДанныеСтроки);

КонецПроцедуры

&НаСервере
Функция УровеньЭлементаДерева(ЭлементДерева)
	Уровень = 0;
	ПредыдущийЭлемент = ЭлементДерева.ПолучитьРодителя();
	Пока Истина Цикл
		Если ПредыдущийЭлемент = Неопределено Тогда 
			Возврат Уровень;
		Иначе
			ПредыдущийЭлемент = ПредыдущийЭлемент.ПолучитьРодителя();
			Уровень = Уровень + 1;
		КонецЕсли;
	КонецЦикла;
	Возврат Уровень;
КонецФункции

&НаКлиенте
Процедура ПечатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	РезультатНастройки = Новый Структура("ПечататьИзвещениеОбОтказеПФР, ФорматДокументооборота", Истина, ФорматДокументооборота);
	КонтекстЭДОКлиент.СформироватьИПоказатьПечатныеДокументы(ЦиклОбмена, РезультатНастройки);
	
КонецПроцедуры

#КонецОбласти