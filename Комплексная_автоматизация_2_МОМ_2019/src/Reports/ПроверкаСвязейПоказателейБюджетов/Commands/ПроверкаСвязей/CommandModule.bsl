
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// Вставить содержимое обработчика.
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта", "ПроверкаСвязейПоказателейБюджетов");
	ПараметрыФормы.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ПроверкаСвязейПоказателейБюджетов.Форма", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
