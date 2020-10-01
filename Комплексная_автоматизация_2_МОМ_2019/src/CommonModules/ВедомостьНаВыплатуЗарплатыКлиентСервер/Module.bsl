////////////////////////////////////////////////////////////////////////////////
// Ведомости на выплату зарплаты.
// Клиент-серверные процедуры и функции.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ДатаВыплаты(Ведомость) Экспорт
	Возврат ?(ЗначениеЗаполнено(Ведомость.ДатаВыплаты), Ведомость.ДатаВыплаты, НачалоДня(Ведомость.Дата));
КонецФункции

Процедура НастроитьПолеВидДоходаИсполнительногоПроизводства(Форма, ИмяЭлемента = "ВидДоходаИсполнительногоПроизводства") Экспорт
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		Форма, ИмяЭлемента, 
		ВидДоходаИсполнительногоПроизводстваОбязателен(Форма.Объект));
КонецПроцедуры

Функция ВидДоходаИсполнительногоПроизводстваОбязателен(Ведомость) Экспорт
	Возврат ВидыДоходовИсполнительногоПроизводстваКлиентСервер.ВидДоходаОбязателенДляБанков(ДатаВыплаты(Ведомость));
КонецФункции

#КонецОбласти
