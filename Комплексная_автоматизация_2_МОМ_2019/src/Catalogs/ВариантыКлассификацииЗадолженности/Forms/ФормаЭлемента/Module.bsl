
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.Календарь) Тогда
		РежимУчетаОтсрочки = 1;
	Иначе
		Элементы.Календарь.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если РежимУчетаОтсрочки = 1 И Не ЗначениеЗаполнено(Объект.Календарь) Тогда
		
		ТекстОшибки = НСтр("ru='Не указан календарь для учета интервалов по рабочим дням.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Объект.Ссылка,
			"Объект.Календарь",
			,
			Отказ);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимУчетаОтсрочкиПриИзменении(Элемент)
	
	Элементы.Календарь.Доступность = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	Элементы.Календарь.АвтоОтметкаНезаполненного = ?(РежимУчетаОтсрочки = 1, Истина, Ложь);
	
	Если РежимУчетаОтсрочки = 1 Тогда
		ЗаполнитьПроизводственныйКалендарьНаСервере();
	Иначе
		Объект.Календарь = ПредопределенноеЗначение("Справочник.ПроизводственныеКалендари.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнтервалы

&НаКлиенте
Процедура ИнтервалыПриИзменении(Элемент)
	
	СформироватьНаименованияГраниц();
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СформироватьНаименованияГраниц();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаКлиенте
Процедура СформироватьНаименованияГраниц()
	
	Интервалы = Объект.Интервалы;
	КоличествоИнтервалов = Интервалы.Количество();
	НаименованиеИнтервалаСвыше = НСтр("ru='Свыше %НижняяГраницаИнтервала% дней'");
	НаименованиеИнтервалаОтДо  = НСтр("ru='От %НижняяГраницаИнтервала% до %ВерхняяГраницаИнтервала% %ДняДней%'");
	ВерхняяГраницаИнтервала    = 9999999999;
	
	Для ТекИндекс = 1 По КоличествоИнтервалов-1 Цикл
		ПредыдущийЭтап = Интервалы[ТекИндекс-1];
		ЭтотЭтап = Интервалы[ТекИндекс];
		Если ЭтотЭтап.НижняяГраницаИнтервала = 0 Тогда
			ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала + 1;
		КонецЕсли;
		Пока (ТекИндекс - 1 >= 0) И ЭтотЭтап.НижняяГраницаИнтервала < Интервалы[ТекИндекс-1].НижняяГраницаИнтервала Цикл
			Интервалы.Сдвинуть(ТекИндекс,-1);
			ТекИндекс = ТекИндекс - 1;
		КонецЦикла;
	КонецЦикла;

	Если КоличествоИнтервалов = 1 Тогда
		
		Интервалы[0].НижняяГраницаИнтервала = 1;
		Интервалы[0].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
		Интервалы[0].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[0].НижняяГраницаИнтервала);
		
	ИначеЕсли КоличествоИнтервалов > 1 Тогда
		
		Интервалы[0].НижняяГраницаИнтервала = 1;
		
		Для ТекИндекс = 1 По КоличествоИнтервалов-1 Цикл
			
			ПредыдущийЭтап = Интервалы[ТекИндекс-1];
			
			ЭтотЭтап = Интервалы[ТекИндекс];
			
			Если ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала Тогда
				ЭтотЭтап.НижняяГраницаИнтервала = ПредыдущийЭтап.НижняяГраницаИнтервала + 1;
			КонецЕсли;
			
			Если ТекИндекс < КоличествоИнтервалов Тогда
				
				ПредыдущийЭтап.ВерхняяГраницаИнтервала = Интервалы[ТекИндекс].НижняяГраницаИнтервала-1;
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДо, "%НижняяГраницаИнтервала%", ПредыдущийЭтап.НижняяГраницаИнтервала);
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДоПредставление, "%ВерхняяГраницаИнтервала%", ПредыдущийЭтап.ВерхняяГраницаИнтервала);
				НаименованиеИнтервалаОтДоПредставление = СтрЗаменить(НаименованиеИнтервалаОтДоПредставление, "%ДняДней%", ?(ПредыдущийЭтап.ВерхняяГраницаИнтервала = 1,НСтр("ru='дня'"),НСтр("ru='дней'")));
				ПредыдущийЭтап.НаименованиеИнтервала = НаименованиеИнтервалаОтДоПредставление;
				
			КонецЕсли;
			
			Интервалы[КоличествоИнтервалов-1].ВерхняяГраницаИнтервала = ВерхняяГраницаИнтервала;
			Интервалы[КоличествоИнтервалов-1].НаименованиеИнтервала = СтрЗаменить(НаименованиеИнтервалаСвыше, "%НижняяГраницаИнтервала%", Интервалы[КоличествоИнтервалов-1].НижняяГраницаИнтервала);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПроизводственныйКалендарьНаСервере()
	
	КалендарныеГрафики.ЗаполнитьПроизводственныйКалендарьВФорме(ЭтаФорма, "Объект.Календарь");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
