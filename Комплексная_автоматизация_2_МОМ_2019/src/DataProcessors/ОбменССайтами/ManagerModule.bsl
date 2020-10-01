
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция СоздатьСайт(ВходящиеПараметры, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ДанныеСайта = ДанныеСозданияСайта(ВходящиеПараметры);
	
	Если ТипЗнч(ДанныеСайта)= Тип("Соответствие") Тогда
		
		ЗаписатьДанныеСайта(ВходящиеПараметры, ДанныеСайта);
		
		СайтСоздан = ДанныеСайта.Получить("ready");
		ОжиданиеСозданияСайта = ДанныеСайта.Получить("waiting");
		
		ВходящиеПараметры.Вставить("СайтСоздан", СайтСоздан);
		ВходящиеПараметры.Вставить("ОжиданиеСозданияСайта", ОжиданиеСозданияСайта);
		
	ИначеЕсли ТипЗнч(ДанныеСайта)= Тип("Структура") Тогда
		ВходящиеПараметры.Вставить("Ошибка", ДанныеСайта.Ошибка);
	Иначе
		ВходящиеПараметры.Вставить("Ошибка", ДанныеСайта);
	КонецЕсли;

	ПоместитьВоВременноеХранилище(ВходящиеПараметры, ФоновоеЗаданиеАдресХранилища);
	
КонецФункции

Функция ДанныеСозданияСайта(ВходящиеПараметры) Экспорт
		
	ТипСайта = ВходящиеПараметры.ТипСайта;
	ДанныеАвторизации = ДанныеДляАвторизации();
	Если ТипСайта=1 Тогда
		ТипСайтаИД = 1;
	ИначеЕсли ТипСайта=2 Тогда
		ТипСайтаИД = 10;
	ИначеЕсли ТипСайта=3 Тогда
		ТипСайтаИД = 2;
	ИначеЕсли ТипСайта=4 Тогда
		ТипСайтаИД = 11;
	КонецЕсли;
	АдресСайта = ВходящиеПараметры.ИмяСайта+".1c-umi.ru";
	АдресЗапроса= ДанныеАвторизации.Получить("АдресЗапроса");
	РазделительТелаЗапроса = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");	
	ContentType = "multipart/form-data; charset=UTF-8; boundary=" + РазделительТелаЗапроса;
	ТекстОтправки = "";
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "partner", ДанныеАвторизации.Получить("partner"), РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "code", ДанныеАвторизации.Получить("code"), РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "host", ВходящиеПараметры.АдресСайта, РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "action", "host_install", РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "email", ВходящиеПараметры.EmailРегистрацииСайта, РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "appID", ТипСайтаИД, РазделительТелаЗапроса);
	Если ВходящиеПараметры.Свойство("ДизайнИД") Тогда
		ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "desID",ВходящиеПараметры.ДизайнИД, РазделительТелаЗапроса);
	КонецЕсли;
	
	СтруктураДанныхСоздания = Новый Структура;
	СтруктураДанныхСоздания.Вставить("ТелоЗапроса", ТекстОтправки);
	
	СтруктураДанныхСоздания.Вставить("АдресЗапроса",
		ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресЗапроса));
		
	ТекстОшибки = "";	
	ДанныеСтрока = ПолучитьДанныеЗапросом("POST", СтруктураДанныхСоздания.ТелоЗапроса, СтруктураДанныхСоздания.АдресЗапроса, Новый Структура,
		ContentType,ТекстОшибки);
		
	Если ТекстОшибки<>"" Тогда
		Возврат ТекстОшибки;
	КонецЕсли;
		
	Если Лев(ДанныеСтрока,6) = "<html>" Тогда
		ТекстОшибки = Сред(ДанныеСтрока, СтрНайти(ДанныеСтрока, "<title>")+7, СтрНайти(ДанныеСтрока, "</title>")-СтрНайти(ДанныеСтрока, "<title>")-7);
		ДанныеСайтаСтруктура = Новый Структура("Ошибка", ТекстОшибки);
		Возврат ДанныеСайтаСтруктура;
	ИначеЕсли Лев(ДанныеСтрока,1) = "{" Тогда
		ДанныеСайта = ПрочитатьРеквизитJSON(ДанныеСтрока, "result");
		Если ТипЗнч(ДанныеСайта)= Тип("Соответствие") Тогда
			
			Возврат ДанныеСайта;
			
		Иначе
			ТекстОшибки = ДанныеСайта.Получить("errors");
			Возврат ТекстОшибки;
		КонецЕсли;
	Иначе
		Возврат ДанныеСтрока;
	КонецЕсли;
	
