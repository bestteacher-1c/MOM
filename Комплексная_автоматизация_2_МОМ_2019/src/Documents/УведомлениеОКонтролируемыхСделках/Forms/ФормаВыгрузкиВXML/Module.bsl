#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Уведомление") Тогда
		Уведомление = Параметры.Уведомление;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузитьУведомлениеВXML(Команда)
	
	ВыгружаемыеДанные = ВыгрузитьНаСервере(УникальныйИдентификатор);
	
	Если ВыгружаемыеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
		ПолучитьПутьВыгрузкиИВыгрузить(ВыгружаемыеДанные);
	#Иначе
		ВыгрузитьУведомлениеВXML(ВыгружаемыеДанные, "");
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьУведомлениеВXML502(Команда)
	
	ВыгружаемыеДанные = ВыгрузитьНаСервере502(УникальныйИдентификатор);
	
	Если ВыгружаемыеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
		ПолучитьПутьВыгрузкиИВыгрузить(ВыгружаемыеДанные);
	#Иначе
		ВыгрузитьУведомлениеВXML(ВыгружаемыеДанные, "");
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВыгрузитьНаСервере(УникальныйИдентификатор)
	
	Если ЗначениеЗаполнено(Уведомление) Тогда
		ОбъектДокумента = Уведомление.ПолучитьОбъект();
		Возврат ОбъектДокумента.ВыгрузитьДокумент(УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ВыгрузитьНаСервере502(УникальныйИдентификатор)
	
	Если ЗначениеЗаполнено(Уведомление) Тогда
		ОбъектДокумента = Уведомление.ПолучитьОбъект();
		Возврат ОбъектДокумента.ВыгрузитьДокументСРазделениемНаФайлы(УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьПутьВыгрузкиИВыгрузить(ВыгружаемыеДанные) Экспорт
	
	Длг = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Длг.Заголовок = НСтр("ru = 'Укажите каталог для выгрузки уведомления'");
	
	ДополнительныеПараметры = Новый Структура("ВыгружаемыеДанные", ВыгружаемыеДанные);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолучитьПутьВыгрузкиИВыгрузитьЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Длг.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПутьВыгрузкиИВыгрузитьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено
		И ВыбранныеФайлы.Количество()>0 Тогда
		
		ВыбраннаяПапка = ВыбранныеФайлы.Получить(0);
		
		РазделительПутиОС = ПолучитьРазделительПути();
		ПутьДляВыгрузки = ВыбраннаяПапка+?(Прав(ВыбраннаяПапка, 1) <> РазделительПутиОС, РазделительПутиОС, "");
		ВыгрузитьУведомлениеВXML(ДополнительныеПараметры.ВыгружаемыеДанные, ПутьДляВыгрузки);
		
	Иначе
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьУведомлениеВXML(ВыгружаемыеДанные, ПутьВыгрузки="")
	
	МассивСообщений = Новый Массив;
	
	Для Каждого ФайлВыгрузки Из ВыгружаемыеДанные Цикл
		
		#Если ВебКлиент Тогда
			Попытка
				ПолучитьФайл(ФайлВыгрузки.АдресФайлаВыгрузки, ФайлВыгрузки.ИмяФайлаВыгрузки);
			Исключение
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = НСтр("ru='Не удалось записать файл ""%1""! 
					|Возможно, недостаточно места на диске, диск защищен от записи или не подключено расширение для работы с файлами.'");
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки);
				МассивСообщений.Добавить(Сообщение);
			КонецПопытки;
		#Иначе
			ДвоичныйФайл = ПолучитьИзВременногоХранилища(ФайлВыгрузки.АдресФайлаВыгрузки);
			Попытка
				ДвоичныйФайл.Записать(ПутьВыгрузки + ФайлВыгрузки.ИмяФайлаВыгрузки);
				ТекстСообщения = НСтр("ru='Файл выгрузки регламентированного отчета ""%1"" сохранен в каталог ""%2"".'");
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки, ПутьВыгрузки);
				МассивСообщений.Добавить(Сообщение);
			Исключение
				Сообщение = Новый СообщениеПользователю;
				ТекстСообщения = НСтр("ru='Не удалось записать файл ""%1""! Возможно, недостаточно места на диске или диск защищен от записи.'");
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки);
				МассивСообщений.Добавить(Сообщение);
			КонецПопытки;
		#КонецЕсли
		
	КонецЦикла;
	
	Закрыть(МассивСообщений);
	
КонецПроцедуры

#КонецОбласти