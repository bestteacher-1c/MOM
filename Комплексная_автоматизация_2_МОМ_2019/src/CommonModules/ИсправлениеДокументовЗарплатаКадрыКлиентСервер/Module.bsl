
#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает значения реквизитам формы с включенным механизмом исправлений.
//
// Параметры:
//  Форма                 - Форма  - Форма документа.
//  РежимИсправления      - Строка - Допустимые значения:
//  	"РасчетЗарплаты"        - для расчетных документов;
//  	"ПериодическиеСведения" - для документов, которые вводят периодические сведения;
//  ПолеПериодРегистрации - Строка - По умолчанию "ПериодРегистрации".
//
Процедура УстановитьПоляИсправления(Форма, РежимИсправления = "РасчетЗарплаты", ПолеПериодРегистрации = "ПериодРегистрации") Экспорт
	
	Если Не Форма.ИспользоватьРасчетЗарплатыРасширенная Тогда
		Возврат;
	КонецЕсли;
	
	Объект = Форма.Объект;
	
	ИспользоватьИсправлениеДокумента = Форма.ВозможностиИсправления.Исправление;
	ИспользоватьСторнированиеДокумента = Форма.ВозможностиИсправления.Сторнирование;
	
	ДокументУтвержден = УтверждениеДокумента(Форма, Форма.Элементы.Найти("Расчетчик")) И Объект.Проведен;
	ДоступноИсправлениеДокумента = ИспользоватьИсправлениеДокумента И ДокументУтвержден И Форма.ДоступноИсправлениеДокумента;
	ДоступноСторнированиеДокумента = ИспользоватьСторнированиеДокумента И ДокументУтвержден И Форма.ДоступноСторнированиеДокумента;
	
	ЭтоДокументИсправление = ИспользоватьИсправлениеДокумента И ЗначениеЗаполнено(Форма.ПараметрыИсправленногоДокумента.Ссылка);
	ДокументИсправлен = ИспользоватьИсправлениеДокумента И Форма.ДокументИсправлен;
	ДокументСторнирован = ИспользоватьСторнированиеДокумента И Форма.ДокументСторнирован;
	
	ВидимостьПанелиИсправления = ЭтоДокументИсправление	Или ДокументИсправлен Или ДокументСторнирован
		Или(Форма.РекомендованоИсправление И (ДоступноИсправлениеДокумента Или ДоступноСторнированиеДокумента));
	
	Форма.Элементы.ГруппаИсправление.Видимость = ВидимостьПанелиИсправления;
	
	Если Не ВидимостьПанелиИсправления Тогда 
		Возврат;
	КонецЕсли;
	
	Форма.ТолькоПросмотр = Форма.ТолькоПросмотр Или ДокументИсправлен Или ДокументСторнирован;
	
	ВидимостьКомандыИсправить = ДоступноИсправлениеДокумента
		И Форма.РекомендованоИсправление
		И Не(ДокументСторнирован Или ДокументИсправлен);
		
	Если ИспользоватьИсправлениеДокумента Тогда
		Форма.Элементы.Исправить.Видимость = ВидимостьКомандыИсправить;
		Если ЭтоДокументИсправление Тогда
			Форма.Элементы.Исправить.Заголовок = НСтр("ru = 'Исправить повторно'");
		Иначе
			Форма.Элементы.Исправить.Заголовок = НСтр("ru = 'Исправить'");
		КонецЕсли;
	КонецЕсли;
	
	ВидимостьКомандыСторнировать = ДоступноСторнированиеДокумента
		И Форма.РекомендованоИсправление
		И Не(ДокументСторнирован Или ДокументИсправлен);
		
	Если ИспользоватьСторнированиеДокумента Тогда
		Форма.Элементы.Сторнировать.Видимость = ВидимостьКомандыСторнировать;
	КонецЕсли;
	
	СтатусВнимание = Истина;
	КрасныйТекст = Ложь;
	ТекстНадписи = "";
	
	Если ДокументИсправлен Тогда
		Если ЭтоДокументИсправление Тогда
			ТекстНадписи = НСтр("ru = 'Документ является исправлением другого документа. В свою очередь документ повторно исправлен и его редактирование невозможно'");
		Иначе
			ТекстНадписи = НСтр("ru = 'Документ исправлен и его редактирование невозможно'");
		КонецЕсли;
		КрасныйТекст = Истина;
		
	ИначеЕсли ДокументСторнирован Тогда
		Если ЭтоДокументИсправление Тогда
			ТекстНадписи = НСтр("ru = 'Документ является исправлением другого документа. В свою очередь документ сторнирован и его редактирование невозможно'");
		Иначе
			ТекстНадписи = НСтр("ru = 'Документ сторнирован и его редактирование невозможно'");
		КонецЕсли;
		КрасныйТекст = Истина;
		
	ИначеЕсли ЭтоДокументИсправление Тогда
		ТекстНадписи = НСтр("ru = 'Документ является исправлением другого документа'");
		
	ИначеЕсли РежимИсправления = "РасчетЗарплаты" И (ИспользоватьИсправлениеДокумента Или ИспользоватьСторнированиеДокумента) Тогда
		ПериодРегистрации = Объект[ПолеПериодРегистрации];
		ПредставлениеПериода = Формат(ПериодРегистрации, "ДФ='ММММ гггг ""г""'");
		РедактированиеНеРекомендуется = Истина;
		
		Если Объект.Свойство("Организация") Тогда
			Если Форма.ПроведенаВыплатаЗарплаты = НеОпределено Или Форма.ПроизведеноОтражение = НеОпределено Тогда
				ИсправлениеДокументовЗарплатаКадрыВызовСервера.ЗаполнитьВыплатаПроизводиласьОтражениеВУчетеПроизводилось(
					Объект.Организация,
					Объект.Ссылка,
					ПериодРегистрации,
					Форма.ПроведенаВыплатаЗарплаты,
					Форма.ПроизведеноОтражение);
			КонецЕсли;
			
			Если Форма.ПроведенаВыплатаЗарплаты И Форма.ПроизведеноОтражение Тогда
				ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'За %1 уже проведены выплата и отражение зарплаты в бухгалтерском учете.'"), ПредставлениеПериода);
					
			ИначеЕсли Форма.ПроведенаВыплатаЗарплаты Тогда
				ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Выплата зарплаты за %1 уже проведена.'"), ПредставлениеПериода);
					
			ИначеЕсли Форма.ПроизведеноОтражение Тогда
				ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Произведено отражение зарплаты в бухгалтерском учете за %1.'"), ПредставлениеПериода);
					
			Иначе
				РедактированиеНеРекомендуется = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ВидимостьКомандыИсправить Или ВидимостьКомандыСторнировать Тогда
			
			Если РедактированиеНеРекомендуется Тогда
				ТекстНадписи = ТекстНадписи + ?(ПустаяСтрока(ТекстНадписи), "", " ");
				ТекстНадписи = ТекстНадписи + НСтр("ru = 'Редактирование этого документа не рекомендуется.'");
			Иначе
				СтатусВнимание = Ложь;
			КонецЕсли;
			
			ТекстНадписи = ТекстНадписи + ?(ПустаяСтрока(ТекстНадписи), "", Символы.ПС);
			
			Если Не РедактированиеНеРекомендуется И ВидимостьКомандыИсправить И ВидимостьКомандыСторнировать Тогда
				ТекстНадписи = ТекстНадписи
					+ НСтр("ru = 'Если необходимо внести исправление, но при этом сохранить данный экземпляр документа, воспользуйтесь командой Исправить или Сторнировать'");
			ИначеЕсли ВидимостьКомандыИсправить И ВидимостьКомандыСторнировать Тогда
				ТекстНадписи = ТекстНадписи
					+ НСтр("ru = 'Воспользуйтесь командой Исправить для исправления этого документа или Сторнировать для его отмены'"); 
			ИначеЕсли ВидимостьКомандыИсправить Тогда
				ТекстНадписи = ТекстНадписи
					+ НСтр("ru = 'Воспользуйтесь командой Исправить для исправления этого документа'");
			ИначеЕсли ВидимостьКомандыСторнировать Тогда
				ТекстНадписи = ТекстНадписи
					+ НСтр("ru = 'Воспользуйтесь командой Сторнировать для отмены этого документа'");
			КонецЕсли;
		КонецЕсли;	
			
	ИначеЕсли РежимИсправления = "ПериодическиеСведения" И (ИспользоватьИсправлениеДокумента Или ИспользоватьСторнированиеДокумента) Тогда
		ТекстНадписи = НСтр("ru = 'Если необходимо внести исправление, но при этом сохранить данный экземпляр документа, воспользуйтесь командой Исправить'");
		
	КонецЕсли;
	
	Форма.Элементы.ИсправлениеКартинка.Картинка = ?(СтатусВнимание, БиблиотекаКартинок.Предупреждение, БиблиотекаКартинок.Информация);	
	ИсправлениеИнфоНадпись = Форма.Элементы.ИсправлениеКартинка.РасширеннаяПодсказка;
	ИсправлениеИнфоНадпись.ЦветТекста = ?(КрасныйТекст, Форма.ИсправлениеЦветОсобогоТекста, Форма.ИсправлениеПоясняющийТекст);
	ИсправлениеИнфоНадпись.Заголовок = ТекстНадписи;
	
	Если ИспользоватьИсправлениеДокумента Тогда
		Форма.Элементы.ПерейтиКИсправлению.Видимость = ДокументИсправлен;
	КонецЕсли;
	
	Если ИспользоватьСторнированиеДокумента  Тогда
		Форма.Элементы.ПерейтиКСторно.Видимость = ДокументСторнирован И Форма.ДоступноЧтениеСторнирование;
	КонецЕсли;
	
	Если ИспользоватьИсправлениеДокумента Или ИспользоватьСторнированиеДокумента Тогда
		Форма.Элементы.ПерейтиКИсправленному.Видимость = ЭтоДокументИсправление;
	КонецЕсли;
	
