
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

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
	
	Если НЕ (Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка)) Тогда 
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		КонецЕсли;
	КонецЕсли;
	
	Если Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ОбщегоНазначения.СообщитьПользователю("Сообщение по форме С-09-4 можно создавать только для организаций");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Форма2014_1");
	ПредставлениеСообщения.Вывести(Макет);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗагрузитьДанные();
	Иначе
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗагрузитьМакетыУведомленияПростойФормы(ЭтотОбъект, Объект.ИмяОтчета, "ПараметрыФорма2014_1");
	
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		СохранитьДанные();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПредставлениеСообщенияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеСообщения", "");
		Возврат;
	КонецЕсли;
	
	ОсобаяОбласть = СписокОбластейСОсобойОбработкой.НайтиПоЗначению(Область.Имя);
	Если ОсобаяОбласть = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОсобаяОбласть.Значение = "КОД_НО" Тогда 
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_НО();
	ИначеЕсли ОсобаяОбласть.Значение = "КОД_ПРИНЯТОЕ_РЕШЕНИЕ" Тогда 
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_ПРИНЯТОЕ_РЕШЕНИЕ();
	ИначеЕсли ОсобаяОбласть.Значение = "КОД_ФОРМА_РЕОРГАНИЗАЦИИ" Тогда 
		СтандартнаяОбработка = Ложь;
		НестандартнаяОбработка_КОД_ФОРМА_РЕОРГАНИЗАЦИИ();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеСообщенияПриИзмененииСодержимогоОбласти(Элемент, Область)
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	Модифицированность = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);

КонецПроцедуры

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СохранитьДанные() Экспорт
	
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	Для Каждого Область Из ПредставлениеСообщения.Области Цикл 
		Если Область.СодержитЗначение = Истина Тогда
			СтруктураПараметров.Вставить(Область.Имя, Область.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ПредставлениеСообщения.Области["ДАТА_ПОДПИСИ"].Значение = Объект.ДатаПодписи;
	
	СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации,ОГРН, АдресЭлектроннойПочтыОрганизации";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
	
	СведенияОбОрганизации.Свойство("НаимЮЛПол",							ПредставлениеСообщения.Области["НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ"].Значение);
	СведенияОбОрганизации.Свойство("ИННЮЛ",								ПредставлениеСообщения.Области["ИНН"].Значение);
	СведенияОбОрганизации.Свойство("КППЮЛ",								ПредставлениеСообщения.Области["КПП"].Значение);
	СведенияОбОрганизации.Свойство("ОГРН",								ПредставлениеСообщения.Области["ОГРН"].Значение);
	СведенияОбОрганизации.Свойство("ТелОрганизации",					ПредставлениеСообщения.Области["ТЕЛЕФОН"].Значение);
	СведенияОбОрганизации.Свойство("АдресЭлектроннойПочтыОрганизации",	ПредставлениеСообщения.Области["EMAIL_ПОДПИСАНТА"].Значение);
	
	УстановитьДанныеПоРегистрацииВИФНС();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные()
	ПризнакПодписанта = Объект.ПодписантПризнак;
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	Если ЗначениеЗаполнено(СтруктураПараметров) Тогда 
		Для Каждого КлючИЗначение Из СтруктураПараметров Цикл
			Если ЗначениеЗаполнено(КлючИЗначение.Значение)
				И ПредставлениеСообщения.Области.Найти(КлючИЗначение.Ключ) <> Неопределено Тогда
				ПредставлениеСообщения.Области[КлючИЗначение.Ключ].Значение = КлючИЗначение.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		ПредставлениеСообщения.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ПредставлениеСообщения.Области["ИНН_ПОДПИСАНТА"].Значение = ДанныеПредставителя.ИНН;
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		ПредставлениеСообщения.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		ПредставлениеСообщения.Области["ИНН_ПОДПИСАНТА"].Значение = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
	ПредставлениеСообщения.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ПредставлениеСообщения.Области["ИНН_ПОДПИСАНТА"].Значение = "";
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	
	Организация = Объект.Организация;
	РегистрацияВИФНС = Объект.РегистрацияВИФНС;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеСообщения.Область("КОД_НО").Значение = Реквизиты.Код;
	ПредставлениеСообщения.Область("КПП").Значение = Реквизиты.КПП;
	ПредставлениеСообщения.Области["EMAIL_ПОДПИСАНТА"].Значение = "";
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		ПризнакПодписанта = "4";
		ПредставлениеСообщения.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = ПризнакПодписанта;
		ПредставлениеСообщения.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = Реквизиты.ДокументПредставителя;
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПризнакПодписанта = "3";
		ПредставлениеСообщения.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = ПризнакПодписанта;
		ПредставлениеСообщения.Области["ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_ПРИНЯТОЕ_РЕШЕНИЕ()
	НестандартнаяОбработкаОбработкаСпискаВыбора("КОД_ПРИНЯТОЕ_РЕШЕНИЕ", "Код принятия решения");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_ФОРМА_РЕОРГАНИЗАЦИИ()
	НестандартнаяОбработкаОбработкаСпискаВыбора("КОД_ФОРМА_РЕОРГАНИЗАЦИИ", "Код формы регистрации");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработкаОбработкаСпискаВыбора(ИмяНестандартнойОбласти, НазваниеСписка, Результат = Неопределено, НужноЗаполнятьРезультат = Ложь)
	СтруктураОтбора = Новый Структура("ИмяОсобогоПоля", ИмяНестандартнойОбласти);
	Строки = ТаблицаЗначенийПредопределенныхРеквизитов.НайтиСтроки(СтруктураОтбора);
	ЗагружаемыеКоды.Очистить();
	Для Каждого Строка Из Строки Цикл 
		НоваяСтрока = ЗагружаемыеКоды.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",          НазваниеСписка);
	ПараметрыФормы.Вставить("ТаблицаЗначений",    ЗагружаемыеКоды);
	ПараметрыФормы.Вставить("СтруктураДляПоиска", Новый Структура("Код", ПредставлениеСообщения.Области[ИмяНестандартнойОбласти].Значение));
	
	ДополнительныеПараметры = Новый Структура("ИмяНестандартнойОбласти", ИмяНестандартнойОбласти);
	ОписаниеОповещения = Новый ОписаниеОповещения("НестандартнаяОбработкаОбработкаСпискаВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ФормаВыбораЗначенияИзТаблицы", ПараметрыФормы, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработкаОбработкаСпискаВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	ИмяНестандартнойОбласти = ДополнительныеПараметры.ИмяНестандартнойОбласти;
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПредставлениеСообщения.Области[ИмяНестандартнойОбласти].Значение = РезультатВыбора.Код;
	
	Если ИмяНестандартнойОбласти = "КОД_ПРИНЯТОЕ_РЕШЕНИЕ" И РезультатВыбора.Код = "2" Тогда
		ПредставлениеСообщения.Области["КОД_ФОРМА_РЕОРГАНИЗАЦИИ"].Значение = "";
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_НО()
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Неопределено, "НестандартнаяОбработка_КОД_НОЗавершение");
КонецПроцедуры

&НаКлиенте
Процедура НестандартнаяОбработка_КОД_НОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотр(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПредварительныйПросмотрЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	ИначеЕсли Модифицированность Тогда 
		СохранитьДанные();
	КонецЕсли;
	
	МассивПечати = Новый Массив;
	МассивПечати.Добавить(Объект.Ссылка);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.УведомлениеОСпецрежимахНалогообложения",
		"Уведомление", МассивПечати, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредварительныйПросмотрЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		МассивПечати = Новый Массив;
		МассивПечати.Добавить(Объект.Ссылка);
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Документ.УведомлениеОСпецрежимахНалогообложения",
			"Уведомление", МассивПечати, Неопределено);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
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
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2014_1"),
			"1111047_5.02000_02.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

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

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры
