#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Партнер") Тогда
			Если НЕ (ДанныеЗаполнения.Свойство("Контрагент") И ЗначениеЗаполнено(ДанныеЗаполнения.Контрагент)) Тогда
				ДанныеЗаполнения.Вставить("Контрагент", ПартнерыИКонтрагенты.ПолучитьКонтрагентаПартнераПоУмолчанию(ДанныеЗаполнения.Партнер));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата              = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	ДокументОснование = Неопределено;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Реквизиты = Документы.ПервичныйДокумент.МассивРеквизитовПоТипуПервичногоДокумента(ТипПервичногоДокумента);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		Реквизиты.МассивВсехРеквизитов,
		Реквизиты.МассивРеквизитовДляТипа,
		МассивНепроверяемыхРеквизитов);
	
	Если ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Договор");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НомерВходящегоДокумента)
		И НЕ ЗначениеЗаполнено(ДатаВходящегоДокумента) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НомерВходящегоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаВходящегоДокумента");
	КонецЕсли; 

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(Организация) И Организация = Контрагент Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Организация и контрагент не должны совпадать'"),
			ЭтотОбъект,
			"Контрагент",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПараметрыРегистрации = Документы.ПервичныйДокумент.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения)
	
	ДанныеЗаполненияЭтоСтруктура = (ТипЗнч(ДанныеЗаполнения) = Тип("Структура"));
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Контрагент") Тогда
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Договор") Тогда
		Если ДанныеЗаполненияЭтоСтруктура 
			И ДанныеЗаполнения.Свойство("Партнер")
			И ДанныеЗаполнения.Партнер = Справочники.Партнеры.НашеПредприятие Тогда
			Договор = Справочники.ДоговорыМеждуОрганизациями.ПустаяСсылка();
		Иначе
			Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ДанныеЗаполненияЭтоСтруктура ИЛИ НЕ ДанныеЗаполнения.Свойство("Валюта") Тогда
		Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
