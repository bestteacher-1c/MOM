#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Обработка.НастройкаОтраженияДокументовВРеглУчете.Команда.ОтражениеДокументовВРеглУчете");
	
	 ПараметрыФормы = Новый Структура("", );
	 ОткрытьФорму("Обработка.НастройкаОтраженияДокументовВРеглУчете.Форма",
	 	ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	 
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти