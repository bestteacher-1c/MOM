////////////////////////////////////////////////////////////////////////////////
// Содержит события форм, вызываемые на клиенте
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Выполняет переопределяемую команду
//
// Параметры:
//  Форма	- ФормаКлиентскогоПриложения - форма, в которой расположена команда
//  Команда	- КомандаФормы - команда формы
//  ДополнительныеПараметры	- Структура - дополнительные параметры.
//
Процедура ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ НЕ УТ
	ИнтеграцияССППРКлиент.ВыполнитьКомандуИнтеграцииССППР(Форма, Команда, ДополнительныеПараметры);
	
	ПроверкаДокументовКлиент.ВыполнитьКомандуИзмененияСтатусаПроверкиДокумента(Форма, Команда);
	//-- НЕ УТ
	
	МодификацияКонфигурацииКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры);
	
	СобытияФормКлиентЛокализация.ВыполнитьПереопределяемуюКоманду(Форма, Команда, ДополнительныеПараметры);
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма					- ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  ИмяСобытия				- Строка - идентификатор сообщения принимающей формой (см. метод Оповестить)
//	Параметр				- Произвольный - параметр сообщения (см. метод Оповестить)
//	Источник				- Произвольный - источник события (см. метод Оповестить)
//  ДополнительныеПараметры	- Структура - дополнительные параметры.
//
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры = Неопределено) Экспорт
	
	//++ НЕ УТ
	ПроверкаДокументовКлиент.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник);
	//-- НЕ УТ
	
	СобытияФормКлиентЛокализация.ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник, ДополнительныеПараметры);
	
	Возврат;
	
КонецПроцедуры

// Процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
//  Форма					- ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
//  Отказ					- Булево - признак отказа от записи документа
//	ПараметрыЗаписи			- Структура - параметры записи (см. событие ПередЗаписью).
//
Процедура ПередЗаписью(Форма, Отказ, ПараметрыЗаписи) Экспорт
	
	//++ НЕ УТ
	ПроверкаДокументовКлиент.ПередЗаписью(Форма, Отказ, ПараметрыЗаписи);
	//-- НЕ УТ
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - форма, из обработчика события которой происходит вызов процедуры.
//	см. справочную информацию по событиям управляемой формы.
//
Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	СобытияФормКлиентЛокализация.ПослеЗаписи(Форма, ПараметрыЗаписи);
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(Форма, ПараметрыЗаписи);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - форма, из обработчика события которой происходит вызов процедуры.
//	см. справочную информацию по событиям управляемой формы.
//
Процедура ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	СобытияФормКлиентЛокализация.ОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - Произвольный     - элемент-источник события "При изменении".
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры = Неопределено) Экспорт
	
	СобытияФормКлиентЛокализация.ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры = Неопределено) Экспорт
	
	СобытияФормКлиентЛокализация.ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры = Неопределено) Экспорт
	
	СобытияФормКлиентЛокализация.ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры);
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры = Неопределено) Экспорт
	
	СобытияФормКлиентЛокализация.ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры);
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти
