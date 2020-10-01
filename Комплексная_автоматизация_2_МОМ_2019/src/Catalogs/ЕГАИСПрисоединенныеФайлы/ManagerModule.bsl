#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Возврат РаботаСФайлами.РеквизитыРедактируемыеВГрупповойОбработке();
	
КонецФункции

// Возвращает краткое описание последнего сообщения обмена указанного типа (Передано, ВОчереди, СОшибкой, Любое)
//   по документу. Если такого сообщения нет, возвращает Неопределено.
//
// Параметры:
//   ДокументСсылка         - ОпределяемыйТип.ДокументыЕГАИС - документ для получения описания
//   ТипПоследнегоСообщения - Строка                         - тип сообщения из фиксированного списка
// Возвращаемое значение:
//   Структура - реквизиты сообщения:
//   * ВладелецФайла - ОпределяемыйТип.ДокументыЕГАИСП           - владелец файла
//   * Операция      - ПеречислениеСсылка.ВидыОперацийЕГАИС      - операция обмена
//   * ТипСообщения  - ПеречислениеСсылка.ТипыЗапросовИС         - тип сообщения (исходящий, входящий)
//   * Сообщение     - СправочникСсылка.ЕГАИСПрисоединенныеФайлы - ссылка на сообщение
//                   - Неопределено - сообщение не найдено
//
Функция ПоследнееСообщение(ДокументСсылка, ТипПоследнегоСообщения = "ПереданоВУТМ") Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕГАИСПрисоединенныеФайлы.Ссылка            КАК Сообщение,
	|	ЕГАИСПрисоединенныеФайлы.ТипСообщения      КАК ТипСообщения,
	|	ЕГАИСПрисоединенныеФайлы.ВладелецФайла     КАК ОрганизацияЕГАИС,
	|	ЕГАИСПрисоединенныеФайлы.ФорматОбмена      КАК ФорматОбмена,
	|	ЕГАИСПрисоединенныеФайлы.Операция          КАК Операция,
	|	ЕГАИСПрисоединенныеФайлы.ОперацияКвитанции КАК ОперацияКвитанции
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОчередьПередачиДанныхЕГАИС КАК ОчередьПередачиДанныхЕГАИС
	|		ПО ОчередьПередачиДанныхЕГАИС.Сообщение = ЕГАИСПрисоединенныеФайлы.Ссылка
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЕГАИСПрисоединенныеФайлы КАК ОтветНаПередачуДанных
	|		ПО ЕГАИСПрисоединенныеФайлы.Ссылка = ОтветНаПередачуДанных.СообщениеОснование
	|		И (ЕГАИСПрисоединенныеФайлы.Операция = ОтветНаПередачуДанных.Операция)
	|		И (ОтветНаПередачуДанных.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий))
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.Документ = &Документ
	|	И &Условие
	|УПОРЯДОЧИТЬ ПО
	|	ЕГАИСПрисоединенныеФайлы.ДатаСоздания УБЫВ");
	
	Запрос.УстановитьПараметр("Документ", ДокументСсылка);
	
	Если ТипПоследнегоСообщения = "ПереданоВУТМ" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие",
			"
			|ВЫБОР КОГДА ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Исходящий)
			|	И ОтветНаПередачуДанных.Ссылка ЕСТЬ NULL ТОГДА
			|	ЛОЖЬ
			|ИНАЧЕ
			|	ИСТИНА
			|КОНЕЦ
			|");
	ИначеЕсли ТипПоследнегоСообщения = "ВОчереди" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие",
			"НЕ (ОчередьПередачиДанныхЕГАИС.Сообщение ЕСТЬ NULL)");
	ИначеЕсли ТипПоследнегоСообщения = "СОшибкой" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие",
			"ЕГАИСПрисоединенныеФайлы.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийЕГАИС.Ошибка)");
	ИначеЕсли ТипПоследнегоСообщения = "Любое" Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условие", "ИСТИНА");
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Сообщение");
	ВозвращаемоеЗначение.Вставить("ТипСообщения");
	ВозвращаемоеЗначение.Вставить("Операция");
	ВозвращаемоеЗначение.Вставить("ОрганизацияЕГАИС");
	ВозвращаемоеЗначение.Вставить("ФорматОбмена");
	
	ЗаполнитьЗначенияСвойств(ВозвращаемоеЗначение, Выборка);
	
	Если ЗначениеЗаполнено(Выборка.ОперацияКвитанции) Тогда
		ВозвращаемоеЗначение.Операция = Выборка.ОперацияКвитанции;
	Иначе
		ВозвращаемоеЗначение.Операция = Выборка.Операция;
	КонецЕсли;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕГАИСПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЕГАИСПрисоединенныеФайлы КАК ЕГАИСПрисоединенныеФайлы
	|ГДЕ
	|	ЕГАИСПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыЗапросовИС.Входящий)
	|	И ЕГАИСПрисоединенныеФайлы.Операция В (ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС), ЗНАЧЕНИЕ(Перечисление.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС))";
	
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ЕГАИСПрисоединенныеФайлы";
	МетаданныеОбъекта = Метаданные.Справочники.ЕГАИСПрисоединенныеФайлы;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	ТаблицаСоответствияДокументовТипамЕГАИС = Перечисления.ВидыДокументовЕГАИС.ТаблицаСоответствияДокументовТипамЕГАИС();
	
	АбстрактныеОперации = Перечисления.ВидыДокументовЕГАИС.АбстрактныеОперации();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ВТСсылкиДляОбработки.Ссылка КАК Справочник.ЕГАИСПрисоединенныеФайлы) КАК Ссылка
	|ПОМЕСТИТЬ СсылкиДляОбработки
	|ИЗ
	|	&ВТСсылкиДляОбработки КАК ВТСсылкиДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СсылкиДляОбработки.Ссылка КАК Ссылка,
	|	СсылкиДляОбработки.Ссылка.ВерсияДанных КАК ВерсияДанных
	|ИЗ
	|	СсылкиДляОбработки КАК СсылкиДляОбработки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ВТСсылкиДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВходящееСообщениеТекстСообщенияXML = ИнтеграцияИС.ТекстСообщенияXMLИзПротокола(Выборка.Ссылка);
		ОбъектXDTO = Неопределено;
		Если ЗначениеЗаполнено(ВходящееСообщениеТекстСообщенияXML) Тогда
			
			ТекстОшибки = "";
			
			ЧтениеXML = Новый ЧтениеXML;
			ЧтениеXML.УстановитьСтроку(ВходящееСообщениеТекстСообщенияXML);
			
			Попытка
				
				ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents").Тип());
				
			Исключение
				
				ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				
				Попытка
					
					ОбъектXDTO = ИнтеграцияЕГАИС.ПреобразоватьПроизвольныйОбъектXDTOВОбъектXDTO(
						ИнтеграцияИС.ПроизвольныйОбъектXDTOПоТекстуСообщенияXML(ВходящееСообщениеТекстСообщенияXML),
						ИнтеграцияИС.ОбъектXDTOПоИмениСвойства(ИнтеграцияЕГАИС.КорневоеПространствоИмен(), "Documents", Неопределено));
					
				Исключение
					
					ТекстОшибки = ПодробноеПредставлениеОшибки;
					
				КонецПопытки;
				
			КонецПопытки;
			
			Если ЗначениеЗаполнено(ТекстОшибки) Тогда
				
				// Не удалось прочитать текст сообщения XML.
				ВходящееСообщениеТекстСообщенияXML = "";
				
			КонецЕсли;
			
		Иначе
			
			// Текст сообщения XML отсутствует.
			ВходящееСообщениеТекстСообщенияXML = "";
			
		КонецЕсли;
		
		ТипЕГАИС          = Неопределено;
		ЗагруженныйОбъект = Неопределено;
		Операция          = Неопределено;
		
		Если ОбъектXDTO <> Неопределено Тогда
			Попытка
				ДокументыПоТипамЕГАИС = ИнтеграцияИС.ОбъектXDTOВСтруктуру(ОбъектXDTO.Document);
				Для Каждого КлючИЗначение Из ДокументыПоТипамЕГАИС Цикл
					Если КлючИЗначение.Значение <> Неопределено Тогда
						ТипЕГАИС                  = КлючИЗначение.Ключ;
						ЗагруженныйОбъект         = ДокументыПоТипамЕГАИС[ТипЕГАИС];
						ВидДокументаИФорматОбмена = Перечисления.ВидыДокументовЕГАИС.ДанныеДокументаПоТипуЕГАИС(
							ТипЕГАИС, ТаблицаСоответствияДокументовТипамЕГАИС);
						Операция                  = ВидДокументаИФорматОбмена.ВидДокументаЕГАИС;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			Исключение
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			КонецПопытки;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ЗаписьПротокола = Выборка.Ссылка.ПолучитьОбъект();
			
			Если ЗаписьПротокола = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если ЗаписьПротокола.ВерсияДанных <> Выборка.ВерсияДанных Тогда
				ОтменитьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если ЗагруженныйОбъект <> Неопределено 
				И (Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС 
					ИЛИ Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС) Тогда
					Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЗагруженныйОбъект, "OperationResult")
						И ЗагруженныйОбъект.OperationResult <> Неопределено Тогда
					Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС;
				ИначеЕсли ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ЗагруженныйОбъект, "Result")
					И ЗагруженныйОбъект.Result <> Неопределено Тогда
					Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС;
				КонецЕсли;
			КонецЕсли;
			
			
			СтатусОбработки = Неопределено;
			
			Если ЗагруженныйОбъект <> Неопределено Тогда
				
				Если Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПроведенЕГАИС Тогда
				
					ОперацияВыполнена = (ВРег(ЗагруженныйОбъект.OperationResult.OperationResult) <> ВРег("Rejected"));
					
					Если ВРег(ЗагруженныйОбъект.OperationResult.OperationName) = ВРег("Confirm")
						И ОперацияВыполнена Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ДокументПроведен;
						
					ИначеЕсли ВРег(ЗагруженныйОбъект.OperationResult.OperationName) = ВРег("UnConfirm")
						И ОперацияВыполнена Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ДокументРаспроведен;
						
					Иначе
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
						
					КонецЕсли;
				КонецЕсли;
				
				Если Операция = Перечисления.ВидыДокументовЕГАИС.КвитанцияПолученЕГАИС Тогда
				
					Если ВРег(ЗагруженныйОбъект.Result.Conclusion) = ВРег("Rejected") Тогда
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.Ошибка;
						
					Иначе
						
						СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийЕГАИС.ОбрабатываетсяЕГАИС;
						
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
			Если СтатусОбработки <> Неопределено ИЛИ Операция <> Неопределено И АбстрактныеОперации.Найти(Операция) = Неопределено Тогда
				Если СтатусОбработки <> Неопределено Тогда
					ЗаписьПротокола.СтатусОбработки = СтатусОбработки;
				КонецЕсли;
				
				Если Операция <> Неопределено И АбстрактныеОперации.Найти(Операция) = Неопределено Тогда
					ЗаписьПротокола.Операция = Операция;
				КонецЕсли;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ЗаписьПротокола);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка,, Параметры.Очередь);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать справочник: %Справочник% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Справочник%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
			                         УровеньЖурналаРегистрации.Предупреждение,
			                         МетаданныеОбъекта,
			                         Выборка.Ссылка,
			                         ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = НЕ ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
