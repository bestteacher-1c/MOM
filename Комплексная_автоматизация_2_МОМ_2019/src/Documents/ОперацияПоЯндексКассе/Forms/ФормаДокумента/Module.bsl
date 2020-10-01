#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	
	УстановитьДоступ();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();

	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	УправлениеЭлементамиФормы();

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОтчетПоОперациямЯндексКассы", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьТипОперацииВозвратаИРассчитатьСуммуКомиссии();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыОсновное


&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	ЗаполнитьРеквизитыПриСменеХозяйственнойОперации();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()
	
	Объект.НастройкаЯндексКассы = Справочники.НастройкиЯндексКассы.НайтиНастройку(
		Новый Структура("Организация", Объект.Организация));
		
	ЗначенияРеквизитов = ЗначенияРеквизитовНастройки(Объект.НастройкаЯндексКассы);
	
	Если ЗначенияРеквизитов.Количество() Тогда
		ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов,
			"БанковскийСчет, СтатьяРасходов, АналитикаРасходов, Подразделение, Эквайер");
	
		Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда 
			Объект.СтатьяДвиженияДенежныхСредств = ЗначенияРеквизитов.СтатьяДвиженияДенежныхСредствОплаты;
		Иначе
			Объект.СтатьяДвиженияДенежныхСредств = ЗначенияРеквизитов.СтатьяДвиженияДенежныхСредствВозвраты;
		КонецЕсли;
	КонецЕсли;
	
	ФискальнаяОперацияОбновитьСтатус();
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаОперацииПриИзменении(Элемент)
	
	СуммаОперацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СуммаОперацииПриИзмененииНаСервере()
	
	ВычислитьПроцентКомиссии();
	Документы.ОперацияПоЯндексКассе.ПересчитатьНДС(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаКомиссииПриИзменении(Элемент)
	
	СуммаКомиссииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СуммаКомиссииПриИзмененииНаСервере()
	
	ВычислитьПроцентКомиссии();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОперацииВозвратаПриИзменении(Элемент)
	
	ТипОперацииВозвратаПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ТипОперацииВозвратаПриИзмененииСервер()
	
	Если Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.Возврат Тогда 
		Объект.СуммаКомиссии = 0;
	ИначеЕсли Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.Отмена Тогда
		УстановитьТипОперацииВозвратаИРассчитатьСуммуКомиссии();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	КонтрагентПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура КонтрагентПриИзмененииСервер()
	
	Объект.Партнер = ДенежныеСредстваСервер.ПолучитьПартнераПоКонтрагенту(Объект.Контрагент, Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПлатежаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту") Тогда 
		
		СтандартнаяОбработка = Ложь;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", Объект.Организация);
		Отбор.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента"));
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Отбор", Отбор);
		ПараметрыФормы.Вставить("СуммаДокумента", Объект.СуммаДокумента);
		ПараметрыФормы.Вставить("КонецПериода"	, Объект.Дата);
		
		ОткрытьФорму("Документ.ОперацияПоЯндексКассе.ФормаВыбора", ПараметрыФормы, Элемент, УникальныйИдентификатор);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОснованиеПлатежаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ВыбранноеЗначение = Неопределено 
		И Не ТипЗнч(ВыбранноеЗначение) = Тип("Тип") 
		И Не ВыбранноеЗначение.Пустая() Тогда 
		
		СтандартнаяОбработка = Ложь;
		ОснованиеПлатежаОбработкаВыбораСервер(ВыбранноеЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОснованиеПлатежаОбработкаВыбораСервер(ВыбранноеЗначение)
	
	Объект.ОснованиеПлатежа = ВыбранноеЗначение;
	
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитовОснованияПлатежа(Объект.ОснованиеПлатежа));
	
	Документы.ОперацияПоЯндексКассе.ПересчитатьНДС(Объект);
	
	УстановитьТипОперацииВозвратаИРассчитатьСуммуКомиссии();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ФискальнаяОперацияСтатусОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ФискальнаяОперацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыАналитикиУчета

&НаКлиенте
Процедура СтатьяРасходовПриИзменении(Элемент)
	
	СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭквайерСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Основание", ДанныеЭквайераПоУмолчанию(Объект.Дата));
	
	ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаЭлемента", ПараметрыФормы, Элемент, УникальныйИдентификатор); 
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если АналитикаРасходовЗаказРеализация Тогда
		ПродажиКлиент.НачалоВыбораАналитикиРасходов(Элемент, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Объект.АналитикаРасходов = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиКомандФормы


#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗначенияРеквизитовНастройки(НастройкаЯндексКассы)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ
	|	Справочник.НастройкиЯндексКассы КАК НастройкиЯндексКассы
	|ГДЕ
	|	НастройкиЯндексКассы.Ссылка = &НастройкаЯндексКассы";
	
	Запрос.УстановитьПараметр("НастройкаЯндексКассы", НастройкаЯндексКассы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЗначенияВсехРеквизитов = Новый Структура;
	
	Если Выборка.Следующий() Тогда
		
		Для каждого ТекущийРеквизит Из Выборка.Владелец().Колонки Цикл
			Если СтрСравнить(ТекущийРеквизит.Имя, "ДополнительныеНастройки") = 0 Тогда
				ДополнительныеНастройки = Выборка.ДополнительныеНастройки.Выбрать();
				
				Пока ДополнительныеНастройки.Следующий() Цикл
					ЗначенияВсехРеквизитов.Вставить(ДополнительныеНастройки.Настройка, ДополнительныеНастройки.Значение);
				КонецЦикла;
			Иначе 
				ЗначенияВсехРеквизитов.Вставить(ТекущийРеквизит.Имя, Выборка[ТекущийРеквизит.Имя]);		  
			КонецЕсли; 
		КонецЦикла;		  
		
	КонецЕсли; 
		
	Возврат ЗначенияВсехРеквизитов;
	
КонецФункции

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКонтрольЗаполненияАналитикиРасходов(Форма, КэшированныеЗначения)
	
	СтруктураДействий = Новый Структура("ЗаполнитьПризнакАналитикаРасходовОбязательна, ЗаполнитьПризнакАналитикаРасходовЗаказРеализация");
	
	ДанныеОбъекта = Новый Структура;
	ДанныеОбъекта.Вставить("СтатьяРасходов", Форма.Объект.СтатьяРасходов);
	ДанныеОбъекта.Вставить("АналитикаРасходовОбязательна", Форма.АналитикаРасходовОбязательна);
	ДанныеОбъекта.Вставить("АналитикаРасходовЗаказРеализация", Форма.АналитикаРасходовЗаказРеализация);
	
#Если Клиент Тогда
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#Иначе
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(ДанныеОбъекта, СтруктураДействий, КэшированныеЗначения);
#КонецЕсли
	
	Форма.АналитикаРасходовОбязательна = ДанныеОбъекта.АналитикаРасходовОбязательна;
	Форма.АналитикаРасходовЗаказРеализация = ДанныеОбъекта.АналитикаРасходовЗаказРеализация;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ЗаполнитьРеквизитыПриСменеХозяйственнойОперации()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда
		
		Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.ПустаяСсылка();
		Объект.СпособОплаты = Перечисления.СпособыОплатыЧерезЯндексКассу.AC;
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда
		
		Объект.СпособОплаты = Перечисления.СпособыОплатыЧерезЯндексКассу.ПустаяСсылка();
		Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.Возврат;
		ТипОперацииВозвратаПриИзмененииСервер();
		
	КонецЕсли;	
	
	Объект.ОснованиеПлатежа = Неопределено;
	Объект.ОбъектРасчетов = Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТипОперацииВозвратаИРассчитатьСуммуКомиссии()
	
	Если ЗначениеЗаполнено(Объект.ОснованиеПлатежа) 
		И Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда 
		
		ДанныеДокументаОплаты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ОснованиеПлатежа,
			"Дата, СуммаДокумента, СуммаКомиссии, ВалютаКомиссии");
		
		Объект.ВалютаКомиссии = ДанныеДокументаОплаты.ВалютаКомиссии;
		
		Если КонецДня(ДанныеДокументаОплаты.Дата) = КонецДня(Объект.Дата) Тогда 
			Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.Отмена;
			Документы.ОперацияПоЯндексКассе.ВычислитьСуммуКомиссииПоСуммеВозврата(Объект, ДанныеДокументаОплаты);
		Иначе
			Объект.ТипОперацииВозврата = Перечисления.ТипыОперацийВозвратаЧерезЯндексКассу.Возврат;
		КонецЕсли;
		
		ВычислитьПроцентКомиссии();
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииСервер(КэшированныеЗначения)
	
	Если Не ЗначениеЗаполнено(Объект.АналитикаРасходов) Тогда
		Объект.АналитикаРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПолучитьАналитикуРасходовПоУмолчанию(
			Объект.СтатьяРасходов,
			Объект);
	Иначе
		ДоходыИРасходыСервер.ОчиститьАналитикуПрочихРасходов(Объект.СтатьяРасходов, Объект.АналитикаРасходов);
	КонецЕсли;
	УстановитьДоступ();
	
	ОбновитьКонтрольЗаполненияАналитикиРасходов(ЭтаФорма, КэшированныеЗначения);

КонецПроцедуры

&НаСервере
Функция ЗначенияРеквизитовОснованияПлатежа(ОснованиеПлатежа)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОснованиеПлатежа", ОснованиеПлатежа);
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ДанныеДокумента.Партнер,
		|	ДанныеДокумента.Контрагент,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.Договор.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
		|			ТОГДА ДанныеДокумента.Договор
		|		ИНАЧЕ ДанныеДокумента.ДокументОснование
		|	КОНЕЦ КАК ОбъектРасчетов
		|ИЗ
		|	Документ.СчетНаОплатуКлиенту КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &ОснованиеПлатежа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеДокумента.Партнер,
		|	ДанныеДокумента.Контрагент,
		|	ВЫБОР
		|		КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
		|			ТОГДА ДанныеДокумента.Договор
		|		ИНАЧЕ ДанныеДокумента.Ссылка
		|	КОНЕЦ
		|ИЗ
		|	Документ.ЗаказКлиента КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &ОснованиеПлатежа
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеДокумента.Партнер,
		|	ДанныеДокумента.Контрагент,
		|	ДанныеДокумента.ОбъектРасчетов
		|ИЗ
		|	Документ.ОперацияПоЯндексКассе КАК ДанныеДокумента
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &ОснованиеПлатежа";
	   
	ЗначенияРеквизитов = Запрос.Выполнить().Выбрать();
	ЗначенияРеквизитов.Следующий();
	
	Возврат ЗначенияРеквизитов;
	
КонецФункции

&НаСервере
Процедура ВычислитьПроцентКомиссии()
	
	Процент = ?(Объект.СуммаДокумента<> 0, 
		100 * Объект.СуммаКомиссии / Объект.СуммаДокумента,
		0);
	
	Если Процент > 0 Тогда  
		ПроцентКомиссии = Формат(Процент, "ЧЦ=5; ЧДЦ=2") + "%";
	Иначе
		ПроцентКомиссии = "";
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	АналитикаРасходовЗаказРеализация = 
		Не Объект.СтатьяРасходов.Пустая()
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "АналитикаРасходовЗаказРеализация");
		
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(Справочники.НастройкиЯндексКассы.СписокДоступныхОрганизаций(Истина, Истина));
	
	Если Не Объект.Ссылка.Пустая() 
		И Элементы.Организация.СписокВыбора.НайтиПоЗначению(Объект.Организация) = Неопределено Тогда 
		
		Элементы.Организация.СписокВыбора.Добавить(Объект.Организация);
		
	КонецЕсли;
		
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	ИспользоватьНесколькоРасчетныхСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	
	Если Объект.Ссылка.Пустая() И ЗначениеЗаполнено(Объект.Организация) Тогда
		
		ОрганизацияПриИзмененииСервер();
		
	КонецЕсли;
	
	ВычислитьПроцентКомиссии();
	
	УправлениеЭлементамиФормы();
	
	Элементы.СуммаНДС20.Заголовок = СтрШаблон(НСтр("ru = 'Сумма НДС (%1)'"), Строка(УчетНДСУП.СтавкаНДСПоУмолчанию()));
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	УстановитьВидимость();
	УстановитьДоступность();
	
	ФискальнаяОперацияОбновитьСтатус();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	// Информация о проблемах
	Элементы.ГруппаИнформацияОПроблемеВДокументе.Видимость = Объект.ЕстьПроблемы;

	// Видимость Организации и БанковскогоСчета в зависимости от функциональных опций
	Элементы.Организация.Видимость = ИспользоватьНесколькоОрганизаций ИЛИ Не ЗначениеЗаполнено(Объект.Организация);
	Элементы.БанковскийСчет.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	
	// Видимость в зависимости от вида хозяйственной операции
	ЭтоОплата  = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента;
	ЭтоВозврат = Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту;
	
	// для оплат
	Элементы.СпособОплаты.Видимость = ЭтоОплата;
		
	// для возвратов
	Элементы.ТипОперацииВозврата.Видимость = ЭтоВозврат;
		
	// Доступность аналитик учета в зависимости от включенных функциональных опций
	ТипРеквизитаСтатьяРасходов = Метаданные.НайтиПоТипу(ТипЗнч(Объект.СтатьяРасходов));
	СтатьиРасходовДоступны = ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ТипРеквизитаСтатьяРасходов);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"СтатьяРасходов",
		"Видимость",
		СтатьиРасходовДоступны);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
		"АналитикаРасходов",
		"Видимость",
		СтатьиРасходовДоступны);
		
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность()
	
	ОграничениеТипаОснованиеПлатежа = Новый ОписаниеТипов;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента Тогда 
		Типы = Метаданные.ОпределяемыеТипы.ОснованиеПлатежаЧерезЯндексКассу.Тип.Типы();
		МассивТипов = Новый Массив;
		Для Каждого Тип Из Типы Цикл 
			Если Тип = Тип("ДокументСсылка.ОперацияПоЯндексКассе") Тогда 
				Продолжить; 
			КонецЕсли;
			МассивТипов.Добавить(Тип);
		КонецЦикла;
		ОграничениеТипаОснованиеПлатежа = Новый ОписаниеТипов(МассивТипов);
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту Тогда 
		ОграничениеТипаОснованиеПлатежа = Новый ОписаниеТипов("ДокументСсылка.ОперацияПоЯндексКассе");
	КонецЕсли;
		
	Элементы.ОснованиеПлатежа.ОграничениеТипа = ОграничениеТипаОснованиеПлатежа;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступ()
	
	Элементы.АналитикаРасходов.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.СтатьяРасходов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеЭквайераПоУмолчанию(ДатаСреза)
	
	Возврат Справочники.НастройкиЯндексКассы.ДанныеЭквайераПоУмолчанию(ДатаСреза);
	
