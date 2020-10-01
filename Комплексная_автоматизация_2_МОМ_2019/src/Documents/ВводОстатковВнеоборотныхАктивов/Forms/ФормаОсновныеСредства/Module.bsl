
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриСозданииЧтенииНаСервере();
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков2_2(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ТипОперации", Объект.ТипОперации);
	Оповестить("Запись_ВводОстатковВнеоборотныхАктивов", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИзменениеСтрокиОС();
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ИзменениеСтрокиОС(Истина, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ОСПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ИзменениеСтрокиОС();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемы

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

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	Заголовок = ВнеоборотныеАктивыВызовСервера.ПредставлениеВводаОстатков2_2(Объект);
	
КонецПроцедуры

&НаКлиенте
Функция РеквизитыРедактируемыеВОтдельнойФорме()
	
	СтрокаТаблицы = Элементы.ОС.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат Новый Структура;
	КонецЕсли;
	
	СтруктураТабличнойЧастиОС = Новый Структура(
	"ОсновноеСредство,
	|ИнвентарныйНомер,
	|ПорядокУчетаБУ,
	|ПорядокУчетаНУ,
	|СчетУчета,
	|СчетАмортизации,
	|ГруппаОС,
	|ДоговорЛизинга,
	|АмортизационнаяГруппа,
	|КодПоОКОФ,
	|ШифрПоЕНАОФ,
	|СпособПоступления,
	|МОЛ,
	|АдресМестонахождения,
	|ПервоначальнаяСтоимостьБУ,
	|ПервоначальнаяСтоимостьНУ,
	|ПервоначальнаяСтоимостьПР,
	|ТекущаяСтоимостьБУ,
	|ТекущаяСтоимостьНУ,
	|ТекущаяСтоимостьПР,
	|НакопленнаяАмортизацияБУ,
	|НакопленнаяАмортизацияНУ,
	|НакопленнаяАмортизацияПР,
	|НачислятьАмортизациюБУ,
	|МетодНачисленияАмортизацииБУ,
	|СрокИспользованияБУ,
	|ПоказательНаработки,
	|ОбъемНаработкиБУ,
	|КоэффициентАмортизацииБУ,
	|КоэффициентУскоренияБУ,
	|ГрафикАмортизацииБУ,
	|НачислятьАмортизациюНУ,
	|СрокИспользованияНУ,
	|СпециальныйКоэффициентНУ,
	|СтатьяРасходовАмортизации,
	|АналитикаРасходовАмортизации,
	|НомерДокументаПринятияКУчету,
	|НомерДокументаМодернизации,
	|СобытиеПринятияКУчету,
	|СобытиеМодернизации,
	|НазваниеДокументаПринятияКУчету,
	|НазваниеДокументаМодернизации,
	|ДатаПринятияКУчету,
	|ДатаМодернизации,
	|СтатьяРасходовНалог,
	|АналитикаРасходовНалог,
	|Контрагент,
	|ПередаватьРасходыВДругуюОрганизацию,
	|ОрганизацияПолучательРасходов,
	|СчетПередачиРасходов,
	|ВключитьАмортизационнуюПремиюВСоставРасходов,
	|СтатьяРасходовАмортизационнойПремии,
	|АналитикаРасходовАмортизационнойПремии,
	|СуммаКапитальныхВложенийВключаемыхВРасходыНУ,
	|ЕстьСобытияМодернизации,
	|СтоимостьДляВычисленияАмортизации,
	|ПервоначальнаяСтоимостьОтличается,
	|ВариантРаздельногоУчетаНДС,
	|НалогообложениеНДС,
	|ПрименениеЦелевогоФинансирования,
	|СчетУчетаЦФ,
	|СчетАмортизацииЦФ,
	|СтатьяДоходов,
	|АналитикаДоходов,
	|ТекущаяСтоимостьБУЦФ,
	|ТекущаяСтоимостьНУЦФ,
	|ТекущаяСтоимостьПРЦФ,
	|НакопленнаяАмортизацияБУЦФ,
	|НакопленнаяАмортизацияНУЦФ,
	|НакопленнаяАмортизацияПРЦФ,
	|ЕстьРезервПереоценки,
	|РезервПереоценкиСтоимости,
	|РезервПереоценкиАмортизации,
	|РасчетыМеждуОрганизациямиАрендатор,
	|СчетУчетаАрендатора,
	|ПодразделениеАрендатора,
	|ЗалоговаяСтоимость,
	|НакопленнаяАмортизацияНУДо2009,
	|СрокИспользованияНУДо2009,
	|КорректировкаСтоимостиАрендованногоИмуществаНУ");
	
	ЗаполнитьЗначенияСвойств(СтруктураТабличнойЧастиОС, СтрокаТаблицы);
	
	Возврат СтруктураТабличнойЧастиОС;
	
КонецФункции

&НаКлиенте
Процедура ИзменениеСтрокиОС(ЭтоНовый = Ложь, Копирование = Ложь)
	
	ДанныеЗаполнения = ?(Не ЭтоНовый ИЛИ Копирование, РеквизитыРедактируемыеВОтдельнойФорме(), Новый Структура);
	ДанныеЗаполнения.Вставить("Дата", Объект.Дата);
	ДанныеЗаполнения.Вставить("Организация", Объект.Организация);
	ДанныеЗаполнения.Вставить("ТипОперации", Объект.ТипОперации);
	ДанныеЗаполнения.Вставить("Ссылка", Объект.Ссылка);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭтоНовый", ЭтоНовый);
	СтруктураПараметров.Вставить("Копирование", Копирование);
	СтруктураПараметров.Вставить("ДанныеЗаполнения", ДанныеЗаполнения);
	
	ФормаРедактированияСтроки = Неопределено;
	
	ОткрытьФорму(
		"Документ.ВводОстатковВнеоборотныхАктивов.Форма.ФормаРедактированияСтрокиОС",
		СтруктураПараметров,
		ЭтаФорма,,,,
		Новый ОписаниеОповещения(
			"ИзменениеСтрокиОСЗавершение",
			ЭтотОбъект,
			Новый Структура("ЭтоНовый", ЭтоНовый)),
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтрокиОСЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ЭтоНовый = ДополнительныеПараметры.ЭтоНовый;
	
	ФормаРедактированияСтроки = Результат;
	
	Если ФормаРедактированияСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый Тогда
		СтрокаТаблицы = Объект.ОС.Добавить();
	Иначе
		СтрокаТаблицы = Объект.ОС.НайтиПоИдентификатору(Элементы.ОС.ТекущаяСтрока);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ФормаРедактированияСтроки);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти
