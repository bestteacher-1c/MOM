#Область ПрограммныйИнтерфейс

// Выполняет печать этикеток обуви по переданным данным печати.
// 
// Параметры:
// 	ДанныеПечати - Структура - данные для печати
// 	Форма = ФормаКлиентскогоПриложения - Форма источник вызова печати
Процедура НапечататьЭтикеткиИСМП(ДанныеПечати, Форма) Экспорт
	
	СтандартнаяОбработка = Истина;
	ПечатьЭтикетокИСМПКлиентПереопределяемый.ПечатьЭтикеткиИСМП(ДанныеПечати, Форма, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("АдресВХранилище"       , ПоместитьВоВременноеХранилище(ДанныеПечати, Форма.УникальныйИдентификатор));
		ПараметрыПечати.Вставить("КоличествоЭкземпляров" , 1);
		ПараметрыПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте" , ДанныеПечати.КаждаяЭтикеткаНаНовомЛисте);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"РегистрСведений.ПулКодовМаркировкиСУЗ",
			"ЭтикеткаКодМаркировкиИСМП",
			ПараметрКоманды,
			Форма,
			ПараметрыПечати);
		
	КонецЕсли;
	
КонецПроцедуры

// Выводит переданный по адресу во временном харнищие табличный документ
// 
// Параметры:
// 	АдресТабличногоДокумента - Строка- Адрес во временном хранилище
// 	Форма - УправляемаяФормы - владелец открываемой формы для печати
// 	СразуНаПринтер - Булево - отправлять непостредственно на принтер
//
Процедура ВывестиНаПечатьТаблиныйДокументПоАдресу(АдресТабличногоДокумента, Форма, СразуНаПринтер=Ложь) Экспорт
	
	Если Не ЭтоАдресВременногоХранилища(АдресТабличногоДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Если СразуНаПринтер И ЭтоАдресВременногоХранилища(АдресТабличногоДокумента) Тогда
		ТабличныйДокумент = ПолучитьИзВременногоХранилища(АдресТабличногоДокумента);
		ТабличныйДокумент.Напечатать();
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.ПеремаркировкаТоваровИСМП.ПустаяСсылка"));
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище", АдресТабличногоДокумента);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.РаботаСКМПриПеремаркировкеТоваровИСМП",
		"ТабличныйДокумент",
		ПараметрКоманды,
		Форма,
		ПараметрыПечати);
	
КонецПроцедуры

// Резервирует и выполняет печать нового кода маркировки. Последовательно запрашивает данные, которых недостаточно
// - Задает вопрос о необходимости записать объект для резервирования.
// - Запрашивает шаблон этикетки у пользователя.
// 
// Параметры:
// 	Результат - Произвольный - результаты переданных данных из других форм и обработчиков оповещений
// 	ДополнительныеПараметры - Структура - (См. ПечатьЭтикетокИСМПКлиент.СтруктураПараметровПечатиНовогоКодаМаркировки)
Процедура РаспечататьНовыйКодМаркировки(Результат, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещенияДействия = Новый ОписаниеОповещения(
		"РаспечататьНовыйКодМаркировки", ЭтотОбъект, ДополнительныеПараметры);
	
	Если ДополнительныеПараметры.Действие = "Начало" Тогда
		
		Если ЗначениеЗаполнено(ДополнительныеПараметры.Документ) Тогда
			ДополнительныеПараметры.Действие = "ВыбратьШаблон";
			ВыполнитьОбработкуОповещения(ОписаниеОповещенияДействия, "");
		Иначе
			ТекстВопроса = Нстр("ru = 'Для резервирования нового кода маркировки документ будет записан, продолжить?'");
			ДополнительныеПараметры.Действие = "Запись";
			ПоказатьВопрос(ОписаниеОповещенияДействия, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры.Действие = "УстановитьЭтикеткуИПечать" Тогда
		
		Если Результат = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры.СтруктураПечатиЭтикетки.ШаблонЭтикетки = Результат.ДанныеВыбора.ШаблонЭтикетки;
		ДополнительныеПараметры.Шаблон                                 = Результат.ДанныеВыбора.ШаблонМаркировки;
		ДополнительныеПараметры.СразуНаПринтер                         = Результат.ДанныеВыбора.СразуНаПринтер;
		ДополнительныеПараметры.СтруктураПечатиЭтикетки.Шаблон         = Результат.ДанныеВыбора.ШаблонМаркировки;
		ДополнительныеПараметры.СтруктураПечатиЭтикетки.Серия          = Результат.ДанныеВыбора.Серия;
		
		ДанныеДляПечати = ПечатьЭтикетокИСМПКлиентСервер.ДанныеДляПечатиЭтикеток(
			ДополнительныеПараметры.СтруктураПечатиЭтикетки,
			ДополнительныеПараметры.Форма,
			ДополнительныеПараметры.Документ);
		
		СтруктураРезультата = ПечатьЭтикетокИСМПВызовСервера.ПечатьЭтикетокСРезервированиемПоДокументу(
			ДанныеДляПечати);
		Если СтруктураРезультата = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		АдресТабличногоДокумента = ПоместитьВоВременноеХранилище(
			СтруктураРезультата.ТабличныйДокумент, ДополнительныеПараметры.Форма.УникальныйИдентификатор);
		
		ВывестиНаПечатьТаблиныйДокументПоАдресу(АдресТабличногоДокумента, ЭтотОбъект, Результат.ДанныеВыбора.СразуНаПринтер);
		
		Если ДополнительныеПараметры.Оповещение <> Неопределено Тогда
			
			ДанныеОповещения = Новый Структура();
			ДанныеОповещения.Вставить("РезультатРезервирования", СтруктураРезультата.РезультатРезервирования);
			ДанныеОповещения.Вставить("СохраняемыеНастройки",    Результат);
			
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, ДанныеОповещения);
			
		КонецЕсли;
		
	ИначеЕсли ДополнительныеПараметры.Действие = "ВыбратьШаблон" Тогда
		
		Если Результат = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ДополнительныеПараметры.Действие = "УстановитьЭтикеткуИПечать";
		
		ПараметрыОткрытия = ШтрихкодированиеИСКлиентСервер.ПараметрыОткрытияФормыУточненияДанных();
		ПараметрыОткрытия.ШаблонКодаМаркировки      = ДополнительныеПараметры.Шаблон;
		ПараметрыОткрытия.ШаблонЭтикетки            = ДополнительныеПараметры.ШаблонЭтикетки;
		ПараметрыОткрытия.СразуНаПринтер            = ДополнительныеПараметры.СразуНаПринтер;
		ПараметрыОткрытия.Шаблоны                   = ДополнительныеПараметры.Шаблоны;
		ПараметрыОткрытия.ПараметрыСканирования     = ДополнительныеПараметры.ПараметрыСканирования;
		ПараметрыОткрытия.ПараметрыУказанияСерий    = ДополнительныеПараметры.ПараметрыСканирования.ПараметрыУказанияСерий;
		ПараметрыОткрытия.Номенклатура              = ДополнительныеПараметры.Номенклатура;
		ПараметрыОткрытия.Характеристика            = ДополнительныеПараметры.Характеристика;
		ПараметрыОткрытия.Серия                     = ДополнительныеПараметры.Серия;
		ПараметрыОткрытия.Документ                  = ДополнительныеПараметры.Документ;
		ПараметрыОткрытия.РежимПечатиЭтикеток       = Истина;
		ПараметрыОткрытия.Операция                  = "ОткрытьФормуУточненияДанных";
		
		ПараметрыОткрытияФормыУточненияДанных = ШтрихкодированиеИСКлиентСервер.ПараметрыОткрытияФормыУточненияДанных();
		ПараметрыОткрытияФормыУточненияДанных.Операция = "ОткрытьФормуУточненияДанных";
		ПараметрыОткрытияФормыУточненияДанных.ДанныеДляУточненияСведенийПользователя = ПараметрыОткрытия;
		
		ШтрихкодированиеИСКлиент.УточнитьДанныеУПользователя(
			ДополнительныеПараметры.Форма,
			ПараметрыОткрытияФормыУточненияДанных,
			ОписаниеОповещенияДействия);
		
	ИначеЕсли ДополнительныеПараметры.Действие = "Запись" Тогда
		
		Если Не Результат = КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
		Попытка
			ДополнительныеПараметры.Форма.ВладелецФормы.Записать();
		Исключение
			ТекстОшибки = 
				СтрШаблон(
					НСтр("ru = 'Не удалось записать документ по причине: %1'"),
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Возврат;
		КонецПопытки;
		ДополнительныеПараметры.Документ = ДополнительныеПараметры.Форма.ВладелецФормы.Объект.Ссылка;
		ДополнительныеПараметры.Действие = "ВыбратьШаблон";
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияДействия, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

//Получает данные для печати этикеток ИС МП из справочника штрихкодов упаковок
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
// Возвращаемое значение:
// 	Неопределено - Описание
Функция ПечатьШтрихкодыУпаковокИСМП(ОписаниеКоманды) Экспорт
	
	ДанныеДляПечати = Новый Структура();
	ДанныеДляПечати.Вставить("РежимПечати", "Выборочно");
	
	ОчиститьСообщения();
	
	МассивШаблоновКодовМаркировок = Новый Массив();
	
	ОбъектыПечати = ПечатьЭтикетокИСМПВызовСервера.ДанныеДляПечатиШтрихкодовУпаковокИСМП(
		ОписаниеКоманды.Идентификатор,
		ОписаниеКоманды.ОбъектыПечати,
		МассивШаблоновКодовМаркировок);
	
	ДанныеДляПечати.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	Если ДанныеДляПечати.ОбъектыПечати.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru='Нет данных для печати этикеток.'"));
		Возврат Неопределено;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура();
	ПараметрыФормыВыбораШаблона = Новый Структура();
	ПараметрыФормыВыбораШаблона.Вставить("Шаблоны", МассивШаблоновКодовМаркировок);
	
	ДополнительныеПараметры.Вставить("Параметры", ПараметрыФормыВыбораШаблона);
	СтандартнаяОбработка = Истина;
	
	ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиентСервер.ПараметрыОткрытияФормыУточненияДанных();
	ПараметрыОткрытияФормы.РежимПечатиЭтикеток = Истина;
	
	Для Каждого СтрокаОбъектПечати Из ОбъектыПечати Цикл
		ПараметрыОткрытияФормы.КодМаркировки          = СтрокаОбъектПечати.КодМаркировки;
		ПараметрыОткрытияФормы.ХешСуммаКодаМаркировки = СтрокаОбъектПечати.ХешСуммаКодаМаркировки;
		ПараметрыОткрытияФормы.Номенклатура           = СтрокаОбъектПечати.Номенклатура;
		ПараметрыОткрытияФормы.Характеристика         = СтрокаОбъектПечати.Характеристика;
	КонецЦикла;
	
	ПечатьЭтикетокИСМПКлиентПереопределяемый.ОткрытьФормуВыбораШаблонаЭтикеткиИСМППоДаннымПечати(
		ДанныеДляПечати, ОписаниеКоманды.Форма, СтандартнаяОбработка, ДополнительныеПараметры);
	
	Если СтандартнаяОбработка Тогда
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Документ.ПеремаркировкаТоваровИСМП.ПустаяСсылка"));
		
		ПараметрыПечати = Новый Структура;
		ПараметрыПечати.Вставить("АдресВХранилище",
			ПоместитьВоВременноеХранилище(ДанныеДляПечати, ОписаниеКоманды.Форма.УникальныйИдентификатор));
		ПараметрыПечати.Вставить("КоличествоЭкземпляров" , 1);
		
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
			"Справочник.ШтрихкодыУпаковокТоваров",
			"ЭтикеткаКодМаркировкиИСМП",
			ПараметрКоманды,
			ЭтотОбъект,
			ПараметрыПечати);
			
	КонецЕсли;
	
КонецФункции

// Возвращает новую структуру параметров для использования в процедуре РаспечататьНовыйКодМаркировки.
// 
// Параметры:
// 	СтурктураПечати - Структура - (см. ШтрихкодированиеИСМПКлиентСервер.СтруктураПечатиЭтикетки)
// 	Форма - ФормаКлиентскогоПриложения - форма, из которой осуществляется вызов
// 	Оповещение - ОписаниеОповещения - Оповещение, которое вызывается на клиенте, передается результат резервирования
// 	нового кода маркировки.
// Возвращаемое значение:
// 	Структура - Описание:
// * СтруктураПечати - (см. ШтрихкодированиеИСМПКлиентСервер.СтруктураПечатиЭтикетки) - Структура для печати.
// * Форма - ФормаКлиентскогоПриложения - форма, из которой осуществляется вызов.
// * Оповещение - ОписаниеОповещения - Оповещение, которое вызывается на клиенте, передается результат резервирования.
//
Функция СтруктураПараметровПечатиНовогоКодаМаркировки(СтруктураПечати, Форма, Оповещение = Неопределено) Экспорт
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Оповещение",              Оповещение);
	СтруктураПараметров.Вставить("СтруктураПечатиЭтикетки", СтруктураПечати);
	СтруктураПараметров.Вставить("Действие",                "Начало");
	СтруктураПараметров.Вставить("Форма",                   Форма);
	СтруктураПараметров.Вставить("Организация",             Неопределено);
	СтруктураПараметров.Вставить("ВидПродукции",            Неопределено);
	СтруктураПараметров.Вставить("Документ",                Неопределено);
	СтруктураПараметров.Вставить("СразуНаПринтер",          Ложь);
	СтруктураПараметров.Вставить("Шаблон",                  Неопределено);
	СтруктураПараметров.Вставить("ШаблонЭтикетки",          Неопределено);
	СтруктураПараметров.Вставить("Шаблоны",                 Новый Массив());
	СтруктураПараметров.Вставить("ПараметрыСканирования",   Неопределено);
	СтруктураПараметров.Вставить("Номенклатура",            Неопределено);
	СтруктураПараметров.Вставить("Характеристика",          Неопределено);
	СтруктураПараметров.Вставить("Серия",                   Неопределено);
	СписокШаблонов = ИнтеграцияИСМПКлиентСервер.ШаблоныКодовПоНоменклатуре(СтруктураПечати.Номенклатура);
	СтруктураПараметров.Шаблоны = СписокШаблонов.ВыгрузитьЗначения();
	
	Возврат СтруктураПараметров;
	
КонецФункции

#КонецОбласти