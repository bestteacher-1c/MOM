#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроверитьНеобходимостьСбросаКэшаВидовБюджетов(Отказ);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Ссылка = Справочники.Сценарии.ФактическиеДанные
		ИЛИ Ссылка = Справочники.Сценарии.ИсполнениеБюджета Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Периодичность");
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	Если Не ИспользоватьКурсыДругогоСценария Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СценарийКурсов");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		И Не ЗначениеЗаполнено(Валюта) Тогда
		
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Валюта"". Установите валюту управленческого учета!'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНеобходимостьСбросаКэшаВидовБюджетов(Отказ)
	Если НЕ Отказ Тогда
		Если Ссылка = Справочники.Сценарии.ФактическиеДанные
		 ИЛИ Ссылка = Справочники.Сценарии.ИсполнениеБюджета Тогда
			Если Родитель <> Ссылка.Родитель Тогда
				// Если для предопределенных элементов измененяется родитель, то необходимо сбросить кэш настроек видов бюджетов,
				// т.к. в настройках может быть указан отбор с по сценарию с видом сравнения "в группе" или "в группе из списка",
				// что может повлиять на необходимость получения фактических данных (см. БюджетнаяОтчетностьРасчетКэшаСервер.ПоИсточникуПредположительноНужныФактическиеДанные)
				Попытка
					Набор = РегистрыСведений.КэшВспомогательныхДанныхВидаБюджета.СоздатьНаборЗаписей();
					Набор.Записать(Истина);
				Исключение
					КодЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка();
					ИмяСобытия = НСтр("ru = 'Запись сценария'", КодЯзыка);
					ТекстСообщенияЖР = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось очистить кэш вспомогательных данных по причине: %1'", КодЯзыка),
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					ТекстСообщения   = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось очистить кэш вспомогательных данных по причине: %1'"),
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					ЗаписьЖурналаРегистрации(ИмяСобытия,
					                         УровеньЖурналаРегистрации.Ошибка,,,
					                         ТекстСообщенияЖР);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли