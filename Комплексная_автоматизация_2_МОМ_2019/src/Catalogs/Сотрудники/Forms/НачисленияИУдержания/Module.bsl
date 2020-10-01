#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда 
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
	    Модуль.ДоработатьЗапросСпискаНачислений(ЭтотОбъект, "НачислениеЗарплаты", "ЖурналДокументовНачислениеЗарплаты");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		НачислениеЗарплаты, "ПредставлениеТипаДоначислениеПерерасчет", Документы.НачислениеЗарплаты.ПредставлениеТипаДоначислениеПерерасчет());
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка( 
		НачислениеЗарплаты, "ПредставлениеТипаРасчетЗарплаты", Метаданные.Документы.НачислениеЗарплаты.Синоним);
		
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Заголовок,СотрудникСсылка");
	
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СотрудникСсылка, "ТекущаяОрганизация,ФизическоеЛицо,ДатаУвольнения", ТекущаяДатаСеанса());
	
	Если КадровыеДанные.Количество() > 0 Тогда
		ТекущаяОрганизация = КадровыеДанные[0].ТекущаяОрганизация;
		ФизическоеЛицоСсылка = КадровыеДанные[0].ФизическоеЛицо;
		ДатаУвольнения = КадровыеДанные[0].ДатаУвольнения;
	КонецЕсли; 
	
	ДоступноНачислениеЗарплаты = ПравоДоступа("Просмотр", Метаданные.ЖурналыДокументов.НачислениеЗарплаты);
	
	Если ДоступноНачислениеЗарплаты Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЭтаФорма.НачислениеЗарплаты.Отбор, "Организация", ТекущаяОрганизация);
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ЭтаФорма.НачислениеЗарплаты, "ФизическоеЛицо", ФизическоеЛицоСсылка, Истина);
	КонецЕсли;
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыРасчета();
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Начисления", 3);
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Удержания", 3);
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыЛьгот();
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Начисления", 3);
	
	ПрочитатьДанные();
	
	Если ДоступноНачислениеЗарплаты Тогда
		ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "НачислениеЗарплаты", , , , "Организация");
	КонецЕсли; 
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.УстановитьВидимостьГруппыЛьготы(Элементы, "ЛьготыГруппа");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ДокументыНачисленийГруппа",
		"Видимость",
		ДоступноНачислениеЗарплаты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СотрудникиКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "ИзменениеДанныхМестаРаботы" 
		ИЛИ ИмяСобытия = "ДокументНачальнаяШтатнаяРасстановкаПослеЗаписи" Тогда
		
		ПрочитатьДанные();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачисленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьРегистратор("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьРегистратор("Удержания");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьРегистратор("Показатели");
	
КонецПроцедуры

&НаКлиенте
Процедура ЛьготыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьРегистратор("Льготы");
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыНачислениеЗарплаты

&НаКлиенте
Процедура НачислениеЗарплатыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура("Сотрудник", СотрудникСсылка);
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		ЗначенияЗаполнения.Вставить("Организация", ТекущаяОрганизация);
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	
	Отказ = Истина;
	ОткрытьФорму(ПолноеИмяОбъектаМетаданныхПоТипу(Параметр) + ".ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаСервере
Процедура НачислениеЗарплатыПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	Если ДоступноНачислениеЗарплаты Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, Настройки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачислениеЗарплатыПриОбновленииСоставаПользовательскихНастроекНаСервере(СтандартнаяОбработка)
	
	Если ДоступноНачислениеЗарплаты Тогда
		ЗарплатаКадры.ПроверитьПользовательскиеНастройкиДинамическогоСписка(ЭтотОбъект, , СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьФОТ(Команда)
	
	ПоказыватьФОТ = НЕ Элементы.ПоказатьФОТ.Пометка;
	Элементы.ПоказатьФОТ.Пометка = ПоказыватьФОТ;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистраторНачислений(Команда)
	
	ПоказатьРегистратор("Начисления");
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияОплатыТруда(Команда)

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СотрудникСсылка", СотрудникСсылка);
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаИсторииИзмененияОплатыТруда", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ИсторияИзмененияУдержаний(Команда)

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Организация", ТекущаяОрганизация);
	ПараметрыОткрытия.Вставить("ФизическоеЛицо", ФизическоеЛицоСсылка);
	
	ОткрытьФорму("Справочник.Сотрудники.Форма.ФормаИсторииИзмененияУдержаний", ПараметрыОткрытия, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистраторПоказателей(Команда)
	
	ПоказатьРегистратор("Показатели");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистраторЛьгот(Команда)
	
	ПоказатьРегистратор("Льготы");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьРегистраторУдержаний(Команда)
	
	ПоказатьРегистратор("Удержания");
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьДанные()
	
	ПрочитатьНачисления();
	ПрочитатьУдержания();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЛьготыСотрудников");
		Модуль.ПрочитатьЛьготыСотрудника(ЭтотОбъект, СотрудникСсылка, ОписаниеТаблицыЛьгот());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНачисления()
	
	Начисления.Очистить();
	Показатели.Очистить();
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		ТаблицаСотрудников.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	КонецЕсли;
	
	СтрокаСотрудник = ТаблицаСотрудников.Добавить();
	СтрокаСотрудник.Сотрудник = СотрудникСсылка;
	Если ЗначениеЗаполнено(ДатаУвольнения) Тогда
		
		СтрокаСотрудник.Период = ДатаУвольнения - 1;
		Элементы.ДекорацияЗаголовокНачислений.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Начисления действовавшие по %1'") + ":",
			Формат(ДатаУвольнения, "ДЛФ=DD"));
			
	Иначе
			
		СтрокаСотрудник.Период = ТекущаяДатаСеанса();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяОрганизация) Тогда
		СтрокаСотрудник.Организация = ТекущаяОрганизация;
	КонецЕсли;
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыРасчета();
	
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийСотрудниковДействующиеНачисленияВРеквизит(Неопределено, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета, , Ложь, Истина);
	ЗарплатаКадрыРасширенный.ВводНачисленийДанныеВРеквизит(ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, Истина);
	
	ФОТ = Начисления.Итог("Размер");
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьУдержания()
	
	Удержания.Очистить();
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	СтрокаСотрудник = ТаблицаСотрудников.Добавить();
	СтрокаСотрудник.ФизическоеЛицо = ФизическоеЛицоСсылка;
	Если ЗначениеЗаполнено(ДатаУвольнения) Тогда
		СтрокаСотрудник.Период = ДатаУвольнения - 1;
	Иначе
		СтрокаСотрудник.Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний();
	
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийСотрудниковДействующиеНачисленияВРеквизит(Неопределено, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета);
	ЗарплатаКадрыРасширенный.ВводНачисленийДанныеВРеквизит(ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, Истина);
	
	ДобавленыПоляПоказателей = Ложь;
	Если Удержания.Количество() > 0  Тогда
		
		Если Удержания[0].Свойство("Показатель1") Тогда
			ДобавленыПоляПоказателей = Истина;
		КонецЕсли;
		
		Для каждого СтрокаУдержаний Из Удержания Цикл
			
			Если Не ЗарплатаКадрыПовтИсп.ПолучитьИнформациюОВидеРасчета(СтрокаУдержаний.Удержание).Рассчитывается Тогда
				
				Если ДобавленыПоляПоказателей И ЗначениеЗаполнено(СтрокаУдержаний["ТекущееЗначение1"]) Тогда
					
					СтрокаУдержаний["Показатель1"] = Справочники.ПоказателиРасчетаЗарплаты.ПолучитьСсылку(УникальныйИдентификатор);
					СтрокаУдержаний["ПредставлениеПоказателя1"] = НСтр("ru='Фиксированная сумма'");
					СтрокаУдержаний["Значение1"] = СтрокаУдержаний["ТекущееЗначение1"];
					СтрокаУдержаний["ТочностьПоказателя1"] = "ЧДЦ=2";
					
				Иначе
					
					СтрокаУдержаний["Представление"] = НСтр("ru='Фиксированная сумма'");
					СтрокаУдержаний["Значение"] = Формат(СтрокаУдержаний.Размер, "ЧДЦ=2");
					
				КонецЕсли;
				 
			КонецЕсли; 
			
		КонецЦикла;
		
		РегистраторыУдержаний = Удержания.Выгрузить(, "Регистратор").ВыгрузитьКолонку("Регистратор");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Регистраторы", РегистраторыУдержаний);
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	УсловияУдержанияПоИсполнительномуДокументу.Регистратор,
			|	УсловияУдержанияПоИсполнительномуДокументу.СпособРасчета,
			|	УсловияУдержанияПоИсполнительномуДокументу.Процент,
			|	УсловияУдержанияПоИсполнительномуДокументу.Сумма,
			|	УсловияУдержанияПоИсполнительномуДокументу.Числитель,
			|	УсловияУдержанияПоИсполнительномуДокументу.Знаменатель
			|ИЗ
			|	РегистрСведений.УсловияУдержанияПоИсполнительномуДокументу.СрезПоследних(, Регистратор В (&Регистраторы)) КАК УсловияУдержанияПоИсполнительномуДокументу";
			
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СтрокиУдержаний = Удержания.НайтиСтроки(Новый Структура("Регистратор", Выборка.Регистратор));
			Если СтрокиУдержаний.Количество() > 0 Тогда
				
				СтрокаУдержаний = Неопределено;
				Для каждого НайденнаяСтрокаУдержаний Из СтрокиУдержаний Цикл
					ОписаниеУдержания = ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(НайденнаяСтрокаУдержаний.Удержание);
					Если ОписаниеУдержания.КатегорияУдержания = ПеречислениЯ.КатегорииУдержаний.ИсполнительныйЛист Тогда
						СтрокаУдержаний = НайденнаяСтрокаУдержаний;
						Прервать;
					КонецЕсли; 
				КонецЦикла;

				Если СтрокаУдержаний <> Неопределено Тогда
					
					Если Выборка.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Долей Тогда
						ПредставлениеПоказателя = Формат(Выборка.Числитель, "ЧДЦ=") + " / " + Формат(Выборка.Знаменатель, "ЧДЦ=") + " " + НСтр("ru='доля заработка'");
						ЗначениеПоказателя = 0;
					ИначеЕсли Выборка.СпособРасчета = Перечисления.СпособыРасчетаУдержанияПоИсполнительномуДокументу.Процентом Тогда
						ПредставлениеПоказателя = НСтр("ru='% заработка'");
						ЗначениеПоказателя = Выборка.Процент;
					Иначе
						ПредставлениеПоказателя = НСтр("ru='Фиксированная сумма'");
						ЗначениеПоказателя = Выборка.Сумма;
					КонецЕсли;
					
					Если ДобавленыПоляПоказателей Тогда
							
						СтрокаУдержаний["Показатель1"] = Справочники.ПоказателиРасчетаЗарплаты.ПолучитьСсылку(УникальныйИдентификатор);
						СтрокаУдержаний["ПредставлениеПоказателя1"] = ПредставлениеПоказателя;
						СтрокаУдержаний["Значение1"] = ЗначениеПоказателя;
						СтрокаУдержаний["ТекущееЗначение1"] = СтрокаУдержаний["Значение1"];
						СтрокаУдержаний["ТочностьПоказателя1"] = "ЧДЦ=2";
						
					Иначе
						
						СтрокаУдержаний["Представление"] = ПредставлениеПоказателя;
						СтрокаУдержаний["Значение"] = Формат(ЗначениеПоказателя, "ЧДЦ=2");
						
					КонецЕсли; 
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УдержанияПредставление",
		"Видимость",
		Не ДобавленыПоляПоказателей);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"УдержанияЗначение",
		"Видимость",
		Не ДобавленыПоляПоказателей);
	
