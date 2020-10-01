
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Запись, ЭтотОбъект);
	
	Если Параметры.Свойство("ВозвратЗначенияБезЗаписи") Тогда
		ВозвратЗначенияБезЗаписи = Параметры.ВозвратЗначенияБезЗаписи;
	КонецЕсли;
	
	ПолучитьДоступныеСчетаУчета();
	
	УправлениеФормой();
	
	Элементы.Подразделение.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.СтруктураПредприятия");
	Элементы.Подразделение.ВыбиратьТип = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПорядокОтраженияРасходов");
	
КонецПроцедуры // ПослеЗаписи()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ВозвратЗначенияБезЗаписи Тогда
		
		Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
			Текст = НСтр("ru = 'Поле ""Организация"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, Параметры.Ключ, "Запись.Организация", "Запись.Организация", Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.СтатьяРасходов) Тогда
			Текст = НСтр("ru = 'Поле ""Статья расходов"" не заполнено'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, Параметры.Ключ, "Запись.СтатьяРасходов", "СтатьяРасходов", Отказ);
			Возврат;
		КонецЕсли;
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		Отказ = Истина;
		Модифицированность = Ложь;
		СтруктураВозврата = Новый Структура("Организация, Подразделение, СтатьяРасходов, СчетУчета, СчетСписанияОСНО, СчетСписанияЕНВД");
		ЗаполнитьЗначенияСвойств(СтруктураВозврата, Запись);
		Закрыть(СтруктураВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	
	Если ДоступныеСчетаУчетаПрочихРасходов.Найти(Запись.СчетУчета) <> Неопределено Тогда
		Запись.СчетСписанияОСНО = Неопределено;
		Запись.СчетСписанияЕНВД = Неопределено;
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ПолучитьДоступныеСчетаУчета()
	
	СтруктураСчетовУчета = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасходов();
	
	ДоступныеСчетаУчетаРасходов = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаРасходов);
	ДоступныеСчетаУчетаПрочихРасходов = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаПрочихРасходов);
	ДоступныеСчетаУчетаОС = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаОС);
	ДоступныеСчетаУчетаОбъектыСтроительства = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаОбъектыСтроительства);
	ДоступныеСчетаУчетаНМА = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаНМА);
	ДоступныеСчетаСписанияРасходов = Новый ФиксированныйМассив(СтруктураСчетовУчета.СчетаСписания);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить("ВидДеятельностиДляНалоговогоУчетаЗатрат");
	МассивРеквизитов.Добавить("ВариантРаспределенияРасходовРегл");
	МассивРеквизитов.Добавить("КосвенныеЗатратыНУ");
	МассивРеквизитов.Добавить("ВидДеятельностиРасходов");
	МассивРеквизитов.Добавить("РасходыНаНМАиНИОКР");
	МассивРеквизитов.Добавить("РасходыНаОбъектыСтроительства");
	МассивРеквизитов.Добавить("РасходыНаОбъектыЭксплуатации");
	
	РеквизитыСтатьи = 
		ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.СтатьяРасходов, МассивРеквизитов);
	
	ИспользуетсяЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД");
	РасходыПоОСНО = (РеквизитыСтатьи.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсновнаяСистемаНалогообложения);
	РасходыПоЕНВД = (РеквизитыСтатьи.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.ОсобыйПорядокНалогообложения);
	РасходыПоОСНОиЕНВД = (РеквизитыСтатьи.ВидДеятельностиДляНалоговогоУчетаЗатрат = Перечисления.ВидыДеятельностиДляНалоговогоУчетаЗатрат.РаспределяемыеЗатраты);
	
	НаВнеоборотныеАктивы = (РеквизитыСтатьи.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаВнеоборотныеАктивы);
	НаНаправленияДеятельности = (РеквизитыСтатьи.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаНаправленияДеятельности);
	НеРаспределять = (РеквизитыСтатьи.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НеРаспределять);
	НаПроизводственныеЗатраты = (РеквизитыСтатьи.ВариантРаспределенияРасходовРегл = Перечисления.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты);
	
	// Настрйка отображения счетов списания
	Элементы.ГруппаСчетаСписания.Видимость = НаНаправленияДеятельности ИЛИ (НаПроизводственныеЗатраты И РеквизитыСтатьи.КосвенныеЗатратыНУ);
	
	Элементы.СчетСписанияОСНО.Заголовок = ?(ИспользуетсяЕНВД, НСтр("ru = 'Счет списания (ОСНО)'"), НСтр("ru = 'Счет списания'"));
	Элементы.СчетСписанияЕНВД.Видимость = ИспользуетсяЕНВД;
	
	Элементы.СчетСписанияОСНО.Доступность = (РасходыПоОСНО ИЛИ РасходыПоОСНОиЕНВД) И ДоступныеСчетаУчетаПрочихРасходов.Найти(Запись.СчетУчета) = Неопределено;
	Элементы.СчетСписанияЕНВД.Доступность = (РасходыПоЕНВД ИЛИ РасходыПоОСНОиЕНВД) И ДоступныеСчетаУчетаПрочихРасходов.Найти(Запись.СчетУчета) = Неопределено;
	
	// Установка параметров выбора счетов учета
	ПараметрыВыбора = Новый Массив;
	Если НаВнеоборотныеАктивы И РеквизитыСтатьи.РасходыНаОбъектыЭксплуатации Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаУчетаОС));
	ИначеЕсли НаВнеоборотныеАктивы И РеквизитыСтатьи.РасходыНаНМАиНИОКР  Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаУчетаНМА));
	ИначеЕсли НаВнеоборотныеАктивы И РеквизитыСтатьи.РасходыНаОбъектыСтроительства  Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаУчетаОбъектыСтроительства));
	ИначеЕсли РеквизитыСтатьи.ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ОсновнаяДеятельность Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаУчетаРасходов));
	ИначеЕсли РеквизитыСтатьи.ВидДеятельностиРасходов = Перечисления.ВидыДеятельностиРасходов.ПрочаяДеятельность Тогда
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаУчетаПрочихРасходов));
	Иначе
		СчетаУчетаРасходовИПрочихРасходов = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаУчетаРасходовИПрочихРасходов, ДоступныеСчетаУчетаРасходов);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(СчетаУчетаРасходовИПрочихРасходов, ДоступныеСчетаУчетаПрочихРасходов);
		ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Новый ФиксированныйМассив(СчетаУчетаРасходовИПрочихРасходов)));
	КонецЕсли;
	Элементы.СчетУчета.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаСписанияРасходов));
	Элементы.СчетСписанияОСНО.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	ПараметрыВыбора = Новый Массив;
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеСчетаСписанияРасходов));
	Элементы.СчетСписанияЕНВД.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		ДоступныеДляВыбораОрганизации = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка(
			"РегистрСведений.ПорядокОтраженияРасходов", Тип("СправочникСсылка.Организации"));
		Если ДоступныеДляВыбораОрганизации <> Неопределено Тогда
			Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(ДоступныеДляВыбораОрганизации);
			Элементы.Организация.РежимВыбораИзСписка = Истина;
			Если ДоступныеДляВыбораОрганизации.Количество() = 1 Тогда
				Запись.Организация = ДоступныеДляВыбораОрганизации.Получить(0);
				Элементы.Организация.ТолькоПросмотр = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаЗаписать.Видимость = Не ВозвратЗначенияБезЗаписи;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
