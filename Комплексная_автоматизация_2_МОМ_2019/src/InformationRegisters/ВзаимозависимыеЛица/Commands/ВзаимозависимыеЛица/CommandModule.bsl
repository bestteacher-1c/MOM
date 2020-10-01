#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Организации") Тогда
		ПараметрыФормы.Вставить("Организация", ПараметрКоманды);
	КонецЕсли;
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Контрагенты") Тогда
		ПараметрыФормы.Вставить("Контрагент", ПараметрКоманды);
	КонецЕсли;
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.ФормаСписка", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры

#КонецОбласти