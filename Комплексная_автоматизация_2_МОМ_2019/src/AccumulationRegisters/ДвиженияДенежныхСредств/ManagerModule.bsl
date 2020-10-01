#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

//++ НЕ УТ
#Область ПрограммныйИнтерфейс

// Определяет показатели регистра.
// Подробнее см. ОбщийМодуль.МеждународныйУчетСерверПовтИсп.Показатели().
//
// Параметры:
//  Свойства - Структура - содержащая ключи СвойстваПоказателей, СвойстваРесурсов.
//
// Возвращаемое значение:
//  Соответствие - Ключ - имя показателя.
//                 Значение - структура свойств показателя.
//
Функция Показатели(Свойства) Экспорт

	Показатели = Новый Соответствие;
	
	СвойстваПоказателей = Свойства.СвойстваПоказателей;
	СвойстваРесурсов = Свойства.СвойстваРесурсов;
	
	// Массив содержит не только ресурсы регистров, но и производные от них поля в запросах.
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "Сумма", "ВалютаУпр"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаРегл", "ВалютаРегл"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВВалюте", "Валюта"));
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаВКорВалюте", "КорВалюта"));
	
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.Сумма, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаКВыплатеВРамкахЛимита", "Валюта"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаКВыплатеВРамкахЛимита, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаКВыплатеСверхЛимита", "Валюта"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаКВыплатеСверхЛимита, Новый Структура(СвойстваПоказателей, МассивРесурсов));
	
	МассивРесурсов = Новый Массив;
	МассивРесурсов.Добавить(Новый Структура(СвойстваРесурсов, "СуммаКВыплате", "Валюта"));
	Показатели.Вставить(Перечисления.ПоказателиАналитическихРегистров.СуммаКВыплате, Новый Структура(СвойстваПоказателей, МассивРесурсов));

	Возврат Показатели;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)
	|	И( ВЫБОР КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.Кассы) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.КассыККМ) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	КОГДА ТипЗначения(ДенежныеСредства) = Тип(Справочник.ФизическиеЛица) ТОГДА ЗначениеРазрешено(ДенежныеСредства)
	|	ИНАЧЕ ИСТИНА КОНЕЦ) ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецЕсли
