///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Отбор.Свойство("Владелец") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
		
	Заголовок = ОбщегоНазначения.ПредставлениеСписка(Метаданные.Справочники.ПравилаОбработкиЭлектроннойПочты)
		+ ": " + Параметры.Отбор.Владелец;
	Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Параметры.Отбор.Владелец) Тогда
		ТолькоПросмотр = Истина;
		Элементы.ФормаПрименитьПравила.Видимость = Ложь;
		Элементы.НастройкаПорядкаЭлементов.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПрименитьПравила(Команда)
	
	ОчиститьСообщения();
	
	ПараметрыФормы = Новый Структура;
	
	МассивЭлементовОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(ВзаимодействияКлиентСервер.ОтборДинамическогоСписка(Список), "Владелец");
	Если МассивЭлементовОтбора.Количество() > 0 И МассивЭлементовОтбора[0].Использование
		И ЗначениеЗаполнено(МассивЭлементовОтбора[0].ПравоеЗначение) Тогда
		ПараметрыФормы.Вставить("УчетнаяЗапись",МассивЭлементовОтбора[0].ПравоеЗначение);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не установлен отбор по владельцу(учетной записи) правил.'"));
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПравилаОбработкиЭлектроннойПочты.Форма.ПрименениеПравил", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
