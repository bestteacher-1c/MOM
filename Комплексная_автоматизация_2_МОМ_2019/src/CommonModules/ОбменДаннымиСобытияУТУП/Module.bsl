
#Область ПрограммныйИнтерфейс


//++ НЕ УТ
#Область ОбменУправлениеПредприятиемДокументооборот20

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемДокументооборот20ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемДокументооборот20ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемДокументооборот20ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеПредприятиемДокументооборот20", Источник, Отказ, Замещение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25ПередЗаписью(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник        - ДокументОбъект - источник события.
//  Отказ           - Булево - флаг отказа от выполнения обработчика.
//  РежимЗаписи     - РежимЗаписиДокумента - см. в синтаксис-помощнике РежимЗаписиДокумента.
//  РежимПроведения - РежимПроведенияДокумента - см. в синтаксис-помощнике РежимПроведенияДокумента.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25ПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25", Источник, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25ПередУдалением(Источник, Отказ) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25", Источник, Отказ);
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура ОбменДаннымиОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25ПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("ОбменУправлениеПредприятиемЗарплатаИУправлениеПерсоналом25", Источник, Отказ, Замещение);
	
КонецПроцедуры

#КонецОбласти
//-- НЕ УТ

#Область ОбменПолный

// Процедура-обработчик события "ПередЗаписью" ссылочных типов данных (кроме документов) для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события, кроме типа ДокументОбъект
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписью(Источник, Отказ) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписью("Полный", Источник, Отказ);
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" документов для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - ДокументОбъект - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюДокумента("Полный", Источник, Отказ, РежимЗаписи, РежимПроведения);
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" константы для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - КонстантаМенеджерЗначения - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюКонстанты(Источник, Отказ) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты("Полный", Источник, Отказ);
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - НаборЗаписейРегистра - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика
//  Замещение      - Булево - признак замещения существующего набора записей.
// 
Процедура ОбменДаннымиПолныйПередЗаписьюРегистра(Источник, Отказ, Замещение) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Полный", Источник, Отказ, Замещение);
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередЗаписью" регистров расчета для механизма регистрации объектов на узлах.
//
// Параметры:
//		Источник	- НаборЗаписейРегистра - источник события.
//		Отказ		- Булево - флаг отказа от выполнения обработчика.
//		Замещение	- Булево - признак замещения существующего набора записей.
//
Процедура ОбменДаннымиПолныйПередЗаписьюНабораРасчета(Источник, Отказ, Замещение, ТолькоЗапись, ЗаписьФактическогоПериодаДействия, ЗаписьПерерасчетов) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередЗаписьюРегистра("Полный", Источник, Отказ, Замещение);
		
//++ НЕ УТ
		Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
			Возврат;
		КонецЕсли;
//-- НЕ УТ
		
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Процедура-обработчик события "ПередУдалением" ссылочных типов данных для механизма регистрации объектов на узлах.
//
// Параметры:
//  ИмяПланаОбмена - Строка - имя плана обмена, для которого выполняется механизм регистрации
//  Источник       - источник события
//  Отказ          - Булево - флаг отказа от выполнения обработчика.
// 
Процедура ОбменДаннымиПолныйПередУдалением(Источник, Отказ) Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиСобытия.МеханизмРегистрацииОбъектовПередУдалением("Полный", Источник, Отказ);
	КонецЕсли;
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РегистрацияИзмененийДляНачальнойВыгрузкиДанных

// Выполняет регистрацию изменений для начальной выгрузки данных с учетом даты начала выгрузки и списка организаций.
// Процедура является универсальной и может быть использована для регистрации изменений данных по дате начала выгрузки
// и списку организаций для объектных типов данных и наборов записей регистров.
// Если список организаций не задан (Организации = Неопределено), то изменения регистрируются только по дате начала выгрузки.
// Регистрации подлежат данные для всех объектов метаданных, включенных в состав плана обмена.
// Если для объекта метаданных в составе плана обмена установлен признак авторегистрации
// или если признак авторегистрации не установлен и правила регистрации не заданы,
// то регистрация изменений будет выполнена безусловно для всех данных этого типа.
// Если для объекта метаданных заданы правила регистрации, то регистрация изменений будет выполнена 
// с учетом даты начала выгрузки и списка организаций.
// Для документов поддерживается регистрация изменений по дате начала выгрузки и по списку организаций.
// Для бизнес-процессов и для задач поддерживается регистрация изменений по дате начала выгрузки.
// Для наборов записей регистров поддерживается регистрация изменений по дате начала выгрузки и по списку организаций.
// Данная процедура может служить прототипом для разработки собственных процедур регистрации изменений
// для начальной выгрузки данных.
//
// Параметры:
//  Получатель         - ПланОбменаСсылка - Узел плана обмена, для которого требуется выполнить регистрацию изменений данных.
//  ДатаНачалаВыгрузки - Дата - Дата, относительно которой необходимо выполнить регистрацию изменений данных для выгрузки.
//                       Изменения будут зарегистрированы для данных, которые на оси времени располагаются после этой даты.
//  Организации        - Массив - Список организаций, для которых необходимо выполнить регистрацию изменений данных.
//                       Если параметр не задан, то организации не будут учитываться при регистрации изменений.
//
Процедура ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям(Знач Получатель, ДатаНачалаВыгрузки, Организации = Неопределено, Данные = Неопределено) Экспорт
	
	ОтборПоОрганизациям = (Организации <> Неопределено);
	ОтборПоДатеНачалаВыгрузки = ЗначениеЗаполнено(ДатаНачалаВыгрузки);
	
	Если Не ОтборПоОрганизациям И Не ОтборПоДатеНачалаВыгрузки Тогда
		
		Если ТипЗнч(Данные) = Тип("Массив") Тогда
			
			Для Каждого ОбъектМетаданных Из Данные Цикл
				
				ПланыОбмена.ЗарегистрироватьИзменения(Получатель, ОбъектМетаданных);
				
			КонецЦикла;
			
		Иначе
			
			ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Данные);
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ОтборПоДатеНачалаВыгрузкиИОрганизациям = ОтборПоДатеНачалаВыгрузки И ОтборПоОрганизациям;
	
	ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Получатель);
	
	СоставПланаОбмена = Метаданные.ПланыОбмена[ИмяПланаОбмена].Состав;
	
	ИспользоватьФильтрПоМетаданным = (ТипЗнч(Данные) = Тип("Массив"));
	
	Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
		
		Если ИспользоватьФильтрПоМетаданным
			И Данные.Найти(ЭлементСоставаПланаОбмена.Метаданные) = Неопределено
			// При принудительной регистрации не запускается алгоритм правил регистрации.
			// Документы РПС, не выгружаются, на их основании должен быть зарегистрирован к обмену отчёт о розничных продажах.
			ИЛИ ЭлементСоставаПланаОбмена.Метаданные = Метаданные.Документы.РеализацияПодарочныхСертификатов Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ПолноеИмяОбъекта = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		
		Если ЭлементСоставаПланаОбмена.АвтоРегистрация = АвтоРегистрацияИзменений.Запретить
			И ОбменДаннымиПовтИсп.ПравилаРегистрацииОбъектаСуществуют(ИмяПланаОбмена, ПолноеИмяОбъекта) Тогда
			
			Если ОбщегоНазначения.ЭтоСправочник(ЭлементСоставаПланаОбмена.Метаданные)
				И ОтборПоОрганизациям Тогда // Справочники
				
				Выборка = ВыборкаСправочниковПоОрганизации(ПолноеИмяОбъекта, ЭлементСоставаПланаОбмена, Организации);
				
				Если Выборка <> Неопределено Тогда
					Пока Выборка.Следующий() Цикл
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
					КонецЦикла;
					
					Продолжить;
					
				КонецЕсли;
				
			ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ЭлементСоставаПланаОбмена.Метаданные) Тогда // Документы
				
				Если ОтборПоДатеНачалаВыгрузкиИОрганизациям
					И ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("Организация") <> Неопределено Тогда // Регистрация по дате и организациям
					
					Выборка = ВыборкаДокументовПоДатеНачалаВыгрузкиИОрганизациям(ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации);
					
					Пока Выборка.Следующий() Цикл
						
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
						
					КонецЦикла;
					
					Продолжить;
					
				Иначе // Регистрация по дате
					
					Выборка = ВыборкаОбъектовПоДатеНачалаВыгрузки(ПолноеИмяОбъекта, ДатаНачалаВыгрузки);
					
					Пока Выборка.Следующий() Цикл
						
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
						
					КонецЦикла;
					
					Продолжить;
					
				КонецЕсли;
				
			ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ЭлементСоставаПланаОбмена.Метаданные)
				ИЛИ ОбщегоНазначения.ЭтоЗадача(ЭлементСоставаПланаОбмена.Метаданные) Тогда // Бизнес-процессы и Задачи
				
				// Регистрация по дате
				Выборка = ВыборкаОбъектовПоДатеНачалаВыгрузки(ПолноеИмяОбъекта, ДатаНачалаВыгрузки);
				
				Пока Выборка.Следующий() Цикл
					
					ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
					
				КонецЦикла;
				
				Продолжить;
				
			ИначеЕсли ОбщегоНазначения.ЭтоРегистр(ЭлементСоставаПланаОбмена.Метаданные) Тогда // Регистры
				
				// Регистры сведений (независимые)
				Если ОбщегоНазначения.ЭтоРегистрСведений(ЭлементСоставаПланаОбмена.Метаданные)
					И ЭлементСоставаПланаОбмена.Метаданные.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
					
					ОсновнойОтбор = ОсновнойОтборРегистраСведений(ЭлементСоставаПланаОбмена.Метаданные);
					
					ОтборПоПериоду     = (ОсновнойОтбор.Найти("Период") <> Неопределено);
					ОтборПоОрганизации = (ОсновнойОтбор.Найти("Организация") <> Неопределено);
					
					Если ОтборПоДатеНачалаВыгрузкиИОрганизациям И ОтборПоПериоду И ОтборПоОрганизации Тогда // Регистрация по дате и организациям
						
						Выборка = ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоДатеНачалаВыгрузкиИОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации);
						
					ИначеЕсли ОтборПоДатеНачалаВыгрузки И ОтборПоПериоду Тогда // Регистрация по дате
						
						Выборка = ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоДатеНачалаВыгрузки(ОсновнойОтбор, ПолноеИмяОбъекта, ДатаНачалаВыгрузки);
						
					ИначеЕсли ОтборПоОрганизациям И ОтборПоОрганизации Тогда // Регистрация по организациям
						
						Выборка = ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, Организации);
						
					Иначе
						
						Выборка = Неопределено;
						
					КонецЕсли;
					
					Если Выборка <> Неопределено Тогда
						
						НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьНаборЗаписей();
						
						Пока Выборка.Следующий() Цикл
							
							Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
								
								НаборЗаписей.Отбор[ИмяИзмерения].Значение = Выборка[ИмяИзмерения];
								НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
								
							КонецЦикла;
							
							ПланыОбмена.ЗарегистрироватьИзменения(Получатель, НаборЗаписей);
							
						КонецЦикла;
						
						Продолжить;
						
					КонецЕсли;
					
				Иначе // Регистры (прочие)
					
					Если ОтборПоДатеНачалаВыгрузкиИОрганизациям
						И ЭлементСоставаПланаОбмена.Метаданные.Измерения.Найти("Период") <> Неопределено
						И ЭлементСоставаПланаОбмена.Метаданные.Измерения.Найти("Организация") <> Неопределено Тогда // Регистрация по дате и организациям
						
						Выборка = ВыборкаРегистраторовНаборовЗаписейПоДатеНачалаВыгрузкиИОрганизациям(ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации);
						
						НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьНаборЗаписей();
						
						Пока Выборка.Следующий() Цикл
							
							НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
							НаборЗаписей.Отбор.Регистратор.Использование = Истина;
							
							ПланыОбмена.ЗарегистрироватьИзменения(Получатель, НаборЗаписей);
							
						КонецЦикла;
						
						Продолжить;
						
					ИначеЕсли ЭлементСоставаПланаОбмена.Метаданные.Измерения.Найти("Период") <> Неопределено Тогда // Регистрация по дате
						
						Выборка = ВыборкаРегистраторовНаборовЗаписейПоДатеНачалаВыгрузки(ПолноеИмяОбъекта, ДатаНачалаВыгрузки);
						
						НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьНаборЗаписей();
						
						Пока Выборка.Следующий() Цикл
							
							НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
							НаборЗаписей.Отбор.Регистратор.Использование = Истина;
							
							ПланыОбмена.ЗарегистрироватьИзменения(Получатель, НаборЗаписей);
							
						КонецЦикла;
						
						Продолжить;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Получатель, ЭлементСоставаПланаОбмена.Метаданные);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РегистрацияИзмененийДляНачальнойВыгрузкиДанных

Функция ВыборкаСправочниковПоОрганизации(ПолноеИмяОбъекта, ЭлементСоставаПланаОбмена, Организации)
	
	ТекстЗапроса = "ВЫБРАТЬ
		|	Таблица.Ссылка КАК Ссылка
		|ИЗ
		|	[ПолноеИмяОбъекта] КАК Таблица
		|ГДЕ
		|	Таблица.[Организация] В(&Организации)";
	
	ТекстЗапроса        = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	РеквизитОрганизации = Неопределено;
	
	Если ПолноеИмяОбъекта = "Справочник.Организации" Тогда
		
		РеквизитОрганизации = "Ссылка";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.ДоговорыМеждуОрганизациями" Тогда
		
		РеквизитОрганизации = "Организация";
		
		ТекстЗапроса = ТекстЗапроса + "
		| ИЛИ Таблица.ОрганизацияПолучатель В(&Организации)";
		
	ИначеЕсли ПолноеИмяОбъекта = "Справочник.БанковскиеСчетаОрганизаций" Тогда
		
		РеквизитОрганизации = "Владелец";
		
	Иначе
		Если ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("Организация") <> Неопределено Тогда
			РеквизитОрганизации = "Организация";
		КонецЕсли;
	КонецЕсли;
	
	Если РеквизитОрганизации = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Организация]", РеквизитОрганизации);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ВыборкаДокументовПоДатеНачалаВыгрузкиИОрганизациям(ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК Таблица
	|ГДЕ
	|	Таблица.Дата >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Если ПолноеИмяОбъекта = "Документ.СписаниеБезналичныхДенежныхСредств" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|	И (Таблица.Организация В(&Организации) 
		|		ИЛИ Таблица.БанковскийСчетПолучатель.Владелец В(&Организации))";
		
	ИначеЕсли ПолноеИмяОбъекта = "Документ.ВзаимозачетЗадолженности" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|	И (Таблица.Организация В(&Организации) 
		|		ИЛИ Таблица.КонтрагентДебитор В(&Организации)
		|		ИЛИ Таблица.КонтрагентКредитор В(&Организации))";
		
	ИначеЕсли ПолноеИмяОбъекта = "Документ.ВозвратТоваровМеждуОрганизациями"
		Или ПолноеИмяОбъекта = "Документ.ПередачаТоваровМеждуОрганизациями"
		Или ПолноеИмяОбъекта = "Документ.ПеремещениеТоваров" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|	И (Таблица.Организация В(&Организации) 
		|		ИЛИ Таблица.ОрганизацияПолучатель В(&Организации))";
		
	ИначеЕсли ПолноеИмяОбъекта = "Документ.ОтчетПоКомиссииМеждуОрганизациями"
		ИЛИ ПолноеИмяОбъекта = "Документ.ОтчетПоКомиссииМеждуОрганизациямиОСписании" Тогда
		
		ТекстЗапроса = ТекстЗапроса + "
		|	И (Таблица.Организация В(&Организации) 
		|		ИЛИ Таблица.Комиссионер В(&Организации))";
		
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
		|	И Таблица.Организация В(&Организации)";
	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаОбъектовПоДатеНачалаВыгрузки(ПолноеИмяОбъекта, ДатаНачалаВыгрузки)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК Таблица
	|ГДЕ
	|	Таблица.Дата >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаРегистраторовНаборовЗаписейПоДатеНачалаВыгрузкиИОрганизациям(ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Организация В(&Организации)
	|	И ТаблицаРегистра.Период >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаРегистраторовНаборовЗаписейПоДатеНачалаВыгрузки(ПолноеИмяОбъекта, ДатаНачалаВыгрузки)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Период >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоДатеНачалаВыгрузкиИОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, ДатаНачалаВыгрузки, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	[Измерения]
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Организация В(&Организации)
	|	И ТаблицаРегистра.Период >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Измерения]", СтрСоединить(ОсновнойОтбор, ","));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоДатеНачалаВыгрузки(ОсновнойОтбор, ПолноеИмяОбъекта, ДатаНачалаВыгрузки)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	[Измерения]
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Период >= &ДатаНачалаВыгрузки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Измерения]", СтрСоединить(ОсновнойОтбор, ","));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаВыгрузки", ДатаНачалаВыгрузки);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	[Измерения]
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Организация В(&Организации)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Измерения]", СтрСоединить(ОсновнойОтбор, ","));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Функция ОсновнойОтборРегистраСведений(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	Если ОбъектМетаданных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
		И ОбъектМетаданных.ОсновнойОтборПоПериоду Тогда
		
		Результат.Добавить("Период");
		
	КонецЕсли;
	
	Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		
		Если Измерение.ОсновнойОтбор Тогда
			
			Результат.Добавить(Измерение.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ОбщиеДляВсехПлановОбменаПроцедурыИФункции

// Обновляет кэш значений настроек узлов планов обмена
Процедура ОбновитьКэшМеханизмовРегистрации() Экспорт
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда
		ОбменДаннымиВызовСервера.СброситьКэшМеханизмаРегистрацииОбъектов();
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
