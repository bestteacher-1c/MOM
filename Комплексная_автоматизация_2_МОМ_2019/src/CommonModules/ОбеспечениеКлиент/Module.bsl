////////////////////////////////////////////////////////////////////////////////
// Клиентские процедуры работы с механизмами обеспечения
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Отображает вопрос о необходимости отгружать заказ одной датой или частями.
// Вызывает процедуру переноса данных в форму документа.
// Используется при переносе в документ строк с учетом дат отгрузки.
//  Параметры:
//   Форма - Форма в которой будет отображен вопрос и в обработку оповещения которой будет передан результат ответа.
//   ЗначенияРеквизитов - Структура - Содержит значения реквизитов объекта, редактируемого в форме.
//                                    Содержит поля:
//                                                   ДатаОтгрузки - Дата - Дата отгрузки, заданная для документа в целом.
//                                                   НеОтгружатьЧастями - Булево - Признак, что заказ отгружается
//                                                       целиком, установленной датой отгрузки.
//                                                   ЖелаемаяДатаОтгрузки - Дата - Желаемая дата отгрузки, заданная для
//                                                                                 документа в целом (оговаривается с
//                                                                                 получателем товара, клиентом).
//                                    Вопрос будет задан, только если НеОтгружатьЧастями = Истина.
//   ДополнительныеПараметры - Структура - Структура для обработки оповещением после ответа пользователем на вопрос.
//                                         Обязательное поле в структуре:
//                                                                        МаксимальнаяДатаОтгрузки - Дата - максимальная
//                                                                                                          дата
//                                                                                                          отгрузки в
//                                                                                                          строках
//                                                                                                          которые
//                                                                                                          необходимо
//                                                                                                          перенести в документ.
//                                         Структура также содержит данные строк в произвольной форме, которые будут
//                                         перенесены в документ в обработку оповещения.
//   ИмяПроцедурыОповещения - Строка - Имя экспортной процедуры формы в которой производится обработка оповещения после
//                                     ответа на вопрос.
//   ЗадаватьВопрос - Булево - признак необходимости задавать вопрос.
//
Процедура ПоказатьВопросОбОтгрузкеОднойДатой(Форма, ЗначенияРеквизитов, ДополнительныеПараметры, ИмяПроцедурыОповещения, ЗадаватьВопрос) Экспорт
	
	НачалоДня = НачалоДня(ОбщегоНазначенияКлиент.ДатаСеанса());
	СтараяДатаОтгрузки = ЗначенияРеквизитов.ДатаОтгрузки;
	НоваяДатаОтгрузки = Макс(
		ДополнительныеПараметры.МаксимальнаяДатаОтгрузки,
		ЗначенияРеквизитов.ЖелаемаяДатаОтгрузки,
		НачалоДня);
		
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяПроцедурыОповещения, Форма, ДополнительныеПараметры);
	ЗадатьВопрос = ЗадаватьВопрос И ЗначенияРеквизитов.НеОтгружатьЧастями И НоваяДатаОтгрузки > СтараяДатаОтгрузки;
	Если ЗадатьВопрос И ЗначениеЗаполнено(СтараяДатаОтгрузки) Тогда
		
		СтрокаПоиска = "ЗаполнитьВариантОбеспеченияПослеВопроса";
		
		Если СтрокаПоиска = Лев(ИмяПроцедурыОповещения, СтрДлина(СтрокаПоиска)) Тогда
			ШаблонТекстаВопроса = НСтр("ru = 'Дата отгрузки текущей строки %1, дата отгрузки остальных строк %2.
											|Можно отгрузить все одной датой %1, можно отгружать частями.'");
		Иначе
			ШаблонТекстаВопроса = НСтр("ru = 'Дата отгрузки подобранных строк %1, дата отгрузки остальных строк %2.
											|Можно отгрузить все одной датой %1, можно отгружать частями.'");
		КонецЕсли;
		СтараяДатаОтгрузкиСтрокой = Формат(СтараяДатаОтгрузки, "ДЛФ=D");
		НоваяДатаОтгрузкиСтрокой = Формат(НоваяДатаОтгрузки, "ДЛФ=D");
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонТекстаВопроса,
			НоваяДатаОтгрузкиСтрокой,
			СтараяДатаОтгрузкиСтрокой);
		
		СписокКнопок = Новый СписокЗначений();
		ШаблонКнопки = НСтр("ru = 'Отгрузить одной датой (%1)'");
		ТекстКнопки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонКнопки, НоваяДатаОтгрузкиСтрокой);
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, ТекстКнопки);
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Отгружать частями'"));
		
		ЗаголовокВопроса = НСтр("ru = 'Вопрос'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок,,, ЗаголовокВопроса);
		
	Иначе
		
		ВыполнитьОбработкуОповещения(ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру параметров, используемую при открытии формы обработки "ОбеспечениеПотребностей".
//  Возвращаемое значение:
//   Структура - 
//    ОтборПоТипуОбеспечения - ПеречислениеСсылка.ТипыОбеспечения, Неопределено - отбор по типу обеспечения.
//    ОтборПоПодразделению - СправочникСсылка.СтруктураПредприятия, Неопределено - отбор по подразделению.
//    ЕстьШагЗапасы - Булево - если Ложь, то шаг поддержания запасов игнорируется.
//
Функция ПараметрыОткрытияФормыОбработкиОбеспечениеПотребностей() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ОтборПоТипуОбеспечения", Неопределено);
	Результат.Вставить("ОтборПоИсточникуОбеспечения", Неопределено);
	Результат.Вставить("ОтборПоПодразделению", Неопределено);
	Результат.Вставить("ЕстьШагЗапасы", Истина);
	Результат.Вставить("ОтборПоЦеховымКладовым", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Открывает форму обработки "Состояние обеспечения заказов" для выделенных заказов в форме списка.
//
// Параметры:
//   ПолеСписка - ТаблицаФормы - таблица содержащая список заказов.
//   Форма - ФормаКлиентскогоПриложения  - форма, в которой расположена таблица.
//
Процедура ОткрытьФормуСостояниеОбеспечения(ПолеСписка, Форма) Экспорт

	Если ПолеСписка = Неопределено Тогда

		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;

	КонецЕсли;

	Заказы = Новый СписокЗначений();

	Для Каждого Заказ Из ПолеСписка.ВыделенныеСтроки Цикл
	
		Если ТипЗнч(Заказ) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			Продолжить;
		КонецЕсли;

		Заказы.Добавить(ПолеСписка.ДанныеСтроки(Заказ).Ссылка);

	КонецЦикла;

	ПараметрыФормы = Новый Структура("Заказы", Заказы);
	ОткрытьФорму("Обработка.СостояниеОбеспечения.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);

КонецПроцедуры

// Проверяет возможность выполнения команды "Состояние обеспечения" в документе (наличие строк в списке товаров)
// и сообщает, если команду выполнить невозможно.
//
// Параметры:
//  Форма          - ФормаКлиентскогоПриложения     - форма, содержащая список товаров.
//  Поле           - Строка               - Путь к реквизиту формы - списку товаров.
//  ТекстСообщения - Строка, Неопределено - переопределенный текст сообщения о невозможности выполнения команды.
// Возвращаемое значение:
//  - Булево - Истина - проверка выполнена успешно, Ложь - в противном случае.
//
Функция ПроверитьВозможностьВыполненияКомандыСостояниеОбеспеченияВДокументе(Форма, Поле = "Товары", Знач ТекстПредупреждения = Неопределено) Экспорт
	
	Коллекция = Форма.Объект[Поле];
	ПроверкаУспешна = Коллекция.Количество() > 0;
	Если Не ПроверкаУспешна Тогда
		
		Если ТекстПредупреждения = Неопределено Тогда
			
			ТекстПредупреждения = НСтр("ru = 'Не введено ни одной строки в список ""Товары"".
				|Просмотр состояния обеспечения списка товаров невозможен.'")
			
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
	КонецЕсли;
	Возврат ПроверкаУспешна;
	
КонецФункции

#КонецОбласти

// Заполняет служебные реквизиты "ДатаОтгрузкиОбязательна" и "СкладОбязателен" в шапке документа.
//
//  Параметры:
//   Товары - ДанныеФормыКоллекция - таблица формы.
//   ДатаОтгрузкиОбязательна - РеквизитФормы - служебный реквизит формы, заполняемый, исходя из итогов одноименного
//                                             реквизита таблицы формы.
//   СкладОбязателен - РеквизитФормы - служебный реквизит формы, заполняемый, исходя из итогов одноименного реквизита
//                                     таблицы формы.
//
Процедура ЗаполнитьСлужебныеРеквизиты(Товары, ДатаОтгрузкиОбязательна = Неопределено, СкладОбязателен = Неопределено) Экспорт
	
	ОбеспечениеКлиентСервер.ЗаполнитьСлужебныеРеквизиты(Товары, ДатаОтгрузкиОбязательна, СкладОбязателен);
	
КонецПроцедуры

// Сообщает о том, что в заказе нет ни одного товара с действием "Обеспечивать обособленно" по собственному назначению.
//
Процедура СообщитьОбОтсутствииТовараКОбособленномуОбеспечению() Экспорт
	
	ТекстОшибки = НСтр("ru = 'Заказ не является объектом обособления. Выполнение команды не предусмотрено.'");
	
	ПоказатьПредупреждение(, ТекстОшибки);
	
КонецПроцедуры

// Сообщает о том, что все присутствующие в документе товары с действием "Обеспечивать обособленно" - по стороннему назначению.
//
// Параметры:
//  ЭтоРезервирование	 - Булево - Это резервирование или снятие резерва.
//
Процедура СообщитьОбОтсутствииТовараКОбособленномуОбеспечениюПоТекущемуЗаказу(ЭтоРезервирование) Экспорт
	
	Если ЭтоРезервирование Тогда
		
		ТекстОшибки = НСтр("ru = 'Резервирование для указанного в строках назначения доступно из соответствующего заказа,
		|или с помощью документа ""Корректировка назначения товаров"".'");
		
	Иначе
		
		ТекстОшибки = НСтр("ru = 'Снятие резерва для указанного в строках назначения доступно из соответствующего заказа,
		|или с помощью документа ""Корректировка назначения товаров"".'");
		
	КонецЕсли;
	
	ПоказатьПредупреждение(, ТекстОшибки);
	
КонецПроцедуры

// Сообщает о невозможности запуска обработки резервирования/снятия резерва из документа с 
// неподходящим статусов.
//
// Параметры:
//  ЭтоРезервирование	 - Булево - Это резервирование или снятие резерва
//  МинимальныйСтатус	 - Строка - Минимальный статус, начиная с которого доступен запуск обработки резервирования/снятия резерва.
//
Процедура СообщитьОНеобходимомМинимальномСтатусеДокумента(ЭтоРезервирование, МинимальныйСтатус) Экспорт
	
	ТекстОшибки = ?(ЭтоРезервирование,
		НСтр("ru = 'Минимальный статус документа для резервирования под назначение - ""%1"".'"),
		НСтр("ru = 'Минимальный статус документа для снятия резерва под назначение - ""%1"".'"));
	
	ТекстОшибки = СтрШаблон(ТекстОшибки, МинимальныйСтатус);
	
	ПоказатьПредупреждение(, ТекстОшибки);
	
КонецПроцедуры

// Предназначена для проверки заполнения полей перед выполнением команды по заполнению обеспечения в документах.
//
// Параметры:
//  Объект - ДанныеФормыСтруктура - основной реквизит формы документа, связанный с редактируемым объектом-документом в
//                                  которым нужно выполнить проверки заполнения полей.
//  ТаблицаТовары - ДанныеФормыКоллекция - список в котором необходимо выполнить проверки заполнения полей
//  ПараметрыПроверки - Структура - структура параметров проверки, формируемая функцией ОбеспечениеКлиентСервер.ИнициализироватьПараметрыПроверкиЗаполнения
//  ПутиКДанным - Строка - имена полей документа через запятую, если они отличаются от стандартных: "НомерСтроки",
//                         "Отменено", "Номенклатура", "Характеристика", "Склад", "Подразделение", "Назначение",
//                         "ТипНоменклатуры", "ХарактеристикиИспользуются", "КлючСвязиЭтапы", "Количество", "КоличествоУпаковок".
//  Склад - СправочникСсылка.Склады - значение поля склад (склад - отгрузки) из шапки документа.
//
// Возвращаемое значение:
//  Булево - истина, если проверка заполнения выполнена успешно, ложь - в противном случае.
//
Функция ПроверитьЗаполнение(Объект, ТаблицаТовары, Строки, ПараметрыПроверки, ПутиКДанным = Неопределено, Склад = Неопределено) Экспорт

	Пути = "НомерСтроки,
	       |Отменено,
	       |Номенклатура, Характеристика, Склад, Подразделение, Назначение,
	       |ТипНоменклатуры, ХарактеристикиИспользуются, КлючСвязиЭтапы,
	       |Количество, КоличествоУпаковок";

	ДанныеСтроки = Новый Структура(Пути);
	Ошибки = Новый Массив();

	Хранилище = Новый Структура(Пути);

	Если ПутиКДанным = Неопределено Тогда
		ПутиКДанным = Новый Соответствие();
	КонецЕсли;

	Для Каждого Свойство Из ПутиКДанным Цикл
		Хранилище.Вставить(Свойство.Значение);
	КонецЦикла;

	ЗаполнитьЗначенияСвойств(Хранилище, Объект);

	Если ТипЗнч(Строки) = Тип("Массив") Тогда
		ИдентификаторыСтрок = Строки;
	Иначе
		ИдентификаторыСтрок = Новый Массив();
		ИдентификаторыСтрок.Добавить(Строки);
	КонецЕсли;

	Если ИдентификаторыСтрок.Количество() = 0 Тогда

		ПоказатьПредупреждение(, НСтр("ru = 'Для заполнения обеспечения необходимо выделить строки.'"));

		Возврат Ложь;

	КонецЕсли;

	СкладВТабЧасти         = ПараметрыПроверки.Поля.Свойство("Склад")
		И СтрНайти(ПараметрыПроверки.Поля["Склад"], "[") > 0;
		
	ПодразделениеВТабЧасти = ПараметрыПроверки.Поля.Свойство("Подразделение")
		И СтрНайти(ПараметрыПроверки.Поля["Подразделение"], "[") > 0;

	ЕстьОшибкиСклад         = Ложь;
	ЕстьОшибкиПодразделение = Ложь;
	
	Для Каждого Идентификатор Из ИдентификаторыСтрок Цикл

		СтрокаТовары = ТаблицаТовары.НайтиПоИдентификатору(Идентификатор);
		ЗаполнитьЗначенияСвойств(Хранилище, СтрокаТовары);

		ОбеспечениеКлиентСервер.ЗаполнитьЗначенияСвойствСРазличиемИмен(ДанныеСтроки, Хранилище, ПутиКДанным);

		Если ДанныеСтроки.Отменено = Истина Тогда
			
			Если ИдентификаторыСтрок.Количество() = 1 Тогда

				ПоказатьПредупреждение(, НСтр("ru = 'Для отмененной строки обеспечение и отгрузка невозможны.'"));

				Возврат Ложь;

			Иначе
				Продолжить;
			КонецЕсли;

		КонецЕсли;

		Если ДанныеСтроки.Количество = 0 И ДанныеСтроки.КоличествоУпаковок = 0 Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Количество", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если ДанныеСтроки.Количество = 0 И ДанныеСтроки.КоличествоУпаковок <> 0 Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "КоличествоУпаковок", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДанныеСтроки.Номенклатура) Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Номенклатура", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если Не ЗначениеЗаполнено(ДанныеСтроки.Характеристика) И ДанныеСтроки.ХарактеристикиИспользуются = Истина Тогда

			Ошибка = Новый Структура("Поле, НомерСтроки", "Характеристика", ДанныеСтроки.НомерСтроки);
			Ошибки.Добавить(Ошибка);

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("Склад") И Не ЗначениеЗаполнено(Склад) И Не ЗначениеЗаполнено(ДанныеСтроки.Склад)
			И (ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар")
				Или ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара")) Тогда

			Если СкладВТабЧасти Или Не ЕстьОшибкиСклад Тогда
				Ошибка = Новый Структура("Поле, НомерСтроки", "Склад", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);
				ЕстьОшибкиСклад = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("Подразделение") И Не ЗначениеЗаполнено(ДанныеСтроки.Подразделение)
			И ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

			Если ПодразделениеВТабЧасти Или Не ЕстьОшибкиПодразделение Тогда
				Ошибка = Новый Структура("Поле, НомерСтроки", "Подразделение", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);
				ЕстьОшибкиПодразделение = Истина;
			КонецЕсли;

		КонецЕсли;

		Если ПараметрыПроверки.Поля.Свойство("КлючСвязиЭтапы") И Не ЗначениеЗаполнено(ДанныеСтроки.КлючСвязиЭтапы)
			И ДанныеСтроки.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда

				Ошибка = Новый Структура("Поле, НомерСтроки", "КлючСвязиЭтапы", ДанныеСтроки.НомерСтроки);
				Ошибки.Добавить(Ошибка);

		КонецЕсли;

	КонецЦикла;

	ОшибкиПользователю = Неопределено;

	Для Каждого Ошибка Из Ошибки Цикл

		Поле  = СтрЗаменить(ПараметрыПроверки.Поля[Ошибка.Поле], "%1", Ошибка.НомерСтроки - 1);
		Текст = СтрЗаменить(ПараметрыПроверки.Тексты[Ошибка.Поле], "%1", Ошибка.НомерСтроки);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ОшибкиПользователю, Поле, Текст, "");

	КонецЦикла;

	ОчиститьСообщения();
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(ОшибкиПользователю);

	Возврат Ошибки.Количество() = 0;

КонецФункции

#КонецОбласти
