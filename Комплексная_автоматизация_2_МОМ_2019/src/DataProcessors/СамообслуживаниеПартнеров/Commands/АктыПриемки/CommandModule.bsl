

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Документ.АктОРасхожденияхПослеОтгрузки.Форма.ФормаСпискаСамообслуживание",
				,
				ПараметрыВыполненияКоманды.Источник,
				ПараметрыВыполненияКоманды.Уникальность,
				ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