КонецФункции

&НаКлиенте
Процедура ФискальнаяОперацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФискальнаяОперацияДанныеЖурнала = МенеджерОборудованияВызовСервера.ДанныеФискальнойОперации(Объект.Ссылка);
	Иначе
		ФискальнаяОперацияДанныеЖурнала = Неопределено;
	КонецЕсли;
		
	Если "ПробитьЧек" = НавигационнаяСсылкаФорматированнойСтроки Тогда
			
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДокументСсылка", Объект.Ссылка);
		ПараметрыФормы.Вставить("Партнер",        Объект.Партнер);
		ПараметрыФормы.Вставить("Организация",    Объект.Организация);
		ПараметрыФормы.Вставить("ТорговыйОбъект", Неопределено);
		
		ПодключаемоеОборудованиеУТКлиент.ПробитьЧек(
			ЭтотОбъект,
			ПараметрыФормы,
			РежимЗаписиДокумента.Проведение,
			Новый ОписаниеОповещения("ФискальнаяОперацияЗавершение", ЭтотОбъект));
		
	ИначеЕсли "ОткрытьЗаписьФискальнойОперации" = НавигационнаяСсылкаФорматированнойСтроки Тогда
		
		ПодключаемоеОборудованиеУТКлиент.ОткрытьЗаписьФискальнойОперации(ЭтотОбъект, Объект.Ссылка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФискальнаяОперацияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ФискальнаяОперацияОбновитьСтатус();
	
КонецПроцедуры	
	
&НаСервере
Процедура ФискальнаяОперацияОбновитьСтатус()
		
	Элементы.ГруппаФискальнаяОперация.Видимость = 
		ЗначениеЗаполнено(Объект.НастройкаЯндексКассы)
			И НЕ Объект.НастройкаЯндексКассы.ОтправкаЧековЧерезЯндекс;
	
	ИмяКоманды = "ПробитьЧек";
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ФискальнаяОперацияДанныеЖурнала = МенеджерОборудованияВызовСервера.ДанныеФискальнойОперации(Объект.Ссылка);
	Иначе
		ФискальнаяОперацияДанныеЖурнала = Неопределено;
	КонецЕсли;
	
	Строки = Новый Массив;
	
	Если ФискальнаяОперацияДанныеЖурнала = Неопределено Тогда
		
		Строки.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'Пробить чек'"),,
				ЦветаСтиля.ЦветГиперссылки,,
				ИмяКоманды));
		
	Иначе
		
		Строки.Добавить(
			Новый ФорматированнаяСтрока(
				СтрШаблон(
					НСтр("ru = 'Пробит чек №%1'"),
					ФискальнаяОперацияДанныеЖурнала.НомерЧекаККМ),,
				ЦветаСтиля.ЦветГиперссылки,,
				"ОткрытьЗаписьФискальнойОперации"));
				
	КонецЕсли;
	
	ФискальнаяОперацияСтатус = Новый ФорматированнаяСтрока(Строки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

