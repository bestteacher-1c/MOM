////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентБазовый: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийФормыСотрудника

Процедура СотрудникиОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИзмененыДанныеДополнительнойФормы"
		И ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения")
		И Источник.УникальныйИдентификатор = Форма.УникальныйИдентификатор Тогда
		
		Форма.ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр);
		СотрудникиКлиентСервер.УстановитьПризнакРедактированияДанныхВДополнительнойФорме(Параметр.ИмяФормы, Форма)
		
	КонецЕсли;

	СотрудникиКлиент.ЛичныеДанныеФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма);
	
	// Вычеты
	Если ИмяСобытия = "ИзменениеДанныхМестаРаботы"
		И Параметр.ФизическоеЛицо = Форма.ФизическоеЛицоСсылка
		И Форма <> Источник Тогда
		
		Если Параметр.Сотрудник = Форма.Сотрудник.Ссылка Тогда
			Форма.ПрочитатьДанныеСвязанныеСФизлицом();
		Иначе
			Форма.ОбработкаИзмененияДанныхОРабочемМестеНаСервере(Параметр.Сотрудник);
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "ОтредактированаИстория" И (Форма.ФизическоеЛицоСсылка = Источник ИЛИ Форма.СотрудникСсылка = Источник) Тогда
		Если Параметр.ИмяРегистра = "ФИОФизическихЛиц" Тогда
			Если Форма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(Форма, Форма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				НаименованиеПоМенеджеруЗаписи = Форма.ФИОФизическихЛиц.Фамилия + " " + Форма.ФИОФизическихЛиц.Имя + " " + Форма.ФИОФизическихЛиц.Отчество;
				Если Не ПустаяСтрока(НаименованиеПоМенеджеруЗаписи) И Форма.ФизическоеЛицо.ФИО <> НаименованиеПоМенеджеруЗаписи Тогда
					Форма.ФизическоеЛицо.ФИО = НаименованиеПоМенеджеруЗаписи;
					СотрудникиКлиент.СформироватьНаименованиеСотрудника(Форма);
				КонецЕсли; 
				СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура СотрудникиПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	ОчиститьСообщения();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	
	// Запрос про полное имя
	Оповещение = Новый ОписаниеОповещения("СотрудникиПередЗаписьюИзменитьФИО", ЭтотОбъект, ДополнительныеПараметры);
	ЗапроситьРежимИзмененияФИО(Форма, Форма.ФИОФизическихЛиц, Форма.ФИОФизическихЛицНоваяЗапись, Отказ, НСтр("ru = 'сотрудника'"), Оповещение);

КонецПроцедуры

Процедура СотрудникиПередЗаписьюИзменитьФИО(Отказ, ДополнительныеПараметры) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Форма.ФИОФизическихЛицНоваяЗапись И Форма.ВыполненаКомандаСменыФИО = Ложь Тогда
		Оповещение = Новый ОписаниеОповещения("СотрудникиПередЗаписьюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		СотрудникиКлиент.ИзменитьФИОСотрудника(Форма, Оповещение);
	Иначе 
		СотрудникиПередЗаписьюЗавершение(Отказ, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура СотрудникиПередЗаписьюЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Форма.Записать(ПараметрыЗаписи) Тогда
		
		Форма.Модифицированность = Ложь;
		Если ДополнительныеПараметры.ЗакрытьПослеЗаписи И Форма.Открыта() Тогда 
			Форма.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписью(Форма, Отказ, ПараметрыЗаписи, ОповещениеЗавершения = Неопределено, ЗакрытьПослеЗаписи = Истина) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Отказ", Отказ);
	ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	
	Если Не Форма.СозданиеНового И Не Отказ Тогда
		// запрос про гражданство
		Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюФИО", ЭтотОбъект, ДополнительныеПараметры);
		СотрудникиКлиент.ЗапроситьРежимИзмененияГражданства(Форма, Форма.ГражданствоФизическихЛиц.Период, Отказ, Оповещение);
	Иначе 
		ФизическиеЛицаПередЗаписьюФИО(Отказ, ДополнительныеПараметры);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюФИО(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
		
	// Запрос про полное имя
	Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюИзменитьФИО", ЭтотОбъект, ДополнительныеПараметры);
	ЗапроситьРежимИзмененияФИО(Форма, Форма.ФИОФизическихЛиц, Форма.ФИОФизическихЛицНоваяЗапись, Отказ, НСтр("ru = 'сотрудника'"), Оповещение);
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюИзменитьФИО(Отказ, ДополнительныеПараметры) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	// Если внесли изменение в ФИО.
	Если Форма.ФИОФизическихЛицНоваяЗапись И Форма.ВыполненаКомандаСменыФИО = Ложь Тогда
		Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюУдостоверениеЛичности", ЭтотОбъект, ДополнительныеПараметры);
		СотрудникиКлиент.ИзменитьФИОФизическогоЛица(Форма, Оповещение);
	Иначе 
		ФизическиеЛицаПередЗаписьюУдостоверениеЛичности(Ложь, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюУдостоверениеЛичности(Результат, ДополнительныеПараметры) Экспорт

	Отказ = (Результат = Неопределено);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	// Запрос про документ удостоверяющий личность.
	Оповещение = Новый ОписаниеОповещения("ФизическиеЛицаПередЗаписьюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
    СотрудникиКлиент.ЗапроситьРежимИзмененияУдостоверенияЛичности(Форма, Форма.ДокументыФизическихЛиц.Период, Отказ, Оповещение);	
	
КонецПроцедуры

Процедура ФизическиеЛицаПередЗаписьюЗавершение(Отказ, ДополнительныеПараметры) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
	ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Форма.Записать(ПараметрыЗаписи) Тогда
		
		Форма.Модифицированность = Ложь;
		Если ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
			Форма.Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если ИмяСобытия = "ИзмененыДанныеДополнительнойФормы"
		И ТипЗнч(Источник) = Тип("ФормаКлиентскогоПриложения")
		И Источник.УникальныйИдентификатор = Форма.УникальныйИдентификатор Тогда
		
		Форма.ПрочитатьДанныеИзХранилищаВФормуНаСервере(Параметр);
		СотрудникиКлиентСервер.УстановитьПризнакРедактированияДанныхВДополнительнойФорме(Параметр.ИмяФормы, Форма)
		
	КонецЕсли;
	
	СотрудникиКлиент.ЛичныеДанныеФизическогоЛицаОбработкаОповещения(ИмяСобытия, Параметр, Источник, Форма);
	
	Если ИмяСобытия = "ОтредактированаИстория" И Форма.ФизическоеЛицоСсылка = Источник Тогда
		Если (Параметр.ИмяРегистра = "ГражданствоФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ДокументыФизическихЛиц"
			ИЛИ Параметр.ИмяРегистра = "ФИОФизическихЛиц")
			И Форма[Параметр.ИмяРегистра + "НаборЗаписейПрочитан"] Тогда
			Если Параметр.ИмяРегистра = "ДокументыФизическихЛиц" Тогда
				ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(Форма, Форма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия ,Форма.Элементы.ДокументыФизическихЛицСерия, Форма);
				СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер ,Форма.Элементы.ДокументыФизическихЛицНомер, Форма);
				СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
			Иначе
				РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(Форма, Форма.ФизическоеЛицоСсылка, ИмяСобытия, Параметр, Источник);
				Если Параметр.ИмяРегистра = "ГражданствоФизическихЛиц" Тогда
					Если ЗначениеЗаполнено(Форма.ГражданствоФизическихЛиц.Страна) Тогда
						Форма.ГражданствоФизическихЛицЛицоБезГражданства = 0;
					Иначе
						Форма.ГражданствоФизическихЛицЛицоБезГражданства = 1;
					КонецЕсли;
					СотрудникиКлиентСервер.ОбновитьДоступностьПолейВводаГражданства(Форма, ОбщегоНазначенияКлиент.ДатаСеанса());
				ИначеЕсли Параметр.ИмяРегистра = "ФИОФизическихЛиц" Тогда
					НаименованиеПоМенеджеруЗаписи = Форма.ФИОФизическихЛиц.Фамилия + " " + Форма.ФИОФизическихЛиц.Имя + " " + Форма.ФИОФизическихЛиц.Отчество;
					Если Не ПустаяСтрока(НаименованиеПоМенеджеруЗаписи) И Форма.ФизическоеЛицо.ФИО <> НаименованиеПоМенеджеруЗаписи Тогда
						Форма.ФизическоеЛицо.ФИО = НаименованиеПоМенеджеруЗаписи;
						СотрудникиКлиент.СформироватьНаименованиеФизическогоЛица(Форма);
					КонецЕсли; 
					СотрудникиКлиентСервер.УстановитьВидимостьПолейФИО(Форма);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Процедура ЗапроситьРежимИзмененияФИО(Форма, МенеджерЗаписиФИО, НоваяЗапись, Отказ, ПредставлениеСущности, ОповещениеЗавершения = Неопределено)
	
	// Если на вопрос про ввод новой записи еще не ответили.
	Если Форма.ДоступенПросмотрДанныхФизическихЛиц И НоваяЗапись = Ложь Тогда
		
		НоваяДатаФИО = ОбщегоНазначенияКлиент.ДатаСеанса();
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("МенеджерЗаписиФИО", МенеджерЗаписиФИО);
		ДополнительныеПараметры.Вставить("НоваяДатаФИО", НоваяДатаФИО);
		ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("ЗапроситьРежимИзмененияФИОЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru =  'При редактировании изменено полное имя %2. 
							|Если просто исправлены прежние данные (они были ошибочны), нажмите ""Исправлена ошибка"".
							|Если у сотрудника сменилась фамилия или имя, нажмите ""Сотрудник изменил имя""'"), 
				Формат(НоваяДатаФИО, "ДФ='д ММММ гггг ""г""'"), ПредставлениеСущности);
		ТекстКнопкиДа = НСтр("ru = 'Сотрудник изменил имя'");
		РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(Форма, "ФИОФизическихЛиц", ТекстВопроса, ТекстКнопкиДа, Отказ, Оповещение);	
		
	Иначе 
		
		Если ОповещениеЗавершения <> Неопределено Тогда 
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры	

Процедура ЗапроситьРежимИзмененияФИОЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	Форма = ДополнительныеПараметры.Форма;
	МенеджерЗаписиФИО = ДополнительныеПараметры.МенеджерЗаписиФИО;
	НоваяДатаФИО = ДополнительныеПараметры.НоваяДатаФИО;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	Если Не Отказ И Форма["ФИОФизическихЛицНоваяЗапись"] = Истина Тогда
		МенеджерЗаписиФИО.Период = НоваяДатаФИО;
		Форма.ВыполненаКомандаСменыФИО = Ложь;
	КонецЕсли;

	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ФизическиеЛицаИННПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбработатьОтображениеПоляИНН(Форма.ФизическоеЛицо.ИНН, Элемент,  Форма);
КонецПроцедуры

Процедура ФизическиеЛицаСтраховойНомерПФРПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбработатьОтображениеПоляСтраховойНомерПФР(Форма.ФизическоеЛицо.СтраховойНомерПФР, Элемент, Форма);
КонецПроцедуры

Процедура ДокументыФизическихЛицВидДокументаПриИзменении(Форма) Экспорт
	СотрудникиКлиентСервер.ОбновитьГруппуФамилияИмяЛатиницей(Форма, "ДокументыФизическихЛиц");
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия ,Форма.Элементы.ДокументыФизическихЛицСерия, Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер ,Форма.Элементы.ДокументыФизическихЛицНомер, Форма);
	Форма.ДокументыФизическихЛиц.СтранаВыдачи = Неопределено;
	СотрудникиКлиентСервер.УстановитьВидимостьСтраныВыдачиДокумента(Форма);
КонецПроцедуры

Процедура ДокументыФизическихЛицСерияПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеСерияДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Серия, Элемент,  Форма);
КонецПроцедуры

Процедура ДокументыФизическихЛицНомерПриИзменении(Форма, Элемент) Экспорт
	СотрудникиКлиентСервер.ОбновитьПолеУдостоверениеЛичностиПериод(Форма);
	СотрудникиКлиентСервер.ОбработатьОтображениеНомерДокументаФизическогоЛица(Форма.ДокументыФизическихЛиц.ВидДокумента, Форма.ДокументыФизическихЛиц.Номер, Элемент,  Форма);
КонецПроцедуры

Процедура ОбработкаОповещенияОтредактированаИсторияДокументыФизическихЛиц(Форма, ВедущийОбъект, ИмяСобытия, Параметр, Источник) Экспорт
	
	КоллекцииИдентичны = РедактированиеПериодическихСведенийКлиент.КоллекцииНаборовИдентичны(Форма[Параметр.ИмяРегистра + "НаборЗаписей"], Параметр.МассивЗаписей, ОбщегоНазначенияКлиентСервер.КлючиСтруктурыВСтроку(Форма[Параметр.ИмяРегистра + "Прежняя"]));
	Если НЕ КоллекцииИдентичны Тогда
		НаборЗаписей = Форма[Параметр.ИмяРегистра + "НаборЗаписей"];
		НаборЗаписей.Очистить();
		Для Каждого Строка Из Параметр.МассивЗаписей Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Строка);
		КонецЦикла;
		НаборЗаписей.Сортировать("Период");
		ПоследняяЗапись = Неопределено;
		Если НаборЗаписей.Количество() > 0 Тогда
			Для СмещениеИндекса = 0 По НаборЗаписей.Количество()-1 Цикл
				Запись = НаборЗаписей[НаборЗаписей.Количество() - 1 - СмещениеИндекса];
				Если Запись.ЯвляетсяДокументомУдостоверяющимЛичность Тогда
					ПоследняяЗапись = Запись;
					Прервать;
				КонецЕсли; 
			КонецЦикла;
		КонецЕсли;
		Если ПоследняяЗапись <> Неопределено Тогда
			СтруктураЗаписи = Новый Структура();
			Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
				СтруктураЗаписи.Вставить(КлючЗначение.Ключ, ПоследняяЗапись[КлючЗначение.Ключ]);
			КонецЦикла;
			Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
		Иначе
			МенеджерЗаписи = РедактированиеПериодическихСведенийВызовСервера.СтруктураМенеджераЗаписи(Параметр.ИмяРегистра, ВедущийОбъект);
			СтруктураЗаписи = Новый Структура();
			Для Каждого КлючЗначение Из Форма[Параметр.ИмяРегистра + "Прежняя"] Цикл
				СтруктураЗаписи.Вставить(КлючЗначение.Ключ, МенеджерЗаписи[КлючЗначение.Ключ]);
			КонецЦикла;
			Форма[Параметр.ИмяРегистра + "Прежняя"] = Новый ФиксированнаяСтруктура(СтруктураЗаписи);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(Форма[Параметр.ИмяРегистра], Форма[Параметр.ИмяРегистра + "Прежняя"]);
		Форма.Модифицированность = Истина;
		РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, Параметр.ИмяРегистра, ВедущийОбъект);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
