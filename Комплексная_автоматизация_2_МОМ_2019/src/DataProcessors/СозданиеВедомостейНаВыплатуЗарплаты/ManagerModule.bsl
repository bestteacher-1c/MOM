#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Создание_ведомостей 

Функция ПараметрыСозданияВедомостейПоРасчетномуДокументу() Экспорт
	
	ПараметрыСозданияВедомостейПоРасчетномуДокументу = Новый Структура;
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("СпособВыплаты");
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("ДатаВыплаты");
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("Округление");
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("ВРазрезеПодразделений");
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("ВРазрезеСтатейФинансирования");
	ПараметрыСозданияВедомостейПоРасчетномуДокументу.Вставить("ВРазрезеСтатейРасходов");
	
	Возврат ПараметрыСозданияВедомостейПоРасчетномуДокументу;
	
КонецФункции

Функция СоздатьВедомостиПоРасчетномуДокументу(РасчетныйДокумент, ПараметрыСоздания) Экспорт
	
	СпособВыплаты = ПараметрыСоздания.СпособВыплаты.ПолучитьОбъект();
	
	ВедомостиПоРасчетномуДокументу = Новый Массив;
	
	// Организацию и период регистрации определяем по выплатам, зарегистрированным документом. 
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", РасчетныйДокумент);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗарплатаКВыплате.Организация КАК Организация
	|ИЗ
	|	РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|ГДЕ
	|	ЗарплатаКВыплате.Регистратор = &Регистратор";
	ВыборкаОрганизации = Запрос.Выполнить().Выбрать();
	Если Не ВыборкаОрганизации.Следующий() Тогда
		Возврат ВедомостиПоРасчетномуДокументу
	КонецЕсли;	
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ЗарплатаКВыплате.Период) КАК ПериодРегистрации
	|ИЗ
	|	РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|ГДЕ
	|	ЗарплатаКВыплате.Регистратор = &Регистратор";
	ВыборкаПериода = Запрос.Выполнить().Выбрать();
	ВыборкаПериода.Следующий();

	// Получаем зарплату и налог по документу.
	
	ОписаниеОперации = ВедомостьНаВыплатуЗарплаты.ОписаниеОперацииВыплаты();
	ОписаниеОперации.Организация        = ВыборкаОрганизации.Организация;
	ОписаниеОперации.ПериодРегистрации  = ВыборкаПериода.ПериодРегистрации;
	ОписаниеОперации.Дата               = ПараметрыСоздания.ДатаВыплаты;
	ОписаниеОперации.ПорядокВыплаты     = СпособВыплаты.ХарактерВыплаты;
	ОписаниеОперации.СпособПолучения    = СпособВыплаты.СпособПолучения;
	
	ОписаниеОперации.ДокументыОснования = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РасчетныйДокумент);
	
	ОтборСотрудников = ВедомостьНаВыплатуЗарплаты.ОтборСотрудниковДляВыплаты();
	ОтборСотрудников.ВидыДоговоров = СпособВыплаты.ГруппаВидовДоговоров;
	
	ПараметрыРасчетаЗарплаты = ВедомостьНаВыплатуЗарплаты.ПараметрыРасчетаЗарплаты();
	ПараметрыРасчетаЗарплаты.Округление = СпособВыплаты.Округление;

	Зарплата = ВедомостьНаВыплатуЗарплаты.ЗарплатаКВыплате(
		ОписаниеОперации,
		ОтборСотрудников,
		ПараметрыРасчетаЗарплаты);
		
	// Получаем кадровые данные сотрудников.
	КадровыеДанные = 
		КадровыйУчет.КадровыеДанныеСотрудников(
			Истина, 
			Зарплата.ВыгрузитьКолонку("Сотрудник"), 	
			"Подразделение, ВидМестаВыплаты, МестоВыплаты",
			ПараметрыСоздания.ДатаВыплаты);
	КадровыеДанные.Индексы.Добавить("Сотрудник");
	
	// Дописываем кадровые данные к таблице зарплаты
	Зарплата.Колонки.Добавить("ПодразделениеВыплаты", КадровыеДанные.Колонки.Подразделение.ТипЗначения);
	Зарплата.Колонки.Добавить("ВидМестаВыплаты",      КадровыеДанные.Колонки.ВидМестаВыплаты.ТипЗначения);
	Зарплата.Колонки.Добавить("МестоВыплаты",         КадровыеДанные.Колонки.МестоВыплаты.ТипЗначения);
	Для Каждого СтрокаЗарплаты Из Зарплата Цикл
		СтрокаКадровыхДанных = КадровыеДанные.Найти(СтрокаЗарплаты.Сотрудник, "Сотрудник");
		СтрокаЗарплаты.ПодразделениеВыплаты = СтрокаКадровыхДанных.Подразделение;
		Если ЗначениеЗаполнено(СтрокаКадровыхДанных.ВидМестаВыплаты) Тогда
			СтрокаЗарплаты.ВидМестаВыплаты = СтрокаКадровыхДанных.ВидМестаВыплаты;
			Если СтрокаКадровыхДанных.ВидМестаВыплаты = Перечисления.ВидыМестВыплатыЗарплаты.БанковскийСчет Тогда
				// все перечисления на банковские счета - в одну ведомость.
				СтрокаЗарплаты.МестоВыплаты = Справочники.КлассификаторБанков.ПустаяСсылка();
			Иначе	
				СтрокаЗарплаты.МестоВыплаты = СтрокаКадровыхДанных.МестоВыплаты;
			КонецЕсли;	
		Иначе
			// по умолчанию - в кассу.
			СтрокаЗарплаты.ВидМестаВыплаты = Перечисления.ВидыМестВыплатыЗарплаты.Касса;
			СтрокаЗарплаты.МестоВыплаты    = Справочники.Кассы.ПустаяСсылка();
		КонецЕсли	
	КонецЦикла;	
	
	// Определяем уникальные сочетания ключевых полей будущих ведомостей
	
	ПоляКлючаВедомости = Новый Массив;
	ПоляКлючаВедомости.Добавить("ВидМестаВыплаты");
	ПоляКлючаВедомости.Добавить("МестоВыплаты");
	Если ПараметрыСоздания.ВРазрезеПодразделений Тогда
		ПоляКлючаВедомости.Добавить("ПодразделениеВыплаты");
	КонецЕсли;	
	Если ПараметрыСоздания.ВРазрезеСтатейФинансирования Тогда
		ПоляКлючаВедомости.Добавить("СтатьяФинансирования");
	КонецЕсли;	
	Если ПараметрыСоздания.ВРазрезеСтатейРасходов Тогда
		ПоляКлючаВедомости.Добавить("СтатьяРасходов");
	КонецЕсли;	
	
	КолонкиКлючаВедомости = СтрСоединить(ПоляКлючаВедомости, ", "); // Не локализуется
	КлючиВедомостей = Зарплата.Скопировать(, КолонкиКлючаВедомости);
	КлючиВедомостей.Свернуть(КолонкиКлючаВедомости);
	
	Для Каждого ПолеКлючаВедомости Из ПоляКлючаВедомости Цикл
		КлючиВедомостей.Индексы.Добавить(ПолеКлючаВедомости);
	КонецЦикла;		

	// По каждому ключу создаем ведомость,
	// выбираем приходящуюся на нее зарплату,
	// определяем из этой зарплаты налог к удержанию
	
	ПараметрыРасчетаНДФЛ = ВедомостьНаВыплатуЗарплаты.ПараметрыРасчетаНДФЛ();	
	ПараметрыРасчетаНДФЛ.ПланируемаяДатаВыплаты = ПараметрыСоздания.ДатаВыплаты;
	ПараметрыРасчетаНДФЛ.ОкончательныйРасчет    = СпособВыплаты.ОкончательныйРасчетНДФЛ;
	
	ПараметрыОтбораЗарплаты = Новый Структура(КолонкиКлючаВедомости);
	
	РанееУдержано = Неопределено;
	Для Каждого КлючВедомости Из КлючиВедомостей Цикл
		
		Ведомость = НоваяВедомостьПоКлючу(КлючВедомости, ОписаниеОперации, СпособВыплаты);
		
		ЗаполнитьЗначенияСвойств(ПараметрыОтбораЗарплаты, КлючВедомости);
		ЗарплатаВедомости = Зарплата.Скопировать(ПараметрыОтбораЗарплаты);
		
		Финансирование = ВедомостьНаВыплатуЗарплаты.ФинансированиеВыплаты();
		ЗаполнитьЗначенияСвойств(Финансирование, КлючВедомости);
		НДФЛВедомости = ВедомостьНаВыплатуЗарплаты.НалогиКУдержанию(
			ЗарплатаВедомости, 
			ОписаниеОперации, 
			ПараметрыРасчетаНДФЛ,
			Финансирование,,
			РанееУдержано);
			
			Если РанееУдержано = Неопределено Тогда
				РанееУдержано = НДФЛВедомости.Скопировать();
			Иначе
				ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НДФЛВедомости, РанееУдержано);
			КонецЕсли;
		
		Ведомость.ЗагрузитьВыплаты(ЗарплатаВедомости, НДФЛВедомости);

		ВедомостиПоРасчетномуДокументу.Добавить(Ведомость);
		
	КонецЦикла;
	
	Возврат ВедомостиПоРасчетномуДокументу	
	
