#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке();
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Договор подряда
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Документ.ДоговорРаботыУслуги";
	КомандаПечати.Идентификатор = "ПФ_MXL_ДоговорПодряда";
	КомандаПечати.Представление = НСтр("ru = 'Договор подряда'");
	КомандаПечати.Порядок = 10;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Акт приема-передачи выполненных работ (услуг).
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
	КомандаПечати.Идентификатор = "ПФ_MXL_АктСдачиПриемкиВыполненныхРаботУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Акт приема-передачи выполненных работ (услуг)'");
	КомандаПечати.Порядок = 20;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
КонецПроцедуры

// Формирует печатные формы
//
// Параметры:
//  (входные)
//    МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//    ПараметрыПечати - Структура - дополнительные настройки печати;
//  (выходные)
//   КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы.
//   ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                             представление - имя области в которой был выведен объект;
//   ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьСоглашение = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ДоговорПодряда");
	
	Если НужноПечататьСоглашение Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,	"ПФ_MXL_ДоговорПодряда",
			НСтр("ru = 'Договор подряда'"), ПечатьДоговора(МассивОбъектов, ОбъектыПечати), ,
			"Документ.ДоговорРаботыУслуги.ПФ_MXL_ДоговорПодряда");
	КонецЕсли;
						
КонецПроцедуры								
	
Функция ПечатьДоговора(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДоговорРаботыУслуги_ДоговорПодряда";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ДоговорРаботыУслуги.ПФ_MXL_ДоговорПодряда");
	
	ДанныеПечатиОбъектов = ДанныеПечатиДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Для Каждого ДанныеПечати Из ДанныеПечатиОбъектов Цикл
		
		// Документы нужно выводить на разных страницах.
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе
			ПервыйДокумент = Ложь;
		КонецЕсли;		
		
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Макет.Параметры.Заполнить(ДанныеПечати.Значение);
		
		ТабличныйДокумент.Вывести(Макет);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Значение.Ссылка);
		
	КонецЦикла;	
						
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ДанныеПечатиДокументов(МассивОбъектов)
	
	ДанныеПечатиОбъектов = Новый Соответствие;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорРаботыУслуги.Ссылка,
	|	ДоговорРаботыУслуги.Номер,
	|	ДоговорРаботыУслуги.Дата,
	|	ДоговорРаботыУслуги.Организация,
	|	ДоговорРаботыУслуги.Организация.НаименованиеПолное КАК НазваниеОрганизации,
	|	ДоговорРаботыУслуги.Сотрудник,
	|	ДоговорРаботыУслуги.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВЫБОР
	|		КОГДА ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ПоАктамВыполненныхРабот)
	|				ИЛИ ДоговорРаботыУслуги.СпособОплаты = ЗНАЧЕНИЕ(Перечисление.СпособыОплатыПоДоговоруГПХ.ВКонцеСрокаСАвансовымиПлатежами)
	|			ТОГДА &ОплатаПоАктам
	|		ИНАЧЕ &ОплатаПоДоговору
	|	КОНЕЦ КАК ЧастотаВыплат,
	|	ДоговорРаботыУслуги.ДатаНачала,
	|	ДоговорРаботыУслуги.ДатаОкончания,
	|	ДоговорРаботыУслуги.Сумма КАК СуммаЗаРаботу,
	|	ДоговорРаботыУслуги.Руководитель КАК Руководитель,
	|	ДоговорРаботыУслуги.ДолжностьРуководителя КАК ДолжностьРуководителя
	|ИЗ
	|	Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|ГДЕ
	|	ДоговорРаботыУслуги.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("ОплатаПоАктам", НСтр("ru = 'ежемесячно'"));
	Запрос.УстановитьПараметр("ОплатаПоДоговору", НСтр("ru = 'однократно в конце срока'"));
	РезультатыЗапроса = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ДокументДляПечати Из РезультатыЗапроса Цикл
		
		ДанныеПечати = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ДокументДляПечати);
		ДанныеПечати.Вставить("ФИОРуководителяСклоняемое", "");
		ДанныеПечати.Дата = Формат(ДанныеПечати.Дата, "ДЛФ=D");
		ДанныеПечати.ДатаНачала = Формат(ДанныеПечати.ДатаНачала, "ДЛФ=DD");
		ДанныеПечати.ДатаОкончания = Формат(ДанныеПечати.ДатаОкончания, "ДЛФ=DD");
		
		// Подготовка номера документа.
		ДанныеПечати.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеПечати.Номер, Ложь, Ложь);

		Если ЗначениеЗаполнено(ДанныеПечати.Руководитель) Тогда
				
			ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДанныеПечати.Руководитель), 
				"Пол,ФамилияИО", ДанныеПечати.Дата);
				
			Если ДанныеФизическогоЛица[0].Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
				ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующего'"));
			Иначе
				ДанныеПечати.Вставить("Действующего", НСтр("ru = 'действующей'"));
			КонецЕсли;
			
			Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				
				ДанныеРуководителя = ДанныеФизическогоЛица[0];
				ФИОРуководителя = ДанныеРуководителя.ФамилияИО;
				
				ФизическиеЛицаЗарплатаКадры.Просклонять(ФИОРуководителя,
					2, ФИОРуководителя, ДанныеРуководителя.Пол,
					ДанныеРуководителя.ФизическоеЛицо);
					
				ДанныеПечати.ФИОРуководителяСклоняемое = ФИОРуководителя;
				
			КонецЕсли;
				
		КонецЕсли;
		
		ДанныеПечати.ДолжностьРуководителя = СклонениеПредставленийОбъектов.ПросклонятьПредставление(Строка(ДанныеПечати.ДолжностьРуководителя), 2);
		
		// Юридический адрес организации.
		ДанныеПечати.Вставить("АдресОрганизации", УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			ДанныеПечати.Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
			ДокументДляПечати.Дата));
		
		// Данные физического лица
		ДанныеФизическогоЛица = КадровыйУчет.КадровыеДанныеФизическихЛиц(
			Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументДляПечати.ФизическоеЛицо), 
			"ФИОПолные, ФамилияИО, АдресПоПрописке, ДокументВид, ДокументСерия, ДокументНомер", ДокументДляПечати.Дата);
			
		Если ДанныеФизическогоЛица.Количество() > 0 Тогда
				
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(
					ДанныеФизическогоЛица[0].АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			АдресПоПрописке = "";
			УправлениеКонтактнойИнформациейКлиентСервер.СформироватьПредставлениеАдреса(СтруктураАдреса, АдресПоПрописке);
			
			ДанныеПечати.Вставить("РаботникНаименование", ДанныеФизическогоЛица[0].ФамилияИО);
			ДанныеПечати.Вставить("АдресСотрудника", АдресПоПрописке);
			ДанныеПечати.Вставить("ДокументВид", ДанныеФизическогоЛица[0].ДокументВид);
			ДанныеПечати.Вставить("ДокументСерия", ДанныеФизическогоЛица[0].ДокументСерия);
			ДанныеПечати.Вставить("ДокументНомер", ДанныеФизическогоЛица[0].ДокументНомер);
			
		КонецЕсли;
		
		// Сумма договора и валюта
		ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		ДанныеПечати.Вставить("ВалютаДокумента", ВалютаУчета.НаименованиеПолное);
		
		// Заполнение соответствия
		ДанныеПечатиОбъектов.Вставить(ДокументДляПечати.Ссылка, ДанныеПечати);

	КонецЦикла;
	
	Возврат ДанныеПечатиОбъектов;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоговорРаботыУслуги.Сотрудник,
	|	ДоговорРаботыУслуги.ДатаНачала,
	|	ДоговорРаботыУслуги.ДатаНачалаПФР,
	|	ДоговорРаботыУслуги.ДатаОкончания,
	|	ДоговорРаботыУслуги.Ссылка,
	|	ДоговорРаботыУслуги.Организация,
	|	ДоговорРаботыУслуги.Подразделение,
	|	ДоговорРаботыУслуги.Территория
	|ИЗ
	|	Документ.ДоговорРаботыУслуги КАК ДоговорРаботыУслуги
	|ГДЕ
	|	ДоговорРаботыУслуги.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииДоговоровГПХВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.Сотрудник;	
		ОписаниеПериода.ДатаНачалаПериода = Макс(Выборка.ДатаНачала, Выборка.ДатаНачалаПФР);
		ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Работа;

		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Перечисления.ВидыСтажаПФР2014.ВключаетсяВСтажДляДосрочногоНазначенияПенсии);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
		УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
	КонецЦикла;	
		
	Возврат ДанныеДляРегистрацииВУчете;
															
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли