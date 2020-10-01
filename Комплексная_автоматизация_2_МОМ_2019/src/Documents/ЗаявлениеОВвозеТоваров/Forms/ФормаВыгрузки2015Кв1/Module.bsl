#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем АдресХранилищаДопРеквизиты;

	Если Параметры.Свойство("АдресХранилищаДопРеквизиты", АдресХранилищаДопРеквизиты) Тогда
		ЗагрузитьДанныеИзВременногоХранилища(АдресХранилищаДопРеквизиты);
	КонецЕсли;
	
	Параметры.Свойство("Организация",       Организация);
	Параметры.Свойство("Контрагент",        Контрагент);
	Параметры.Свойство("Договор",           Договор);
	Параметры.Свойство("НомерДоговора",     НомерДоговора);
	Параметры.Свойство("ДатаДоговора",      ДатаДоговора);
	Параметры.Свойство("ОтветственноеЛицо", ОтветственноеЛицо);
	Параметры.Свойство("ДатаОтправки",      ДатаОтправки);
	
	ЗаполнитьСписокВыбораВидовТранспорта(Элементы.ВидТранспорта.СписокВыбора);
	ИспользоватьДоговорыСПоставщиками = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками");

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И НЕ ПеренестиВДокумент Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ВопросСохраненияДанныхЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	ИначеЕсли ПеренестиВДокумент Тогда
		
		ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
		
		Если Отказ Тогда
			Модифицированность = Истина;
			ПеренестиВДокумент = Ложь;
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ОтветственныеЛицаОрганизаций" Тогда
		Если Не ЗначениеЗаполнено(ОтветственноеЛицо) Тогда 
			ОтветственноеЛицо = Источник;
			ОтветственноеЛицоПриИзменении(Неопределено);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда
		// ++ НЕ УТ
		Если ЗначениеЗаполнено(Организация) Тогда 
			СтрокаСведений = "ИННЮЛ, ИННФЛ, КППЮЛ, КодНО";
			СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, , СтрокаСведений);
			ИННЮЛОтпр = СведенияОбОрганизации.ИННЮЛ;
			ИННФЛОтпр = СведенияОбОрганизации.ИННФЛ;
			КППОтпр   = СведенияОбОрганизации.КППЮЛ;
			КодИФНС   = СведенияОбОрганизации.КодНО;
		КонецЕсли;
		// -- НЕ УТ
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрОтпрПриИзменении(Элемент)
	
	Если ПрОтпр = 1 Тогда
		
		ОтправительЯвляетсяЮЛ = НЕ СтруктураРеквизитов.ЭтоПБОЮЛ;
		
		НаимОтпр  = СтруктураРеквизитов.НалогоплательщикНаимЮЛ;
		ИННЮЛОтпр = СтруктураРеквизитов.НалогоплательщикИННЮЛ;
		КППОтпр   = СтруктураРеквизитов.НалогоплательщикКПП;
		ИННФЛОтпр = СтруктураРеквизитов.НалогоплательщикИННФЛ;
		
		ФИОФЛОтпр = ФизическиеЛицаКлиентСервер.ЧастиИмени(СтруктураРеквизитов.НалогоплательщикФИО);
		
		ФамилияФЛОтпр  = ФИОФЛОтпр.Фамилия;
		ИмяФЛОтпр      = ФИОФЛОтпр.Имя;
		ОтчествоФЛОтпр = ФИОФЛОтпр.Отчество;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры


&НаКлиенте
Процедура ОтправительЯвляетсяЮЛПриИзменении(Элемент)
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрПодп1ПриИзменении(Элемент)
	
	Если ПрПодп1 <> 3 Тогда
		НаимДовПодп1  = "";
		НомерДовПодп1 = "";
		ДатаДовПодп1  = '00010101'
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственноеЛицоПриИзменении(Элемент)
	
	ОтветственноеЛицоПриИзмененииНаСервере();
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУчастникиСделки

&НаКлиенте
Процедура УчастникиСделкиРольПродавцаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.УчастникиСделки.ТекущиеДанные;
	
	ДанныеСтрокиТаблицы = Новый Структура(
		"НадписьНомерДокумента, НадписьДатаДокумента");
		
	ЗаполнитьЗначенияСвойств(ДанныеСтрокиТаблицы, ТекущиеДанные);
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСтрокиТаблицы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если НЕ ФормаЗаполнена() Тогда
		Возврат;
	КонецЕсли; 
	
	Модифицированность = Ложь;
	
	АдресВременногоХранилища = ДанныеФормыВоВременноеХранилище();
	Закрыть(АдресВременногоХранилища);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортерСовпадаетСОтправителемПриИзменении(Элемент)
	
	Если Элемент <> Ложь Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Элементы.КтоИмпортирует.Видимость = НЕ ИмпортерСовпадаетСОтправителем;
	Элементы.ГруппаИмпортирует.Видимость = НЕ ИмпортерСовпадаетСОтправителем;
	Элементы.ГруппаИННКППИмпортирует.Видимость = НЕ ИмпортерСовпадаетСОтправителем;
	
	КтоИмпортируетПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИННИмпортируетЮЛПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КППИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КтоИмпортируетПриИзменении(Элемент)
	
	Если Элемент <> Ложь Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	Если КтоИмпортирует = 1 Тогда
		
		ФамилияФЛИмпорт = "";
		ИмяФЛИмпорт = "";
		ОтчествоФЛИмпорт = "";
		ИННФЛИмпорт = "";
		
	ИначеЕсли КтоИмпортирует = 2 Тогда
		
		НаимИмпорт = "";
		ИННЮЛИмпорт = "";
		КППИмпорт = "";
		
	КонецЕсли;
		
	Элементы.ГруппаИмпортируетФЛ.Видимость = КтоИмпортирует = 2;
	Элементы.ГруппаИмпортируетЮЛ.Видимость = КтоИмпортирует = 1;
	Элементы.ГруппаИННКППИмпортируетФЛ.Видимость = КтоИмпортирует = 2;
	Элементы.ГруппаИННКППИмпортируетЮЛ.Видимость = КтоИмпортирует = 1;
	
	ИмпортерЯвляетсяЮЛ = ?(КтоИмпортирует = 1, Истина, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ФамилияИмпортируетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция ДанныеФормыВоВременноеХранилище()
	
	СтруктураДопРеквизитов = Новый Структура;
	Если СтруктураРеквизитов <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ЭтотОбъект);
	КонецЕсли;
	СтруктураДопРеквизитов.Вставить("СтруктураРеквизитовВыгрузки", СтруктураРеквизитов);
	СтруктураДопРеквизитов.Вставить("Спецификации", Спецификации.Выгрузить());
	СтруктураДопРеквизитов.Вставить("УчастникиСделки", УчастникиСделки.Выгрузить());
	СтруктураДопРеквизитов.Вставить("ДокументыПоступления", ДокументыПоступления.Выгрузить());
	СтруктураДопРеквизитов.Вставить("Договор", Договор);
	СтруктураДопРеквизитов.Вставить("НомерДоговора", НомерДоговора);
	СтруктураДопРеквизитов.Вставить("ДатаДоговора", ДатаДоговора);
	СтруктураДопРеквизитов.Вставить("ОтветственноеЛицо", ОтветственноеЛицо);
	СтруктураДопРеквизитов.Вставить("ДатаОтправки", ДатаОтправки);
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(СтруктураДопРеквизитов, УникальныйИдентификатор);
	
	Возврат АдресВременногоХранилища;
	
