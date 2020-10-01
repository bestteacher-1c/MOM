#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеУменьшениеНалогаККТ.Форма.Форма2018_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2018_1";
	Стр.ОписаниеФормы = "В редакции от 18.03.2019 письмо ФНС России N ММВ-7-3/138@";
	Стр.ДатаНачала = Дата("20180101");
	Стр.ДатаКонца = Дата("20500101");
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2018_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2018_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2018_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2018_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
		Данные.Вставить("ПодписантИмя", Объект.ПодписантИмя);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2018_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция НапечататьЛистБ(Объект, Данные, Листы, ПечатнаяФорма, НомСтр, ИННКПП)
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(ИННКПП.Стр110, "ОбщСумРасхККТ", ПечатнаяФорма.Области);
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("---------------------------", "СумРасхККТПревНал", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧН=000; ЧВН="), "НомСтр", ПечатнаяФорма.Области);
	
	Для Каждого КЗ Из Данные Цикл 
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Или КЗ.Значение = Неопределено Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области, "-");
		КонецЕсли;
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	НомСтр = НомСтр + 1;
	ПечатнаяФорма.Вывести(Отчеты.РегламентированноеУведомлениеУменьшениеНалогаККТ.ПолучитьМакет("Печать_Форма2018_1_ЛистБ"));
КонецФункции

Функция НапечататьЛистТитульный(Объект, Данные, Листы, ПечатнаяФорма, НомСтр, ИННКПП)
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантФамилия, "ПодпФ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантИмя, "ПодпИ", ПечатнаяФорма.Области, "-");
	УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Объект.ПодписантОтчество, "ПодпО", ПечатнаяФорма.Области, "-");
	
	Для Каждого КЗ Из Данные Цикл 
		Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области, "-");
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда
			УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области);
		ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
			УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, ПечатнаяФорма.Области, "-");
		КонецЕсли;
	КонецЦикла;
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	НомСтр = НомСтр + 1;
КонецФункции

