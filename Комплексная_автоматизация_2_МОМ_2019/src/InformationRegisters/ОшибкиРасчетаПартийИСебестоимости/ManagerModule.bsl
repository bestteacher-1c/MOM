#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив идентификаторов протоколов расчета указанных организаций.
//
Функция ПолучитьПротоколыРасчета(ПериодРасчета, МассивОрганизаций) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВариантыРасчета = Новый Массив;
	
	Если РасчетСебестоимостиПовтИсп.ПартионныйУчетВерсии22(НачалоМесяца(ПериодРасчета)) Тогда
		ВариантыРасчета.Добавить(Перечисления.ВариантыРасчетаПартийИСебестоимости.ПартииИСебестоимость);
		ВариантыРасчета.Добавить(Перечисления.ВариантыРасчетаПартийИСебестоимости.ФактическаяСебестоимость);
	Иначе
		ВариантыРасчета.Добавить(Перечисления.ВариантыРасчетаПартийИСебестоимости.ФактическаяСебестоимость);
	КонецЕсли;
	
	ИдентификаторыПротоколов = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Т.ИдентификаторПротокола КАК ИдентификаторПротокола,
	|	Т.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.ОшибкиРасчетаПартийИСебестоимости КАК Т
	|ГДЕ
	|	Т.Период = &Период
	|	И Т.Организация В (&МассивОрганизаций)
	|	И Т.ВариантРасчета В (&ВариантыРасчета)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ИдентификаторПротокола,
	|	Организация
	|ИТОГИ ПО
	|	ИдентификаторПротокола";
	
	Запрос.УстановитьПараметр("Период", 		   НачалоМесяца(ПериодРасчета));
	Запрос.УстановитьПараметр("МассивОрганизаций", ОбщегоНазначенияУТКлиентСервер.Массив(МассивОрганизаций));
	Запрос.УстановитьПараметр("ВариантыРасчета",   ВариантыРасчета);
	
	ВыборкаИдентификаторов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаИдентификаторов.Следующий() Цикл
		
		ИдентификаторыПротоколов.Вставить(ВыборкаИдентификаторов.ИдентификаторПротокола, Новый Массив);
		
		Выборка = ВыборкаИдентификаторов.Выбрать();
		Пока Выборка.Следующий() Цикл
			ИдентификаторыПротоколов[Выборка.ИдентификаторПротокола].Добавить(Выборка.Организация);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ИдентификаторыПротоколов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
