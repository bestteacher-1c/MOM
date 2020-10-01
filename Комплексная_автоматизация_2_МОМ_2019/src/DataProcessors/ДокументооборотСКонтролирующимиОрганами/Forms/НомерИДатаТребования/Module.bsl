
&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Требование = Параметры.Требование;

	ПрорисоватьПриложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВложенияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяФайла = НавигационнаяСсылкаФорматированнойСтроки;
	
	Результат = ПолучитьВложениеНаСервере(ИмяФайла);
	Если ЗначениеЗаполнено(Результат.ТекстПредупреждения) Тогда 
		ПоказатьПредупреждение(, Результат.ТекстПредупреждения);
	Иначе
		Если Результат.ВАрхиве Тогда 
			КонтекстЭДОКлиент.ПоказатьУведомлениеАрхивныхФайлов(, 9, 3, Истина);
			Возврат;
		КонецЕсли;
		ОперацииСФайламиЭДКОКлиент.ОткрытьФайл(Результат.АдресДанных, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродолжитьОтправку(Команда)
	
	ЕстьОшибка = Ложь;
	Если НЕ ЗначениеЗаполнено(Номер) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Заполните номер требования'"), ,"Номер");
		ЕстьОшибка = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Заполните дату требования'"), ,"Дата");
		ЕстьОшибка = Истина;
	КонецЕсли;
	
	Если ЕстьОшибка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Номер", Номер);
	ДополнительныеПараметры.Вставить("Дата", Дата);
	
	Закрыть(ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
		
КонецПроцедуры

&НаСервере
Функция ПрорисоватьПриложения()
	
	ВсеВложенияТребования = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ПолучитьВложенияДокументовРеализацииПолномочийНалоговыхОрганов(Требование);
	
	ЭтоТребованиеОПредставленииПояснений = 
		Требование.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииПоясненийКДекларацииНДС;
	
	Если ЭтоТребованиеОПредставленииПояснений Тогда
		// Не показываем xml-файлы, если это требование о представлении пояснений к декларации по НДС
		Для каждого ПриложениеТребования Из ВсеВложенияТребования Цикл
			
			СвойстваФайла = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПриложениеТребования.ИмяФайла);
			
			Если ВРЕГ(СвойстваФайла.Расширение) <> ВРЕГ(".xml") Тогда
				Вложения.Добавить(ПриложениеТребования);
			КонецЕсли;
		
		КонецЦикла;
	Иначе
		Вложения.ЗагрузитьЗначения(ВсеВложенияТребования);
	КонецЕсли;
	
	Элементы.Вложения.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ФорматированноеПредставлениеСпискаВложений(Вложения.ВыгрузитьЗначения(), Ложь);
	
КонецФункции

&НаСервере
Функция ПолучитьВложениеНаСервере(ИмяФайла)
	
	Результат = Новый Структура("ТекстПредупреждения, АдресДанных, ВАрхиве", "",, Ложь);
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		Результат.ТекстПредупреждения = ТекстСообщения;
		Возврат Результат;
	КонецЕсли;
	
	// получаем вложение
	СтрВложения = КонтекстЭДОСервер.ПолучитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов(Требование, ИмяФайла);
	Если СтрВложения.Количество() = 0 Тогда
		Результат.ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Вложение с именем  %1 не обнаружено.'"), Символ(34) + ИмяФайла + Символ(34));
		Возврат Результат;
	КонецЕсли;
	
	Вложение = СтрВложения[0];
	
	Если Вложение.ВАрхиве Тогда 
		Результат.ВАрхиве = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Адрес = ПоместитьВоВременноеХранилище(Вложение.Данные.Получить(), УникальныйИдентификатор);
	Результат.АдресДанных = Адрес;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

