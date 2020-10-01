#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Перем ОшибкаЗаполнения Экспорт;
Перем УжеСуществует Экспорт;
Перем СуществующееСообщение Экспорт;

#Область ПрограммныйИнтерфейс

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ОбработкаЗаполненияОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПриЗаписиОбъекта(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли