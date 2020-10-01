
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СсылкаНаЭД = "";
	Если Параметры.Свойство("ЭлектронныйДокумент", СсылкаНаЭД) Тогда
		
		ЗначениеВРеквизитФормы(СсылкаНаЭД.ПолучитьОбъект(), "ЭлектронныйДокумент");
		
		СписокТиповДокументов = ОбменСКонтрагентамиСлужебный.СписокОперацийВидаЭД(ЭлектронныйДокумент.ВидЭД);
		
		Если СписокТиповДокументов.Количество() = 0 Тогда
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			
		ИначеЕсли СписокТиповДокументов.Количество() = 1 Тогда
			
			Элементы.ГруппаПодобрать.Видимость = Ложь;
			Элементы.ГруппаСоздать.Видимость = Ложь;
			
			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Создать_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "СоздатьДокументУчета";
			Элементы.ФормаСоздатьДокумент.ИмяКоманды = "Создать_" + СписокТиповДокументов[0].Значение;

			НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + СписокТиповДокументов[0].Значение);
			НоваяКоманда.Действие = "ПодобратьДокумент";
			Элементы.ФормаПодобратьДокумент.ИмяКоманды = "Прикрепить_" + СписокТиповДокументов[0].Значение;
			
		Иначе
			
			Элементы.ФормаПодобратьДокумент.Видимость = Ложь;
			Элементы.ФормаСоздатьДокумент.Видимость = Ложь;
			
			Для Каждого ЭлементСписка Из СписокТиповДокументов Цикл
				
				НоваяКоманда = ЭтотОбъект.Команды.Добавить("Прикрепить_" + ЭлементСписка.Значение);
				НоваяКоманда.Действие = "ПодобратьДокумент";
				
				НоваяКнопка = Элементы.Добавить("Прикрепить_" + ЭлементСписка.Значение,Тип("КнопкаФормы"),Элементы.ГруппаПодобрать);
				НоваяКнопка.Заголовок = ЭлементСписка.Представление;  
				НоваяКнопка.ИмяКоманды = "Прикрепить_" + ЭлементСписка.Значение;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров Тогда
			Элементы.ФормаПерезаполнитьТекущий.Заголовок = НСтр("ru = 'Сопоставить номенклатуру'");
		КонецЕсли;
		
		Если ТипЗнч(СсылкаНаЭД) = Тип("ДокументСсылка.ЭлектронныйДокументИсходящий") Тогда
			Элементы.ЭлектронныйДокументДокументыОснованияУдалитьДокумент.Видимость = ЭлектронныйДокумент.ВидЭД = Перечисления.ВидыЭД.ПроизвольныйЭД;
			Элементы.ЭлектронныйДокументДокументыОснованияУдалитьДокумент.ТолькоВоВсехДействиях = Ложь;
		КонецЕсли;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ПоказатьЗначение(,ТекСтрока.ДокументОснование);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьДокумент(Команда)
	
	Модифицированность = Ложь;
	СпособОбработки = СтрЗаменить(Команда.Имя,"Прикрепить_","");
	Тип = ПолучитьИмяДокументаНаСервере(СпособОбработки); 
	Если ЗначениеЗаполнено(Тип) Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодобратьДокументЗавершить", ЭтотОбъект,СпособОбработки);
		Подсказка = НСтр("ru = 'Укажите документ отражения в учете'");
		ПоказатьВводЗначения(ОписаниеОповещения, , Подсказка, Новый ОписаниеТипов(Тип));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСвязьСДокументом(Команда)
		
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Связь между документами разорвется. Повторно связать документы возможно только в ручном режиме. Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСвязьСДокументомЗавершить", ЭтотОбъект, ТекСтрока.ДокументОснование);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущий(Команда)
	
	Модифицированность = Ложь;
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	
	Если ТекСтрока <> Неопределено Тогда
		ТекстВопроса = НСтр("ru = 'Документ учета будет заполнены данными электронного документа. Продолжить?'");
		СтруктураПараметров = Новый Структура("ДокументОснование,СпособОбработки",ТекСтрока.ДокументОснование,ТекСтрока.СпособОбработки);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПерезаполнитьТекущийПродолжить", ЭтотОбъект, СтруктураПараметров);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПодобратьДокументЗавершить(Знач Результат, Знач СпособОбработки) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		ПерепривязатьЭлектронныйДокумент(Результат,СпособОбработки);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца()
	
	Оповестить("ЭлектронныйДокументИсходящий_ПодборДокументаУчета", ЭлектронныйДокумент.Ссылка, ЭтотОбъект.ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьДокументУчета(Команда)
	
	КонтекстОперации = ЭлектронноеВзаимодействиеСлужебныйКлиент.НовыйКонтекстОперации();
	СсылкаНаНовыйДокумент = СоздатьДокументУчетаНаСервере(СтрЗаменить(Команда.Имя,"Создать_",""), КонтекстОперации);
	ОповеститьВладельца();
	ПоказатьЗначение(,СсылкаНаНовыйДокумент);
	ЭлектронноеВзаимодействиеОбработкаОшибокКлиент.ОбработатьОшибки(КонтекстОперации);
	
КонецПроцедуры

&НаСервере
Функция СоздатьДокументУчетаНаСервере(СпособОбработки, КонтекстОперации)
	
	СсылкаНаНовыйДокумент = Неопределено;
	ОбменСКонтрагентамиСлужебный.ПерезаполнитьДокументыИБПоЭД(СсылкаНаНовыйДокумент, ЭлектронныйДокумент.Ссылка, СпособОбработки, КонтекстОперации);
	
	ОбработатьДокументыОснования(СсылкаНаНовыйДокумент, СпособОбработки);
	
	Возврат СсылкаНаНовыйДокумент;
	
КонецФункции

&НаКлиенте
Процедура УдалитьСвязьСДокументомЗавершить(Результат, СсылкаНаОбъект) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект);
		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязьСДокументомНаСервере(СсылкаНаОбъект)
	
	ОбработатьДокументыОснования(СсылкаНаОбъект,,Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИмяДокументаНаСервере(СпособОбработки)
	
	ИмяТипа = ОбменСКонтрагентамиСлужебный.ИмяДокументаПоСпособуОбработки(СпособОбработки);
	
	Тип = Неопределено;
	Если Метаданные.Справочники.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "СправочникСсылка." + ИмяТипа;
	ИначеЕсли Метаданные.Документы.Найти(ИмяТипа) <> Неопределено Тогда
	
		Тип = "ДокументСсылка." + ИмяТипа;
	КонецЕсли;
	
	Возврат Тип;
		
КонецФункции

&НаСервере
Процедура ПерепривязатьЭлектронныйДокумент(ВыбранноеЗначение,СпособОбработки)
	
	ОбработатьДокументыОснования(ВыбранноеЗначение,СпособОбработки);
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьДокументыОснования(СсылкаНаДокумент,СпособОбработки = "",Удаление = Ложь)
	
	ДокументОбъект = РеквизитФормыВЗначение("ЭлектронныйДокумент", Тип("ДокументОбъект.ЭлектронныйДокументИсходящий"));
	
	СтрокаОснования = ДокументОбъект.ДокументыОснования.Найти(СсылкаНаДокумент, "ДокументОснование");
	
	Если Удаление И ЗначениеЗаполнено(СтрокаОснования) Тогда
		ДокументОбъект.ДокументыОснования.Удалить(СтрокаОснования);
	КонецЕсли;
	
	Если НЕ Удаление И Не ЗначениеЗаполнено(СтрокаОснования) Тогда
		НоваяСтрока = ДокументОбъект.ДокументыОснования.Добавить();
		НоваяСтрока.ДокументОснование = СсылкаНаДокумент;
	КонецЕсли;
	
	ДокументОбъект.Записать();
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "ЭлектронныйДокумент");
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьТекущийПродолжить(Результат, СтруктураПараметров) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ОбменСКонтрагентамиКлиент.ПерезаполнитьДокумент(СтруктураПараметров.ДокументОснование, ЭлектронныйДокумент.Ссылка,
			СтруктураПараметров.СпособОбработки);

		ОповеститьВладельца();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