КонецПроцедуры

&НаСервере
Функция ОписаниеТаблицыРасчета()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений();
	ОписаниеТаблицыВидовРасчета.ПутьКДанным = "Начисления";
	ОписаниеТаблицыВидовРасчета.ПутьКДаннымПоказателей = "Показатели";
	ОписаниеТаблицыВидовРасчета.ИмяПоляДляВставкиПоказателей = "НачисленияДокументОснование";
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "";
	
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаСервере
Функция ОписаниеТаблицыУдержаний()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицыВидовРасчета.ИмяТаблицы = "Удержания";
	ОписаниеТаблицыВидовРасчета.ПутьКДанным = "Удержания";
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаВидРасчета = "Удержание";
	ОписаниеТаблицыВидовРасчета.НомерТаблицы = 1;
	ОписаниеТаблицыВидовРасчета.ПутьКДаннымПоказателей = "Показатели";
	ОписаниеТаблицыВидовРасчета.ИмяПоляДляВставкиПоказателей = "УдержанияДокументОснование";
	
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаСервере
Функция ОписаниеТаблицыЛьгот()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений(Ложь, Ложь);
	ОписаниеТаблицыВидовРасчета.ИмяТаблицы = "Льготы";
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаВидРасчета = "Льгота";
	ОписаниеТаблицыВидовРасчета.ПутьКДанным = "Льготы";
	ОписаниеТаблицыВидовРасчета.ПутьКДаннымПоказателей = "Показатели";
	ОписаниеТаблицыВидовРасчета.НомерТаблицы = 2;
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "";
	ОписаниеТаблицыВидовРасчета.ИмяПоляДляВставкиПоказателей = "ЛьготыДокументОснование";
	
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьРегистратор(ИмяЭлементаТабличнойЧасти)
	
	ТекущиеДанные = Элементы[ИмяЭлементаТабличнойЧасти].ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Если ИмяЭлементаТабличнойЧасти = "Начисления" Тогда
			Регистратор = РегистраторНачислений(ТекущиеДанные.Начисление, СотрудникСсылка, ТекущаяОрганизация, ТекущиеДанные.ДокументОснование);
		ИначеЕсли ИмяЭлементаТабличнойЧасти = "Льготы" Тогда
			Регистратор = РегистраторНачислений(ТекущиеДанные.Льгота, СотрудникСсылка, ТекущаяОрганизация, ТекущиеДанные.ДокументОснование);
		ИначеЕсли ИмяЭлементаТабличнойЧасти = "Показатели" Тогда
			Регистратор = РегистраторПоказателей(ТекущиеДанные.Показатель, СотрудникСсылка, ТекущаяОрганизация);
		ИначеЕсли ИмяЭлементаТабличнойЧасти = "Удержания" Тогда
			Регистратор = РегистраторУдержаний(ТекущиеДанные.Удержание, ФизическоеЛицоСсылка, ТекущаяОрганизация, ТекущиеДанные.ДокументОснование);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Регистратор) Тогда
			ПоказатьЗначение(,Регистратор);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РегистраторНачислений(Начисление, СотрудникСсылка, Организация, ДокументОснование)
	
	Регистратор = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Сотрудник", СотрудникСсылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Начисление", Начисление);
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
		|	&Сотрудник КАК Сотрудник,
		|	&Начисление КАК Начисление,
		|	&ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТИзмеренияДатыДляПолученияНачислений
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДАТАВРЕМЯ(1, 1, 1) КАК Период,
		|	&Сотрудник КАК Сотрудник,
		|	&Организация КАК Организация,
		|	НачисленияПоказатели.Показатель,
		|	&ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТИзмеренияДатыДляПолученияПоказателей
		|ИЗ
		|	ПланВидовРасчета.Начисления.Показатели КАК НачисленияПоказатели
		|ГДЕ
		|	НачисленияПоказатели.ЗапрашиватьПриВводе
		|	И НачисленияПоказатели.Ссылка = &Начисление";
		
	Запрос.Выполнить();
	
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ПлановыеНачисления",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТИзмеренияДатыДляПолученияНачислений", "Сотрудник,Начисление,ДокументОснование"));
			
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТИзмеренияДатыДляПолученияПоказателей", "Сотрудник,Организация,Показатель,ДокументОснование"));
			
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.ПериодЗаписи,
		|	ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников.Регистратор
		|ПОМЕСТИТЬ ВТРегистраторыНачисленийИПоказателей
		|ИЗ
		|	ВТЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудниковСрезПоследних КАК ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПлановыеНачисления.ПериодЗаписи,
		|	ПлановыеНачисления.Регистратор
		|ИЗ
		|	ВТПлановыеНачисленияСрезПоследних КАК ПлановыеНачисления
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	РегистраторыНачисленийИПоказателей.Регистратор
		|ИЗ
		|	ВТРегистраторыНачисленийИПоказателей КАК РегистраторыНачисленийИПоказателей
		|
		|УПОРЯДОЧИТЬ ПО
		|	РегистраторыНачисленийИПоказателей.ПериодЗаписи УБЫВ,
		|	РегистраторыНачисленийИПоказателей.Регистратор УБЫВ";
	
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Регистратор = Выборка.Регистратор;
	КонецЕсли; 
	
	Возврат Регистратор;
	
