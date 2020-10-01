////////////////////////////////////////////////////////////////////////////////
// Процедуры подсистемы "Производство"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Настройки

// Получает настройки подсистемы "Производство"
// 
// Возвращаемое значение:
//   - Структура - настройки подсистемы "Производство".
//
Функция НастройкиПодсистемыПроизводство() Экспорт
	
	Возврат ПроизводствоСервер.НастройкиПодсистемыПроизводство();
	
КонецФункции

// Возвращает параметры производственного подразделения
//
// Параметры:
//  Подразделение	- СправочникСсылка.СтруктураПредприятия - Подразделение для которого требуется получить параметры.
//
// Возвращаемое значение:
//   Структура   - содержит параметры производственного подразделения.
//
Функция ПараметрыПроизводственногоПодразделения(Подразделение) Экспорт

	Возврат ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение);
	
КонецФункции

// Определяет вид цены выпуска продукции по умолчанию
// 
// Возвращаемое значение:
//  СправочникСсылка.ВидыЦен - вид цены плановой стоимости.
//
Функция ВидЦеныПлановойСтоимости() Экспорт
	
	ВидЦены = Справочники.ВидыЦен.ВидЦеныПлановойСтоимостиТМЦ();
	Возврат ВидЦены;
	
КонецФункции

#КонецОбласти

#КонецОбласти
