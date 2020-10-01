////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму списка заказов из обработки "СервисДоставки".
//
// Параметры:
//  Параметры - Структура - структура параметров открытия формы.
//
Процедура ОткрытьФормуСпискаЗаказовНаДоставку(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = Новый Структура();
	КонецЕсли;

	ОчиститьСообщения();
	
	ЕстьПодключениеКСервису = Неопределено;
	СервисДоставкиВызовСервера.ПроверитьПодключениеИнтернетПоддержки(ЕстьПодключениеКСервису);
	
	Если Не ЕстьПодключениеКСервису Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			Новый ОписаниеОповещения("ОткрытьФормуСпискаЗаказовНаДоставкуЗавершение", ЭтотОбъект, Параметры), ЭтотОбъект);
		
	Иначе
		ОткрытьФормуСпискаЗаказовНаДоставкуЗавершение(Новый Структура(), Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму отслеживания заказов из обработки "СервисДоставки".
//
// Параметры:
//  Параметры - Структура - структура параметров открытия формы.
//
Процедура ОткрытьФормуОтслеживанияЗаказа(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = Новый Структура();
	КонецЕсли;

	ОчиститьСообщения();
	
	ЕстьПодключениеКСервису = Неопределено;
	СервисДоставкиВызовСервера.ПроверитьПодключениеИнтернетПоддержки(ЕстьПодключениеКСервису);
	
	Если Не ЕстьПодключениеКСервису Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			Новый ОписаниеОповещения("ОткрытьФормуОтслеживанияЗаказаЗавершение", ЭтотОбъект, Параметры), ЭтотОбъект);
		
	Иначе
		ОткрытьФормуОтслеживанияЗаказаЗавершение(Новый Структура(), Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму карточки заказа на доставку из обработки "СервисДоставки".
//
// Параметры:
//  Параметры - Структура - см. СервисДоставки.НовыйПараметрыЗаказаНаДоставку().
//
Процедура ОткрытьФормуКарточкиЗаказаНаДоставку(Параметры = Неопределено) Экспорт
	
	Если Параметры = Неопределено Тогда
		Параметры = Новый Структура();
	КонецЕсли;
	
	ОчиститьСообщения();
	
	ЕстьПодключениеКСервису = Неопределено;
	СервисДоставкиВызовСервера.ПроверитьПодключениеИнтернетПоддержки(ЕстьПодключениеКСервису);
	
	Если Не ЕстьПодключениеКСервису Тогда
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(
			Новый ОписаниеОповещения("ОткрытьФормуКарточкиЗаказаНаДоставкуЗавершение", ЭтотОбъект, Параметры), ЭтотОбъект);
		
	Иначе
		ОткрытьФормуКарточкиЗаказаНаДоставкуЗавершение(Новый Структура(), Параметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбработатьРезультатФоновогоЗадания(Результат, ДополнительныеПараметры, Отказ = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		// Фоновое задание отменено пользователем.
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ВыводитьОкноОжидания = Неопределено
		ИЛИ Не ДополнительныеПараметры.ВыводитьОкноОжидания Тогда
		Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("Сообщения") Тогда
			
			Для каждого ЭлементКоллекции Из Результат.Сообщения Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(ЭлементКоллекции.Текст,
					ЭлементКоллекции.КлючДанных, ЭлементКоллекции.Поле, ЭлементКоллекции.ПутьКДанным);
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.Свойство("Статус") И Результат.Статус = "Ошибка" Тогда
		
		Если ЗначениеЗаполнено(Результат.ПодробноеПредставлениеОшибки) Тогда
			ТекстСообщения = Результат.ПодробноеПредставлениеОшибки;
		ИначеЕсли ЗначениеЗаполнено(Результат.КраткоеПредставлениеОшибки) Тогда
			ТекстСообщения = Результат.КраткоеПредставлениеОшибки;
		Иначе
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения операции'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередОткрытиемФормыВыбора(Параметры, ИмяСправочника) Экспорт
	
	Если ИмяСправочника = "АдресКонтрагентаСервисДоставки" Тогда
		Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Контрагент") Тогда
			Параметры.Вставить("Контрагент", Параметры.Отбор.Контрагент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуКарточкиЗаказаНаДоставкуЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОснование = Неопределено;
	Параметры.Свойство("ДокументОснование", ДокументОснование);
	
	Если Не Параметры.Свойство("РежимМастера") Тогда
		Параметры.Вставить("РежимМастера", 0);
	КонецЕсли;
	
	Уникальность = Неопределено;
	Если Параметры.РежимМастера = 0 Тогда
		Если ЗначениеЗаполнено(ДокументОснование) Тогда
			ПараметрыЗаказа = ПараметрыЗаказаНаДоставкуПоДокументуОснованию(ДокументОснование);
			Параметры.Вставить("ОрганизацияБизнесСетиСсылка", ПараметрыЗаказа.ОрганизацияБизнесСетиСсылка);
			Параметры.Вставить("ПараметрыЗаказа", ПараметрыЗаказа);
			Уникальность = ДокументОснование;
		КонецЕсли
	Иначе
		Если Параметры.РежимМастера <> 0 Тогда
			Уникальность = Параметры.ИдентификаторЗаказа;
		КонецЕсли;
	КонецЕсли;
	
	ОрганизацияБизнесСетиСсылка = Неопределено;
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
		ОрганизацияБизнесСетиСсылка = СервисДоставкиВызовСервера.ОрганизацияПоУмолчанию();
		
		Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
			
			Параметры.Вставить("ИмяФормы", "КарточкаЗаказа");
			ОткрытьФормуВыбора("ОрганизацияСервисДоставки",Параметры,"ВыборОрганизацииПродолжение");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	ОткрытьФормуСервисаДоставкиСВопросом(Параметры, "КарточкаЗаказа", Уникальность);
	
КонецПроцедуры

Процедура ОткрытьФормуСпискаЗаказовНаДоставкуЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияБизнесСетиСсылка = Неопределено;
	Параметры.Свойство("ОрганизацияБизнесСети", ОрганизацияБизнесСетиСсылка);
	
	Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
		
		ОрганизацияБизнесСетиСсылка = СервисДоставкиВызовСервера.ОрганизацияПоУмолчанию();
		
		Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
			
			Параметры.Вставить("ИмяФормы", "СписокЗаказов");
			ОткрытьФормуВыбора("ОрганизацияСервисДоставки",Параметры,"ВыборОрганизацииПродолжение");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	ОткрытьФормуСервисаДоставкиСВопросом(Параметры, "СписокЗаказов")
	
КонецПроцедуры

Процедура ОткрытьФормуОтслеживанияЗаказаЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияБизнесСетиСсылка = Неопределено;
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
		
		ОрганизацияБизнесСетиСсылка = СервисДоставкиВызовСервера.ОрганизацияПоУмолчанию();
		
		Если Не ЗначениеЗаполнено(ОрганизацияБизнесСетиСсылка) Тогда
			
			Параметры.Вставить("ИмяФормы", "ОтслеживаниеЗаказа");
			ОткрытьФормуВыбора("ОрганизацияСервисДоставки",Параметры,"ВыборОрганизацииПродолжение");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Параметры.Вставить("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	ОткрытьФормуСервисаДоставкиСВопросом(Параметры, "ОтслеживаниеЗаказа")
	
КонецПроцедуры

Процедура ОбработатьВыборЗначения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборОрганизацииПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры.Вставить("ОрганизацияБизнесСетиСсылка", Результат);
	
	НастройкиФормы = Новый Соответствие();
	НастройкиФормы.Вставить("ОрганизацияБизнесСетиСсылка", Результат);
	СервисДоставкиВызовСервера.СохранитьНастройкиФормыСпискаЗаказов(НастройкиФормы);
	
	ОткрытьФормуСервисаДоставкиСВопросом(ДополнительныеПараметры, ДополнительныеПараметры.ИмяФормы);
	
КонецПроцедуры

Процедура ПроверитьОрганизациюБизнесСетиСВопросом(Параметры, Отказ) Экспорт
	
	ОрганизацияБизнесСетиСсылка = Неопределено;
	Параметры.Свойство("ОрганизацияБизнесСетиСсылка", ОрганизацияБизнесСетиСсылка);
	
	Если Не СервисДоставкиВызовСервера.ОрганизацияПодключена(ОрганизацияБизнесСетиСсылка) Тогда
		ТекстВопроса = НСтр("ru='Организация ""%1"" не подключена в сервисе 1С:Бизнес-сеть. Подключить сейчас?'") + Символы.ПС + Символы.ПС
		+ НСтр("ru='При нажатии ""Да"" откроется форма подключения организации,'") + Символы.ПС
		+ НСтр("ru='при нажатии ""Нет"" откроется форма выбора подключенной организации,'") + Символы.ПС
		+ НСтр("ru='при нажатии ""Отмена"" текущее действие будет отменено.'");
		
		ТекстВопроса = СтрШаблон(ТекстВопроса, ОрганизацияБизнесСетиСсылка);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьОрганизациюПослеВопроса", ЭтотОбъект, Параметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОрганизациюПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПодключитьОрганизациюЗавершение", ЭтотОбъект, Параметры);
		БизнесСетьСлужебныйКлиент.ОткрытьФормуПодключенияОрганизации(Параметры.ОрганизацияБизнесСетиСсылка, ЭтотОбъект, ОписаниеОповещенияОЗакрытии);
	Иначе
		ОткрытьФормуВыбора("ОрганизацияСервисДоставки", Параметры, "ВыборОрганизацииПродолжение");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодключитьОрганизациюЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяФормы") Тогда
		ОткрытьФорму("Обработка.СервисДоставки.Форма." + Параметры.ИмяФормы,
			Параметры,,
			Параметры.Уникальность,,,,
			РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьБлокОшибок(Результат, ОперацияВыполнена) Экспорт
	
	Если Результат.Свойство("Ошибки") Тогда
		Если ТипЗнч(Результат.Ошибки) = Тип("Массив") Тогда
			Для Каждого ТекущаяОшибка Из Результат.Ошибки Цикл
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекущаяОшибка);
			КонецЦикла;
		КонецЕсли;
		ОперацияВыполнена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Конструктор состояния заказа.
//
// Параметры:
// 
// Возвращаемое значение:
//  Структура -
//    * Наименование 	- Строка - наименование состояния или группы состояний заказа.
//    * Идентификатор 	- Строка - идентификатор состояния или группы.
//    * ЭтоГруппа 		- Булево - признак группы состояний.
//
Функция ПараметрыСостоянияЗаказа() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Наименование", "");
	Результат.Вставить("Идентификатор", "");
	Результат.Вставить("ЭтоГруппа", Ложь);
	
	Возврат Результат;
	
КонецФункции

Функция ТолькоЦифры(Знач Строка) Экспорт
	
	ЛишниеСимволы = СтрСоединить(СтрРазделить(Строка, "0123456789"), "");
	Результат     = СтрСоединить(СтрРазделить(Строка, ЛишниеСимволы), "");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыЗаказаНаДоставкуПоДокументуОснованию(Основание)
	
	Возврат СервисДоставкиВызовСервера.ПараметрыЗаказаНаДоставкуПоДокументуОснованию(Основание);
	
КонецФункции

Процедура ОткрытьФормуВыбора(ИмяСправочника, ПараметрыОтбора = Неопределено, ИмяПроцедурыОбработки="ОбработатьВыборЗначения")
	
	ИмяФормыВыбора = СервисДоставкиВызовСервера.ИмяФормыВыбораПоОпределяемомуТипу(ИмяСправочника);
	
	Если ИмяФормыВыбора <> "" Тогда
		
		ПараметрыОткрытия = Новый Структура();
		ПараметрыОткрытия.Вставить("Отбор", ПараметрыОтбора);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		ПередОткрытиемФормыВыбора(ПараметрыОткрытия, ИмяСправочника);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОбработки, ЭтотОбъект, ПараметрыОтбора);
		ОткрытьФорму(
			ИмяФормыВыбора,
			ПараметрыОткрытия,
			,,,,ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуСервисаДоставкиСВопросом(Параметры, ИмяФормы, Уникальность = Неопределено)
	
	Отказ = Ложь;
	Параметры.Вставить("ИмяФормы", ИмяФормы);
	Параметры.Вставить("Уникальность", Уникальность);
	
	ПроверитьОрганизациюБизнесСетиСВопросом(Параметры, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("Обработка.СервисДоставки.Форма.КарточкаЗаказа.ОткрытьФормуКарточкиЗаказаНаДоставку");
	
	ОткрытьФорму("Обработка.СервисДоставки.Форма." + ИмяФормы,
		Параметры,,
		Уникальность,,,,
		РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

#КонецОбласти
