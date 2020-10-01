
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СостояниеРасчета = Перечисления.СостоянияОперацийЗакрытияМесяца.НеВыполнено;
	
	ЗаполнитьСлужебныеПараметрыФормы();
	
	Запрос = Новый Запрос(СлужебныеПараметрыФормы.ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", Параметры.СписокДокументов);
	
	ДанныеКРасчету.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОпределитьСледующийМесяцРасчета();
	НачатьРасчетАмортизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НЕ ВыполняетсяРасчет Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;

	Если НЕ ЗавершениеРаботы Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Продолжить расчет'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Отменить расчет'"));
		
		ТекстВопроса = НСтр("ru = 'Расчет амортизации не завершен. 
		|Отменить расчет и закрыть форму?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок); 
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Расчет амортизации не завершен. Результаты расчета не будут записаны.'");
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьРасчет(Команда)
	
	ОтменитьФоновыйРасчетАмортизации();
	ЗавершитьРасчетИЗакрытьФорму(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьРасчетАмортизации()

	ВыполняетсяРасчет = Истина;
	
	Если ТекущийМесяц = '000101010000' Тогда
		ПослеРасчетаАмортизации();
		Возврат;
	КонецЕсли;
	
	ПредставлениеПериода = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ТекущийМесяц);
	Элементы.ЗаголовокРасчетаВФоне.Заголовок = СтрШаблон(НСтр("ru = 'Выполняется расчет амортизации за %1...'"), ПредставлениеПериода);
	
	ПодключитьОбработчикОжидания("Подключаемый_НачатьРасчетАмортизации", 1, Истина);
	
КонецПроцедуры

&НаСервере
Функция РассчитатьАмортизациюНаСервере()
	
	СписокОрганизаций.Очистить();
	
	Если ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(ТекущийМесяц) Тогда
		
		ПараметрыРасчета = ВнеоборотныеАктивы.НовыеПараметрыРасчетаАмортизации();
		ПараметрыРасчета.Период = ТекущийМесяц;
		ПараметрыРасчета.ОбъектыУчета = "НМА";
		ПараметрыРасчета.ЭтапРасчета = Перечисления.ОперацииЗакрытияМесяца.НачислениеАмортизацииНМА;
		
		СтруктураПоиска = Новый Структура("Дата", ТекущийМесяц);
		СписокСтрок = ДанныеКРасчету.НайтиСтроки(СтруктураПоиска);
		Для каждого ПараметрыТекущегоРасчета Из СписокСтрок Цикл
			НовыйПакет = ПараметрыРасчета.ПакетыАмортизации.Добавить();
			НовыйПакет.Организация = ПараметрыТекущегоРасчета.Организация;
			НовыйПакет.НомерПакета = ПараметрыТекущегоРасчета.НомерПакета;
			ПараметрыРасчета.СписокОрганизаций.Добавить(ПараметрыТекущегоРасчета.Организация);
			СписокОрганизаций.Добавить(ПараметрыТекущегоРасчета.Организация);
		КонецЦикла; 
		
		РезультатРасчета = ВнеоборотныеАктивы.ЗапуститьРасчетАмортизацииВФоне(ПараметрыРасчета, УникальныйИдентификатор);
		
	Иначе
		
		СписокДокументов = Новый Массив;
		СтруктураПоиска = Новый Структура("Дата", ТекущийМесяц);
		СписокСтрок = ДанныеКРасчету.НайтиСтроки(СтруктураПоиска);
		Для каждого ПараметрыТекущегоРасчета Из СписокСтрок Цикл
			СписокДокументов.Добавить(ПараметрыТекущегоРасчета.Ссылка);
		КонецЦикла; 
		РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
							УникальныйИдентификатор,
							"ВнеоборотныеАктивы.ПровестиДокументыВФоне",
							СписокДокументов,
							НСтр("ru = 'Расчет амортизации НМА'"));
		
	КонецЕсли; 
	
	Возврат РезультатРасчета;
	
КонецФункции

