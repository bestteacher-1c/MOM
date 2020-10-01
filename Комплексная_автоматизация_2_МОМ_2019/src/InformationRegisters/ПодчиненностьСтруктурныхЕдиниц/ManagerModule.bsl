#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОбновитьПодчиненностьСтруктурныхЕдиниц(СписокСтруктурныхЕдиниц) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка КАК Ссылка,
		|	СтруктураПредприятия.Родитель КАК Родитель
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Родитель <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)";
	
	РодителиСтруктурныхЕдиниц = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РодителиСтруктурныхЕдиниц.Вставить(Выборка.Ссылка, Выборка.Родитель);
	КонецЦикла;
	
	Для каждого СтруктурнаяЕдиница Из СписокСтруктурныхЕдиниц Цикл
		
		Уровень = 0;
		
		НаборЗаписей = РегистрыСведений.ПодчиненностьСтруктурныхЕдиниц.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
		
		// Добавляем саму себя.
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.СтруктурнаяЕдиница = СтруктурнаяЕдиница;
		НоваяЗапись.ВышестоящаяСтруктурнаяЕдиница = СтруктурнаяЕдиница;
		НоваяЗапись.Уровень = Уровень;
		
		// Добавляем родителей.
		Родитель = РодителиСтруктурныхЕдиниц.Получить(СтруктурнаяЕдиница);
		Пока Родитель <> Неопределено Цикл
			Уровень = Уровень + 1;
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.СтруктурнаяЕдиница = СтруктурнаяЕдиница;
			НоваяЗапись.ВышестоящаяСтруктурнаяЕдиница = Родитель;
			НоваяЗапись.Уровень = Уровень;
			
			Родитель = РодителиСтруктурныхЕдиниц.Получить(НоваяЗапись.ВышестоящаяСтруктурнаяЕдиница);
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ОбновитьПодчиненностьСтруктурныхЕдиницПриСменеРодителя(ПеремещаемаяСтруктурнаяЕдиница, ПредыдущийРодитель, ТекущийРодитель) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Ссылка = &ПеремещаемаяСтруктурнаяЕдиница
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	СтруктураПредприятия.Ссылка
		|ИЗ
		|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
		|ГДЕ
		|	СтруктураПредприятия.Ссылка В ИЕРАРХИИ(&ПеремещаемаяСтруктурнаяЕдиница)";
	
	Запрос.УстановитьПараметр("ПеремещаемаяСтруктурнаяЕдиница", ПеремещаемаяСтруктурнаяЕдиница);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокСтруктурныхЕдиниц = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	// Очистка предыдущего.
	Если ЗначениеЗаполнено(ПредыдущийРодитель) Тогда
		Для каждого СтруктурнаяЕдиница Из СписокСтруктурныхЕдиниц Цикл
			НаборЗаписей = РегистрыСведений.ПодчиненностьСтруктурныхЕдиниц.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.СтруктурнаяЕдиница.Установить(СтруктурнаяЕдиница);
			НаборЗаписей.Отбор.ВышестоящаяСтруктурнаяЕдиница.Установить(ПредыдущийРодитель);
			НаборЗаписей.Записать();
		КонецЦикла; 
	КонецЕсли;

	УстановитьПривилегированныйРежим(Ложь);
	
	// Добавление нового.
	Если ЗначениеЗаполнено(ТекущийРодитель) Тогда
		ОбновитьПодчиненностьСтруктурныхЕдиниц(СписокСтруктурныхЕдиниц);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли