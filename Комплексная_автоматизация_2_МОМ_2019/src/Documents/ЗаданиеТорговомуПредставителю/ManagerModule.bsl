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
	
	Документы.ЗаказКлиента.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	БизнесПроцессы.Задание.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Задание торговому представителю".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ЗаданиеТорговомуПредставителю) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ЗаданиеТорговомуПредставителю.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ЗаданиеТорговомуПредставителю);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьЗаданияДляУправленияТорговымиПредставителями,ИспользоватьЗаданияТорговымПредставителямДляПланирования";

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
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСоглашенияСКлиентами") Тогда
		Отчеты.ОтклоненияОтУсловийПродаж.ДобавитьКомандуОтчета(КомандыОтчетов);
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный массив именами реквизитов по указанной хозяйственнной операции.
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - значение хозяйственной операции.
//  МассивВсехРеквизитов - Массив - содержит имена всех реквизитов.
//  МассивРеквизитовОперации - Массив - содержит имена реквизитов для указанной хозяйственной операции.
//
Функция ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	
	МассивВсехРеквизитов.Добавить("ТребуетсяЗалогЗаТару");
	
	МассивВсехРеквизитов.Добавить("Товары.ПроцентРучнойСкидки");
	МассивВсехРеквизитов.Добавить("Товары.СуммаРучнойСкидки");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
		ИЛИ Не ЗначениеЗаполнено(ХозяйственнаяОперация) Тогда
		
		МассивРеквизитовОперации.Добавить("ТребуетсяЗалогЗаТару");
		
		МассивРеквизитовОперации.Добавить("Товары.ПроцентРучнойСкидки");
		МассивРеквизитовОперации.Добавить("Товары.СуммаРучнойСкидки");
		
	КонецЕсли;
	
КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС продажи.
//
// Параметры:
//  Объект - ДокументОбъект.ЗаданиеТорговомуПредставителю - документ, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
//
Функция ПараметрыЗаполненияНалогообложенияНДСПродажи(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.Дата = Объект.Дата;
	ПараметрыЗаполнения.Склад = Объект.Склад;
	ПараметрыЗаполнения.Договор = Объект.Договор;
	ПараметрыЗаполнения.ЭтоЗаказ = Истина;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту Тогда
		
		ПараметрыЗаполнения.РеализацияТоваров = Истина;
		ПараметрыЗаполнения.РеализацияРаботУслуг = Истина;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию Тогда
		
		ПараметрыЗаполнения.ПередачаНаКомиссию = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Партнер)
	|	И( ЗначениеРазрешено(Склад)
	|	ИЛИ Склад = Значение(Справочник.Склады.ПустаяСсылка)
	|	)И( ЗначениеРазрешено(Организация)
	|	ИЛИ Организация = Значение(Справочник.Организации.ПустаяСсылка)
	|	) ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

  //Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Бланк задания
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "БланкЗадания";
	КомандаПечати.Представление = НСтр("ru = 'Бланк задания'");

	// Сводное задание
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СводноеЗадание";
	КомандаПечати.Представление = НСтр("ru = 'Сводное задание'");

	Если ПравоДоступа("Изменение", Метаданные.Документы.ЗаданиеТорговомуПредставителю) Тогда
		// Настройка печати бланков задания
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.НастройкаПечатиБланковЗаданияТорговомуПредставителю";
		КомандаПечати.МенеджерПечати = "";
		КомандаПечати.Идентификатор = "НастройкаПечатиБланковЗадания";
		КомандаПечати.Представление = НСтр("ru = 'Настройка печати бланков задания'");
	КонецЕсли;

КонецПроцедуры

// Формирует печатные формы объектов.
//
// Параметры:
//   ИменаМакетов - Строка - Имена макетов, перечисленные через запятую.
//   МассивОбъектов - Массив - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода - Структура - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "БланкЗадания") Тогда
		
		СтрокаБланкаЗадания = КоллекцияПечатныхФорм.Найти(ВРег("БланкЗадания"), "ИмяВРЕГ");
		
		НоваяСтрока = КоллекцияПечатныхФорм.Добавить();
		НоваяСтрока.ИмяМакета = "БланкЗаказа";
		НоваяСтрока.Экземпляров = СтрокаБланкаЗадания.Экземпляров;
		НоваяСтрока.ИмяВРЕГ = ВРЕГ(НоваяСтрока.ИмяМакета);
		
		СтруктураБланка = ПолучитьПечатнуюФормуБланкаЗадания(МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"БланкЗадания",
															НСтр("ru='Задание'"),
															СтруктураБланка.Задание);
															
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"БланкЗаказа",
															НСтр("ru='Заказ'"),
															СтруктураБланка.Заказ);
			
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СводноеЗадание") Тогда
		
		СводноеЗадание = ПолучитьПечатнуюФормуСводногоЗадания(МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,
															"СводноеЗадание",
															НСтр("ru='Сводное задание'"),
															СводноеЗадание);
			
	КонецЕсли;
		
КонецПроцедуры

Функция ПолучитьПечатнуюФормуБланкаЗадания(МассивОбъектов, ОбъектыПечати)
		
	БланкЗадания = Новый ТабличныйДокумент();
	БланкЗаказа = Новый ТабличныйДокумент();
	
	БланкЗадания.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеТорговомуПредставителю_БланкЗадания";
	БланкЗаказа.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЗаданиеТорговомуПредставителю_БланкЗаказа";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыБланкаЗадания();
	
	ДанныеОтчета = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	СтруктураПараметровПечати = ПолучитьНастройкиПечатиЗадания();
	
	Пока ДанныеОтчета.Следующий() Цикл
		
		МакетБланкаЗадания = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаданиеТорговомуПредставителю.ПФ_MXL_БланкЗадания");
		МакетБланкаЗаказа = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаданиеТорговомуПредставителю.ПФ_MXL_БланкЗаказа");
		
		Если Не ПервыйДокумент Тогда
			БланкЗадания.ВывестиГоризонтальныйРазделительСтраниц();
			БланкЗаказа.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачалоБланка = БланкЗадания.ВысотаТаблицы + 1;
		НомерСтрокиНачалоТоварногоСостава = БланкЗаказа.ВысотаТаблицы + 1;

		// Вывод бланка задания
		
		ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("Шапка");
		
		ЗаголовокДокумента = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(ДанныеОтчета, НСтр("ru='Задание торговому представителю'"));
		ОбластьМакета.Параметры.ТекстЗаголовка = ЗаголовокДокумента;
		
		ОбластьМакета.Параметры.ТорговыйПредставитель = ДанныеОтчета.ТорговыйПредставитель;
		ОбластьМакета.Параметры.Куратор = ДанныеОтчета.Куратор;
		ОбластьМакета.Параметры.ДатаВизита = Формат(ДанныеОтчета.ДатаВизитаПлан, "ДЛФ=D");
		ОбластьМакета.Параметры.Нач = ?(ЗначениеЗаполнено(ДанныеОтчета.ВремяНачала),Формат(ДанныеОтчета.ВремяНачала,"ДФ=чч:мм"),"____");
		ОбластьМакета.Параметры.Кон = ?(ЗначениеЗаполнено(ДанныеОтчета.ВремяОкончания),Формат(ДанныеОтчета.ВремяОкончания,"ДФ=чч:мм"),"____");
		
		Адрес = ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(ДанныеОтчета.Партнер);
		Телефон = ФормированиеПечатныхФорм.ПолучитьТелефонИзКонтактнойИнформации(ДанныеОтчета.Партнер);
		
		ИнформацияОПартнере = СокрЛП(ДанныеОтчета.Партнер) + ?(ПустаяСтрока(Адрес),"", ", Адрес: " + Адрес) + ?(ПустаяСтрока(Телефон), "", ", Телефон: " + Телефон);
		
		ОбластьМакета.Параметры.ИнформацияОПартнере = ИнформацияОПартнере;
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(БланкЗадания, МакетБланкаЗадания, ОбластьМакета, ДанныеОтчета.Ссылка);
		БланкЗадания.Вывести(ОбластьМакета);
		
		// Вывод задач, определенных в задании.
		
		Если СтруктураПараметровПечати.ВыводитьЗадачи Тогда
			ТаблицаЗадачи = ДанныеОтчета.Задачи.Выгрузить();
			
			Если ТаблицаЗадачи.Количество()>0 Тогда
				
				ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ПустаяСтрока");
				БланкЗадания.Вывести(ОбластьМакета);
			
				ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ЗадачиШапка");
				БланкЗадания.Вывести(ОбластьМакета);
				
				Для Каждого СтрокаЗадачи Из ТаблицаЗадачи Цикл
					ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ЗадачиСтрока");
					ОбластьМакета.Параметры.НомерСтроки = СтрокаЗадачи.НомерСтроки;
					ОбластьМакета.Параметры.ОписаниеЗадачи = СтрокаЗадачи.ОписаниеЗадачи;
					БланкЗадания.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		// Вывод секции произвольных заметок торгового представителя.
		
		Если СтруктураПараметровПечати.ВыводитьЗаметки И СтруктураПараметровПечати.КоличествоСтрокЗаметок > 0 Тогда
			
			ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ПустаяСтрока");
			БланкЗадания.Вывести(ОбластьМакета);
			
			ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ЗаметкиШапка");
			БланкЗадания.Вывести(ОбластьМакета);
			
			ВыведеноСтрок = 0;
			Пока ВыведеноСтрок < СтруктураПараметровПечати.КоличествоСтрокЗаметок Цикл
				ОбластьМакета = МакетБланкаЗадания.ПолучитьОбласть("ЗаметкиСтрока");
				БланкЗадания.Вывести(ОбластьМакета);
				ВыведеноСтрок = ВыведеноСтрок + 1;
			КонецЦикла;
		
		КонецЕсли;
		
		// Вывод бланка заказа
		
		// Вывод условий заказа, определенных в задании.
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("Шапка");
		
		ОбластьМакета.Параметры.Партнер = ДанныеОтчета.Партнер;
		ОбластьМакета.Параметры.Контрагент = ДанныеОтчета.Контрагент;
		ОбластьМакета.Параметры.Валюта = ДанныеОтчета.Валюта;
		
		Если НЕ ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
			ОбластьМакета.Параметры.ЗаголовокСумма = "Сумма:";
			ОбластьМакета.Параметры.Сумма = ДанныеОтчета.СуммаПлан;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Склад = ДанныеОтчета.Склад;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(БланкЗаказа, МакетБланкаЗаказа, ОбластьМакета, ДанныеОтчета.Ссылка);
		БланкЗаказа.Вывести(ОбластьМакета);
		
		// Вывод графика оплаты.
		
		Если СтруктураПараметровПечати.ВыводитьГрафикОплаты Тогда
			
			ТаблицаЭтапыГрафикаОплаты = ДанныеОтчета.ЭтапыГрафикаОплаты.Выгрузить();
			
			Если ТаблицаЭтапыГрафикаОплаты.Количество()>0 ИЛИ СтруктураПараметровПечати.КоличествоСтрокГрафикаОплаты>0 Тогда
				
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ГрафикОплатыШапка");
				БланкЗаказа.Вывести(ОбластьМакета);
								
				Если ТаблицаЭтапыГрафикаОплаты.Количество()>0 Тогда
					Для Каждого СтрокаЭтапыГрафикаОплаты Из ТаблицаЭтапыГрафикаОплаты Цикл
						ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ГрафикОплатыСтрока");
						ОбластьМакета.Параметры.НомерСтроки = СтрокаЭтапыГрафикаОплаты.НомерСтроки;
						ОбластьМакета.Параметры.ВариантОплаты = СтрокаЭтапыГрафикаОплаты.ВариантОплаты;
						ОбластьМакета.Параметры.ДатаПлатежа = СтрокаЭтапыГрафикаОплаты.ДатаПлатежа;
						ОбластьМакета.Параметры.ПроцентПлатежа = СтрокаЭтапыГрафикаОплаты.ПроцентПлатежа;
						БланкЗаказа.Вывести(ОбластьМакета);
					КонецЦикла;
				Иначе
					ВыведеноСтрок = 0;
					Пока ВыведеноСтрок < СтруктураПараметровПечати.КоличествоСтрокГрафикаОплаты Цикл
						ВыведеноСтрок = ВыведеноСтрок + 1;
						ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ГрафикОплатыСтрока");
						ОбластьМакета.Параметры.НомерСтроки = ВыведеноСтрок;
						БланкЗаказа.Вывести(ОбластьМакета);
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
				
		// Вывод товарного состава задания.
		
		ИспользуютсяСкидки = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах");
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыЗаголовок");
		БланкЗаказа.Вывести(ОбластьМакета);

		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|НомерСтроки");
		БланкЗаказа.Вывести(ОбластьМакета);
		
		КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
		ВыводитьКоды = ЗначениеЗаполнено(КолонкаКодов);
		
		Если ВыводитьКоды Тогда
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|КолонкаКодов");
			ОбластьМакета.Параметры.ИмяКолонкиКодов = КолонкаКодов;
			БланкЗаказа.Присоединить(ОбластьМакета);
		КонецЕсли;
		
		Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|Номенклатура");
		Иначе
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|НоменклатураБезПлана");
		КонецЕсли;
		
		БланкЗаказа.Присоединить(ОбластьМакета);
				
		Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|КоличествоПлан");
			БланкЗаказа.Присоединить(ОбластьМакета);
		КонецЕсли;
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|ДанныеЗаказа");
		БланкЗаказа.Присоединить(ОбластьМакета);
		
		Если ИспользуютсяСкидки Тогда
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|Скидки");
			БланкЗаказа.Присоединить(ОбластьМакета);
		КонецЕсли;
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыШапка|Комментарий");
		БланкЗаказа.Присоединить(ОбластьМакета);
		
		ОбластьШапки = БланкЗаказа.Область(БланкЗаказа.ВысотаТаблицы, ,БланкЗаказа.ВысотаТаблицы, );
		БланкЗаказа.ПовторятьПриПечатиСтроки = ОбластьШапки;
		
		ТаблицаТовары = ДанныеОтчета.Товары.Выгрузить();
		
		НомерСтроки = 0;
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если НЕ ФормированиеПечатныхФорм.ПроверитьЗаполнениеНоменклатуры(СтрокаТовары, СтрокаТовары.НомерСтроки) Тогда
				Продолжить;
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|НомерСтроки");
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			БланкЗаказа.Вывести(ОбластьМакета);
			
			Если ВыводитьКоды Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|КолонкаКодов");
				ОбластьМакета.Параметры.Артикул = СтрокаТовары[КолонкаКодов];
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Номенклатура");
			Иначе
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|НоменклатураБезПлана");
			КонецЕсли;
			
			ДополнительныеПараметрыПолученияНаименованияДляПечати = НоменклатураКлиентСервер.ДополнительныеПараметрыПредставлениеНоменклатурыДляПечати();
			ДополнительныеПараметрыПолученияНаименованияДляПечати.Содержание = СтрокаТовары.Содержание;			
			
			ОбластьМакета.Параметры.Номенклатура = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				СтрокаТовары.НаименованиеПолное,
				СтрокаТовары.Характеристика,
				, // Упаковка
				, // Серия
				ДополнительныеПараметрыПолученияНаименованияДляПечати);
			БланкЗаказа.Присоединить(ОбластьМакета);
			
			Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|КоличествоПлан");
				ОбластьМакета.Параметры.КоличествоПлан = СтрокаТовары.КоличествоПлан;
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|ДанныеЗаказа");
			ОбластьМакета.Параметры.ЕдиницаИзмерения = СтрокаТовары.ЕдиницаИзмерения;
			ОбластьМакета.Параметры.Цена = СтрокаТовары.Цена;
			БланкЗаказа.Присоединить(ОбластьМакета);
			
			Если ИспользуютсяСкидки Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Скидки");
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Комментарий");
			ОбластьМакета.Параметры.Комментарий = СокрЛП(СтрокаТовары.Комментарий);
			БланкЗаказа.Присоединить(ОбластьМакета);
			
		КонецЦикла;
		
		// Дополнение таблицы товаров пустыми строками - для возможности указания незапланированного товара.
		
		ВыведеноДополнительныхСтрок = 0;
		
		Пока ВыведеноДополнительныхСтрок < СтруктураПараметровПечати.КоличествоСтрокНоменклатуры Цикл
			
			НомерСтроки = НомерСтроки + 1;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|НомерСтроки");
			ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
			БланкЗаказа.Вывести(ОбластьМакета);
			
			Если ВыводитьКоды Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|КолонкаКодов");
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Номенклатура");
			Иначе
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|НоменклатураБезПлана");
			КонецЕсли;
			
			БланкЗаказа.Присоединить(ОбластьМакета);
						
			Если ДанныеОтчета.ДетализацияПоНоменклатуре Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|КоличествоПлан");
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|ДанныеЗаказа");
			БланкЗаказа.Присоединить(ОбластьМакета);
			
			Если ИспользуютсяСкидки Тогда
				ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Скидки");
				БланкЗаказа.Присоединить(ОбластьМакета);
			КонецЕсли;
			
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ТоварыСтрока|Комментарий");
			БланкЗаказа.Присоединить(ОбластьМакета);
			
			ВыведеноДополнительныхСтрок = ВыведеноДополнительныхСтрок + 1;
		КонецЦикла;
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ПодвалСумма");
		БланкЗаказа.Вывести(ОбластьМакета);
		
		Если ИспользуютсяСкидки Тогда
			ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ПодвалСкидки");
			БланкЗаказа.Вывести(ОбластьМакета);
		КонецЕсли;
		
		ОбластьМакета = МакетБланкаЗаказа.ПолучитьОбласть("ПодвалПодпись");
		БланкЗаказа.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(БланкЗадания, НомерСтрокиНачалоБланка, ОбъектыПечати, ДанныеОтчета.Ссылка);
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(БланкЗаказа, НомерСтрокиНачалоТоварногоСостава, ОбъектыПечати, ДанныеОтчета.Ссылка);
		
	КонецЦикла;
	
	БланкЗадания.ВерхнийКолонтитул.ТекстСлева = ЗаголовокДокумента;
	БланкЗадания.АвтоМасштаб = Истина;
	
	БланкЗаказа.ВерхнийКолонтитул.ТекстСлева = ЗаголовокДокумента;
	БланкЗаказа.АвтоМасштаб = Истина;
	
	СтруктураБланка = Новый Структура();
	СтруктураБланка.Вставить("Задание", БланкЗадания);
	СтруктураБланка.Вставить("Заказ", БланкЗаказа);
	
	Возврат СтруктураБланка;
	
КонецФункции

Функция ПолучитьПечатнуюФормуСводногоЗадания(МассивОбъектов, ОбъектыПечати)
		
	СводноеЗадание = Новый ТабличныйДокумент();
	СводноеЗадание.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СводноеЗаданиеТорговмуПредставителю";
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.Текст = ПолучитьТекстЗапросаДляФормированияПечатнойФормыСводногоЗадания();
	
	ДанныеОтчета = Запрос.Выполнить().Выбрать();
	
	МакетСводногоЗадания = УправлениеПечатью.МакетПечатнойФормы("Документ.ЗаданиеТорговомуПредставителю.ПФ_MXL_СводноеЗадание");
	ПервыйДокумент = Истина;
	ТекущийТорговыйПредставитель = Неопределено;
	
	СтруктураПараметровПечати = ПолучитьНастройкиПечатиЗадания();
	
	НомерСтроки = 0;
	
	Пока ДанныеОтчета.Следующий() Цикл
		
		Если ДанныеОтчета.ТорговыйПредставитель <> ТекущийТорговыйПредставитель Тогда
			
			Если Не ПервыйДокумент Тогда
				ВывестиПодвал(МакетСводногоЗадания, СводноеЗадание);
				ВывестиРасходы(МакетСводногоЗадания, СводноеЗадание, СтруктураПараметровПечати);
				
				СводноеЗадание.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			НомерСтрокиНачалоБланка = СводноеЗадание.ВысотаТаблицы + 1;
			НомерСтроки = 0;
			ПервыйДокумент = Ложь;
			
			ОбластьМакета = МакетСводногоЗадания.ПолучитьОбласть("Шапка");
			ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru='Сводное задание торговому представителю'");
			ОбластьМакета.Параметры.ТорговыйПредставитель = ДанныеОтчета.ТорговыйПредставитель;
			ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(СводноеЗадание, МакетСводногоЗадания, ОбластьМакета, ДанныеОтчета.Ссылка);
			СводноеЗадание.Вывести(ОбластьМакета);
			
			ОбластьМакета = МакетСводногоЗадания.ПолучитьОбласть("ПартнерШапка");
			СводноеЗадание.Вывести(ОбластьМакета);
			
			Если СтруктураПараметровПечати.ВыводитьЗадачиВСводномЗадании Тогда
				ОбластьМакета = МакетСводногоЗадания.ПолучитьОбласть("ЗадачиШапка");
				СводноеЗадание.Вывести(ОбластьМакета);
			КонецЕсли;
			
		КонецЕсли;
		
		НомерСтроки = НомерСтроки + 1;
		
		ОбластьМакета = МакетСводногоЗадания.ПолучитьОбласть("ПартнерСтрока");
		ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
		ОбластьМакета.Параметры.Дата = Формат(ДанныеОтчета.ДатаВизитаПлан, "ДЛФ=D");
		
		Если ЗначениеЗаполнено(ДанныеОтчета.ВремяНачала) Тогда
			Время = Формат(ДанныеОтчета.ВремяНачала,"ДФ=чч:мм") + ?(ЗначениеЗаполнено(ДанныеОтчета.ВремяОкончания),"-" + Формат(ДанныеОтчета.ВремяОкончания,"ДФ=чч:мм"),"");
		Иначе
			Время = "";
		КонецЕсли;
		ОбластьМакета.Параметры.Время = Время;
		
		Адрес = ФормированиеПечатныхФорм.ПолучитьАдресИзКонтактнойИнформации(ДанныеОтчета.Партнер);
		Телефон = ФормированиеПечатныхФорм.ПолучитьТелефонИзКонтактнойИнформации(ДанныеОтчета.Партнер);
		
		ИнформацияОПартнере = СокрЛП(ДанныеОтчета.Партнер) + ?(ПустаяСтрока(Адрес),"", ", Адрес: " + Адрес) + ?(ПустаяСтрока(Телефон), "", ", Телефон: " + Телефон);
		
		ОбластьМакета.Параметры.ИнформацияОПартнере = ИнформацияОПартнере;
		СводноеЗадание.Вывести(ОбластьМакета);
		
		Если СтруктураПараметровПечати.ВыводитьЗадачиВСводномЗадании Тогда
			// Вывод задач, определенных в задании.
			ТаблицаЗадачи = ДанныеОтчета.Задачи.Выгрузить();
			
			Для Каждого СтрокаЗадачи Из ТаблицаЗадачи Цикл
				ОбластьМакета = МакетСводногоЗадания.ПолучитьОбласть("ЗадачиСтрока");
				ОбластьМакета.Параметры.ОписаниеЗадачи = СтрокаЗадачи.ОписаниеЗадачи;
				СводноеЗадание.Вывести(ОбластьМакета);
			КонецЦикла;
		КонецЕсли;
		
		ТекущийТорговыйПредставитель = ДанныеОтчета.ТорговыйПредставитель;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(СводноеЗадание, НомерСтрокиНачалоБланка, ОбъектыПечати, ДанныеОтчета.Ссылка);
		
	КонецЦикла;
		
	ВывестиПодвал(МакетСводногоЗадания, СводноеЗадание);
	ВывестиРасходы(МакетСводногоЗадания, СводноеЗадание, СтруктураПараметровПечати);
		
	СводноеЗадание.АвтоМасштаб = Истина;
	
	Возврат СводноеЗадание;
	
