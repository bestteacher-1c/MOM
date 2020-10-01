
#Область ПрограммныйИнтерфейс

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам.
// 
// Параметры:
//  ТипОбъекта - Строка - идентификатор типа объекта, который необходимо найти;
//  ИДОбъекта - Строка - идентификатор объекта заданного типа;
//  ДополнительныеРеквизиты - Структура - набор дополнительных полей объекта для поиска;
//
Функция НайтиСсылкуНаОбъект(ТипОбъекта,
							ИдОбъекта = "",
							ДополнительныеРеквизиты = Неопределено) Экспорт
							
	Результат = Неопределено;
	ЭлектронноеВзаимодействиеПереопределяемый.НайтиСсылкуНаОбъект(ТипОбъекта,
																	Результат,
																	ИдОбъекта,
																	ДополнительныеРеквизиты);
																	
	Возврат Результат 
	
КонецФункции

Функция ДанныеДляЗаполнения(НоменклатураКонтрагента) Экспорт
	
	ДанныеЗаполнения = ЭлектронноеВзаимодействиеУТ.ДанныеДляЗаполнения(НоменклатураКонтрагента);
	Возврат ДанныеЗаполнения;
	
КонецФункции

Функция ВернутьЕдиницуХранения(Номенклатура) Экспорт
	
	Возврат Номенклатура.ЕдиницаИзмерения;
	
КонецФункции

#КонецОбласти
