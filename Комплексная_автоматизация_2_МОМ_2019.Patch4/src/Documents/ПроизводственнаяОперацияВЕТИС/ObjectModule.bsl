
&После("ОбработкаПроведения")
Процедура bt_Patch4_ОбработкаПроведения(Отказ, РежимПроведения)
	
	Если Сырье.Количество() = 0 Тогда
	
		Отказ = Истина;
	
	КонецЕсли;
	
КонецПроцедуры
