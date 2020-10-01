
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
		ИспользоватьСтатьиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
		СвойстваПоКатегориям = Новый ФиксированноеСоответствие(ПланыВидовРасчета.Удержания.СвойстваУдержанийПоКатегориям());
		УстановитьИнформациюПоСпособуУдержания(ЭтаФорма);
		РассчитыватьРезультат = ?(Объект.Рассчитывается, 0, 1);
		УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
		УстановитьСвойстваФормыПоКатегорииУдержания(ЭтаФорма);
		БылаКатегорияУдержания = Объект.КатегорияУдержания;
		УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
		УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
		УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
		УстановитьВидимостьПрочихБазовыхДоходов();
		УстановитьДоступностьРасчетаБазы(ЭтаФорма, 
			РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБаза"),
			РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаИсполнительногоЛиста"));
		ОбновитьОтражениеВБухучетеИнфоНадпись(ЭтаФорма);
		УстановитьСтраницуБухучетНастройки(ЭтаФорма);
		ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
		СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
		СтатьяРасходовПрошлоеЗначение 		= Объект.СтатьяРасходов;
	КонецЕсли;
	
	Элементы.ПостоянныеПоказатели.ОтборСтрок = Новый ФиксированнаяСтруктура("МожетЗапрашиватьсяПриВводе", Истина);
	
	// Определяем недоступные для выбора в формуле показатели расчета.
	НедоступныеПоказатели = Новый ФиксированныйМассив(Справочники.ПоказателиРасчетаЗарплаты.ПоказателиНедоступныеДляУдержаний());
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользоватьСтатьиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
	
	// Заполнение реквизита с определяющими показателями.
	СведенияОПоказателях = ЗарплатаКадрыРасширенный.СведенияОПоказателяхРасчетаЗарплаты(
	ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.Показатели, "Показатель"));
	
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьСписокОпределяющихПоказателей(СписокОпределяющихПоказателей, ТекущийОбъект.Показатели, СведенияОПоказателях);
	
	ЕстьПоказателиУчетаВремени = РасчетЗарплатыРасширенный.ЕстьПоказателиВКоллекции(Объект.Показатели, Справочники.ПоказателиРасчетаЗарплаты.ПоказателиУчетаВремени());
	ЕстьПоказательРасчетнаяБаза = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБаза");
	ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаИсполнительногоЛиста");
	ЕстьПоказательРасчетнаяБазаСтраховыеВзносы = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаСтраховыеВзносы");
	ЕстьОперативныеПоказатели = РасчетЗарплатыРасширенный.ЕстьПоказателиВКоллекции(Объект.Показатели, Справочники.ПоказателиРасчетаЗарплаты.ОперативныеПоказатели());
	
	СвойстваПоКатегориям = Новый ФиксированноеСоответствие(ПланыВидовРасчета.Удержания.СвойстваУдержанийПоКатегориям());
	УстановитьДоступностьРасчетаБазы(ЭтаФорма, 
		РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(ТекущийОбъект.Показатели, "РасчетнаяБаза"),
		РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(ТекущийОбъект.Показатели, "РасчетнаяБазаИсполнительногоЛиста"));
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьПризнакПоказателейМожетЗапрашиватьсяПриВводе(ЭтаФорма, СведенияОПоказателях);
	
	РассчитыватьРезультат = ?(Объект.Рассчитывается, 0, 1);
	
	УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
	УстановитьСвойстваФормыПоКатегорииУдержания(ЭтаФорма);
	УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьВидимостьПрочихБазовыхДоходов();
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
	
	БылаКатегорияУдержания = ТекущийОбъект.КатегорияУдержания;
	
	ОбновитьОтражениеВБухучетеИнфоНадпись(ЭтаФорма);
	УстановитьСтраницуБухучетНастройки(ЭтаФорма);
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
	СтатьяРасходовПрошлоеЗначение 		= Объект.СтатьяРасходов;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ОценкаПроизводительностиКлиент.ЗамерВремени("ЗаписьЭлементаПланаВидовРасчетаУдержания");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Заполнение признака определяющих показателей.
	Для Каждого СтрокаПоказателей Из ТекущийОбъект.Показатели Цикл
		СтрокаПоказателей.ОпределяющийПоказатель = Ложь;
		ЭлементСписка = СписокОпределяющихПоказателей.НайтиПоЗначению(СтрокаПоказателей.Показатель);
		Если ЭлементСписка <> НеОпределено Тогда
			Если ЭлементСписка.Пометка Тогда
				СтрокаПоказателей.ОпределяющийПоказатель = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ОбновитьИнтерфейс();
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	СведенияОПоказателях = ЗарплатаКадрыРасширенный.СведенияОПоказателяхРасчетаЗарплаты(
								ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.Показатели, "Показатель"));
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьПризнакПоказателейМожетЗапрашиватьсяПриВводе(ЭтаФорма, СведенияОПоказателях);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "Запись_ПоказателиРасчетаЗарплаты" И Источник = ЭтотОбъект Тогда 
		Отбор = Новый Структура("Показатель", Параметр);
		Если Объект.Показатели.НайтиСтроки(Отбор).Количество() > 0 Тогда 
			ИзмененыПоказателиУдержания = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПорядокОпределенияРасчетногоПериодаСреднегоЗаработкаПриИзменении(Элемент)
	УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СпособВыполненияУдержанияПриИзменении(Элемент)
	
	УстановитьПризнакРассчитывается(ЭтаФорма);
	
	УстановитьИнформациюПоСпособуУдержания(ЭтаФорма);
	УстановитьИнформациюПоСпособуРасчета(ЭтаФорма);
	
	УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
	УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КатегорияУдержанияПриИзменении(Элемент)
	
	ЗаполнитьПоКатегорииУдержания();
	
	БылаКатегорияУдержания = Объект.КатегорияУдержания;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитыватьРезультатПриИзменении(Элемент)
	
	Объект.Рассчитывается = ?(РассчитыватьРезультат = 0, Истина, Ложь);

	Если Не Объект.Рассчитывается И Объект.ФормулаРасчета <> "" Тогда 
		
		Объект.ФормулаРасчета = "";
		
		Объект.Показатели.Очистить();
		СписокОпределяющихПоказателей.Очистить();
		
		ЕстьПоказателиУчетаВремени = Ложь;
		ЕстьПоказательРасчетнаяБаза = Ложь;
		ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста = Ложь;
		ЕстьПоказательРасчетнаяБазаСтраховыеВзносы = Ложь;
		ЕстьОперативныеПоказатели = Ложь;
		
		УстановитьДоступностьРасчетаБазы(ЭтаФорма, Ложь, Ложь);
		ОбновитьСтратегиюОтраженияВУчете(ЭтаФорма, Ложь);
		УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
		
	КонецЕсли;
	
	УстановитьПризнакРассчитывается(ЭтаФорма);
	УстановитьИнформациюПоСпособуРасчета(ЭтаФорма);
	
	УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
	УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчаствуетВРасчетеПервойПоловиныМесяцаПриИзменении(Элемент)
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СтратегияОтраженияВУчетеПриИзменении(Элемент)
	
	Если Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.КакЗаданоВидуРасчета") Тогда
		Объект.СтатьяФинансирования = СтатьяФинансированияПрошлоеЗначение;
		Объект.СтатьяРасходов 		= СтатьяРасходовПрошлоеЗначение;
	Иначе
		СтатьяФинансированияПрошлоеЗначение = Объект.СтатьяФинансирования;
		Объект.СтатьяФинансирования = "";
		СтатьяРасходовПрошлоеЗначение = Объект.СтатьяРасходов;
		Объект.СтатьяРасходов = "";
	КонецЕсли;
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПоЗарплатеПриИзменении(Элемент)
	ОбновитьДоступностьНастроекБухучета(ЭтаФорма);
КонецПроцедуры


#Область ОбработчикиСобытийЭлементовТаблицыФормыБазовыеВидыРасчета

&НаКлиенте
Процедура БазовыеВидыРасчетаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Для Каждого Значение Из ВыбранноеЗначение.УдаленныеВидыРасчета Цикл
		СтрокиДляУдаления = Объект.БазовыеВидыРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Значение));
		Для Каждого ТекСтрока Из СтрокиДляУдаления Цикл 
			Объект.БазовыеВидыРасчета.Удалить(ТекСтрока);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Значение Из ВыбранноеЗначение.ДобавленныеВидыРасчета Цикл
		ОбработкаВыбранногоВидаРасчета(Значение, Объект.БазовыеВидыРасчета);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрочиеБазовыеДоходы

&НаКлиенте
Процедура ПрочиеБазовыеДоходыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПрочиеБазовыеДоходыОбработкаВыбораНаСервере(ВыбранноеЗначение.ВидыВыплат, ВыбранноеЗначение.ВидыПрочихДоходов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ПодборБазовых(Команда)
	
	МассивВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ВидыРасчетаКоллекции(Объект.БазовыеВидыРасчета);
	ПараметрыФормы = Новый Структура("МассивВидовРасчета", МассивВидовРасчета);
	ОткрытьФорму("ОбщаяФорма.ПодборВидовРасчета", ПараметрыФормы, Элементы.БазовыеВидыРасчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборПрочихДоходов(Команда)
	
	ПрочиеДоходы = Новый Массив;
	Для Каждого СтрокаДохода Из Объект.ПрочиеБазовыеДоходы Цикл 
		ПрочиеДоходы.Добавить(СтрокаДохода.ВидДохода);
	КонецЦикла;
	
	ПараметрыФормы = Новый Структура("ПрочиеДоходы", ПрочиеДоходы);
	ОткрытьФорму("ПланВидовРасчета.Удержания.Форма.ПодборПрочихДоходов", ПараметрыФормы, Элементы.ПрочиеБазовыеДоходы);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФормулу(Команда)
	
	ПараметрыРедактирования = Новый Структура;
	ПараметрыРедактирования.Вставить("Формула", Объект.ФормулаРасчета);
	ПараметрыРедактирования.Вставить("НаименованиеВидаРасчета", Объект.Наименование);
	ПараметрыРедактирования.Вставить("ВидРасчета", Объект.Ссылка);
	ПараметрыРедактирования.Вставить("НедоступныеПоказатели", Новый Массив(НедоступныеПоказатели));
	
	Оповещение = Новый ОписаниеОповещения("ИзменитьФормулуЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.РедактированиеФормулыРасчетаЗарплаты", ПараметрыРедактирования, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФормулуЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт 
	
	Если ИзмененыПоказателиУдержания И Не Модифицированность Тогда 
		Прочитать();
	    ИзмененыПоказателиУдержания = Ложь;
	КонецЕсли;
	
	Если РезультатРедактирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ФормулаРасчета = РезультатРедактирования.Формула Тогда 
		Возврат;
	КонецЕсли;
	
	Объект.ФормулаРасчета = РезультатРедактирования.Формула;
	ЕстьПоказателиУчетаВремени = РезультатРедактирования.ЕстьПоказателиУчетаВремени;
	ЕстьПоказательРасчетнаяБаза = РезультатРедактирования.ЕстьПоказательРасчетнаяБаза;
	ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста = РезультатРедактирования.ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста;
	ЕстьПоказательРасчетнаяБазаСтраховыеВзносы = РезультатРедактирования.ЕстьПоказательРасчетнаяБазаСтраховыеВзносы;
	ЕстьОперативныеПоказатели = РезультатРедактирования.ЕстьОперативныеПоказатели;
	// Обновление: 
	// - табличной части
	ЗарплатаКадрыРасширенныйКлиентСервер.ОбновитьПоказателиПоФормуле(РезультатРедактирования.СведенияОПоказателях, Объект.Показатели);
	// - Списка определяющих показателей.
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьСписокОпределяющихПоказателей(СписокОпределяющихПоказателей, Объект.Показатели, РезультатРедактирования.СведенияОПоказателях);
	// Доступность настройки расчета базы.
	УстановитьДоступностьРасчетаБазы(ЭтаФорма, РезультатРедактирования.ЕстьПоказательРасчетнаяБаза, РезультатРедактирования.ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста);
	// Обновление стратегии отражения.
	ОбновитьСтратегиюОтраженияВУчете(ЭтаФорма, РезультатРедактирования.ЕстьПоказательРасчетнаяБаза);
	// Доступность участия в первой половине месяца.
	ЕстьПоказателиУчетаВремени = РезультатРедактирования.ЕстьПоказателиУчетаВремени;
	// Признак запрашивается по умолчанию.
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьОтметкуЗапрашиватьПриВводе(РезультатРедактирования.ЗапрашиваемыеПоказатели, Объект.Показатели);
	// Признак для отбора показателей, которые могут быть запрашиваемыми.
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьПризнакПоказателейМожетЗапрашиватьсяПриВводе(ЭтаФорма, РезультатРедактирования.СведенияОПоказателях);
	// Настройка периода среднего заработка.
	УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
	// Признак УчаствуетВРасчетеПервойПоловиныМесяца.
	УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
	УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваФормыПоКатегорииУдержания(Форма)
	
	Элементы = Форма.Элементы;
	
	УстановитьПризнакРассчитывается(Форма);
	
	УстановитьИнформациюПоСпособуУдержания(Форма);
	УстановитьИнформациюПоСпособуРасчета(Форма);
	
	// Отображение вида отпуска
	Если Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска")
		Или Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска") 
		Или Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ДенежноеДовольствиеУдержаниеЗаНеотработанныеДниОтпуска") Тогда
		Элементы.НастройкиПоКатегорииСтраницы.ТекущаяСтраница = Элементы.НеотработанныеДниОтпускаСтраница;
	Иначе
		Элементы.НастройкиПоКатегорииСтраницы.ТекущаяСтраница = Элементы.СпособВыполненияСтраница;
	КонецЕсли;
	
	// Те свойства, которые были недоступными по предыдущей категории сначала сделаем доступными.
	СвойстваУдержания = Форма.СвойстваПоКатегориям.Получить(Форма.БылаКатегорияУдержания);
	НедоступныеСвойства = СвойстваУдержания.НедоступныеСвойства;
	Для Каждого ИмяСвойства Из НедоступныеСвойства Цикл
		// Устанавливаем доступность
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы, ИмяСвойства, "Доступность", Истина);
	КонецЦикла;
	
	СвойстваУдержания = Форма.СвойстваПоКатегориям.Получить(Форма.Объект.КатегорияУдержания);
	НедоступныеСвойства = СвойстваУдержания.НедоступныеСвойства;
	Для Каждого ИмяСвойства Из НедоступныеСвойства Цикл
		// Устанавливаем доступность
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Форма.Элементы, ИмяСвойства, "Доступность", Ложь);
	КонецЦикла;
	
	// Для отдельных категорий требуется уточнить вид операции по зарплате.
	Элементы.ВидОперацииПоЗарплате.СписокВыбора.Очистить();
	Элементы.ВидОперацииПоЗарплате.РежимВыбораИзСписка = Ложь;
	Если Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям") Тогда
		Элементы.ВидОперацииСтраницы.ТекущаяСтраница = Элементы.ВидОперацииВыбираетсяСтраница;
		Элементы.ВидОперацииПоЗарплате.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.ВозмещениеУщерба"));
		Элементы.ВидОперацииПоЗарплате.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.УдержаниеПоПрочимОперациямСРаботниками"));
		Элементы.ВидОперацииПоЗарплате.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.УдержаниеНеизрасходованныхПодотчетныхСумм"));
		Элементы.ВидОперацииПоЗарплате.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПоЗарплате.ВозвратИзлишнеВыплаченныхСуммВследствиеСчетныхОшибок"));
		Элементы.ВидОперацииПоЗарплате.РежимВыбораИзСписка = Истина;
	Иначе
		Элементы.ВидОперацииСтраницы.ТекущаяСтраница = Элементы.ВидОперацииНеВыбираетсяСтраница;
	КонецЕсли;
	
	// при изменении категории могла изменится СтратегияОтраженияВУчете
	ОбновитьОтражениеВБухучетеИнфоНадпись(Форма);
	УстановитьСтраницуБухучетНастройки(Форма);
	ОбновитьДоступностьНастроекБухучета(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоКатегорииУдержания()
	
	Объект.Показатели.Очистить();
	
	СвойстваУдержания = СвойстваПоКатегориям.Получить(Объект.КатегорияУдержания);
	
	ЗаполнитьЗначенияСвойств(Объект, СвойстваУдержания);
	РассчитыватьРезультат = ?(Объект.Рассчитывается, 0, 1);
	
	ЗаполнитьПоКатегорииУдержанияНаСервере();
	
	УстановитьСвойстваФормыПоКатегорииУдержания(ЭтаФорма);
	УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРасчетаБазы(Форма, ЕстьПоказательРасчетнаяБаза, ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста)
	
	Форма.Элементы.РасчетБазы.Доступность = ЕстьПоказательРасчетнаяБаза Или ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоКатегорииУдержанияНаСервере()
	
	ЗаполнитьПоказателиПредопределенногоСпособаРасчета();
	ЗаполнитьБазовыеНачисления();
	ЗаполнитьПрочиеБазовыеДоходы();
	УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьИнформационнуюНадписьЕжемесячногоУдержания(ЭтаФорма);
	УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(ЭтаФорма);
	УстановитьВидимостьПрочихБазовыхДоходов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоказателиПредопределенногоСпособаРасчета()
	
	ЗарплатаКадрыРасширенный.ЗаполнитьПоказателиПредопределенногоСпособаРасчета(Объект.СпособРасчета, Объект.Показатели);
	
	ЕстьПоказателиУчетаВремени = РасчетЗарплатыРасширенный.ЕстьПоказателиВКоллекции(Объект.Показатели, Справочники.ПоказателиРасчетаЗарплаты.ПоказателиУчетаВремени());
	ЕстьПоказательРасчетнаяБаза = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБаза");
	ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаИсполнительногоЛиста");
	ЕстьПоказательРасчетнаяБазаСтраховыеВзносы = РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаСтраховыеВзносы");
	ЕстьОперативныеПоказатели = РасчетЗарплатыРасширенный.ЕстьПоказателиВКоллекции(Объект.Показатели, Справочники.ПоказателиРасчетаЗарплаты.ОперативныеПоказатели());
	
	УстановитьДоступностьРасчетаБазы(ЭтаФорма, ЕстьПоказательРасчетнаяБаза, ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста);
	ОбновитьСтратегиюОтраженияВУчете(ЭтаФорма, ЕстьПоказательРасчетнаяБаза);
	УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБазовыеНачисления()
	
	Объект.БазовыеВидыРасчета.Очистить();
	
	Если Не РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБаза") 
		И Не РасчетЗарплатыРасширенный.ЕстьПоказательВКоллекции(Объект.Показатели, "РасчетнаяБазаИсполнительногоЛиста") Тогда 
		Возврат;
	КонецЕсли;	
	
	СвойстваУдержания = СвойстваПоКатегориям.Получить(Объект.КатегорияУдержания);
	
	Если СвойстваУдержания.ОтборБазовых <> Неопределено Тогда 
		
		ОтборБазовых = ОбщегоНазначения.СкопироватьРекурсивно(СвойстваУдержания.ОтборБазовых);
		Категория = ОтборБазовых.КатегорияНачисления;
		ОтборБазовых.Удалить("КатегорияНачисления");
		БазовыеНачисления = ПланыВидовРасчета.Начисления.НачисленияПоКатегории(Категория, ОтборБазовых);
		Для Каждого БазовоеНачисление Из БазовыеНачисления Цикл
			Если Не ЗначениеЗаполнено(Объект.Ссылка) Или БазовоеНачисление.БазовыеВидыРасчета.Найти(Объект.Ссылка, "ВидРасчета") = Неопределено Тогда
				Если Объект.БазовыеВидыРасчета.НайтиСтроки(Новый Структура("ВидРасчета", БазовоеНачисление)).Количество() = 0 Тогда
					Объект.БазовыеВидыРасчета.Добавить().ВидРасчета = БазовоеНачисление;
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрочиеБазовыеДоходы()
	
	СвойстваУдержания = СвойстваПоКатегориям.Получить(Объект.КатегорияУдержания);
	Если СвойстваУдержания.ДополнениеРасчетнойБазы Тогда 
		ПланыВидовРасчета.Удержания.ЗаполнитьПрочиеБазовыеДоходыУдержания(Объект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнформациюПоСпособуУдержания(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.СпособВыполненияУдержания = ПредопределенноеЗначение("Перечисление.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете") Тогда
		Элементы.НастройкиПоСпособуВыполненияСтраницы.ТекущаяСтраница = Элементы.ЕжемесячноПриОкончательномРасчетеСтраница;
	ИначеЕсли Объект.СпособВыполненияУдержания = ПредопределенноеЗначение("Перечисление.СпособыВыполненияУдержаний.ПоЗначениюПоказателяПриОкончательномРасчете") Тогда
		Элементы.НастройкиПоСпособуВыполненияСтраницы.ТекущаяСтраница = Элементы.ПоЗначениюПоказателяПриОкончательномРасчетеСтраница;
	ИначеЕсли Объект.СпособВыполненияУдержания = ПредопределенноеЗначение("Перечисление.СпособыВыполненияУдержаний.ПустаяСсылка") Тогда
		Элементы.НастройкиПоСпособуВыполненияСтраницы.ТекущаяСтраница = Элементы.СпособНеЗаполненСтраница;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнформациюПоСпособуРасчета(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ПостоянныеПоказателиСтраницы.ТекущаяСтраница = Элементы.ПостоянныеПоказателиПредопределенныйСпособРасчета;
	Если Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.ПроизвольнаяФормула") Тогда
		Элементы.СпособРасчетаСтраницы.ТекущаяСтраница = Элементы.ПроизвольнаяФормулаСтраница;
		Если Объект.Рассчитывается Тогда 
			Элементы.ПостоянныеПоказателиСтраницы.ТекущаяСтраница = Элементы.ПостоянныеПоказателиСтраница;
		КонецЕсли;
	ИначеЕсли Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.ИсполнительныйЛист") Тогда
		Элементы.СпособРасчетаСтраницы.ТекущаяСтраница = Элементы.ИсполнительныйЛистСтраница;
	ИначеЕсли Объект.СпособРасчета = ПредопределенноеЗначение("Перечисление.СпособыРасчетаУдержаний.ВознаграждениеПлатежногоАгента") Тогда
		Элементы.СпособРасчетаСтраницы.ТекущаяСтраница = Элементы.ВознаграждениеАгентаСтраница;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбранногоВидаРасчета(Значение, ТаблицаВидовРасчета)
	
	Если ТаблицаВидовРасчета.НайтиСтроки(Новый Структура("ВидРасчета", Значение)).Количество() = 0 Тогда
		ТаблицаВидовРасчета.Добавить().ВидРасчета = Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваПериодаРасчетаСреднегоЗаработка(Форма)
	
	// Определяем нужна ли сама настройка (есть ли показатель среднего заработка).
	ЕстьПоказателиСреднегоЗаработка = Ложь;
	ПоказателиСреднегоЗаработка = УчетСреднегоЗаработкаКлиентСервер.ПоказателиРасчетаСреднегоЗаработка();
	СреднийЗаработокОбщий = ПоказателиСреднегоЗаработка["СреднийЗаработокОбщий"];
	Для Каждого СтрокаПоказателя Из Форма.Объект.Показатели Цикл
		Если СтрокаПоказателя.Показатель = СреднийЗаработокОбщий Тогда
			ЕстьПоказателиСреднегоЗаработка = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьПоказателиСреднегоЗаработка Тогда
		Форма.Элементы.НастройкаПериодаСреднегоЗаработкаСтраницы.ТекущаяСтраница = Форма.Элементы.ПериодНастраиваетсяСтраница;
	Иначе	
		Форма.Элементы.НастройкаПериодаСреднегоЗаработкаСтраницы.ТекущаяСтраница = Форма.Элементы.ПериодНеНастраиваетсяСтраница;
	КонецЕсли;
	
	Если Не ЕстьПоказателиСреднегоЗаработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Форма.Объект.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка) Тогда
		Форма.Объект.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка = 
			ПредопределенноеЗначение("Перечисление.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка.ПоТрудовомуЗаконодательству");
	КонецЕсли;
	
	// Определяем доступность ввода произвольного периода.
	ДоступностьВвода = Форма.Объект.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка = 
			ПредопределенноеЗначение("Перечисление.ПорядокОпределенияРасчетногоПериодаСреднегоЗаработка.ПоКолдоговору");
			
	Форма.Элементы.КоличествоМесяцевРасчетаСреднегоЗаработка.Доступность = ДоступностьВвода;
	Форма.Элементы.КоличествоМесяцевРасчетаСреднегоЗаработка.АвтоОтметкаНезаполненного = ДоступностьВвода;
	Форма.Элементы.КоличествоМесяцевРасчетаСреднегоЗаработка.ОтметкаНезаполненного = Не ЗначениеЗаполнено(Форма.Объект.КоличествоМесяцевРасчетаСреднегоЗаработка);
	
	Если Не Форма.Элементы.КоличествоМесяцевРасчетаСреднегоЗаработка.Доступность Тогда
		Форма.Объект.КоличествоМесяцевРасчетаСреднегоЗаработка = 12;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакРассчитывается(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	РедактироватьПризнакРассчитывается = (Объект.СпособВыполненияУдержания = ПредопределенноеЗначение("Перечисление.СпособыВыполненияУдержаний.ПоОтдельномуДокументуДоОкончательногоРасчета")
		Или Объект.СпособВыполненияУдержания = ПредопределенноеЗначение("Перечисление.СпособыВыполненияУдержаний.ЕжемесячноПриОкончательномРасчете"));
	
	Если Не РедактироватьПризнакРассчитывается Тогда 
		Объект.Рассчитывается = Истина;
		Форма.РассчитыватьРезультат = 0;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "РассчитыватьРезультат", "Доступность", РедактироватьПризнакРассчитывается);
	
	Элементы.СтраницыРасчетУдержания.ТекущаяСтраница = ?(Объект.Рассчитывается, 
		Элементы.СтраницаРезультатРассчитывается, Элементы.СтраницаРезультатВводитсяВручную);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПризнакУчаствуетВРасчетеПервойПоловиныМесяца(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если УдерживаетсяВЦеломЗаМесяц(Форма) Тогда
		Объект.УчаствуетВРасчетеПервойПоловиныМесяца = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьИнформационнуюНадписьЕжемесячногоУдержания(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Объект.УчаствуетВРасчетеПервойПоловиныМесяца Тогда
		Элементы.ДекорацияЕжемесячно.Заголовок = НСтр("ru = 'Удержание выполняется ежемесячно при окончательном расчете 
                                                       |и в межрасчетный период'");
	Иначе
		Элементы.ДекорацияЕжемесячно.Заголовок = НСтр("ru = 'Удержание выполняется ежемесячно при окончательном расчете'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтображениеСвойстваУчаствуетВРасчетеПервойПоловиныМесяца(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	СвойствоОтображается = Объект.КатегорияУдержания <> ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента");
	Элементы.УдерживаетсяПриРасчетеПервойПоловиныМесяцаСтраницы.ТекущаяСтраница = ?(СвойствоОтображается, 
		Элементы.УдерживаетсяПриРасчетеПервойПоловиныМесяцаОтображаетсяСтраница, Элементы.УдерживаетсяПриРасчетеПервойПоловиныМесяцаНеОтображаетсяСтраница);
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция УдерживаетсяВЦеломЗаМесяц(Форма)
	Возврат РасчетЗарплатыРасширенныйКлиентСервер.УдержаниеВыполняетсяВЦеломЗаМесяц(
		Форма.Объект, 
		Форма.ЕстьПоказательРасчетнаяБаза, 
		Форма.ЕстьОперативныеПоказатели, 
		Форма.ЕстьПоказательРасчетнаяБазаСтраховыеВзносы, 
		Форма.ЕстьПоказательРасчетнаяБазаИсполнительногоЛиста);
КонецФункции  

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьОтражениеВБухучетеИнфоНадпись(Форма)
	
	Если Форма.РаботаВБюджетномУчреждении Тогда
		Если Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента") Тогда
			Форма.ОтражениеВБухучетеИнфоНадпись = НСтр("ru = 'Статья финансирования и статья расходов определяются по удержанию, с которого исчислено вознаграждение.'");
		Иначе
			Форма.ОтражениеВБухучетеИнфоНадпись = НСтр("ru = 'Статья финансирования и статья расходов определяются по базовым начислениям.'");
		КонецЕсли;
	ИначеЕсли Форма.ИспользоватьСтатьиФинансирования Тогда
		Если Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента") Тогда
			Форма.ОтражениеВБухучетеИнфоНадпись = НСтр("ru = 'Статья финансирования определяется по удержанию, с которого исчислено вознаграждение.'");
		Иначе
			Форма.ОтражениеВБухучетеИнфоНадпись = НСтр("ru = 'Статья финансирования определяется по базовым начислениям.'");
		КонецЕсли;
	Иначе
		Форма.ОтражениеВБухучетеИнфоНадпись = "";
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция УстановитьСтраницуБухучетНастройки(Форма)
	
	Если Форма.Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам") Тогда
		Форма.Элементы.БухучетСтраницыНастройки.ТекущаяСтраница = Форма.Элементы.БухучетСтраницаОписание;
	Иначе
		Форма.Элементы.БухучетСтраницыНастройки.ТекущаяСтраница = Форма.Элементы.БухучетСтраницаВыборСтратегии;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьДоступностьНастроекБухучета(Форма)
	
	Элементы = Форма.Элементы;
	
	НастройкаДоступна = Форма.Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.КакЗаданоВидуРасчета");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяФинансирования));
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "Доступность", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "АвтоОтметкаНезаполненного", НастройкаДоступна);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "ОтметкаНезаполненного", НастройкаДоступна И Не ЗначениеЗаполнено(Форма.Объект.СтатьяРасходов));
	
	// Признак округления показываем, когда стратегия не КакЗаданоВидуРасчета.
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОкруглятьРезультатРаспределения", "Видимость", Не НастройкаДоступна);
	
	МожетЯвляетсяОснованием = ОтражениеЗарплатыВБухучетеКлиентСерверРасширенный.УдержаниеМожетЯвляетсяОснованиемОформленияКассовогоЧека(Форма.Объект.КатегорияУдержания, Форма.Объект.ВидОперацииПоЗарплате);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ЯвляетсяОснованиемОформленияКассовогоЧека", "Видимость", МожетЯвляетсяОснованием);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСтратегиюОтраженияВУчете(Форма, ЕстьПоказательРасчетнаяБаза)

	Если ЕстьПоказательРасчетнаяБаза 
			Или Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ВознаграждениеПлатежногоАгента")
			Или Форма.Объект.КатегорияУдержания = ПредопределенноеЗначение("Перечисление.КатегорииУдержаний.ИсполнительныйЛист") Тогда
		Форма.Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам");
	ИначеЕсли Форма.Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам") Тогда
		Форма.Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоФактическимНачислениям");
	КонецЕсли;
	
	УстановитьСтраницуБухучетНастройки(Форма);
	ОбновитьДоступностьНастроекБухучета(Форма);

КонецПроцедуры

&НаСервере
Процедура ПрочиеБазовыеДоходыОбработкаВыбораНаСервере(ВидыВыплат, ВидыПрочихДоходов)
	
	Объект.ПрочиеБазовыеДоходы.Очистить();
	
	Для Каждого ВидВыплаты Из ВидыВыплат Цикл 
		НоваяСтрока = Объект.ПрочиеБазовыеДоходы.Добавить();
		НоваяСтрока.ВидДохода = ВидВыплаты;
	КонецЦикла;
	
	Для Каждого ВидДохода Из ВидыПрочихДоходов Цикл 
		НоваяСтрока = Объект.ПрочиеБазовыеДоходы.Добавить();
		НоваяСтрока.ВидДохода = ВидДохода;
	КонецЦикла;
	
	Объект.ПрочиеБазовыеДоходы.Сортировать("ВидДохода");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПрочихБазовыхДоходов()
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПрочиеБазовыеДоходыГруппа",
		"Видимость", Объект.КатегорияУдержания = Перечисления.КатегорииУдержаний.ИсполнительныйЛист
		И (ПолучитьФункциональнуюОпцию("ИспользоватьВыплатыБывшимСотрудникам") Или ПолучитьФункциональнуюОпцию("ИспользоватьРегистрациюПрочихДоходов")));
	
КонецПроцедуры

#КонецОбласти