КонецПроцедуры

Функция ЭтоИсправление(Форма, ПараметрыИсправленного = Неопределено) Экспорт
	
	ЭтоИсправление = ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыИсправленногоДокумента")
		И ЗначениеЗаполнено(Форма.ПараметрыИсправленногоДокумента.Ссылка);
		
	Если ЭтоИсправление Тогда
		ПараметрыИсправленного = Форма.ПараметрыИсправленногоДокумента;
	КонецЕсли;
	
	Возврат ЭтоИсправление;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция УтверждениеДокумента(Форма, ГруппаФормы, ДокументУтвержден = Истина)
	
	Если ГруппаФормы = Неопределено Тогда
		Возврат ДокументУтвержден;
	КонецЕсли;
	
	Для каждого ПодчиненныйЭлемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		Если ПодчиненныйЭлемент.Вид = ВидПоляФормы.ПолеФлажка Тогда
			ДокументУтвержден = Форма.Объект[ПодчиненныйЭлемент.Имя];
		КонецЕсли;
		Если ТипЗнч(ПодчиненныйЭлемент) = Тип("ГруппаФормы") Или ТипЗнч(ПодчиненныйЭлемент) = Тип("ТаблицаФормы") Тогда
			ДокументУтвержден = УтверждениеДокумента(Форма, ПодчиненныйЭлемент, ДокументУтвержден);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДокументУтвержден;
	
КонецФункции

#КонецОбласти
