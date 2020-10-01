#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
	Если Сводно Тогда
		НачисленнаяЗарплатаИВзносыПоФизлицам.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ИнициализироватьДокумент(ДанныеЗаполнения);
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоНовый() Тогда
		СсылкаНаОбъект = Документы.ОтражениеЗарплатыВФинансовомУчете.ПолучитьСсылку();
		УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
	ПараметрыУчетнойПолитики = РегистрыСведений.УчетнаяПолитикаОрганизаций.ПараметрыУчетнойПолитики(Организация, КонецМесяца(ПериодРегистрации));
	
	Если ПараметрыУчетнойПолитики <> Неопределено Тогда
		ПроводкиПоРаботникам = ПараметрыУчетнойПолитики.ПроводкиПоРаботникам И ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") И Не Сводно;
	КонецЕсли;
	
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Тогда
			Строка.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ЗаймыВыданные;
			Строка.АналитикаАктивовПассивов = Неопределено;
		КонецЕсли;
		
		Если Строка.ЯвляетсяОснованиемОформленияКассовогоЧека Тогда
			Строка.ИдентификаторФискальнойЗаписи =
				Документы.ОтражениеЗарплатыВФинансовомУчете.ИдентификаторФискальнойЗаписи(Ссылка, Строка);
		Иначе
			Строка.ИдентификаторФискальнойЗаписи = "";
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Строка Из НачисленныйНДФЛ Цикл
		Строка.ТипНалога = Перечисления.ТипыНалогов.ТипНалогаОперацииПоЗарплаты(Строка.ВидОперации);
	КонецЦикла;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("ПериодРегистрации");
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Месяц"" не заполнено'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			,
			"ПериодРегистрацииСтрокой",
			,
			Отказ);
		
	КонецЕсли;
	
	Если НачисленнаяЗарплатаИВзносы.Количество() = 0 И НачисленныйНДФЛ.Количество() = 0
		И УдержаннаяЗарплата.Количество() = 0 И НачисленныеПроцентыПоЗаймам.Количество() = 0
		И НачисленныеОтпускаЗаСчетРезерва.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Списки документа не содержат ни одной строки'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			ЭтотОбъект,
			,
			,
			Отказ);
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленнаяЗарплатаИВзносы.СпособОтраженияЗарплатыВБухучете");
	
	Для Каждого Строка Из НачисленнаяЗарплатаИВзносы Цикл
		
		Если Строка.Сумма = 0 И Строка.ВзносыВсего = 0 Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнена сумма начисления и взносов в строке %1 списка ""Начисления и взносы""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "Сумма"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.СпособОтраженияЗарплатыВБухучете)
			И Документы.ОтражениеЗарплатыВФинансовомУчете.ТребуетсяСпособОтражения(Строка.ВидОперации) Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Способ отражения"" в строке %1 списка ""Начисления и взносы""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Строка.НомерСтроки, "СпособОтраженияЗарплатыВБухучете"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ПодразделениеПредприятия");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПодразделения") Тогда
		
		СтруктураОтбора = Новый Структура("ВидОперации", Перечисления.ВидыОперацийПоЗарплате.НДФЛДоходыКонтрагентов);
		НайденныеСтроки = НачисленныйНДФЛ.НайтиСтроки(СтруктураОтбора);
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(Строка.ПодразделениеПредприятия) Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Подразделение"" в строке %1 списка ""НДФЛ""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленныйНДФЛ", Строка.НомерСтроки, "ПодразделениеПредприятия"),
				,
				Отказ);
		КонецЦикла;
	КонецЕсли;
	
	ПроверитьНаличиеБазыРаспределения(Отказ);
	
	Если Сводно Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НачисленныйНДФЛ.ФизическоеЛицо");
	КонецЕсли;
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("УдержаннаяЗарплата"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ПланыВидовХарактеристик.СтатьиДоходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, Новый Структура("НачисленныеПроцентыПоЗаймам"), МассивНепроверяемыхРеквизитов, Отказ);
	
	ИспользоватьПрочиеАктивыПассивы = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов");
	Для Каждого Строка Из УдержаннаяЗарплата Цикл
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок
			И Не ЗначениеЗаполнено(Строка.СтатьяДоходов) Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Статья доходов"" в строке %1 списка ""Удержания""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяДоходов"),
				,
				Отказ);
			
		КонецЕсли;
		
		Если Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПогашениеЗаймов Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ПроцентыПоЗайму Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм Или
			Строка.ВидОперации = Перечисления.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок Тогда
			Продолжить;
		КонецЕсли;

		Если Не ЗначениеЗаполнено(Строка.СтатьяАктивовПассивов) И ИспользоватьПрочиеАктивыПассивы Тогда
			
			ТекстСообщения = НСтр("ru = 'Не заполнена колонка ""Статья пассивов"" в строке %1 списка ""Удержания""'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Строка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("УдержаннаяЗарплата", Строка.НомерСтроки, "СтатьяАктивовПассивов"),
				,
				Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяАктивовПассивов");
	МассивНепроверяемыхРеквизитов.Добавить("УдержаннаяЗарплата.СтатьяДоходов");
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ОтражениеЗарплатыВФинансовомУчете.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по прочим расходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по прочим доходам.
	ДоходыИРасходыСервер.ОтразитьПрочиеДоходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по партиям прочих расходов.
	ДоходыИРасходыСервер.ОтразитьПартииПрочихРасходов(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по списанию резерва отпусков
	ОтражениеЗарплатыВФинансовомУчетеУП.ОтразитьСписаниеРезерваОтпусков(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по трудозатратам незавершенного производства
	ОтражениеЗарплатыВФинансовомУчетеУП.ОтразитьТрудозатратыНезавершенногоПроизводства(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по отражению зарплаты в финансовом учете
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияОтражениеЗарплатыВФинансовомУчете(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по оборотным регистрам управленческого учета
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДоходыРасходыПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	УправленческийУчетПроведениеСервер.ОтразитьДвиженияДенежныеСредстваДоходыРасходы(ДополнительныеСвойства, Движения, Отказ);
	
	// Движения по отражению зарплаты в учете прочих пассивов
	ДоходыИРасходыСервер.ОтразитьПрочиеАктивыПассивы(ДополнительныеСвойства, Движения, Отказ);
	
	РеглУчетПроведениеСервер.ОтразитьПорядокОтраженияПрочихОпераций(ДополнительныеСвойства, Отказ);
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	Если УчетнаяПолитика.ПрименяетсяУСН(Организация, Дата) Тогда
		УчетУСНСервер.ОтразитьДоходКУДиР(ДополнительныеСвойства, Движения, Отказ);
	КонецЕсли;
	
	// Движения по денежным средствам.
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваУПодотчетныхЛиц(ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПроверитьНаличиеБазыРаспределения(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленнаяЗарплата.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	НачисленнаяЗарплата.ВидОперации КАК ВидОперации,
	|	НачисленнаяЗарплата.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	НачисленнаяЗарплата.НомерСтроки КАК НомерСтроки,
	|	НачисленнаяЗарплата.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД
	|ПОМЕСТИТЬ ВТДанныеДокумента
	|ИЗ
	|	&НачисленнаяЗарплата КАК НачисленнаяЗарплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НачисленнаяЗарплата.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	НачисленнаяЗарплата.ВидОперации КАК ВидОперации,
	|	НачисленнаяЗарплата.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	НачисленнаяЗарплата.НомерСтроки КАК НомерСтроки,
	|	НачисленнаяЗарплата.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД
	|ПОМЕСТИТЬ ВТДанныеДокументаСводно
	|ИЗ
	|	&НачисленнаяЗарплатаСводно КАК НачисленнаяЗарплата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДД.Подразделение КАК Подразделение,
	|	СУММА(ДД.НормативнаяСтоимость) КАК НормативнаяСтоимость,
	|	СУММА(ВЫБОР
	|		КОГДА ВидыРабот.КратностьТрудоемкости > 0
	|			ТОГДА ВЫРАЗИТЬ(ДД.Количество * ВидыРабот.Трудоемкость / ВидыРабот.КратностьТрудоемкости КАК ЧИСЛО(15,3))
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ) КАК Длительность,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ КАК ФизическоеЛицо
	|ПОМЕСТИТЬ ВТБазаРаспределения
	|ИЗ
	|	РегистрНакопления.ТрудозатратыНезавершенногоПроизводства КАК ДД
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыРаботСотрудников КАК ВидыРабот
	|			ПО ДД.ВидРабот = ВидыРабот.Ссылка
	|ГДЕ
	|	ДД.Подразделение В
	|			(ВЫБРАТЬ
	|				Т.ПодразделениеПредприятия
	|			ИЗ
	|				ВТДанныеДокумента КАК Т)
	|	И ДД.Организация = &Организация
	|	И ДД.Период МЕЖДУ &НачалоПериода И &ОкончаниеПериода
	|
	|СГРУППИРОВАТЬ ПО
	|	Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	ВЫБОР
	|		КОГДА &Сводно
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ ДД.Сотрудник
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЕСТЬNULL(ВТДанныеДокументаСводно.НомерСтроки, ВТДанныеДокумента.НомерСтроки) КАК НомерСтроки,
	|	ВТДанныеДокумента.ПодразделениеПредприятия КАК ПодразделениеПредприятия,
	|	ВТДанныеДокумента.ВидОперации КАК ВидОперации,
	|	ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете КАК СпособОтраженияЗарплатыВБухучете,
	|	ВТДанныеДокумента.ФизическоеЛицо.Наименование КАК ПредставлениеФизЛица,
	|	ВТДанныеДокумента.ОблагаетсяЕНВД КАК ОблагаетсяЕНВД,
	|	ВЫБОР
	|		КОГДА ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ДлительностьВыполненияРабот)
	|			И ЕСТЬNULL(ВТБазаРаспределения.НормативнаяСтоимость,0) > 0
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ТипСообщения
	|ИЗ
	|	ВТДанныеДокумента КАК ВТДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТБазаРаспределения КАК ВТБазаРаспределения
	|		ПО ВТДанныеДокумента.ПодразделениеПредприятия = ВТБазаРаспределения.Подразделение
	|			И ВТДанныеДокумента.ФизическоеЛицо = ВТБазаРаспределения.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДанныеДокументаСводно КАК ВТДанныеДокументаСводно
	|		ПО ВТДанныеДокумента.ПодразделениеПредприятия = ВТДанныеДокументаСводно.ПодразделениеПредприятия
	|			И ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете = ВТДанныеДокументаСводно.СпособОтраженияЗарплатыВБухучете
	|			И ВТДанныеДокумента.ВидОперации = ВТДанныеДокументаСводно.ВидОперации
	|			И ВТДанныеДокумента.ОблагаетсяЕНВД = ВТДанныеДокументаСводно.ОблагаетсяЕНВД
	|ГДЕ
	|	ВТДанныеДокумента.ПодразделениеПредприятия <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|	И ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.ОплатаСдельныхРабот
	|	И (ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.НормативыОплатыТруда)
	|			И ЕСТЬNULL(ВТБазаРаспределения.НормативнаяСтоимость,0) = 0
	|		ИЛИ
	|		ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете.БазаРаспределенияПоСдельнымРаботам = ЗНАЧЕНИЕ(Перечисление.ТипыБазыРаспределенияРасходов.ДлительностьВыполненияРабот)
	|			И ЕСТЬNULL(ВТБазаРаспределения.Длительность,0) = 0
	|	)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЕСТЬNULL(ВТДанныеДокументаСводно.НомерСтроки, ВТДанныеДокумента.НомерСтроки),
	|	ВТДанныеДокумента.ПодразделениеПредприятия,
	|	ВТДанныеДокумента.ВидОперации,
	|	ВТДанныеДокумента.СпособОтраженияЗарплатыВБухучете,
	|	ВТДанныеДокумента.ОблагаетсяЕНВД
	|	
	|";
	
	Если Сводно Тогда
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносы.Выгрузить(, "ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "НачисленнаяЗарплата.ФизическоеЛицо КАК ФизическоеЛицо", "ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка) КАК ФизическоеЛицо");
		Запрос.УстановитьПараметр("НачисленнаяЗарплатаСводно", НачисленнаяЗарплатаИВзносы.ВыгрузитьКолонки("ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		
	Иначе
		Запрос.УстановитьПараметр("НачисленнаяЗарплата", НачисленнаяЗарплатаИВзносыПоФизлицам.Выгрузить(, "ПодразделениеПредприятия, ФизическоеЛицо, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
		Запрос.УстановитьПараметр("НачисленнаяЗарплатаСводно", НачисленнаяЗарплатаИВзносы.Выгрузить(, "ПодразделениеПредприятия, ОблагаетсяЕНВД, НомерСтроки, СпособОтраженияЗарплатыВБухучете, ВидОперации"));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("НачалоПериода",       НачалоМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("ОкончаниеПериода",    КонецМесяца(ПериодРегистрации));
	Запрос.УстановитьПараметр("Организация",         Организация);
	Запрос.УстановитьПараметр("Сводно",              Сводно);
	Запрос.УстановитьПараметр("Ссылка",              Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	СтруктураСтроки = Новый Структура("ПодразделениеПредприятия, ВидОперации, СпособОтраженияЗарплатыВБухучете, ОблагаетсяЕНВД, НомерСтроки, ТипСообщения");
	
	ТекстыСводно = Новый Массив;
	ТекстыСводно.Добавить(НСтр("ru = 'В подразделении %1 не регистрировалась выработка сотрудников (строка %2 списка ""Начисленная зарплата и взносы"")'"));
	ТекстыСводно.Добавить(НСтр("ru = 'Не задана трудоемкость выполннных работ в подразделении %1 (строка %2 списка ""Начисленная зарплата и взносы"")'"));
	
	ТекстыДетально = Новый Массив;
	ТекстыДетально.Добавить(НСтр("ru = 'Выработка сотрудника (-ов) %1 в подразделении ""%2"" не регистрировалась (строка %3 списка ""Начисленная зарплата и взносы"")'"));
	ТекстыДетально.Добавить(НСтр("ru = 'Не задана трудоемкость работ сотрудника (-ов) %1 в подразделении ""%2"" (строка %3 списка ""Начисленная зарплата и взносы"")'"));
	
	ТекстСотрудники = "";
	НомерСтрокиСводнойТаблицы = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Если Сводно Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыСводно[Выборка.ТипСообщения], Выборка.ПодразделениеПредприятия, Выборка.НомерСтроки),
				ЭтотОбъект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", Выборка.НомерСтроки, "ПодразделениеПредприятия"),
				,
				Отказ);
			
		Иначе
			
			Если СтруктураСтроки.ПодразделениеПредприятия <> Выборка.ПодразделениеПредприятия
				Или СтруктураСтроки.ВидОперации <> Выборка.ВидОперации
				Или СтруктураСтроки.СпособОтраженияЗарплатыВБухучете <> Выборка.СпособОтраженияЗарплатыВБухучете
				Или СтруктураСтроки.ОблагаетсяЕНВД <> Выборка.ОблагаетсяЕНВД Тогда
				
				Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыДетально[СтруктураСтроки.ТипСообщения], ТекстСотрудники, СтруктураСтроки.ПодразделениеПредприятия, СтруктураСтроки.НомерСтроки),
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", СтруктураСтроки.НомерСтроки, "ПодразделениеПредприятия"),
						,
						Отказ);
					
				КонецЕсли;
				
				ЗаполнитьЗначенияСвойств(СтруктураСтроки, Выборка);
				ТекстСотрудники = "";
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
				ТекстСотрудники = ТекстСотрудники + ", " + Выборка.ПредставлениеФизЛица;
			Иначе
				ТекстСотрудники = Выборка.ПредставлениеФизЛица;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Если ЗначениеЗаполнено(ТекстСотрудники) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстыДетально[СтруктураСтроки.ТипСообщения], ТекстСотрудники, СтруктураСтроки.ПодразделениеПредприятия, СтруктураСтроки.НомерСтроки),
			ЭтотОбъект,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("НачисленнаяЗарплатаИВзносы", СтруктураСтроки.НомерСтроки, "ПодразделениеПредприятия"),
			,
		Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
