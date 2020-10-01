#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	//++ НЕ УТ
	Если ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
		Для Каждого Строка Из Списание Цикл
			Строка.НаправлениеДеятельности = НаправлениеДеятельности;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаСписания Из Списание Цикл
		
		Если ЗначениеЗаполнено(СтрокаСписания.Подразделение) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаСписания.Подразделение = Подразделение;
		
	КонецЦикла;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВзаиморасчетыСервер.ЗаполнитьИдентификаторыСтрокВТабличнойЧасти(Списание);
	КонецЕсли;
		
	ВсегоДолейСтоимости = ДоляСтоимостиНаПроизводство + ДоляСтоимостиНаНЗП + ДоляСтоимостиНаСтатьи;
	
	Если Не НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные
		И Не НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам
		И Не ПодразделенияУказаныВручную Тогда
		
		ОтборПоПодразделениям.Очистить();
		// Кеширование подразделений.
		ПодразделенияПоНаправлению = Документы.РаспределениеПрочихЗатрат.ПодразделенияПоНаправлению(
			Подразделение, НаправлениеРаспределения);
		Для Каждого ПодразделениеОтбора Из ПодразделенияПоНаправлению Цикл
			
			НоваяПозицияОтбора = ОтборПоПодразделениям.Добавить();
			НоваяПозицияОтбора.Подразделение = ПодразделениеОтбора;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение
		И НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И (НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Вышестоящее
			Или НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Нижестоящие)
		И ОтборПоПодразделениям.Количество() = 0 Тогда
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Вышестоящее Тогда
			ТекстОшибки = НСтр("ru = 'У подразделения отсутствует вышестоящее подразделение.'");
		Иначе
			ТекстОшибки = НСтр("ru = 'У подразделения отсутствуют нижестоящие подразделения.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"НаправлениеРаспределения",
			,
			Отказ);
			
	КонецЕсли;
	//-- НЕ УТ
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	РаспределениеПрочихЗатратЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И Не ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РегистрыСведений.РеестрДокументов.ИнициализироватьИЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	РаспределениеПрочихЗатратЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
		
		КлючПравилаРаспределения = "";
		Если (УправленческийУчет И РегламентированныйУчет)
			Или УправленческийУчет Тогда
			КлючПравилаРаспределения = "ПравилоРаспределенияУпр";
		Иначе
			КлючПравилаРаспределения = "ПравилоРаспределенияРегл";
		КонецЕсли;
			
		Если ДанныеЗаполнения.Свойство(КлючПравилаРаспределения)
			И ЗначениеЗаполнено(ДанныеЗаполнения[КлючПравилаРаспределения]) Тогда
			//++ НЕ УТ
			Если ТипЗнч(ДанныеЗаполнения[КлючПравилаРаспределения]) = Тип("СправочникСсылка.ПравилаРаспределенияРасходов") Тогда
			//-- НЕ УТ
				
				ТекстЗапроса = 
					"ВЫБРАТЬ
					|	ПравилаРаспределения.НазначениеПравила КАК НазначениеНастройкиРаспределения,
					|	ПравилаРаспределения.НаправлениеРаспределения КАК НаправлениеРаспределения,
					|	ПравилаРаспределения.БазаРаспределенияПоПартиям КАК БазаРаспределенияПоПартиям,
					//++ НЕ УТ
					|	ПравилаРаспределения.РаспределятьПоПартиям КАК РаспределятьПоПартиям,
					|	ПравилаРаспределения.РаспределятьНаСтатьи КАК РаспределятьНаСтатьи,
					|	ПравилаРаспределения.БазаРаспределенияПоПодразделениям КАК БазаРаспределенияПоПодразделениям,
					|	ПравилаРаспределения.УточнятьПартииВДокументе КАК ПартииУказаныВручную,
					|	ПравилаРаспределения.ДоляСтоимостиНаПроизводство КАК ДоляСтоимостиНаПроизводство,
					|	ПравилаРаспределения.ДоляСтоимостиНаСтатьи КАК ДоляСтоимостиНаСтатьи,
					|	ПравилаРаспределения.Показатель КАК Показатель,
					|	ПравилаРаспределения.РаспределятьПоПодразделениям КАК РаспределятьПоПодразделениям,
					|	ПравилаРаспределения.ПодразделенияУказаныВручную КАК ПодразделенияУказаныВручную,
					|	ПравилаРаспределения.ОтборПоПодразделениям.(
					|		Подразделение КАК Подразделение
					|	) КАК ОтборПоПодразделениям,
					|	ПравилаРаспределения.ОтборПоМатериалам.(
					|		Материал КАК Материал
					|	) КАК ОтборПоМатериалам,
					|	ПравилаРаспределения.ОтборПоВидамРабот.(
					|		ВидРабот КАК ВидРабот
					|	) КАК ОтборПоВидамРабот,
					|	ПравилаРаспределения.ОтборПоГруппамПродукции.(
					|		ГруппаПродукции КАК ГруппаПродукции
					|	) КАК ОтборПоГруппамПродукции,
					|	ПравилаРаспределения.ОтборПоПродукции.(
					|		Продукция КАК Продукция
					|	) КАК ОтборПоПродукции,
					|	ПравилаРаспределения.Подразделения.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		Подразделение КАК Подразделение,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК ПоБазе,
					|	ПравилаРаспределения.Списание.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		СтатьяРасходов КАК СтатьяРасходов,
					|		АналитикаРасходов КАК АналитикаРасходов,
					|		ДоляСтоимости КАК ДоляСтоимости,
					|		АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
					|		СчетУчета КАК СчетУчета,
					|		Субконто1 КАК Субконто1,
					|		Субконто2 КАК Субконто2,
					|		Субконто3 КАК Субконто3,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ИдентификаторСтроки КАК ИдентификаторСтроки,
					|		Подразделение КАК Подразделение
					|	) КАК Списание,
					//-- НЕ УТ
					|	ПравилаРаспределения.ОтборПоНаправлениямДеятельности.(
					|		НаправлениеДеятельности КАК НаправлениеДеятельности
					|	) КАК ОтборПоНаправлениямДеятельности,
					|	ПравилаРаспределения.НаправленияДеятельности.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК НаправленияДеятельности
					|ИЗ
					|	Справочник.ПравилаРаспределенияРасходов КАК ПравилаРаспределения
					|ГДЕ
					|	ПравилаРаспределения.Ссылка = &Ссылка";
			//++ НЕ УТ
			Иначе
				
				ТекстЗапроса = 
					"ВЫБРАТЬ
					|	ПравилаРаспределения.НазначениеНастройкиРаспределения КАК НазначениеНастройкиРаспределения,
					|	ПравилаРаспределения.РаспределятьПоПартиям КАК РаспределятьПоПартиям,
					|	ПравилаРаспределения.РаспределятьНаСтатьи КАК РаспределятьНаСтатьи,
					|	ПравилаРаспределения.БазаРаспределенияПоПартиям КАК БазаРаспределенияПоПартиям,
					|	ПравилаРаспределения.БазаРаспределенияПоПодразделениям КАК БазаРаспределенияПоПодразделениям,
					|	ПравилаРаспределения.СтатьяКалькуляции КАК СтатьяКалькуляции,
					|	ПравилаРаспределения.НаправлениеРаспределения КАК НаправлениеРаспределения,
					|	ПравилаРаспределения.ПартииУказаныВручную КАК ПартииУказаныВручную,
					|	ПравилаРаспределения.ДоляСтоимостиНаПроизводство КАК ДоляСтоимостиНаПроизводство,
					|	ПравилаРаспределения.ДоляСтоимостиНаСтатьи КАК ДоляСтоимостиНаСтатьи,
					|	ПравилаРаспределения.Показатель КАК Показатель,
					|	ПравилаРаспределения.РаспределятьПоПодразделениям КАК РаспределятьПоПодразделениям,
					|	ПравилаРаспределения.ПодразделенияУказаныВручную КАК ПодразделенияУказаныВручную,
					|	ПравилаРаспределения.ОтборПоНаправлениямДеятельности.(
					|		НаправлениеДеятельности КАК НаправлениеДеятельности
					|	) КАК ОтборПоНаправлениямДеятельности,
					|	ПравилаРаспределения.ОтборПоПодразделениям.(
					|		Подразделение КАК Подразделение
					|	) КАК ОтборПоПодразделениям,
					|	ПравилаРаспределения.ОтборПоМатериалам.(
					|		Материал КАК Материал
					|	) КАК ОтборПоМатериалам,
					|	ПравилаРаспределения.ОтборПоВидамРабот.(
					|		ВидРабот КАК ВидРабот
					|	) КАК ОтборПоВидамРабот,
					|	ПравилаРаспределения.ОтборПоГруппамПродукции.(
					|		ГруппаПродукции КАК ГруппаПродукции
					|	) КАК ОтборПоГруппамПродукции,
					|	ПравилаРаспределения.ОтборПоПродукции.(
					|		Продукция КАК Продукция
					|	) КАК ОтборПоПродукции,
					|	ПравилаРаспределения.Списание.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		СтатьяРасходов КАК СтатьяРасходов,
					|		АналитикаРасходов КАК АналитикаРасходов,
					|		ДоляСтоимости КАК ДоляСтоимости,
					|		АналитикаАктивовПассивов КАК АналитикаАктивовПассивов,
					|		СчетУчета КАК СчетУчета,
					|		Субконто1 КАК Субконто1,
					|		Субконто2 КАК Субконто2,
					|		Субконто3 КАК Субконто3,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ИдентификаторСтроки КАК ИдентификаторСтроки,
					|		Подразделение КАК Подразделение
					|	) КАК Списание,
					|	ПравилаРаспределения.ПоБазе.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		Подразделение КАК Подразделение,
					|		СтатьяКалькуляции КАК СтатьяКалькуляции,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК ПоБазе,
					|	ПравилаРаспределения.НаправленияДеятельности.(
					|		Ссылка КАК Ссылка,
					|		НомерСтроки КАК НомерСтроки,
					|		НаправлениеДеятельности КАК НаправлениеДеятельности,
					|		ДоляСтоимости КАК ДоляСтоимости
					|	) КАК НаправленияДеятельности
					|ИЗ
					|	Документ.РаспределениеПрочихЗатрат КАК ПравилаРаспределения
					|ГДЕ
					|	ПравилаРаспределения.Ссылка = &Ссылка";
				
			КонецЕсли;
			//-- НЕ УТ
			
			Запрос = Новый Запрос;
			Запрос.Текст = ТекстЗапроса;
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения[КлючПравилаРаспределения]);
			//++ НЕ УТ
			УчетПоГруппамПродукции = ПолучитьФункциональнуюОпцию("АналитическийУчетПоГруппамПродукции");
			//-- НЕ УТ
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка, , 
					"ОтборПоНаправлениямДеятельности,
					//++ НЕ УТ
					|ОтборПоМатериалам, ОтборПоПодразделениям, ОтборПоВидамРабот, ОтборПоГруппамПродукции, ОтборПоПродукции, Списание, ПоБазе,
					//-- НЕ УТ
					|НаправленияДеятельности");
				
				//++ НЕ УТ
				Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные Тогда
					ОтборПоПодразделениям.Загрузить(Выборка.ОтборПоПодразделениям.Выгрузить());
				Иначе
					ОтборПоПодразделениям.Очистить();
				КонецЕсли;
				
				ОтборПоМатериалам.Загрузить(Выборка.ОтборПоМатериалам.Выгрузить());
				ОтборПоПродукции.Загрузить(Выборка.ОтборПоПродукции.Выгрузить());
				ОтборПоВидамРабот.Загрузить(Выборка.ОтборПоВидамРабот.Выгрузить());
				Если УчетПоГруппамПродукции Тогда
					ОтборПоГруппамПродукции.Загрузить(Выборка.ОтборПоГруппамПродукции.Выгрузить());
				КонецЕсли;
				
				Списание.Загрузить(Выборка.Списание.Выгрузить());
				ПоБазе.Загрузить(Выборка.ПоБазе.Выгрузить());
				Для Каждого СтрокаПоБазе Из ПоБазе Цикл
					СтрокаПоБазе.СтатьяКалькуляции = СтатьяКалькуляции;
				КонецЦикла;
				//-- НЕ УТ
				
				ОтборПоНаправлениямДеятельности.Загрузить(Выборка.ОтборПоНаправлениямДеятельности.Выгрузить());
				НаправленияДеятельности.Загрузить(Выборка.НаправленияДеятельности.Выгрузить());
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НазначениеНастройкиРаспределения) Тогда
		
		НазначенияПоВарианту = Новый Соответствие;
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат);
		//++ НЕ УТ	
		НазначенияПоВарианту.Вставить(Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты,
			Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства);
		//-- НЕ УТ
		ВариантыРаспределения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтатьяРасходов, 
			"ВариантРаспределенияРасходовРегл, ВариантРаспределенияРасходовУпр");
		
		Если УправленческийУчет Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ВариантыРаспределения.ВариантРаспределенияРасходовУпр);
		КонецЕсли;
			
		Если РегламентированныйУчет Тогда
			НазначениеНастройкиРаспределения = 
				НазначенияПоВарианту.Получить(ВариантыРаспределения.ВариантРаспределенияРасходовРегл);			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат
		И (ЗначениеЗаполнено(НаправлениеДеятельности)
		Или (ТипЗнч(АналитикаРасходов) = Тип("СправочникСсылка.НаправленияДеятельности")
			И ЗначениеЗаполнено(АналитикаРасходов))
		Или Не ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат")) Тогда
		НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Текущее;
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспределениеПрочихЗатрат.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Регистрация задания к расчету себестоимости.
	Если Не НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(Дата, Ссылка, Организация);
	КонецЕсли;
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	
	// Запись наборов записей
	РаспределениеПрочихЗатратЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	РаспределениеПрочихЗатратЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	РаспределениеПрочихЗатрат.Ссылка
		|ИЗ
		|	Документ.РаспределениеПрочихЗатрат КАК РаспределениеПрочихЗатрат
		|ГДЕ
		|	РаспределениеПрочихЗатрат.Проведен
		|	И РаспределениеПрочихЗатрат.Организация = &Организация
		|	И РаспределениеПрочихЗатрат.Подразделение = &Подразделение
		|	И РаспределениеПрочихЗатрат.НаправлениеДеятельности = &НаправлениеДеятельности
		|	И РаспределениеПрочихЗатрат.СтатьяРасходов = &СтатьяРасходов
		|	И РаспределениеПрочихЗатрат.АналитикаРасходов = &АналитикаРасходов
		|	И РаспределениеПрочихЗатрат.Дата МЕЖДУ &ПериодНачало И &ПериодОкончание
		|	И НЕ РаспределениеПрочихЗатрат.Ссылка = &ТекущийДокумент
		|	И (РаспределениеПрочихЗатрат.РегламентированныйУчет = &РегламентированныйУчет
		|		ИЛИ РаспределениеПрочихЗатрат.УправленческийУчет = &УправленческийУчет)";
	
	Запрос.УстановитьПараметр("Организация",		Организация);
	Запрос.УстановитьПараметр("Подразделение",		Подразделение);
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Запрос.УстановитьПараметр("ПериодНачало",		НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("ПериодОкончание",	КонецМесяца(Дата));
	Запрос.УстановитьПараметр("ТекущийДокумент",	Ссылка);
	Запрос.УстановитьПараметр("СтатьяРасходов",		СтатьяРасходов);
	Запрос.УстановитьПараметр("АналитикаРасходов",	АналитикаРасходов);
	Запрос.УстановитьПараметр("РегламентированныйУчет",	РегламентированныйУчет);
	Запрос.УстановитьПараметр("УправленческийУчет",	УправленческийУчет);
		
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		ТекстСообщения = НСтр("ru = 'В указанном периоде уже существует аналогичный документ.
								   |Операция не выполнена.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
		
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	//++ НЕ УТ	
	Если Не РаспределятьПоПартиям И Не РаспределятьПоПодразделениям
		И Не РаспределятьНаСтатьи И Не ОставитьВНЗП
		И НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не выбрано ни одно направление распределения статьи расходов.'"),
				,
				"НаправлениеРаспределения",
				,
				Отказ);
	КонецЕсли;
		
	Если РаспределятьНаСтатьи И Списание.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не введено ни одной строки в список ""Другие статьи""'"),
			,
			"Списание",
			,
			Отказ);
	КонецЕсли;
	
	РеквизитТЧСписание = Новый Массив;
	СтруктураТЧСписание = Новый Структура;
	СтруктураТЧСписание.Вставить("Списание", "СтатьяРасходов, АналитикаРасходов");
	РеквизитТЧСписание.Добавить(СтруктураТЧСписание);
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(
		ЭтотОбъект, РеквизитТЧСписание, МассивНепроверяемыхРеквизитов, Отказ);
		
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные
		И ОтборПоПодразделениям.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заданы подразделения в отборе.'"),
				,
				"НаправлениеРаспределения",
				,
				Отказ);
	КонецЕсли;
	
	Если Не РаспределятьПоПартиям 
		Или ПартииУказаныВручную Или ПодразделенияУказаныВручную Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяКалькуляции");
	КонецЕсли;
	
	Если ПартииУказаныВручную 
		И ПартииПроизводства.Количество() = 0
		И ВыпускиБезРаспоряжения.Количество() = 0
		И Вручную.Количество() = 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Не указаны партии.'"),,,,	Отказ);
			
	КонецЕсли;
	
	Если Не (РаспределятьПоПартиям И (РаспределятьНаСтатьи Или ОставитьВНЗП)
		И Не (ПартииУказаныВручную Или ПодразделенияУказаныВручную)) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоляСтоимостиНаПроизводство");
	КонецЕсли;
	
	Если Не РаспределятьПоПодразделениям Или 
		(РаспределятьПоПодразделениям И ПодразделенияУказаныВручную) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПодразделениям");
	КонецЕсли;
	
	Если Не РаспределятьНаСтатьи Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Списание");
	КонецЕсли;
	
	Если Не ПодразделенияУказаныВручную Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПоБазе");
	КонецЕсли;
	
	Если Не (БазаРаспределенияПоПодразделениям = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяЕжемесячно
		Или БазаРаспределенияПоПодразделениям = Перечисления.ТипыБазыРаспределенияРасходов.ВводитсяПриИзменении) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Показатель");
	КонецЕсли;
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеСтатейРасходовПоЭтапамПроизводства
		И (Не РаспределятьПоПартиям Или ПартииУказаныВручную) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
	КонецЕсли;
	
	Если Не ОставитьВНЗП Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ДоляСтоимостиНаНЗП");
	КонецЕсли;
	
	Если БазаРаспределенияПоПартиям = Перечисления.ТипыБазыРаспределенияРасходов.СуммаМатериальныхИТрудозатрат 
		И Не РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(Дата) Тогда		
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='База распределение ""Сумма материальных и трудозатрат"" доступна только для партионного учета 2.2.'"),
			ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(Ссылка),
			"ПравилоРаспределенияПоЭтапам",
			"Объект",
			Отказ);
			
	КонецЕсли;
	//-- НЕ УТ	
	
	Если НазначениеНастройкиРаспределения = Перечисления.НазначениеПравилРаспределенияРасходов.РаспределениеРасходовНаФинансовыйРезультат Тогда
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.Указанные
			И ОтборПоНаправлениямДеятельности.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заданы направления деятельности в отборе.'"),
				,
				"НаправлениеРаспределения",
				,
				Отказ);
				
		КонецЕсли;
		
		Если НаправлениеРаспределения = Перечисления.НаправлениеРаспределенияПоПодразделениям.ПоКоэффициентам
			И НаправленияДеятельности.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не введено ни одной строки в список ""Направления деятельности""'"),
				,
				"НаправленияДеятельности",
				,
				Отказ);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НаправлениеРаспределения) Тогда
			МассивНепроверяемыхРеквизитов.Добавить("БазаРаспределенияПоПартиям");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РаспределениеПрочихЗатратЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
