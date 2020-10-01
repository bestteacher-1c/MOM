#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
	
	КонтрактыДоговорыСотрудников.СформироватьДвиженияОсновныхДанныхИСведенийОКонтрактахДоговорах(Движения, ДанныеДляПроведения.СведенияОКонтрактахДоговорах);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаПриема = ТекущаяДатаСеанса();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ТрудовойДоговорДата, "Объект.ТрудовойДоговорДата", Отказ, НСтр("ru='Дата договора'"), , , Ложь);
	Если ЗначениеЗаполнено(ТрудовойДоговорДата) Тогда
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаПродления, "Объект.ДатаПродления", Отказ, НСтр("ru='Дата продления'"), ТрудовойДоговорДата, НСтр("ru='даты договора'"), Ложь);
		
		Если СрочныйДоговор Тогда
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаЗавершенияТрудовогоДоговора, "Объект.ДатаЗавершенияТрудовогоДоговора", Отказ, НСтр("ru='Дата завершения'"), ТрудовойДоговорДата, НСтр("ru='даты договора'"), Ложь);
		КонецЕсли;
		
	Иначе
		
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаПродления, "Объект.ДатаПродления", Отказ, НСтр("ru='Дата продления'"), , , Ложь);
		
		Если СрочныйДоговор Тогда
			ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаЗавершенияТрудовогоДоговора, "Объект.ДатаЗавершенияТрудовогоДоговора", Отказ, НСтр("ru='Дата завершения'"), , , Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получает данные для формирования движений.
// Возвращает Структуру с полями.
//		КадровыеДвижения - данные, необходимые для формирования 
//				- кадровой истории (см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения)
//				- авансов (см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат)
//				- истории применяемых графиков работы (см. КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков).
//		ПлановыеНачисления - данные, необходимые для формирования истории плановых начислений.
//		(см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений)
//		ЗначенияПоказателей (см. там же).
//
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ПродлениеКонтрактаДоговора.ТрудовойДоговорДата = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ПродлениеКонтрактаДоговора.ДатаПродления
	|		ИНАЧЕ ПродлениеКонтрактаДоговора.ТрудовойДоговорДата
	|	КОНЕЦ КАК Период,
	|	ПродлениеКонтрактаДоговора.ДатаПродления КАК ДатаНачала,
	|	ПродлениеКонтрактаДоговора.Сотрудник КАК Сотрудник,
	|	ПродлениеКонтрактаДоговора.ФизическоеЛицо,
	|	ПродлениеКонтрактаДоговора.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ПродлениеКонтрактаДоговора.Организация КАК Организация,
	|	ПродлениеКонтрактаДоговора.ДатаЗавершенияТрудовогоДоговора КАК ДатаОкончания,
	|	ПродлениеКонтрактаДоговора.ТрудовойДоговорНомер КАК НомерДоговораКонтракта,
	|	ПродлениеКонтрактаДоговора.ТрудовойДоговорДата КАК ДатаДоговораКонтракта,
	|	ПродлениеКонтрактаДоговора.ПредставительНанимателя КАК ПредставительНанимателя,
	|	ПродлениеКонтрактаДоговора.ДолжностьПредставителяНанимателя КАК ДолжностьПредставителяНанимателя,
	|	ПродлениеКонтрактаДоговора.ОснованиеПредставителяНанимателя,
	|	ПродлениеКонтрактаДоговора.ВидАктаГосоргана,
	|	ЛОЖЬ КАК ПоступлениеНаСлужбуВпервые,
	|	ПродлениеКонтрактаДоговора.СрочныйДоговор,
	|	ПродлениеКонтрактаДоговора.СезонныйДоговор,
	|	ПродлениеКонтрактаДоговора.СрокЗаключенияДоговора,
	|	ПродлениеКонтрактаДоговора.ОснованиеСрочногоДоговора,
	|	ПродлениеКонтрактаДоговора.ОборудованиеРабочегоМеста,
	|	ПродлениеКонтрактаДоговора.ИныеУсловияДоговора
	|ИЗ
	|	Документ.ПродлениеКонтрактаДоговора КАК ПродлениеКонтрактаДоговора
	|ГДЕ
	|	ПродлениеКонтрактаДоговора.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляПроведения = Новый Структура; 
	
	// Набор данных для проведения - таблица для формирования описаний договоров сотрудников.
	СведенияОКонтрактахДоговорах = РезультатЗапроса.Выгрузить();
	ДанныеДляПроведения.Вставить("СведенияОКонтрактахДоговорах", СведенияОКонтрактахДоговорах);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли