#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Операция (регламентированный учет)".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОперацияБух) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ОперацияБух.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ОперацияБух);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьРеглУчет";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

// Возвращает список счетов учета, использование которых в документе не рекомендуется.
// 
// Возвращаемое значение:
// 	Результат - СписокЗначений - Список счетов учета.
//
Функция НерекомендуемыеСчетаУчета() Экспорт
	
	НерекомендуемыеСчетаУчета = Новый Массив;
	
	СчетаУчетаНоменклатуры = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаНоменклатуры();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаНаСкладе);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаВПути);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаНоменклатуры.СчетаУчетаПередачиНаКомиссию);
	
	СчетаУчетаРасчетов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасчетов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовСПоставщиками);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовПоАвансаВыданным);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовСКлиентами);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасчетов.СчетаРасчетовПоАвансаПолученным);
	
	СчетаУчетаРасходов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаРасходов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаРасходов.СчетаРасходов);
	
	СчетаУчетаПрочихДоходов = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаПрочихДоходов();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаПрочихДоходов.СчетаПрочихДоходов);
	
	СчетаУчетаТМЦВЭксплуатации = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаТМЦВЭксплуатации();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаТМЦВЭксплуатации.СчетаУчета);
	
	СчетаУчетаДенежныхСредств = Обработки.НастройкаОтраженияДокументовВРеглУчете.ДоступныеСчетаУчетаДенежныхСредств();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаДенежныхСредств.СчетаБезналичныхДенежныхСредств);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(НерекомендуемыеСчетаУчета, СчетаУчетаДенежныхСредств.СчетаНаличныхДенежныхСредств);
	
	Возврат НерекомендуемыеСчетаУчета;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Бухгалтерская справка
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БухгалтерскаяСправка";
	КомандаПечати.Представление = НСтр("ru = 'Бухгалтерская справка'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Функция ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабДокумент = Новый ТабличныйДокумент;
	// Зададим параметры макета по умолчанию
	ТабДокумент.РазмерКолонтитулаСверху = 0;
	ТабДокумент.РазмерКолонтитулаСнизу  = 0;
	ТабДокумент.АвтоМасштаб             = Истина;
	ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
	ТабДокумент.КлючПараметровПечати     = "ПАРАМЕТРЫ_ПЕЧАТИ_ОперацияБух_БухгалтерскаяСправка";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХозрасчетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
	|	ХозрасчетныйДвиженияССубконто.СчетДт,
	|	ХозрасчетныйДвиженияССубконто.ПодразделениеДт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоДт3,
	|	ХозрасчетныйДвиженияССубконто.СчетКт,
	|	ХозрасчетныйДвиженияССубконто.ПодразделениеКт,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт1,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт2,
	|	ХозрасчетныйДвиженияССубконто.СубконтоКт3,
	|	ХозрасчетныйДвиженияССубконто.Организация,
	|	ХозрасчетныйДвиженияССубконто.ВалютаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютаКт,
	|	ХозрасчетныйДвиженияССубконто.Сумма,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаДт,
	|	ХозрасчетныйДвиженияССубконто.ВалютнаяСуммаКт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоДт,
	|	ХозрасчетныйДвиженияССубконто.КоличествоКт,
	|	ХозрасчетныйДвиженияССубконто.Содержание,
	|	ХозрасчетныйДвиженияССубконто.Регистратор
	|ПОМЕСТИТЬ ВТХозрасчетный
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор В (&МассивОбъектов), , ) КАК ХозрасчетныйДвиженияССубконто
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ХозрасчетныйДвиженияССубконто.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОперацияБух.Ссылка КАК Ссылка,
	|	ОперацияБух.Номер,
	|	ОперацияБух.Ответственный,
	|	ОперацияБух.Дата,
	|	ОперацияБух.Содержание КАК СодержаниеОперации,
	|	ЕСТЬNULL(ВТХозрасчетный.НомерСтроки,1) КАК НомерСтроки,
	|	ВТХозрасчетный.СчетДт,
	|	ВТХозрасчетный.ПодразделениеДт,
	|	ВТХозрасчетный.СубконтоДт1,
	|	ВТХозрасчетный.СубконтоДт2,
	|	ВТХозрасчетный.СубконтоДт3,
	|	ВТХозрасчетный.СчетКт,
	|	ВТХозрасчетный.ПодразделениеКт,
	|	ВТХозрасчетный.СубконтоКт1,
	|	ВТХозрасчетный.СубконтоКт2,
	|	ВТХозрасчетный.СубконтоКт3,
	|	ВТХозрасчетный.Организация КАК Организация,
	|	ВТХозрасчетный.ВалютаДт,
	|	ВТХозрасчетный.ВалютаКт,
	|	ВТХозрасчетный.Сумма,
	|	ВТХозрасчетный.ВалютнаяСуммаДт,
	|	ВТХозрасчетный.ВалютнаяСуммаКт,
	|	ВТХозрасчетный.КоличествоДт,
	|	ВТХозрасчетный.КоличествоКт,
	|	ВТХозрасчетный.Содержание КАК Содержание
	|ИЗ
	|	Документ.ОперацияБух КАК ОперацияБух
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТХозрасчетный КАК ВТХозрасчетный
	|		ПО ОперацияБух.Ссылка = ВТХозрасчетный.Регистратор
	|ГДЕ
	|	ОперацияБух.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОперацияБух.Дата,
	|	ОперацияБух.Ссылка,
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Выборка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		ЕстьОшибки = Ложь;	

		Если Не ПервыйДокумент Тогда
			ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		// Зададим параметры макета по умолчанию
		ТабДокумент.РазмерКолонтитулаСверху = 0;
		ТабДокумент.РазмерКолонтитулаСнизу  = 0;
		ТабДокумент.АвтоМасштаб             = Истина;
		ТабДокумент.ОриентацияСтраницы      = ОриентацияСтраницы.Ландшафт;
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОперацияБух.ПФ_MXL_БухгалтерскаяСправка");
		// Получаем области макета для вывода в табличный документ.
		ШапкаДокумента   = Макет.ПолучитьОбласть("Шапка");
		ЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		СтрокаТаблицы    = Макет.ПолучитьОбласть("СтрокаТаблицы");
		ПодвалТаблицы    = Макет.ПолучитьОбласть("ПодвалТаблицы");
		ПодвалДокумента  = Макет.ПолучитьОбласть("Подвал");
				
		// Выведем шапку документа.
		СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Выборка.Организация, Выборка.Дата);
		
		СтруктураШапки = Новый Структура;
		СтруктураШапки.Вставить("Организация",    ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации));
		СтруктураШапки.Вставить("НомерДокумента", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Выборка.Номер, Истина, Истина));
		СтруктураШапки.Вставить("ДатаДокумента",  Формат(Выборка.Дата, "ДЛФ=D"));
		СтруктураШапки.Вставить("Содержание",     Выборка.СодержаниеОперации);
		
		ШапкаДокумента.Параметры.Заполнить(СтруктураШапки);
		ТабДокумент.Вывести(ШапкаДокумента);
		
		// Выведем заголовок таблицы.
		ТабДокумент.Вывести(ЗаголовокТаблицы);
		
		// Выведем строки документа.
		Пока Выборка.Следующий() Цикл
			
			СтрокаТаблицы.Параметры.Заполнить(Выборка);
			
			АналитикаДт = ?(ЗначениеЗаполнено(Выборка.ПодразделениеДт), Строка(Выборка.ПодразделениеДт) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоДт1), Строка(Выборка.СубконтоДт1) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоДт2), Строка(Выборка.СубконтоДт2) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоДт3), Строка(Выборка.СубконтоДт3), "");
			
			АналитикаКт = ?(ЗначениеЗаполнено(Выборка.ПодразделениеКт), Строка(Выборка.ПодразделениеКт) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоКт1), Строка(Выборка.СубконтоКт1) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоКт2), Строка(Выборка.СубконтоКт2) + Символы.ПС, "")
				+ ?(ЗначениеЗаполнено(Выборка.СубконтоКт3), Строка(Выборка.СубконтоКт3), "");
				
			СтруктураАналитики = Новый Структура("АналитикаДт,АналитикаКт", АналитикаДт, АналитикаКт);
			СтрокаТаблицы.Параметры.Заполнить(СтруктураАналитики);
			
			// Проверим, помещается ли строка с подвалом.
			СтрокаСПодвалом = Новый Массив;
			СтрокаСПодвалом.Добавить(СтрокаТаблицы);
			СтрокаСПодвалом.Добавить(ПодвалТаблицы);
			СтрокаСПодвалом.Добавить(ПодвалДокумента);
			
			Если НЕ ОбщегоНазначенияБПВызовСервера.ПроверитьВыводТабличногоДокумента(ТабДокумент, СтрокаСПодвалом) Тогда
				
				// Выведем подвал таблицы.
				ТабДокумент.Вывести(ПодвалТаблицы);
					
				// Выведем разрыв страницы.
				ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();

				// Выведем заголовок таблицы.
				ТабДокумент.Вывести(ЗаголовокТаблицы);
				
			КонецЕсли;
			
			ТабДокумент.Вывести(СтрокаТаблицы);
			
		КонецЦикла;
		
		// Выведем подвал таблицы.
		ТабДокумент.Вывести(ПодвалТаблицы);
		
		// Выведем подвал документа.
		
		ТабДокумент.Вывести(ПодвалДокумента);
		
		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Выборка.Ссылка);

	КонецЦикла;

	Возврат ТабДокумент;

КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм,
	ОбъектыПечати, ПараметрыВывода) Экспорт
	
	// Проверяем, нужно ли для макета ПлатежноеПоручение формировать табличный документ.
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БухгалтерскаяСправка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "БухгалтерскаяСправка", НСтр("ru = 'Бухгалтерская справка'"), 
			ПечатьБухгалтерскаяСправка(МассивОбъектов, ОбъектыПечати), , "Документ.ОперацияБух.ПФ_MXL_БухгалтерскаяСправка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли