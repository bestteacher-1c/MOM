#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СписокФизическихЛиц = Новый Массив;
	Если Количество() Тогда
		СписокФизическихЛиц = ВыгрузитьКолонку("ФизическоеЛицо");
	Иначе
		Выборка = РегистрыСведений.СтандартныеВычетыФизическихЛицНДФЛ.ВыбратьПоРегистратору(Отбор.Регистратор.Значение);
		Пока Выборка.Следующий() Цикл
			СписокФизическихЛиц.Добавить(Выборка.ФизическоеЛицо);
		КонецЦикла;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ФизическиеЛица", СписокФизическихЛиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СписокФизическихЛиц = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ФизическиеЛица", СписокФизическихЛиц) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РегистрыСведений.СтандартныеВычетыПоНДФЛВторичный.ЗаполнитьВторичныеДанныеЛичныеВычеты(СписокФизическихЛиц);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли