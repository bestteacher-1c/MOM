#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ТекущийКонтейнер;
Перем ТекущийПотокЗаменыСсылок;
Перем ТекущиеОбработчики;
Перем ТекущееИмяКолонкиИсходныхСсылок;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура Инициализировать(Контейнер, ПотокЗаменыСсылок, Обработчики) Экспорт
	
	ТекущийКонтейнер = Контейнер;
	ТекущийПотокЗаменыСсылок = ПотокЗаменыСсылок;
	ТекущиеОбработчики = Обработчики;
	
	ИмяФайла = Контейнер.ПолучитьПроизвольныйФайл(ВыгрузкаЗагрузкаДанныхСлужебный.ТипДанныхДляИмениКолонкиТаблицыЗначений());
	ТекущееИмяКолонкиИсходныхСсылок = ВыгрузкаЗагрузкаДанных.ПрочитатьОбъектИзФайла(ИмяФайла);
	
	Если ТекущееИмяКолонкиИсходныхСсылок = Неопределено Или ПустаяСтрока(ТекущееИмяКолонкиИсходныхСсылок) Тогда 
		ВызватьИсключение НСтр("ru = 'Не найдено имя колонки с исходной ссылкой'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьСопоставлениеСсылок() Экспорт
	
	ТаблицаОписанийФайлов = ТекущийКонтейнер.ПолучитьОписанияФайловИзКаталога(ВыгрузкаЗагрузкаДанныхСлужебный.ReferenceMapping());
	
	Граф = Обработки.ВыгрузкаЗагрузкаДанныхГрафЗависимостейСловарейСопоставленияСсылок.Создать();
	
	Для Каждого ОписаниеФайла Из ТаблицаОписанийФайлов Цикл
		Граф.ДобавитьВершину(ОписаниеФайла.ТипДанных);
	КонецЦикла;
	
	ЗависимостиТипов = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьЗависимостиТиповПриЗаменеСсылок();
	
	Для Каждого ЗависимостьТипов Из ЗависимостиТипов Цикл
		
		Если ТаблицаОписанийФайлов.НайтиСтроки(Новый Структура("ТипДанных", ЗависимостьТипов.Ключ)).Количество() > 0 Тогда
			
			ИменаЗависимыхОбъектов = ЗависимостьТипов.Значение; // Массив из Строка
			Для Каждого ПолноеИмяЗависимогоОбъекта Из ИменаЗависимыхОбъектов Цикл
				
				Если ТаблицаОписанийФайлов.НайтиСтроки(Новый Структура("ТипДанных", ПолноеИмяЗависимогоОбъекта)).Количество() > 0 Тогда
					
					Граф.ДобавитьРебро(ЗависимостьТипов.Ключ, ПолноеИмяЗависимогоОбъекта);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ПорядокОбхода = Граф.ТопологическаяСортировка();
	
	Для Каждого ОбъектМетаданных Из ПорядокОбхода Цикл
		
		ПараметрыОтбора = Новый Структура();
		ПараметрыОтбора.Вставить("ТипДанных", ОбъектМетаданных.ПолноеИмя());
		СловариСопоставленияСсылок = ТаблицаОписанийФайлов.НайтиСтроки(ПараметрыОтбора);
		
		Для Каждого ОписаниеФайла Из СловариСопоставленияСсылок Цикл
			
			// Перед чтением выполняем замену ссылок в таблице со значениями полей естественного ключа.
			ТекущийПотокЗаменыСсылок.ВыполнитьЗаменуСсылокВФайле(ОписаниеФайла);
			
			// Читаем таблицу со значениями полей естественного ключа
			ТаблицаИсходныхСсылок = ВыгрузкаЗагрузкаДанных.ПрочитатьОбъектИзФайла(ОписаниеФайла.ПолноеИмя); // ТаблицаЗначений
		
			Отказ = Ложь;
			СтандартнаяОбработка = Истина;
			ОбработчикСопоставленияСсылок = Неопределено;
			
			ТекущиеОбработчики.ПередСопоставлениемСсылок(
				ТекущийКонтейнер,
				ОбъектМетаданных,
				ТаблицаИсходныхСсылок,
				СтандартнаяОбработка, 
				ОбработчикСопоставленияСсылок, 
				Отказ);
			
			Если Отказ Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтандартнаяОбработка Тогда
				
				Обработки.ВыгрузкаЗагрузкаДанныхМенеджерСопоставленияСсылок.ВыполнитьСтандартноеСопоставлениеСсылок(
					ТекущийПотокЗаменыСсылок, ОбъектМетаданных, ТаблицаИсходныхСсылок, ЭтотОбъект);
				
			Иначе
				
				ИмяТипаXML = ВыгрузкаЗагрузкаДанныхСлужебный.XMLТипСсылки(ОбъектМетаданных);
				
				СоответствиеСсылок = ОбработчикСопоставленияСсылок.СопоставитьСсылки(
					ТекущийКонтейнер, ЭтотОбъект, ТаблицаИсходныхСсылок); // см. ВыгрузкаЗагрузкаПредопределенныхДанных.СопоставитьСсылки
				Для Каждого ЭлементСоответствия Из СоответствиеСсылок Цикл
					
					ТекущийПотокЗаменыСсылок.ЗаменитьСсылку(ИмяТипаXML, Строка(ЭлементСоответствия[ТекущееИмяКолонкиИсходныхСсылок].УникальныйИдентификатор()),
						Строка(ЭлементСоответствия.Ссылка.УникальныйИдентификатор()));
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИмяКолонкиИсходныхСсылок() Экспорт
	
	Возврат ТекущееИмяКолонкиИсходныхСсылок;
	
КонецФункции

#КонецОбласти

#КонецЕсли
