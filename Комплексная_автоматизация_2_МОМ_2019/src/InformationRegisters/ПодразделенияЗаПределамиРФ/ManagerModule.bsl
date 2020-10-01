#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Подразделение.Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьВторичныеДанные(Подразделение = Неопределено) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы") Тогда 
		Возврат;
	КонецЕсли;
	
	Набор = РегистрыСведений.ПодразделенияЗаПределамиРФ.СоздатьНаборЗаписей();
	Набор.ОбменДанными.Загрузка = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДатыНачала.СтруктурнаяЕдиница КАК Подразделение,
	|	ДатыНачала.Период КАК ДатаНачала,
	|	МИНИМУМ(ЕСТЬNULL(ДатыОкончания.Период, &МаксимальнаяДата)) КАК ДатаОкончания,
	|	ДатыНачала.СтруктурнаяЕдиница.Владелец КАК Организация
	|ИЗ
	|	РегистрСведений.ТерриториальныеУсловияПФР КАК ДатыНачала
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТерриториальныеУсловияПФР КАК ДатыОкончания
	|		ПО ДатыНачала.СтруктурнаяЕдиница = ДатыОкончания.СтруктурнаяЕдиница
	|			И ДатыНачала.ТерриториальныеУсловияПФР <> ДатыОкончания.ТерриториальныеУсловияПФР
	|			И ДатыНачала.Период < ДатыОкончания.Период
	|ГДЕ
	|	ДатыНачала.СтруктурнаяЕдиница ССЫЛКА Справочник.ПодразделенияОрганизаций
	|	И ДатыНачала.ТерриториальныеУсловияПФР = ЗНАЧЕНИЕ(Справочник.ТерриториальныеУсловияПФР.ЗАГР)
	|	И ДатыНачала.СтруктурнаяЕдиница = &Подразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДатыНачала.СтруктурнаяЕдиница,
	|	ДатыНачала.Период,
	|	ДатыНачала.СтруктурнаяЕдиница.Владелец";
	Запрос.УстановитьПараметр("МаксимальнаяДата", ЗарплатаКадрыПериодическиеРегистры.МаксимальнаяДата());
	
	Если Подразделение = Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДатыНачала.СтруктурнаяЕдиница = &Подразделение", "(ИСТИНА)");
		Набор.Записать();
	Иначе
		Запрос.УстановитьПараметр("Подразделение", Подразделение);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
		Если Подразделение <> Неопределено Тогда
			Набор.Отбор.Подразделение.Установить(Подразделение);
			Набор.Записать();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Пока Выборка.СледующийПоЗначениюПоля("Подразделение") Цикл
		
		Набор.Отбор.Подразделение.Установить(Выборка.Подразделение);
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(Набор.Добавить(), Выборка);
		КонецЦикла;
		
		Набор.Записать();
		Набор.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли