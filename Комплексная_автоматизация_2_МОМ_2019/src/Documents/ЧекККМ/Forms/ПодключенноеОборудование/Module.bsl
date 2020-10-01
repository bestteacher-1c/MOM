
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗначениеОткрыватьФормуСПодключеннымОборудованием = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ЧекККМ", "ОткрыватьФормуСПодключеннымОборудованием");
	Если ЗначениеОткрыватьФормуСПодключеннымОборудованием = Неопределено Тогда
		БольшеНеПоказывать = Ложь;
	Иначе
		БольшеНеПоказывать = Не ЗначениеОткрыватьФормуСПодключеннымОборудованием;
	КонецЕсли;
	
	ФормаВладелец                        = Параметры.УникальныйИдентификатор;
	ПодключитьОборудованиеПриОткрытии    = Параметры.ПодключитьОборудованиеПриОткрытии;
	ИспользоватьПодключаемоеОборудование = Истина;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь();
	Элементы.ГруппаОткрытьПодключаемоеОборудование.Видимость = ЭтоПолноправныйПользователь;
	Элементы.ГруппаОткрытьТекущиеНастройкиРМК.Видимость = ЭтоПолноправныйПользователь;
	
	РозничныеПродажи.ЗаполнитьТаблицуОборудование(ЭтотОбъект, Параметры.ПоддерживаемыеТипыПодключаемогоОборудования);
	
	Элементы.ОборудованиеГруппаУправлениеУстройствами.Доступность = Оборудование.Количество() > 0;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//ОборудованиеПодключено
	
	Если ПодключитьОборудованиеПриОткрытии Тогда
		
		Для Каждого СтрокаТЧ Из Оборудование Цикл
			
			МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоИдентификатору(
				Новый ОписаниеОповещения("НачатьПодключениеОборудованиеПоИдентификаторуЗавершение", ЭтотОбъект, СтрокаТЧ),
				ВладелецФормы.УникальныйИдентификатор,
				СтрокаТЧ.Ссылка);
			
		КонецЦикла;
		
	Иначе
		
		Для Каждого СтрокаТЧ Из глПодключаемоеОборудование.ПараметрыПодключенияПО Цикл
			
			Отбор = Новый Структура("Ссылка", СтрокаТЧ.Ссылка);
			НайденныеСтроки = Оборудование.НайтиСтроки(Отбор);
			Для Каждого СтрокаОборудование Из НайденныеСтроки Цикл
				СтрокаОборудование.Подключено = 0;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ЗавершениеРаботы Тогда
		ПередЗакрытиемНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПодключаемоеОборудование(Команда)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьТекущиеНастройкиРМК(Команда)
	
	ТекущиеНастройкиРМК = ТекущиеНастройкиРМК();
	Если ЗначениеЗаполнено(ТекущиеНастройкиРМК) Тогда
		ПоказатьЗначение(Неопределено, ТекущиеНастройкиРМК);
	Иначе
		ОткрытьФорму("Справочник.НастройкиРМК.ФормаОбъекта",,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключить(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Подключено = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Оборудование уже подключено.'"));
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоИдентификатору(
		Новый ОписаниеОповещения("НачатьПодключениеОборудованиеПоИдентификаторуЗавершение", ЭтотОбъект, ТекущиеДанные),
		ВладелецФормы.УникальныйИдентификатор,
		ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.Оборудование.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Подключено = 1 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Оборудование не подключено.'"));
		Возврат;
	КонецЕсли;
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПоИдентификатору(
		Новый ОписаниеОповещения("НачатьОтключениеОборудованиеПоИдентификаторуЗавершение", ЭтотОбъект, ТекущиеДанные),
		ВладелецФормы.УникальныйИдентификатор,
		ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ТекущиеНастройкиРМК()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НастройкиРМК.Ссылка
	|ИЗ
	|	Справочник.НастройкиРМК КАК НастройкиРМК
	|ГДЕ
	|	НастройкиРМК.РабочееМесто = &РабочееМесто";
	
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.Ссылка;
		
	Иначе
		
		Возврат Справочники.НастройкиРМК.ПустаяСсылка();
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ПередЗакрытиемНаСервере()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ЧекККМ", "ОткрыватьФормуСПодключеннымОборудованием", Не БольшеНеПоказывать);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеОборудованиеПоИдентификаторуЗавершение(Данные, СтрокаТЧ) Экспорт

	Если НЕ Данные.Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'При подключении устройства %Устройство% произошла ошибка:
		                            |""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", Данные.ОписаниеОшибки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Устройство%",     СтрокаТЧ.Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Оборудование", Оборудование.Индекс(СтрокаТЧ) + 1, "Представление"),
			,
			Ложь);
		
		СтрокаТЧ.Подключено = 1;
		
	Иначе
		
		СтрокаТЧ.Подключено = 0;
		
	КонецЕсли;
	
	Оповестить("ОборудованиеПодключено", Новый Структура, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОтключениеОборудованиеПоИдентификаторуЗавершение(Данные, СтрокаТЧ) Экспорт

	Если Не Данные.Результат Тогда
		
		ТекстСообщения = НСтр("ru = 'При отключении устройства %Устройство% произошла ошибка:
		                            |""%ОписаниеОшибки%"".'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", Данные.ОписаниеОшибки);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Устройство%",     СтрокаТЧ.Ссылка);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
			,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Оборудование", Оборудование.Индекс(СтрокаТЧ) + 1, "Представление"),
			,
			Ложь);
		
	Иначе
		
		СтрокаТЧ.Подключено = 1;
		
	КонецЕсли;
	
	Оповестить("ОборудованиеПодключено", Новый Структура, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
