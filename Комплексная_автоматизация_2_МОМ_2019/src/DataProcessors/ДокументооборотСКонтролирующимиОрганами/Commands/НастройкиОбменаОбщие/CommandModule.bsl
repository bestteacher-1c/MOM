
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПараметрыВыполненияКоманды = ДополнительныеПараметры.ПараметрыВыполненияКоманды;
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ТекстОшибки);
	Иначе
		КонтекстЭДОКлиент.ОткрытьФормуОбщихНастроекЭДО(ПараметрыВыполненияКоманды.Окно);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

