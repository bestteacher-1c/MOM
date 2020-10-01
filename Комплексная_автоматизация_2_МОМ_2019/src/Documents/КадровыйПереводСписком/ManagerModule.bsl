#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	Возврат Документы.КадровыйПеревод.СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры);
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(Сотрудники.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
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
	
	МетаданныеДокумента = Метаданные.Документы.КадровыйПереводСписком;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
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

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.КадровыйПереводСписком);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплаты,ЧтениеДанныхДляНачисленияЗарплаты", , Ложь) Тогда
		
		// Бронирование позиции
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьКадровыхПриказовРасширенная";
		КомандаПечати.Идентификатор = "ПФ_MXL_ПодтверждениеБронированияПозиции";
		КомандаПечати.Представление = НСтр("ru = 'Подтверждение брони'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьБронированиеПозиций";
		
	КонецЕсли;
	
	// Приказ о переводе
	Если ПравоДоступа("Просмотр", Метаданные.Отчеты.ПечатнаяФормаТ5а) Тогда
		
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
		КомандаПечати.МенеджерПечати = "Отчет.ПечатнаяФормаТ5а";
		КомандаПечати.Идентификатор = "ПФ_MXL_Т5а";
		КомандаПечати.Представление = НСтр("ru = 'Приказ о переводе (Т-5а)'");
		КомандаПечати.ДополнительныеПараметры.Вставить("ТребуетсяЧтениеБезОграничений", Истина);
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ДобавитьКомандуПечатиСлужебногоКонтракта(КомандыПечати);
	КонецЕсли;

КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхДляНачисленияЗарплатыРасширенная, ЧтениеДанныхДляНачисленияЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 
	
	ДанныеДляПроверкиОграничений = Новый Массив;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Сотрудники", Объект.Сотрудники.Выгрузить(, "Подразделение,ФизическоеЛицо"));
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПриемНаРаботуСпискомСотрудники.Подразделение КАК Подразделение,
		|	ПриемНаРаботуСпискомСотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&Сотрудники КАК ПриемНаРаботуСпискомСотрудники
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Сотрудники.Подразделение КАК Подразделение,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	ВТСотрудники КАК Сотрудники
		|
		|УПОРЯДОЧИТЬ ПО
		|	Подразделение,
		|	ФизическоеЛицо";
		
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.СледующийПоЗначениюПоля("Подразделение") Цикл
		
		ОписаниеСтруктурыДанных = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
		ОписаниеСтруктурыДанных.Организация = Объект.Организация;
		ОписаниеСтруктурыДанных.Подразделение = Выборка.Подразделение;
		
		Пока Выборка.Следующий() Цикл
			Если ОписаниеСтруктурыДанных.МассивФизическихЛиц = Неопределено Тогда
				ОписаниеСтруктурыДанных.МассивФизическихЛиц = Новый Массив;
			КонецЕсли; 
			ОписаниеСтруктурыДанных.МассивФизическихЛиц.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла; 
		
		ДанныеДляПроверкиОграничений.Добавить(ОписаниеСтруктурыДанных);

	КонецЦикла;
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок) Экспорт
	
	ДанныеДляРегистрацииВУчете = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КадровыйПеревод.Ссылка КАК Ссылка,
	|	КадровыйПеревод.Сотрудник КАК Сотрудник,
	|	КадровыйПеревод.ДатаНачала КАК ДатаНачала,
	|	КадровыйПеревод.ДатаОкончания КАК ДатаОкончания,
	|	КадровыйПеревод.Подразделение КАК Подразделение,
	|	КадровыйПеревод.ОбособленноеПодразделение КАК Организация,
	|	КадровыйПеревод.Должность КАК Должность,
	|	КадровыйПеревод.ДолжностьПоШтатномуРасписанию КАК ДолжностьПоШтатномуРасписанию,
	|	КадровыйПеревод.ВидЗанятости КАК ВидЗанятости,
	|	КадровыйПеревод.КоличествоСтавок КАК КоличествоСтавок,
	|	КадровыйПеревод.ГрафикРаботы КАК ГрафикРаботы,
	|	КадровыйПеревод.ИзменитьПодразделениеИДолжность КАК ИзменитьПодразделениеИДолжность,
	|	КадровыйПеревод.ИзменитьГрафикРаботы КАК ИзменитьГрафикРаботы,
	|	КадровыйПеревод.НаПериодПереводаСохранятьЛьготныйСтажПФР КАК НаПериодПереводаСохранятьЛьготныйСтажПФР,
	|	КадровыйПеревод.ВидСтажаПФР КАК ВидСтажаПФР,
	|	КадровыйПеревод.ИзменитьТерриторию КАК ИзменитьТерриторию
	|ИЗ
	|	Документ.КадровыйПереводСписком.Сотрудники КАК КадровыйПеревод
	|ГДЕ
	|	КадровыйПеревод.Ссылка В(&МассивСсылок)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеДляРегистрацииВУчетеПоДокументу = УчетСтажаПФР.ДанныеДляРегистрацииВУчетеСтажаПФР();
		ДанныеДляРегистрацииВУчете.Вставить(Выборка.Ссылка, ДанныеДляРегистрацииВУчетеПоДокументу); 
		
		ОписаниеПериода = УчетСтажаПФР.ОписаниеРегистрируемогоПериода();
		ОписаниеПериода.Сотрудник = Выборка.Сотрудник;
		ОписаниеПериода.ДатаНачалаПериода = Выборка.ДатаНачала;
		ОписаниеПериода.ДатаОкончанияПериода = Выборка.ДатаОкончания;
		ОписаниеПериода.Состояние = Перечисления.СостоянияСотрудника.Перемещение;
		ОписаниеПериода.ВидЗанятости = Выборка.ВидЗанятости;
		
		РегистрируемыйПериод = УчетСтажаПФР.ДобавитьЗаписьВДанныеДляРегистрацииВУчета(ДанныеДляРегистрацииВУчетеПоДокументу, ОписаниеПериода);
		
		Если Выборка.НаПериодПереводаСохранятьЛьготныйСтажПФР Тогда
			
			Если Выборка.ИзменитьПодразделениеИДолжность Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
			КонецЕсли;
				
			Если Выборка.ИзменитьТерриторию Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
			КонецЕсли;
				
			УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ВидСтажаПФР", Выборка.ВидСтажаПФР);
			
		Иначе
			
			Если Выборка.ИзменитьПодразделениеИДолжность Тогда
				
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Должность", Выборка.Должность);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ДолжностьПоШтатномуРасписанию", Выборка.ДолжностьПоШтатномуРасписанию);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "КоличествоСтавок", Выборка.КоличествоСтавок);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Организация", Выборка.Организация);
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Подразделение", Выборка.Подразделение);
				
			КонецЕсли;
				
			Если Выборка.ИзменитьТерриторию Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "Территория", Выборка.Территория);
			КонецЕсли;
			
			Если Выборка.ИзменитьГрафикРаботы Тогда
				УчетСтажаПФР.УстановитьЗначениеРегистрируемогоРесурса(РегистрируемыйПериод, "ГрафикРаботы", Выборка.ГрафикРаботы);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеДляРегистрацииВУчете;
	
КонецФункции

Процедура ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента) Экспорт
	
	ЗарплатаКадры.ЗаполнитьДатуЗапретаРедактированияСписочногоДокумента(ОбъектДокумента, "Сотрудники", "ДатаНачала");
	
КонецПроцедуры

Процедура ЗаполнитьДатыЗапрета(ПараметрыОбновления) Экспорт
	
	ОбновлениеВыполнено = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 100
		|	КадровыйПереводСписком.Ссылка КАК Ссылка,
		|	КадровыйПереводСписком.Дата КАК Дата
		|ИЗ
		|	Документ.КадровыйПереводСписком КАК КадровыйПереводСписком
		|ГДЕ
		|	КадровыйПереводСписком.ДатаЗапрета = ДАТАВРЕМЯ(1, 1, 1)
		|
		|УПОРЯДОЧИТЬ ПО
		|	КадровыйПереводСписком.Дата УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ОбновлениеВыполнено = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
				ПараметрыОбновления, Выборка.Ссылка.Метаданные().ПолноеИмя(), "Ссылка", Выборка.Ссылка) Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ОбъектДокумента = Выборка.Ссылка.ПолучитьОбъект();
			
			МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Выборка.Ссылка);
			МенеджерДокумента.ЗаполнитьДатуЗапретаРедактирования(ОбъектДокумента);
			
			ОбъектДокумента.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектДокумента);
			ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбновлениеВыполнено);
	
КонецПроцедуры

Функция ОписаниеПодписейДокумента() Экспорт 

	ОписаниеПодписей = ПодписиДокументов.ОписаниеТаблицыПодписей();

	ОписаниеПодписиРуководитель = ПодписиДокументов.ОписаниеРеквизитовПодписанта();
	ОписаниеПодписиРуководитель.ФизическоеЛицо = "Руководитель";
	ОписаниеПодписиРуководитель.Должность = "ДолжностьРуководителя";
	ОписаниеПодписиРуководитель.ОснованиеПодписи = "ОснованиеПредставителяНанимателя";

	ПереопределяемыеИмена = Новый Соответствие;
	ПереопределяемыеИмена.Вставить("Руководитель", ОписаниеПодписиРуководитель);

	ПодписиДокументов.ДобавитьОписаниеПодписейОрганизации(
		ОписаниеПодписей,
		"Руководитель",
		ПереопределяемыеИмена);

	Возврат ОписаниеПодписей;

КонецФункции

Процедура СформироватьДвиженияМероприятийТрудовойДеятельности(НаборЗаписей, ДанныеДляПроведения) Экспорт
	
	Документы.КадровыйПеревод.СформироватьДвиженияМероприятийТрудовойДеятельности(НаборЗаписей, ДанныеДляПроведения);
	
КонецПроцедуры

Функция ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент, ТолькоПроведенные = Ложь) Экспорт
	
	Возврат Документы.КадровыйПеревод.ДанныеДляПроведенияМероприятияТрудовойДеятельности(СсылкаНаДокумент, ТолькоПроведенные);
	
КонецФункции

#КонецОбласти

#КонецЕсли
