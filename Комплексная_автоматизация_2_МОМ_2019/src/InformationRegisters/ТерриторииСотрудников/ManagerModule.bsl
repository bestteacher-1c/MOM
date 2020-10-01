
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ГоловнаяОрганизация)
	|	И ЗначениеРазрешено(ФизическоеЛицо)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет интервальный регистр сведений ТерриторииСотрудниковИнтервальный.
//
Процедура ЗаполнитьИнтервальныйРегистр(ПараметрыОбновления = Неопределено) Экспорт
	
	ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
	ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
	ПараметрыПостроения.ПараметрыРесурсов = ПараметрыНаследованияРесурсов();
	
	ЗарплатаКадрыПериодическиеРегистры.ПеренестиВозвратныйРегистрВИнтервальныйРегистрСведений(
		Метаданные.РегистрыСведений.ТерриторииСотрудников.Имя,
		ПараметрыПостроения,
		ПараметрыОбновления);
	
КонецПроцедуры
	
Функция ПараметрыНаследованияРесурсов() Экспорт
	Возврат ЗарплатаКадрыПериодическиеРегистры.ПараметрыНаследованияРесурсов(Метаданные.РегистрыСведений.ТерриторииСотрудников.Имя);
КонецФункции

#КонецОбласти

#КонецЕсли
