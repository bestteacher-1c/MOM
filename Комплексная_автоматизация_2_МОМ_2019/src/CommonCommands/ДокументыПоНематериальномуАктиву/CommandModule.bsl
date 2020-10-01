
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
		Истина, "ОбщаяКоманда.ДокументыПоНематериальномуАктиву");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НематериальныйАктив", ПараметрКоманды);
	
	// Чтобы можно было открыть несколько форм нужно определить уникальность.
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения")
		И ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.НематериальныеАктивы.Форма.ФормаЭлемента" Тогда
		УникальностьФормы = ПараметрыВыполненияКоманды.Источник;
	Иначе
		УникальностьФормы = ПараметрКоманды;
	КонецЕсли; 
	
	ИмяФормы = ВнеоборотныеАктивыКлиентЛокализация.ИмяФормыДокументыПоНематериальномуАктиву();
	Если ИмяФормы = Неопределено Тогда
		ИмяФормы = "Обработка.ЖурналДокументовНМА2_4.Форма";
	КонецЕсли; 
	
	ОткрытьФорму(ИмяФормы, 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		УникальностьФормы, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