Функция СформироватьСписокЛистовФорма2018_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	ИННКПП = Новый Структура();
	ИННКПП.Вставить("ИНН", СтруктураПараметров.ДанныеУведомления.Форма2018_1_Титульная.ИННШапка);
	
	НомСтр = 1;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.Вывести(Отчеты.РегламентированноеУведомлениеУменьшениеНалогаККТ.ПолучитьМакет("Печать_Форма2018_1_Титульная"));
	НапечататьЛистТитульный(Объект, СтруктураПараметров.ДанныеУведомления.Форма2018_1_Титульная, Листы, ПечатнаяФорма, НомСтр, ИННКПП);

	ПечатнаяФорма.Вывести(Отчеты.РегламентированноеУведомлениеУменьшениеНалогаККТ.ПолучитьМакет("Печать_Форма2018_1_ЛистА"));
	Индекс = 1;
	Для Каждого Стр Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистА Цикл 
		Если Не ЗначениеЗаполнено(Стр.Значение.МоделККТ) Тогда 
			Продолжить;
		КонецЕсли;
		Постфикс = "_" + Индекс;
		
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ИННКПП.ИНН, "ИННШапка", ПечатнаяФорма.Области, "-");
		УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Формат(НомСтр, "ЧЦ=3; ЧН=000; ЧВН="), "НомСтр", ПечатнаяФорма.Области);
		
		Для Каждого КЗ Из Стр.Значение Цикл 
			Если ТипЗнч(КЗ.Значение) = Тип("Строка") Или КЗ.Значение = Неопределено Тогда 
				УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(КЗ.Значение, КЗ.Ключ + Постфикс, ПечатнаяФорма.Области, "-");
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда
				УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(КЗ.Значение, КЗ.Ключ + Постфикс, ПечатнаяФорма.Области);
			ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
				УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ + Постфикс, ПечатнаяФорма.Области, "-");
			КонецЕсли;
		КонецЦикла;
		
		Если Индекс = 4 Тогда 
			УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
			НомСтр = НомСтр + 1;
			ПечатнаяФорма.Вывести(Отчеты.РегламентированноеУведомлениеУменьшениеНалогаККТ.ПолучитьМакет("Печать_Форма2018_1_ЛистА"));
			Индекс = 1;
		Иначе
			Индекс = Индекс + 1;
		КонецЕсли;
	КонецЦикла;
	
	Если Индекс <> 1 Тогда 
		Пока Индекс <= 4 Цикл
			Постфикс = "_" + Индекс;
			Для Каждого КЗ Из Стр.Значение Цикл 
				Если ТипЗнч(КЗ.Значение) = Тип("Строка") Или КЗ.Значение = Неопределено Тогда 
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать("", КЗ.Ключ + Постфикс, ПечатнаяФорма.Области, "-");
				ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Число") Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(0, КЗ.Ключ + Постфикс, ПечатнаяФорма.Области);
				ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда
					УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(Дата("00010101000000"), КЗ.Ключ + Постфикс, ПечатнаяФорма.Области, "-");
				КонецЕсли;
			КонецЦикла;
			
			Индекс = Индекс + 1;
		КонецЦикла;
		УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
		НомСтр = НомСтр + 1;
	КонецЕсли;
	
	ОТЧ = Новый ОписаниеТипов("Число");
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.Вывести(Отчеты.РегламентированноеУведомлениеУменьшениеНалогаККТ.ПолучитьМакет("Печать_Форма2018_1_ЛистБ"));
	ИННКПП.Вставить("Стр110", ОТЧ.ПривестиЗначение(СтруктураПараметров.ДанныеУведомления.Форма2018_1_ЛистБ_Общая.ОбщСумРасхККТ));
	ИННКПП.Вставить("Стр210", ОТЧ.ПривестиЗначение(СтруктураПараметров.ДанныеУведомления.Форма2018_1_ЛистБ_Общая.СумРасхККТПревНал));
	ЛистБНапечатан = Ложь;
	Для Каждого Стр Из СтруктураПараметров.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистБ Цикл 
		Если Не ЗначениеЗаполнено(Стр.Значение.НомерПат) Или Не ЗначениеЗаполнено(Стр.Значение.ДатаВыдПат) Тогда 
			Продолжить;
		КонецЕсли;
		НапечататьЛистБ(Объект, Стр.Значение, Листы, ПечатнаяФорма, НомСтр, ИННКПП);
		ЛистБНапечатан = Истина;
	КонецЦикла;
	
	Если ЛистБНапечатан Тогда
		ТД = ПолучитьИзВременногоХранилища(Листы[Листы.Количество()-1].Значение[0]);
		УведомлениеОСпецрежимахНалогообложения.ВывестиЧислоСПрочеркамиНаПечать(ИННКПП.Стр210, "СумРасхККТПревНал", ТД.Области);
		Листы[Листы.Количество()-1].Значение[0] = ПоместитьВоВременноеХранилище(ТД);
	КонецЕсли;
	Возврат Листы;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(СведенияОтправки)
	Префикс = "IU_UVUMNALKKT";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2018_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульная = Данные.ДанныеУведомления.Форма2018_1_Титульная;
	Если Не ЗначениеЗаполнено(Титульная.Фамилия) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана фамилия", "Форма2018_1_Титульная", "Фамилия"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.Имя) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указанао имя", "Форма2018_1_Титульная", "Имя"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПрПодп) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак подписанта", "Форма2018_1_Титульная", "ПрПодп"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.НаимДок) И Титульная.ПрПодп = "2" Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан документ (обязателен при подаче представителем)", "Форма2018_1_Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ) И Титульная.ПрПодп = "2" Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан представитель", "Форма2018_1_Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если ЗначениеЗаполнено(Титульная.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ)
		И (Не ЗначениеЗаполнено(Данные.ПодписантФамилия) Или Не ЗначениеЗаполнено(Данные.ПодписантИмя))Тогда 
		
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указаны фамилия/имя представителя", "Форма2018_1_Титульная", "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Форма2018_1_Титульная", "КодНО"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.КодНО)) <> 4 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульная.КодНО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан налоговый орган", "Форма2018_1_Титульная", "ИННШапка"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ИННШапка) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН", "Форма2018_1_Титульная", "ИННШапка"));
	ИначеЕсли СтрДлина(СокрЛП(Титульная.ИННШапка)) <> 12 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульная.ИННШапка) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Форма2018_1_Титульная", "ИННШапка"));
	КонецЕсли;
	
	Для Каждого Стр Из Данные.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистА Цикл 
		СтрЗначение = Стр.Значение;
		
		Если Не ЗначениеЗаполнено(СтрЗначение.МоделККТ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указано наименование модели контрольно-кассовой техники", "Форма2018_1_ЛистА", "МоделККТ", СтрЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗначение.НомерККТ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан заводской номер экземпляра модели контрольно-кассовой техники", "Форма2018_1_ЛистА", "НомерККТ", СтрЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗначение.РегНомерККТ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан регистрационный номер контрольно-кассовой техники", "Форма2018_1_ЛистА", "РегНомерККТ", СтрЗначение.УИД));
		ИначеЕсли СтрДлина(СокрЛП(СтрЗначение.РегНомерККТ)) <> 16 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан регистрационный номер контрольно-кассовой техники", "Форма2018_1_ЛистА", "РегНомерККТ", СтрЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗначение.ДатаРегККТ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата регистрации контрольно-кассовой техники в налоговом органе", "Форма2018_1_ЛистА", "ДатаРегККТ", СтрЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗначение.СумРасхККТ) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана сумма расходов", "Форма2018_1_ЛистА", "СумРасхККТ", СтрЗначение.УИД));
		ИначеЕсли СтрЗначение.СумРасхККТ > 18000 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Сумма расходов не должна превышать 18000 рублей", "Форма2018_1_ЛистА", "СумРасхККТ", СтрЗначение.УИД));
		КонецЕсли;
	КонецЦикла;
	
	ОбщиеДанныеЛистБ = Данные.ДанныеУведомления.Форма2018_1_ЛистБ_Общая;
	Если Не ЗначениеЗаполнено(ОбщиеДанныеЛистБ.ОбщСумРасхККТ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана общая сумма расходов", "Форма2018_1_ЛистБ_Общая", "ОбщСумРасхККТ"));
	КонецЕсли;
	
	Для Каждого Стр Из Данные.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистБ Цикл 
		СтрЗначение = Стр.Значение;
		
		Если Не ЗначениеЗаполнено(СтрЗначение.НомерПат) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан номер патента", "Форма2018_1_ЛистБ", "НомерПат", СтрЗначение.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрЗначение.ДатаВыдПат) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата выдачи патента", "Форма2018_1_ЛистБ", "ДатаВыдПат", СтрЗначение.УИД));
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетностьПереопределяемый.КраткоеНазваниеПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить().ДанныеУведомления;
	Титульная = ДанныеУведомления.Форма2018_1_Титульная;
	ОсновныеСведения.Вставить("КодНО", Титульная.КодНО);
	ОсновныеСведения.Вставить("ПрПодп", Титульная.ПрПодп);
	ОсновныеСведения.Вставить("ТлфПодп", Титульная.Тлф);
	ОсновныеСведения.Вставить("ИННТитул", Титульная.ИННШапка);
	ОсновныеСведения.Вставить("ИННФЛ", Титульная.ИННШапка);
	ОсновныеСведения.Вставить("НаимДок",Титульная.НаимДок);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2018_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2018_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	ДанныеУведомления.Вставить("ПодписантФамилия", Объект.ПодписантФамилия);
	ДанныеУведомления.Вставить("ПодписантИмя", Объект.ПодписантИмя);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2018_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2018_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2018_1");
	ЗаполнитьДанными_Форма2018_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ДополнитьПараметры(Параметры)
	Для Каждого Стр Из Параметры.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистА Цикл
		ПарамСтр = Стр.Значение;
		ПарамСтр.Вставить("ДатаРегККТСтр", Формат(ПарамСтр.ДатаРегККТ, "ДФ=dd.MM.yyyy"));
	КонецЦикла;
	Для Каждого Стр Из Параметры.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистБ Цикл
		ПарамСтр = Стр.Значение;
		ПарамСтр.Вставить("ДатаВыдПатСтр", Формат(ПарамСтр.ДатаВыдПат, "ДФ=dd.MM.yyyy"));
		ПарамСтр.Вставить("ПерСрУплНалСтр", Формат(ПарамСтр.ПерСрУплНал, "ДФ=dd.MM.yyyy"));
		ПарамСтр.Вставить("ВтСрУплНалСтр", Формат(ПарамСтр.ВтСрУплНал, "ДФ=dd.MM.yyyy"));
		ПарамСтр.Вставить("ТрСрУплНалСтр", Формат(ПарамСтр.ТрСрУплНал, "ДФ=dd.MM.yyyy"));
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДанными_Форма2018_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзелНов(ДанныеУведомления, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(ДеревоВыгрузки);
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Узел, ПараметрыТекущейСтраницы = Неопределено, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если Стр.Тип = "А" Или Стр.Тип = "A" Или Стр.Тип = "П" Тогда
			Если ЗначениеЗаполнено(Стр.Ключ) Тогда
				ЗначениеПоказателя = Неопределено;
				Если ПараметрыТекущейСтраницы <> Неопределено И ПараметрыТекущейСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				ИначеЕсли ПараметрыТекущейСтраницы = Неопределено 
					И ЗначениеЗаполнено(Стр.Раздел)
					И ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Раздел, ЗначениеПоказателя) Тогда 
					Если ЗначениеПоказателя.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда
						РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда
				
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						Если УИДРодителя = Неопределено Или СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, НовУзел, СтрМнгч.Значение, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиУзелНов(ПараметрыВыгрузки, Стр, ПараметрыТекущейСтраницы, УИДРодителя)
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#Область Интеграция

