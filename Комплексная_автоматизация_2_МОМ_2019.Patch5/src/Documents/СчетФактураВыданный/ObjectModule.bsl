
&После("ОбработкаЗаполнения")
Процедура bt_Patch5_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			
		Если ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
			
			Если ТипЗнч(ДанныеЗаполнения.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			
				Дата = ДанныеЗаполнения.ДокументОснование.Дата;
				Номер = ДанныеЗаполнения.ДокументОснование.Номер;
				ДатаВыставления = ДанныеЗаполнения.ДокументОснование.Дата;
			
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
