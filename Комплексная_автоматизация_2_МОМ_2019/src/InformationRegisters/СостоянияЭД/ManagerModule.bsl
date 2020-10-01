#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления БЭД 1.2.7.8
// Изменяет состояние УдалитьУдалитьОжидаетсяИзвещение на ОжидаетсяИзвещениеОПолучении.
//
// Параметры:
//  Параметры - Структура - параметры обработчика обновления.
//
Процедура УдалитьСостояниеУдалитьОжидаетсяИзвещение(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияЭД.СсылкаНаОбъект
	               |ИЗ
	               |	РегистрСведений.СостоянияЭД КАК СостоянияЭД
	               |ГДЕ
	               |	СостоянияЭД.СостояниеВерсииЭД = ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.УдалитьОжидаетсяИзвещение)";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.СостоянияЭД.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.СсылкаНаОбъект.Установить(Выборка.СсылкаНаОбъект);
		НаборЗаписей.Прочитать();
		Для Каждого Запись Из НаборЗаписей Цикл
			Запись.СостояниеВерсииЭД = Перечисления.СостоянияВерсийЭД.ОжидаетсяИзвещениеОПолучении;
		КонецЦикла;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Истина;
	
КонецПроцедуры

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоДвижения = Ложь;
	ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.СостоянияЭД";
	ДополнительныеПараметры.ОтметитьВсеРегистраторы = Ложь;
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	
	Данные = ДанныеКОбработкеДляПереходаНаНовуюВерсию();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Данные, ДополнительныеПараметры);
	
КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.СостоянияЭД;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяОбъекта, ДополнительныеПараметры);
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("СсылкаНаОбъект", Выборка.СсылкаНаОбъект);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.СостоянияЭД.СоздатьНаборЗаписей();
			Набор.Отбор.СсылкаНаОбъект.Установить(Выборка.СсылкаНаОбъект);
			Набор.Прочитать();
			
			ОбработатьДанные_ЗаполнитьОписаниеОснованияЭД(Набор);
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор);
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЦикла;
	
	Если Параметры.ПрогрессВыполнения.ВсегоОбъектов = 0 Тогда
		Параметры.ПрогрессВыполнения.ВсегоОбъектов = КоличествоДанныхКОбработкеДляПереходаНаНовуюВерсию();
	КонецЕсли;
	
	Параметры.ПрогрессВыполнения.ОбработаноОбъектов  = Параметры.ПрогрессВыполнения.ОбработаноОбъектов  + Выборка.Количество();
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеКОбработкеДляПереходаНаНовуюВерсию() 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СостоянияЭД.СсылкаНаОбъект КАК СсылкаНаОбъект
	|ИЗ
	|	РегистрСведений.СостоянияЭД КАК СостоянияЭД
	|ГДЕ
	|	СостоянияЭД.Вид = """"
	|	И СостоянияЭД.СостояниеВерсииЭД = ЗНАЧЕНИЕ(Перечисление.СостоянияВерсийЭД.НеСформирован)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция КоличествоДанныхКОбработкеДляПереходаНаНовуюВерсию() 
	
	Данные = ДанныеКОбработкеДляПереходаНаНовуюВерсию();
	Возврат Данные.Количество();
	
КонецФункции

Процедура ОбработатьДанные_ЗаполнитьОписаниеОснованияЭД(Набор) 
	
	Описание = Неопределено;
	
	ЗаписиДляУдаления = Новый Массив;
	
	Для Каждого Запись Из Набор Цикл
		
		Если Запись.СсылкаНаОбъект = Неопределено Тогда
			ЗаписиДляУдаления.Добавить(Запись);
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Запись.Вид) 
			ИЛИ Запись.СостояниеВерсииЭД <> Перечисления.СостоянияВерсийЭД.НеСформирован Тогда
			Продолжить;
		КонецЕсли;
		
		Если Описание = Неопределено Тогда
			Описание = ОбменСКонтрагентамиСлужебный.ОписаниеОснованияЭлектронногоДокумента(Запись.СсылкаНаОбъект);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(Запись, Описание);
		
	КонецЦикла;
	
	Для Каждого Запись Из ЗаписиДляУдаления Цикл
		Набор.Удалить(Запись);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли





