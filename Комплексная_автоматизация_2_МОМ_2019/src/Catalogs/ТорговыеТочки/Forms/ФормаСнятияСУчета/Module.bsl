
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация   = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ТорговаяТочка, "Организация");
	ТорговаяТочка = Параметры.ТорговаяТочка;
	
	Если НЕ ЗначениеЗаполнено(Организация) И НЕ ЗначениеЗаполнено(ТорговаяТочка) Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения")
		И (ИмяСобытия = "Создание_ФормаТС1" ИЛИ ИмяСобытия = "Создание_ФормаТС2")
		И Параметр = ТорговаяТочка Тогда
		
		Если КлючНазначенияИспользования = "СнятьСУчетаИзФормыСписка" Тогда
			ЗаполнитьУведомлениеВМенеджереЗаписи(Источник);
		КонецЕсли;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСнятьСУчета(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДляАвтозаполненияФормыТС = СнятьСУчетаНаСервере();
	
	ОткрытьФорму(ПараметрыДляАвтозаполненияФормыТС.ИмяФормыУведомления,
		ПараметрыДляАвтозаполненияФормыТС.ПараметрыФормы,
		ЭтотОбъект);
	
	ОповеститьОбИзменении(ТорговаяТочка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СнятьСУчетаНаСервере()
	
	СоздатьЗаписьОСнятииТорговойТочкиСУчета();
	
	Если ТорговыйСбор.ЭтоПоследняяТорговаяТочкаОрганизации(ТорговаяТочка, Организация, ДатаСнятияСУчета) Тогда
		ИмяФормыУведомления = "Отчет.РегламентированноеУведомлениеТС2.Форма.Форма2015_1";
		ПараметрыФормы = Справочники.ТорговыеТочки.ПараметрыФормыТС2(ТорговаяТочка, ДатаСнятияСУчета);
	Иначе
		ИмяФормыУведомления = "Отчет.РегламентированноеУведомлениеТС1.Форма.Форма2015_1";
		ПараметрыФормы = Справочники.ТорговыеТочки.ПараметрыФормыТС1(ТорговаяТочка, ДатаСнятияСУчета);
		// Код 3 - это снятие с учета.
		ПараметрыФормы.Данные.ДанныеТорговойТочки.Т_1 = "3";
	КонецЕсли;
	
	Результат = Новый Структура("ИмяФормыУведомления, ПараметрыФормы", ИмяФормыУведомления, ПараметрыФормы);
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СоздатьЗаписьОСнятииТорговойТочкиСУчета()
	
	МенеджерЗаписи= РегистрыСведений.ПараметрыТорговыхТочек.СоздатьМенеджерЗаписи();
	
	ПараметрыТорговойТочки = РегистрыСведений.ПараметрыТорговыхТочек.ПараметрыТорговойТочки(
		ТорговаяТочка,
		ДатаСнятияСУчета);
		
	Если ПараметрыТорговойТочки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, ПараметрыТорговойТочки);
	МенеджерЗаписи.Период                = ДатаСнятияСУчета;
	МенеджерЗаписи.ДатаПодачиУведомления = ДатаСнятияСУчета;
	МенеджерЗаписи.ВидОперации = Перечисления.ВидыОперацийТорговыеТочки.СнятиеСУчета;
	МенеджерЗаписи.Записать();
	
	ЗначениеВРеквизитФормы(МенеджерЗаписи, "МенеджерЗаписиПараметровТорговойТочки");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУведомлениеВМенеджереЗаписи(Источник)
	
	МенеджерЗаписи = РеквизитФормыВЗначение("МенеджерЗаписиПараметровТорговойТочки");
	МенеджерЗаписи.Уведомление = Источник;
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

#КонецОбласти
