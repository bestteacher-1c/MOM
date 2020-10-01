#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеЕНВД1.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "ЕНВД-1/приказ ФНС от 11 декабря 2012 г. N ММВ-7-6/941@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ОбластьОграничители = МакетУведомления.ПолучитьОбласть("Ограничители");
	ОбластьПустаяСтрока = МакетУведомления.ПолучитьОбласть("ПустаяСтрока");
	МассивДляПроверки = Новый Массив;
	МассивДляПроверки.Добавить(ОбластьПустаяСтрока);
	МассивДляПроверки.Добавить(ОбластьОграничители);
	
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.ТитульныйЛист[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ИНН, "ИНН1_", ОбластьТитульный.Области, 10);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_КПП, "КПП1_", ОбластьТитульный.Области, 9);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.КОД_НО, "КОД_НО_", ОбластьТитульный.Области, 4);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.КОД_РЕЗИДЕНТА, "КОД_РЕЗИДЕНТА_", ОбластьТитульный.Области, 1);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ОРГАНИЗАЦИЯ, "НаимОрг_", ОбластьТитульный.Области, 160);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ОГРН, "ОГРН_", ОбластьТитульный.Области, 13);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВОбластиМакета(Титульный.ДАТА_ПРИМЕНЕНЕНИ_ЕНВД, "ДАТА_ПРИМЕНЕНЕНИ_ЕНВД_", ОбластьТитульный.Области);	
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "ПРИЛОЖЕНО_СТРАНИЦ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "ПРИЛОЖЕНО_ЛИСТОВ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Титульный.ПРИЛОЖЕНО_СТРАНИЦ, "ПРИЛОЖЕНО_СТРАНИЦ_", ОбластьТитульный.Области, 3);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПРИЛОЖЕНО_ЛИСТОВ_", ОбластьТитульный.Области, 3);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ПРИЗНАК_НП_ПОДВАЛ, "ПРИЗНАК_НП_ПОДВАЛ_", ОбластьТитульный.Области, 1);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ОбластьТитульный.Области, 20);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ИНН_ПРЕДСТАВИТЕЛЯ, "ИНН_ПРЕДСТАВИТЕЛЯ_", ОбластьТитульный.Области, 12);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ТЕЛЕФОН, "Телефон_", ОбластьТитульный.Области, 20);
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокУпПред_", ОбластьТитульный.Области, 40);
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВОбластиМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ОбластьТитульный.Области);
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
	ПечатнаяФорма.Вывести(ОбластьОграничители);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	ОбластьПодвалДопЛист = МакетУведомления.ПолучитьОбласть("ПустаяСтрока");
	МассивДляПроверки[1] = ОбластьПодвалДопЛист;
	
	Страница = 1;
	Для Каждого ДопЛист Из СтруктураПараметров.Лист2 Цикл 
		
		ОбластьДопЛист = МакетУведомления.ПолучитьОбласть("Приложение");
		ОбластиМакета = ОбластьДопЛист.Области;
		Страница = Страница + 1;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_ИНН, "ИНН2_", ОбластиМакета, 10);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(Титульный.П_КПП, "КПП2_", ОбластиМакета, 9);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета("000", "НомСтр1_", ОбластиМакета, 3);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВОбластиМакета(Страница, "НомСтр1_", ОбластиМакета, 3);
		
		Для Инд = 1 по 3 Цикл
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд], "КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд + "_", ОбластиМакета, 2); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["ИНДЕКС" + Инд], "ИНДЕКС" + Инд + "_", ОбластиМакета, 6); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["РЕГИОН" + Инд], "РЕГИОН" + Инд + "_", ОбластиМакета, 2); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["РАЙОН" + Инд], "РАЙОН" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["ГОРОД" + Инд], "ГОРОД" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["НаселенныйПункт" + Инд], "НаселенныйПункт" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Улица" + Инд], "Улица" + Инд + "_", ОбластиМакета, 34); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Дом" + Инд], "Дом" + Инд + "_", ОбластиМакета, 8); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Корпус" + Инд], "Корпус" + Инд + "_", ОбластиМакета, 8); 
			Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВОбластиМакета(ДопЛист["Квартира" + Инд], "Квартира" + Инд + "_", ОбластиМакета, 8); 
		КонецЦикла;
		
		ПечатнаяФорма.Вывести(ОбластьДопЛист);
		
		ПечатнаяФорма.Вывести(ОбластьОграничители);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "UT_ENVD1";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные.ТитульныйЛист[0];
	Ошибок = 0;
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПОДПИСИ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата подписи", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_РЕЗИДЕНТА) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан признак организации", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульный.П_ИНН, Истина, "") Тогда 
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Неправильно заполнен ИНН/КПП на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если (Не ЗначениеЗаполнено(Титульный.П_ОГРН))
		И (Титульный.КОД_РЕЗИДЕНТА = "1")Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен ОГРН на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПРИМЕНЕНЕНИ_ЕНВД) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата начала применения ЕНВД", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_РЕЗИДЕНТА) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан признак на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Страница = 0;
	Заполнено = Ложь;
	Для Каждого ДопЛист Из Данные.Лист2 Цикл
		Страница = Страница + 1;
		
		Для Инд = 1 По 3 Цикл 
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				И (Не ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд])) Тогда
				
					РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан адрес (доп. лист " + Страница + ")", УникальныйИдентификатор);
					Ошибок = Ошибок + 1;
			КонецЕсли;
				
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				Или ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд]) Тогда
				
					Заполнено = Истина;
			КонецЕсли;
		КонецЦикла;
		
		Если Ошибок > 3 Тогда
			ВызватьИсключение "";
		КонецЕсли;
	КонецЦикла;
	
	Если Не Заполнено Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнены сведения о видах деятельности на доп. страницах", УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Ложь);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Титульный = Данные.ТитульныйЛист[0];
	
	ОсновныеСведения.Вставить("ПризнОрг", Титульный.КОД_РЕЗИДЕНТА);
	ОсновныеСведения.Вставить("НаимОрг", Титульный.ОРГАНИЗАЦИЯ);
	ОсновныеСведения.Вставить("ДатаПримЕНВД", Формат(Титульный.ДАТА_ПРИМЕНЕНЕНИ_ЕНВД, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ПрПодп", 	Титульный.ПРИЗНАК_НП_ПОДВАЛ);
	ОсновныеСведения.Вставить("ИННФЛ", 		Титульный.ИНН_ПРЕДСТАВИТЕЛЯ);
	ОсновныеСведения.Вставить("Телефон",	Титульный.ТЕЛЕФОН);
	ОсновныеСведения.Вставить("ОГРН", 		Титульный.П_ОГРН);
	ОсновныеСведения.Вставить("НаимДок", 	Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
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

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Данные = Объект.ДанныеУведомления.Получить();
	ДопЛисты = Данные.Лист2;
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_ЕНВД1 = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "ЕНВД1");
	Узел_СвПредДеят = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ЕНВД1, "СвПредДеят");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанными_ЕНВДх(ДопЛисты, Узел_СвПредДеят);
КонецПроцедуры

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	Титульный = Данные.ТитульныйЛист[0];
	
	Если Не ЗначениеЗаполнено(Титульный.П_ОГРН) И (Титульный.КОД_РЕЗИДЕНТА = "1") Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ОГРН на титульном листе", "ТитульныйЛист", "П_ОГРН", Титульный.UID));
	ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ОГРНСоответствуетТребованиям(Титульный.П_ОГРН, Истина, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ОГРН на титульном листе", "ТитульныйЛист", "П_ОГРН", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН на титульном листе", "ТитульныйЛист", "П_ИНН", Титульный.UID));
	ИначеЕсли Не РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(Титульный.П_ИНН, Истина, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН на титульном листе", "ТитульныйЛист", "П_ИНН", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.П_КПП) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан КПП на титульном листе", "ТитульныйЛист", "П_КПП", Титульный.UID));
	ИначеЕсли Не РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(Титульный.П_КПП, "") Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП на титульном листе", "ТитульныйЛист", "П_КПП", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПОДПИСИ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата подписи", "ТитульныйЛист", "ДАТА_ПОДПИСИ", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ДАТА_ПРИМЕНЕНЕНИ_ЕНВД) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата начала применения ЕНВД", "ТитульныйЛист", "ДАТА_ПРИМЕНЕНЕНИ_ЕНВД", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_РЕЗИДЕНТА) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак на титульном листе", "ТитульныйЛист", "КОД_РЕЗИДЕНТА", Титульный.UID));
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Титульный.ОРГАНИЗАЦИЯ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана организация", "ТитульныйЛист", "ОРГАНИЗАЦИЯ", Титульный.UID));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "ТитульныйЛист", "КОД_НО", Титульный.UID));
	КонецЕсли;
	
	Заполнено = Ложь;
	Для Каждого ДопЛист Из Данные.Лист2 Цикл
		Для Инд = 1 По 3 Цикл 
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				И (Не ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд])) Тогда
				
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан адрес", "Лист2", "РЕГИОН" + Инд, ДопЛист.UID));
			КонецЕсли;
				
			Если ЗначениеЗаполнено(ДопЛист["КОД_ВИДА_ДЕЯТЕЛЬНОСТИ" + Инд])
				Или ЗначениеЗаполнено(ДопЛист["РЕГИОН" + Инд]) Тогда
					Заполнено = Истина;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если Не Заполнено Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не заполнены адреса/виды деятельности", "Лист2", "РЕГИОН1", Данные.Лист2[0].UID));
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли