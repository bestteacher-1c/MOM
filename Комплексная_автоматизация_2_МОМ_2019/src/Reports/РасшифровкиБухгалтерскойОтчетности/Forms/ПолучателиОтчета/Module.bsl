
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ПолучателиОтчета) = Тип("Массив")  Тогда
		ПолучателиОтчета.ЗагрузитьЗначения(Параметры.ПолучателиОтчета);
	ИначеЕсли ТипЗнч(Параметры.ПолучателиОтчета) = Тип("ФиксированныйМассив")  Тогда
		ПолучателиОтчета.ЗагрузитьЗначения(Новый Массив(Параметры.ПолучателиОтчета));
	ИначеЕсли ТипЗнч(Параметры.ПолучателиОтчета) = Тип("СписокЗначений") Тогда
		ПолучателиОтчета.ЗагрузитьЗначения(Параметры.ПолучателиОтчета.ВыгрузитьЗначения());
	Иначе
		ВызватьИсключение НСтр("ru = 'Не поддерживаемый типа параметра ПолучателиОтчета: допустимо Массив, ФиксированныйМассив, СписокЗначений'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