КонецФункции

Функция НоваяВедомостьПоКлючу(КлючВедомости, ОписаниеОперации, СпособВыплаты)
	
	ДокументМенеджер = ВедомостьНаВыплатуЗарплаты.МенеджерДокументаПоВидуМестаВыплаты(КлючВедомости.ВидМестаВыплаты); 
	
	Ведомость = ДокументМенеджер.СоздатьДокумент();
	Ведомость.УстановитьСсылкуНового(ДокументМенеджер.ПолучитьСсылку());	
	
	Ведомость.Организация       = ОписаниеОперации.Организация;
	Ведомость.ПериодРегистрации = ОписаниеОперации.ПериодРегистрации;
	Ведомость.Дата              = ОписаниеОперации.Дата;
	Ведомость.ПеречислениеНДФЛВыполнено = Не ПолучитьФункциональнуюОпцию("ВестиРасчетыСБюджетомПоНДФЛ");
	Основание = Ведомость.Основания.Добавить();
	Основание.Документ = ОписаниеОперации.ДокументыОснования[0];
	
	Ведомость.УстановитьМестоВыплаты(КлючВедомости.МестоВыплаты);

	Ведомость.СпособВыплаты  = СпособВыплаты.Ссылка;
	Ведомость.Округление     = СпособВыплаты.Округление;
	Ведомость.ПроцентВыплаты = СпособВыплаты.ПроцентВыплаты;
	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(КлючВедомости, "ПодразделениеВыплаты") Тогда
		Ведомость.Подразделение        = КлючВедомости.ПодразделениеВыплаты;
	КонецЕсли;	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(КлючВедомости, "СтатьяФинансирования") Тогда
		Ведомость.СтатьяФинансирования = КлючВедомости.СтатьяФинансирования;
	КонецЕсли;	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(КлючВедомости, "СтатьяРасходов") Тогда
		Ведомость.СтатьяРасходов       = КлючВедомости.СтатьяРасходов;
	КонецЕсли;	
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Ведомость, "ВидДоходаИсполнительногоПроизводства") 
		И ВидыДоходовИсполнительногоПроизводстваКлиентСервер.ВидДоходаОбязателенДляБанков(Ведомость.Дата)Тогда
		Ведомость.ВидДоходаИсполнительногоПроизводства = Перечисления.ВидыДоходовИсполнительногоПроизводства.ЗарплатаВознаграждения;
	КонецЕсли;	
	
	ЗаполняемыеЗначения = Новый Структура;
	ЗаполняемыеЗначения.Вставить("Организация");
	ЗаполняемыеЗначения.Вставить("Ответственный");
	ЗаполнитьЗначенияСвойств(ЗаполняемыеЗначения, Ведомость);
	ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
	ЗаполнитьЗначенияСвойств(Ведомость, ЗаполняемыеЗначения,, "Организация");
	
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(
		Ведомость.Метаданные(), 
		Ведомость.Организация);	
	ЗаполнитьЗначенияСвойств(Ведомость, СведенияОПодписях);
	
	Возврат Ведомость
	
КонецФункции

#КонецОбласти

#Область Сохранение_ведомостей 

Функция ПроверитьВедомости(Ведомости) Экспорт
	
	Отказ = Ложь;
	Для Каждого Ведомость Из Ведомости Цикл
		Если Не Ведомость.ПроверитьЗаполнение() Тогда
			Сообщения = ПолучитьСообщенияПользователю(Ложь);
			Для Каждого Сообщение Из Сообщения Цикл
				Сообщение.КлючДанных = Ведомость.ПолучитьСсылкуНового();
			КонецЦикла;
			Отказ = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Не Отказ
	
КонецФункции

Процедура СохранитьВедомости(Ведомости, РежимЗаписи)	Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Для Каждого Ведомость Из Ведомости Цикл
			Ведомость.Записать(РежимЗаписи);
		КонецЦикла;	
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(
			НСтр(
				"ru = 'Создание ведомостей на выплату зарплаты.Сохранение и проведение ведомостей'", 
				ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		   
	    ВызватьИсключение;
	
	КонецПопытки;
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли