#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область АПИдляИнтерфейсыВзаимодействияБРО

// Внешний АПИ ИнтерфейсыВзаимодействияБРО.ОрганизацииИмеющиеПравоНаЛьготныйКредит
//
Функция ОрганизацииИмеющиеПравоНаЛьготныйКредит(СписокИНН) Экспорт
	
	ОрганизацииИмеющиеПравоНаЛьготныйКредит = Новый Массив;
	Для каждого ИНН Из СписокИНН Цикл
		АдресРезультата = ПоместитьВоВременноеХранилище(,Новый УникальныйИдентификатор);
		ПроверитьОрганизациюВФоне(ИНН, АдресРезультата);
		Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
		
		Если НЕ Результат.Выполнено Тогда
			// При ошибке сервера возвращаем неопределено сразу по всем оргаинзациям
			Возврат Неопределено;  
		КонецЕсли;
		
		Если Результат.Выполнено И Результат.ОрганизацияПострадалаОтПандемии Тогда
			 ОрганизацииИмеющиеПравоНаЛьготныйКредит.Добавить(ИНН);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ОрганизацииИмеющиеПравоНаЛьготныйКредит;
	
КонецФункции

// Внешний АПИ ИнтерфейсыВзаимодействияБРО.ОрганизацииОтправлявшиеЗаявкиНаЛьготныйКредит
// 
Функция ОрганизацииОтправлявшиеЗаявкиНаЛьготныйКредит() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЗаявкиНаЛьготныйКредит.Организация КАК Организация
		|ИЗ
		|	Документ.ЗаявкиНаЛьготныйКредит КАК ЗаявкиНаЛьготныйКредит
		|ГДЕ
		|	ЗаявкиНаЛьготныйКредит.ПометкаУдаления = ЛОЖЬ
		|	И ЗаявкиНаЛьготныйКредит.Состояние <> ЗНАЧЕНИЕ(Перечисление.СостоянияЛьготныхЗаявок.ВРаботе)";
	
	Организации = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Организация");
	
	Возврат Организации;
	
КонецФункции

#КонецОбласти

#Область Авторизация

Функция ПолучитьJwtToken(ВходящийКонтекст)
	
	Результат = Новый Структура();
	Результат.Вставить("ОписаниеОшибки",   "");
	Результат.Вставить("ОшибкаСервера",    Ложь);
	Результат.Вставить("Выполнено",        Ложь);
	Результат.Вставить("JwtToken",         Неопределено);

	Попытка
		
		// https://identity.credit-fns.astral-dev.ru/api/Account/Certificate/Token
		
		АдресСервиса = АдресСервераАутентификации();
		АдресРесурса = "/api/Account/Certificate/Token";
		
		Параметры = Новый Структура();
		Параметры.Вставить("Sign",  ВходящийКонтекст.ПодписанноеСообщениеBase64);
		Параметры.Вставить("Token", ВходящийКонтекст.ТокенДляИдентификации);
		
		Ответ = PostЗапрос(АдресСервиса, АдресРесурса, Параметры);
	
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				Результат.Вставить("Выполнено", Истина);
				Результат.Вставить("JwtToken",  Данные.JwtToken);
			Иначе
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные.errors));
			КонецЕсли;
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Получение Jwt токена'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
			
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Процедура ПолучитьДанныеДляПодписанияИТокенВФоне(SubjectKeyId, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",        Ложь);
	Результат.Вставить("ОшибкаСервера",    Ложь);
	Результат.Вставить("ОписаниеОшибки",   "");
	Результат.Вставить("ДанныеДляПодписи", Неопределено);
	Результат.Вставить("ТокенДляИдентификации", Неопределено);

	Попытка
		
		// https://identity.credit-fns.astral-dev.ru/api/Account/Certificate/SignData
		
		АдресСервиса = АдресСервераАутентификации();
		АдресРесурса = "/api/Account/Certificate/SignData";
		
		Параметры = Новый Структура();
		Параметры.Вставить("Skid", SubjectKeyId);
		
		Ответ = PostЗапрос(АдресСервиса, АдресРесурса, Параметры);
	
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				Результат.Вставить("Выполнено",        Истина);
				Результат.Вставить("ДанныеДляПодписи", Данные.data);
				Результат.Вставить("ТокенДляИдентификации", Данные.token);
			Иначе
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные.errors));
			КонецЕсли;
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Авторизация в системе'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
			
	КонецПопытки; 
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ПолучениеДанных

