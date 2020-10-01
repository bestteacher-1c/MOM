#Область СлужебныйПрограммныйИнтерфейс

#Область Печать

// См. УправлениеПечатьюПереопределяемый.ПриОпределенииОбъектовСКомандамиПечати.
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить(Документы.ПереносДанных);
	
КонецПроцедуры

#КонецОбласти

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbfa0-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ПереносДанных);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

