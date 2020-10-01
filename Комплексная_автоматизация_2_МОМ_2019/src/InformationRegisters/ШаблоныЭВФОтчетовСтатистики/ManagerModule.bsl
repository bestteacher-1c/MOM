#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура обновления БРО
// загружает избранные шаблоны статистики
Процедура ЗагрузитьРекомендуемыеЭлектронныеПредставления(Параметры = Неопределено) Экспорт
	
	Перем АдресВременногоХранилища;
	
	КоличествоНезагруженныхШаблонов = 0;
	
	Попытка
		ДобавитьШаблоныИзКонфигурации(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов);
	Исключение
		СтрОш = НСтр("ru = 'Не удалось получить шаблоны для обновления'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
	Попытка
		ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов);
	Исключение
		СтрОш = НСтр("ru = 'Не удалось распаковать шаблоны для обновления'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат;
	КонецПопытки;
	
КонецПроцедуры

Процедура ДобавитьШаблоныИзКонфигурации(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов)
	
	ВремФайлАрхиваШаблонов = ПолучитьИмяВременногоФайла("zip");
	АрхивШаблоновЭВФДвоичныеДанные = РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.ПолучитьМакет("ОбновляемыеШаблоны");
	Попытка
		АрхивШаблоновЭВФДвоичныеДанные.Записать(ВремФайлАрхиваШаблонов);
	Исключение
		УдалитьФайлы(ВремФайлАрхиваШаблонов);
		ВызватьИсключение "Не удалось сохранить архив шаблонов ЭВФ во временный файл." + Символы.ПС + ОписаниеОшибки();
	КонецПопытки;
	
	ВремКаталог = ПолучитьИмяВременногоФайла("");
	ВремКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВремКаталог);
	СоздатьКаталог(ВремКаталог);
	
	Попытка
		ЗИП = Новый ЧтениеZipФайла(ВремФайлАрхиваШаблонов);
		ЗИП.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ЗИП.Закрыть();
	Исключение
		УдалитьФайлы(ВремКаталог);
		ВызватьИсключение "Не удалось распаковать архив шаблонов ЭВФ.
				|" + ИнформацияОбОшибке().Описание;
		Возврат;
	КонецПопытки;
	
	ОбъектыФайл = НайтиФайлы(ВремКаталог, "*.xml", Ложь);
	
	ШаблоныЭВФ = Новый Массив;
	
	Для Каждого ОбъектФайл Из ОбъектыФайл Цикл
		
		Если ОбъектФайл.Существует() Тогда
			
			ШаблонЭВФ = Новый Структура;
			ШаблонЭВФ.Вставить("ИмяФайлаШаблона", НРег(ОбъектФайл.Имя));
			ШаблонЭВФ.Вставить("Размер", ОбъектФайл.Размер());
			
			Попытка
				ШаблонЭВФ.Вставить("Шаблон", Новый ДвоичныеДанные(ОбъектФайл.ПолноеИмя));
				ШаблоныЭВФ.Добавить(ШаблонЭВФ);
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось загрузить XML-шаблон ""%1"":%2'"), ОбъектФайл.Имя, Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
				
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор);
	
	УдалитьФайлы(ВремФайлАрхиваШаблонов);
	Попытка
		УдалитьФайлы(ВремКаталог);
	Исключение
		СтрОш = НСтр("ru = 'Не удалось удалить временные файлы'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Предупреждение,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

Функция ДатаВерсии(СтрДата)
	
	Разделители = "-.,/";
	
	ДлинаСтроки = СтрДлина(СтрДата);
	
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("");
	
	Для НС = 1 По ДлинаСтроки Цикл
		Сим = Сред(СтрДата, НС, 1);
		Если СтрНайти(Разделители, Сим) > 0 Тогда
			МассивПолей.Добавить("");
		ИначеЕсли СтрНайти("0123456789", Сим) > 0 Тогда
			МассивПолей[МассивПолей.ВГраница()] = МассивПолей[МассивПолей.ВГраница()] + Сим;
		КонецЕсли;
	КонецЦикла;
	
	День  = Макс(1, Число("0" + СокрЛП(МассивПолей[0])));
	Месяц = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 1, "1", СокрЛП(МассивПолей[1]))));
	Год   = Макс(1, Число("0" + ?(МассивПолей.ВГраница() < 2, "1", СокрЛП(МассивПолей[2]))));
	
	Возврат Дата(Год, Месяц, День);
	
КонецФункции

Функция ДобавитьРеквизитыИзФайлаШаблона(РеквизитыШаблона)
	
	Если ТипЗнч(РеквизитыШаблона) <> Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВремФайлШаблона = ПолучитьИмяВременногоФайла("." + РеквизитыШаблона.ИмяФайлаШаблона);
	
	Попытка
		РеквизитыШаблона.Шаблон.Записать(ВремФайлШаблона);
	Исключение
		УдалитьФайлы(ВремФайлШаблона);
		Возврат Ложь;
	КонецПопытки;

	АтрибутыШаблона = Новый Соответствие;
	ОбъектЧтениеXML = Новый ЧтениеXML;
	
	Попытка
		
		ОбъектЧтениеXML.ОткрытьФайл(ВремФайлШаблона);
		ОбъектЧтениеXML.ИгнорироватьПробелы = Ложь;
		
		Пока ОбъектЧтениеXML.Прочитать() Цикл
			Если ОбъектЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				Если НРег(ОбъектЧтениеXML.Имя) = "metaform" Тогда
					Пока ОбъектЧтениеXML.ПрочитатьАтрибут() Цикл
						Если АтрибутыШаблона[ОбъектЧтениеXML.Имя] = Неопределено Тогда
							АтрибутыШаблона.Вставить(СтрЗаменить(ОбъектЧтениеXML.Имя, "-", "_"), ОбъектЧтениеXML.Значение);
						КонецЕсли;
					КонецЦикла;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		ОбъектЧтениеXML.Закрыть();
		
		УдалитьФайлы(ВремФайлШаблона);
		
	Исключение
		
		УдалитьФайлы(ВремФайлШаблона);
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Если АтрибутыШаблона.Количество() = 0 Тогда
	
		Возврат Ложь;
	
	КонецЕсли;
	
	РеквизитыШаблона.Вставить("ОКУД",             АтрибутыШаблона["OKUD"]);
	РеквизитыШаблона.Вставить("КодШаблона",       АтрибутыШаблона["code"]);
	РеквизитыШаблона.Вставить("Наименование",     ВРег(Лев(АтрибутыШаблона["name"], 1)) + Сред(АтрибутыШаблона["name"], 2));
	РеквизитыШаблона.Вставить("КодПериодичности", Число("0" + АтрибутыШаблона["idp"]));
	РеквизитыШаблона.Вставить("КодФормы",         Число("0" + АтрибутыШаблона["idf"]));
	РеквизитыШаблона.Вставить("Шифр",             АтрибутыШаблона["shifr"]);
	РеквизитыШаблона.Вставить("Версия",           АтрибутыШаблона["version"]);
	РеквизитыШаблона.Вставить("ВерсияФормата",    АтрибутыШаблона["format_version"]);
	
	Возврат Истина;
	
КонецФункции

Процедура ЗагрузитьШаблоны(АдресВременногоХранилища, КоличествоНезагруженныхШаблонов, ТихийРежим = Ложь) Экспорт 
	ШаблоныЭВФ = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	
	Для Каждого ШаблонЭВФ Из ШаблоныЭВФ Цикл
		
		Если НЕ ДобавитьРеквизитыИзФайлаШаблона(ШаблонЭВФ) Тогда
			Если Не ТихийРежим Тогда 
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не распознан формат XML-шаблона ""%1""'"), ШаблонЭВФ.ИмяФайлаШаблона));
			КонецЕсли;
			
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			Продолжить;
		КонецЕсли;
		
		Если СтрНайти(ШаблонЭВФ.ВерсияФормата, "1.3") = 0 Тогда
			Если Не ТихийРежим Тогда 
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Версия формата XML-шаблона ""%1"" не соответствует версии ""1.3""'"), ШаблонЭВФ.ИмяФайлаШаблона));
			КонецЕсли;
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
			Продолжить;
		КонецЕсли;
		
		Если СтрНачинаетсяС(ШаблонЭВФ.ИмяФайлаШаблона, ШаблонЭВФ.ОКУД + "_") Тогда 
			ИмяФайлаШаблона = ШаблонЭВФ.ИмяФайлаШаблона;
		Иначе
			ИмяФайлаШаблона = ШаблонЭВФ.ОКУД + "_" + ШаблонЭВФ.ИмяФайлаШаблона;
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.ШаблоныЭВФОтчетовСтатистики.СоздатьМенеджерЗаписи();
		
		ИмяФайлаБезКода = СтрЗаменить(ИмяФайлаШаблона, ШаблонЭВФ.ОКУД + "_", "");
		МенеджерЗаписи.ИмяФайлаШаблона = ИмяФайлаБезКода;
		МенеджерЗаписи.Прочитать();
		Если МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.Удалить();
		КонецЕсли;
		
		МенеджерЗаписи.ИмяФайлаШаблона = ИмяФайлаШаблона;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() Тогда
			Если ДатаВерсии(МенеджерЗаписи.Версия) > ДатаВерсии(ШаблонЭВФ.Версия) Тогда
				
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				
				Продолжить;
				
			КонецЕсли;
		КонецЕсли;
		
		МенеджерЗаписи.ИмяФайлаШаблона  = ИмяФайлаШаблона;
		
		МенеджерЗаписи.ОКУД             = Прав("000000000" + ШаблонЭВФ.ОКУД, 7);
		МенеджерЗаписи.КодШаблона       = ШаблонЭВФ.КодШаблона;
		МенеджерЗаписи.Наименование     = ШаблонЭВФ.Наименование;
		МенеджерЗаписи.КодПериодичности = ШаблонЭВФ.КодПериодичности;
		МенеджерЗаписи.КодФормы         = ШаблонЭВФ.КодФормы;
		МенеджерЗаписи.Шифр             = ШаблонЭВФ.Шифр;
		МенеджерЗаписи.Версия           = ШаблонЭВФ.Версия;
		
		МенеджерЗаписи.Размер           = ШаблонЭВФ.Размер;
		МенеджерЗаписи.ДатаДобавления   = ТекущаяДатаСеанса();
		
		Попытка
			
			МенеджерЗаписи.Шаблон = Новый ХранилищеЗначения(ШаблонЭВФ.Шаблон, Новый СжатиеДанных(8));
			МенеджерЗаписи.Записать(Истина);
			
		Исключение
			Если Не ТихийРежим Тогда 
				ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось записать XML-шаблон ""%1"":%2'"), ШаблонЭВФ.ИмяФайлаШаблона, Символы.ПС + ОписаниеОшибки()));
			КонецЕсли;
			
			КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
		КонецПопытки;
		
	КонецЦикла;
КонецПроцедуры

#Область ОбновлениеШаблоновЧерезСервисВебСбора

Функция ПолучитьТаймаутДляВебСервисаСбора()
	Попытка
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда 
			Если ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Состояние", СостояниеФоновогоЗадания.Активно)).Количество() > 0
				И ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ", РегламентированнаяОтчетностьПовтИсп.ПолучитьКлючЗаданияОбновленияШаблонов())).Количество() = 0 Тогда 
				
				Возврат 4;
			КонецЕсли;
		КонецЕсли;
	Исключение
		Возврат 90;
	КонецПопытки;
	
	Возврат 90;
КонецФункции

// Выполняется в фоновом задании
Процедура ЗагрузитьШаблоныЧерезСервисВебСбора(ПараметрыПроцедуры, АдресРезультата, АдресДополнительногоРезультата) Экспорт
	
	Перем СвойстваШаблонов;
	Перем АдресСервера;
	
	ПараметрыПроцедуры.Свойство("СвойстваШаблонов", СвойстваШаблонов);
	ТихийРежим = ПараметрыПроцедуры.Свойство("ТихийРежим");
	
	Если СвойстваШаблонов = Неопределено
	 ИЛИ СвойстваШаблонов.Количество() = 0 Тогда
		Если Не ТихийРежим Тогда 
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Нет данных для обновления шаблонов.'"));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	WSПрокси = ПроксиСервисаВебСбора(АдресСервера, ПолучитьТаймаутДляВебСервисаСбора());
	
	Если WSПрокси = Неопределено Тогда
		Если Не ТихийРежим Тогда 
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Не удалось подключиться к веб-сервису Росстата.'"));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	WSОперации = Новый Соответствие;
	Для Каждого Операция Из WSПрокси.ТочкаПодключения.Интерфейс.Операции Цикл
		WSОперации.Вставить(Операция.Имя, Операция);
	КонецЦикла;
	
	ШаблоныЭВФ = Новый Массив;
	
	КоличествоНезагруженныхШаблонов = 0;
	
	КоличествоОбновляемыхШаблонов = СвойстваШаблонов.Количество();
	
	// Подготовка к вызову и вызовы метода веб-сервиса "GetTemplateBody".
	WSОперация = WSОперации["GetTemplateBody"];
	Если WSОперация <> Неопределено Тогда
		
		СчетчикОщибокОпераций = 0;
		
		ПараметрыОперации = ПараметрыОперацииОбъектыXDTO(WSПрокси.ФабрикаXDTO, WSОперация);
		
		ПараметрОперации = ПараметрыОперации.Найти("request", "Имя");
		
		Для НомерШаблона = 1 По КоличествоОбновляемыхШаблонов Цикл
			
			СвойстваШаблона = СвойстваШаблонов[НомерШаблона - 1];
			
			Если ПараметрОперации <> Неопределено Тогда
				ПараметрОперации.Значение.Id = СвойстваШаблона.ИДОбъекта;
			КонецЕсли;
			
			ЗасчитанаОшибка = Ложь;
			
			Ответ = Неопределено;
			Для НомПопытки = 1 По 3 Цикл
				Попытка
					Если ПараметрыОперации.Количество() = 0 Тогда
						Ответ = WSПрокси.GetTemplateBody();
					ИначеЕсли ПараметрыОперации.Количество() = 1 Тогда
						Ответ = WSПрокси.GetTemplateBody(ПараметрыОперации[0].Значение);
					КонецЕсли;
					СчетчикОщибокОпераций = 0; // считаем только идущие подряд ошибки
					Прервать;
				Исключение
					Если НомПопытки < 3 Тогда
						Продолжить;
					КонецЕсли;
					
					КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
					
					СчетчикОщибокОпераций = СчетчикОщибокОпераций + 1;
					Если СчетчикОщибокОпераций > 3 Тогда // превышено количество ошибок обращения к сервису
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
						ЗаписьЖурналаРегистрации(
							НСтр("ru = 'Обновление шаблонов Росстата. Ошибка вызова операции веб-сервиса (GetTemplateBody).'",
							КодОсновногоЯзыка), УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
						Если Не ТихийРежим Тогда 
							ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru='Ошибка доступа к веб-сервису при получении данных шаблона Росстата: %1 ""%2"".'"),
								СвойстваШаблона.Код, СвойстваШаблона.ИмяФормы));
						КонецЕсли;
						
						Сообщение = Новый СообщениеПользователю;
						Сообщение.Текст = НСтр("ru='Превышено количество ошибок при запросах к веб-сервису. Операция обновления шаблонов прервана.'");
						Сообщение.Сообщить();
						КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов
							+ (КоличествоОбновляемыхШаблонов - НомерШаблона);
					КонецЕсли;
					
					ЗасчитанаОшибка = Истина;
				КонецПопытки;
			КонецЦикла;
			
			Если ЗасчитанаОшибка Тогда
				Если СчетчикОщибокОпераций > 3 Тогда
					Прервать;
				Иначе
					Продолжить;
				КонецЕсли;
			КонецЕсли;
			
			Если НЕ (ТипЗнч(Ответ) = Тип("ОбъектXDTO")
				И Ответ.Тип().Имя = "GetTemplateBodyResponse") Тогда
				Если Не ТихийРежим Тогда 
					ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Формат ответа веб-сервиса не позволяет получить данные шаблона Росстата:|%1 ""%2"".'"), СвойстваШаблона.Код, СвойстваШаблона.ИмяФормы));
				КонецЕсли;
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				Продолжить;
			КонецЕсли;
			
			Попытка
				ДанныеШаблона = ДвоичныеДанныеФайлаИзАрхива(Ответ.Body);
			Исключение
				Если Не ТихийРежим Тогда 
					ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Ошибка при распаковке данных шаблона Росстата:|%1 ""%2"".'"), СвойстваШаблона.Код, СвойстваШаблона.ИмяФормы));
				КонецЕсли;
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				Продолжить;
			КонецПопытки;
			
			Если ДанныеШаблона = Неопределено Тогда
				Если Не ТихийРежим Тогда 
					ОбщегоНазначения.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Архив не содержит необходимый файл шаблона:|%1 ""%2"".'"), СвойстваШаблона.Код, СвойстваШаблона.ИмяФормы));
				КонецЕсли;
				КоличествоНезагруженныхШаблонов = КоличествоНезагруженныхШаблонов + 1;
				Продолжить;
			КонецЕсли;
			
			ШаблонЭВФ = Новый Структура;
			ШаблонЭВФ.Вставить("ИмяФайлаШаблона", НРег(СвойстваШаблона.Шифр) + "_" + СокрЛП(СвойстваШаблона.ТипФормы) + ".xml");
			ШаблонЭВФ.Вставить("Размер", ДанныеШаблона.Размер());
			ШаблонЭВФ.Вставить("Шаблон", ДанныеШаблона);
			
			ШаблоныЭВФ.Добавить(ШаблонЭВФ);
			
			Процент = Окр(100 * НомерШаблона / КоличествоОбновляемыхШаблонов);
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='%1 из %2'"), Формат(НомерШаблона, "ЧГ="), Формат(КоличествоОбновляемыхШаблонов, "ЧГ="));
			ДлительныеОперации.СообщитьПрогресс(Процент, ТекстСообщения);
			
		КонецЦикла;
		
	Иначе
		Если Не ТихийРежим Тогда 
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Веб-сервис не поддерживает операцию получения содержимого шаблонов Росстата.'"));
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЗагруженоШаблонов = Новый Структура("Незагружено,Всего", КоличествоНезагруженныхШаблонов, КоличествоОбновляемыхШаблонов);
	
	ПоместитьВоВременноеХранилище(ШаблоныЭВФ, АдресРезультата);
	ПоместитьВоВременноеХранилище(ЗагруженоШаблонов, АдресДополнительногоРезультата);
	
КонецПроцедуры

Функция СписокШаблоновСервисаВебСбора(СвойстваМодуля, ИспользоватьЦентральныйСервисСбора = Ложь, ПолучатьВсеВерсии = Ложь) Экспорт
	
	Перем АдресСервера;
	
	СвойстваМодуля = Новый Структура("ВерсияМодуля,ПутьДляЗагрузки", "", "");
	
	WSПрокси = ПроксиСервисаВебСбора(АдресСервера, ПолучитьТаймаутДляВебСервисаСбора(), ИспользоватьЦентральныйСервисСбора);
	
	Если WSПрокси = Неопределено Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не удалось подключиться к веб-сервису Росстата.'");
		Сообщение.Сообщить();
		Возврат Неопределено;
	КонецЕсли;
	
	WSОперации = Новый Соответствие;
	Для Каждого Операция Из WSПрокси.ТочкаПодключения.Интерфейс.Операции Цикл
		WSОперации.Вставить(Операция.Имя, Операция);
	КонецЦикла;
	
	// Подготовка к вызову и вызов метода веб-сервиса "GetActualVersion".
	WSОперация = WSОперации["GetActualVersion"];
	Если WSОперация <> Неопределено Тогда
		
		ПараметрыОперации = ПараметрыОперацииОбъектыXDTO(WSПрокси.ФабрикаXDTO, WSОперация);
		
		Ответ = Неопределено;
		Попытка
			Если ПараметрыОперации.Количество() = 0 Тогда
				Ответ = WSПрокси.GetActualVersion();
			ИначеЕсли ПараметрыОперации.Количество() = 1 Тогда
				Ответ = WSПрокси.GetActualVersion(ПараметрыОперации[0].Значение);
			КонецЕсли;
			Если НЕ (ТипЗнч(Ответ) = Тип("ОбъектXDTO")
				И Ответ.Тип().Имя = "GetActualVersionResponse") Тогда
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = НСтр("ru='Формат ответа веб-сервиса не позволяет получить номер актуальной версии программного модуля Росстата.'");
				Сообщение.Сообщить();
			Иначе
				СвойстваМодуля.ВерсияМодуля = Ответ.Version;
				СвойстваМодуля.ПутьДляЗагрузки = АдресСервера + "/" + Ответ.RelativeDownloadPath;
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление шаблонов Росстата. Ошибка вызова операции веб-сервиса (GetActualVersion).'", КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Ошибка при получении номера версии программного модуля Росстата.'");
			Сообщение.Сообщить();
		КонецПопытки;
		
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Веб-сервис не поддерживает операцию получения номера актуальной версии программного модуля Росстата.'");
		Сообщение.Сообщить();
	КонецЕсли;
	
	// Подготовка к вызову и вызов метода веб-сервиса "GetTemplatesInfo".
	Ответ = Неопределено;
	WSОперация = WSОперации["GetTemplatesInfo"];
	Если WSОперация <> Неопределено Тогда
		
		ПараметрыОперации = ПараметрыОперацииОбъектыXDTO(WSПрокси.ФабрикаXDTO, WSОперация);
		
		ПараметрОперации = ПараметрыОперации.Найти("request", "Имя");
		Если ПараметрОперации <> Неопределено Тогда
			Если ПолучатьВсеВерсии = Ложь Тогда 
				ПараметрОперации.Значение.State = "Actual"; // получить актуальные версии шаблонов
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			Если ПараметрыОперации.Количество() = 0 Тогда
				Ответ = WSПрокси.GetTemplatesInfo();
			ИначеЕсли ПараметрыОперации.Количество() = 1 Тогда
				Ответ = WSПрокси.GetTemplatesInfo(ПараметрыОперации[0].Значение);
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление шаблонов Росстата. Ошибка вызова операции веб-сервиса (GetTemplatesInfo).'", КодОсновногоЯзыка),
				УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Ошибка доступа к веб-сервису при получении списка актуальных шаблонов Росстата.
				|Проверьте правильность ввода адреса ON-line модуля ТОГС.'");
			Сообщение.Сообщить();
			Возврат Неопределено;
		КонецПопытки;
		
		Если НЕ (ТипЗнч(Ответ) = Тип("ОбъектXDTO")
			И Ответ.Тип().Имя = "ArrayOfTemplateInfo") Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru='Формат ответа веб-сервиса не позволяет получить список актуальных шаблонов Росстата.'");
			Сообщение.Сообщить();
			Возврат Неопределено;
		КонецЕсли;
		
	Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Веб-сервис не поддерживает операцию получения списка актуальных шаблонов Росстата.'");
		Сообщение.Сообщить();
		Возврат Неопределено;
	КонецЕсли;
	
	// Обработка результата запроса к веб-сервису.
	СвойстваШаблонов = ТаблицаСвойствШаблонов();
	
	Для Каждого СвойстваШаблона Из Ответ.TemplateInfo Цикл
		СтрокаСвойстваШаблона = СвойстваШаблонов.Добавить();
		
		Если ТипЗнч(СвойстваШаблона.ExtraKeys) = Тип("ОбъектXDTO")
			И СвойстваШаблона.ExtraKeys.Тип().Имя = "ArrayOfstring" Тогда
			Для Каждого ЭлементКлюча Из СвойстваШаблона.ExtraKeys.string Цикл
				СтрокаСвойстваШаблона.Ключи.Добавить(Строка(ЭлементКлюча));
			КонецЦикла;
		КонецЕсли;
		СтрокаСвойстваШаблона.Код              = СокрЛП(СвойстваШаблона.Code);
		СтрокаСвойстваШаблона.ОКУД             = СокрЛП(СвойстваШаблона.Okud);
		СтрокаСвойстваШаблона.ИмяФормы         = СокрЛП(СвойстваШаблона.Name);
		СтрокаСвойстваШаблона.Шифр             = СокрЛП(СвойстваШаблона.Shifr);
		СтрокаСвойстваШаблона.ТипФормы         = СвойстваШаблона.Idf;
		СтрокаСвойстваШаблона.ТипПериодичности = СвойстваШаблона.PeriodType;
		СтрокаСвойстваШаблона.ДатаОбновления   = СвойстваШаблона.UpdateTime;
		СтрокаСвойстваШаблона.Версия           = СвойстваШаблона.Version;
		СтрокаСвойстваШаблона.ЭтоАрхив         = СвойстваШаблона.IsArchive;
		СтрокаСвойстваШаблона.ИДОбъекта        = СвойстваШаблона.ObjectId;
		СтрокаСвойстваШаблона.Хэш              = СвойстваШаблона.Hash;
	КонецЦикла;
	
	СвойстваШаблонов.Сортировать("ИмяФормы, Код");
	
	Попытка
		ТекущиеНастройки = Новый Структура("Таблица, ДатаВремя", СвойстваШаблонов, ТекущаяДатаСеанса());
		ХранилищеСистемныхНастроек.Сохранить("РегистрСведений.ШаблоныЭВФОтчетовСтатистики", "ПоследниеРезультаты", ТекущиеНастройки);
	Исключение
	КонецПопытки;
	
	Возврат СвойстваШаблонов;
	
КонецФункции

Функция АдресСервераССОРосстата(НазваниеТОГС = "", ИспользоватьЦентральныйСервисСбора = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ИспользоватьЦентральныйСервисСбора Тогда 
		АдресСервера = Константы.АдресСервераСбораОтчетностиРосстата.Получить();
	Иначе
		АдресСервера = "";
	КонецЕсли;
	
	НазваниеТОГС = "";
	
	НачПозиция = СтрНайти(АдресСервера, "{");
	Если НачПозиция > 0 Тогда
		КонПозиция = СтрНайти(АдресСервера, "}", , НачПозиция);
		Если КонПозиция > НачПозиция Тогда
			НазваниеТОГС = Сред(АдресСервера, НачПозиция + 1, КонПозиция - НачПозиция - 1);
		Иначе
			НазваниеТОГС = Сред(АдресСервера, НачПозиция + 1);
		КонецЕсли;
		АдресСервера = Лев(АдресСервера, НачПозиция - 1);
	КонецЕсли;
	
	Если ПустаяСтрока(АдресСервера) Тогда
		
		АдресСервера = "http://websbor.gks.ru/online";
		Константы.АдресСервераСбораОтчетностиРосстата.Установить(АдресСервера);
		
	КонецЕсли;
	
	Возврат АдресСервера;
	
КонецФункции

Функция ТаблицаСвойствШаблонов()
	
	СвойстваШаблонов = Новый ТаблицаЗначений;
	
	СвойстваШаблонов.Колонки.Добавить("Код",              Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("ОКУД",             Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("ИмяФормы",         Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("Шифр",             Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("ТипФормы",         Новый ОписаниеТипов("Число"));
	СвойстваШаблонов.Колонки.Добавить("ТипПериодичности", Новый ОписаниеТипов("Число"));
	СвойстваШаблонов.Колонки.Добавить("ДатаОбновления",   Новый ОписаниеТипов("Дата"));
	СвойстваШаблонов.Колонки.Добавить("Версия",           Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("ЭтоАрхив",         Новый ОписаниеТипов("Булево"));
	СвойстваШаблонов.Колонки.Добавить("ИДОбъекта",        Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("Хэш",              Новый ОписаниеТипов("Строка"));
	СвойстваШаблонов.Колонки.Добавить("Ключи",            Новый ОписаниеТипов("Массив"));
	
	Возврат СвойстваШаблонов;
	
КонецФункции

Функция ПараметрыОперацииОбъектыXDTO(ФабрикаXDTOСервиса, WSОперацияСервиса) Экспорт 
	
	ПараметрыОперации = Новый ТаблицаЗначений;
	ПараметрыОперации.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
	ПараметрыОперации.Колонки.Добавить("Значение");
	
	Для Каждого WSПараметр Из WSОперацияСервиса.Параметры Цикл
		СвойстваПараметра = ПараметрыОперации.Добавить();
		
		СвойстваПараметра.Имя = WSПараметр.Имя;
		
		Если ТипЗнч(WSПараметр.Тип) = Тип("ТипЗначенияXDTO") Тогда
			ПараметрXDTO = ФабрикаXDTOСервиса.Создать(WSПараметр.Тип, "");
		Иначе
			ПараметрXDTO = ФабрикаXDTOСервиса.Создать(WSПараметр.Тип);
		КонецЕсли;
		
		СвойстваПараметра.Значение = ПараметрXDTO;
	КонецЦикла;
	
	Возврат ПараметрыОперации;
	
КонецФункции

Функция ПараметрыПодключенияКСервисуВебСбора(ИспользоватьЦентральныйСервисСбора = Ложь)
	
	АдресСервера = АдресСервераССОРосстата("", ИспользоватьЦентральныйСервисСбора);
	
	Попытка
		Владелец = "Константа.АдресСервераСбораОтчетностиРосстата";
		ИмяПользователя = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Логин");
		ПарольПользователя = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "Пароль");
	Исключение
		ИмяПользователя = "";
		ПарольПользователя = "";
	КонецПопытки;
	
	АдресСервераССО = ?(Прав(АдресСервера, 1) = "/", Лев(АдресСервера, СтрДлина(АдресСервера) - 1), АдресСервера);
	
	Если НЕ СтрНачинаетсяС(НРег(АдресСервераССО), "http://")
	   И НЕ СтрНачинаетсяС(НРег(АдресСервераССО), "https://") Тогда
		АдресСервераССО = "http://" + АдресСервераССО;
	КонецЕсли;
	
	ПутьКЦентрализованномуВебСервису    = "/webexchangeservice/public/old";
	ПутьКЦентрализованномуВебСервисуЗ   = "/webexchangeservice/external/old";
	ПутьКДецентрализованномуВебСервису  = "/WebServices/PublicIntegrationService.svc";
	ПутьКДецентрализованномуВебСервисуЗ = "/WebServices/IntegrationService.svc";
	
	ЗащищенноеСоединение = Ложь;
	
	Если СтрНайти(АдресСервераССО, "online.gks.ru") > 0
	 ИЛИ СтрНайти(АдресСервераССО, "websbor.gks.ru/online") > 0
	 ИЛИ СтрНайти(АдресСервераССО, "websbor.gks.ru/webstat") > 0 Тогда // централизованный веб-сервис
		АдресСервиса = АдресСервераССО + ?(ЗащищенноеСоединение,
			ПутьКЦентрализованномуВебСервисуЗ, ПутьКЦентрализованномуВебСервису);
	Иначе
		АдресСервиса = АдресСервераССО + ?(ЗащищенноеСоединение,
			ПутьКДецентрализованномуВебСервисуЗ, ПутьКДецентрализованномуВебСервису);
	КонецЕсли;
	
	// заполняем настройки
	Результат = Новый Структура;
	Результат.Вставить("АдресWSDL", АдресСервиса + "?wsdl");
	Результат.Вставить("URIПространстваИмен", "http://tempuri.org/");
	Результат.Вставить("ИмяСервиса", "PublicIntegrationService");
	Результат.Вставить("ИмяТочкиПодключения", "BasicHttpBinding_IPublicIntegrationService");
	Результат.Вставить("Местоположение", АдресСервиса);
	Результат.Вставить("ИмяПользователя", ИмяПользователя);
	Результат.Вставить("Пароль", ПарольПользователя);
	Результат.Вставить("АдресСервера", АдресСервераССО);
	
	Возврат Результат;
	
КонецФункции

Функция ПроксиСервисаВебСбора(АдресСервера, Таймаут = 120, ИспользоватьЦентральныйСервисСбора = Ложь) Экспорт 
	
	WSПрокси = Неопределено;
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключенияКСервису = ПараметрыПодключенияКСервисуВебСбора(ИспользоватьЦентральныйСервисСбора);
	ЗаполнитьЗначенияСвойств(ПараметрыПодключения, ПараметрыПодключенияКСервису);
	ПараметрыПодключения.Таймаут = Таймаут;
	
	АдресСервера = ПараметрыПодключенияКСервису.АдресСервера;
	
	Попытка
		
		WSПрокси = ПроксиИзWSСсылкиССОРосстата(ПараметрыПодключения);
		
	Исключение
		
		КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление шаблонов Росстата. Ошибка создания клиентского прокси для вызова веб-сервиса'", КодОсновногоЯзыка),
			УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	КонецПопытки;
	
	Возврат WSПрокси;
	
КонецФункции

Функция ПроксиИзWSСсылкиССОРосстата(Параметры)
	
	АдресWSDL = Параметры.АдресWSDL;
	URIПространстваИмен = Параметры.URIПространстваИмен;
	ИмяСервиса = Параметры.ИмяСервиса;
	ИмяТочкиПодключения = Параметры.ИмяТочкиПодключения;
	ИмяПользователя = Параметры.ИмяПользователя;
	Пароль = Параметры.Пароль;
	Таймаут = Параметры.Таймаут;
	Местоположение = Параметры.Местоположение;
	ИспользоватьАутентификациюОС = Параметры.ИспользоватьАутентификациюОС;
	
	ИнтернетПрокси = Неопределено;
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		ИнтернетПрокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(АдресWSDL);
	КонецЕсли;
	
	Протокол = "";
	Позиция = СтрНайти(АдресWSDL, "://");
	Если Позиция > 0 Тогда
		Протокол = НРег(Лев(АдресWSDL, Позиция - 1));
	КонецЕсли;
	
	ЗащищенноеСоединение = Неопределено;
	Если (Протокол = "https" Или Протокол = "ftps")  Тогда
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL;
	КонецЕсли;
	
	Прокси = WSСсылки.WSСборОтчетностиРосстата.СоздатьWSПрокси(URIПространстваИмен, ИмяСервиса, ИмяТочкиПодключения,
		ИнтернетПрокси, Таймаут, ЗащищенноеСоединение, Местоположение, ИспользоватьАутентификациюОС);
	
	Прокси.Пользователь = ИмяПользователя;
	Прокси.Пароль       = Пароль;
	
	Возврат Прокси;
	
КонецФункции

Функция ДвоичныеДанныеФайлаИзАрхива(ДвоичныеДанныеФайлаАрхива) Экспорт 
	
	ВремФайлАрхива = ПолучитьИмяВременногоФайла("zip");
	
	Попытка
		ДвоичныеДанныеФайлаАрхива.Записать(ВремФайлАрхива);
	Исключение
		УдалитьФайлы(ВремФайлАрхива);
		ВызватьИсключение "Не удалось сохранить архива шаблона ЭВФ во временный файл." + Символы.ПС + ОписаниеОшибки();
	КонецПопытки;
	
	ВремКаталог = ПолучитьИмяВременногоФайла("");
	ВремКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ВремКаталог);
	СоздатьКаталог(ВремКаталог);
	
	Попытка
		ЗИП = Новый ЧтениеZipФайла(ВремФайлАрхива);
		ЗИП.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		ЗИП.Закрыть();
	Исключение
		УдалитьФайлы(ВремКаталог);
		ВызватьИсключение "Не удалось распаковать архив шаблона ЭВФ.
				|" + ИнформацияОбОшибке().Описание;
	КонецПопытки;
	
	ДвоичныеДанныеФайла = Неопределено;
	
	ОбъектыФайл = НайтиФайлы(ВремКаталог, "*.*", Ложь);
	
	Для Каждого ОбъектФайл Из ОбъектыФайл Цикл
		
		Если ОбъектФайл.Существует() Тогда
			
			Попытка
				ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ОбъектФайл.ПолноеИмя);
				
				Прервать;
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось получить данные шаблона из файла ""%1"":%2'"), ОбъектФайл.Имя, Символы.ПС + ОписаниеОшибки());
				Сообщение.Сообщить();
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЦикла;
	
	УдалитьФайлы(ВремФайлАрхива);
	
	Попытка
		УдалитьФайлы(ВремКаталог);
	Исключение
		СообщениеОбОшибке = НСтр("ru = 'Не удалось удалить временные файлы'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СообщениеОбОшибке, УровеньЖурналаРегистрации.Предупреждение,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ДвоичныеДанныеФайла;
	
КонецФункции

Процедура ПолучитьАктуальныйШаблонИзСервисаРосстата(ПараметрыПроцедуры, АдресРезультата, АдресДополнительногоРезультата) Экспорт
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныЭВФОтчетовСтатистики.Версия КАК ВерсияШаблона,
		|	ШаблоныЭВФОтчетовСтатистики.ОКУД КАК ОКУД,
		|	ШаблоныЭВФОтчетовСтатистики.КодШаблона КАК КодШаблона
		|ИЗ
		|	РегистрСведений.ШаблоныЭВФОтчетовСтатистики КАК ШаблоныЭВФОтчетовСтатистики
		|ГДЕ
		|	ШаблоныЭВФОтчетовСтатистики.ИмяФайлаШаблона = &ИмяФайлаШаблона";
		
		Запрос.УстановитьПараметр("ИмяФайлаШаблона", ПараметрыПроцедуры.ИмяФайлаШаблона);
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда 
			ТаблицаФорматов = РегламентированнаяОтчетность.ПолучитьТекущуюТаблицуФорматов(ПараметрыПроцедуры);
			ОтобранныеСтроки = ТаблицаФорматов.НайтиСтроки(Новый Структура("Код, ОКУД", ВыборкаДетальныеЗаписи.КодШаблона, ВыборкаДетальныеЗаписи.ОКУД));
			Если ОтобранныеСтроки.Количество() <> 1 Тогда 
				Возврат;
			КонецЕсли;
			
			Если ОтобранныеСтроки[0].Версия = ВыборкаДетальныеЗаписи.ВерсияШаблона Тогда 
				Возврат;
			КонецЕсли;
			
			ОсновнойРезультат = Новый Структура;
			ОсновнойРезультат.Вставить("Версия", ОтобранныеСтроки[0].Версия);
			ОсновнойРезультат.Вставить("ОКУД", ВыборкаДетальныеЗаписи.ОКУД);
			ОсновнойРезультат.Вставить("КодШаблона", ВыборкаДетальныеЗаписи.КодШаблона);
			ПоместитьВоВременноеХранилище(ОсновнойРезультат, АдресРезультата);
			ТФК = ТаблицаФорматов.СкопироватьКолонки();
			НовСтр = ТФК.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтр, ОтобранныеСтроки[0]);
			ЗагрузитьШаблоныЧерезСервисВебСбора(Новый Структура("СвойстваШаблонов, ТихийРежим", ТФК, Истина), АдресДополнительногоРезультата, "");
		КонецЕсли;
	Исключение
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

Процедура ПриПолученииНовогоШаблонаФСГС(ПараметрыШаблона) Экспорт
	Попытка
		ДД = ПолучитьИзВременногоХранилища(ПараметрыШаблона.АдресФайла);
		ШаблоныЭВФ = Новый Массив;
		ШаблонЭВФ = Новый Структура;
		ШаблонЭВФ.Вставить("ИмяФайлаШаблона", ?(ЗначениеЗаполнено(НРег(ПараметрыШаблона.ИмяФайла)), НРег(ПараметрыШаблона.ИмяФайла), "unknwn.xml"));
		ШаблонЭВФ.Вставить("Размер", ДД.Размер());
		ШаблонЭВФ.Вставить("Шаблон", ДД);
		ШаблоныЭВФ.Добавить(ШаблонЭВФ);
		КоличествоНезагруженныхШаблонов = 0;
		ЗагрузитьШаблоны(ПоместитьВоВременноеХранилище(ШаблоныЭВФ, Новый УникальныйИдентификатор), КоличествоНезагруженныхШаблонов);
		Если КоличествоНезагруженныхШаблонов > 0 Тогда 
			ЗаписьЖурналаРегистрации("ПриПолученииНовогоШаблонаФСГС", УровеньЖурналаРегистрации.Предупреждение, , , "Не удалось загрузить шаблон: " + ШаблонЭВФ.ИмяФайлаШаблона);
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации("ПриПолученииНовогоШаблонаФСГС", УровеньЖурналаРегистрации.Предупреждение, , , "Не удалось загрузить шаблон");
	КонецПопытки;
КонецПроцедуры

#КонецОбласти

#КонецЕсли