КонецФункции

&НаСервереБезКонтекста
Функция РегистраторУдержаний(Удержание, ФизическоеЛицо, Организация, ДокументОснование)
	
	Регистратор = Неопределено;
	
	ИзмеренияДаты = Новый ТаблицаЗначений;
	ИзмеренияДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ИзмеренияДаты.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ИзмеренияДаты.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	ИзмеренияДаты.Колонки.Добавить("Удержание", Новый ОписаниеТипов("ПланВидовРасчетаСсылка.Удержания"));
	
	СтрокаИзмерений = ИзмеренияДаты.Добавить();
	СтрокаИзмерений.ФизическоеЛицо = ФизическоеЛицо;
	СтрокаИзмерений.Организация = Организация;
	СтрокаИзмерений.Удержание = Удержание;
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ИзмеренияДаты.Колонки.Добавить("ДокументОснование", Метаданные.ОпределяемыеТипы.ОснованиеУдержания.Тип);
		СтрокаИзмерений.ДокументОснование = ДокументОснование;
	КонецЕсли;
	
	Запрос = ЗарплатаКадрыОбщиеНаборыДанных.ЗапросВТИмяРегистраСрез(
		"ПлановыеУдержания",
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(ИзмеренияДаты),
		,
		Истина,
		"");
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Регистратор = Выборка.Регистратор;
	КонецЕсли; 
	
	Возврат Регистратор;
	
КонецФункции

&НаСервереБезКонтекста
Функция РегистраторПоказателей(Показатель, Сотрудник, Организация)
	
	Регистратор = Неопределено;
	
	ИзмеренияДаты = Новый ТаблицаЗначений;
	ИзмеренияДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ИзмеренияДаты.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ИзмеренияДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ИзмеренияДаты.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	
	СтрокаИзмерений = ИзмеренияДаты.Добавить();
	СтрокаИзмерений.Организация = Организация;
	СтрокаИзмерений.Сотрудник = Сотрудник;
	СтрокаИзмерений.Показатель = Показатель;
	
	Запрос = ЗарплатаКадрыОбщиеНаборыДанных.ЗапросВТИмяРегистраСрез(
		"ЗначенияПериодическихПоказателейРасчетаЗарплатыСотрудников",
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(ИзмеренияДаты),
		,
		Истина,
		"");
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Регистратор = Выборка.Регистратор;
	КонецЕсли; 
	
	Возврат Регистратор;
	
КонецФункции

&НаСервереБезКонтекста		
Функция ПолноеИмяОбъектаМетаданныхПоТипу(Тип)
	Возврат Метаданные.НайтиПоТипу(Тип).ПолноеИмя(); 
КонецФункции

#КонецОбласти