КонецФункции

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьОтветственноеЛицоОрганизации(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Автозаполнение", Истина);
	ПараметрыФормы.Вставить("Владелец", Организация);
	ПараметрыФормы.Вставить("Наименование", ФамилияПодп1 + " " + ИмяПодп1 + " " + ОтчествоПодп1);
	ПараметрыФормы.Вставить("Должность", ДолжностьПодп1);
	ПараметрыФормы.Вставить("ПравоПодписиПоДоверенности", (ПрПодп1 = 3));
	ПараметрыФормы.Вставить("ДатаНачала", ОбщегоНазначенияКлиент.ДатаСеанса());
	ПараметрыФормы.Вставить("ДокументПраваПодписи", НаимДовПодп1);
	ПараметрыФормы.Вставить("НомерДокументаПраваПодписи", НомерДовПодп1);
	ПараметрыФормы.Вставить("ДатаДокументаПраваПодписи", ДатаДовПодп1);
	
	ОткрытьФорму("Справочник.ОтветственныеЛицаОрганизаций.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Для Индекс = 0 По УчастникиСделки.Количество() - 1 Цикл
		
		СтрокаУчастникиСделки = УчастникиСделки[Индекс];
		
		Префикс = "УчастникиСделки[%1]";
		Префикс = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Префикс, Формат(Индекс, "ЧН=0; ЧГ="));
				
		ИмяСписка = НСтр("ru = 'Участники сделки'");
				
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.РольПродавца) Тогда
			Поле = Префикс + ".РольПродавца";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Роль продавца'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.Продавец) Тогда
			Поле = Префикс + ".Продавец";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Продавец'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.РольПокупателя) Тогда
			Поле = Префикс + ".РольПокупателя";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Роль покупателя'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.Покупатель) Тогда
			Поле = Префикс + ".Покупатель";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Покупатель'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.НомерДоговора) Тогда
			Поле = Префикс + ".НомерДоговора";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Номер договра'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;

		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.ДатаДоговора) Тогда
			Поле = Префикс + ".ДатаДоговора";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата договра'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.НомерСпецификации) Тогда
			Поле = Префикс + ".НомерСпецификации";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Номер спецификации'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаУчастникиСделки.ДатаСпецификации) Тогда
			Поле = Префикс + ".ДатаСпецификации";
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("Колонка",, НСтр("ru = 'Дата спецификации'"),
					Индекс + 1, ИмяСписка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , Поле, , Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеИзВременногоХранилища(АдресХранилища)
	
	ДанныеХранилища = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	СтруктураРеквизитов = ДанныеХранилища.СтруктураРеквизитовВыгрузки;
	Если ТипЗнч(СтруктураРеквизитов) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураРеквизитов);
	КонецЕсли;
	
	УчастникиСделки.Загрузить(ДанныеХранилища.УчастникиСделки);
	Спецификации.Загрузить(ДанныеХранилища.Спецификации);
	ДокументыПоступления.Загрузить(ДанныеХранилища.ДокументыПоступления);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохраненияДанныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ПеренестиВДокумент = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ФормаЗаполнена()
	
	Статус = Истина;
	//++ НЕ УТ
	
	Если НЕ ЗначениеЗаполнено(КодИФНС) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='В карточке организации не заполнен код налогового органа!'"),
			,
			"НаимОтпр");
			
			Статус = Ложь;
		
	ИначеЕсли СтрДлина(СокрЛП(КодИФНС)) <> 4 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Код налогового органа должен состоять из 4 цифр!'"),
			,
			"НаимОтпр");
			
			Статус = Ложь;
		
	КонецЕсли;
	
	Если (ОтправительЯвляетсяЮЛ И НЕ ЗначениеЗаполнено(ИННЮЛОтпр)) ИЛИ (НЕ ОтправительЯвляетсяЮЛ И НЕ ЗначениеЗаполнено(ИННФЛОтпр)) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='В карточке организации не заполнен ИНН отправителя!'"),
			,
			,
			"НаимОтпр");
			
			Статус = Ложь;
		
	КонецЕсли; 
	
	Если ПрПодп1 = 3 Тогда
		Если НЕ ЗначениеЗаполнено(НаимДовПодп1) ИЛИ НЕ ЗначениеЗаполнено(НомерДовПодп1) ИЛИ НЕ ЗначениеЗаполнено(ДатаДовПодп1) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнены сведения о доверенности подписанта!'"));
			
			Статус = Ложь;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(ФамилияПодп1) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнена фамилия подписанта!'"));
			
			Статус = Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяПодп1) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Не заполнено имя подписанта!'"));
			
			Статус = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	
	НомерСтроки = 0;
	Для каждого Строка Из ДокументыПоступления Цикл
		Если ПустаяСтрока(Строка.ВидТранспорта) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Вид транспорта"" не заполнено.'"),
			,
			"ДокументыПоступления[" + НомерСтроки + "].ВидТранспорта");
			
			Статус = Ложь;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Строка.ДатаПринятияНаУчет) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Дата приянитя к учету"" не заполнено.'"),
			,
			"ДокументыПоступления[" + НомерСтроки + "].ДатаПринятияНаУчет");
			
			Статус = Ложь;
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Возврат Статус;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.СтруктураРеквизитов = Неопределено Тогда
		Элементы.СтраницаОтправительДокумента.Видимость = Ложь;
	КонецЕсли;
	
	Если Форма.ОтправительЯвляетсяЮЛ Тогда
		Элементы.ГруппаОтпрЮФ.ТекущаяСтраница = Форма.Элементы.ГруппаОтпрЮФ.ПодчиненныеЭлементы.ГруппаЮЛ;
		Элементы.ГруппаПодписантСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПодписантСтраницы.ПодчиненныеЭлементы.ГруппаПодписантЮЛ;
	Иначе
		Элементы.ГруппаОтпрЮФ.ТекущаяСтраница = Форма.Элементы.ГруппаОтпрЮФ.ПодчиненныеЭлементы.ГруппаФЛ;
		Элементы.ГруппаПодписантСтраницы.ТекущаяСтраница = Форма.Элементы.ГруппаПодписантСтраницы.ПодчиненныеЭлементы.ГруппаПодписантФЛ;
	КонецЕсли;
	
	Элементы.ГруппаСтраницыСведенияОПодписанте.Видимость = Не ЗначениеЗаполнено(Форма.ОтветственноеЛицо);
	Элементы.ГруппаПодписантСтраницы.Видимость = Не ЗначениеЗаполнено(Форма.ОтветственноеЛицо);
	Элементы.ГруппаДоверенность.Видимость  = (Форма.ПрПодп1 = 3);
	
	флОтпрПредст = (Форма.ПрОтпр = 2);
	Форма.Элементы.ОтправительЯвляетсяЮЛ.Доступность = флОтпрПредст;
	
	Если Форма.ИспользоватьДоговорыСПоставщиками Тогда
		Элементы.ГруппаДоговорЗаполнен.Видимость   = ЗначениеЗаполнено(Форма.Договор);
		Элементы.ГруппаДоговорНеЗаполнен.Видимость = Не ЗначениеЗаполнено(Форма.Договор);
	Иначе
		Элементы.ГруппаДоговорЗаполнен.Видимость   = Ложь;
		Элементы.ГруппаДоговорНеЗаполнен.Видимость = Истина;
	КонецЕсли;
	
	Форма.Элементы.КтоИмпортирует.Видимость = НЕ Форма.ИмпортерСовпадаетСОтправителем;
	Форма.Элементы.ГруппаИмпортирует.Видимость = НЕ Форма.ИмпортерСовпадаетСОтправителем;
	Форма.Элементы.ГруппаИННКППИмпортирует.Видимость = НЕ Форма.ИмпортерСовпадаетСОтправителем;
	
	Если Форма.КтоИмпортирует = 0 Тогда
		Форма.КтоИмпортирует = 1;
	КонецЕсли;
	
	Форма.Элементы.ГруппаИмпортируетФЛ.Видимость = Форма.КтоИмпортирует = 2;
	Форма.Элементы.ГруппаИмпортируетЮЛ.Видимость = Форма.КтоИмпортирует = 1;
	Форма.Элементы.ГруппаИННКППИмпортируетФЛ.Видимость = Форма.КтоИмпортирует = 2;
	Форма.Элементы.ГруппаИННКППИмпортируетЮЛ.Видимость = Форма.КтоИмпортирует = 1;
	
	Форма.ИмпортерЯвляетсяЮЛ = ?(Форма.КтоИмпортирует = 1, Истина, Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораВидовТранспорта(СписокЗначений) Экспорт

	СписокЗначений.Очистить();
	СписокЗначений.Добавить("10 - Морской/речной транспорт");
	СписокЗначений.Добавить("20 - Железнодорожный транспорт");
	СписокЗначений.Добавить("30 - Автодорожный транспорт, за исключением транспортных средств, указанных под кодами 31, 32");
	СписокЗначений.Добавить("31 - Состав транспортных средств (тягач с полуприцепом или прицепом)");
	СписокЗначений.Добавить("32 - Состав транспортных средств (тягач с полуприцепом(-ами) или прицепом(-ами))");
	СписокЗначений.Добавить("40 - Воздушный транспорт");
	СписокЗначений.Добавить("50 - Почтовое отправление");
	СписокЗначений.Добавить("71 - Трубопроводный транспорт");
	СписокЗначений.Добавить("72 - Линии электропередачи");
	СписокЗначений.Добавить("80 - Внутренний водный транспорт");
	СписокЗначений.Добавить("90 - Транспортное средство, перемещающееся в качестве товара своим ходом");
	СписокЗначений.Добавить("99 - Прочее");
	
КонецПроцедуры

&НаСервере
Процедура ОтветственноеЛицоПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(ОтветственноеЛицо) Тогда
		
		ИННФЛПодп1      = ОтветственноеЛицо.ФизическоеЛицо.ИНН;
		ДолжностьПодп1  = ОтветственноеЛицо.Должность;
		
		ФИО = ОтветственноеЛицо.ФизическоеЛицо.Наименование;
		
		ФИОподписанта = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИО);
		ФамилияПодп1    = ФИОподписанта.Фамилия;
		ИмяПодп1        = ФИОподписанта.Имя;
		ОтчествоПодп1   = ФИОподписанта.Отчество;
		
		Если ОтветственноеЛицо.ПравоПодписиПоДоверенности Тогда
			ПрПодп1 = 3;
			
			НаимДовПодп1  = ОтветственноеЛицо.ДокументПраваПодписи;
			НомерДовПодп1 = ОтветственноеЛицо.НомерДокументаПраваПодписи;
			ДатаДовПодп1  = ОтветственноеЛицо.ДатаДокументаПраваПодписи;
			
		Иначе
			
			Если ОтправительЯвляетсяЮЛ Тогда
				ПрПодп1 = 2;
			Иначе
				ПрПодп1 = 1;
			КонецЕсли;
			
			НаимДовПодп1  = "";
			НомерДовПодп1 = "";
			ДатаДовПодп1  = "";
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчастникиСделкиТипГражданскоПравовыхОтношенийПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.УчастникиСделки.ТекущиеДанные;
	Если ТекущаяСтрока.ТипГражданскоПравовыхОтношений = ПредопределенноеЗначение("Перечисление.ТипыГражданскоПравовыхОтношений.ПокупательПродавец") Тогда
		ТекущаяСтрока.РольПродавца = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Продавец");
		ТекущаяСтрока.РольПокупателя = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Покупатель");
	ИначеЕсли ТекущаяСтрока.ТипГражданскоПравовыхОтношений = ПредопределенноеЗначение("Перечисление.ТипыГражданскоПравовыхОтношений.КомитентКомиссионер") Тогда
		ТекущаяСтрока.РольПродавца = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Комитент");
		ТекущаяСтрока.РольПокупателя = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Комиссионер");
	ИначеЕсли ТекущаяСтрока.ТипГражданскоПравовыхОтношений = ПредопределенноеЗначение("Перечисление.ТипыГражданскоПравовыхОтношений.ПринципалАгент") Тогда
		ТекущаяСтрока.РольПродавца = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Принципал");
		ТекущаяСтрока.РольПокупателя = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Агент");
	ИначеЕсли ТекущаяСтрока.ТипГражданскоПравовыхОтношений = ПредопределенноеЗначение("Перечисление.ТипыГражданскоПравовыхОтношений.ДоверительПоверенный") Тогда
		ТекущаяСтрока.РольПродавца = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Поверенный");
		ТекущаяСтрока.РольПокупателя = ПредопределенноеЗначение("Перечисление.СубъектыГражданскоПравовыхОтношений.Доверитель");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаимОтпрНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение( , Организация);
	
КонецПроцедуры

#КонецОбласти

