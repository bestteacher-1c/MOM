&НаКлиенте
Перем ОписаниеОповещенияОЗавершенииЗагрузки Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеПорядокУплатыПрибыль;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2019_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления);
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	ИначеЕсли Параметры.Свойство("ПредставлениеXML") Тогда 
		Параметры.Свойство("РегистрацияВНалоговомОргане", Объект.РегистрацияВИФНС);
		Параметры.Свойство("Организация", Объект.Организация);
		ЗагрузитьИзXMLНаСервере(Новый Структура("Организация, РегистрацияВНалоговомОргане, ПредставлениеXML", 
								Объект.Организация, Объект.РегистрацияВИФНС, Параметры.ПредставлениеXML));
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	Если ТекущаяДатаСеанса() < '20200101' Тогда
		Элементы.ОтправитьВКонтролирующийОрган.Видимость = Ложь;
	КонецЕсли;
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = Заголовок + " (" + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "НаименованиеСокращенное") + ")";
	ИдДляСвор = УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект);
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(ИдДляСвор);
	РучнойВвод = Ложь;
	Элементы.ФормаЗагрузитьИзФайлаВФормуУведомление.Видимость = ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииНаСервере();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Очистить(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ОчиститьУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОчисткаОтчета() Экспорт
	Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	ЗаполнитьНачальныеДанные();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации,ФамилияРук,ИмяРук,ОтчествоРук";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
	ДанныеУведомленияТитульный.Вставить("НаимОрг", СведенияОбОрганизации.НаимЮЛПол);
	ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
	ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		Объект.ПодписантФамилия = СведенияОбОрганизации.ФамилияРук;
		Объект.ПодписантИмя = СведенияОбОрганизации.ИмяРук;
		Объект.ПодписантОтчество= СведенияОбОрганизации.ОтчествоРук;
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц() Экспорт
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Уведомление №1";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Уведомление1";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Уведомление1";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Уведомление1";
	
	ОПСвед = Стр001.ПолучитьЭлементы().Добавить();
	ОПСвед.Наименование = "Подразделения";
	ОПСвед.ИндексКартинки = 1;
	ОПСвед.Многостраничность = Истина;
	ОПСвед.Многострочность = Истина;
	
	ОПСвед = ОПСвед.ПолучитьЭлементы().Добавить();
	ОПСвед.Наименование = "Стр. 1";
	ОПСвед.ИндексКартинки = 1;
	ОПСвед.ИмяМакета = "Уведомление1_подр";
	ОПСвед.Многостраничность = Истина;
	ОПСвед.Многострочность = Ложь;
	ОПСвед.УИД = Новый УникальныйИдентификатор;
	ОПСвед.ИДНаименования = "Уведомление1_подр";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Уведомление №2";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Уведомление2";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Уведомление2";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Уведомление2";
	
	ОПСвед = Стр001.ПолучитьЭлементы().Добавить();
	ОПСвед.Наименование = "Подразделения";
	ОПСвед.ИндексКартинки = 1;
	ОПСвед.Многостраничность = Истина;
	ОПСвед.Многострочность = Истина;
	
	ОПСвед = ОПСвед.ПолучитьЭлементы().Добавить();
	ОПСвед.Наименование = "Стр. 1";
	ОПСвед.ИндексКартинки = 1;
	ОПСвед.ИмяМакета = "Уведомление2_подр";
	ОПСвед.Многостраничность = Истина;
	ОПСвед.Многострочность = Ложь;
	ОПСвед.УИД = Новый УникальныйИдентификатор;
	ОПСвед.ИДНаименования = "Уведомление2_подр";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Уведомление №3";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Уведомление3";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Уведомление3";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Уведомление3";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		ПредУИД = УИДТекущаяСтраница;
		
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		Если Элемент.ТекущиеДанные.Многостраничность Тогда 
			ИмяМакета = ПолучитьИмяВыводимогоМакета(Элемент.ТекущиеДанные);
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, ПредУИД);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НайтиСтрокуВДеревоПоУИД(Дерево, UID)
	Для Каждого Элемент Из Дерево Цикл 
		Если Элемент.УИД = UID И Не ПустаяСтрока(Элемент.ИДНаименования) Тогда
			Возврат Элемент;
		КонецЕсли;
	
		НайденныйИД = НайтиСтрокуВДеревоПоУИД(Элемент.ПолучитьЭлементы(), UID);
		Если НайденныйИД <> Неопределено Тогда
			Возврат НайденныйИД;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция ПолучитьИмяВыводимогоМакета(ТекущиеДанные)
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяМакета) Тогда 
		Возврат ТекущиеДанные.ИмяМакета;
	Иначе
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].ИмяМакета;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПредУИД)
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("УправлениеСтраницами"));
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	СтрДанных = Неопределено;
	Для Каждого Элт Из ДанныеМногостраничныхРазделов[ТекущееИДНаименования] Цикл 
		Если Элт.Значение.УИД = УИДТекущаяСтраница Тогда 
			СтрДанных = Элт.Значение;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	НайденнаяСтрока = НайтиСтрокуВДеревоПоУИД(ДеревоСтраниц.ПолучитьЭлементы(), УИДТекущаяСтраница);
	Если НайденнаяСтрока <> Неопределено
		И НайденнаяСтрока.ПолучитьРодителя().ПолучитьЭлементы().Количество() = 1 Тогда 
		
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницу.Текст = "";
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
		ПредставлениеУведомления.Области.УдалитьСтраницу.Гиперссылка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, ПредУИД)
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		СтрокаСведений = "ФамилияРук,ИмяРук,ОтчествоРук";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		Объект.ПодписантФамилия = СведенияОбОрганизации.ФамилияРук;
		Объект.ПодписантИмя = СведенияОбОрганизации.ИмяРук;
		Объект.ПодписантОтчество= СведенияОбОрганизации.ОтчествоРук;
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", "");
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
	Если ЕстьОбласть Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ДанныеМногостраничныхРазделов = СтруктураПараметров.ДанныеМногостраничныхРазделов;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтраницу(Команда)
	ДобавитьСтраницуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.ДобавитьСтраницуУведомления(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСтраницу() Экспорт
	УдалениеСтраницы = Истина;
	УдалитьСтраницуНаСервере();
	УдалениеСтраницы = Ложь;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтраницуНаСервере()
	НовИд = УведомлениеОСпецрежимахНалогообложения.УдалитьСтраницуНаСервере(ЭтотОбъект);
	Если НовИд <> Неопределено Тогда 
		Элементы.ДеревоСтраниц.ТекущаяСтрока = НовИд;
	КонецЕсли;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрЧислоВхождений(Область.Имя, "ДобавитьСтраницу") > 0 Тогда
		ДобавитьСтраницу(Неопределено);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли СтрЧислоВхождений(Область.Имя, "УдалитьСтраницу") > 0 Тогда
		УведомлениеОСпецрежимахНалогообложенияКлиент.УдалитьСтраницу(ЭтотОбъект);
		СтандартнаяОбработка = Ложь;
		Возврат;
	ИначеЕсли
		Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
			
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Истина);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Свойство("Фамилия", Объект.ПодписантФамилия);
		Результат.Свойство("Имя", Объект.ПодписантИмя);
		Результат.Свойство("Отчество", Объект.ПодписантОтчество);
		Представление = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		Область = ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ");
		Область.Значение = Представление;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Если Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УведомлениеОбъект = Объект.Ссылка.ПолучитьОбъект();
		Если УведомлениеОбъект.Заблокирован() Тогда 
			УведомлениеОбъект.Разблокировать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2019_1"),
			"1150082_5.01000_01.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзXML(ПараметрыЗагрузкиXML) Экспорт
	ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML);
	Элементы.ДеревоСтраниц.ТекущаяСтрока = ДеревоСтраниц.ПолучитьЭлементы()[0].ПолучитьИдентификатор();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2019_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТаблицаОсобыхПолейВВыгрузке", УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПутейВВыгрузке());
	ДополнительныеПараметры.Вставить("КартаМногостраничныхРазделов", УведомлениеОСпецрежимахНалогообложения.ПолучитьСтандартнуюКартуМногостраничныхРазделов(ЭтотОбъект));
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМногостраничныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	ОписаниеОповещенияОЗавершенииЗагрузки = Новый ОписаниеОповещения("ЗагрузитьИзФайлаВФормуУведомлениеЗавершение", ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ПолучитьСворачиваемыеЭлементы()
	СворачиваемыеЭлементы = ПоместитьВоВременноеХранилище(УведомлениеОСпецрежимахНалогообложения.ПолучитьИдентификаторыДляСворачивания(ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомлениеЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	ПолучитьСворачиваемыеЭлементы();
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриОткрытии(ЭтотОбъект, Ложь);
КонецПроцедуры
