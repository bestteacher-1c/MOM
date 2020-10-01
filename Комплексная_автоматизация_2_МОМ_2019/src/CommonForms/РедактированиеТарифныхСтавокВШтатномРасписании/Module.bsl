#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыДанныеПозицииШтатногоРасписания" И Источник = ЭтаФорма Тогда
		ПрочитатьДанныеПозицииВФорму(Параметр);
		УправлениеШтатнымРасписаниемКлиент.ПозицииПриАктивизацииСтроки(ЭтаФорма, Позиции, Истина);
	КонецЕсли; 
	
	Если ИмяСобытия = "ИзмененыПоказателиДокумента" И Источник.ВладелецФормы = ЭтаФорма Тогда
		
		Если Параметр.Показатели.Количество() > 0 Тогда 
			ОбработатьИзменениеПоказателейНаСервере(Параметр.Показатели);
		КонецЕсли;
		
		Если Параметр.Начисления.Количество() > 0 Тогда 
			ОбработатьИзменениеПоказателейНаСервере(Параметр.Начисления);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоступноЧтениеНачисленийШтатногоРасписания = 
			Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленийШтатногоРасписания,ЧтениеНачисленийШтатногоРасписания", , Ложь);
			
	Организация = Параметры.Организация;
	ДатаВступленияВСилу = Параметры.ДатаВступленияВСилу;
	ЗаполнитьПоИзменениямТарифнойСетки(Параметры.ТарифнаяСетка);
	ЗаполнитьОтображаемыеПоказатели();
	УправлениеШтатнымРасписаниемФормы.ДополнитьФормуИзменяемымиПоказателями(ЭтаФорма, "Позиции");
	ДанныеПоказателейВРеквизитФормы();
	УстановитьВидимостьЭлементовФормы();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыПозиции

&НаКлиенте
Процедура ПозицииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьДанныеПозиции(Элемент.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПриАктивизацииСтроки(Элемент)
	
	УправлениеШтатнымРасписаниемКлиент.ПозицииПриАктивизацииСтроки(ЭтаФорма, Позиции, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииПередУдалением(Элемент, Отказ)
	
	УдалитьНачисленияИЕжегодныеОтпуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ПозицииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ОбработатьВыбранныеПозиции(ВыбранноеЗначение) Тогда
		Если Позиции.Количество() > 0 Тогда
			Элементы.Позиции.ТекущаяСтрока = Позиции[Позиции.Количество() - 1].ПолучитьИдентификатор();
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПозицию(Команда)
	
	ТекущееДействиеСПозицией = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка");
	ВыбратьПозициюИзСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоказатели(Команда)
	
	МассивПоказателей = Новый Массив;
	МассивНачислений = Новый Массив;
	
	Для каждого Показатель Из ОтображаемыеПоказатели Цикл
		
		Если ТипЗнч(Показатель.Значение) = Тип("СправочникСсылка.ПоказателиРасчетаЗарплаты") Тогда
			МассивПоказателей.Добавить(Показатель.Значение);
		Иначе
			МассивНачислений.Добавить(Показатель.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивПоказателей.Количество() = 0 И МассивНачислений.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Нет показателей к заполнению'"));
	Иначе
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РасширенноеРедактирование", Истина);
		ПараметрыФормы.Вставить("МассивПоказателей", МассивПоказателей);
		
		Если МассивНачислений.Количество() > 0 Тогда
			ПараметрыФормы.Вставить("МассивНачислений", МассивНачислений);
		КонецЕсли;
		
		ОткрытьФорму("ОбщаяФорма.ГрупповоеЗаполнениеПоказателейДокументов", ПараметрыФормы, ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВКадровомУчете(Команда)
	
	ДополнительныеПараметры = Новый Структура("ЗаписатьПозиции", Ложь);
	
	Если Модифицированность Тогда 
		ДополнительныеПараметры.ЗаписатьПозиции = Истина;
		ТекстВопроса = НСтр("ru = 'Для продолжения необходимо записать позиции.'") + Символы.ПС + НСтр("ru = 'Продолжить?'"); 
		Оповещение = Новый ОписаниеОповещения("ОтразитьВКадровомУчетеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе 
		ОтразитьВКадровомУчетеЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТекущиеПозицииПодробно(Команда)
	ТекущиеПозицииПодробноНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УпорядочитьСписокПозиций(Команда)
	
	УпорядочитьСписокПозицийНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьПоТекущейКадровойРасстановке(Команда)
	
	ДополнитьПоТекущейКадровойРасстановкеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодборУправленческойПозиции()
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ОрганизационнаяСтруктураКлиент");
		Модуль.ВыбратьУправленческуюПозициюИзСписка(ЭтотОбъект, АдресСпискаПодобранных());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	УстановитьВидимостьКолонокТекущихЗначений();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонокТекущихЗначений()

	ФОИспользоватьВилкуСтавокВШтатномРасписании = ПолучитьФункциональнуюОпциюФормы("ИспользоватьВилкуСтавокВШтатномРасписании");
	Для Каждого ОписаниеПоказателя Из КолонкиПоказателей Цикл
		Показатель = УправлениеШтатнымРасписаниемФормы.ПрефиксЭлементаПоказателиПозиций() + ОписаниеПоказателя.Ключ;
		Если ФОИспользоватьВилкуСтавокВШтатномРасписании Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				Показатель + "МинТекущееЗначение",
				"Видимость",
				ПозицииПодробно);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				Показатель + "МаксТекущееЗначение",
				"Видимость",
				ПозицииПодробно);
		Иначе
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
				Элементы,
				Показатель + "ТекущееЗначение",
				"Видимость",
				ПозицииПодробно);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи) 

	Если ЗаписатьПозиции() И ЗакрытьПослеЗаписи Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьПозиции()
	
	Отказ = Ложь;
	НачатьТранзакцию();
	Для каждого СтрокаПозиции Из Позиции Цикл
						
		ПозицияОбъект = СтрокаПозиции.Позиция.ПолучитьОбъект();
		
		Попытка 
			ПозицияОбъект.Заблокировать();
		Исключение
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось изменить позицию штатного расписания ""%1"".
				|Возможно, данные позиции редактируются другим пользователем'"),
				ПозицияОбъект.Наименование);
			
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			Продолжить;
			
		КонецПопытки;
		
		ЗаполнитьПозицию(ПозицияОбъект, СтрокаПозиции);
			
		Попытка
			ПозицияОбъект.Записать();
		Исключение
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не удалось сохранить изменения в позиции'") + " """ + ПозицияОбъект.Наименование + """",,,,Отказ);
		КонецПопытки;
			
	КонецЦикла;
	Если Отказ Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
		Модифицированность = Ложь;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПозицию(ПозицияОбъект, СтрокаПозиции)
	
	ЗаполнитьЗначенияСвойств(ПозицияОбъект, СтрокаПозиции);
	
	ПозицияОбъект.Начисления.Очистить();
	ПозицияОбъект.Показатели.Очистить();
	ПозицияОбъект.ЕжегодныеОтпуска.Очистить();
	ПозицияОбъект.Специальности.Очистить();
	
	СтруктураОтбора = Новый Структура("ИдентификаторСтрокиПозиции", СтрокаПозиции.ИдентификаторСтрокиПозиции);
	СтрокиНачислений = Начисления.НайтиСтроки(СтруктураОтбора);
	
	Для Каждого СтрокаТаблицы Из СтрокиНачислений Цикл
		ЗаполнитьЗначенияСвойств(ПозицияОбъект.Начисления.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
	СтрокиПоказателей = Показатели.НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаТаблицы Из СтрокиПоказателей Цикл
		ЗаполнитьЗначенияСвойств(ПозицияОбъект.Показатели.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
	СтрокиОтпусков = ЕжегодныеОтпуска.НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаТаблицы Из СтрокиОтпусков Цикл
		ЗаполнитьЗначенияСвойств(ПозицияОбъект.ЕжегодныеОтпуска.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
	СтрокиСпециальностей = Специальности.НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаТаблицы Из СтрокиСпециальностей Цикл
		ЗаполнитьЗначенияСвойств(ПозицияОбъект.Специальности.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("УправленческаяЗарплатаФормы");
		Модуль.ЗаполнитьПозициюОбъектШтатногоРасписания(ПозицияОбъект, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтразитьВКадровомУчетеЗавершение(Ответ, ДополнительныеПараметры) Экспорт 

	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ЗаписатьПозиции Тогда
		
		Попытка
			РезультатЗаписи = ЗаписатьПозиции();
		Исключение
			РезультатЗаписи = Ложь;
		КонецПопытки;
		
		Если Не РезультатЗаписи Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Во время сохранения произошли ошибки. Продолжение невозможно.'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Позиции.Количество() > 0 Тогда
		
		ПараметрыОткрытияФормы = Новый Структура;
		ЗначенияЗаполнения = Новый Структура;
		ЗначенияЗаполнения.Вставить("Организация", 	Организация);
		ЗначенияЗаполнения.Вставить("ДатаИзменения",ДатаВступленияВСилу);
		ЗначенияЗаполнения.Вставить("ЭтоОтражениеИзмененияШтатногоРасписания", Истина);
		ЗначенияЗаполнения.Вставить("УчитыватьКакИндексациюЗаработка", ПолучитьФункциональнуюОпциюФормы("ИспользоватьИндексациюЗаработка"));
		ДолжностиПоШтатномуРасписанию = Новый Массив;
		Для Каждого СтрокаПозиции Из Позиции Цикл
			ДолжностиПоШтатномуРасписанию.Добавить(СтрокаПозиции.Позиция);
		КонецЦикла;
		ЗначенияЗаполнения.Вставить("ДолжностиПоШтатномуРасписанию", ДолжностиПоШтатномуРасписанию);
		
		ПараметрыОткрытияФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.ИзменениеПлановыхНачислений.Форма.ФормаДокумента", ПараметрыОткрытияФормы);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Нет позиций для отражения в кадровом учете.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеПозицииВФорму(АдресДанныхПозиции)
	
	УправлениеШтатнымРасписаниемФормы.ПрочитатьДанныеПозицииВФорму(ЭтаФорма, ЭтаФорма, АдресДанныхПозиции);
	СтрокаПозиции = Позиции.НайтиПоИдентификатору(ИдентификаторРедактируемойСтроки);
	СтрокиПозиций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтрокаПозиции);
	ДанныеПоказателейВРеквизитФормы(СтрокиПозиций);
	РассчитатьИтогиФОТПоПозиции(ИдентификаторРедактируемойСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеПоказателейВРеквизитФормы(СтрокиПозиций = Неопределено)
	
	Если ОтображаемыеПоказатели.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокиПозиций = Неопределено Тогда
		КоллекцияПозиций = Позиции;
	Иначе
		КоллекцияПозиций = СтрокиПозиций;
	КонецЕсли;
	
	Для Каждого СтрокаПозиции Из КоллекцияПозиций Цикл
		УправлениеШтатнымРасписаниемФормы.ЗаполнитьНачисленияПоказателиСтрокиПозиции(ЭтаФорма, СтрокаПозиции, Начисления, Показатели);
	КонецЦикла;
		
	Если ПозицииПодробно Тогда
		ЗаполнитьТекущиеПоказателиПозиций(СтрокиПозиций);
	КонецЕсли;
	
	УстановитьДоступностьКомандыЗаполнитьПоказатели();
	УправлениеШтатнымРасписаниемФормы.ОбновитьИтогиСтрок(ЭтаФорма, Позиции);
	
КонецПроцедуры

&НаСервере
Функция ОбработатьВыбранныеПозиции(ВыбранноеЗначение)
	
	ПозицияДобавлена = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		ВыбранныеПозиции = ВыбранноеЗначение;
	Иначе
		ВыбранныеПозиции = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	КонецЕсли;
	
	Для каждого Позиция Из ВыбранныеПозиции Цикл
		
		СтруктураПоиска = Новый Структура("Позиция", Позиция);
		Если Позиции.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
			
			УправлениеШтатнымРасписаниемФормы.ДобавитьДанныеПоПозиции(ЭтаФорма, Позиция, ДатаВступленияВСилу, ИдентификаторСтрокиПозицииМакс);
			
			ДобавленнаяСтрока = Позиции[Позиции.Количество() - 1];
			Если ЗначениеЗаполнено(ТекущееДействиеСПозицией) Тогда
				ДобавленнаяСтрока.Действие = ТекущееДействиеСПозицией;
			КонецЕсли;
			СтрокиПозиций = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДобавленнаяСтрока);
			ДанныеПоказателейВРеквизитФормы(СтрокиПозиций);
			РассчитатьИтогиФОТПоПозиции(ДобавленнаяСтрока.ПолучитьИдентификатор());
			ПозицияДобавлена = Истина;
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ПозицияДобавлена;
	
КонецФункции

&НаСервере
Процедура ТекущиеПозицииПодробноНаСервере()
	Пометка = ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(ЭтотОбъект.Элементы, "ПозицииТекущиеПозицииПодробно", "Пометка");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(ЭтотОбъект.Элементы, "ПозицииТекущиеПозицииПодробно", "Пометка", Не Пометка);
	ПозицииПодробно = Не Пометка;
	
	Если ПозицииПодробно Тогда
		ЗаполнитьТекущиеПоказателиПозиций();
	КонецЕсли;
	УстановитьВидимостьКолонокТекущихЗначений();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущиеПоказателиПозиций(СтрокиПозиций = Неопределено)

	Если СтрокиПозиций = Неопределено Тогда
		КоллекцияПозиций = Позиции;
	Иначе
		КоллекцияПозиций = СтрокиПозиций;
	КонецЕсли;
	
	МассивПозиций = ОбщегоНазначения.ВыгрузитьКолонку(КоллекцияПозиций, "Позиция");
	ДанныеПозиций = УправлениеШтатнымРасписанием.ДанныеПозицийШтатногоРасписания(Истина, МассивПозиций, ДатаВступленияВСилу);
	СведенияОПоказателях = ПлановыеНачисленияСотрудников.СведенияОПоказателях(ОтображаемыеПоказатели);
	
	Для Каждого СтрокаПозиции Из КоллекцияПозиций Цикл
		
		ДанныеПозиции = ДанныеПозиций[СтрокаПозиции.Позиция];
		Для Каждого СтрокаНачисления Из ДанныеПозиции.Начисления Цикл
			ИнфоОПоказателе = СведенияОПоказателях[СтрокаНачисления.Начисление];
			Если ИнфоОПоказателе <> Неопределено Тогда
				УправлениеШтатнымРасписаниемФормы.УстановитьТекущиеЗначенияНачисленийСтрокиПозиции(ЭтаФорма, СтрокаПозиции, ИнфоОПоказателе, СтрокаНачисления);
			КонецЕсли;
			Для Каждого СтрокаПоказателя Из СтрокаНачисления.Показатели Цикл
				ИнфоОПоказателе = СведенияОПоказателях[СтрокаПоказателя.Показатель];
				Если ИнфоОПоказателе <> Неопределено Тогда
					УправлениеШтатнымРасписаниемФормы.УстановитьТекущиеЗначенияПоказателейСтрокиПозиции(ЭтаФорма, СтрокаПозиции, ИнфоОПоказателе, СтрокаПоказателя);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьИтогиФОТПоПозиции(ИдентификаторТекущейСтроки)
	
	ДанныеТекущейПозиции = Позиции.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
	ДанныеНачислений = Начисления.Выгрузить(Новый Структура("ИдентификаторСтрокиПозиции", ДанныеТекущейПозиции.ИдентификаторСтрокиПозиции));
	УправлениеШтатнымРасписанием.РассчитатьИтогиФОТПоПозиции(ЭтаФорма, ДанныеТекущейПозиции, ДанныеНачислений, ОписаниеТаблицыНачислений());
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма, Позиции);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандыЗаполнитьПоказатели()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПозицииЗаполнитьПоказатели",
		"Доступность",
		УправлениеШтатнымРасписаниемФормы.ЕстьРедактируемыеПоказатели(КолонкиПоказателей));
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьИзменениеПоказателейНаСервере(ЗначенияПоказателей)
	
	ФОИспользоватьВилкуСтавокВШтатномРасписании = ПолучитьФункциональнуюОпциюФормы("ИспользоватьВилкуСтавокВШтатномРасписании");
	МассивИзмененныхПозиций = Новый Массив;
	СтруктураПоискаПоказателя = Новый Структура("ИдентификаторСтрокиПозиции, Показатель");
	СтруктураПоискаНачисления = Новый Структура("ИдентификаторСтрокиПозиции, Начисление");
	Для Каждого СтрокаПозиции Из Позиции Цикл
		
		Для каждого КолонкаПоказатель Из КолонкиПоказателей Цикл
			Показатель = КолонкаПоказатель.Значение.Показатель;
			ДействиеПоказателя = ЗначенияПоказателей[Показатель];
			Если ДействиеПоказателя = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если Не УправлениеШтатнымРасписаниемФормы.ПоказательИспользуется(СтрокаПозиции, КолонкаПоказатель.Ключ) Тогда
				Продолжить;
			КонецЕсли;
			
			ИмяПоказателя = КолонкаПоказатель.Ключ;
			Если ФОИспользоватьВилкуСтавокВШтатномРасписании Тогда
				ПоказательМин = ИмяПоказателя + "Мин";
				ПоказательМакс = ИмяПоказателя + "Макс";
				ПлановыеНачисленияСотрудниковФормы.РассчитатьЗначениеПоказателяНачисления(СтрокаПозиции[ПоказательМин], ДействиеПоказателя, Показатель);	
				ПлановыеНачисленияСотрудниковФормы.РассчитатьЗначениеПоказателяНачисления(СтрокаПозиции[ПоказательМакс], ДействиеПоказателя, Показатель);	
			Иначе
				ПлановыеНачисленияСотрудниковФормы.РассчитатьЗначениеПоказателяНачисления(СтрокаПозиции[ИмяПоказателя], ДействиеПоказателя, Показатель);
			КонецЕсли;
			
			СтруктураПоискаПоказателя.ИдентификаторСтрокиПозиции = СтрокаПозиции.ИдентификаторСтрокиПозиции;
			СтруктураПоискаПоказателя.Показатель = Показатель;
			СтрокиПоказателей = Показатели.НайтиСтроки(СтруктураПоискаПоказателя);
			
			Если СтрокиПоказателей.Количество() > 0 Тогда
				МассивИзмененныхПозиций.Добавить(СтрокаПозиции.Позиция);
			КонецЕсли;
			Для Каждого СтрокаПоказателя Из СтрокиПоказателей Цикл
			
				Если ФОИспользоватьВилкуСтавокВШтатномРасписании Тогда
					СтрокаПоказателя["ЗначениеМин"] = СтрокаПозиции[ПоказательМин];
					СтрокаПоказателя["ЗначениеМакс"] = СтрокаПозиции[ПоказательМакс];
				Иначе
					СтрокаПоказателя["Значение"] = СтрокаПозиции[ИмяПоказателя];
				КонецЕсли; 
				
			КонецЦикла;
			
			СтруктураПоискаНачисления.ИдентификаторСтрокиПозиции = СтрокаПозиции.ИдентификаторСтрокиПозиции;
			СтруктураПоискаНачисления.Начисление = Показатель;
			СтрокиНачислений = Начисления.НайтиСтроки(СтруктураПоискаНачисления);
			
			Если СтрокиНачислений.Количество() > 0 Тогда
				МассивИзмененныхПозиций.Добавить(СтрокаПозиции.Позиция);
			КонецЕсли;
			Для Каждого СтрокиНачисления Из СтрокиНачислений Цикл
			
				Если ФОИспользоватьВилкуСтавокВШтатномРасписании Тогда
					СтрокиНачисления["РазмерМин"] = СтрокаПозиции[ПоказательМин];
					СтрокиНачисления["РазмерМакс"] = СтрокаПозиции[ПоказательМакс];
				Иначе
					СтрокиНачисления["Размер"] = СтрокаПозиции[ИмяПоказателя];
				КонецЕсли; 
				
			КонецЦикла; 
		КонецЦикла;
	КонецЦикла;
	
	УправлениеШтатнымРасписанием.РассчитатьФОТПозицийШтатногоРасписания(ЭтаФорма, ДатаВступленияВСилу, МассивИзмененныхПозиций);
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма, Позиции);
	УправлениеШтатнымРасписаниемФормы.ПоместитьДанныеОбъектаВДанныеФормы(ЭтаФорма, , ДатаВступленияВСилу);
	УстановитьДоступностьКомандыЗаполнитьПоказатели();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений();
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "";
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыПозиций()
	
	ОписаниеТаблицыПозиций = УправлениеШтатнымРасписаниемКлиентСервер.ОписаниеТаблицыПозиций();
	ОписаниеТаблицыПозиций.ПутьКДанным = "Позиции";
	Возврат ОписаниеТаблицыПозиций;
	
КонецФункции

&НаСервере
Процедура УдалитьНачисленияИЕжегодныеОтпуска() Экспорт
	
	УправлениеШтатнымРасписаниемФормы.УдалитьНачисленияИЕжегодныеОтпуска(Элементы.Позиции.ВыделенныеСтроки, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПозициюИзСписка(МножественныйВыбор = Истина)
	
	СтруктураОтбор = Новый Структура;
	СтруктураОтбор.Вставить("Владелец", Организация);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбор);
	ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытия.Вставить("МножественныйВыбор", МножественныйВыбор);
	ПараметрыОткрытия.Вставить("СкрытьПанельВводаДокументов", Истина);
	ПараметрыОткрытия.Вставить("АдресСпискаПодобранных", АдресСпискаПодобранных());
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаВыбора", ПараметрыОткрытия, Элементы.Позиции);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеПозиции(ИдентификаторСтрокиТекущейПозиции)
	
	ДанныеПозиции = ОписаниеДанныхПозицииВХранилище(ИдентификаторСтрокиТекущейПозиции);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", ДанныеПозиции.Ключ);
	ПараметрыОткрытия.Вставить("АдресДанныхПозицииВХранилище", ДанныеПозиции.АдресДанныхПозицииВХранилище);
	
	ОткрытьФорму("Справочник.ШтатноеРасписание.ФормаОбъекта", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеДанныхПозицииВХранилище(ИдентификаторСтрокиТекущейПозиции)
	
	Возврат УправлениеШтатнымРасписаниемФормы.ОписаниеДанныхПозицииВХранилище(ЭтаФорма, ЭтаФорма, ИдентификаторСтрокиТекущейПозиции, ДатаВступленияВСилу);
	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранных()
	
	Возврат ПоместитьВоВременноеХранилище(Позиции.Выгрузить(, "Позиция").ВыгрузитьКолонку("Позиция"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура УпорядочитьСписокПозицийНаСервере()
	
	УправлениеШтатнымРасписанием.УпорядочитьСписокПозиций(Позиции);
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеТаблицыНачисленийНаКлиенте() Экспорт
	
	Возврат ОписаниеТаблицыНачислений();
	
КонецФункции

&НаСервере
Функция ОписаниеТаблицыНачисленийНаСервере() Экспорт
	
	Возврат ОписаниеТаблицыНачислений();
	
КонецФункции

&НаКлиенте
Функция ОписаниеТаблицыПозицийНаКлиенте() Экспорт
	
	Возврат ОписаниеТаблицыПозиций();
	
КонецФункции

&НаСервере
Функция ОписаниеТаблицыПозицийНаСервере() Экспорт
	
	Возврат ОписаниеТаблицыПозиций();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("Позиции") Тогда
		Позиции.Загрузить(ДанныеЗаполнения.Позиции);
	КонецЕсли; 
	
	Если ДанныеЗаполнения.Свойство("Начисления") Тогда
		Начисления.Загрузить(ДанныеЗаполнения.Начисления);
	КонецЕсли; 
	
	Если ДанныеЗаполнения.Свойство("Показатели") Тогда
		Показатели.Загрузить(ДанныеЗаполнения.Показатели);
	КонецЕсли; 
	
	Если ДанныеЗаполнения.Свойство("ЕжегодныеОтпуска") Тогда
		ЕжегодныеОтпуска.Загрузить(ДанныеЗаполнения.ЕжегодныеОтпуска);
	КонецЕсли; 
	
	Если ДанныеЗаполнения.Свойство("Специальности") Тогда
		Специальности.Загрузить(ДанныеЗаполнения.Специальности);
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоИзменениямТарифнойСетки(ТарифнаяСетка)
	
	РезультатЗапроса = УправлениеШтатнымРасписанием.РезультатЗапросаПоИзменениямПозицийШтатногоРасписания(
			ТарифнаяСетка, Организация, ДатаВступленияВСилу);
			
	Если РезультатЗапроса <> Неопределено Тогда
			
		ТаблицаПозицийКИзменению = РезультатЗапроса.Выгрузить();
		УправлениеШтатнымРасписанием.ЗаполнитьОбъектИзменениямиПозицийШтатногоРасписания(ЭтаФорма, ТаблицаПозицийКИзменению, ТарифнаяСетка);
		УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма, Позиции);
		УправлениеШтатнымРасписаниемФормы.ПоместитьДанныеОбъектаВДанныеФормы(ЭтаФорма, , ДатаВступленияВСилу);
		Модифицированность = Истина;
		
	КонецЕсли;
		
КонецПроцедуры

#Область ОтображаемыеПоказатели

&НаКлиенте
Процедура ОтображаемыеПоказатели(Команда)

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВыбранныеПоказатели", ОтображаемыеПоказатели);
	ПараметрыФормы.Вставить("ЗаголовокФормы", "Отображаемые показатели");
	ОбработчикЗавершения = Новый ОписаниеОповещения("ФормаВыбораПоказателейПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораПоказателей", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор, , , ОбработчикЗавершения);

КонецПроцедуры

&НаКлиенте
Процедура ФормаВыбораПоказателейПослеЗакрытия(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ФормаВыбораПоказателейПослеЗакрытияНаСервере(РезультатЗакрытия);
	
КонецПроцедуры

&НаСервере
Процедура ФормаВыбораПоказателейПослеЗакрытияНаСервере(РезультатЗакрытия) Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"ОбщаяФорма.ФормаВыбораПоказателей",
		"ОтображаемыеПоказатели",
		РезультатЗакрытия,
		,
		ИмяПользователя());
		
	ОтображаемыеПоказатели = РезультатЗакрытия;
	УправлениеШтатнымРасписаниемФормы.ДополнитьФормуИзменяемымиПоказателями(ЭтаФорма, "Позиции");
	УстановитьВидимостьКолонокТекущихЗначений();
	ДанныеПоказателейВРеквизитФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтображаемыеПоказатели()
	
	ПоказателиСовокупнойТарифнойСтавки = ПлановыеНачисленияСотрудников.ПоказателиНачислений();
	ОтображаемыеПоказателиПоУмолчанию = Новый СписокЗначений;
	Для Каждого СтрокаПоказателя Из ПоказателиСовокупнойТарифнойСтавки Цикл
		Если СтрокаПоказателя.ИспользуетсяВСовокупнойТарифнойСтавке = Истина Тогда
			ОтображаемыеПоказателиПоУмолчанию.Добавить(СтрокаПоказателя.Показатель);
		КонецЕсли;
	КонецЦикла;
	
	ОтображаемыеПоказатели = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
		"ОбщаяФорма.ФормаВыбораПоказателей",
		"ОтображаемыеПоказатели",
		ОтображаемыеПоказателиПоУмолчанию,
		,
		ИмяПользователя());
	
КонецПроцедуры

#КонецОбласти 

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции механизма выполнения длительных операций.

&НаКлиенте
Процедура ДополнитьПоТекущейКадровойРасстановкеНаКлиенте()
	
	ОчиститьСообщения();
	
	РезультатРаботыЗадания = ДополнитьПоТекущейКадровойРасстановкеНаСервере();
	
	Если Не РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = РезультатРаботыЗадания.ИдентификаторЗадания;
		АдресХранилища		 = РезультатРаботыЗадания.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДополнитьПоТекущейКадровойРасстановкеНаСервере()
	
	ПараметрыВыполнения = Новый Структура("Организация,ДатаВступленияВСилу");
	ЗаполнитьЗначенияСвойств(ПараметрыВыполнения, ЭтотОбъект);
	
	ПараметрыВыполнения.Вставить("Позиции", Позиции.Выгрузить());
	ПараметрыВыполнения.Вставить("Начисления", Начисления.Выгрузить());
	ПараметрыВыполнения.Вставить("Показатели", Показатели.Выгрузить());
	ПараметрыВыполнения.Вставить("ЕжегодныеОтпуска", ЕжегодныеОтпуска.Выгрузить());
	ПараметрыВыполнения.Вставить("Специальности", Специальности.Выгрузить());
	
	НаименованиеЗадания = НСтр("ru = 'Формирование позиций штатного расписания""'");
	
	РезультатРаботыЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"УправлениеШтатнымРасписаниемФормы.ДополнитьПоТекущейКадровойРасстановке",
		ПараметрыВыполнения,
		НаименованиеЗадания);
	
	АдресХранилища = РезультатРаботыЗадания.АдресХранилища;
	
	Если РезультатРаботыЗадания.ЗаданиеВыполнено Тогда
		ЗаполнениеПослеВыполненияДлительнойОперации();
	КонецЕсли;
	
	Возврат РезультатРаботыЗадания;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция СообщенияФоновогоЗадания(ИдентификаторЗадания)
	
	СообщенияПользователю = Новый Массив;
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		СообщенияПользователю = ФоновоеЗадание.ПолучитьСообщенияПользователю();
	КонецЕсли;
	
	Возврат СообщенияПользователю;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				Состояние(НСтр("ru='Процесс формирования кадровых приказов завершен'"));
				ЗаполнениеПослеВыполненияДлительнойОперации();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания(
					"Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал,
					Истина);
			КонецЕсли;
				
		КонецЕсли;
		
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		
		СообщенияПользователю = СообщенияФоновогоЗадания(ИдентификаторЗадания);
		Если СообщенияПользователю <> Неопределено Тогда
			Для каждого СообщениеФоновогоЗадания Из СообщенияПользователю Цикл
				СообщениеФоновогоЗадания.Сообщить();
			КонецЦикла;
		КонецЕсли;
		
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеПослеВыполненияДлительнойОперации()
	
	ДанныеЗаполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
	УправлениеШтатнымРасписаниемФормы.ПоместитьДанныеОбъектаВДанныеФормы(ЭтаФорма, , ДанныеЗаполнения.ДатаВступленияВСилу);
	
	Если Позиции.Количество() > 0 Тогда
		Элементы.Позиции.ТекущаяСтрока = Позиции[0].ПолучитьИдентификатор();
	КонецЕсли; 
	
	УправлениеШтатнымРасписаниемКлиентСервер.ЗаполнитьИтоговыйФОТПоПозициям(ЭтаФорма, Позиции);
	
КонецПроцедуры

#КонецОбласти