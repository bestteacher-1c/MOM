////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Реализация услуг и прочих активов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормаДокумента

Процедура ПриИзмененииРеквизита(ИмяЭлемента, Форма, ДополнительныеПараметры = Неопределено) Экспорт

	ТребуетсяВызовСервера = Ложь;
	ПродолжитьИзменениеРеквизита = Истина;
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	//++ Локализация
	
	//++ НЕ УТ
	Если ИмяЭлемента = Элементы.РеализацияВзаимозависимомуЛицу.Имя Тогда	
		РеализацияВзаимозависимомуЛицуПриИзменении(Форма, ТребуетсяВызовСервера, ДополнительныеПараметры);
	КонецЕсли; 
	//-- НЕ УТ
	
	//-- Локализация
	
	Если ПродолжитьИзменениеРеквизита Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
			Форма, 
			ИмяЭлемента, 
			ДополнительныеПараметры,
			ТребуетсяВызовСервера);
			
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриВыполненииКоманды(Команда, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	ПродолжитьВыполнениеКоманды = Истина;
	
	//++ Локализация
	
	//++ НЕ УТ
	Если Команда.Имя = Элементы.РасходыЗаполнитьВосстановлениеАмортизационнойПремии.ИмяКоманды Тогда
		
		ЗаполнитьВосстановлениеАмортизационнойПремии(Форма, ТребуетсяВызовСервера, ПродолжитьВыполнениеКоманды);
		
	ИначеЕсли Команда.Имя = Элементы.РасходыЗаполнитьСтатьюАмортизационнойПремии.ИмяКоманды Тогда
		
		ЗаполнитьСтатьюАмортизационнойПремии(Форма, ПродолжитьВыполнениеКоманды);
		
	КонецЕсли; 
	//-- НЕ УТ
	
	//-- Локализация
	
	Если ПродолжитьВыполнениеКоманды Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьВыполнениеКоманды(
			Форма, 
			Команда.Имя, 
			ДополнительныеПараметры,
			ТребуетсяВызовСервера);
			
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДополнитьСписокТиповОснований(Форма, СписокТипов) Экспорт

	//++ Локализация
	
	//++ НЕ УТ
	
	Объект = Форма.Объект;
	
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияОСсОтложеннымПереходомПрав")
		ИЛИ Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияБезПереходаПраваСобственности") Тогда
		
		Если НЕ Форма.ИспользуетсяУчетВНА_2_4 Тогда
			СписокТипов.Добавить("Документ.ПодготовкаКПередачеОС.ФормаВыбора", НСтр("ru='Подготовка к передаче ОС (2.2)'"));
		КонецЕсли;
		
	Иначе
		
		Если НЕ Форма.ИспользуетсяУчетВНА_2_4 Тогда
			СписокТипов.Добавить("Документ.ПодготовкаКПередачеНМА.ФормаВыбора", НСтр("ru='Подготовка к передаче НМА (2.2)'"));
			СписокТипов.Добавить("Документ.ПодготовкаКПередачеОС.ФормаВыбора", НСтр("ru='Подготовка к передаче ОС (2.2)'"));
		КонецЕсли;
		
	КонецЕсли; 
	
	//-- НЕ УТ
	
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

//++ Локализация

//++ НЕ УТ

#Область СлужебныеПроцедурыИФункции

#Область ФормаДокумента

Процедура РеализацияВзаимозависимомуЛицуПриИзменении(Форма, ТребуетсяВызовСервера, ДополнительныеПараметры)
	
	Объект = Форма.Объект;
	
	Если Объект.РеализацияВзаимозависимомуЛицу Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", "РеализацияВзаимозависимомуЛицу");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьВосстановлениеАмортизационнойПремии(Форма, ТребуетсяВызовСервера, ПродолжитьВыполнениеКоманды)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.Расходы.Количество() = 0 Тогда
		ПродолжитьВыполнениеКоманды = Ложь;
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Расходы.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать строки, в которых будет заполнено восстановление амортизационной премии'"));
		ПродолжитьВыполнениеКоманды = Ложь;
		Возврат;
	КонецЕсли;
	
	ТребуетсяВызовСервера = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьСтатьюАмортизационнойПремии(Форма, ПродолжитьВыполнениеКоманды)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ПродолжитьВыполнениеКоманды = Ложь;
	
	Если Объект.Расходы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Расходы.ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать строки, в которых будет заполнена статья доходов'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСтатьюАмортизационнойПремииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ПланВидовХарактеристик.СтатьиДоходов.ФормаВыбора",,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ЗаполнитьСтатьюАмортизационнойПремииЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ДополнительныеПараметрыДействия = Новый Структура;
		
		ПараметрыДействия = Новый Структура;
		ПараметрыДействия.Вставить("СтатьяДоходов", Результат);
		ПараметрыДействия.Вставить("ИмяТЧ", "Расходы");
		ДополнительныеПараметрыДействия.Вставить("Выполнить_УстановитьСтатьюДоходов", ПараметрыДействия);
		
		ОбщегоНазначенияУТКлиент.ПродолжитьВыполнениеКоманды(
			ДополнительныеПараметры.Форма,
			"РасходыЗаполнитьСтатьюАмортизационнойПремии",
			ДополнительныеПараметрыДействия);
			
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

//-- НЕ УТ

//-- Локализация