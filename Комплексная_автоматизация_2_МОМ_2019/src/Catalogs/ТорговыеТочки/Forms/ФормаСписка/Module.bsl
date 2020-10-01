
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Организация") И ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
		Организация = Параметры.Отбор.Организация;
	Иначе
		ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	КонецЕсли;

	Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ТорговыеТочки) Тогда
		Элементы.ФормаСнятьСУчета.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОтображатьТолькоДействующиеТочкиПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
	Модифицированность = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьСУчета(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ВызватьИсключение НСтр("ru='Команда не может быть выполнена для указанного объекта.'");
	КонецЕсли;
	
	Если НЕ ТорговыйСборВызовСервера.ВозможноИзменитьПараметрыТорговойТочки(ТекущиеДанные.Ссылка) Тогда
		
		ТекстПредупреждения = НСтр("ru='Торговая точка уже снята с учета.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ТорговаяТочка, КлючНазначенияИспользования",
		ТекущиеДанные.Ссылка,
		"СнятьСУчетаИзФормыСписка");
	ОткрытьФорму("Справочник.ТорговыеТочки.Форма.ФормаСнятияСУчета", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Если Форма.ПоказыватьТолькоДействующиеТочки Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Форма.Список, "ТорговаяТочкаЗакрыта", Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Форма.Список, "ТорговаяТочкаЗакрыта");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
