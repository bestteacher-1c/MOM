#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплаты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СценарииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	
	МожноЗаполнитьЗарплату = 
		ВедомостьНаВыплатуЗарплаты.МожноЗаполнитьЗарплату(ЭтотОбъект);
		
	ПравилаПроверки = Новый Структура;
	ПравилаПроверки.Вставить("Раздатчик", НСтр("ru='Не указан раздатчик'"));
	
	МожноЗаполнитьЗарплату = 
		ЗарплатаКадры.СвойстваЗаполнены(ЭтотОбъект, ПравилаПроверки)
		И МожноЗаполнитьЗарплату;
	
	Возврат МожноЗаполнитьЗарплату
	
КонецФункции

#КонецОбласти

#Область МестоВыплаты

Функция МестоВыплаты() Экспорт
	МестоВыплаты = ВедомостьНаВыплатуЗарплаты.МестоВыплаты();
	МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.Раздатчик;
	МестоВыплаты.Значение = Раздатчик;
	Возврат МестоВыплаты
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	Раздатчик = Значение
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

Процедура ОчиститьВыплаты() Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВыплаты(ЭтотОбъект);
КонецПроцедуры	

Процедура ЗагрузитьВыплаты(Зарплата, НДФЛ) Экспорт
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ);
КонецПроцедуры

Процедура ДобавитьВыплаты(Зарплата, НДФЛ) Экспорт
	ВедомостьНаВыплатуЗарплаты.ДобавитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ)
КонецПроцедуры

Процедура УстановитьНДФЛ(НДФЛ, Знач ФизическиеЛица = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьНДФЛ(ЭтотОбъект, НДФЛ, ФизическиеЛица)
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли