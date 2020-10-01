#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ГруппаФинансовогоУчета") Тогда
		ГруппаФинансовогоУчета = Параметры.ГруппаФинансовогоУчета;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокСобственнаяНоменклатура, "ГруппаФинансовогоУчета", ГруппаФинансовогоУчета, ЗначениеЗаполнено(ГруппаФинансовогоУчета));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокНоменклатураПереданная, "ГруппаФинансовогоУчета", ГруппаФинансовогоУчета, ЗначениеЗаполнено(ГруппаФинансовогоУчета));
		
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	#Область УправлениеЭлементамиПоФО
	ПлательщикЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД");
	Элементы.СчетУчетаВыручкиОтПродажЕНВД.Видимость = ПлательщикЕНВД;
	Элементы.СчетУчетаСебестоимостиПродажЕНВД.Видимость = ПлательщикЕНВД;
	Элементы.СтатьяДоходовЕНВД.Видимость = ПлательщикЕНВД;
	Элементы.ГруппаСчетаУчетаВыручки.ОтображатьВШапке = ПлательщикЕНВД;
	Элементы.ГруппаСчетаУчетаСебестоимости.ОтображатьВШапке = ПлательщикЕНВД;
	Элементы.ГруппаСтатьиДоходов.ОтображатьВШапке = ПлательщикЕНВД;
	Элементы.СписокСобственнаяНоменклатураСчетУчетаВыручкиОтПродаж.Заголовок = ?(ПлательщикЕНВД, НСтр("ru='ОСНО'"), НСтр("ru='Выручка от продаж'"));
	Элементы.СписокСобственнаяНоменклатураСчетУчетаСебестоимостиПродаж.Заголовок = ?(ПлательщикЕНВД, НСтр("ru='ОСНО'"), НСтр("ru='Себестоимость продажи'"));
	Элементы.СтатьяДоходовОСНО.Заголовок = ?(ПлательщикЕНВД, НСтр("ru='ОСНО'"), НСтр("ru='Статья доходов'"));
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГруппаФинансовогоУчетаПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокСобственнаяНоменклатура, "ГруппаФинансовогоУчета", ГруппаФинансовогоУчета, ЗначениеЗаполнено(ГруппаФинансовогоУчета));
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(
		СписокНоменклатураПереданная, "ГруппаФинансовогоУчета", ГруппаФинансовогоУчета, ЗначениеЗаполнено(ГруппаФинансовогоУчета));
	
КонецПроцедуры

#КонецОбласти
