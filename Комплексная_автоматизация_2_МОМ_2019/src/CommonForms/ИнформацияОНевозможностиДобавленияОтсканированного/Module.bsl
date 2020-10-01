#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИдентификаторСтрокиПозиционирования = - 1;
	ПоказатьДерево                      = Ложь;
	СкрытьБезПроблем                    = Истина;
	Штрихкод                            = Параметры.Штрихкод;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресДереваУпаковок) Тогда
		
		ИнформацияВДереве = Истина;
		
		ДеревоУпаковки = ПолучитьИзВременногоХранилища(Параметры.АдресДереваУпаковок);
		
		ПоказатьДерево = ДеревоУпаковки.Строки.Количество() > 1;
		
		Для Каждого СтрокаДерева Из ДеревоУпаковки.Строки Цикл
			
			Если СтрокаДерева.Строки.Количество() > 0 Тогда
				ПоказатьДерево = Истина;
			КонецЕсли;
			
			ДобавитьСтрокуВДерево(ДеревоОтсканированнойУпаковки.ПолучитьЭлементы(), СтрокаДерева);
			
		КонецЦикла;
		
	Иначе
		
		ИнформацияВДереве = Ложь;
		ЭтоУпаковка       = Ложь; 
		
	КонецЕсли;
	
	Если ПоказатьДерево Тогда
		
		ПоказатьИнформациюОПроблемахСУпаковкой();
		
	Иначе
		
		Если ЗначениеЗаполнено(Параметры.ТекстОшибкиФорматированнаяСтрока)
			Или СтрДлина(Параметры.ТекстОшибки) <= 200 Тогда
			ПоказатьИнформациюОПроблемахСМаркируемойПродукцией(ИнформацияВДереве);
		Иначе
			ПоказатьТекстНеизвестнойОшибки();
		КонецЕсли;
		
	КонецЕсли;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	СброситьРазмерыИПоложениеОкна();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОшибкаДобавленияМаркируемойПродукцииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "СкопироватьШтриховойКодВБуферОбмена" Тогда
		
		ИнтеграцияИСКлиент.СкопироватьШтрихКодВБуферОбмена(Элементы.БуферОбмена, Штрихкод);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОтсканированнойУпаковки

&НаКлиенте
Процедура ДеревоОтсканированнойУпаковкиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоОтсканированнойУпаковки.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено 
		И ТекущиеДанные.ЕстьОшибки Тогда
		
		ТекстОшибки = ТекущиеДанные.ТекстОшибки;
		
	Иначе
		
		ТекстОшибки = "";
		
	КонецЕсли;
	
	Элементы.ДекорацияПредставлениеОшибкиТекущейСтроки.Заголовок = ТекстОшибки;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СкрытьСтрокиБезПроблем(Команда)
	
	СкрытьБезПроблем = Не СкрытьБезПроблем;
	Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
	
	Если СкрытьБезПроблем Тогда
		СкрытьСтрокиБезПроблемНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьСтрокуВДерево(КоллекцияСтрокПриемника, СтрокаИсточник)

	НоваяСтрока = КоллекцияСтрокПриемника.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсточник);
	
	Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
		Или Не ЗначениеЗаполнено(НоваяСтрока.ТипУпаковки) Тогда
		КоличествоСтрокСМаркируемойПродукцией = КоличествоСтрокСМаркируемойПродукцией + 1;
	КонецЕсли;
	
	Если НоваяСтрока.ЕстьОшибки Тогда
		
		Если НоваяСтрока.ТипУпаковки = Перечисления.ТипыУпаковок.МаркированныйТовар
			Или Не ЗначениеЗаполнено(НоваяСтрока.ТипУпаковки) Тогда
			КоличествоСтрокСПроблемами = КоличествоСтрокСПроблемами + 1;
		КонецЕсли;
		
		СтрокаРодитель = НоваяСтрока.ПолучитьРодителя();
		
		Если СтрокаРодитель <> Неопределено Тогда
			
			ИдентификаторСтрокиРодителя = СтрокаРодитель.ПолучитьИдентификатор();
			Если ИдентификаторыРаскрываемыхСтрок.НайтиПоЗначению(ИдентификаторСтрокиРодителя) = Неопределено Тогда
				ИдентификаторыРаскрываемыхСтрок.Добавить(ИдентификаторСтрокиРодителя);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ИдентификаторСтрокиПозиционирования = - 1 Тогда
			ИдентификаторСтрокиПозиционирования = НоваяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ПодчиненнаяСтрока Из СтрокаИсточник.Строки Цикл
		
		ДобавитьСтрокуВДерево(НоваяСтрока.ПолучитьЭлементы(), ПодчиненнаяСтрока);
		
		Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(ПодчиненнаяСтрока.ТипУпаковки) Тогда
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + 1;
			
		Иначе
			
			НоваяСтрока.СодержитПродукции = НоваяСтрока.СодержитПродукции + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Для Каждого ПодчиненнаяСтрока Из НоваяСтрока.ПолучитьЭлементы() Цикл
			
			НоваяСтрока.СодержитУпаковок = НоваяСтрока.СодержитУпаковок + ПодчиненнаяСтрока.СодержитУпаковок;
			НоваяСтрока.СодержитПродукции  = НоваяСтрока.СодержитПродукции + ПодчиненнаяСтрока.СодержитПродукции;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ИнтеграцияИСКлиентСервер.ЭтоУпаковка(НоваяСтрока.ТипУпаковки) Тогда
		
		Если НоваяСтрока.СодержитУпаковок > 0 
			И НоваяСтрока.СодержитПродукции > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Упаковок - %1, Пачек - %2.'"),
				НоваяСтрока.СодержитУпаковок,
				НоваяСтрока.СодержитПродукции);
			
		ИначеЕсли НоваяСтрока.СодержитУпаковок > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Упаковок - %1.'"),
				НоваяСтрока.СодержитУпаковок);
			
		ИначеЕсли НоваяСтрока.СодержитПродукции > 0 Тогда
			
			НоваяСтрока.ПредставлениеНоменклатуры = СтрШаблон(
				НСтр("ru = 'Пачек - %1.'"),
				НоваяСтрока.СодержитПродукции);
			
		Иначе
			
			НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<пустая упаковка>'");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НоваяСтрока.Номенклатура) Тогда
		НоваяСтрока.ПредставлениеНоменклатуры = НоваяСтрока.Номенклатура;
	Иначе
		НоваяСтрока.ПредставлениеНоменклатуры = НСтр("ru = '<не определена>'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
#Область ЕстьОшибки
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиТекстОшибки.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ЕстьОшибки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);
	
#КонецОбласти
	
#Область Отбор
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковки.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СкрытьБезПроблем");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.НеСоответствуетОтбору");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона" , ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти
	
#Область Представление
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДеревоОтсканированнойУпаковкиПредставление.Имя);
	
	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.ТипУпаковки");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыУпаковок.МаркированныйТовар;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоОтсканированнойУпаковки.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура СкрытьСтрокиБезПроблемНаСервере()
	
	Если СкрытьБезПроблем Тогда
	
		СтрокиДерева = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			
			СоответствуетОтбору = Ложь;
			СкрытьБезОшибокВСтрокеДерева(СтрокаДерева, СоответствуетОтбору);
			
		КонецЦикла;
		
		Элементы.ДеревоОтсканированнойУпаковкиСкрытьСтрокиБезПроблем.Пометка = СкрытьБезПроблем;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьБезОшибокВСтрокеДерева(Знач СтрокаДерева, СоответствуетОтбору)
	
	Если ТипЗнч(СтрокаДерева) = Тип("Число") Тогда
		СтрокаДерева = ДеревоОтсканированнойУпаковки.НайтиПоИдентификатору(СтрокаДерева);
	КонецЕсли;
	
	ПодчиненныеСтроки = СтрокаДерева.ПолучитьЭлементы();
	
	ТекущаяСтрокаСоответствуетОтбору = Ложь;
	
	Для Каждого ПодчиненнаяСтрока Из ПодчиненныеСтроки Цикл
		
		СоответствуетОтбору = Ложь;
		
		СкрытьБезОшибокВСтрокеДерева(ПодчиненнаяСтрока, СоответствуетОтбору);
		
		Если СоответствуетОтбору Тогда
			ТекущаяСтрокаСоответствуетОтбору = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ТекущаяСтрокаСоответствуетОтбору Тогда
		
		ТекущаяСтрокаСоответствуетОтбору = СтрокаДерева.ЕстьОшибки;
		
	КонецЕсли;
	
	СоответствуетОтбору = ТекущаяСтрокаСоответствуетОтбору;
	СтрокаДерева.НеСоответствуетОтбору = Не СоответствуетОтбору;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого ЭлементСписка Из ИдентификаторыРаскрываемыхСтрок Цикл
		
		Элементы.ДеревоОтсканированнойУпаковки.Развернуть(ЭлементСписка.Значение, Ложь);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформациюОПроблемах();
	
	Элементы.ДекорацияИнформацияОПроблемах.Заголовок = СтрШаблон(
		НСтр("ru = 'Добавление отсканированной упаковки невозможно.
		           |Невозможно добавить единиц Маркируемой продукции %1 из %2.'"),
		КоличествоСтрокСПроблемами, КоличествоСтрокСМаркируемойПродукцией);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСМаркируемойПродукцией(ИнформацияВДереве)
	
	ЭтотОбъект.Ширина = 50;
	
	Элементы.СтраницаУпаковка.Видимость             = Ложь;
	Элементы.СтраницаМаркируемаяПродукция.Видимость = Истина;
	Элементы.СтраницаНеизвестнаяОшибки.Видимость    = Ложь;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаМаркируемаяПродукция;
	
	// Видимость кнопок командой панели
	Элементы.ЗакрытьМаркируемаяПродукция.Видимость         = Истина;
	Элементы.ЗакрытьМаркируемаяПродукция.КнопкаПоУмолчанию = Истина;
	
	Если ИнформацияВДереве Тогда
		
		СтрокиВерхнегоУровня = ДеревоОтсканированнойУпаковки.ПолучитьЭлементы();
		
		Если СтрокиВерхнегоУровня.Количество() = 0 Тогда
			
			Элементы.ДекорацияОшибкаДобавленияМаркируемойПродукции.Заголовок = НСтр("ru = 'Нет информации по отсканированному штрихкоду'");
			Возврат;
			
		Иначе
			
			ДанныеМаркируемойПродукции = СтрокиВерхнегоУровня[0];
			ТекстОшибки = ДанныеМаркируемойПродукции.ТекстОшибки;
			
		КонецЕсли;
		
	Иначе
		
		Если ЗначениеЗаполнено(Параметры.ТекстОшибкиФорматированнаяСтрока) Тогда
			ТекстОшибки = Параметры.ТекстОшибкиФорматированнаяСтрока;
		Иначе
			ТекстОшибки = Параметры.ТекстОшибки;
		КонецЕсли;
		
	КонецЕсли;
	
	Префикс = НСтр("ru = 'Невозможно обработать отсканированный штрихкод'");
	
	СтрокаШтриховойКод = Новый ФорматированнаяСтрока(
		ШтрихкодированиеИСКлиентСервер.ПредставлениеШтрихкода(Штрихкод),
		Новый Шрифт(,,,,Истина),
		ЦветаСтиля.ЦветГиперссылкиГосИС,,
		"СкопироватьШтриховойКодВБуферОбмена");
	
	ТекстСОшибкой = НСтр("ru = 'по причине:'") + Символы.ПС + ТекстОшибки;
	
	Элементы.ДекорацияОшибкаДобавленияМаркируемойПродукции.Заголовок =
		Новый ФорматированнаяСтрока(Префикс, " ", СтрокаШтриховойКод, " ", ТекстСОшибкой);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекстНеизвестнойОшибки()
	
	ЭтотОбъект.Ширина = 50;
	
	Элементы.СтраницаУпаковка.Видимость             = Ложь;
	Элементы.СтраницаМаркируемаяПродукция.Видимость = Ложь;
	Элементы.СтраницаНеизвестнаяОшибки.Видимость    = Истина;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаНеизвестнаяОшибки;
	
	// Видимость кнопок командой панели
	Элементы.ЗакрытьМаркируемаяПродукция.Видимость         = Истина;
	Элементы.ЗакрытьМаркируемаяПродукция.КнопкаПоУмолчанию = Истина;
	
	ТекстНеизвестнойОшибки = Параметры.ТекстОшибки;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьИнформациюОПроблемахСУпаковкой()
	
	Элементы.СтраницаУпаковка.Видимость             = Истина;
	Элементы.СтраницаМаркируемаяПродукция.Видимость = Ложь;
	Элементы.СтраницаНеизвестнаяОшибки.Видимость    = Ложь;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаУпаковка;
	
	// Видимость кнопок командой панели
	Элементы.ЗакрытьМаркируемаяПродукция.Видимость = Ложь;
	
	ЭтотОбъект.Ширина = 200;
	ЭтотОбъект.Высота = 40;
	
	СкрытьСтрокиБезПроблемНаСервере();
	СформироватьИнформациюОПроблемах();
	
	Элементы.ДеревоОтсканированнойУпаковки.ТекущаяСтрока = ИдентификаторСтрокиПозиционирования;
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.ИнформацияОНевозможностиДобавленияОтсканированного", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти