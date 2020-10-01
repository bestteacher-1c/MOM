////////////////////////////////////////////////////////////////////////////////
// Подсистема "Бизнес-сеть".
// ОбщийМодуль.БизнесСетьСлужебныйКлиент.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Подключает организацию к сервису Бизнес-сети по коду активации асинхронно.
//
// Параметры:
//  Организация			 - ОпределяемыйТип.Организация - подключаемая организация.
//  КодАктивации		 - Строка - код активации, выданный сервисом.
//  Форма				 - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещения	 - ОписаниеОповещения - описание оповещения о закрытии формы.
//
Процедура ПодключитьОрганизациюКСервису(Организация, КодАктивации, Форма, ОписаниеОповещения) Экспорт
	
	ДлительнаяОперация = БизнесСетьВызовСервера.ПодключитьОрганизациюКСервису(Организация, КодАктивации, Форма.УникальныйИдентификатор);
	
	ПараметрыОжидания                                 = ДлительныеОперацииКлиент.ПараметрыОжидания(Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Истина;
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОписаниеОповещения, ПараметрыОжидания);
	
КонецПроцедуры

// Открывает сайт Бизнес-сети для регистрации организации.
//
// Параметры:
//  ДанныеОрганизацииВBase64 - Строка - данные организации, полученные через метод БизнесСеть.ДанныеОрганизацииВBase64.
//
Процедура ОткрытьСтраницуРегистрацииОрганизации(ДанныеОрганизацииВBase64) Экспорт
	
	URLАдрес = URLАдресДляОтправкиДанныхОрганизации(ДанныеОрганизацииВBase64);
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуИнтегрированногоСайта(URLАдрес);
		
КонецПроцедуры

// Открывает форму подключения организации к Бизнес-сети.
//
// Параметры:
//  Организация					 - ОпределяемыйТип.Организация - подключаемая организация.
//  Владелец					 - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения - описание оповещения о закрытии формы.
//
Процедура ОткрытьФормуПодключенияОрганизации(Организация, 
			Владелец = Неопределено, 
			ОписаниеОповещенияОЗакрытии = Неопределено)  Экспорт
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Организация", Организация);
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПодключениеОрганизации", ПараметрыФормы, Владелец,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Открывает форму выбора организации для открытия профиля.
//
// Параметры:
//  Владелец					 - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещенияОЗакрытии	 - ОписаниеОповещения - описание оповещения о закрытии формы.
//
Процедура ОткрытьФормуВыбораОрганизации(
			Владелец = Неопределено, 
			ОписаниеОповещенияОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ВыборОрганизации",, Владелец,,,, ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

// Показывает оповещение пользователю с логотипом Бизнес-сети.
//
// Параметры:
//  ТекстОповещения - Строка - текст оповещения пользователю.
//
Процедура ПоказатьОповещениеБизнесСети(ТекстОповещения) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Бизнес-сеть'"),
		Неопределено,
		ТекстОповещения,
		БиблиотекаКартинок.БизнесСеть);
		
КонецПроцедуры

// Открывает страницу с профилем организации.
//
// Параметры:
//  ИдентификаторОрганизации - Строка - идентификатор организации в Бизнес-сети.
//
Процедура ОткрытьПрофильОрганизацииНаСайтеБизнесСети(ИдентификаторОрганизации) Экспорт
	
	Если Не ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не передан идентификатор организации. Необходимо повторно подключиться к сервису 1С:Бизнес-сеть'"));
		Возврат;
	КонецЕсли;
	
	URLАдрес = URLАдресДляОткрытияПрофиляОрганизации(ИдентификаторОрганизации);
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуИнтегрированногоСайта(URLАдрес);
	
КонецПроцедуры

// Команда открытия формы отправки документа через 1С:Бизнес-сеть.
Процедура ОтправитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	Если ПараметрКоманды.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Команда не может быть выполнена для указанного объекта.'")
	КонецЕсли;
	
	Организация = Неопределено;
	Отказ = Ложь;
	ТекстОшибки = "";
	ВозможнаОтправка = БизнесСетьВызовСервера.ВозможнаОтправкаДокумента(ПараметрКоманды, Организация, ТекстОшибки, Отказ);
	Если Отказ Тогда
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	ИначеЕсли ВозможнаОтправка = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("МассивСсылокНаОбъект", ПараметрКоманды);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаДокумента", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Команда загрузки документа через сервис Бизнес-сеть.
//
Процедура ЗагрузитьЧерезБизнесСеть(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("РежимЗагрузкиДокументов", Истина);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ДокументыОбмена", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Открытие формы профиля участника 1С:Бизнес-сеть.
//
// Параметры:
//   ПараметрыОткрытия - СправочникСсылка, Структура - ссылка на организацию или контрагента
//     или параметры структуры открытия, см. БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов:
//     * Ссылка - СправочникСсылка - ссылка на организацию или контрагента.
//     * ИНН - Строка - ИНН.
//     * КПП - Строка - КПП.
//     * ЭтоОрганизация - Булево - признак, что участник является организацией.
//     * ЭтоКонтрагент - Булево - признак, что участник является контрагентом.
//
Процедура ОткрытьПрофильУчастника(Знач ПараметрыОткрытия) Экспорт
	
	Отказ = Ложь;
	
	Если ТипЗнч(ПараметрыОткрытия) <> Тип("Структура") Тогда
		// Если открываем по ссылке, преобразуем в структуру.
		Ссылка = ПараметрыОткрытия;
		ПараметрыОткрытия = БизнесСетьКлиентСервер.ОписаниеИдентификацииОрганизацииКонтрагентов();
		ПараметрыОткрытия.Ссылка = Ссылка;
	КонецЕсли;
	
	// Проверка регистрации участника.
	Результат = БизнесСетьВызовСервера.ПолучитьРеквизитыУчастника(ПараметрыОткрытия, Отказ, Истина);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Если ЗначениеЗаполнено(ПараметрыОткрытия.Ссылка) Тогда
			Если ПараметрыОткрытия.ЭтоОрганизация Тогда
				ТекстВопроса = НСтр("ru='Организация ""%1"" не зарегистрирована в сервисе 1С:Бизнес-сеть. Зарегистрировать сейчас?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, ПараметрыОткрытия.Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ЗарегистрироватьОрганизациюПослеВопроса", ЭтотОбъект, ПараметрыОткрытия.Ссылка);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			ИначеЕсли ПараметрыОткрытия.ЭтоКонтрагент Тогда
				ТекстВопроса = НСтр("ru='Контрагент ""%1"" не зарегистрирован в сервисе 1С:Бизнес-сеть.
					|Направить приглашение для регистрации?'");
				ТекстВопроса = СтрШаблон(ТекстВопроса, ПараметрыОткрытия.Ссылка);
				ПараметрыОповещения = Новый Структура("Контрагент", ПараметрыОткрытия.Ссылка);
				ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьКонтрагентаПослеВопроса", ЭтотОбъект, ПараметрыОповещения);
				ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Участник не зарегистрирован в сервисе 1С:Бизнес-сеть.'"));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Открытие профиля участника, если уже получены реквизиты.
	ПараметрыОткрытия.Вставить("Реквизиты", Результат);
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ПрофильУчастника", ПараметрыОткрытия, ЭтотОбъект);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ПодключитьКонтрагентаПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ОтправкаПриглашения", Параметры,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Асинхронная процедура.
Процедура ЗарегистрироватьОрганизациюПослеВопроса(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Ссылка", Параметры);
	ОчиститьСообщения();
	ОткрытьФорму("Обработка.БизнесСеть.Форма.РегистрацияОрганизаций", ПараметрыОткрытия);
	
КонецПроцедуры

// Открытие списка документов 1С:Бизнес-сеть.
//  Особенности поведения формы при использовании метода:
//  1. Если форма открыта с установленным Отбором, то значения Отбора не будут сохранены в настройках формы
//     после ее закрытия, в том числе и выполненные пользователем интерактивно.
//  2. При повторном открытии формы в том же Режиме с новым Отбором, будет активизирована уже открытая форма,
//     и применен новый Отбор.
//  3. При повторном открытии формы в том же Режиме без Отбора, будет активизирована уже открытая форма, а
//     существующий Отбор заменен на сохраненный в настройках формы. После закрытия формы, ее настройки будут
//     сохранены.
//
// Параметры:
//  Режим - Строка    - Режим просмотра документов. Допустимые значения:
//    "Входящие"  - Для входящих документов.
//    "Исходящие" - Для исходящих документов.
//  Отбор - Структура - Настройки отборов, доступных на форме, со следующими ключами:
//    * Период                - СтандартныйПериод             - период, за который необходимо вывести документы.
//    * Контрагент            - ОпределяемыйТип.КонтрагентБЭД - отбор документов по контрагенту.
//    * ВидДокумента          - ПеречислениеСсылка.ВидыЭД     - отбор по виду документа.
//    * ПоказыватьЗагруженные - Булево                        - отображать в списке документы, уже загруженные в
//                                                              информационную базу.
//
Процедура ОткрытьСписокДокументовОбмена(Знач Режим, Знач Отбор = Неопределено) Экспорт
	
	Если ВРег(Режим) <> "ВХОДЯЩИЕ"
		И ВРег(Режим) <> "ИСХОДЯЩИЕ" Тогда
		ВызватьИсключение НСтр("ru = 'Некорректный режим открытия списка документов 1С:Бизнес-сеть.'");
	КонецЕсли;
	
	Если Отбор = Неопределено Тогда
		Отбор = Новый Структура;
	КонецЕсли;
	
	Период                = Неопределено;
	Контрагент            = Неопределено;
	ВидДокумента          = Неопределено;
	ПоказыватьЗагруженные = Неопределено;
	
	Отбор.Свойство("Период",                Период);
	Отбор.Свойство("Контрагент",            Контрагент);
	Отбор.Свойство("ВидДокумента",          ВидДокумента);
	Отбор.Свойство("ПоказыватьЗагруженные", ПоказыватьЗагруженные);
	
	НастройкиОтбора = Новый Структура;
	НастройкиОтбора.Вставить("Период",                    Период);
	НастройкиОтбора.Вставить("ОтборКонтрагент",           Контрагент);
	НастройкиОтбора.Вставить("ВключитьОтборКонтрагент",   ЗначениеЗаполнено(Контрагент));
	НастройкиОтбора.Вставить("ОтборВидДокумента",         ВидДокумента);
	НастройкиОтбора.Вставить("ВключитьОтборВидДокумента", ЗначениеЗаполнено(ВидДокумента));
	НастройкиОтбора.Вставить("ПоказыватьЗагруженные",     ПоказыватьЗагруженные);
	
	ДобавитьОтборСпискаДокументовОбменаВКэш(НастройкиОтбора);
	
	НастройкиОтбора.Вставить("РежимИсходящихДокументов", ?(ВРег(Режим) = "ИСХОДЯЩИЕ", Истина, Ложь));
	
	ОткрытьФорму("Обработка.БизнесСеть.Форма.ДокументыОбмена", НастройкиОтбора);
	
	УдалитьОтборСпискаДокументовОбменаИзКэша();
	
КонецПроцедуры

// Открывает форму настроек регионов.
//
// Параметры:
//  ПараметрыФормы		 - Структура - см. ОписаниеПараметровФормыНастройкиРегионов.
//  Владелец			 - ФормаКлиентскогоПриложения - владелец формы.
//  ОписаниеОповещения	 - ОписаниеОповещения - описание оповещения о закрытии формы.
//
Процедура ОткрытьФормуНастройкиРегионов(
			ПараметрыФормы,
			Владелец = Неопределено,
			ОписаниеОповещения = Неопределено) Экспорт

	ОткрытьФорму("Обработка.БизнесСеть.Форма.РегионыДоступностиТоваров", 
		ПараметрыФормы, 
		Владелец, 
		, , , 
		ОписаниеОповещения);
	
	КонецПроцедуры
	
// Описание параметров формы настройки регионов.
// 
// Возвращаемое значение:
//  Структура - описание параметров.
//
Функция ОписаниеПараметровФормыНастройкиРегионов() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ЗаголовокФормы",             НСтр("ru = 'Регионы доступности товаров'"));
	Результат.Вставить("Организация",                Неопределено);
	Результат.Вставить("ЭтоПокупатель",              Ложь);
	Результат.Вставить("АдресДанныхАдресовРегионов", "");
	Результат.Вставить("ТолькоРегионы",              Ложь);
	Результат.Вставить("КлючХраненияНастроек",       ""); // ТорговыеПредложения, ЗапросыКоммерческихПредложений

	Возврат Результат;
	
КонецФункции

Процедура ВывестиСообщенияФоновогоЗадания(Результат, Отказ = Ложь) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Свойство("Сообщения") И ЗначениеЗаполнено(Результат.Сообщения) Тогда
		
		Для каждого ЭлементКоллекции Из Результат.Сообщения Цикл
			ЭлементКоллекции.Сообщить();
		КонецЦикла;
		
	КонецЕсли;
	
	Если Результат.Свойство("Статус") И Результат.Статус = "Ошибка" Тогда
		
		Если ЗначениеЗаполнено(Результат.КраткоеПредставлениеОшибки) Тогда
			ТекстСообщения = Результат.КраткоеПредставлениеОшибки;
		ИначеЕсли ЗначениеЗаполнено(Результат.ПодробноеПредставлениеОшибки) Тогда
			ТекстСообщения = Результат.ПодробноеПредставлениеОшибки;
		Иначе
			ТекстСообщения = НСтр("ru = 'Ошибка выполнения операции'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция URLАдресДляОтправкиДанныхОрганизации(Base64Строка)
	
	Результат = СтрШаблон("%1/organization-onboarding?regctx=%2", СайтБизнесСети(), Base64Строка);
	
	Возврат Результат;
	
КонецФункции

Процедура ПоказатьУведомлениеОПодключенииОрганизацииКСервису() Экспорт
	
	ПоказатьОповещениеБизнесСети(НСтр("ru = 'Организация подключена к сервису'"));

КонецПроцедуры

Функция URLАдресДляОткрытияПрофиляОрганизации(ИдентификаторОрганизации)
	
	Результат = СтрШаблон("%1/organization-profile-access?orgId=%2", СайтБизнесСети(), ИдентификаторОрганизации);
	
	Возврат Результат;
	
КонецФункции

Функция СайтБизнесСети()
	
	Возврат "https://my.1cbn.ru";
	
КонецФункции

Функция ОтборСпискаДокументовОбменаИзКэша() Экспорт
	
	Отбор = Неопределено;
	КэшПодсистемы().Свойство(АдресОтбораСпискаДокументовОбменаВКэше(), Отбор);
	
	Возврат Отбор;
	
КонецФункции

Функция КэшПодсистемы()
	
	ИмяПодсистемы = "ЭлектронноеВзаимодействие.БизнесСеть";
	Если ПараметрыПриложения[ИмяПодсистемы] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПодсистемы, Новый Структура);
	КонецЕсли;
	
	Возврат ПараметрыПриложения[ИмяПодсистемы];
	
КонецФункции

Функция КэшНовыхДокументовВСервисе()
	
	Кэш = КэшПодсистемы();
	
	КэшНовыхДокументовВСервисе = Неопределено;
	АдресКэша = "КэшНовыхДокументовВСервисе";
	
	Кэш.Свойство(АдресКэша, КэшНовыхДокументовВСервисе);
	
	Если КэшНовыхДокументовВСервисе = Неопределено Тогда
		Кэш.Вставить(АдресКэша, Новый Соответствие);
	КонецЕсли;
	
	Возврат Кэш[АдресКэша];
	
КонецФункции

Процедура ДобавитьОтборСпискаДокументовОбменаВКэш(Знач Отбор)
	
	КэшПодсистемы().Вставить(АдресОтбораСпискаДокументовОбменаВКэше(), Отбор);
	
КонецПроцедуры

Процедура УдалитьОтборСпискаДокументовОбменаИзКэша()
	
	Кэш         = КэшПодсистемы();
	АдресОтбора = АдресОтбораСпискаДокументовОбменаВКэше();
	
	Если Кэш.Свойство(АдресОтбора) Тогда
		Кэш.Удалить(АдресОтбора);
	КонецЕсли;
	
КонецПроцедуры

Функция АдресОтбораСпискаДокументовОбменаВКэше()
	
	Возврат "ОтборСпискаДокументовОбмена";
	
КонецФункции

Процедура ИзменитьКэшНовыхДокументовВСервисе(Знач ДокументыСервиса)
	
	Для каждого ЭлементКоллекции Из ДокументыСервиса Цикл
				
		КэшНовыхДокументовВСервисе().Вставить(
			ЭлементКоллекции.ВидДокумента, ЭлементКоллекции.КоличествоДокументов);
		
	КонецЦикла;
	
КонецПроцедуры

Функция КоличествоНовыхДокументовВСервисеИзКэша(Знач ВидДокумента)
	
	КоличествоДокументов = КэшНовыхДокументовВСервисе()[ВидДокумента];
	
	Если КоличествоДокументов = Неопределено Тогда
		КоличествоДокументов = 0;
	КонецЕсли;
	
	Возврат КоличествоДокументов;
	
КонецФункции

Процедура ИзменитьПодсказкуОНовыхДокументахВСервисе(Форма, Знач КоличествоДокументов)
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Элементы,
		БизнесСетьКлиентСервер.ИмяКомандыПодбораДокументовИзСервиса()) Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементФормы = Форма.Элементы[БизнесСетьКлиентСервер.ИмяКомандыПодбораДокументовИзСервиса()];
	
	ПредставлениеКоличества = ?(КоличествоДокументов > 100, НСтр("ru = 'больше 100'"), Строка(КоличествоДокументов));
	
	НовыйЗаголовок = СтрШаблон(НСтр("ru = 'Есть новые документы для загрузки (%1)'"), ПредставлениеКоличества);
	
	Если ЭлементФормы.Заголовок <> НовыйЗаголовок Тогда
		
		ЭлементФормы.Заголовок = НовыйЗаголовок;
		
		Если КоличествоДокументов > 0 Тогда
			Если Не ЭлементФормы.Видимость Тогда
				ЭлементФормы.Видимость = Истина;
			КонецЕсли;
		Иначе
			Если ЭлементФормы.Видимость Тогда
				ЭлементФормы.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьИнформациюОНовыхДокументахВСервисеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Контекст = ДополнительныеПараметры.Контекст;
	
	ИмяРеквизитаИспользованияПодсистемы = БизнесСетьКлиентСервер.ИмяРеквизитаИспользоватьОбменБизнесСеть();
	ИмяРеквизитаВидаДокументаСервиса    = БизнесСетьКлиентСервер.ИмяРеквизитаВидаДокументаСервиса();
	
	Если Не Контекст[ИмяРеквизитаИспользованияПодсистемы] Тогда
		Возврат;
	КонецЕсли;
	
	ПериодОбновления = 3600;
	
	БизнесСетьКлиентПереопределяемый.ПериодОбновленияИнформацииОНовыхДокументахВСервисе(ПериодОбновления);
	
	Если ЗначениеЗаполнено(ПериодОбновления) Тогда
		Контекст.ПодключитьОбработчикОжидания("ОбновитьИнформациюОНовыхДокументахВСервисе",
			ПериодОбновления, Истина);
	КонецЕсли;
	
	Если Результат = Неопределено
		Или Результат.Статус <> "Выполнено" Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыСервиса = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	
	Если ТипЗнч(ДокументыСервиса) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоДокументов = 0;
	ЕстьНовыеДокументы   = Ложь;
	ВидыДокументов       = Новый Массив;
	
	ОпределитьНаличиеНовыхДокументов(ДокументыСервиса, КоличествоДокументов, ЕстьНовыеДокументы, ВидыДокументов);
	
	Контекст[ИмяРеквизитаВидаДокументаСервиса].ЗагрузитьЗначения(ВидыДокументов);
	
	Если ЕстьНовыеДокументы Тогда
		
		Текст = НСтр("ru = '1С:Бизнес-сеть'");
		Пояснение = СтрШаблон(НСтр("ru = 'Новых документов: %1'"), 
			?(КоличествоДокументов > 100, НСтр("ru = 'больше 100'"), КоличествоДокументов));
		
		ДействиеПриНажатии = Новый ОписаниеОповещения("ДействиеОповещенияОткрытьСписокДокументовОбмена",
			БизнесСетьСлужебныйКлиент, ВидыДокументов);
		
		ПоказатьОповещениеПользователя(Текст, ДействиеПриНажатии, Пояснение, БиблиотекаКартинок.БизнесСетьЗагрузка,
			СтатусОповещенияПользователя.Важное);
		
	КонецЕсли;
	
	ИзменитьКэшНовыхДокументовВСервисе(ДокументыСервиса);
	
	ИзменитьПодсказкуОНовыхДокументахВСервисе(Контекст, КоличествоДокументов);
	
КонецПроцедуры

Процедура ОпределитьНаличиеНовыхДокументов(Знач ДокументыСервиса, КоличествоДокументов, ЕстьНовыеДокументы, ВидыДокументов)
	
	Для каждого ЭлементКоллекции Из ДокументыСервиса Цикл
		Если ЭлементКоллекции.КоличествоДокументов > КоличествоНовыхДокументовВСервисеИзКэша(ЭлементКоллекции.ВидДокумента) Тогда
			ЕстьНовыеДокументы = Истина;
		КонецЕсли;
		
		КоличествоДокументов = ЭлементКоллекции.КоличествоДокументов + КоличествоДокументов;
		ВидыДокументов.Добавить(ЭлементКоллекции.ВидДокумента);
	КонецЦикла;
	
КонецПроцедуры

Процедура ДействиеОповещенияОткрытьСписокДокументовОбмена(ВидыДокументов) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ВидДокумента", ВидыДокументов);
	
	ОткрытьСписокДокументовОбмена("Входящие", Отбор);
	
КонецПроцедуры

#КонецОбласти