Процедура ОбновитьСостоянияЗаявокВФоне() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаявкиНаЛьготныйКредит.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявкиНаЛьготныйКредит КАК ЗаявкиНаЛьготныйКредит
		|ГДЕ
		|	ЗаявкиНаЛьготныйКредит.ПометкаУдаления = ЛОЖЬ
		|	И ЗаявкиНаЛьготныйКредит.ТребуетВнимания = ЛОЖЬ
		|	И ЗаявкиНаЛьготныйКредит.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЛьготныхЗаявок.ОтправленоВФНС), ЗНАЧЕНИЕ(Перечисление.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк))";
	
	Заявки = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для каждого Заявка Из Заявки Цикл
		
		Результат = ПолучитьСтатусЗаявки(Заявка);
		
		СостояниеИзменилось = 
			Результат.Выполнено И (Результат.Состояние <> Заявка.Состояние
			ИЛИ ЗначениеЗаполнено(Результат.КонтактыБанка) И НЕ ЗначениеЗаполнено(Заявка.КонтактыБанка));
		
		Если СостояниеИзменилось Тогда
			
			ТребуетВнимания = 
				Результат.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОдобреноБанком
				ИЛИ Результат.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтклоненоБанком
				ИЛИ Результат.Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк
				И ЗначениеЗаполнено(Результат.КонтактыБанка) И НЕ ЗначениеЗаполнено(Заявка.КонтактыБанка);
				
			Если ТребуетВнимания Тогда
				Результат.Вставить("ТребуетВнимания", Истина);
			КонецЕсли;
			
			СохранитьРеквизитыЗаявки(Заявка, Результат);
			
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

Функция ПолучитьСтатусЗаявки(Заявка)
	
	Результат = Новый Структура();
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("Состояние",      Неопределено);
	Результат.Вставить("КонтактыБанка",  "");
	Результат.Вставить("ПричинаОтклоненияБанком","");
	
	Попытка
		
		// https://credit-fns.astral-dev.ru/api/creditrequests/{id}/status

		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/creditrequests/" + Заявка.ИдентификаторЗаявки + "/status";
		
		Ответ = GetЗапрос(АдресСервиса, АдресРесурса);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				
				Результат.Вставить("Выполнено", Истина);
				Результат.Вставить("Состояние", СтатусЗаявкиПоСтроке(Данные.status));
				Результат.Вставить("КонтактыБанка", Данные.acceptInfo);
				
				Если Данные.Свойство("declineReasonBank") Тогда
					Результат.Вставить("ПричинаОтклоненияБанком", Данные.declineReasonBank);
				КонецЕсли;
				
			Иначе
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные));
			КонецЕсли;
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
		
		СкорректироватьРезультатВРежимеТестирования(Результат);
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Получение статуса одной заявки'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
			
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Процедура ОтправитьЗаявкуОператоруВФоне(ВходящийКонтекст, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ОписаниеОшибки",      "");
	Результат.Вставить("ОшибкаСервера",       Ложь);
	Результат.Вставить("Выполнено",           Ложь);
	Результат.Вставить("ИдентификаторЗаявки", Неопределено);
	
	РезультатПолученияJwtTokenа = ПолучитьJwtToken(ВходящийКонтекст);
	Если НЕ РезультатПолученияJwtTokenа.Выполнено Тогда
		Результат.Вставить("ОписаниеОшибки", РезультатПолученияJwtTokenа.ОписаниеОшибки);
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	JwtToken = РезультатПолученияJwtTokenа.JwtToken;
	
	Результат = СоздатьЗаявку(Результат, ВходящийКонтекст, JwtToken);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ОбновитьСтатусЗаявкиВФоне(ВходящийКонтекст, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("Состояние",      Неопределено);
	Результат.Вставить("КонтактыБанка",  "");
	Результат.Вставить("ПричинаОтклоненияБанком", "");
	Результат.Вставить("ОдобреннаяСуммаКредита", 0);
	
	РезультатПолученияJwtTokenа = ПолучитьJwtToken(ВходящийКонтекст);
	Если НЕ РезультатПолученияJwtTokenа.Выполнено Тогда
		Результат.Вставить("ОписаниеОшибки", РезультатПолученияJwtTokenа.ОписаниеОшибки);
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
		Возврат;
	КонецЕсли;
	
	JwtToken = РезультатПолученияJwtTokenа.JwtToken;
	
	Результат = ОбновитьСтатусЗаявки(Результат, ВходящийКонтекст, JwtToken);
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Функция СоздатьЗаявку(Результат, ВходящийКонтекст, JwtToken)
	
	Попытка
		
		// https://credit-fns.astral-dev.ru/api/creditrequests

		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/creditrequests";
		Авторизация  = "Bearer " + JwtToken;
		
		Параметры = ПараметрыЗаявки(ВходящийКонтекст);
		Ответ = PostЗапрос(АдресСервиса, АдресРесурса, Параметры, Авторизация);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				Результат.Вставить("Выполнено", Истина);
				Результат.Вставить("ИдентификаторЗаявки",  Данные.txId);
			Иначе
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные));
			КонецЕсли;
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
		
		СкорректироватьРезультатВРежимеТестирования(Результат);
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Создание заявки'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
			
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Функция ОбновитьСтатусЗаявки(Результат, ВходящийКонтекст, JwtToken)
	
	Попытка
		
		// https://credit-fns.astral-dev.ru/api/creditrequests/{id}

		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/creditrequests/" + ВходящийКонтекст.Заявка.ИдентификаторЗаявки;
		Авторизация  = "Bearer " + JwtToken;
		
		Ответ = GetЗапрос(АдресСервиса, АдресРесурса, Авторизация);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				
				Результат.Вставить("Выполнено",      Истина);
				Результат.Вставить("ПричинаОтклоненияБанком", Данные.declineReasonBank);
				Результат.Вставить("ОдобреннаяСуммаКредита",  Данные.acceptedAmount);
				Результат.Вставить("Состояние", СтатусЗаявкиПоСтроке(Данные.status));
				Результат.Вставить("КонтактыБанка", Данные.acceptInfo);
				
			Иначе
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные));
			КонецЕсли;
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
		
		СкорректироватьРезультатВРежимеТестирования(Результат);
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Получение статуса одной заявки'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
			
	КонецПопытки; 
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверитьДоступностьКредитаВФоне(ИНН, АдресРезультата) Экспорт
	
	ПромежуточныйАдрес = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	
	ПолучитьСведенияОрганизацииВФоне(ИНН, ПромежуточныйАдрес);
	Результат = ПолучитьИзВременногоХранилища(ПромежуточныйАдрес);
	
	Результат.Вставить("ЕстьЗаявка", Ложь);
	Результат.Вставить("СтатусЗаявки", Ложь);
	Результат.Вставить("Банк", "");
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьСведенияОрганизацииВФоне(ИНН, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("РаботаетВПострадавшейОтрасли", Ложь); // isNeedHelpOkfed
	Результат.Вставить("РаботаетБолееГода", Ложь); // moreThanYear
	Результат.Вставить("Действующая", Ложь); // isActivity
	Результат.Вставить("ЧисленностьСотрудников", 0); // szvmPersonal
	Результат.Вставить("ЛимитКредита", 0); // limitPayout
	Результат.Вставить("ОрганизацияПострадалаОтПандемии", Ложь); // isNeedHelp
	
	Попытка
		
		// https://credit-fns.astral-dev.ru/api/companies/{inn}/check
		
		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/companies/" + ИНН + "/check";
		
		Ответ = GetЗапрос(АдресСервиса, АдресРесурса);
		
		Результат.Вставить("Выполнено", Истина);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				
				Результат.Вставить("РаботаетВПострадавшейОтрасли", Данные.isNeedHelpOkfed);
				Результат.Вставить("РаботаетБолееГода", Данные.moreThanYear);
				Результат.Вставить("Действующая", Данные.isActivity);
				Результат.Вставить("ЧисленностьСотрудников", Данные.szvmPersonal);
				Результат.Вставить("ЛимитКредита", Данные.limitPayout);
				Результат.Вставить("ОрганизацияПострадалаОтПандемии", Данные.isNeedHelp);
				
			ИначеЕсли Ответ.КодСостояния = 400 Тогда
				Результат.Вставить("ОписаниеОшибки", ТекстОшибки400(Данные));
			КонецЕсли;
			
		Иначе
			// Ошибка сервера
			ОбработатьОшибкуСервера(Результат);
		КонецЕсли;
	
	Исключение
		
		Комментарий = СохранитьОшибкуВЖурнал(НСтр("ru = 'Проверка организации на признание пострадавшей от пандемии'"));
		Результат.Вставить("ОписаниеОшибки", Комментарий);
		ОбработатьОшибкуСервера(Результат);
	
	КонецПопытки; 
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПроверитьОрганизациюВФоне(ИНН, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("ОрганизацияПострадалаОтПандемии", Ложь);
	
	ПромежуточныйАдрес = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	
	ПолучитьСведенияОрганизацииВФоне(ИНН, ПромежуточныйАдрес);
	СведенияОрганизации = ПолучитьИзВременногоХранилища(ПромежуточныйАдрес);
	
	ЗаполнитьЗначенияСвойств(Результат, СведенияОрганизации);
	
	Если НЕ Результат.ОрганизацияПострадалаОтПандемии Тогда
		ТекстОшибки = НСтр("ru = 'По данным ФНС, организация не работает в отрасли, пострадавшей от пандемии, и поэтому не может претендовать на льготный кредит.'");
		Результат.Вставить("ОписаниеОшибки", ТекстОшибки);
	КонецЕсли;
	
	Если Результат.ОшибкаСервера Тогда
		Результат.Вставить("ОрганизацияПострадалаОтПандемии", Истина);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьБанкиВФоне(ИНН, АдресРезультата) Экспорт
	
	Банки = Новый ТаблицаЗначений;
	Банки.Колонки.Добавить("Идентификатор");
	Банки.Колонки.Добавить("Наименование");
	Банки.Колонки.Добавить("БИК");
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("Банки",          Банки);

	Попытка
		
		// https://credit-fns.astral-dev.ru/api/Banks
		
		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/Banks";
		
		Ответ = GetЗапрос(АдресСервиса, АдресРесурса);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				
				Для каждого СтрокаДанных Из Данные Цикл
					 НовыйБанк = Банки.Добавить();
					 НовыйБанк.Идентификатор = СтрокаДанных.id;
					 НовыйБанк.Наименование = СтрокаДанных.name;
					 НовыйБанк.БИК = СтрокаДанных.bik;
				 КонецЦикла;
				 
				 Результат.Вставить("Банки", Банки);
				 
			 Иначе
		 		ОбработатьОшибкуСервера(Результат, Истина);
			КонецЕсли; 
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
	
	Исключение
		
		СохранитьОшибкуВЖурнал(НСтр("ru = 'Получение списка банков участников'"));
		ПоместитьВоВременноеХранилище(Банки, АдресРезультата);
		ОбработатьОшибкуСервера(Результат);
	
	КонецПопытки; 
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

Процедура ПолучитьСсылкуНаБанкиВФоне(ИНН, АдресРезультата) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("Выполнено",      Ложь);
	Результат.Вставить("ОшибкаСервера",  Ложь);
	Результат.Вставить("ОписаниеОшибки", "");
	Результат.Вставить("СсылкаНаБанки",  "");

	Попытка
		
		// https://credit-fns.astral-dev.ru/api/Banks/Contacts
		
		АдресСервиса = АдресСервераДанных();
		АдресРесурса = "/api/Banks/Contacts";
		
		Ответ = GetЗапрос(АдресСервиса, АдресРесурса);
		
		Если Ответ.КодСостояния = 200 ИЛИ Ответ.КодСостояния = 400 Тогда
			
			Данные = ОтветСервиса(Ответ);
			
			Если Ответ.КодСостояния = 200 Тогда
				
				Результат.Вставить("СсылкаНаБанки", Данные.url);
				 
			Иначе
		 		ОбработатьОшибкуСервера(Результат, Истина);
			КонецЕсли; 
			
		Иначе
			ОбработатьОшибкуСервера(Результат, Истина);
		КонецЕсли;
	
	Исключение
		
		СохранитьОшибкуВЖурнал(НСтр("ru = 'Получение ссылки на список банков участников'"));
		ОбработатьОшибкуСервера(Результат);
	
	КонецПопытки; 
	
	ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыОрганизации(Организация) Экспорт
	
	ЗапрашиваемыеРеквизиты = "НаимЮЛПол,ОГРН,ИННЮЛ,КППЮЛ,БанкСчетНомер, БанкСчетНаимБанка, БанкСчетКоррСчетБанка, БанкСчетБИКБанка,ЧисленностьСотрудников";
	
	ДанныеОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
			Организация,
			,
			ЗапрашиваемыеРеквизиты);
			
	Возврат ДанныеОрганизации;
	
КонецФункции	

Процедура ЗаполнитьПоОрганизации(Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОрганизации = РеквизитыОрганизации(Объект.Организация);
			
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Объект.Организация);
	
	Объект.НаименованиеОрганизации  = ДанныеОрганизации.НаимЮЛПол;
	Если ЭтоЮридическоеЛицо Тогда
		Объект.КПП = ДанныеОрганизации.КППЮЛ;
	Иначе
		Объект.КПП = "";
	КонецЕсли;
	
	Объект.ИНН = ДанныеОрганизации.ИННЮЛ;
	Объект.ОГРН = ДанныеОрганизации.ОГРН;
	
	Если ДанныеОрганизации.Свойство("ЧисленностьСотрудников") Тогда
		Объект.ЧисленностьСотрудников = ДанныеОрганизации.ЧисленностьСотрудников;
	КонецЕсли;
	
	// ФИО руководителя
	Руководитель = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.Руководитель(Объект.Организация); 
	
	Если ЗначениеЗаполнено(Руководитель) Тогда
		
		ФИО = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ФИОФизЛица(Руководитель);
			
		Объект.ИмяРуководителя       = ФИО.Имя;
		Объект.ФамилияРуководителя   = ФИО.Фамилия;
		Объект.ОтчествоРуководителя  = ФИО.Отчество;
		
		Если НЕ ЭтоЮридическоеЛицо Тогда 
			Объект.НаименованиеОрганизации = Строка(Руководитель);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаявкиДляПоказа() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкиНаЛьготныйКредит) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИсключаемыеЛьготныеЗаявки = ХранилищеОбщихНастроек.Загрузить("ЛьготныеЗаявки_БольшеНеНапоминать");
	Если ТипЗнч(ИсключаемыеЛьготныеЗаявки) <> Тип("Массив") Тогда
		ИсключаемыеЛьготныеЗаявки = Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаявкиНаЛьготныйКредит.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявкиНаЛьготныйКредит КАК ЗаявкиНаЛьготныйКредит
		|ГДЕ
		|	ЗаявкиНаЛьготныйКредит.ПометкаУдаления = ЛОЖЬ
		|	И ЗаявкиНаЛьготныйКредит.ТребуетВнимания = Истина
		|	И ЗаявкиНаЛьготныйКредит.Ответственный = &Ответственный
		|	И НЕ ЗаявкиНаЛьготныйКредит.Ссылка В (&ИсключаемыеЛьготныеЗаявки)";
	
	Запрос.УстановитьПараметр("Ответственный", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ИсключаемыеЛьготныеЗаявки", ИсключаемыеЛьготныеЗаявки);
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	Возврат РезультатЗапроса.ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Функция НужноПоказатьПредупреждениеОКонтактахБанка() Экспорт
	
	Если НЕ ПравоДоступа("Чтение", Метаданные.Документы.ЗаявкиНаЛьготныйКредит) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БольшеНеНапоминать = ХранилищеОбщихНастроек.Загрузить("ЛьготныеЗаявки_КонтактыБанка_БольшеНеНапоминать");
	Если БольшеНеНапоминать = Истина Тогда  // Может быть Неопределено
		Возврат Ложь;
	КонецЕсли;
	
	Заявки = ЗаявкиСНеправильнымиКонтактамиБанка(Истина);
	Возврат Заявки.Количество() > 0;
	
КонецФункции

Функция НеправильныйТелефон() Экспорт
	
	Возврат "8-800-000-11-33";
	
КонецФункции

Функция ПравильныйТелефон() Экспорт
	
	Возврат "8(800)200-7799";
	
КонецФункции

Функция ЗаявкиСНеправильнымиКонтактамиБанка(ИзКэша = Ложь) Экспорт
	
	КлючОбъекта = "ЛьготныеЗаявки_КонтактыБанка_Заявки";
	
	Если ИзКэша Тогда
		СохраненныеЗаявки = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта);
		Если СохраненныеЗаявки <> Неопределено Тогда
			Возврат СохраненныеЗаявки;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаявкиНаЛьготныйКредит.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.ЗаявкиНаЛьготныйКредит КАК ЗаявкиНаЛьготныйКредит
		|ГДЕ
		|	ЗаявкиНаЛьготныйКредит.ПометкаУдаления = ЛОЖЬ
		|	И ЗаявкиНаЛьготныйКредит.Ответственный = &Ответственный
		|	И ЗаявкиНаЛьготныйКредит.КонтактыБанка ПОДОБНО ""%"" + &НеправильныйТелефон + ""%""
		|	И ЗаявкиНаЛьготныйКредит.Состояние В (ЗНАЧЕНИЕ(Перечисление.СостоянияЛьготныхЗаявок.ОтклоненоБанком), ЗНАЧЕНИЕ(Перечисление.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк))";
	
	Запрос.УстановитьПараметр("Ответственный", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("НеправильныйТелефон", НеправильныйТелефон());
	РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	СохраненныеЗаявки = ХранилищеОбщихНастроек.Загрузить(КлючОбъекта);
	Если СохраненныеЗаявки = Неопределено Тогда
		ХранилищеОбщихНастроек.Сохранить(КлючОбъекта,,РезультатЗапроса);
	КонецЕсли;

	Возврат РезультатЗапроса;
	
КонецФункции

Функция HTTPЗапрос(АдресРесурса)
	
	HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	HTTPЗапрос.Заголовки.Вставить("Accept", "application/json");
	HTTPЗапрос.Заголовки.Вставить("Content-Type", "application/json");
	HTTPЗапрос.Заголовки.Вставить("X-Source", "1C");
	
	Возврат HTTPЗапрос;
	
КонецФункции

Функция GetЗапрос(АдресСервиса, АдресРесурса, Авторизация = Неопределено) Экспорт
	
	HTTPЗапрос = HTTPЗапрос(АдресРесурса);
	
	Если Авторизация <> Неопределено Тогда
		HTTPЗапрос.Заголовки.Вставить("Authorization", Авторизация);
	КонецЕсли;
	
	// инициализируем настройки прокси, если они определены
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкаПроксиСервера <> Неопределено Тогда
		Прокси = СформироватьПрокси(НастройкаПроксиСервера, "http");
	Иначе
		Прокси = Новый ИнтернетПрокси;
	КонецЕсли;
	
	Таймаут = 5;
	HTTPСоединение = Новый HTTPСоединение(АдресСервиса,,,,
		Прокси,
		Таймаут,
		Новый ЗащищенноеСоединениеOpenSSL);
		
	Ответ = HTTPСоединение.Получить(HTTPЗапрос);
	
	Возврат Ответ;

КонецФункции

Функция PostЗапрос(АдресСервиса, АдресРесурса, Параметры, Авторизация = Неопределено) Экспорт
	
	ВременныйФайл = ПолучитьИмяВременногоФайла(".json");
	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Авто, " ", Истина);
	Запись = Новый ЗаписьJSON;
	Запись.ПроверятьСтруктуру = Истина;
	Запись.ОткрытьФайл(ВременныйФайл, "windows-1251", , ПараметрыJSON);
	Запись.ЗаписатьНачалоОбъекта();
	
	Для каждого Параметр Из Параметры Цикл
		Запись.ЗаписатьИмяСвойства(Параметр.Ключ);
		Запись.ЗаписатьЗначение(Параметр.Значение);
	КонецЦикла; 
	
	Запись.ЗаписатьКонецОбъекта();
	Запись.Закрыть();
	
	Файл = Новый ЧтениеТекста(ВременныйФайл, "windows-1251");
	СтрокаПараметров = Файл.Прочитать();
	Файл.Закрыть();
	
	HTTPЗапрос = HTTPЗапрос(АдресРесурса);
	HTTPЗапрос.УстановитьТелоИзСтроки(СтрокаПараметров, КодировкаТекста.UTF8);
	
	Если Авторизация <> Неопределено Тогда
		HTTPЗапрос.Заголовки.Вставить("Authorization", Авторизация);
	КонецЕсли;
	
	// инициализируем настройки прокси, если они определены
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаСервере();
	Если НастройкаПроксиСервера <> Неопределено Тогда
		Прокси = СформироватьПрокси(НастройкаПроксиСервера, "http");
	Иначе
		Прокси = Новый ИнтернетПрокси;
	КонецЕсли;
	
	Таймаут = 5;
	HTTPСоединение = Новый HTTPСоединение(АдресСервиса,,,,
		Прокси,
		Таймаут,
		Новый ЗащищенноеСоединениеOpenSSL);
		
	Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос);
	
	Возврат Ответ;

КонецФункции

Процедура ОбработатьОшибкуСервера(Результат, ЭтоОшибка500 = Ложь)
	
	Если ЭтоОшибка500 Тогда
		ОписаниеОшибки = ТекстСерверНедоступен();
		Результат.Вставить("ОписаниеОшибки", ОписаниеОшибки);
	КонецЕсли;
	
	Результат.Вставить("ОшибкаСервера",  Истина);
	
КонецПроцедуры

Функция ТекстСерверНедоступен() Экспорт
	
	Возврат НСтр("ru = 'Сервис временно недоступен.'");
	
КонецФункции

Функция ТекстОшибки400(errors)
	
	Если ТипЗнч(errors) = Тип("Массив") Тогда
		Ошибки = Новый Массив;
		Для каждого Ошибка Из errors Цикл
			Ошибки.Добавить(Ошибка.message);
		КонецЦикла;
		ОписаниеОшибки = СтрСоединить(Ошибки, Символы.ПС);
	Иначе
		ОписаниеОшибки = errors.message;
	КонецЕсли;
	
	Возврат ОписаниеОшибки;
	
КонецФункции

Функция СформироватьПрокси(НастройкиПрокси, Протокол)
	
	Прокси = Новый ИнтернетПрокси;
	Прокси.НеИспользоватьПроксиДляЛокальныхАдресов = НастройкиПрокси["НеИспользоватьПроксиДляЛокальныхАдресов"];
	Прокси.Установить(Протокол, НастройкиПрокси["Сервер"], СтроковыеФункцииКлиентСервер.СтрокаВЧисло(НастройкиПрокси["Порт"]), НастройкиПрокси["Пользователь"], НастройкиПрокси["Пароль"]);
		
	Возврат Прокси;
	
КонецФункции

Функция ОтветСервиса(Ответ)

	СтрокаОтвет = Ответ.ПолучитьТелоКакСтроку();
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаОтвет);
	Данные = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат Данные;
	
КонецФункции

Функция СохранитьОшибкуВЖурнал(Событие)

	ИмяСобытия = НСтр("ru = 'Льготные кредиты.'",
		ОбщегоНазначения.КодОсновногоЯзыка()) + Событие;
		
	Комментарий = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытия ,
		УровеньЖурналаРегистрации.Ошибка,,,
		Комментарий);
	
	Возврат Комментарий;
	
КонецФункции

Функция СтатусЗаявкиПоСтроке(СостояниеСтрокой)
	
	Если СостояниеСтрокой = "CREATED" Тогда
		Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтправленоВФНС;
	ИначеЕсли СостояниеСтрокой = "REGULATOR_APPROVED" Тогда
		Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОбработаноВФНСПереданоВБанк;
	ИначеЕсли СостояниеСтрокой = "BANK_APPROVED" Тогда
		Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОдобреноБанком;
	ИначеЕсли СостояниеСтрокой = "BANK_DECLINED" Тогда
		Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтклоненоБанком;
	Иначе
		Состояние = Перечисления.СостоянияЛьготныхЗаявок.ОтправленоВФНС;
	КонецЕсли;
	
	Возврат Состояние;

КонецФункции

Функция ПараметрыЗаявки(ВходящийКонтекст)
	
	Заявка = ВходящийКонтекст.Заявка;
	ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Заявка.Организация);
	
	Параметры = Новый Структура();
	Параметры.Вставить("bankId", Заявка.ИдентификаторБанка);
	Параметры.Вставить("requestedAmount", Заявка.ЗапрашиваемаяСуммаКредита);
	Параметры.Вставить("period", Заявка.СрокКредитования);
	Параметры.Вставить("personalCount", Заявка.ЧисленностьСотрудников);
	Параметры.Вставить("companyName", СокрЛП(Заявка.НаименованиеОрганизации));
	Параметры.Вставить("companyInn", СокрЛП(Заявка.ИНН));
	Параметры.Вставить("companyOgrn", СокрЛП(Заявка.ОГРН));
	
	Если ЭтоЮридическоеЛицо Тогда
		Параметры.Вставить("companyKpp", СокрЛП(Заявка.КПП));
	КонецЕсли;
	
	ФИО = Новый Массив;
	ФИО.Добавить(СокрЛП(Заявка.ФамилияРуководителя));
	ФИО.Добавить(СокрЛП(Заявка.ИмяРуководителя));
	ФИО.Добавить(СокрЛП(Заявка.ОтчествоРуководителя));
	
	ФИО = СтрСоединить(ФИО, " ");
	
	Параметры.Вставить("directorFullName", ФИО);

	Возврат Параметры;
	
КонецФункции

Процедура ДобавитьПротокол(АдресСервиса, СПротоколом)
	
	Если СПротоколом Тогда
		АдресСервиса = "https://" + АдресСервиса;
	КонецЕсли;
	
КонецПроцедуры

Функция ЧтоДелатьПриНедоступностиСервера() Экспорт
	
	ЭтоФайловаяБаза = ОбщегоНазначения.ИнформационнаяБазаФайловая();

	Если ЭтоФайловаяБаза Тогда
		Текст = НСтр("ru = 'Что делать?
                      |Проверьте, что из программы доступны следующие внешние ресуры:'");
	Иначе
		Текст = НСтр("ru = 'Что делать?
                      |Проверьте, что с сервера доступны следующие внешние ресуры:'");
	КонецЕсли;
	
	Текст = Текст + Символы.ПС 
		+ "- " + АдресСервераАутентификации(Истина)
		+ Символы.ПС 
		+ "- " + АдресСервераДанных(Истина);
	
	Возврат Текст;
	
КонецФункции

Функция ЧтоДелатьПослеОдобрения(Заявка) Экспорт
	
	ЧтоДальше = НСтр("ru = 'Для получения кредита свяжитесь с банком '") + Заявка.НаименованиеБанка + ".";
	ДобавитьКонтактыБанка(Заявка, ЧтоДальше);
	
	Возврат Новый ФорматированнаяСтрока(ЧтоДальше);

КонецФункции

Процедура ДобавитьКонтактыБанка(Заявка, Текст) Экспорт
	
	КонтактыБанка = СокрЛП(Заявка.КонтактыБанка);
	Если ЗначениеЗаполнено(КонтактыБанка) Тогда
		
		КонтактыБанка = Новый ФорматированнаяСтрока(КонтактыБанка, Новый Шрифт(, , Истина));
		Текст = Новый ФорматированнаяСтрока(
			Текст, 
			Символы.ПС,
			Символы.ПС,
			КонтактыБанка);
		
	КонецЕсли;

КонецПроцедуры

#Область ИзименяемыеЗначения

Процедура СкорректироватьРезультатВРежимеТестирования(Результат)
	
	ЭтоРежимТестирования = Ложь;
	
	Если ЭтоРежимТестирования Тогда
		
		Если Результат.Свойство("Состояние") Тогда
			
			ОтветПоложительный = Ложь;
			
			Если ОтветПоложительный Тогда
				Результат.Вставить("ОдобреннаяСуммаКредита",  1000000);
				Результат.Вставить("Состояние",      Перечисления.СостоянияЛьготныхЗаявок.ОдобреноБанком);
				Результат.Вставить("КонтактыБанка",  "8 (800) 200-62-00");
				
			Иначе
				Результат.Вставить("ПричинаОтклоненияБанком", НСтр("ru = 'Предоставлены недостоверные сведения'"));
				Результат.Вставить("Состояние",  Перечисления.СостоянияЛьготныхЗаявок.ОтклоненоБанком);
			КонецЕсли;
		КонецЕсли;
		
		Если Результат.Свойство("ИдентификаторЗаявки") Тогда
			Результат.Вставить("ИдентификаторЗаявки",  "тест");
		КонецЕсли;
		
		Результат.Вставить("ОписаниеОшибки", "");
		Результат.Вставить("Выполнено",      Истина);
			
	КонецЕсли;

КонецПроцедуры

Функция АдресСервераАутентификации(СПротоколом = Ложь) Экспорт
	
	ЭтоРежимТестирования = ЛьготныеКредиты.ИспользуетсяРежимТестирования(); 
	
	Если ЭтоРежимТестирования Тогда
		АдресСервиса = "identity.credit-fns.astral-dev.ru";
	Иначе
		АдресСервиса = "identity-credit-fns.astral.ru";
	КонецЕсли;
	ДобавитьПротокол(АдресСервиса, СПротоколом);
	
	Возврат АдресСервиса;
	
КонецФункции

Функция АдресСервераДанных(СПротоколом = Ложь) Экспорт
	
	ЭтоРежимТестирования = ЛьготныеКредиты.ИспользуетсяРежимТестирования(); 
	
	Если ЭтоРежимТестирования Тогда
		АдресСервиса = "credit-fns.astral-dev.ru";
	Иначе
		АдресСервиса = "credit-fns.astral.ru";
	КонецЕсли;
	
	ДобавитьПротокол(АдресСервиса, СПротоколом);
	
	Возврат АдресСервиса;
	
КонецФункции

Процедура СохранитьРеквизитыЗаявки(Заявка, Результат) Экспорт
	
	ЗаявкаОбъект = Заявка.ПолучитьОбъект();
	ЗаполнитьЗначенияСвойств(ЗаявкаОбъект, Результат);
	ЗаявкаОбъект.Записать();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли


#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	Если НЕ ЛьготныеКредитыКлиентСервер.ЗаявкиПринимаются() Тогда
		
		Если ВидФормы = "ФормаОбъекта" И ТипЗнч(Параметры) = Тип("Структура") И НЕ Параметры.Свойство("Ключ") Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "Документ.ЗаявкиНаЛьготныйКредит.Форма.ПриемЗаявокПриостановлен";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти