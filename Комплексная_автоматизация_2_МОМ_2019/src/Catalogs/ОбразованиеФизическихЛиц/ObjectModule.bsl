#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОбучениеРазвитие") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбучениеРазвитие");
		Модуль.ЗаполнитьСвидетельствоИзДокументаОбучения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоДополнительноеОбразование() Экспорт
		
	Возврат ВидОбразования = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОбразованияФизическихЛиц.ДополнительноеПрофессиональноеОбразование")
		Или ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.ПовышениеКвалификации")
		Или ВидДополнительногоОбучения = ПредопределенноеЗначение("Перечисление.ВидыПрофессиональнойПодготовки.Переподготовка");
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли