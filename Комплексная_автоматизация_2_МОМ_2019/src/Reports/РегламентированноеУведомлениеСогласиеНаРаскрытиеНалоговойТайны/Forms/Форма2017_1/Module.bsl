
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

	РазделительНомераСтроки = "___";
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2017_1");
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
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
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = Заголовок + " (" + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "НаименованиеСокращенное") + ")";
	РучнойВвод = Ложь;
	
	ЦФБ = Новый Цвет(255, 255, 255);
	ЦФЖ = Новый Цвет(255, 255, 192);
	ДоступностьТекстСвед(ЭтотОбъект);
	
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
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьТекстСвед(Форма)
	Если Форма.ТекущееИДНаименования <> "Лист002" Тогда 
		Возврат;
	КонецЕсли;
	
	ЕстьКод1400 = Ложь;
	Инд = 0;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Обл = Форма.ПредставлениеУведомления.Области.Найти("КодСвед___" + Инд);
		Если Обл = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		Если Обл.Значение = "1400" Тогда 
			ЕстьКод1400 = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Обл = Форма.ПредставлениеУведомления.Области.Найти("ТекстСвед");
	Если ЕстьКод1400 Тогда 
		Обл.Защита = Ложь;
		Обл.ЦветФона = Форма.ЦФЖ;
	Иначе
		Обл.Защита = Истина;
		Обл.ЦветФона = Форма.ЦФБ;
		Обл.Значение = "";
	КонецЕсли;
	
	Форма.ДанныеУведомления["Лист002"]["ТекстСвед"] = Обл.Значение;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачальныеДанные() Экспорт
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации,ФамилияРук,ИмяРук,ОтчествоРук";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.ФИО);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "4");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	ИначеЕсли РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
		Объект.ПодписантФамилия = СокрЛП(СведенияОбОрганизации.ФамилияРук);
		Объект.ПодписантИмя = СокрЛП(СведенияОбОрганизации.ИмяРук);
		Объект.ПодписантОтчество = СокрЛП(СведенияОбОрганизации.ОтчествоРук);
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
	Иначе
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
		ДанныеУведомленияТитульный.Вставить("НаимОрг", "");
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
	Стр001.МакетыПФ = "Печать_Форма2017_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Коды сведений";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист002";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист002";
	Стр001.МногострочныеЧасти.Добавить("МнгСтр");
	Стр001.МакетыПФ = "Печать_Форма2017_1_Лист002";
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
			ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, ПолучитьМногострочныеЧасти(Элемент.ТекущиеДанные), ПредУИД);
		Иначе 
			ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета, Элемент.ТекущиеДанные.МногострочныеЧасти, ПредУИД);
		КонецЕсли;
		ДоступностьТекстСвед(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяВыводимогоМакета(ТекущиеДанные)
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяМакета) Тогда 
		Возврат ТекущиеДанные.ИмяМакета;
	Иначе
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].ИмяМакета;
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция ПолучитьМногострочныеЧасти(ТекущиеДанные)
	Если ТекущиеДанные.МногострочныеЧасти.Количество() > 0 Тогда 
		Возврат ТекущиеДанные.МногострочныеЧасти;
	ИначеЕсли ТекущиеДанные.ПолучитьЭлементы().Количество() > 0 Тогда 
		Возврат ТекущиеДанные.ПолучитьЭлементы()[0].МногострочныеЧасти;
	Иначе
		Возврат ТекущиеДанные.МногострочныеЧасти;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД)
	Для Каждого МнгЧ Из ТекущиеМногострочныеЧасти Цикл 
		СЗ = ДанныеДопСтрокСтраницы[МнгЧ.Значение];
		Для Инд = 1 По СЗ.Количество() Цикл 
			ИндСтр = РазделительНомераСтроки + Формат(Инд, "ЧГ=0");
			ДанныеСтроки = СЗ[Инд-1].Значение;
			Для Каждого КЗ Из ДанныеСтроки Цикл 
				ДанныеСтроки[КЗ.Ключ] = ПредставлениеУведомления.Области[КЗ.Ключ + ИндСтр].Значение;
			КонецЦикла;
		КонецЦикла;
		
		ВсеДопСтроки = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгЧ.Значение]);
		СтрокиТекущейСтраницы = ВсеДопСтроки.НайтиСтроки(Новый Структура("УИД", ПредУИД));
		Для Инд = 0 По СтрокиТекущейСтраницы.Количество() - СЗ.Количество() - 1 Цикл 
			ВсеДопСтроки.Удалить(СтрокиТекущейСтраницы[Инд]);
		КонецЦикла;
		
		Для Инд = СтрокиТекущейСтраницы.Количество() + 1 По СЗ.Количество() Цикл 
			НовСтр = ВсеДопСтроки.Добавить();
			НовСтр.УИД = ПредУИД;
		КонецЦикла;
		
		СтрокиТекущейСтраницы = ВсеДопСтроки.НайтиСтроки(Новый Структура("УИД", ПредУИД));
		Для Инд = 0 По СтрокиТекущейСтраницы.ВГраница() Цикл 
			ЗаполнитьЗначенияСвойств(СтрокиТекущейСтраницы[Инд], СЗ[Инд].Значение);
		КонецЦикла;
		
		ДанныеДопСтрок[МнгЧ.Значение] = ПоместитьВоВременноеХранилище(ВсеДопСтроки, ДанныеДопСтрок[МнгЧ.Значение]);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти)
	Если ТипЗнч(МногострочныеЧасти) = Тип("СписокЗначений") 
		И МногострочныеЧасти.Количество() > 0 Тогда 
		
		Для Каждого МнгСтр Из МногострочныеЧасти Цикл 
			ТЗ = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгСтр.Значение]);
			ИсхСтр = ОбщегоНазначения.СкопироватьРекурсивно(ДанныеДопСтрокСтраницы[МнгСтр.Значение][0].Значение);
			Для Каждого КЗ Из ИсхСтр Цикл 
				ИсхСтр[Кз.Ключ] = Неопределено;
			КонецЦикла;
			
			Строки = ТЗ.НайтиСтроки(Новый Структура("УИД", УИДТекущаяСтраница));
			ДанныеДопСтрокСтраницы[МнгСтр.Значение].Очистить();
			Инд = 0;
			Пока ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() < Строки.Количество() Цикл 
				ТекСтр = ОбщегоНазначения.СкопироватьРекурсивно(ИсхСтр);
				ЗаполнитьЗначенияСвойств(ТекСтр, Строки[Инд]);
				ДанныеДопСтрокСтраницы[МнгСтр.Значение].Добавить(ТекСтр);
				Инд = Инд + 1;
			КонецЦикла;
			
			Если ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() = 0 Тогда 
				ДанныеДопСтрокСтраницы[МнгСтр.Значение].Добавить(ИсхСтр);
			КонецЕсли;
			
			ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Header_" + МнгСтр.Значение));
			Инд = 0;
			ВыводитьЗначокУдаления = ДанныеДопСтрокСтраницы[МнгСтр.Значение].Количество() > 1;
			Для Каждого Стр Из ДанныеДопСтрокСтраницы[МнгСтр.Значение] Цикл
				Инд = Инд + 1;
				ИндСтр = РазделительНомераСтроки + Формат(Инд, "ЧГ=");
				Обл = Макет.ПолучитьОбласть("Str_" + МнгСтр.Значение);
				Для Каждого ОблПодч Из Обл.Области Цикл 
					Если ОблПодч.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
						Если ОблПодч.СодержитЗначение Тогда 
							Стр.Значение.Свойство(ОблПодч.Имя, ОблПодч.Значение);
						КонецЕсли;
						ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
					КонецЕсли;
					
					Если ВыводитьЗначокУдаления И ОблПодч.Имя = "Del_" + МнгСтр.Значение + ИндСтр Тогда 
						ОблПодч.Текст = "х";
						ОблПодч.Гиперссылка = Истина;
					КонецЕсли;
				КонецЦикла;
				ПредставлениеУведомления.Вывести(Обл);
			КонецЦикла;
			ПредставлениеУведомления.Области["Str_" + МнгСтр.Значение].Имя = "";
			
			ОблДобавленияСтроки = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("ОбщиеЭлементы").ПолучитьОбласть("AddStrArea");
			ОблДобавленияСтроки.Области["AddStrLabel"].Имя = "AddStrLabel_" + МнгСтр.Значение;
			ОблДобавленияСтроки.Области["AddStr"].Имя = "AddStr_" + МнгСтр.Значение;
			ПредставлениеУведомления.Вывести(ОблДобавленияСтроки);
			ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Footer_" + МнгСтр.Значение));
		КонецЦикла;
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

&НаСервере
Процедура ПоказатьТекущуюМногостраничнуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("УправлениеСтраницами"));
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	УведомлениеОСпецрежимахНалогообложения.УстановитьФорматыВПолях(ЭтотОбъект);
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
		ПредставлениеУведомления.Области.УдалитьСтраницуЗначок.Гиперссылка = Ложь;
	КонецЕсли;
	
	ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти);
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета, МногострочныеЧасти, ПредУИД)
	Если Не УдалениеСтраницы И ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(МногострочныеЧасти, ПредУИД);
	КонецЕсли;
	
	ТекущиеМногострочныеЧасти = ОбщегоНазначения.СкопироватьРекурсивно(МногострочныеЧасти);
	
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
	
	ПоказатьМногострочныеЧасти(Макет, МногострочныеЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область, Истина);
	ДоступностьТекстСвед(ЭтотОбъект);
	
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
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "4";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		Иначе
			ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		КонецЕсли;
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
	
	Если ТекущиеМногострочныеЧасти.Количество() > 0 Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы(ТекущиеМногострочныеЧасти, УИДТекущаяСтраница);
	КонецЕсли;
	
	ДанныеДопСтрокБД = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрок Цикл 
		ДанныеДопСтрокБД.Вставить(КЗ.Ключ, ПолучитьИзВременногоХранилища(КЗ.Значение));
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеДопСтрокБД);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеМногостраничныхРазделов", ДанныеМногостраничныхРазделов);
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
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
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	
	ДанныеДопСтрокБД = СтруктураПараметров.ДанныеДопСтрокБД;
	ДанныеДопСтрок = Новый Структура;
	ДанныеДопСтрокСтраницы = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрокБД Цикл 
		ДанныеДопСтрок.Вставить(КЗ.Ключ, ПоместитьВоВременноеХранилище(КЗ.Значение, Новый УникальныйИдентификатор));
		Стр = Новый Структура;
		Для Каждого Кол Из КЗ.Значение.Колонки Цикл 
			Если Кол.Имя <> "УИД" Тогда 
				Стр.Вставить(Кол.Имя);
			КонецЕсли;
		КонецЦикла;
		СЗ = Новый СписокЗначений;
		СЗ.Добавить(Стр);
		ДанныеДопСтрокСтраницы.Вставить(КЗ.Ключ, СЗ);
	КонецЦикла;
	
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрНачинаетсяС(Область.Имя, "AddStr_") Или СтрНачинаетсяС(Область.Имя, "AddStrLabel_") Тогда
		ДобавитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрНачинаетсяС(Область.Имя, "Del_") И Область.Гиперссылка = Истина Тогда
		УдалитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
			
	Если СтандартнаяОбработка Тогда 
		ОО = Новый ОписаниеОповещения("ПредставлениеУведомленияВыборЗавершение", ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка, Ложь, Истина, ОО);
	КонецЕсли;
	
	Если СтандартнаяОбработка И Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
		Возврат;
	ИначеЕсли Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыборЗавершение(Результат, Параметры) Экспорт 
	ДоступностьТекстСвед(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтроку(ИмяОбласти)
	ИмяОбласти = СтрЗаменить(ИмяОбласти, "AddStr_", "");
	ИмяОбласти = СтрЗаменить(ИмяОбласти, "AddStrLabel_", "");
	
	ДопСтрокиТекущейСтраницы = ДанныеДопСтрокСтраницы[ИмяОбласти];
	НомерДобавляемойСтроки = ДопСтрокиТекущейСтраницы.Количество() + 1;
	НоваяСтрока = ОбщегоНазначения.СкопироватьРекурсивно(ДанныеДопСтрокСтраницы[ИмяОбласти][0].Значение);
	Для Каждого КЗ Из НоваяСтрока Цикл 
		НоваяСтрока[КЗ.Ключ] = Неопределено;
	КонецЦикла;
	ДопСтрокиТекущейСтраницы.Добавить(НоваяСтрока);
	Верх = ПредставлениеУведомления.Области[КЗ.Ключ + РазделительНомераСтроки + Формат(НомерДобавляемойСтроки - 1, "ЧГ=0")].Верх + 1;
	Обл = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ТекущийМакет).ПолучитьОбласть("Str_" + ИмяОбласти);
	ИндСтр = РазделительНомераСтроки + Формат(НомерДобавляемойСтроки, "ЧГ=0");
	Для Каждого ОблПодч Из Обл.Области Цикл 
		Если ОблПодч.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
			ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
		КонецЕсли;
	КонецЦикла;
	ПредставлениеУведомления.ВставитьОбласть(Обл.Область(), ПредставлениеУведомления.Область(Верх,,Верх,), ТипСмещенияТабличногоДокумента.ПоВертикали);
	ПредставлениеУведомления.Области["Str_" + ИмяОбласти].Имя = "";
	Для Инд = 1 По НомерДобавляемойСтроки Цикл 
		ОблПодч = ПредставлениеУведомления.Области["Del_" + ИмяОбласти + РазделительНомераСтроки + Формат(Инд, "ЧГ=0")];
		ОблПодч.Текст = "х";
		ОблПодч.Гиперссылка = Истина;
	КонецЦикла;
	
	Для Каждого КЗ Из ДопСтрокиТекущейСтраницы[НомерДобавляемойСтроки-1].Значение Цикл 
		Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Области.Найти(КЗ.Ключ + РазделительНомераСтроки + Формат(НомерДобавляемойСтроки, "ЧГ="));
		Прервать;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтроку(ИмяОбласти)
	ОТЧ = Новый ОписаниеТипов("Число");
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(ИмяОбласти, "Del_", ""), РазделительНомераСтроки);
	ДопСтроки = Разложение[0];
	Номер = ОТЧ.ПривестиЗначение(Разложение[1]);
	ДанныеДопСтрокСтраницы[ДопСтроки].Удалить(Номер-1);
	Верх = ПредставлениеУведомления.Области[ИмяОбласти].Верх;
	ПредставлениеУведомления.УдалитьОбласть(ПредставлениеУведомления.Область(Верх,,Верх), ТипСмещенияТабличногоДокумента.ПоВертикали);
	Низ = Верх + ДанныеДопСтрокСтраницы[ДопСтроки].Количество() - Номер;
	
	Если Низ >= Верх Тогда 
		Области = ПредставлениеУведомления.ПолучитьОбласть(Верх,,Низ).Области;
		СоответствиеИмен = Новый Соответствие;
		Для Каждого Обл Из Области Цикл 
			Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
				П = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Обл.Имя, РазделительНомераСтроки);
				Если П.Количество() = 2 Тогда 
					СоответствиеИмен[Обл.Имя] = П[0] + РазделительНомераСтроки + Формат(ОТЧ.ПривестиЗначение(П[1]) - 1, "ЧГ=0");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Пока Истина Цикл 
			Если СоответствиеИмен.Количество() = 0 Тогда 
				Прервать;
			КонецЕсли;
			
			Для Каждого КЗ Из СоответствиеИмен Цикл 
				Если СоответствиеИмен[КЗ.Значение] <> Неопределено Тогда 
					Продолжить;
				КонецЕсли;
				
				ПредставлениеУведомления.Области[КЗ.Ключ].Имя = КЗ.Значение;
				СоответствиеИмен.Удалить(КЗ.Ключ);
				Прервать;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если ДанныеДопСтрокСтраницы[ДопСтроки].Количество() = 1 Тогда
		ОблПодч = ПредставлениеУведомления.Области["Del_" + Разложение[0] + РазделительНомераСтроки + "1"];
		ОблПодч.Текст = "";
		ОблПодч.Гиперссылка = Ложь;
	КонецЕсли;
	ДоступностьТекстСвед(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ОбластьИмя) Экспорт 
КонецФункции

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
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Нет Тогда
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
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
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
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2017_1"),
			"1110058_5.01000_01.tif");
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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
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
Функция ТаблицаЗаменИменМногострочныхЧастей()
	Замены = Новый Соответствие;
	Замены.Вставить("МнгСтр", "Лист002");
	Возврат Замены;
КонецФункции

&НаСервере
Процедура ЗагрузитьИзXMLНаСервере(ПараметрыЗагрузкиXML)
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТаблицаОсобыхПолейВВыгрузке", УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПутейВВыгрузке());
	ДополнительныеПараметры.Вставить("ЗаменыИменМногострочныхЧастей", ТаблицаЗаменИменМногострочныхЧастей());
	
	ДеревоЗагрузки = УведомлениеОСпецрежимахНалогообложения.СформироватьДеревоЗагрузки(ПараметрыЗагрузкиXML.ПредставлениеXML);
	СхемаВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2017_1");
	УведомлениеОСпецрежимахНалогообложения.УстановитьОрганизациюПоПараметрамЗагрузки(ЭтотОбъект, ПараметрыЗагрузкиXML);
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	СформироватьДеревоСтраниц();
	УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.ЗагрузитьОбычныеСтраницы(ЭтотОбъект, ДеревоЗагрузки, СхемаВыгрузки, ДополнительныеПараметры);
	Если Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда 
		ДанныеУведомления.Титульная.Наименование = УведомлениеОСпецрежимахНалогообложения.ПолучитьНаименованиеИПИзВыгрузки(ДеревоЗагрузки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайлаВФормуУведомление(Команда)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ЗагрузитьИзФайлаУведомление(ЭтотОбъект);
КонецПроцедуры