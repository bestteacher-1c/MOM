
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗапуститьЗадание(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(ТекущиеДанные.Спецификация);
	ЗапуститьЗаданиеНаСервере(МассивСсылок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗапуститьЗаданиеНаСервере(МассивСсылок)
	
	РегистрыСведений.ЗаданияКРасчетуДлительностиПроизводства.ЗапуститьЗадание(МассивСсылок);
	
КонецПроцедуры

#КонецОбласти