Функция ПолучитьСписокПечатныхЛистовУведомления(Ссылка) Экспорт 
	Результат = Новый СписокЗначений;
	Для Каждого Лист Из СформироватьСписокЛистовФорма2018_1(Ссылка) Цикл 
		Результат.Добавить(ПолучитьИзВременногоХранилища(Лист.Значение[0]), Лист.Представление);
	КонецЦикла;
	Возврат Результат;
КонецФункции

Функция ДанныеПоследнегоУведомления(Организация, НалоговыйОрган) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("РегистрацияВИФНС", НалоговыйОрган);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	УведомлениеОСпецрежимахНалогообложения.Ссылка КАК Ссылка,
	|	УведомлениеОСпецрежимахНалогообложения.Дата КАК Дата
	|ИЗ
	|	Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
	|ГДЕ
	|	НЕ УведомлениеОСпецрежимахНалогообложения.ПометкаУдаления
	|	И УведомлениеОСпецрежимахНалогообложения.Организация = &Организация
	|	И УведомлениеОСпецрежимахНалогообложения.РегистрацияВИФНС = &РегистрацияВИФНС
	|	И УведомлениеОСпецрежимахНалогообложения.ВидУведомления = ЗНАЧЕНИЕ(Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУменьшениеНалогаККТ)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат ДанныеУведомления(Выборка.Ссылка);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ДанныеУведомления(Ссылка)
	ДанныеИБ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ДанныеУведомления,Организация,РегистрацияВИФНС,Дата");
	СтруктураПараметров = ДанныеИБ.ДанныеУведомления.Получить();
	
	ТаблицаБ = Новый ТаблицаЗначений;
	ТаблицаБ.Колонки.Добавить("Стр120");
	ТаблицаБ.Колонки.Добавить("Стр130");
	ТаблицаБ.Колонки.Добавить("Стр140");
	ТаблицаБ.Колонки.Добавить("Стр150");
	ТаблицаБ.Колонки.Добавить("Стр160");
	ТаблицаБ.Колонки.Добавить("Стр170");
	ТаблицаБ.Колонки.Добавить("Стр180");
	ТаблицаБ.Колонки.Добавить("Стр190");
	ТаблицаБ.Колонки.Добавить("Стр200");
	
	ЛистыБ = СтруктураПараметров.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистБ;
	ОписаниеТипаЧисло = Новый ОписаниеТипов("Число");
	ОписаниеТипаДата = Новый ОписаниеТипов("Дата", , , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	Для Каждого ЛистБ Из ЛистыБ Цикл
		Если ЗначениеЗаполнено(ЛистБ.Значение.НомерПат) И ЗначениеЗаполнено(ЛистБ.Значение.ДатаВыдПат) Тогда 
			НовСтр = ТаблицаБ.Добавить();
			НовСтр.Стр120 = ЛистБ.Значение.НомерПат;
			НовСтр.Стр130 = ЛистБ.Значение.ДатаВыдПат;
			НовСтр.Стр140 = ОписаниеТипаЧисло.ПривестиЗначение(ЛистБ.Значение.СумПерСрНалУм);
			НовСтр.Стр150 = ОписаниеТипаДата.ПривестиЗначение(ЛистБ.Значение.ПерСрУплНал);
			НовСтр.Стр160 = ОписаниеТипаЧисло.ПривестиЗначение(ЛистБ.Значение.СумРасхККТПерУмНал);
			НовСтр.Стр170 = ОписаниеТипаДата.ПривестиЗначение(ЛистБ.Значение.ВтСрУплНал);
			НовСтр.Стр180 = ОписаниеТипаЧисло.ПривестиЗначение(ЛистБ.Значение.СумВтСрНалУм);
			НовСтр.Стр190 = ОписаниеТипаДата.ПривестиЗначение(ЛистБ.Значение.ТрСрУплНал);
			НовСтр.Стр200 = ОписаниеТипаЧисло.ПривестиЗначение(ЛистБ.Значение.СумРасхККТВтУмНал);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаА = Новый ТаблицаЗначений;
	ТаблицаА.Колонки.Добавить("МоделККТ");
	ТаблицаА.Колонки.Добавить("НомерККТ");
	ТаблицаА.Колонки.Добавить("РегНомерККТ");
	ТаблицаА.Колонки.Добавить("ДатаРегККТ");
	ТаблицаА.Колонки.Добавить("СумРасхККТ");
	
	ЛистыА = СтруктураПараметров.ДанныеМногостраничныхРазделов.Форма2018_1_ЛистА;
	Для Каждого ЛистА Из ЛистыА Цикл 
		Если ЗначениеЗаполнено(ЛистА.Значение.МоделККТ) И ЗначениеЗаполнено(ЛистА.Значение.НомерККТ)
			И ЗначениеЗаполнено(ЛистА.Значение.РегНомерККТ) И ЗначениеЗаполнено(ЛистА.Значение.ДатаРегККТ) Тогда 
			
			НовСтр = ТаблицаА.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ЛистА.Значение);
			НовСтр.СумРасхККТ = ОписаниеТипаЧисло.ПривестиЗначение(ЛистА.Значение.СумРасхККТ);
		КонецЕсли;
	КонецЦикла;
	ТаблицаА.Свернуть("МоделККТ,НомерККТ,РегНомерККТ,ДатаРегККТ", "СумРасхККТ");
	
	Результат = Новый Структура;
	Результат.Вставить("Ссылка", Ссылка);
	Результат.Вставить("Дата", ДанныеИБ.Дата);
	Результат.Вставить("ДанныеЛистовБ", ТаблицаБ);
	Результат.Вставить("ДанныеЛистовА", ТаблицаА);
	Результат.Вставить("Организация", ДанныеИБ.Организация);
	Результат.Вставить("РегистрацияВИФНС", ДанныеИБ.РегистрацияВИФНС);
	Результат.Вставить("Стр110", СтруктураПараметров.ДанныеУведомления.Форма2018_1_ЛистБ_Общая.ОбщСумРасхККТ);
	Результат.Вставить("Стр210", СтруктураПараметров.ДанныеУведомления.Форма2018_1_ЛистБ_Общая.СумРасхККТПревНал);
	Возврат Результат;
КонецФункции

Функция СформироватьУведомление(Параметры) Экспорт 
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ПустаяСсылка();
КонецФункции

#КонецОбласти

#КонецОбласти
#КонецЕсли