КонецФункции

// Выводит секцию подвала.
//
// Параметры:
//  Макет - макет, на основе которого формируется табличный документ.
//  ТабличныйДокумент - итоговый табличный документ, в который выводится секция.
//
Процедура ВывестиПодвал(Макет, ТабличныйДокумент)
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	ОбластьЯчеек = ТабличныйДокумент.Вывести(ОбластьМакета);
	ОбластьЯчеек.ВысотаСтроки = 1;
	
КонецПроцедуры

// Выводит секцию расходов.
//
// Параметры:
//  Макет - макет, на основе которого формируется табличный документ.
//  ТабличныйДокумент - итоговый табличный документ, в который выводится секция.
//  СтруктураПараметровПечати - структура, содержащая настройки печати.
//
Процедура ВывестиРасходы(Макет, ТабличныйДокумент, СтруктураПараметровПечати)
	
	Если СтруктураПараметровПечати.ВыводитьРасходы И СтруктураПараметровПечати.КоличествоСтрокРасходов > 0 Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ПустаяСтрока");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("РасходыШапка");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ВыведеноСтрок = 0;
		Пока ВыведеноСтрок < СтруктураПараметровПечати.КоличествоСтрокРасходов Цикл
			ОбластьМакета = Макет.ПолучитьОбласть("РасходыСтрока");
			ОбластьМакета.Параметры.НомерСтроки = ВыведеноСтрок + 1;
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ВыведеноСтрок = ВыведеноСтрок + 1;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыБланкаЗадания()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаданиеТорговомуПредставителю.Ссылка КАК Ссылка,
	|	ЗаданиеТорговомуПредставителю.Номер КАК Номер,
	|	ЗаданиеТорговомуПредставителю.Дата КАК Дата,
	|	ЗаданиеТорговомуПредставителю.Организация КАК Организация,
	|	ЗаданиеТорговомуПредставителю.Организация.Префикс КАК Префикс,
	|	ЗаданиеТорговомуПредставителю.Партнер КАК Партнер,
	|	ЗаданиеТорговомуПредставителю.Контрагент КАК Контрагент,
	|	ЗаданиеТорговомуПредставителю.ДатаВизитаПлан КАК ДатаВизитаПлан,
	|	ЗаданиеТорговомуПредставителю.ВремяНачала КАК ВремяНачала,
	|	ЗаданиеТорговомуПредставителю.ВремяОкончания КАК ВремяОкончания,
	|	ЗаданиеТорговомуПредставителю.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ЗаданиеТорговомуПредставителю.Валюта КАК Валюта,
	|	ЗаданиеТорговомуПредставителю.СуммаПлан КАК СуммаПлан,
	|	ЗаданиеТорговомуПредставителю.ТорговыйПредставитель КАК ТорговыйПредставитель,
	|	ЗаданиеТорговомуПредставителю.Куратор КАК Куратор,
	|	ЗаданиеТорговомуПредставителю.Склад КАК Склад,
	|	ЗаданиеТорговомуПредставителю.ДетализацияПоНоменклатуре,
	|	ЗаданиеТорговомуПредставителю.Товары.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		Номенклатура.НаименованиеПолное КАК НаименованиеПолное,
	|		ВЫБОР
	|			КОГДА ЗаданиеТорговомуПредставителю.Товары.Упаковка = ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|				ТОГДА ЗаданиеТорговомуПредставителю.Товары.Номенклатура.ЕдиницаИзмерения.Наименование
	|			ИНАЧЕ ЗаданиеТорговомуПредставителю.Товары.Упаковка.Наименование
	|		КОНЕЦ КАК ЕдиницаИзмерения,
	|		КоличествоПлан КАК КоличествоПлан,
	|		Цена КАК Цена,
	|		Характеристика.НаименованиеПолное КАК Характеристика,
	|		Комментарий КАК Комментарий,
	|		Номенклатура.Код КАК Код,
	|		Номенклатура.Артикул КАК Артикул,
	|		Содержание КАК Содержание
	|	),
	|	ЗаданиеТорговомуПредставителю.Задачи.(
	|		НомерСтроки,
	|		ОписаниеЗадачи
	|	),
	|	ЗаданиеТорговомуПредставителю.ЭтапыГрафикаОплаты.(
	|		НомерСтроки КАК НомерСтроки,
	|		ВариантОплаты,
	|		ДатаПлатежа,
	|		ПроцентПлатежа
	|	),
	|	Константы.ИспользоватьХарактеристикиНоменклатуры КАК ИспользуютсяХарактеристики
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю КАК ЗаданиеТорговомуПредставителю
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО (ИСТИНА)
	|ГДЕ
	|	ЗаданиеТорговомуПредставителю.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ПолучитьТекстЗапросаДляФормированияПечатнойФормыСводногоЗадания()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗаданиеТорговомуПредставителю.Ссылка КАК Ссылка,
	|	ЗаданиеТорговомуПредставителю.Номер КАК Номер,
	|	ЗаданиеТорговомуПредставителю.Дата КАК Дата,
	|	ЗаданиеТорговомуПредставителю.Партнер КАК Партнер,
	|	ЗаданиеТорговомуПредставителю.ДатаВизитаПлан КАК ДатаВизитаПлан,
	|	ЗаданиеТорговомуПредставителю.ВремяНачала КАК ВремяНачала,
	|	ЗаданиеТорговомуПредставителю.ВремяОкончания КАК ВремяОкончания,
	|	ЗаданиеТорговомуПредставителю.ТорговыйПредставитель КАК ТорговыйПредставитель,
	|	ЗаданиеТорговомуПредставителю.Задачи.(
	|		ОписаниеЗадачи
	|	)
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю КАК ЗаданиеТорговомуПредставителю
	|ГДЕ
	|	ЗаданиеТорговомуПредставителю.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТорговыйПредставитель,
	|	ДатаВизитаПлан,
	|	ВремяНачала";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает значение реквизита, прочитанного из информационной базы по ссылке на объект
// см. ОбщегоНазначения.ЗначениеРеквизитаОбъекта()
// Если полученное значение не имеет тип булево, возвращается значение Ложь.
//
Функция ЗначениеРеквизитаОбъектаТипаБулево(Ссылка, ИмяРеквизита) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Результат = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
	Если ТипЗнч(Результат) <> Тип("Булево") Тогда
		Результат = Ложь;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);	
	Возврат Результат
КонецФункции

// Возвращает настройки печати бланка задания.
//
// Возвращаемое значение:
//  Структура, содержащая настройки.
//
Функция ПолучитьНастройкиПечатиЗадания()
	
	НастройкиПечатиБланка = Новый Структура();
	
	НастройкиПечатиБланка.Вставить("ВыводитьЗадачиВСводномЗадании", Ложь);
	НастройкиПечатиБланка.Вставить("ВыводитьГрафикОплаты", Истина);
	НастройкиПечатиБланка.Вставить("ВыводитьЗадачи", Истина);
	НастройкиПечатиБланка.Вставить("ВыводитьРасходы", Истина);
	НастройкиПечатиБланка.Вставить("ВыводитьЗаметки", Истина);
	НастройкиПечатиБланка.Вставить("КоличествоСтрокГрафикаОплаты", 3);
	НастройкиПечатиБланка.Вставить("КоличествоСтрокНоменклатуры", 5);
	НастройкиПечатиБланка.Вставить("КоличествоСтрокРасходов", 5);
	НастройкиПечатиБланка.Вставить("КоличествоСтрокЗаметок", 5);
	
	УстановитьЗначенияПараметровИзНастроек(НастройкиПечатиБланка);
	
	Возврат НастройкиПечатиБланка;

КонецФункции

// Устанавливает значения параметров настройки печати.
//
// Параметры:
//  СтруктураНастроекПечати - структура, содержащая настройки печати.
//
Процедура УстановитьЗначенияПараметровИзНастроек(СтруктураНастроекПечати)
	
	Для Каждого ЭлементСтруктуры Из СтруктураНастроекПечати Цикл
		ИмяПараметра = ЭлементСтруктуры.Ключ;
		ЗначениеПараметра = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Документ.ЗаданиеТорговомуПредставителю.НастройкиПечатиБланковЗадания", ИмяПараметра);
		
		Если ЗначениеПараметра <> Неопределено Тогда
			СтруктураНастроекПечати[ИмяПараметра] = ЗначениеПараметра;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

 // Текущие дела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел().
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Документ.ЗаданиеТорговомуПредставителю.Форма.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы.
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.ЗаданиеТорговомуПредставителю))
		И (ПравоДоступа("Добавление", Метаданные.Документы.ЗаданиеТорговомуПредставителю)
			ИЛИ ПравоДоступа("Изменение", Метаданные.Документы.ЗаданиеТорговомуПредставителю))
		И ПолучитьФункциональнуюОпцию("ИспользоватьЗаданияДляУправленияТорговымиПредставителями");
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА ЗаданиеТорговомуПредставителю.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийТорговымПредставителям.НеПодготовлено)
	|				ТОГДА ЗаданиеТорговомуПредставителю.Ссылка
	|		КОНЕЦ) КАК ЗаданияТорговымПредставителямКПодготовке,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА ЗаданиеТорговомуПредставителю.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийТорговымПредставителям.НеПодготовлено)
	|					И ЗаданиеТорговомуПредставителю.ДатаВизитаПлан < НАЧАЛОПЕРИОДА(&ДатаАктуальности, ДЕНЬ)
	|				ТОГДА ЗаданиеТорговомуПредставителю.Ссылка
	|			КОГДА ЗаданиеТорговомуПредставителю.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийТорговымПредставителям.КОтработке)
	|					И ЗаданиеТорговомуПредставителю.ДатаВизитаПлан < НАЧАЛОПЕРИОДА(&ДатаАктуальности, ДЕНЬ)
	|					И ЗаданиеТорговомуПредставителю.ДатаВизитаФакт = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЗаданиеТорговомуПредставителю.Ссылка
	|		КОНЕЦ) КАК ЗаданияТорговымПредставителямПросроченные,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВЫБОР
	|			КОГДА ЗаказКлиента.ДокументОснование ЕСТЬ NULL 
	|					И ЗаданиеТорговомуПредставителю.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаданийТорговымПредставителям.Отработано)
	|				ТОГДА ЗаданиеТорговомуПредставителю.Ссылка
	|		КОНЕЦ) КАК ЗаданияТорговымПредставителямКОформлениюЗаказов
	|ИЗ
	|	Документ.ЗаданиеТорговомуПредставителю КАК ЗаданиеТорговомуПредставителю
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК ЗаказКлиента
	|		ПО ЗаданиеТорговомуПредставителю.Ссылка = ЗаказКлиента.ДокументОснование
	|ГДЕ
	|	ЗаданиеТорговомуПредставителю.Куратор = &Пользователь
	|	И (НЕ ЗаданиеТорговомуПредставителю.ПометкаУдаления)";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ЗаданияТорговымПредставителям
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ЗаданияТорговымПредставителям";
	ДелоРодитель.Представление  = НСтр("ru = 'Задания торговым представителям'");
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Продажи;
	
	// ЗаданияТорговымПредставителямКПодготовке
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Статус", Перечисления.СтатусыЗаданийТорговымПредставителям.НеПодготовлено);
	ПараметрыОтбора.Вставить("Куратор", ОбщиеПараметрыЗапросов.Пользователь);
	ПараметрыОтбора.Вставить("Актуальность", "");
	ПараметрыОтбора.Вставить("НаличиеЗаказов", "");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаданияТорговымПредставителямКПодготовке";
	Дело.ЕстьДела       = Результат.ЗаданияТорговымПредставителямКПодготовке > 0;
	Дело.Представление  = НСтр("ru = 'Задания к подготовке'");
	Дело.Количество     = Результат.ЗаданияТорговымПредставителямКПодготовке;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "ЗаданияТорговымПредставителям";
	
	// ЗаданияТорговымПредставителямКОформлениюЗаказов
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Статус", Перечисления.СтатусыЗаданийТорговымПредставителям.Отработано);
	ПараметрыОтбора.Вставить("Куратор", ОбщиеПараметрыЗапросов.Пользователь);
	ПараметрыОтбора.Вставить("Актуальность", "");
	ПараметрыОтбора.Вставить("НаличиеЗаказов", "Заказы не оформлены");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаданияТорговымПредставителямКОформлениюЗаказов";
	Дело.ЕстьДела       = Результат.ЗаданияТорговымПредставителямКОформлениюЗаказов > 0;
	Дело.Представление  = НСтр("ru = 'Задания к оформлению заказов'");
	Дело.Количество     = Результат.ЗаданияТорговымПредставителямКОформлениюЗаказов;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "ЗаданияТорговымПредставителям";
	
	// ЗаданияТорговымПредставителямПросроченные
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Статус", Перечисления.СтатусыЗаданийТорговымПредставителям.ПустаяСсылка());
	ПараметрыОтбора.Вставить("Куратор", ОбщиеПараметрыЗапросов.Пользователь);
	ПараметрыОтбора.Вставить("Актуальность", "Просроченные");
	ПараметрыОтбора.Вставить("НаличиеЗаказов", "");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаданияТорговымПредставителямПросроченные";
	Дело.ЕстьДела       = Результат.ЗаданияТорговымПредставителямПросроченные > 0;
	Дело.Представление  = НСтр("ru = 'Просроченные задания'");
	Дело.Количество     = Результат.ЗаданияТорговымПредставителямПросроченные;
	Дело.Важное         = Истина;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = Новый Структура("СтруктураБыстрогоОтбора", ПараметрыОтбора);
	Дело.Владелец       = "ЗаданияТорговымПредставителям";
	
	Если Результат.ЗаданияТорговымПредставителямКПодготовке > 0
		Или Результат.ЗаданияТорговымПредставителямКОформлениюЗаказов > 0
		Или Результат.ЗаданияТорговымПредставителямПросроченные > 0 Тогда
		ДелоРодитель.ЕстьДела = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