&НаКлиенте
Процедура ПослеРасчетаАмортизации()

	ВыполняетсяРасчет = Ложь;
	
	ЕстьОшибки = ПроверитьНаличиеОшибок(ТекущийМесяц, СписокОрганизаций.ВыгрузитьЗначения(), АдресХранилища);
	
	ОпределитьСледующийМесяцРасчета();
	
	Для каждого ИмяСобытия Из СлужебныеПараметрыФормы.СобытияЗаписи Цикл
		Оповестить(ИмяСобытия);
	КонецЦикла; 
	Для каждого ИмяТипаДокумента Из СлужебныеПараметрыФормы.ТипыДокументов Цикл
		ОповеститьОбИзменении(Тип(ИмяТипаДокумента));
	КонецЦикла; 
	
	Если ТекущийМесяц <> '000101010000' Тогда
		
		НачатьРасчетАмортизации();
		
	Иначе
		
		ЗавершитьРасчетИЗакрытьФорму(ЕстьОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРасчетИЗакрытьФорму(ЕстьОшибки)

	ВнеоборотныеАктивыКлиент.ОповеститьОРасчетеАмортизации(ЕстьОшибки);
	
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеРасчета()

	Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
		
		ПослеРасчетаАмортизации();
		
	Иначе
		
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеРасчета", 3, Истина);
			
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачатьРасчетАмортизации()

	ВыполняетсяРасчет = Истина;
	
	РезультатРасчета = РассчитатьАмортизациюНаСервере();
	
	Если РезультатРасчета.ЗаданиеВыполнено Тогда
		
		АдресХранилища = РезультатРасчета.АдресХранилища;
		ПослеРасчетаАмортизации();
		
	Иначе
		
		ИдентификаторЗадания = РезультатРасчета.ИдентификаторЗадания;
		АдресХранилища       = РезультатРасчета.АдресХранилища;
	
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьЗавершениеРасчета", 2, Истина);
		
    КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОпределитьСледующийМесяцРасчета()

	Для каждого ЭлементКоллекции Из ДанныеКРасчету Цикл
		Если ЭлементКоллекции.Дата > ТекущийМесяц Тогда
			ТекущийМесяц = ЭлементКоллекции.Дата;
			Возврат;
		КонецЕсли; 
	КонецЦикла; 

	ТекущийМесяц = '000101010000';
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОтменитьФоновыйРасчетАмортизации();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьФоновыйРасчетАмортизации()

	ВыполняетсяРасчет = Ложь;
	ВнеоборотныеАктивы.ОтменитьФоновыйРасчетАмортизации(ИдентификаторЗадания, АдресХранилища);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьНаличиеОшибок(Знач ТекущийМесяц, Знач СписокОрганизаций, Знач АдресХранилища)

	ЕстьОшибки = ПолучитьИзВременногоХранилища(АдресХранилища);
	ЕстьОшибки = ?(ЕстьОшибки = Истина, Истина, Ложь);
	
	Возврат ЕстьОшибки;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСлужебныеПараметрыФормы()

	СлужебныеПараметры = Новый Структура;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	АмортизацияНМА2_4.Ссылка КАК Ссылка,
	|	АмортизацияНМА2_4.Организация КАК Организация,
	|	АмортизацияНМА2_4.НомерПакета,
	|	АмортизацияНМА2_4.Дата КАК Дата
	|ИЗ
	|	Документ.АмортизацияНМА2_4 КАК АмортизацияНМА2_4
	|ГДЕ
	|	АмортизацияНМА2_4.Ссылка В(&СписокДокументов)
	|	И НЕ АмортизацияНМА2_4.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата,
	|	Организация";
	СлужебныеПараметры.Вставить("ТекстЗапроса", ТекстЗапроса);
	
	СлужебныеПараметры.Вставить("СобытияЗаписи", Новый Массив);
	СлужебныеПараметры.СобытияЗаписи.Добавить("Запись_АмортизацияНМА2_4");
	
	СлужебныеПараметры.Вставить("ТипыДокументов", Новый Массив);
	СлужебныеПараметры.ТипыДокументов.Добавить("ДокументСсылка.АмортизацияНМА2_4");
	
	АмортизацияНМАЛокализация.ДополнитьСлужебныеПараметрыФормыРасчетАмортизации(СлужебныеПараметры);
	
	СлужебныеПараметрыФормы = Новый ФиксированнаяСтруктура(СлужебныеПараметры);

КонецПроцедуры
 
#КонецОбласти
