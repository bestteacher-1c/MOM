
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДополнительныеПараметры = Новый Структура("ЗаголовокОкна,ЗаголовокНетОбновления");
	ДополнительныеПараметры.ЗаголовокОкна = НСтр("ru = 'Переход на программу: 1С:Управление торговлей ред. 11'");
	ДополнительныеПараметры.ЗаголовокНетОбновления = НСтр("ru = 'Обновления отсутствуют.'");
	
	ПолучениеОбновленийПрограммыКлиент.ПерейтиНаДругуюПрограмму("Trade",,ДополнительныеПараметры);
	
КонецПроцедуры

#КонецОбласти