КонецФункции

Функция СоздатьСайтПродолжить(ВходящиеПараметры, ФоновоеЗаданиеАдресХранилища = "") Экспорт
	
	ЗаписатьКонтактнуюИнформацию(ВходящиеПараметры.АдресСайта, ВходящиеПараметры.ПарольСайта, ВходящиеПараметры.ОсновнаяОрганизация, ВходящиеПараметры.ТипСайта);
	
	Если ВходящиеПараметры.ТипСайта=4 Тогда
		
	    ЗначениеОтображатьОстатки = ?(ВходящиеПараметры.ВыгружатьОстатки, "true", "false"); 
		// 1-отображать остатки, товары без остатка будут не видны.
		// 0 - видны все товары, остаток отображается в режиме редактирования.
		ЗаписатьПоляСайта(ВходящиеПараметры.АдресСайта, ВходящиеПараметры.ПарольСайта, "dlya_vstavki", "emarket_set_invisible_when_import", ЗначениеОтображатьОстатки);
		
	    ЗначениеОтображатьХарактеристики = "true";
		// 1-отображать остатки, товары без остатка будут не видны.
		// 0 - видны все товары, остаток отображается в режиме редактирования.
		ЗаписатьПоляСайта(ВходящиеПараметры.АдресСайта, ВходящиеПараметры.ПарольСайта, "dlya_vstavki", "new_offers_import", ЗначениеОтображатьХарактеристики);
		
		СоздатьУзелОбменаССайтом(ВходящиеПараметры,
			ВходящиеПараметры.АдресСайта, 
			ВходящиеПараметры.ИДСайта, 
			ВходящиеПараметры.ПарольСайта);
			
		ЗапуститьОбменССайтом(ВходящиеПараметры.ИДСайта);
		
	Иначе
		// в разработке.
	КонецЕсли;
	
	ВходящиеПараметры.Вставить("ОбменВыполнен", Истина);
	ПоместитьВоВременноеХранилище(ВходящиеПараметры, ФоновоеЗаданиеАдресХранилища);
	
КонецФункции

Функция ДанныеДляАвторизации() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить("partner", "Test1C");
	Результат.Вставить("code", "26a63f89a737125b418492ff70ae1567");
	Результат.Вставить("АдресЗапроса", "http://gate.umi.ru/partnerapi");
					 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьДанныеЗапросом(HTTPМетод, ТелоЗапроса, АдресЗапроса, ЗаголовкиЗапроса, ContentType="", ТекстОшибки="")
	
	HTTPСоединение = Новый HTTPСоединение(
	АдресЗапроса.Хост,
	АдресЗапроса.Порт,,,,180,
	ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
	
	Если ContentType="" Тогда
		ContentType = "application/json;charset=utf-8";
	КонецЕсли;
	
	ЗапросHTTP = Новый HTTPЗапрос(АдресЗапроса.ПутьНаСервере);
	ЗапросHTTP.Заголовки["Cache-Control"]	= "no-cache";
	ЗапросHTTP.Заголовки["Content-type"]	= ContentType;
	Для каждого стр Из ЗаголовкиЗапроса Цикл
		ЗапросHTTP.Заголовки[стр.Ключ]	= стр.Значение;
	КонецЦикла;
	
	Если ТипЗнч(ТелоЗапроса)=Тип("Строка") Тогда
		ЗапросHTTP.УстановитьТелоИзСтроки(ТелоЗапроса,"UTF-8",ИспользованиеByteOrderMark.НеИспользовать);
	ИначеЕсли ТипЗнч(ТелоЗапроса)=Тип("ДвоичныеДанные") Тогда
		ЗапросHTTP.УстановитьТелоИзДвоичныхДанных(ТелоЗапроса);
	КонецЕсли; 
	
	Попытка
		Если HTTPМетод="GET" Тогда
		    ОтветHTTP = HTTPСоединение.Получить(ЗапросHTTP);
		ИначеЕсли HTTPМетод="POST" Тогда
			ОтветHTTP = HTTPСоединение.ОтправитьДляОбработки(ЗапросHTTP);
		ИначеЕсли HTTPМетод="PUT" Тогда
			ОтветHTTP = HTTPСоединение.Записать(ЗапросHTTP);
		ИначеЕсли HTTPМетод="DELETE" Тогда	
			ОтветHTTP = HTTPСоединение.Удалить(ЗапросHTTP);
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Если СтрНайти(ТекстОшибки, "Couldn't resolve host name")<>0 Тогда
		    ТекстОшибки = НСтр("ru = 'Ошибка: Нет подключения к интернету'");
		КонецЕсли;
		Возврат "";
	КонецПопытки;
	
	Если ОтветHTTP.КодСостояния<>200 Тогда
		ОбщегоНазначения.СообщитьПользователю(ОтветHTTP.КодСостояния);
	КонецЕсли;

	ОтветКакСтрока = ОтветHTTP.ПолучитьТелоКакСтроку();
	Возврат ОтветКакСтрока;	
	
КонецФункции

Процедура СоздатьУзелОбменаССайтом(ВходящиеПараметры, АдресСайта, ИДСайта, Пароль="")
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОбменССайтом.Ссылка КАК ПланОбмена
	|ИЗ
	|	ПланОбмена.ОбменССайтом КАК ОбменССайтом
	|ГДЕ
	|	ОбменССайтом.Код = &ИДСайта";
	
	Запрос.УстановитьПараметр("ИДСайта", ИДСайта);
	
	Результат = Запрос.Выполнить();
	НачатьТранзакцию();
	Попытка
		Если Результат.Пустой() Тогда
			ПланОбменаСайт = ПланыОбмена.ОбменССайтом.СоздатьУзел();
		Иначе
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				ПланОбменаСайт = ЭлектронноеВзаимодействиеСлужебный.ОбъектПоСсылкеДляИзменения(Выборка.ПланОбмена);
			КонецЦикла;
		КонецЕсли;
		
		ПланОбменаСайт.АдресСайта = "https://"+АдресСайта+"/admin/exchange/autoimport/";
		
		ПланОбменаСайт.ВыгружатьКартинки			= Истина;
		ПланОбменаСайт.ВыгружатьНаСайт				= Истина;
		ПланОбменаСайт.ВладелецКаталога				= ВходящиеПараметры.ОсновнаяОрганизация;
		ПланОбменаСайт.ВыгружатьИзменения			= Истина;
		ПланОбменаСайт.ИмяПользователя				= ВходящиеПараметры.ИмяСайта;
		ПланОбменаСайт.Код							= ИДСайта;
		ПланОбменаСайт.Наименование					= НСтр("ru = 'Обмен товарами и заказами с'") +" "+ АдресСайта;
		ПланОбменаСайт.ОбменТоварами				= Истина;
		ПланОбменаСайт.ВыгружатьТовары              = Истина;
		ПланОбменаСайт.ВыгружатьЦеныОстатки         = Истина;
		ПланОбменаСайт.ВидОтбораПоНоменклатуре = ВходящиеПараметры.ОтборКатегорииГруппыПереключатель;
		
		ТаблицаКаталогов = ХранилищеСистемныхНастроек.Загрузить("ТаблицаКаталоговСозданияСайта");
		ПланОбменаСайт.СохраненнаяТаблицаКаталогов = Новый ХранилищеЗначения(ТаблицаКаталогов);
		
		ИмяСправочникаСклады = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("Склады");
		ДополнительныеРеквизиты = Новый Структура("СписокТочекСамовывоза", Справочники[ИмяСправочникаСклады].ПустаяСсылка());
		СохраненныеНастройки = Новый Структура("ПараметрыПрикладногоРешения", ДополнительныеРеквизиты);
		ПланОбменаСайт.ПараметрыПрикладногоРешения = Новый ХранилищеЗначения(СохраненныеНастройки);
		
		Если ВходящиеПараметры.Свойство("ДанныеСайтаСсылка") Тогда
			ПланОбменаСайт.ДанныеСайта = ВходящиеПараметры.ДанныеСайтаСсылка;
		КонецЕсли;
		
		ПланОбменаСайт.Записать();
			
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ПланОбменаСайт.Ссылка, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначения.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
		
КонецПроцедуры

Функция ПрочитатьРеквизитJSON(ДанныеСтрока, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(ДанныеСтрока) Тогда
		Возврат 0;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеСтрока);
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);
	РеквизитЗначение = Результат.Получить(ИмяРеквизита);
	
	Возврат РеквизитЗначение;
	
КонецФункции

Процедура ЗапуститьОбменССайтом(КодУзлаОбмена)
	
	УзелОбмена = ПланыОбмена.ОбменССайтом.НайтиПоКоду(КодУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(УзелОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ИспользоватьОбменССайтом.Установить(Истина);
	
	ОбменССайтомСобытия.ВыполнитьОбмен(УзелОбмена, НСтр("ru = 'Обмен полный при создании сайта'"), Ложь);

КонецПроцедуры

Функция ЗаписатьДанныеСайта(ВходящиеПараметры, РезультатСозданияСайта)
	
	ПолученныйАдресСайта = РезультатСозданияСайта.Получить("host");
	ИДСайта = РезультатСозданияСайта.Получить("id");
	ЛогинСайта = РезультатСозданияСайта.Получить("login");
	ПарольСайта = РезультатСозданияСайта.Получить("password");
	СсылкаАдминЗоны	= РезультатСозданияСайта.Получить("autologinUrl");
	
	НовСтр = Справочники.Сайты.СоздатьЭлемент();
	НовСтр.Организация	= ВходящиеПараметры.ОсновнаяОрганизация;
	НовСтр.АдресСайта	= ВходящиеПараметры.АдресСайта;
	НовСтр.Наименование	= ВходящиеПараметры.АдресСайта;
	НовСтр.Код			= ИДСайта;
	НовСтр.ТипСайта		= ВходящиеПараметры.ТипСайта;
	НовСтр.ИмяПользователя = ВходящиеПараметры.EmailРегистрацииСайта;
	НовСтр.URLАдминЗоны	= СсылкаАдминЗоны;
	
	Попытка
		НовСтр.ОбменДанными.Загрузка = Истина;
		НовСтр.Записать();
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(НовСтр.Ссылка, ПарольСайта);
		УстановитьПривилегированныйРежим(Ложь);
		
		Константы.СайтСоздан.Установить(Истина);
	Исключение
		ВходящиеПараметры.Вставить("Ошибка", ОписаниеОшибки());
	КонецПопытки;
	
	ВходящиеПараметры.Вставить("ИДСайта",		ИДСайта);
	ВходящиеПараметры.Вставить("АдресСайта",	ПолученныйАдресСайта);
	ВходящиеПараметры.Вставить("ЛогинСайта",	ЛогинСайта);
	ВходящиеПараметры.Вставить("ПарольСайта",	ПарольСайта);
	ВходящиеПараметры.Вставить("СсылкаАдминЗоны",СсылкаАдминЗоны);
	ВходящиеПараметры.Вставить("ДанныеСайтаСсылка", НовСтр.Ссылка);
	
КонецФункции

Процедура ЗаписатьКонтактнуюИнформацию(АдресСайта, ПарольСайта, ОсновнаяОрганизация, ТипСайта)

	ФактАдресОрганизации = КонтактнаяИнформация(ОсновнаяОрганизация, "ФактАдресОрганизации");
	ТелефонОрганизации = КонтактнаяИнформация(ОсновнаяОрганизация, "ТелефонОрганизации");
	ФаксОрганизации = КонтактнаяИнформация(ОсновнаяОрганизация, "ФаксОрганизации");
	EmailОрганизации = КонтактнаяИнформация(ОсновнаяОрганизация, "EmailОрганизации");
	SkypeОрганизации = КонтактнаяИнформация(ОсновнаяОрганизация, "Skype");
		
	НаименованиеОрганизации = ОсновнаяОрганизация.Наименование;
		
	Если ТипСайта=4 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "imya_i_familiya",НаименованиеОрганизации);
		
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", 		ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "address", 	ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", 	ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 3 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", 		ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "address", 	ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", 	ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 2 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "address", ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "full_phone",	ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "dlya_vstavki", "telefon",ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "fax", ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "contacts", "skype", SkypeОрганизации);
	ИначеЕсли ТипСайта = 1 Тогда
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "address", ФактАдресОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "full_phone", ТелефонОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "fax", ФаксОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "email", EmailОрганизации);
		ЗаписатьПоляСайта(АдресСайта, ПарольСайта, "kontakty", "skype", SkypeОрганизации);
	КонецЕсли;
	
КонецПроцедуры

// Функция находит актуальное значение контактной информации.
// Параметры:
//  Объект       - СправочникСсылка, объект контактной информации.
//  ВидКонтактнойИнформации - строка - наименование предопределенного или обычного элемента
//										справочника ВидыКонтактнойИнформации.
//	
// Возвращаемое значение
//  Строка - представление найденного адреса.
//
Функция КонтактнаяИнформация(ОбъектКонтактнойИнформации, ВидКонтактнойИнформации) Экспорт
	
	КонтактнаяИнформацияПредставление = "";
		
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		
		МодульКонтактнойИнформации = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		
		МетаданныеВидыКонтактнойИнформации = Метаданные.Справочники.Найти("ВидыКонтактнойИнформации");
		Если МетаданныеВидыКонтактнойИнформации = Неопределено Тогда
			Возврат КонтактнаяИнформацияПредставление;
		КонецЕсли;
		
		ВидыКонтактнойИнформации = Справочники["ВидыКонтактнойИнформации"];
		
		Попытка 
			ВидИнформации = ВидыКонтактнойИнформации[ВидКонтактнойИнформации];//.Найти(ТипКонтактнойИнформации);
		Исключение
			ВидИнформации = ВидыКонтактнойИнформации.НайтиПоНаименованию(ВидКонтактнойИнформации);
		КонецПопытки;
		
		Если ЗначениеЗаполнено(ВидИнформации) Тогда
			
			КонтактнаяИнформацияПредставление = МодульКонтактнойИнформации.ПредставлениеКонтактнойИнформацииОбъекта(ОбъектКонтактнойИнформации,
				ВидИнформации, ,ТекущаяДатаСеанса());
				
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат КонтактнаяИнформацияПредставление;

КонецФункции

Процедура ЗаписатьПоляСайта(АдресСайта, ПарольСайта, РазделСайта, ИмяПоля, ЗначениеПоля)
	
	Если НЕ ЗначениеЗаполнено(ЗначениеПоля) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеАвторизации = ДанныеДляАвторизации();
	АдресЗапроса= ДанныеАвторизации.Получить("АдресЗапроса");
	
	РазделительТелаЗапроса = СтрЗаменить(Строка(Новый УникальныйИдентификатор()), "-", "");	
	ContentType = "multipart/form-data; charset=UTF-8; boundary=" + РазделительТелаЗапроса;
	ТекстОтправки = "";
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "partner", 	ДанныеАвторизации.Получить("partner"), РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "code", 	ДанныеАвторизации.Получить("code"), РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "host", 	АдресСайта, РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "action", 	"put_config_fields", РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "password", ПарольСайта, РазделительТелаЗапроса);
	ДобавитьПараметрВТелоЗапроса(ТекстОтправки, "Fields["+РазделСайта+"|"+ИмяПоля+"]", ЗначениеПоля, РазделительТелаЗапроса);
	
	СтруктураДанныхСоздания = Новый Структура;
	СтруктураДанныхСоздания.Вставить("ТелоЗапроса", ТекстОтправки);
	
	СтруктураДанныхСоздания.Вставить("АдресЗапроса",
		ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресЗапроса));
		
	ТекстОшибки = "";
	ДанныеСтрока = ПолучитьДанныеЗапросом("POST", СтруктураДанныхСоздания.ТелоЗапроса, СтруктураДанныхСоздания.АдресЗапроса, Новый Структура,
		ContentType,ТекстОшибки);
		
	Если ТекстОшибки="" Тогда
		ДанныеУспешноЗаписаны = ПрочитатьРеквизитJSON(ДанныеСтрока, "result");
		Если ДанныеУспешноЗаписаны Тогда
			
		Иначе
			ТекстОшибки = ПрочитатьРеквизитJSON(ДанныеСтрока, "errors");
			Если ТипЗнч(ТекстОшибки)=Тип("Массив") Тогда
				Для каждого стр Из ТекстОшибки Цикл
				    ОбщегоНазначения.СообщитьПользователю(стр);
				КонецЦикла;
			Иначе
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПараметрВТелоЗапроса(ТекстОтправки, ИмяПараметра, ЗначениеПараметра, РазделительТелаЗапроса)
	
	Если ТекстОтправки="" Тогда
		ДобавитьСтрокуСРазделителем(ТекстОтправки, "--" + РазделительТелаЗапроса);
	КонецЕсли;
	
	ДобавитьСтрокуСРазделителем(ТекстОтправки, "Content-disposition: form-data; name="+ИмяПараметра+"" + Символы.ПС);
	ДобавитьСтрокуСРазделителем(ТекстОтправки, ЗначениеПараметра);
	ДобавитьСтрокуСРазделителем(ТекстОтправки, "--" + РазделительТелаЗапроса);
	
КонецПроцедуры

Процедура ДобавитьСтрокуСРазделителем(НачСтрока, ДобавитьТекст)
	
	НачСтрока = НачСтрока + ДобавитьТекст + Символы.ПС;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли