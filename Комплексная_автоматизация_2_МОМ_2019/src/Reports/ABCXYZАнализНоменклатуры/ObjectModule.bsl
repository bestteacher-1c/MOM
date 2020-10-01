#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//	Форма        - ФормаКлиентскогоПриложения - форма отчета,
//	КлючВарианта - Строка           - имя предопределенного варианта отчета или уникальный идентификатор,
//	Настройки    - Структура        - см. возвращаемое значение ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//	Форма                - ФормаКлиентскогоПриложения - форма отчета,
//	Отказ                - Булево           - передается из параметров обработчика "как есть",
//	СтандартнаяОбработка - Булево           - передается из параметров обработчика "как есть".
//
// См. также:
//	"ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
		И Параметры.Свойство("ОписаниеКоманды")
		И Параметры.ОписаниеКоманды.ДополнительныеПараметры.Свойство("ИмяКоманды") Тогда
		
		Если Параметры.ОписаниеКоманды.ДополнительныеПараметры.ИмяКоманды = "ПоНоменклатуре" Тогда
			ЭтаФорма.ФормаПараметры.Отбор.Вставить("Номенклатура", Параметры.ПараметрКоманды);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовкиПолей()
	Если НЕ ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Строка(Константы.ВалютаУправленческогоУчета.Получить());

	Для каждого НаборДанных Из СхемаКомпоновкиДанных.НаборыДанных Цикл
		Для каждого ПолеНабораДанных Из НаборДанных.Поля Цикл
			Если СтрНайти(ПолеНабораДанных.Заголовок, "%ВалютаУпр%") > 0 Тогда
				ПолеНабораДанных.Заголовок = СтрЗаменить(ПолеНабораДанных.Заголовок, "%ВалютаУпр%", ВалютаУправленческогоУчета);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Для каждого ВычисляемоеПоле Из СхемаКомпоновкиДанных.ВычисляемыеПоля Цикл
		Если СтрНайти(ВычисляемоеПоле.Заголовок, "%ВалютаУпр%") > 0 Тогда
			ВычисляемоеПоле.Заголовок = СтрЗаменить(ВычисляемоеПоле.Заголовок, "%ВалютаУпр%", ВалютаУправленческогоУчета);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

УстановитьЗаголовкиПолей();

#КонецОбласти

#КонецЕсли