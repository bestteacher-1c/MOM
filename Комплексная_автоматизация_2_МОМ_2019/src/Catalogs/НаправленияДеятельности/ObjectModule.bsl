
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Если НЕ ЭтоГруппа Тогда
			ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если Статус.Пустая() Тогда
		Статус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПроверитьЗаполнитьПередЗаписью(Назначение, ШаблонНазначения, ЭтотОбъект, "УчетЗатрат", Отказ, Истина, Не УчетЗатрат);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	Если Не ЭтоНовый() Тогда
		РеквизитыДоЗаписи = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,"ДопускаетсяОбособлениеСверхПотребности,ПометкаУдаления");
		
		ДополнительныеСвойства.Вставить("ОбновитьНазначение", 
			РеквизитыДоЗаписи.ДопускаетсяОбособлениеСверхПотребности <> ДопускаетсяОбособлениеСверхПотребности);
	Иначе
		ДополнительныеСвойства.Вставить("ОбновитьНазначение", ДопускаетсяОбособлениеСверхПотребности);
	КонецЕсли;	
	
	ОбщегоНазначенияУТ.ПодготовитьДанныеДляСинхронизацииКлючей(ЭтотОбъект, ПараметрыСинхронизацииКлючей());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияУТ.СинхронизироватьКлючи(ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонНазначения = Справочники.НаправленияДеятельности.ШаблонНазначения(ЭтотОбъект);
	Справочники.Назначения.ПриЗаписиСправочника(Назначение, 
												ШаблонНазначения,
												ЭтотОбъект,
												УчетНДСУП.ВидДеятельностиПоНалогообложениюНДС(НалогообложениеНДС),
												ДополнительныеСвойства.ОбновитьНазначение);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Запись подчиненной константы.
	ОбеспечениеСервер.ИспользоватьУправлениеПеремещениемОбособленныхТоваровВычислитьИЗаписать();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НалогообложениеНДСОпределяетсяВДокументе Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		Назначение = Справочники.Назначения.ПустаяСсылка();
		Если НалогообложениеНДСОпределяетсяВДокументе Тогда
			НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыСинхронизацииКлючей()
	
	Результат = Новый Соответствие;
	
	Результат.Вставить("Справочник.КлючиАналитикиУчетаПоПартнерам", "ПометкаУдаления");
	
	//++ НЕ УТ
	Результат.Вставить("Справочник.ПартииПроизводства", "ПометкаУдаления");
	//-- НЕ УТ
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
#КонецОбласти

#КонецЕсли