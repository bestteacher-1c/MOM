#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// восстанавливаем режим отображения списка областей данных
	ПоказыватьОбластиДанных = ХранилищеОбщихНастроек.Загрузить("ОбщаяФормаРабочийстолОператораОтправки", "РежимОтображенияОбластейДанных");
	Если ПоказыватьОбластиДанных <> "0" И ПоказыватьОбластиДанных <> "1" И ПоказыватьОбластиДанных <> "2" Тогда
		ПоказыватьОбластиДанных = "0";
	КонецЕсли;
	
	// регулируем пометку подменю
	Если ПоказыватьОбластиДанных = "0" Тогда
		Элементы.ОбластиДанныхКнопкаОтображатьТребующиеАудита.Пометка = Истина;
	ИначеЕсли ПоказыватьОбластиДанных = "1" Тогда
		Элементы.ОбластиДанныхКнопкаОтображатьСОтчетностьюВОбработке.Пометка = Истина;
	ИначеЕсли ПоказыватьОбластиДанных = "2" Тогда
		Элементы.ОбластиДанныхКнопкаОтображатьВсе.Пометка = Истина;
	КонецЕсли;
	
	// прячем группу с информацией из областей данных пользователей
	Элементы.ГруппаПравая.ТекущаяСтраница = Элементы.ГруппаПраваяПустая;
	Элементы.ГруппаПраваяОтчетность.Видимость = Ложь;
	
	ЗаполнитьОбластиДанных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ОбластиДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВойтиВВыбраннуюОбласть();
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрацииВИФНСВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "РегистрацииВИФНСДоверенность" Тогда
		СтандартнаяОбработка = Ложь;
		Если Элемент.ТекущиеДанные <> Неопределено И Элемент.ТекущиеДанные.Доверенность <> Неопределено Тогда
			ПоказатьЗначение(, Элемент.ТекущиеДанные.Доверенность);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВойтиВВыбраннуюОбласть(Команда = Неопределено)
	
	ТекСтрока = Элементы.ОбластиДанных.ТекущаяСтрока;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрокаРеквизита = ОбластиДанных.НайтиПоИдентификатору(ТекСтрока);
	Если ТекСтрокаРеквизита = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВойтиВОбластьДанныхНаСервере(ТекСтрокаРеквизита.Разделитель);
	
	Элементы.КнопкаВыйти.Видимость = Истина;
	
	// считываем данные панели Отчетность заново
	Элементы.ОтправкиОтчетности.Обновить();
	Элементы.СобытияОтправкиОтчетности.Обновить();
	Элементы.РегистрацииВИФНС.Обновить();
	
	Элементы.ГруппаПраваяОтчетность.Видимость = Истина;
	Элементы.ГруппаПравая.ТекущаяСтраница = Элементы.ГруппаПраваяОтчетность;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьВсеОбластиДанных(Команда)
	
	Элементы.ОбластиДанныхКнопкаОтображатьВсе.Пометка = Истина;
	Элементы.ОбластиДанныхКнопкаОтображатьСОтчетностьюВОбработке.Пометка = Ложь;
	Элементы.ОбластиДанныхКнопкаОтображатьТребующиеАудита.Пометка = Ложь;
	
	НовыйПоказыватьОбластиДанных = "2";
	
	Если НовыйПоказыватьОбластиДанных <> ПоказыватьОбластиДанных Тогда
		ПоказыватьОбластиДанных = НовыйПоказыватьОбластиДанных;
		ЗаполнитьОбластиДанных();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОбластиДанныхСОтчетностьюВОбработке(Команда)
	
	Элементы.ОбластиДанныхКнопкаОтображатьВсе.Пометка = Ложь;
	Элементы.ОбластиДанныхКнопкаОтображатьСОтчетностьюВОбработке.Пометка = Истина;
	Элементы.ОбластиДанныхКнопкаОтображатьТребующиеАудита.Пометка = Ложь;
	
	НовыйПоказыватьОбластиДанных = "1";
	
	Если НовыйПоказыватьОбластиДанных <> ПоказыватьОбластиДанных Тогда
		ПоказыватьОбластиДанных = НовыйПоказыватьОбластиДанных;
		ЗаполнитьОбластиДанных();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьОбластиТребующиеАудита(Команда)
	
	Элементы.ОбластиДанныхКнопкаОтображатьВсе.Пометка = Ложь;
	Элементы.ОбластиДанныхКнопкаОтображатьСОтчетностьюВОбработке.Пометка = Ложь;
	Элементы.ОбластиДанныхКнопкаОтображатьТребующиеАудита.Пометка = Истина;
	
	НовыйПоказыватьОбластиДанных = "0";
	
	Если НовыйПоказыватьОбластиДанных <> ПоказыватьОбластиДанных Тогда
		ПоказыватьОбластиДанных = НовыйПоказыватьОбластиДанных;
		ЗаполнитьОбластиДанных();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкиСдачиОтчетностиЧерезСервисСпецоператора",,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНаправленияСдачиОтчетности(Команда)
	
	ОткрытьФорму("Справочник.НаправленияСдачиОтчетности.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОбластиДанных(Команда)
	
	ЗаполнитьОбластиДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации(Команда)
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыйтиИзОбластиДанных(Команда)
	
	ВыключитьИспользованиеРазделителя();
	Элементы.КнопкаВыйти.Видимость = Ложь;
	Элементы.ГруппаПраваяОтчетность.Видимость = Ложь;
	Элементы.ГруппаПравая.ТекущаяСтраница = Элементы.ГруппаПраваяПустая;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьОбластиДанных()
	
	ТекДанные = Элементы.ОбластиДанных.ТекущаяСтрока;
	Если ТекДанные <> Неопределено Тогда
		ТекСтрокаРазделитель = ОбластиДанных.НайтиПоИдентификатору(ТекДанные).Разделитель;
	КонецЕсли;
	
	Если ПоказыватьОбластиДанных = "2" Тогда // все
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) КАК Представление,
		                      |	ОбластиДанных.ОбластьДанныхВспомогательныеДанные КАК Разделитель,
		                      |	ОтправкиКОбработке.ТребуетАудита КАК ТребуетАудита
		                      |ИЗ
		                      |	РегистрСведений.ОбластиДанных КАК ОбластиДанных
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		                      |			ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
		                      |			МАКСИМУМ(ОтправкиОтчетностиКОбработке.ТребуетАудита) КАК ТребуетАудита
		                      |		ИЗ
		                      |			РегистрСведений.ОтправкиОтчетностиКОбработке КАК ОтправкиОтчетностиКОбработке
		                      |		ГДЕ
		                      |			ОтправкиОтчетностиКОбработке.Идентификатор <> """"
		                      |		
		                      |		СГРУППИРОВАТЬ ПО
		                      |			ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные) КАК ОтправкиКОбработке
		                      |		ПО ОбластиДанных.ОбластьДанныхВспомогательныеДанные = ОтправкиКОбработке.ОбластьДанных,
		                      |		Константа.ПредставлениеОбластиДанных КАК ПредставлениеОбластиДанных
		                      |ГДЕ
		                      |	ОбластиДанных.Статус = &СтатусИспользуемая
		                      |	И ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) <> """"
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Разделитель");
		Запрос.УстановитьПараметр("СтатусИспользуемая", Перечисления.СтатусыОбластейДанных.Используется);
		
	ИначеЕсли ПоказыватьОбластиДанных = "1" Тогда // все незавершенные
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) КАК Представление,
		                      |	ОбластиДанных.ОбластьДанных КАК Разделитель,
		                      |	ОтправкиОтчетностиКОбработке.ТребуетАудита КАК ТребуетАудита
		                      |ИЗ
		                      |	(ВЫБРАТЬ
		                      |		ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные,
		                      |		МАКСИМУМ(ОтправкиОтчетностиКОбработке.ТребуетАудита) КАК ТребуетАудита
		                      |	ИЗ
		                      |		РегистрСведений.ОтправкиОтчетностиКОбработке КАК ОтправкиОтчетностиКОбработке
		                      |	
		                      |	СГРУППИРОВАТЬ ПО
		                      |		ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные) КАК ОтправкиОтчетностиКОбработке
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		                      |			ОбластиДанных.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
		                      |			ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) КАК Представление
		                      |		ИЗ
		                      |			РегистрСведений.ОбластиДанных КАК ОбластиДанных,
		                      |			Константа.ПредставлениеОбластиДанных КАК ПредставлениеОбластиДанных
		                      |		ГДЕ
		                      |			ОбластиДанных.Статус = &СтатусИспользуемая
		                      |			И ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) <> """") КАК ОбластиДанных
		                      |		ПО ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные = ОбластиДанных.ОбластьДанных,
		                      |		Константа.ПредставлениеОбластиДанных КАК ПредставлениеОбластиДанных");
		
		Запрос.УстановитьПараметр("СтатусИспользуемая", Перечисления.СтатусыОбластейДанных.Используется);
		
	ИначеЕсли ПоказыватьОбластиДанных = "0" ИЛИ ПоказыватьОбластиДанных = "" Тогда // все, требующие аудита
		
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		                      |	ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные КАК Разделитель,
		                      |	ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) КАК Представление,
		                      |	ИСТИНА КАК ТребуетАудита
		                      |ИЗ
		                      |	РегистрСведений.ОтправкиОтчетностиКОбработке КАК ОтправкиОтчетностиКОбработке
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		                      |			ОбластиДанных.ОбластьДанныхВспомогательныеДанные КАК ОбластьДанных,
		                      |			ПредставлениеОбластиДанных.Значение КАК Представление
		                      |		ИЗ
		                      |			РегистрСведений.ОбластиДанных КАК ОбластиДанных,
		                      |			Константа.ПредставлениеОбластиДанных КАК ПредставлениеОбластиДанных
		                      |		ГДЕ
		                      |			ОбластиДанных.Статус = &СтатусИспользуемая
		                      |			И ПОДСТРОКА(ПредставлениеОбластиДанных.Значение, 1, 255) <> """") КАК ОбластиДанных
		                      |		ПО ОтправкиОтчетностиКОбработке.ОбластьДанныхВспомогательныеДанные = ОбластиДанных.ОбластьДанных,
		                      |		Константа.ПредставлениеОбластиДанных КАК ПредставлениеОбластиДанных
		                      |ГДЕ
		                      |	ОтправкиОтчетностиКОбработке.ТребуетАудита = ИСТИНА
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	Разделитель");
		
		Запрос.УстановитьПараметр("СтатусИспользуемая", Перечисления.СтатусыОбластейДанных.Используется);
		
	КонецЕсли;
	
	ОбластиДанных.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НовСтр = ОбластиДанных.Добавить();
		НовСтр.Представление = СокрЛП(Выборка.Представление);
		НовСтр.Разделитель = Выборка.Разделитель;
		НовСтр.СуществуютНезавершенныеОтправки = (Выборка.ТребуетАудита <> NULL);
		НовСтр.ТребуетАудита = (Выборка.ТребуетАудита = ИСТИНА);
	КонецЦикла;
	
	Если ТекСтрокаРазделитель <> Неопределено Тогда
		ТекСтроки = ОбластиДанных.НайтиСтроки(Новый Структура("Разделитель", ТекСтрокаРазделитель));
		Если ТекСтроки.Количество() > 0 Тогда
			Элементы.ОбластиДанных.ТекущаяСтрока = ТекСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
Конецпроцедуры

&НаСервере
Процедура ВойтиВОбластьДанныхНаСервере(Знач ЗначениеРазделителя)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Истина, ЗначениеРазделителя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыключитьИспользованиеРазделителя()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
		МодульРаботаВМоделиСервиса.УстановитьРазделениеСеанса(Ложь);
	КонецЕсли;
	
	РазделительТекущейОбласти = 0;
	
КонецПроцедуры

#КонецОбласти