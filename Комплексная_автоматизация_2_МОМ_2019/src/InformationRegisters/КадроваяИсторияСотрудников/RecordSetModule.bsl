#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПередЗаписью(ЭтотОбъект);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблицПередЗаписью", МенеджерВременныхТаблиц);
	ЗарплатаКадрыПериодическиеРегистры.СоздатьВТСтарыйНаборЗаписей(ЭтотОбъект, МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыПериодическиеРегистры.КонтрольИзмененийПриЗаписи(ЭтотОбъект);
	
	ОбновитьИнтервальныйРегистрСведений();
	
	КадровыйУчет.КадроваяИсторияСотрудниковПриЗаписи(ЭтотОбъект, Отказ);
	
	ИзменившиесяДанные = ЗарплатаКадрыПериодическиеРегистры.ТаблицаИзменившихсяДанныхНабора(ЭтотОбъект);
	КадровыйУчет.ОбработатьИзменениеОрганизацийВНаборе(ИзменившиесяДанные);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьИнтервальныйРегистрСведений()
	
	МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблицПередЗаписью;
	ИзменившиесяДанныеНабора = ЗарплатаКадрыПериодическиеРегистры.ТаблицаИзменившихсяДанныхНабора(ЭтотОбъект); 
	
	Если ИзменившиесяДанныеНабора <> Неопределено
		И ИзменившиесяДанныеНабора.Количество() > 0 Тогда
		
		СписокСотрудников = ИзменившиесяДанныеНабора.ВыгрузитьКолонку("Сотрудник");
			
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Сотрудники.Ссылка КАК Сотрудник
			|ПОМЕСТИТЬ ВТТаблицаОтбора
			|ИЗ
			|	Справочник.Сотрудники КАК Сотрудники
			|ГДЕ
			|	Сотрудники.Ссылка В(&СписокСотрудников)";
		Запрос.УстановитьПараметр("СписокСотрудников", СписокСотрудников);
		Запрос.Выполнить();
		
		ЗарплатаКадрыПериодическиеРегистры.СоздатьВТРегистраторыДляОбновления(
			"КадроваяИсторияСотрудников", 
			МенеджерВременныхТаблиц, 
			"Сотрудник", 
			ЭтотОбъект);
		
	КонецЕсли;
	
	ПараметрыПостроения = ЗарплатаКадрыПериодическиеРегистры.ПараметрыПостроенияИнтервальногоРегистра();
	ПараметрыПостроения.ОсновноеИзмерение = "Сотрудник";
	ПараметрыПостроения.ПараметрыРесурсов = РегистрыСведений.КадроваяИсторияСотрудников.ПараметрыНаследованияРесурсов();

	ЗарплатаКадрыПериодическиеРегистры.СформироватьДвиженияИнтервальногоРегистраПоИзменениям(
		"КадроваяИсторияСотрудников", 
		ЭтотОбъект, 
		МенеджерВременныхТаблиц, 
		ПараметрыПостроения);
		
	Если ДополнительныеСвойства.Свойство("ОбновлятьУвольнение")
		И ДополнительныеСвойства.ОбновлятьУвольнение
		И ИзменившиесяДанныеНабора <> Неопределено
		И ИзменившиесяДанныеНабора.Количество() Тогда
		
		ОбновитьВторичныеДанныеУвольнения(МенеджерВременныхТаблиц);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьВторичныеДанныеУвольнения(МенеджерВременныхТаблиц)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РегистрСведений.Период КАК Период,
	|	РегистрСведений.Регистратор КАК Регистратор,
	|	РегистрСведенийИнтервальный.ДатаОкончания КАК ДатаОкончания,
	|	РегистрСведенийИнтервальный.ДатаНачала КАК ДатаНачала,
	|	РегистрСведенийИнтервальный.ПериодЗаписи КАК ПериодЗаписи,
	|	РегистрСведенийИнтервальный.Год КАК Год,
	|	РегистрСведенийИнтервальный.ПериодПредыдущейЗаписи КАК ПериодПредыдущейЗаписи,
	|	РегистрСведений.Регистратор КАК РегистраторЗаписи,
	|	РегистрСведений.Регистратор КАК РегистраторСобытия,
	|	#ТекстОписанияПолейРегистра,
	|	#ТекстОписанияПолейСреза  
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников КАК РегистрСведений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРегистраторыДляОбновления КАК ВТРегистраторыДляОбновления
	|		ПО ВТРегистраторыДляОбновления.Регистратор = РегистрСведений.Регистратор 
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК РегистрСведенийСрез
	|		ПО (ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РегистрСведений.Период, ДЕНЬ), СЕКУНДА, -1) >= РегистрСведенийСрез.ДатаНачала)
	|			И (ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(РегистрСведений.Период, ДЕНЬ), СЕКУНДА, -1) <= РегистрСведенийСрез.ДатаОкончания)
	|			И РегистрСведений.Сотрудник = РегистрСведенийСрез.Сотрудник
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КадроваяИсторияСотрудниковИнтервальный КАК РегистрСведенийИнтервальный
	|		ПО (РегистрСведений.Период = РегистрСведенийИнтервальный.ДатаНачала)
	|			И (РегистрСведений.Период <= РегистрСведенийИнтервальный.ДатаОкончания)
	|			И РегистрСведений.Сотрудник = РегистрСведенийИнтервальный.Сотрудник 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Регистратор";
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ОписаниеРегистра = ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеРегистра("КадроваяИсторияСотрудников");
	
	МассивСтрокОписанияПолейРегистра = Новый Массив;
	МассивСтрокОписанияПолейСреза = Новый Массив;
	Разделитель = "," + Символы.ПС;
	Для каждого Измерение Из ОписаниеРегистра.Измерения Цикл
	
		МассивСтрокОписанияПолейРегистра.Добавить("РегистрСведений.");
		МассивСтрокОписанияПолейРегистра.Добавить(Измерение);
		МассивСтрокОписанияПолейРегистра.Добавить(Разделитель);

	КонецЦикла; 	
	
	Для каждого Реквизит Из ОписаниеРегистра.Реквизиты Цикл
		
		МассивСтрокОписанияПолейРегистра.Добавить("РегистрСведений.");
		МассивСтрокОписанияПолейРегистра.Добавить(Реквизит);
		МассивСтрокОписанияПолейРегистра.Добавить(Разделитель);
	
	КонецЦикла; 
		
	Для каждого Ресурс Из ОписаниеРегистра.ВозвратныеРесурсы Цикл
	
		МассивСтрокОписанияПолейСреза.Добавить("РегистрСведенийСрез.");
		МассивСтрокОписанияПолейСреза.Добавить(Ресурс);
		МассивСтрокОписанияПолейСреза.Добавить(Разделитель);
		
	КонецЦикла; 
		
	Для каждого Ресурс Из ОписаниеРегистра.Ресурсы Цикл
	
		МассивСтрокОписанияПолейСреза.Добавить("РегистрСведенийСрез.");
		МассивСтрокОписанияПолейСреза.Добавить(Ресурс);
		МассивСтрокОписанияПолейСреза.Добавить(Разделитель); 
	
	КонецЦикла;
	
	Если МассивСтрокОписанияПолейРегистра.Количество() > 0 Тогда
		МассивСтрокОписанияПолейРегистра.Удалить(МассивСтрокОписанияПолейРегистра.Количество() - 1);
	КонецЕсли; 
	
	Если МассивСтрокОписанияПолейСреза.Количество() > 0 Тогда
		МассивСтрокОписанияПолейСреза.Удалить(МассивСтрокОписанияПолейСреза.Количество() - 1);
	КонецЕсли; 
	
	ТекстОписанияПолейРегистра = СтрСоединить(МассивСтрокОписанияПолейРегистра);
	ТекстОписанияПолейСреза = СтрСоединить(МассивСтрокОписанияПолейСреза);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТекстОписанияПолейРегистра", ТекстОписанияПолейРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ТекстОписанияПолейСреза", 	ТекстОписанияПолейСреза);
	ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьЗапросУничтоженияВременнойТаблицы(ТекстЗапроса, "ВТРегистраторыДляОбновления");
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	НаборЗаписей = РегистрыСведений.КадроваяИсторияСотрудников.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("ЭтоВторичныйНабор", Истина);
	НаборЗаписейИнтервальный = РегистрыСведений.КадроваяИсторияСотрудниковИнтервальный.СоздатьНаборЗаписей();
	
	Пока Выборка.СледующийПоЗначениюПоля("Регистратор") Цикл
		
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		Пока Выборка.Следующий() Цикл
		
			НоваяСтрока = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ВидСобытия = Перечисления.ВидыКадровыхСобытий.Увольнение;
			
			НаборЗаписейИнтервальный.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
			НаборЗаписейИнтервальный.Отбор.ДатаНачала.Установить(Выборка.Период);
			НоваяСтрокаИнтервальный = НаборЗаписейИнтервальный.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаИнтервальный, Выборка);
			НоваяСтрокаИнтервальный.ВидСобытия = Перечисления.ВидыКадровыхСобытий.Увольнение;
			НаборЗаписейИнтервальный.Записать();
			НаборЗаписейИнтервальный.Очистить();
			
		КонецЦикла; 
		НаборЗаписей.Записать();
		НаборЗаписей.Очистить();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли