
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УказываетсяТранспортноеСредствоПредприятия = Параметры.УказываетсяТранспортноеСредствоПредприятия
	                                           И ИнтеграцияВЕТИС.УказываетсяТранспортноеСредство();
	ОбязательностьНомераТранспортногоСредства  = Параметры.ОбязательностьНомераТранспортногоСредства;
	
	Для каждого КлючИЗначение Из ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхПунктаМаршрута() Цикл
		Параметры.Свойство(КлючИЗначение.Ключ, ЭтаФорма[КлючИЗначение.Ключ]);
	КонецЦикла;
	
	Если Параметры.Свойство("ЭтоМаршрутВозврата") Тогда
		ЭтоМаршрутВозврата = Параметры.ЭтоМаршрутВозврата;
	КонецЕсли;
	
	РежимРаботыФормы = Новый Структура;
	Если Параметры.Свойство("РежимРаботыФормы") Тогда
		РежимРаботыФормы = Параметры.РежимРаботыФормы;
	КонецЕсли;
	
	Параметры.Свойство("ХозяйствующийСубъект", ХозяйствующийСубъект);
	
	Если Параметры.Свойство("ДанныеАдреса") И Параметры.ДанныеАдреса <> Неопределено
		И ЗначениеЗаполнено(Параметры.ДанныеАдреса.СтранаGUID) Тогда
		СтранаМира = ИнтеграцияВЕТИСПовтИсп.СтранаМира(Параметры.ДанныеАдреса.СтранаGUID);
	Иначе
		СтранаМира = Справочники.СтраныМира.Россия;
	КонецЕсли;
	
	Элементы.ПредставлениеАдреса.Видимость      = (СтранаМира  = Справочники.СтраныМира.Россия);
	Элементы.ПредставлениеАдресаВЕТИС.Видимость = (СтранаМира <> Справочники.СтраныМира.Россия);
	
	ВидПунктаМаршрута = ?(ЗначениеЗаполнено(Адрес) ИЛИ ЗначениеЗаполнено(АдресПредставление), 1, 0);
	
	Если НЕ ЗначениеЗаполнено(ТипТранспорта) Тогда
		ТипТранспорта = Перечисления.ТипыТранспортаВЕТИС.Автомобиль;
	КонецЕсли;
	
	СПерегрузкой = Макс(СПерегрузкой, ЗначениеЗаполнено(НомерТранспортногоСредства));
	Если РежимРаботыФормы.Свойство("ВидПунктаМаршрута") Тогда
		Если РежимРаботыФормы.ВидПунктаМаршрута.Свойство("Видимость") Тогда
			Если Не РежимРаботыФормы.ВидПунктаМаршрута.Видимость Тогда
				СПерегрузкой = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	НастроитьВидимостьДоступностьЭлементов();
	НастроитьОтображениеВидаПунктаМаршрута(ЭтаФорма);
	НастроитьОтображениеДанныхПоТипуТранспорта(ЭтаФорма);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИнициализироватьПоляКонтактнойИнформации();
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПунктаМаршрутаПриИзменении(Элемент)
	
	НастроитьОтображениеВидаПунктаМаршрута(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСменаТранспорта(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		НастроитьОтображениеДанныхПоТипуТранспорта(ЭтаФорма);
	Иначе
		ТипТранспорта = ТекущийТипТранспорта;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипТранспортаПриИзменении(Элемент)
	
	НомерЗаполнен = Не (ПустаяСтрока(НомерТранспортногоСредства)
		И ПустаяСтрока(НомерАвтомобильногоПрицепа)
		И ПустаяСтрока(НомерАвтомобильногоКонтейнера));
		
	Если НомерЗаполнен И ТипТранспорта = ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.ПерегонСкота")  Тогда	
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ВопросСменаТранспорта", ЭтаФорма);
		ТекстВопроса = НСтр("ru = 'При выборе типа транспорта ""Перегон"" номер транспортного средства будет очищен. Продолжить?'");
		ПоказатьВопрос(ОповещениеОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		НастроитьОтображениеДанныхПоТипуТранспорта(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТранспортноеСредствоПриИзменении(Элемент)
	
	РеквизитыТранспортногоСредства = ЗначенияРеквизитовТранспортногоСредства(ТранспортноеСредство);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыТранспортногоСредства);
	
КонецПроцедуры

#Область РедактированиеАдреса

&НаСервере
Процедура СтранаМираПриИзмененииНаСервере(СтранаМира)
	
	ДанныеСтраныМира = ПрочиеКлассификаторыВЕТИСВызовСервера.ДанныеСтраныМира(СтранаМира);
	
	ДанныеАдреса = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхАдреса();
	ДанныеАдреса.СтранаGUID          = ДанныеСтраныМира.Идентификатор;
	ДанныеАдреса.СтранаПредставление = ДанныеСтраныМира.Наименование;
	
	Адрес              = "";
	АдресПредставление = "";
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаМираПриИзменении(Элемент)
	
	СтранаМираПриИзмененииНаСервере(СтранаМира);
	
	Элементы.ПредставлениеАдреса.Видимость      = (СтранаМира  = ПредопределенноеЗначение("Справочник.СтраныМира.Россия"));
	Элементы.ПредставлениеАдресаВЕТИС.Видимость = (СтранаМира <> ПредопределенноеЗначение("Справочник.СтраныМира.Россия"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаПриИзменении(Элемент)
	
	Текст = Элемент.ТекстРедактирования;
	Если ПустаяСтрока(Текст) Тогда
		// Очистка данных, сбрасываем как представления, так и внутренние значения полей.
		Адрес = "";
		Возврат;
	КонецЕсли;
	
	// Формируем внутренние значения полей по тексту и параметрам формирования из
	// реквизита ВидКонтактнойИнформацииАдресаДоставки.
	АдресПредставление = Текст;
	Адрес = ЗначенияПолейКонтактнойИнформацииСервер(Текст, ВидКонтактнойИнформацииАдреса);
	ДанныеАдреса = ДанныеАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	// Если представление было изменено в поле и сразу нажата кнопка выбора, то необходимо 
	// привести данные в соответствие и сбросить внутренние поля для повторного разбора.
	Если Элемент.ТекстРедактирования <> АдресПредставление Тогда
		АдресПредставление = Элемент.ТекстРедактирования;
		Адрес              = "";
	КонецЕсли;
	
	// Данные для редактирования
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформацииАдреса);
	ПараметрыОткрытия.Вставить("ЗначенияПолей",           Адрес);
	ПараметрыОткрытия.Вставить("Представление",           АдресПредставление);
	
	// Переопределямый заголовок формы, по умолчанию отобразятся данные по ВидКонтактнойИнформации.
	ПараметрыОткрытия.Вставить("Заголовок", НСтр("ru='Адрес точки маршрута'"));
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОчистка(Элемент, СтандартнаяОбработка)
	
	// Сбрасываем как представления, так и внутренние значения полей.
	АдресПредставление = "";
	Адрес              = "";
	ДанныеАдреса = ДанныеАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение)<>Тип("Структура") Тогда
		// Отказ от выбора, данные неизменны.
		Возврат;
	КонецЕсли;
	
	АдресПредставление = ВыбранноеЗначение.Представление;
	Адрес              = ВыбранноеЗначение.КонтактнаяИнформация;
	ДанныеАдреса       = ДанныеАдресаКлиент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеАдресаВЕТИСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ДанныеАдреса", ДанныеАдреса);
	
	ОткрытьФорму(
		"Обработка.КлассификаторыВЕТИС.Форма.РедактированиеАдреса",
		ПараметрыОткрытияФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ОбработатьРезультатРедактированияАдресаВЕТИС", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаМираОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура БезПерегрузкиПриИзменении(Элемент)
	
	Если Не СПерегрузкой Тогда
		
		ТипТранспорта                 = ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.Автомобиль");
		НомерТранспортногоСредства    = Неопределено;
		НомерАвтомобильногоПрицепа    = Неопределено;
		НомерАвтомобильногоКонтейнера = Неопределено;
		
		НастроитьОтображениеДанныхПоТипуТранспорта(ЭтаФорма);
		
	КонецЕсли;
	
	НастроитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ОбработатьПодтверждение();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Отказ = Ложь;
		Если ВидПунктаМаршрута = 1 И ДанныеАдреса = Неопределено Тогда
			ДанныеАдреса = ДанныеАдресаКлиент(, Отказ);
		КонецЕсли;
		
		ОбработатьПодтверждение(Отказ);
		
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПодтверждение(Отказ = Ложь)
	
	ОчиститьСообщения();
	
	ПроверяемыеПоля = Новый Структура;
	
	Если НЕ РежимРаботыФормы.Свойство("ВидПунктаМаршрута")
		ИЛИ НЕ РежимРаботыФормы.ВидПунктаМаршрута.Свойство("Видимость")
		ИЛИ НЕ РежимРаботыФормы.ВидПунктаМаршрута.Видимость = Ложь Тогда
		
		Если ВидПунктаМаршрута = 0 Тогда
			Если Не (СПерегрузкой И ЭтоМаршрутВозврата) Тогда
				ПроверяемыеПоля.Вставить("Предприятие", НСтр("ru = 'Предприятие'"));
			КонецЕсли;
		КонецЕсли;
		
		Если ВидПунктаМаршрута = 1 Тогда
			Поле = "Адрес"+?(СтранаМира = ПредопределенноеЗначение("Справочник.СтраныМира.Россия"),"","Представление");
			ПроверяемыеПоля.Вставить(Поле, НСтр("ru = 'Адрес'"));
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ОбязательностьНомераТранспортногоСредства <> Неопределено И ОбязательностьНомераТранспортногоСредства = Истина)
		ИЛИ (ОбязательностьНомераТранспортногоСредства = Неопределено И СПерегрузкой) Тогда
		
		ПредставлениеНомераТранспортногоСредства 
			= ИнтеграцияВЕТИСКлиентСервер.ПредставлениеНомераТранспортногоСредства(ТипТранспорта);
			
		Если Не ПустаяСтрока(ПредставлениеНомераТранспортногоСредства)
			И (Не (СПерегрузкой И ЭтоМаршрутВозврата)) Тогда
			ПроверяемыеПоля.Вставить("НомерТранспортногоСредства", ПредставлениеНомераТранспортногоСредства);
		КонецЕсли;
		
	КонецЕсли;
	
	ШаблонСообщения = НСтр("ru = 'Не заполнено поле ""%1""'");
	
	Для каждого КлючИЗначение Из ПроверяемыеПоля Цикл
		Если НЕ ЗначениеЗаполнено(ЭтаФорма[КлючИЗначение.Ключ]) Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщения, КлючИЗначение.Значение);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,КлючИЗначение.Ключ,,Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Если ВидПунктаМаршрута = 1 Тогда
		
		Если ДанныеАдреса = Неопределено Тогда
			ДанныеАдреса = ДанныеАдресаКлиент(Ложь, Отказ);
		КонецЕсли;
		
		Если Не Отказ Тогда
		
			Если Не ЗначениеЗаполнено(АдресПредставление) Тогда
				
				ТекстСообщения = НСтр("ru = 'Адрес не заполнен'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресПредставление",, Отказ);
				
			ИначеЕсли ДанныеАдреса = Неопределено
				Или ТипЗнч(ДанныеАдреса) <> Тип("Структура")
				Или НЕ ДанныеАдреса.Свойство("СтранаGUID")
				Или НЕ ДанныеАдреса.Свойство("РегионGUID")
				Или НЕ ЗначениеЗаполнено(ДанныеАдреса.СтранаGUID)
				Или НЕ ЗначениеЗаполнено(ДанныеАдреса.РегионGUID) Тогда
				
				ТекстСообщения = НСтр("ru = 'Адрес заполнен некорректно. Необходимо выбирать значения из классификатора'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресПредставление",, Отказ);
				
			Иначе
				
				ИнтеграцияВЕТИСКлиент.ПроверитьКорректностьДанныхАдреса(ДанныеАдреса, "АдресПредставление", Отказ)
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		СохранитьИзменения();
	КонецЕсли;
	
КонецПроцедуры

#Область РедактированиеАдреса

&НаКлиенте
Функция ДанныеАдресаКлиент(ОчищатьСообщения = Истина, Отказ = Ложь)
	Попытка
		ДанныеАдресаСтруктурой = ИнтеграцияВЕТИСВызовСервера.ДанныеАдресаПоАдресуXML(Адрес, АдресПредставление);
	Исключение
		Если СтранаМира = ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
			ИмяПоля = "ПредставлениеАдреса";
			ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введен регион. Повторите ввод.'");
		Иначе
			ИмяПоля = "ПредставлениеАдресаВЕТИС";
			ТекстСообщения = НСтр("ru = 'Не удалось прочитать данные адреса. Возможно не корректно введены данные. Повторите ввод. Причина ошибки: %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ОписаниеОшибки());
		КонецЕсли;
		Если ОчищатьСообщения Тогда
			ОчиститьСообщения();
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяПоля);
		ДанныеАдресаСтруктурой = Неопределено;
		
		Отказ = Истина;
	КонецПопытки;
	
	Возврат ДанныеАдресаСтруктурой;
	
КонецФункции

&НаСервере
Процедура ИнициализироватьПоляКонтактнойИнформации()
	
	// Реквизит формы, контролирующий работу с адресом доставки.
	// Используемые поля аналогичны полям справочника ВидыКонтактнойИнформации.
	ВидКонтактнойИнформацииАдреса = Новый Структура;
	ВидКонтактнойИнформацииАдреса.Вставить("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес);
	ВидКонтактнойИнформацииАдреса.Вставить("ТолькоНациональныйАдрес",      Истина);
	ВидКонтактнойИнформацииАдреса.Вставить("ВключатьСтрануВПредставление", Ложь);
	ВидКонтактнойИнформацииАдреса.Вставить("СкрыватьНеактуальныеАдреса",   Ложь);
	
	Если СтранаМира = Справочники.СтраныМира.Россия Тогда
		// Считываем данные из полей адреса в реквизиты для редактирования.
		//Если адресный классификатор не загружен, то корректной конвертации адреса не произойдет.
		Если ЗначениеЗаполнено(АдресПредставление)
		   И ТипЗнч(ДанныеАдреса) = Тип("Структура")
		   И ДанныеАдреса.Свойство("СтранаGUID")
		   И ЗначениеЗаполнено(ДанныеАдреса.СтранаGUID)
		   И ДанныеАдреса.Свойство("РегионGUID")
		   И ЗначениеЗаполнено(ДанныеАдреса.РегионGUID) Тогда
			ПрочитатьПредставлениеАдреса = Ложь;
		Иначе
			ПрочитатьПредставлениеАдреса = Истина;
		КонецЕсли;
		Если ПрочитатьПредставлениеАдреса Тогда
			АдресПредставление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(Адрес);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияПолейКонтактнойИнформацииСервер(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено)
	
	// Создаем новый экземпляр по представлению.
	Результат = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбработатьРезультатРедактированияАдресаВЕТИС(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Адрес              = "";
	АдресПредставление = Результат.ПредставлениеАдреса;
	ДанныеАдреса       = Результат;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура НастроитьВидимостьДоступностьЭлементов()
	
	Элементы.ГруппаТранспортноеСредство.Доступность = СПерегрузкой;
	
	Если РежимРаботыФормы.Свойство("ИзменятьСоставСтрок") И РежимРаботыФормы.ИзменятьСоставСтрок Тогда
		Элементы.ГруппаТранспортноеСредство.Доступность = Истина;
	КонецЕсли;
	
	Если ОбязательностьНомераТранспортногоСредства = Неопределено Тогда
		Элементы.НомерТранспортногоСредства.АвтоОтметкаНезаполненного = СПерегрузкой И Не ЭтоМаршрутВозврата;
	Иначе 
		Элементы.НомерТранспортногоСредства.АвтоОтметкаНезаполненного = ОбязательностьНомераТранспортногоСредства И Не ЭтоМаршрутВозврата;
	КонецЕсли;
	
	Если РежимРаботыФормы.Свойство("ВидПунктаМаршрута") Тогда
		Если РежимРаботыФормы.ВидПунктаМаршрута.Свойство("ТолькоПросмотр") Тогда
			Элементы.ГруппаПунктМаршрута.ТолькоПросмотр = РежимРаботыФормы.ВидПунктаМаршрута.ТолькоПросмотр;
		КонецЕсли;
		Если РежимРаботыФормы.ВидПунктаМаршрута.Свойство("Видимость") Тогда
			Элементы.ГруппаПунктМаршрута.Видимость = РежимРаботыФормы.ВидПунктаМаршрута.Видимость;
			Элементы.ГруппаТранспортноеСредство.ОтображатьЗаголовок = Ложь;
			ЭтаФорма.Заголовок = Элементы.ГруппаТранспортноеСредство.Заголовок;
			ЭтаФорма.АвтоЗаголовок = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если РежимРаботыФормы.Свойство("ТипТранспорта") Тогда
		Если РежимРаботыФормы.ТипТранспорта.Свойство("ТолькоПросмотр") Тогда
			Элементы.ТипТранспорта.ТолькоПросмотр = РежимРаботыФормы.ТипТранспорта.ТолькоПросмотр;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеВидаПунктаМаршрута(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ВидПунктаМаршрута = 0 Тогда
		Элементы.ГруппаПунктМаршрутаСтраницы.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаПредприятие;
		Форма.Адрес = "";
	Иначе
		Элементы.ГруппаПунктМаршрутаСтраницы.ТекущаяСтраница = 
			Элементы.ГруппаСтраницаАдрес;
		Форма.Предприятие = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеДанныхПоТипуТранспорта(Форма)
	
	Элементы = Форма.Элементы;
	
	Форма.ТекущийТипТранспорта = Форма.ТипТранспорта;
	
	ВидимостьДопПолей = Ложь;
	ВидимостьПоляТранспортноеСредство = Ложь;
	Если Форма.ТипТранспорта = ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.Автомобиль") Тогда
		ВидимостьДопПолей = Истина;
		ВидимостьПоляТранспортноеСредство = Форма.УказываетсяТранспортноеСредствоПредприятия;
	Иначе
		Форма.НомерАвтомобильногоПрицепа    = "";
		Форма.НомерАвтомобильногоКонтейнера = "";
	КонецЕсли;
	
	Элементы.ТранспортноеСредство.Видимость          = ВидимостьПоляТранспортноеСредство;
	Элементы.НомерАвтомобильногоПрицепа.Видимость    = ВидимостьДопПолей;
	Элементы.НомерАвтомобильногоКонтейнера.Видимость = ВидимостьДопПолей;
	
	ВидимостьНомера = Не Форма.ТипТранспорта = ПредопределенноеЗначение("Перечисление.ТипыТранспортаВЕТИС.ПерегонСкота");
	Если Не ВидимостьНомера Тогда
		Форма.НомерТранспортногоСредства    = "";
		Форма.НомерАвтомобильногоПрицепа    = "";
		Форма.НомерАвтомобильногоКонтейнера = "";
	КонецЕсли;
	Элементы.НомерТранспортногоСредства.Видимость = ВидимостьНомера;
	
	Элементы.НомерТранспортногоСредства.Заголовок = 
		ИнтеграцияВЕТИСКлиентСервер.ПредставлениеНомераТранспортногоСредства(Форма.ТипТранспорта);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения()
	
	Результат = ИнтеграцияВЕТИСКлиентСервер.СтруктураДанныхПунктаМаршрута();
	ЗаполнитьЗначенияСвойств(Результат, ЭтаФорма);
	Если ВидПунктаМаршрута = 0 Тогда
		Результат.Адрес              = "";
		Результат.АдресПредставление = "";
		Результат.ДанныеАдреса       = Неопределено;
	Иначе
		Результат.Предприятие = Неопределено;
	КонецЕсли;
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗначенияРеквизитовТранспортногоСредства(ТранспортноеСредство)
	
	РеквизитыТранспортногоСредства = Новый Структура;
	РеквизитыТранспортногоСредства.Вставить("НомерТранспортногоСредства");
	РеквизитыТранспортногоСредства.Вставить("НомерАвтомобильногоПрицепа");
	РеквизитыТранспортногоСредства.Вставить("НомерАвтомобильногоКонтейнера");
	ИнтеграцияВЕТИСПереопределяемый.ПриОпределенииРеквизитовТранспортногоСредства(РеквизитыТранспортногоСредства, ТранспортноеСредство);
	Возврат РеквизитыТранспортногоСредства;
	
КонецФункции

#КонецОбласти