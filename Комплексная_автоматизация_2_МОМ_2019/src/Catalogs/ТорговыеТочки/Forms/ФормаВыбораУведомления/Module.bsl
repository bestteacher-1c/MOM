
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперации = Параметры.ВидОперации;
	
	Заголовки = Новый Соответствие();
	Заголовки.Вставить(Перечисления.ВидыОперацийТорговыеТочки.Регистрация,			НСтр("ru = 'Уведомления о постановке на учет'"));
	Заголовки.Вставить(Перечисления.ВидыОперацийТорговыеТочки.ИзменениеПараметров,	НСтр("ru = 'Уведомления об изменении параметров'"));
	Заголовки.Вставить(Перечисления.ВидыОперацийТорговыеТочки.СнятиеСУчета,			НСтр("ru = 'Уведомления о снятии с учета'"));
	ТекстЗаголовкаПоКоду = Заголовки.Получить(ВидОперации);
	
	Если ТекстЗаголовкаПоКоду <> Неопределено Тогда
		Заголовок = ТекстЗаголовкаПоКоду;
	КонецЕсли;
	
	КодыПричины = Новый Соответствие();
	КодыПричины.Вставить(Перечисления.ВидыОперацийТорговыеТочки.Регистрация,			"1");
	КодыПричины.Вставить(Перечисления.ВидыОперацийТорговыеТочки.ИзменениеПараметров,	"2");
	КодыПричины.Вставить(Перечисления.ВидыОперацийТорговыеТочки.СнятиеСУчета,			"3");
	
	Организация	= Параметры.Организация;
	КодПричины	= КодыПричины.Получить(ВидОперации);
	
	СформироватьСписокУведомлений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ТипЗнч(Источник) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения")
		И (ИмяСобытия = "Создание_ФормаТС1" ИЛИ ИмяСобытия = "Запись_УведомлениеОСпецрежимахНалогообложения") Тогда
		
		СформироватьСписокУведомлений();

	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыУведомлений

&НаКлиенте
Процедура ТаблицаУведомленийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОповеститьОВыборе(Элементы.ТаблицаУведомлений.ТекущиеДанные.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаУведомленийПередНачаломИзменения(Элемент, Отказ)
	ПоказатьЗначение( ,Элемент.ТекущиеДанные.Ссылка);
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция АдресТорговойТочки(СведенияИзУведомления)
	
	Сведения = Новый Структура("Индекс, Код_региона, Населенный_пункт, Город, Улица, Дом, Корпус, Квартира");
	ЗаполнитьЗначенияСвойств(Сведения, СведенияИзУведомления);
	
	Адрес = Новый Массив(8);
	
	Адрес.Установить(0, Сведения.Индекс);
	Адрес.Установить(1, АдресныйКлассификатор.НаименованиеРегионаПоКоду(Сведения.Код_региона));
	Адрес.Установить(2, Сведения.Населенный_пункт);
	Адрес.Установить(3, Сведения.Город);
	Адрес.Установить(4, Сведения.Улица);
	Адрес.Установить(5, ?(ЗначениеЗаполнено(Сведения.Дом),		СтрШаблон(НСтр("ru = 'дом № %1'"),	Сведения.Дом),		""));
	Адрес.Установить(6, ?(ЗначениеЗаполнено(Сведения.Корпус),	СтрШаблон(НСтр("ru = 'корпус %1'"),	Сведения.Корпус),	""));
	Адрес.Установить(7, ?(ЗначениеЗаполнено(Сведения.Квартира),	СтрШаблон(НСтр("ru = 'кв. %1'"),	Сведения.Квартира),	""));
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(Адрес, "");
	
	Возврат СтрСоединить(Адрес, ", ");
	
КонецФункции

&НаСервере
Процедура СформироватьСписокУведомлений()
	
	ТаблицаУведомлений.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	УведомлениеОСпецрежимахНалогообложения.Ссылка,
	|	УведомлениеОСпецрежимахНалогообложения.ДанныеУведомления,
	|	УведомлениеОСпецрежимахНалогообложения.РегистрацияВИФНС.Наименование КАК Орган,
	|	УведомлениеОСпецрежимахНалогообложения.Дата
	|ИЗ
	|	Документ.УведомлениеОСпецрежимахНалогообложения КАК УведомлениеОСпецрежимахНалогообложения
	|ГДЕ
	|	УведомлениеОСпецрежимахНалогообложения.Организация = &Организация
	|	И НЕ УведомлениеОСпецрежимахНалогообложения.ПометкаУдаления
	|	И УведомлениеОСпецрежимахНалогообложения.ИмяОтчета =&УведомлениеТС1";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("УведомлениеТС1", "РегламентированноеУведомлениеТС1");
	
	ДокументыУведомлений = Запрос.Выполнить().Выбрать();
	
	Пока ДокументыУведомлений.Следующий() Цикл
		
		Если ТипЗнч(ДокументыУведомлений.ДанныеУведомления) = Тип("ХранилищеЗначения") Тогда
			
			ДанныеУведомления = ДокументыУведомлений.ДанныеУведомления.Получить();
			
			Если ДанныеУведомления.КодПричины = КодПричины Тогда
				
				Сведения = ДанныеУведомления.Сведения;
				
				Для Каждого СведенияОТорговойТочке Из Сведения Цикл
					
					СтрокаУведомлений 				= ТаблицаУведомлений.Добавить();
					СтрокаУведомлений.Ссылка 		= ДокументыУведомлений.Ссылка;
					СтрокаУведомлений.Орган 		= ДокументыУведомлений.Орган;
					СтрокаУведомлений.ТорговаяТочка = СведенияОТорговойТочке.НаимТоргОб;
					СтрокаУведомлений.Дата 			= СведенияОТорговойТочке.ДАТА_ПРАВА;
					СтрокаУведомлений.Адрес 		= АдресТорговойТочки(СведенияОТорговойТочке);
					СтрокаУведомлений.ТорговыйСбор	= СведенияОТорговойТочке.СуммаСбораИтого;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;

	ТаблицаУведомлений.Сортировать("ТорговаяТочка Возр");
	
КонецПроцедуры

#КонецОбласти

