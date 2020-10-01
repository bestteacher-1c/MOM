////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Ввод остатков внеоборотных активов".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормаРедактированияСтрокиОС

Процедура ФормаРедактированияСтрокиОС_ПриИзмененииРеквизита(Элемент, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	Элементы = Форма.Элементы;
	
	//++ Локализация
	
	Если Элемент.Имя = Элементы.ПрименениеЦелевогоФинансирования.Имя
		ИЛИ Элемент.Имя = Элементы.ВариантРаздельногоУчетаНДСИзДокумента.Имя 
		ИЛИ Элемент.Имя = Элементы.ВариантРаздельногоУчетаНДСРаспределяется.Имя 
		ИЛИ Элемент.Имя = Элементы.ЕстьИзменениеПараметровАмортизацииБУ.Имя 
		ИЛИ Элемент.Имя = Элементы.ЕстьРезервПереоценкиРегл.Имя 
		ИЛИ Элемент.Имя = Элементы.НачислятьАмортизациюНУ.Имя Тогда	
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
		
	ИначеЕсли Элемент.Имя = Элементы.ВключитьАмортизационнуюПремиюВСоставРасходов.Имя Тогда
	
		ТребуетсяВызовСервера = Истина;
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
	
	ИначеЕсли Элемент.Имя = Элементы.ТекущаяСтоимостьНУ.Имя
		ИЛИ Элемент.Имя = Элементы.ТекущаяСтоимостьПР.Имя	
		ИЛИ Элемент.Имя = Элементы.ТекущаяСтоимостьБУЦФ.Имя
		ИЛИ Элемент.Имя = Элементы.ПервоначальнаяСтоимостьНУ.Имя
		ИЛИ Элемент.Имя = Элементы.ПервоначальнаяСтоимостьПР.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияНУ.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияПР.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияБУЦФ.Имя Тогда	
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
		
	ИначеЕсли Элемент.Имя = Элементы.СрокИспользованияБУ.Имя Тогда
		
		ДополнительныеПараметры = Новый Структура;
		
		ПараметрыДействия = Новый Структура("ИмяРеквизита,ОбновитьЕслиСовпадают", Элемент.Имя, Истина);
		ДополнительныеПараметры.Вставить("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия);
		
	ИначеЕсли Элемент.Имя = Элементы.СрокИспользованияБУОстаточный.Имя Тогда
		
		ДополнительныеПараметры = Новый Структура;
		
		ПараметрыДействия = Новый Структура("ИмяРеквизита,ОбновитьЕслиСовпадают", Элемент.Имя, Ложь);
		ДополнительныеПараметры.Вставить("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия);
		
	ИначеЕсли Элемент.Имя = Элементы.ПорядокУчетаБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_ПорядокУчетаБУПриИзменении(Форма, ТребуетсяВызовСервера, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.ПорядокУчетаНУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_ПорядокУчетаНУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.ДатаПринятияКУчетуБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_ДатаПринятияКУчетуБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.МетодНачисленияАмортизацииБУ.Имя Тогда
		
		ТребуетсяВызовСервера = Истина;
		
	ИначеЕсли Элемент.Имя = Элементы.ТекущаяСтоимостьБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_ТекущаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.НакопленнаяАмортизацияБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_НакопленнаяАмортизацияБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.ПервоначальнаяСтоимостьБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_ПервоначальнаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.РезервПереоценкиСтоимостиРеглСумма.Имя Тогда
		
		ФормаРедактированияСтрокиОС_РезервПереоценкиСтоимостиРеглСуммаПриИзменении(Форма);
		
	ИначеЕсли Элемент.Имя = Элементы.НачислятьАмортизациюБУ.Имя
		ИЛИ Элемент.Имя = Элементы.НачислятьИзносБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_НачислятьАмортизациюБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяРасходовБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_СтатьяРасходовБУПриИзменении(Форма, ТребуетсяВызовСервера);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяРасходовАмортизационнойПремии.Имя Тогда
		
		ФормаРедактированияСтрокиОС_СтатьяРасходовАмортизационнойПремииПриИзменении(Форма, ТребуетсяВызовСервера);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяРасходовНалог.Имя Тогда
		
		ФормаРедактированияСтрокиОС_СтатьяРасходовНалогПриИзменении(Форма, ТребуетсяВызовСервера);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяДоходовЦФ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_СтатьяДоходовЦФПриИзменении(Форма, ТребуетсяВызовСервера);
		
	ИначеЕсли Элемент.Имя = Элементы.АналитикаРасходовБУ.Имя Тогда
		
		ФормаРедактированияСтрокиОС_АналитикаРасходовБУПриИзменении(Форма);
		
	ИначеЕсли Элемент.Имя = Элементы.ПередаватьРасходыВДругуюОрганизацию.Имя Тогда

		ФормаРедактированияСтрокиОС_ПередаватьРасходыВДругуюОрганизациюПриИзменении(Форма, ДополнительныеПараметры);
		
	КонецЕсли; 
	
	//-- Локализация
	
	ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
		Форма, 
		Элемент.Имя, 
		ДополнительныеПараметры,
		ТребуетсяВызовСервера);
	
КонецПроцедуры

Функция ФормаРедактированияСтрокиОС_ТребуетсяВызовСервераДляНастройкиЭлементовФормы(Форма, СтруктураИзмененныхРеквизитов) Экспорт

	//++ Локализация
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ПорядокУчетаБУ")
			И Форма.ПорядокУчетаБУ = ПредопределенноеЗначение("Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ") Тогда
		Возврат Истина;
	КонецЕсли; 
	
	//-- Локализация
	
	Возврат Ложь;

КонецФункции

Процедура ФормаРедактированияСтрокиОС_ПриИзмененииСрокаИспользования(Форма, ИмяРеквизита, ОбновитьЕслиСовпадают, СписокРеквизитов) Экспорт

	//++ Локализация
	
	Если ИмяРеквизита <> "СрокИспользованияБУ"
		И Форма.ОтражатьВУпрУчете
		И (Форма.СрокИспользованияНУ = 0
			ИЛИ Форма.СрокиИспользованияСовпадают И ОбновитьЕслиСовпадают) Тогда
		
		Форма.СрокИспользованияБУ = Форма[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияБУ";
		
	КонецЕсли;
	
	Если ИмяРеквизита <> "СрокИспользованияНУ"
		И Форма.ОтражатьВРеглУчете
		И (Форма.СрокИспользованияНУ = 0
			ИЛИ Форма.СрокиИспользованияСовпадают И ОбновитьЕслиСовпадают) Тогда
		
		Форма.СрокИспользованияНУ = Форма[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияНУ";
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

Функция ФормаРедактированияСтрокиОС_СрокиИспользованияСовпадают(Форма) Экспорт
	
	//++ Локализация
	Возврат (НЕ Форма.ОтражатьВРеглУчете ИЛИ (Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияБУ = Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияНУ));
	//-- Локализация
	
	Возврат Истина;
	
КонецФункции

Процедура ФормаРедактированияСтрокиОС_ЗавершитьРедактированиеЗавершение(Форма, РезультатРедактирования) Экспорт

	//++ Локализация
	
	Если Форма.ВспомогательныеРеквизиты.ОтражатьВУпрУчете
		И Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
	
		МножительРезерваПереоценки = ?(Форма.ЕстьРезервПереоценкиРегл, ?(Форма.РезервПереоценкиРеглЗнак, 1, -1), 0);
		РезультатРедактирования.Вставить("РезервПереоценкиСтоимостиРегл", МножительРезерваПереоценки * Форма.РезервПереоценкиСтоимостиРеглСумма);
		РезультатРедактирования.Вставить("РезервПереоценкиАмортизацииРегл", МножительРезерваПереоценки * Форма.РезервПереоценкиАмортизацииРеглСумма);
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти

#Область ФормаРедактированияСтрокиНМА

Процедура ФормаРедактированияСтрокиНМА_ПриИзмененииРеквизита(Элемент, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	Элементы = Форма.Элементы;
	
	//++ Локализация
	
	Если Элемент.Имя = Элементы.ПрименениеЦелевогоФинансирования.Имя
		ИЛИ Элемент.Имя = Элементы.ЕстьРезервПереоценкиРегл.Имя
		ИЛИ Элемент.Имя = Элементы.СрокИспользованияНУДо2009.Имя
		ИЛИ Элемент.Имя = Элементы.МетодНачисленияАмортизацииБУ.Имя
		ИЛИ Элемент.Имя = Элементы.МетодНачисленияАмортизацииНУ.Имя
		ИЛИ Элемент.Имя = Элементы.ПередаватьРасходыВДругуюОрганизацию.Имя Тогда	
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
		
	ИначеЕсли Элемент.Имя = Элементы.ПорядокУчетаБУ.Имя
		ИЛИ Элемент.Имя = Элементы.ПорядокУчетаНУ.Имя Тогда	
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
		
	ИначеЕсли Элемент.Имя = Элементы.ТекущаяСтоимостьНУ.Имя
		ИЛИ Элемент.Имя = Элементы.ТекущаяСтоимостьПР.Имя 
		ИЛИ Элемент.Имя = Элементы.ТекущаяСтоимостьБУЦФ.Имя	
		ИЛИ Элемент.Имя = Элементы.ПервоначальнаяСтоимостьНУ.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияНУ.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияПР.Имя
		ИЛИ Элемент.Имя = Элементы.НакопленнаяАмортизацияБУЦФ.Имя Тогда	
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
		
	ИначеЕсли Элемент.Имя = Элементы.СрокИспользованияБУ.Имя Тогда
		
		ДополнительныеПараметры = Новый Структура;
		
		ПараметрыДействия = Новый Структура("ИмяРеквизита,ОбновитьЕслиСовпадают", Элемент.Имя, Истина);
		ДополнительныеПараметры.Вставить("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия);
		
	ИначеЕсли Элемент.Имя = Элементы.СрокИспользованияНУ.Имя Тогда
		
		ДополнительныеПараметры = Новый Структура;
		
		ПараметрыДействия = Новый Структура("ИмяРеквизита,ОбновитьЕслиСовпадают", Элемент.Имя, Ложь);
		ДополнительныеПараметры.Вставить("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия);
		
	ИначеЕсли Элемент.Имя = Элементы.ДатаПринятияКУчетуБУ.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_ДатаПринятияКУчетуБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.ТекущаяСтоимостьБУ.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_ТекущаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.НакопленнаяАмортизацияБУ.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_НакопленнаяАмортизацияБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.ПервоначальнаяСтоимостьБУ.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_ПервоначальнаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры);
		
	ИначеЕсли Элемент.Имя = Элементы.РезервПереоценкиСтоимостиРеглСумма.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_РезервПереоценкиСтоимостиРеглСуммаПриИзменении(Форма);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяРасходовБУ.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_СтатьяРасходовБУПриИзменении(Форма, ТребуетсяВызовСервера);
		
	ИначеЕсли Элемент.Имя = Элементы.СтатьяДоходов.Имя Тогда	
		
		ФормаРедактированияСтрокиНМА_СтатьяДоходовПриИзменении(Форма, ТребуетсяВызовСервера);
		
	КонецЕсли; 
	
	//-- Локализация
	
	ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
		Форма, 
		Элемент.Имя, 
		ДополнительныеПараметры,
		ТребуетсяВызовСервера);
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_ПриИзмененииСрокаИспользования(Форма, ИмяРеквизита, ОбновитьЕслиСовпадают, СписокРеквизитов) Экспорт

	//++ Локализация
	
	Если ИмяРеквизита = "СрокИспользованияБУ"
		И Форма.ОтражатьВУпрУчете
		И (Форма.СрокИспользованияУУ = 0
			ИЛИ ОбновитьЕслиСовпадают
				И Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияБУ = Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияУУ) Тогда
		
		Форма.СрокИспользованияУУ = Форма[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияУУ";
		
	КонецЕсли;
	
	Если ИмяРеквизита = "СрокИспользованияБУ"
		И Форма.ОтражатьВРеглУчете
		И (Форма.СрокИспользованияНУ = 0
			ИЛИ ОбновитьЕслиСовпадают
				И Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияБУ = Форма.ЗначенияРеквизитовДоИзменения.СрокИспользованияНУ) Тогда
		
		Форма.СрокИспользованияНУ = Форма[ИмяРеквизита];
		СписокРеквизитов = СписокРеквизитов + ",СрокИспользованияНУ";
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_ЗавершитьРедактированиеЗавершение(Форма, РезультатРедактирования) Экспорт

	//++ Локализация
	
	Если Форма.ВспомогательныеРеквизиты.ОтражатьВУпрУчете
		И Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
		
		МножительРезерваПереоценки = ?(Форма.ЕстьРезервПереоценкиРегл, ?(Форма.РезервПереоценкиРеглЗнак, 1, -1), 0);
		РезультатРедактирования.Вставить("РезервПереоценкиСтоимостиРегл", МножительРезерваПереоценки * Форма.РезервПереоценкиСтоимостиРеглСумма);
		РезультатРедактирования.Вставить("РезервПереоценкиАмортизацииРегл", МножительРезерваПереоценки * Форма.РезервПереоценкиАмортизацииРеглСумма);
		
	КонецЕсли;
	
	//-- Локализация
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормаРедактированияСтрокиОС

//++ Локализация

Процедура ФормаРедактированияСтрокиОС_ПорядокУчетаБУПриИзменении(Форма, ТребуетсяВызовСервера, ДополнительныеПараметры)
	
	ИзмененныеРеквизиты = ВнеоборотныеАктивыКлиентЛокализация.ПриИзмененииПорядкаУчетаБУ_ОС(
								Форма, Форма.ВспомогательныеРеквизиты.ПрименяетсяУСНДоходыМинусРасходы);
	
	Если Форма.ПорядокУчетаБУ = ПредопределенноеЗначение("Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ") Тогда
		
		Форма.НакопленнаяАмортизацияНУ = 0;
		Форма.НакопленнаяАмортизацияПР = 0;
		Форма.НакопленнаяАмортизацияВР = 0;
		
		Форма.ПрименениеЦелевогоФинансирования = Ложь;
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ПрименениеЦелевогоФинансирования";
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ИзмененныеРеквизиты", ИзмененныеРеквизиты);
		
		ТребуетсяВызовСервера = Истина;
		
		Возврат;
		
	ИначеЕсли Форма.ПорядокУчетаБУ = ПредопределенноеЗначение("Перечисление.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету") Тогда
		
		Форма.ПервоначальнаяСтоимостьОтличается = Истина;
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ПервоначальнаяСтоимостьОтличается";
		
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", ИзмененныеРеквизиты);
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_ПорядокУчетаНУПриИзменении(Форма, ДополнительныеПараметры)
	
	ИзмененныеРеквизиты = "ПорядокУчетаНУ";
	Если Форма.ПорядокУчетаНУ = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету") Тогда
		Форма.ПервоначальнаяСтоимостьОтличается = Истина;
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ПервоначальнаяСтоимостьОтличается";
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", ИзмененныеРеквизиты);
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_ДатаПринятияКУчетуБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Если Форма.ОтражатьВУпрУчете 
		И Форма.ЗначенияРеквизитовДоИзменения.ДатаПринятияКУчетуБУ = Форма.ЗначенияРеквизитовДоИзменения.ДатаПринятияКУчетуУУ Тогда
		Форма.ДатаПринятияКУчетуУУ = Форма.ДатаПринятияКУчетуБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", "ДатаПринятияКУчетуБУ");
	ДополнительныеПараметры.Вставить("Выполнить_ЗаполнитьЗначенияРеквизитовДоИзменения");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_ТекущаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	Если Элементы.ТекущаяСтоимостьУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьУУ Тогда
		Форма.ТекущаяСтоимостьУУ = Форма.ТекущаяСтоимостьБУ;
	КонецЕсли; 
	
	Если Элементы.ТекущаяСтоимостьНУ.Видимость Тогда
		Если Форма.ПорядокУчетаНУ = ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету") Тогда
			Форма.ТекущаяСтоимостьНУ = 0;
		ИначеЕсли Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьНУ Тогда
			Форма.ТекущаяСтоимостьНУ = Форма.ТекущаяСтоимостьБУ;
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_НакопленнаяАмортизацияБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	Если Элементы.НакопленнаяАмортизацияУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияБУ = Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияУУ Тогда
		Форма.НакопленнаяАмортизацияУУ = Форма.НакопленнаяАмортизацияБУ;
	КонецЕсли; 
	
	Если Элементы.НакопленнаяАмортизацияНУ.Видимость 
		И Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияБУ = Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияНУ 
		И Форма.ПорядокУчетаБУ <> ПредопределенноеЗначение("Перечисление.ПорядокПогашенияСтоимостиОС.НачислениеИзносаПоЕНАОФ")
		И Форма.ПорядокУчетаНУ <> ПредопределенноеЗначение("Перечисление.ПорядокВключенияСтоимостиОСВСоставРасходовНУ.ВключениеВРасходыПриПринятииКУчету") Тогда
		Форма.НакопленнаяАмортизацияНУ = Форма.НакопленнаяАмортизацияБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_ПервоначальнаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	Если Форма.Элементы.ПервоначальнаяСтоимостьУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьУУ Тогда
		Форма.ПервоначальнаяСтоимостьУУ = Форма.ПервоначальнаяСтоимостьБУ;
	КонецЕсли; 
	
	Если Элементы.ПервоначальнаяСтоимостьНУ.Видимость 
		И Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияНУ Тогда
		Форма.ПервоначальнаяСтоимостьНУ = Форма.ПервоначальнаяСтоимостьБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_РезервПереоценкиСтоимостиРеглСуммаПриИзменении(Форма)
	
	Если Форма.ТекущаяСтоимостьБУ <> 0 И Форма.РезервПереоценкиСтоимостиРеглСумма <> 0 Тогда
		МножительЦФ = ?(Форма.ПрименениеЦелевогоФинансирования, 1, 0);
		Форма.РезервПереоценкиАмортизацииРеглСумма = 
			(Форма.НакопленнаяАмортизацияБУ + МножительЦФ * Форма.НакопленнаяАмортизацияБУЦФ)
			* (Форма.РезервПереоценкиСтоимостиРеглСумма / (Форма.ТекущаяСтоимостьБУ + МножительЦФ * Форма.ТекущаяСтоимостьБУ));
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_НачислятьАмортизациюБУПриИзменении(Форма, ДополнительныеПараметры)
	
	ИзмененныеРеквизиты = "НачислятьАмортизациюБУ";
	
	Если Форма.НачислятьАмортизациюБУ <> Форма.НачислятьАмортизациюНУ Тогда
		Форма.НачислятьАмортизациюНУ = Форма.НачислятьАмортизациюБУ;
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",НачислятьАмортизациюНУ";
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", ИзмененныеРеквизиты);
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_СтатьяРасходовБУПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяРасходовБУ) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаРасходовБУ = Неопределено;
		Форма.АналитикаРасходовБУОбязательна = Ложь;
	КонецЕсли;
	
	Если Форма.ЗначенияРеквизитовДоИзменения.СтатьяРасходовБУ = Форма.СтатьяРасходовАмортизационнойПремии
		И Форма.Элементы.СтатьяРасходовАмортизационнойПремии.Видимость Тогда
		
		Форма.СтатьяРасходовАмортизационнойПремии = Форма.СтатьяРасходовБУ;
		Форма.АналитикаРасходовАмортизационнойПремии = Форма.АналитикаРасходовБУ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_СтатьяРасходовАмортизационнойПремииПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяРасходовАмортизационнойПремии) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаРасходовАмортизационнойПремии = Неопределено;
		Форма.АналитикаРасходовАмортизационнойПремииОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_СтатьяРасходовНалогПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяРасходовАмортизационнойПремии) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаРасходовНалог = Неопределено;
		Форма.АналитикаРасходовАмортизационнойПремииОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_СтатьяДоходовЦФПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяДоходов) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаДоходовОбязательна = Ложь;
		Форма.АналитикаДоходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_АналитикаРасходовБУПриИзменении(Форма)
	
	Если Форма.СтатьяРасходовБУ = Форма.СтатьяРасходовАмортизационнойПремии
		И Форма.ЗначенияРеквизитовДоИзменения.АналитикаРасходовБУ = Форма.АналитикаРасходовАмортизационнойПремии
		И Форма.Элементы.АналитикаРасходовАмортизационнойПремии.Видимость Тогда
		
		Форма.АналитикаРасходовАмортизационнойПремии = Форма.АналитикаРасходовБУ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиОС_ПередаватьРасходыВДругуюОрганизациюПриИзменении(Форма, ДополнительныеПараметры)
	
	Если Не Форма.ПередаватьРасходыВДругуюОрганизацию Тогда
		Форма.ОрганизацияПолучательРасходов = Неопределено;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", "ПередаватьРасходыВДругуюОрганизацию");
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#Область ФормаРедактированияСтрокиНМА

//++ Локализация

Процедура ФормаРедактированияСтрокиНМА_ДатаПринятияКУчетуБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Если Форма.ОтражатьВУпрУчете 
		И Форма.ЗначенияРеквизитовДоИзменения.ДатаПринятияКУчетуБУ = Форма.ЗначенияРеквизитовДоИзменения.ДатаПринятияКУчетуУУ Тогда
		Форма.ДатаПринятияКУчетуУУ = Форма.ДатаПринятияКУчетуБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", "ДатаПринятияКУчетуБУ");
	ДополнительныеПараметры.Вставить("Выполнить_ЗаполнитьЗначенияРеквизитовДоИзменения");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_ТекущаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	СуммаНУ = Форма.ТекущаяСтоимостьБУ - Форма.ТекущаяСтоимостьПР - Форма.ТекущаяСтоимостьВР;
	Если СуммаНУ < 0 Тогда
		Форма.ТекущаяСтоимостьНУ = 0;
		Форма.ТекущаяСтоимостьВР = Форма.ТекущаяСтоимостьБУ - Форма.ТекущаяСтоимостьНУ - Форма.ТекущаяСтоимостьПР;
	Иначе
		Форма.ТекущаяСтоимостьНУ = СуммаНУ;
	КонецЕсли;
	
	Если Элементы.ТекущаяСтоимостьУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьУУ Тогда
		Форма.ТекущаяСтоимостьУУ = Форма.ТекущаяСтоимостьБУ;
	КонецЕсли; 
	
	Если Элементы.ТекущаяСтоимостьНУ.Видимость 
		И Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьНУ Тогда
		Форма.ТекущаяСтоимостьНУ = Форма.ТекущаяСтоимостьБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_НакопленнаяАмортизацияБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	СуммаНУ = Форма.НакопленнаяАмортизацияБУ - Форма.НакопленнаяАмортизацияПР - Форма.НакопленнаяАмортизацияВР;
	Если СуммаНУ < 0 Тогда
		Форма.НакопленнаяАмортизацияНУ = 0;
		Форма.НакопленнаяАмортизацияВР = Форма.НакопленнаяАмортизацияБУ - Форма.НакопленнаяАмортизацияНУ - Форма.НакопленнаяАмортизацияПР;
	Иначе
		Форма.НакопленнаяАмортизацияНУ = СуммаНУ;
	КонецЕсли;
	
	Если Элементы.НакопленнаяАмортизацияУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияБУ = Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияУУ Тогда
		Форма.НакопленнаяАмортизацияУУ = Форма.НакопленнаяАмортизацияБУ;
	КонецЕсли; 
	
	Если Элементы.НакопленнаяАмортизацияНУ.Видимость 
		И Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияБУ = Форма.ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияНУ Тогда
		Форма.НакопленнаяАмортизацияНУ = Форма.НакопленнаяАмортизацияБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_ПервоначальнаяСтоимостьБУПриИзменении(Форма, ДополнительныеПараметры)
	
	Элементы = Форма.Элементы;
	
	Если Элементы.ПервоначальнаяСтоимостьУУ.Видимость 
		И Форма.ВалютаУпр = Форма.ВалютаРегл
		И Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьУУ Тогда
		Форма.ПервоначальнаяСтоимостьУУ = Форма.ПервоначальнаяСтоимостьБУ;
	КонецЕсли; 
	
	Если Элементы.ПервоначальнаяСтоимостьНУ.Видимость 
		И Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьБУ = Форма.ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьНУ Тогда
		Форма.ПервоначальнаяСтоимостьНУ = Форма.ПервоначальнаяСтоимостьБУ;
	КонецЕсли; 
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Выполнить_ПересчитатьЗависимыеСуммы");
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_РезервПереоценкиСтоимостиРеглСуммаПриИзменении(Форма)
	
	Если Форма.ТекущаяСтоимостьБУ <> 0 И Форма.РезервПереоценкиСтоимостиРеглСумма <> 0 Тогда
		МножительЦФ = ?(Форма.ПрименениеЦелевогоФинансирования, 1, 0);
		Форма.РезервПереоценкиАмортизацииРеглСумма = 
			(Форма.НакопленнаяАмортизацияБУ + МножительЦФ * Форма.НакопленнаяАмортизацияБУЦФ)
			* (Форма.РезервПереоценкиСтоимостиРеглСумма / (Форма.ТекущаяСтоимостьБУ + МножительЦФ * Форма.ТекущаяСтоимостьБУ));
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_СтатьяРасходовБУПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяРасходовБУ) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаРасходовБУ = Неопределено;
		Форма.АналитикаРасходовБУОбязательна = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаРедактированияСтрокиНМА_СтатьяДоходовПриИзменении(Форма, ТребуетсяВызовСервера)
	
	Если ЗначениеЗаполнено(Форма.СтатьяДоходов) Тогда
		ТребуетсяВызовСервера = Истина;
	Иначе
		Форма.АналитикаДоходовОбязательна = Ложь;
		Форма.АналитикаДоходов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти

#КонецОбласти
