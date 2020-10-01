#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ШаблоныСхемыКомпоновкиДанных() Экспорт
	
	Шаблоны = Новый Массив;
	
	Для каждого Макет Из Метаданные.Обработки.ИсточникиДанныхПланированияУП.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Если Макет.Имя = "ПроизводствоПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство")
			ИЛИ Макет.Имя = "ОбеспечениеЗаказовПроизводстваПредопределенный" И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		Шаблоны.Добавить(Новый Структура("Имя, Синоним, ПолноеИмяИсточникаШаблонов", Макет.Имя, Макет.Синоним, "Обработка.ИсточникиДанныхПланированияУП"));
		
	КонецЦикла;
	
	Возврат Шаблоны;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли