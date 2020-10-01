
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ЗначенияПеречисления = Новый Массив;
		Если Параметры.Отбор.Свойство("Ссылка") Тогда
			ЗначенияПеречисления.Добавить(Параметры.Отбор.Ссылка);
		Иначе
			ЗначенияПеречисления.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Покупка"));
			ЗначенияПеречисления.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.Перемещение"));
			ЗначенияПеречисления.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.СборкаРазборка"));
			ЗначенияПеречисления.Добавить(ПредопределенноеЗначение("Перечисление.ТипыОбеспечения.ПроизводствоНаСтороне"));
			// Производство не добавляется т.к. не используется
		КонецЕсли;
		
		ДанныеВыбора = Новый СписокЗначений; // результат
		
		Для Каждого Значение Из ЗначенияПеречисления Цикл
			Если Не ЗначениеЗаполнено(Параметры.СтрокаПоиска)
				Или СтрНайти(НРег(Значение), НРег(Параметры.СтрокаПоиска)) = 1 Тогда
				ДанныеВыбора.Добавить(Значение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

