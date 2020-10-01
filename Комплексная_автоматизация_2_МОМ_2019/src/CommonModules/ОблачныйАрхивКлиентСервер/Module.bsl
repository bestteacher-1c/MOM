///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивКлиентСервер.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработкаСтрок

// Получает текстовое описание структуры расписания.
//
// Параметры:
//  СтруктураРасписания - Структура - структура с ключами, как описано в ХранилищаНастроек.НастройкиОблачногоАрхива
//                          для настройки НастройкиАгентаКопирования.РасписаниеАвтоматическогоРезервногоКопирования;
//  Вариант             - Строка - "Кратко" или "Подробно" (по-умолчанию).
//
// Возвращаемое значение:
//   Строка - Текстовое описание расписания.
//
Функция ПолучитьТекстовоеОписаниеРасписания(СтруктураРасписания, Вариант = "Подробно") Экспорт

	// Никакие проверки на правильность не вызываются, все поля должны присутствовать.

	ТипСтруктура = Тип("Структура");

	Результат = "";

	Если ТипЗнч(СтруктураРасписания) = ТипСтруктура Тогда

		// Обязательные поля:
		//  ** РасписаниеВключено - Булево;
		//  ** Вариант - Строка - "Ежедневно_ОдинРазВДень", "Ежедневно_НесколькоРазВДень", "Еженедельно",
		//               "Ежемесячно_ПоДням", "Ежемесячно_ПоДнямНедели".
		//               Возможно добавление варианта "Однократно" перед остальными вариантами.
		//  ** Ежедневно_ОдинРазВДень:
		//    *** Время (Время);
		//  ** Ежедневно_НесколькоРазВДень:
		//    *** ВремяНачала (Время);
		//    *** ВремяОкончания (Время);
		//    *** КоличествоЧасовПовтора (Число 1..23);
		//  ** Еженедельно:
		//    *** Время (Время);
		//    *** ДниНедели (Массив (числа 1..7));
		//  ** Ежемесячно_ПоДням:
		//    *** Время (Время);
		//    *** ДниМесяца (Массив (числа 1..32));
		//  ** Ежемесячно_ПоДнямНедели:
		//    *** Время (Время);
		//    *** НомерНедели (Число 1..5) (first, second, third, fourth, last);
		//    *** ДниНедели (Массив (числа 1..7)).

		// Расписание вообще включено?
		Если СтруктураРасписания.РасписаниеВключено = Истина Тогда

			// Ежедневно_ОдинРазВДень
			Если СтруктураРасписания.Вариант = "Ежедневно_ОдинРазВДень" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежедневно_ОдинРазВДень;
				Результат =
					Результат
					+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru='#Ежедневно в %1#'"),
						Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат = НРег(Результат);
				КонецЕсли;
			КонецЕсли;

			// Ежедневно_НесколькоРазВДень
			Если СтруктураРасписания.Вариант = "Ежедневно_НесколькоРазВДень" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежедневно_НесколькоРазВДень;
				Если ЭлементСтруктуры.КоличествоЧасовПовтора = 1 Тогда
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#Ежедневно с %1 до %2 каждый час#'"),
							Формат(ЭлементСтруктуры.ВремяНачала, "ДФ=HH:mm"),
							Формат(ЭлементСтруктуры.ВремяОкончания, "ДФ=HH:mm"));
				Иначе
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#Ежедневно с %1 до %2 каждые %3#'"),
							Формат(ЭлементСтруктуры.ВремяНачала, "ДФ=HH:mm"),
							Формат(ЭлементСтруктуры.ВремяОкончания, "ДФ=HH:mm"),
							НРег(
								ЧислоПрописью(
									ЭлементСтруктуры.КоличествоЧасовПовтора,
									"НП=Истина",
									НСтр("ru='час,часа,часов,м,,,,,0'"))));
				КонецЕсли;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат = НРег(Результат);
				КонецЕсли;
			КонецЕсли;

			// Еженедельно
			Если СтруктураРасписания.Вариант = "Еженедельно" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Еженедельно;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#еженедельно в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					СписокДнейНедели = "";
					Для Каждого ТекущийДеньНедели Из ЭлементСтруктуры.ДниНедели Цикл
						СписокДнейНедели = СписокДнейНедели + "#" + ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеДняНедели(ТекущийДеньНедели) + "#";
					КонецЦикла;
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ", ");
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#В %1 по дням недели: %2#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейНедели);
				КонецЕсли;
			КонецЕсли;

			// Ежемесячно_ПоДням
			Если СтруктураРасписания.Вариант = "Ежемесячно_ПоДням" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежемесячно_ПоДням;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#в определенные числа месяца в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					СписокДнейМесяца = "";
					Для Каждого ТекущийДеньМесяца Из ЭлементСтруктуры.ДниМесяца Цикл
						Если (ТекущийДеньМесяца = 32) ИЛИ (ТекущийДеньМесяца = 99) Тогда
							СписокДнейМесяца = СписокДнейМесяца + "#" + НСтр("ru='последний день месяца'") + "#";
						Иначе
							СписокДнейМесяца = СписокДнейМесяца + "#" + ТекущийДеньМесяца + "#";
						КонецЕсли;
					КонецЦикла;
					СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "##", ", ");
					СписокДнейМесяца = СтрЗаменить(СписокДнейМесяца, "#", "");
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#В %1 по числам месяца: %2#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейМесяца);
				КонецЕсли;
			КонецЕсли;

			// Ежемесячно_ПоДнямНедели
			Если СтруктураРасписания.Вариант = "Ежемесячно_ПоДнямНедели" Тогда
				ЭлементСтруктуры = СтруктураРасписания.Ежемесячно_ПоДнямНедели;
				Если ВРег(Вариант) = ВРег("Кратко") Тогда
					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#в определенные дни недель в пределах месяца в %1#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"));
				Иначе // Подробно.
					Если ЭлементСтруктуры.НомерНедели = 1 Тогда
						НомерНеделиСтрокой = НСтр("ru='первой'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 2 Тогда
						НомерНеделиСтрокой = НСтр("ru='второй'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 3 Тогда
						НомерНеделиСтрокой = НСтр("ru='третьей'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 4 Тогда
						НомерНеделиСтрокой = НСтр("ru='четвертой'");
					ИначеЕсли ЭлементСтруктуры.НомерНедели = 5 Тогда
						НомерНеделиСтрокой = НСтр("ru='последней'");
					КонецЕсли;

					СписокДнейНедели = "";
					Для Каждого ТекущийДеньНедели Из ЭлементСтруктуры.ДниНедели Цикл
						СписокДнейНедели = СписокДнейНедели + "#" + ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеДняНедели(ТекущийДеньНедели) + "#";
					КонецЦикла;
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "##", ", ");
					СписокДнейНедели = СтрЗаменить(СписокДнейНедели, "#", "");

					Результат =
						Результат
						+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru='#В %1 по дням недели: %2 каждой %3 недели#'"),
							Формат(ЭлементСтруктуры.Время, "ДФ=HH:mm"),
							СписокДнейНедели,
							НомерНеделиСтрокой);
				КонецЕсли;
			КонецЕсли;

		Иначе

			Если ВРег(Вариант) = ВРег("Кратко") Тогда
				Результат =
					Результат
					+ НСтр("ru='отключено'");
			Иначе // Подробно.
				Результат =
					Результат
					+ НСтр("ru='Выполнение по-расписанию отключено.'");
			КонецЕсли;

		КонецЕсли;

		Результат = СтрЗаменить(Результат, "##", "; ");
		Результат = СтрЗаменить(Результат, "#", "");

	КонецЕсли;

	Возврат Результат;

КонецФункции

// Преобразует размер в байтах в мегабайты или оставляет в байтах, если размер маленький.
//
// Параметры:
//  Размер - Число - число, которые необходимо преобразовать в текст.
//
// Возвращаемое значение:
//   Строка - текстовое представление в байтах или в мегабайтах.
//
Функция ПолучитьПредставлениеРазмера(Размер) Экспорт

	Результат = "";
	Если Размер < 1*1024*1024 Тогда // До 1 Мб - в байтах
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 байт'"),
			Формат(Размер, "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"));
	Иначе // В Мегабайтах
		Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='%1 Мбайт'"),
			Формат(Окр(Размер / 1024 / 1024, 0, РежимОкругления.Окр15как20), "ЧЦ=20; ЧДЦ=; ЧРГ=' '; ЧН=0; ЧГ=3,0"));
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Возвращает список символов, запрещенных для использования в параметрах командной строки, т.к. могут привести к неожиданным последствиям.
//
// Возвращаемое значение:
//  Строка - список запрещенных символов.
//
Функция ЗапрещенныеСимволыДляКоманднойСтроки() Экспорт

	Результат = "<>?|;$`&";

	Возврат Результат;

КонецФункции

// Проверяет строку на наличие запрещенных для использования в командной строке символов.
//
// Параметры:
//  СтрокаДляПроверки - Строка - строка, которую необходимо проверить на наличие запрещенных символов;
//  ТекстОшибки       - Строка - строка со списком найденных запрещенных символов.
//
// Возвращаемое значение:
//  Булево - Истина, если есть запрещенные символы.
//
Функция ЕстьЗапрещенныеСимволыДляКоманднойСтроки(СтрокаДляПроверки, ТекстОшибки = Неопределено) Экспорт

	Результат = Ложь;
	НайденныеЗапрещенныеСимволы = Новый Соответствие;
	ТекстОшибки = "";

	ЗапрещенныеСимволы = ЗапрещенныеСимволыДляКоманднойСтроки();

	ВсегоСимволов = СтрДлина(ЗапрещенныеСимволы);
	Для С=1 По ВсегоСимволов Цикл
		ТекущийСимвол = Сред(ЗапрещенныеСимволы, С, 1);
		ЧислоВхождений = СтрЧислоВхождений(СтрокаДляПроверки, ТекущийСимвол);
		Если ЧислоВхождений > 0 Тогда
			Результат = Истина;
			НайденныеЗапрещенныеСимволы.Вставить(ТекущийСимвол, ЧислоВхождений);
		КонецЕсли;
	КонецЦикла;

	Если Результат = Истина Тогда
		СписокНайденныхЗапрещенныхСимволов = "";
		Для Каждого КлючЗначение Из НайденныеЗапрещенныеСимволы Цикл
			СписокНайденныхЗапрещенныхСимволов = СписокНайденныхЗапрещенныхСимволов
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"#%1 (%2)#", 
					КлючЗначение.Ключ,
					КлючЗначение.Значение);
		КонецЦикла;
		СписокНайденныхЗапрещенныхСимволов = СтрЗаменить(СписокНайденныхЗапрещенныхСимволов, "##", ", ");
		СписокНайденныхЗапрещенныхСимволов = СтрЗаменить(СписокНайденныхЗапрещенныхСимволов, "#", "");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Найдены запрещенные символы: %1'"),
			СписокНайденныхЗапрещенныхСимволов);
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СборДанных

// Возвращает структуру шага для сбора данных процедурой "ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву".
//
// Возвращаемое значение:
//   Структура - Структура с определенными ключами, см. код.
//
Функция ПолучитьОписаниеШагаСбораДанных() Экспорт

	Результат = Новый Структура("КодШага, ОписаниеШага, СрокУстареванияСекунд");

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЛогИОтладка

// Функция возвращает массив всех возможных событий журнала регистрации для событий подсистемы ОблачныйАрхив.
// Нужно для формирования журнала регистрации из Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации.
//
// Возвращаемое значение:
//   Массив - Массив всех возможных событий.
//
Функция ПолучитьСписокВсехСобытийЖурналаРегистрации() Экспорт

	Результат = Новый Массив;

	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив'"));
	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив.Отладка'"));
	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив.Сервис и регламент'"));
	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив.Работа с внешними утилитами'"));
	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив.Все обновления Облачного архива'"));
	Результат.Добавить(НСтр("ru='БИП:ОблачныйАрхив.Веб-сервисы'"));

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область Скрипты

// Функция возвращает содержимое потока вывода у процесса, запущенного через WshShell.Exec(СтрокаКоманды).
//
// Параметры:
//  Процесс  - COMОбъект - объект запущенного процесса;
//  ВидПотока - Строка - "StdOut", "StdErr";
//  МаксимальноеКоличествоСтрок - Число - ограничитель возвращаемого количества строк.
//
// Возвращаемое значение:
//   Строка - содержимое потока вывода процесса.
//
Функция ПрочитатьПотокВыводаПроцесса(Процесс, ВидПотока, МаксимальноеКоличествоСтрок = 0) Экспорт

	СодержимоеПотока = "";

	Если ВРег(ВидПотока) = ВРег("StdOut") Тогда
		Поток = Процесс.StdOut;
	ИначеЕсли ВРег(ВидПотока) = ВРег("StdErr") Тогда
		Поток = Процесс.StdErr;
	Иначе
		Возврат "";
	КонецЕсли;

	ПрочитаноСтрок = 0;
	Пока НЕ Поток.AtEndOfStream Цикл
		Если МаксимальноеКоличествоСтрок > 0 Тогда
			ПрочитаноСтрок = ПрочитаноСтрок + 1;
			Если (ПрочитаноСтрок > МаксимальноеКоличествоСтрок) Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
		СодержимоеПотока = СодержимоеПотока + Символы.ПС + Поток.ReadLine();
	КонецЦикла;
	
	Возврат СокрЛП(СодержимоеПотока);
	
КонецФункции

// Функция возвращает таблицу с описанием всех локальных дисков (жесткие диски, USB, CD-ROM, сетевые диски).
// Так как подсистема работает только в файловой информационной базе, то неважно, где будет запускаться эта функция.
//
// Возвращаемое значение:
//   Массив - массив структур с ключами:
//    * Имя             - Строка(2) - Буква диска с двоеточием (Name);
//    * Идентификатор   - Строка(2) - Буква диска с двоеточием (DeviceID) - рекомендуется использовать для идентификации;
//    * Заголовок       - Строка(2) - Буква диска с двоеточием (Caption);
//    * ТипДиска        - Число - 2 - USB, 3 - жесткий диск, 4 - сетевой диск, 5 - CD-ROM (DriveType);
//    * ФайловаяСистема - Строка - NTFS, FAT32, ... (FileSystem);
//    * БайтВсего       - Число - Общий размер диска в байтах (Size);
//    * БайтСвободно    - Число - Свободно на диске, байт (FreeSpace);
//    * СетевойПуть     - Строка - если ТипДиска = 4, то здесь задан путь к сетевой папке (ProviderName).
//
Функция ПолучитьИнформациюОДисках()

	Результат = Новый Массив;

	wbemFlagReturnImmediately = 16;
	wbemFlagForwardOnly = 32;

	ЛокальныйКомпьютер = ".";
	WMIАдрес  = "winmgmts:\\" + ЛокальныйКомпьютер + "\root\CIMv2";
	WMIСервис = ПолучитьCOMОбъект(WMIАдрес);
	оЭлементы = WMIСервис.ExecQuery(
		"SELECT * FROM Win32_LogicalDisk",
		"WQL",
		wbemFlagReturnImmediately + wbemFlagForwardOnly);
	Для Каждого оЭлемент Из оЭлементы Цикл
		ЭлементРезультата = Новый Структура;
		ЭлементРезультата.Вставить("Имя",             оЭлемент.Name);
		ЭлементРезультата.Вставить("Идентификатор",   оЭлемент.DeviceID);
		ЭлементРезультата.Вставить("Заголовок",       оЭлемент.Caption);
		ЭлементРезультата.Вставить("ТипДиска",        оЭлемент.DriveType);
		ЭлементРезультата.Вставить("ФайловаяСистема", оЭлемент.FileSystem);
		ЭлементРезультата.Вставить("БайтВсего",       оЭлемент.Size);
		ЭлементРезультата.Вставить("БайтСвободно",    оЭлемент.FreeSpace);
		ЭлементРезультата.Вставить("СетевойПуть",     оЭлемент.ProviderName);
		Результат.Добавить(ЭлементРезультата);
	КонецЦикла;

	Возврат Результат;

КонецФункции

// Если каталог указывает на подключенный сетевой диск, то имя диска будет развернуто в полное имя.
// Было: Z:\Dir, станет \\server\path\Dir.
// Это необходимо для настроек Агента резервного копирования, т.к. пользователь может подключить сетевой диск,
//  а у пользователя, от имени которого по расписанию запускается Агент резервного копирования,
//  этот диск может быть НЕ подключен и будет ошибка копирования.
//
// Параметры:
//  ИмяКаталога - Строка - имя каталога.
//
// Возвращаемое значение:
//   Строка - преобразованное имя каталога.
//
Функция ПривестиИмяКаталогаКПолномуВиду(ИмяКаталога) Экспорт

	ВсеДиски = ПолучитьИнформациюОДисках();

	Результат = ИмяКаталога;

	Для Каждого ТекущийДиск Из ВсеДиски Цикл
		// Диск найден?
		Если ВРег(ТекущийДиск.Идентификатор) = ВРег(Лев(Результат, 2)) Тогда
			// Это подключенный сетевой диск?
			Если ТекущийДиск.ТипДиска = 4 Тогда // Сетевой диск.
				НаЧтоЗаменять = ТекущийДиск.СетевойПуть;
				Если СтрДлина(НаЧтоЗаменять) > 0 Тогда
					НаЧтоЗаменять = ИнтернетПоддержкаПользователейКлиентСервер.УдалитьПоследнийСимвол(НаЧтоЗаменять, "\/");
					Результат = ""
						+ НаЧтоЗаменять
						+ Прав(Результат, СтрДлина(Результат) - 2);
				КонецЕсли;
			КонецЕсли;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	// Агент резервного копирования не работает, если в конце имени каталога стоит косая черта.
	Результат = ИнтернетПоддержкаПользователейКлиентСервер.УдалитьПоследнийСимвол(Результат, "\/");

	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СписокИдентификаторовИБ

// В облачный архив будут попадать резервные копии с разными идентификаторами:
//  ОсновнойИдентификатор + Суффикс, что позволит разделять копии по способу создания для дальнейшей обработки.
// Основные суффиксы: Auto (автоматические резервные копии) и Manual (ручные резервные копии), и итоговые идентификаторы примут вид:
//  - 000000000000000000000_Auto и 000000000000000000000_Manual, где 000000000000000000000 - идентификатор этой ИБ.
//
// Возвращаемое значение:
//  Структура - Структура с ключами:
//   * Ключ - Строка - Суффикс, добавляемый к основному идентификатору ИБ (состоит из английских букв, цифр, знаков "-" и "_", в верхнем регистре);
//   * Значение - Структура - структура с ключами:
//     ** Суффикс  - Строка - суффикс, добавляемый к идентификатору ИБ для резервных копий;
//     ** Описание - Строка - текст, добавляемый к имени ИБ для резервных копий.
//
Функция ПолучитьОписаниеСуффиксовИдентификаторовИБ() Экспорт

	ТипСтруктура = Тип("Структура");

	Результат = Новый Структура;

	ОблачныйАрхивКлиентСерверПереопределяемый.ДополнитьСтруктуруСуффиксовИдентификаторовИБ(Результат);

	Если ТипЗнч(Результат) <> ТипСтруктура Тогда
		Результат = Новый Структура;
	КонецЕсли;

	Результат.Вставить("АвтоматическаяКопия",
		Новый Структура("Суффикс, Описание",
			"_Auto",
			"")); // Никакого дополнительного описания.
	Результат.Вставить("РучнаяКопия",
		Новый Структура("Суффикс, Описание",
			"_Manual",
			" " + НСтр("ru='(вручную)'")));

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
