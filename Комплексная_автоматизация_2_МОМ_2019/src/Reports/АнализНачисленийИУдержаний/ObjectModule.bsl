#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ПередНачаломКомпоновкиРезультата();
	
	УчетНачисленнойЗарплаты.ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(
		ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ПриКомпоновкеОтчета(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ЗарплатаКадрыОтчеты.ПриЗавершенииКомпоновкиРезультата(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗаполнятьОбщиеИсточникиДанных()
	
	Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("УстанавливаетсяМакетКомпоновкиДанных") Тогда
		ЗаполнитьОбщиеИсточникиДанных = Ложь;
	Иначе
		ЗаполнитьОбщиеИсточникиДанных = ЗаполнятьОбщиеИсточникиНаборовДанных(СхемаКомпоновкиДанных.НаборыДанных);
	КонецЕсли;
	
	Возврат ЗаполнитьОбщиеИсточникиДанных;
	
КонецФункции

Функция ЗаполнятьОбщиеИсточникиНаборовДанных(НаборыДанных)
	
	ЗаполнятьИсточникиДанных = Ложь;
	
	Для Каждого НаборДанных Из НаборыДанных Цикл
		
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхЗапросСхемыКомпоновкиДанных")
			И (СтрНайти(НаборДанных.Запрос, "ОбщиеЗапросы_") > 0
			Или СтрНайти(НаборДанных.Запрос, "Представления_") > 0) Тогда
			
			ЗаполнятьИсточникиДанных = Истина;
			Прервать;
			
		ИначеЕсли ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных") Тогда
			
			ЗаполнятьИсточникиДанных = ЗаполнятьОбщиеИсточникиНаборовДанных(НаборДанных.Элементы);
			Если ЗаполнятьИсточникиДанных Тогда
				Прервать;

			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗаполнятьИсточникиДанных;
	
КонецФункции

Процедура ИнициализироватьОтчет(КлючВарианта = "") Экспорт
	
	ЗаполнитьОбщиеИсточникиДанных = ЗаполнятьОбщиеИсточникиДанных();
	Если ЗаполнитьОбщиеИсточникиДанных Тогда
		
		ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеЗапросы(СхемаКомпоновкиДанных.НаборыДанных);
		
		ДополнительныеПоляПредставлений = ДополнительныеПоляПредставлений();
		
		Если ДополнительныеПоляПредставлений.Свойство("Представления_КадровыеДанныеСотрудниковАнализНачисленийИУдержаний") Тогда
			
			РазрядыКатегории = ДополнительныеПоляПредставлений.Представления_КадровыеДанныеСотрудниковАнализНачисленийИУдержаний.НайтиСтроки(Новый Структура("ИмяПоля", "РазрядКатегория"));
			Если РазрядыКатегории.Количество() > 0 Тогда
				
				ДополнительныеПоляПредставленийКадровыхДанных = Новый Структура;
				ДополнительныеПоляПредставленийКадровыхДанных.Вставить("Представления_КадровыеДанныеСотрудниковАнализНачисленийИУдержаний",
					ДополнительныеПоляПредставлений.Представления_КадровыеДанныеСотрудниковАнализНачисленийИУдержаний.Скопировать(РазрядыКатегории));
				
				ЗарплатаКадрыОбщиеНаборыДанных.ВывестиДополнительныеПоляПредставленийВОтчет(
					ЭтотОбъект, ДополнительныеПоляПредставленийКадровыхДанных);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ЗарплатаКадрыОбщиеНаборыДанных.ВывестиВОтчетДополнительныеПоляПредставлений(ЭтотОбъект, ДополнительныеПоляПредставлений);
		
		Если ДополнительныеПоляПредставлений.Свойство("_") Тогда
			
			ДополнительныеПоляОсновнойТаблицы = Новый Структура("_", ДополнительныеПоляПредставлений["_"]);
			ЗарплатаКадрыОбщиеНаборыДанных.ВывестиДополнительныеПоляПредставленийВОтчет(
				ЭтотОбъект, ДополнительныеПоляОсновнойТаблицы);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗагрузитьНастройкиПоКлючуВарианта(КлючВарианта);
	УстановитьТипРегистраторов();
	
КонецПроцедуры

Процедура ИнициализироватьНаборыДанных() Экспорт
	
	ЗаполнитьОбщиеИсточникиДанных = ЗаполнятьОбщиеИсточникиДанных();
	Если ЗаполнитьОбщиеИсточникиДанных Тогда
		
		ЗарплатаКадрыОбщиеНаборыДанных.ЗаполнитьОбщиеИсточникиДанныхОтчета(ЭтотОбъект);
		ДоработатьЗапросОтработанногоВремени();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиПоКлючуВарианта(КлючВарианта)
	
	Если Не ПустаяСтрока(КлючВарианта) Тогда
		
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек[КлючВарианта].Настройки);
		
		Отбор = КомпоновщикНастроек.Настройки.Отбор;
		Отбор.Элементы.Очистить();
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Организация", ВидСравненияКомпоновкиДанных.Равно, Справочники.Организации.ПустаяСсылка());
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "ФизическоеЛицо", ВидСравненияКомпоновкиДанных.ВСписке, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Справочники.ФизическиеЛица.ПустаяСсылка()));
		
	КонецЕсли;
	
КонецПроцедуры

// Для общей формы "Форма отчета" подсистемы "Варианты отчетов".
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если КлючСхемы <> КлючВарианта Тогда
		
		ЗарплатаКадрыОтчеты.ИнициализироватьНастройкиОтчета(ЭтотОбъект, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		
		ЗарплатаКадрыОтчеты.ОтчетАнализНачисленийИУдержанийПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		
		ЗарплатаКадрыОтчеты.ПодключитьСхему(Контекст, ЭтотОбъект, КлючСхемы, КлючВарианта, НовыеПользовательскиеНастройкиКД);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ДополнительныеПоляПредставлений() Экспорт
	
	ДополнительныеПоля = Новый Структура;
	УчетНачисленнойЗарплаты.ЗаполнитьДополнительныеПоляОтчетаАнализНачисленийИУдержаний(ЭтотОбъект, ДополнительныеПоля);
	
	Возврат ДополнительныеПоля;
	
КонецФункции

Процедура ПередНачаломКомпоновкиРезультата()
	
	 ПроверитьЗначенияПараметров();
	ЗарплатаКадрыОтчеты.ПередНачаломКомпоновкиРезультата(ЭтотОбъект);
	ДоработатьЗапросОтработанногоВремени();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Компоновка вариантов отчета.

Процедура ПриКомпоновкеОтчета(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Если Не СтандартнаяОбработка Тогда
		Возврат
	КонецЕсли;
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(КомпоновщикНастроек);
	
	Если КлючВарианта = "Т51" Тогда
		ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаТ51(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	ИначеЕсли КлючВарианта = "Т49" Тогда
		ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаТ49(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	ИначеЕсли ЗарплатаКадрыОтчеты.ЭтоКлючВариантаОтчетаРасчетныйЛисток(КлючВарианта) Тогда
		ЗарплатаКадрыОтчеты.ПриКомпоновкеРезультатаРасчетныйЛисток(ЭтотОбъект, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	ИначеЕсли КлючВарианта = "РегламентированнаяФормаСправкаПоДСВ" Тогда
		ПриКомпоновкеВариантаСправкаПоДСВ(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	Иначе
		
		МакетКомпоновкиДанных = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанных(СхемаКомпоновкиДанных,
			КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
		
		Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДанныеДокумента") Тогда
			НаборыВнешнихДанных = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.ДанныеДокумента;
		Иначе
			НаборыВнешнихДанных = ЗарплатаКадрыОтчеты.НаборыВнешнихДанныхАнализНачисленийИУдержаний();
		КонецЕсли;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, НаборыВнешнихДанных, ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Формирование варианта РегламентированнаяФормаСправкаПоДСВ (форма КНД 1151087).

Процедура ПриКомпоновкеВариантаСправкаПоДСВ(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	Попытка
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РегламентированнаяФормаСправкаПоДСВ";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		
		НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
		
		ОбщиеНастройкиМакета = Новый Структура("ДатаАктуальности,ПервыйНомер,Ответственный,ДолжностьОтветственного", ТекущаяДатаСеанса(), 0);
		
		ПроверитьЗначенияПараметровДСВ(НастройкиОтчета, ОбщиеНастройкиМакета);
		
		МакетКомпоновки = ЗарплатаКадрыОтчеты.МакетКомпоновкиДанныхДляКоллекцииЗначений(СхемаКомпоновкиДанных, НастройкиОтчета);
		
		СоответствиеПользовательскихПолей = ЗарплатаКадрыОтчеты.СоответствиеПользовательскихПолей(НастройкиОтчета);
		
		Если КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДанныеДокумента") Тогда
			НаборыВнешнихДанных = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.ДанныеДокумента;
		Иначе
			НаборыВнешнихДанных = ЗарплатаКадрыОтчеты.НаборыВнешнихДанныхАнализНачисленийИУдержаний();
		КонецЕсли;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, НаборыВнешнихДанных, , Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ДанныеОтчета = Новый ДеревоЗначений;
		ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		СписокФизическихЛиц = ДанныеОтчета.Строки.ВыгрузитьКолонку("ФизическоеЛицо");
		КадровыеДанные = КадровыйУчет.КадровыеДанныеФизическихЛиц(Истина, СписокФизическихЛиц,
			"Фамилия,Имя,Отчество,ИНН,ДокументКодМВД,ДокументНомер,ДокументСерия,АдресПоПрописке", ОбщиеНастройкиМакета.ДатаАктуальности);
		
		ТаблицаРегистраций = Новый ТаблицаЗначений;
		ТаблицаРегистраций.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
		ТаблицаРегистраций.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов("СправочникСсылка.Организации"));
		
		Для каждого СтрокаФизическоеЛицо Из ДанныеОтчета.Строки Цикл
			
			КадровыеДанныеФизическогоЛица = КадровыеДанныеФизическогоЛица(КадровыеДанные, СтрокаФизическоеЛицо.ФизическоеЛицо);
			Для каждого СтрокаГода Из СтрокаФизическоеЛицо.Строки Цикл
				Для каждого СтрокаДанных Из СтрокаГода.Строки Цикл
					
					НоваяСтрокаТаблицыРегистраций = ТаблицаРегистраций.Добавить(); 
					НоваяСтрокаТаблицыРегистраций.Период = Дата(СтрокаДанных.Год, 12, 31, 23, 59, 59);
					НоваяСтрокаТаблицыРегистраций.СтруктурнаяЕдиница = СтрокаДанных.Организация;
					
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
		СведенияОРегистрациях = РеквизитыРегистрацийВНалоговомОрганеСтруктурныхЕдиниц(ТаблицаРегистраций);
			
		Макет = УправлениеПечатью.МакетПечатнойФормы("Отчет.АнализНачисленийИУдержаний.ПФ_MXL_ФормаКНД1151087");			
		Для каждого СтрокаФизическоеЛицо Из ДанныеОтчета.Строки Цикл
			
			КадровыеДанныеФизическогоЛица = КадровыеДанныеФизическогоЛица(КадровыеДанные, СтрокаФизическоеЛицо.ФизическоеЛицо);
			Для каждого СтрокаГода Из СтрокаФизическоеЛицо.Строки Цикл
				Для каждого СтрокаДанных Из СтрокаГода.Строки Цикл
					
					СведенияОРегистрации = Неопределено;
					
					СведенияПоОрганизации = СведенияОРегистрациях.Получить(СтрокаДанных.Организация);
					Если СведенияПоОрганизации <> Неопределено Тогда
						СведенияОРегистрации = СведенияПоОрганизации.Получить(Дата(СтрокаДанных.Год, 12, 31, 23, 59, 59));
					КонецЕсли; 
					
					Если СведенияОРегистрации = Неопределено Тогда
						СведенияОРегистрации = Новый Структура("Код,КПП", "", "");
					КонецЕсли; 
					
					ВывестиКарточкуПоДСВ(ДокументРезультат, СтрокаДанных, Макет, КадровыеДанныеФизическогоЛица, СведенияОРегистрации, ОбщиеНастройкиМакета);
					
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.ПолеСлева				= 5;
		ДокументРезультат.ПолеСправа			= 10;
		ДокументРезультат.ПолеСнизу				= 0;
		ДокументРезультат.ПолеСверху			= 2;
		ДокументРезультат.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_РегламентированнаяФормаСправкаПоДСВ";
		ДокументРезультат.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
		
		ДопСвойства = КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства;
		ДопСвойства.Вставить("ОтчетПустой", ДанныеОтчета.Строки.Количество() = 0);
		
		СтандартнаяОбработка = Ложь;
		
	Исключение
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение НСтр("ru = 'В настройку отчета ""Регламентированная форма справка по ДСВ"" внесены критичные изменения. Отчет не будет сформирован.'") + " " + КраткоеПредставлениеОшибки(Инфо);
	КонецПопытки;
	
КонецПроцедуры

Процедура ВывестиКарточкуПоДСВ(ДокументРезультат, ДанныеФизЛиц, Макет, КадровыеДанные, СведенияОРегистрации, ОбщиеНастройкиМакета)
	
	Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	
	Раздел = Макет.ПолучитьОбласть("Раздел");
	
	ЗарплатаКадры.ВывестиДанныеПобуквенно(ДанныеФизЛиц.ОрганизацияИНН, Раздел, "Организация_ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(СведенияОРегистрации.КПП, Раздел, "Организация_КПП_", 9);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(СведенияОРегистрации.Код, Раздел, "ИФНС_", 4);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(СтрЗаменить(Формат(ОбщиеНастройкиМакета.ДатаАктуальности, "ДЛФ=D"),".",""), Раздел, "Дата", 8);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(Формат(ДанныеФизЛиц.Год, "ЧГ=0"), Раздел, "Год", 4);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(Формат(ОбщиеНастройкиМакета.ПервыйНомер, "ЧГ=0"), Раздел,                   "Номер", 8);
	
	ЗарплатаКадры.ВывестиДанныеПобуквенно(ДанныеФизЛиц.ОрганизацияНаименованиеСокращенное, Раздел, "Организация_Наименование_", 160);
	
	Раздел.Параметры.ФИООтветственного = ОбщиеНастройкиМакета.Ответственный;
	Раздел.Параметры.ДолжностьОтветственного = ОбщиеНастройкиМакета.ДолжностьОтветственного;
	
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.Фамилия, Раздел,				"ФизЛицо_Фамилия_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.Имя, Раздел,					"ФизЛицо_Имя_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.Отчество, Раздел,				"ФизЛицо_Отчество_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.ИНН, Раздел,					"ФизЛицо_ИНН_", 12);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.ДокументКодМВД, Раздел,		"ФизЛицо_КодДокументаУдЛичн_", 2);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.ДокументСерияНомер, Раздел, 	"ФизЛицо_СерияНомерДокументаУдЛичн_", 25);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресИндекс, Раздел,			"ФизЛицо_АдресИндекс_", 6);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресКодРегиона, Раздел,		"ФизЛицо_АдресРегион_", 2);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресРайон, Раздел,			"ФизЛицо_АдресРайон_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресГород, Раздел,			"ФизЛицо_АдресГород_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресНаселенныйПункт, Раздел,	"ФизЛицо_АдресНаселенныйПункт_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресУлица, Раздел,			"ФизЛицо_АдресУлица_", 33);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресДом, Раздел,				"ФизЛицо_АдресДом_", 8);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресКорпус, Раздел,			"ФизЛицо_АдресКорпус_", 8);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(КадровыеДанные.АдресКвартира, Раздел,			"ФизЛицо_АдресКвартира_", 8);
	ЗарплатаКадры.ВывестиДанныеПобуквенно(Прав("           " + Формат(ДанныеФизЛиц.Сумма,"ЧЦ=11; ЧС=-2; ЧГ=0"),11), Раздел, "СуммаВзносовРубли_", 11);
	
	ДокументРезультат.Вывести(Раздел); 
	
	Если ОбщиеНастройкиМакета.ПервыйНомер <> 0 Тогда
		ОбщиеНастройкиМакета.ПервыйНомер = ОбщиеНастройкиМакета.ПервыйНомер + 1;
	КонецЕсли; 
	
КонецПроцедуры

Функция КадровыеДанныеФизическогоЛица(КадровыеДанные, ФизическоеЛицо)
	
	КадровыеДанныеФизическогоЛица = КадровыеДанные.Найти(ФизическоеЛицо, "ФизическоеЛицо");
	
	ДанныеФизическогоЛица = Новый Структура;
	
	ДанныеФизическогоЛица.Вставить("Фамилия", "");
	ДанныеФизическогоЛица.Вставить("Имя", "");
	ДанныеФизическогоЛица.Вставить("Отчество", "");
	ДанныеФизическогоЛица.Вставить("ИНН", "");
	ДанныеФизическогоЛица.Вставить("ДокументКодМВД", "");
	ДанныеФизическогоЛица.Вставить("ДокументСерияНомер", "");
	ДанныеФизическогоЛица.Вставить("АдресИндекс", "");
	ДанныеФизическогоЛица.Вставить("АдресКодРегиона", "");
	ДанныеФизическогоЛица.Вставить("АдресРайон", "");
	ДанныеФизическогоЛица.Вставить("АдресГород", "");
	ДанныеФизическогоЛица.Вставить("АдресНаселенныйПункт", "");
	ДанныеФизическогоЛица.Вставить("АдресУлица", "");
	ДанныеФизическогоЛица.Вставить("АдресДом", "");
	ДанныеФизическогоЛица.Вставить("АдресКорпус", "");
	ДанныеФизическогоЛица.Вставить("АдресКвартира", "");
		
	Если КадровыеДанныеФизическогоЛица <> Неопределено Тогда
		
		ДанныеФизическогоЛица.Вставить("Фамилия", КадровыеДанныеФизическогоЛица.Фамилия);
		ДанныеФизическогоЛица.Вставить("Имя", КадровыеДанныеФизическогоЛица.Имя);
		ДанныеФизическогоЛица.Вставить("Отчество", КадровыеДанныеФизическогоЛица.Отчество);
		ДанныеФизическогоЛица.Вставить("ИНН", КадровыеДанныеФизическогоЛица.ИНН);
		ДанныеФизическогоЛица.Вставить("ДокументКодМВД", КадровыеДанныеФизическогоЛица.ДокументКодМВД);
		
		ДокументСерияНомер = "";
		Если ЗначениеЗаполнено(КадровыеДанныеФизическогоЛица.ДокументСерия) Тогда
			ДокументСерияНомер = КадровыеДанныеФизическогоЛица.ДокументСерия;
		КонецЕсли; 
		Если ЗначениеЗаполнено(КадровыеДанныеФизическогоЛица.ДокументНомер) Тогда
			ДокументСерияНомер = ?(ПустаяСтрока(ДокументСерияНомер), "", ДокументСерияНомер + " ")
				+ КадровыеДанныеФизическогоЛица.ДокументНомер;
		КонецЕсли; 
		ДанныеФизическогоЛица.Вставить("ДокументСерияНомер", ДокументСерияНомер);
		
		Если ЗначениеЗаполнено(КадровыеДанныеФизическогоЛица.АдресПоПрописке) Тогда
			
			СтруктураАдреса = ЗарплатаКадры.СтруктураАдресаИзXML(КадровыеДанныеФизическогоЛица.АдресПоПрописке, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
			
			ДанныеФизическогоЛица.Вставить("АдресИндекс", СтруктураАдреса.Индекс);
			
			Если ЗначениеЗаполнено(СтруктураАдреса.Регион) Тогда
				ДанныеФизическогоЛица.Вставить("АдресКодРегиона", АдресныйКлассификатор.КодРегионаПоНаименованию(СтруктураАдреса.Регион));
			КонецЕсли; 
			
			ДанныеФизическогоЛица.Вставить("АдресРайон", СтруктураАдреса.Район);
			
			Если НЕ ЗначениеЗаполнено(СтруктураАдреса.Город) Тогда
				
				Если ДанныеФизическогоЛица.АдресКодРегиона = 77
					ИЛИ ДанныеФизическогоЛица.АдресКодРегиона = 78 Тогда
					ДанныеФизическогоЛица.Вставить("АдресГород", СтруктураАдреса.Регион);
				КонецЕсли; 
				
			Иначе
				ДанныеФизическогоЛица.Вставить("АдресГород", СтруктураАдреса.Город);
			КонецЕсли; 
			
			ДанныеФизическогоЛица.Вставить("АдресНаселенныйПункт", СтруктураАдреса.НаселенныйПункт);
			ДанныеФизическогоЛица.Вставить("АдресУлица", СтруктураАдреса.Улица);
			ДанныеФизическогоЛица.Вставить("АдресДом", СтруктураАдреса.Дом);
			ДанныеФизическогоЛица.Вставить("АдресКорпус", СтруктураАдреса.Корпус);
			ДанныеФизическогоЛица.Вставить("АдресКвартира", СтруктураАдреса.Квартира);
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Возврат ДанныеФизическогоЛица;
	
КонецФункции

Процедура ПроверитьЗначенияПараметровДСВ(НастройкиОтчета, ОбщиеНастройки)
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПервыйНомер"));
	Если НЕ ЗначениеПараметра.Использование Тогда
		ЗначениеПараметра.Значение = 0;
	КонецЕсли; 
	ЗначениеПараметра.Использование = Истина;
	ОбщиеНастройки.Вставить("ПервыйНомер", ЗначениеПараметра.Значение);
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Ответственный"));
	Если НЕ ЗначениеПараметра.Использование Тогда
		ЗначениеПараметра.Значение = Неопределено;
	КонецЕсли; 
	ЗначениеПараметра.Использование = Истина;
	
	Ответственный = ЗарплатаКадрыОтчеты.ИОФамилияФизическогоЛица(ЗначениеПараметра.Значение);
	ОбщиеНастройки.Вставить("Ответственный", Ответственный);
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьОтветственного"));
	Если НЕ ЗначениеПараметра.Использование Тогда
		ЗначениеПараметра.Значение = Неопределено;
	КонецЕсли; 
	ЗначениеПараметра.Использование = Истина;
	ОбщиеНастройки.Вставить("ДолжностьОтветственного", ЗначениеПараметра.Значение);
	
КонецПроцедуры

Процедура ПроверитьЗначенияПараметров()
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Если ЗначениеПараметра.Использование Тогда
		
		Если ЗначениеПараметра.Значение<> Неопределено Тогда
			
			Если ЗначениеЗаполнено(ЗначениеПараметра.Значение.ДатаОкончания)
				И ЗначениеПараметра.Значение.ДатаНачала > ЗначениеПараметра.Значение.ДатаОкончания Тогда
				
				ВызватьИсключение НСтр("ru='Не верно задан период отчета'");
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция РеквизитыРегистрацийВНалоговомОрганеСтруктурныхЕдиниц(СтруктурныеЕдиницы)
	
	РеквизитыРегистраций = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СтруктурныеЕдиницы", СтруктурныеЕдиницы);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	СтруктурныеЕдиницы.Период,
		|	СтруктурныеЕдиницы.СтруктурнаяЕдиница
		|ПОМЕСТИТЬ ВТСтруктурныеЕдиницы
		|ИЗ
		|	&СтруктурныеЕдиницы КАК СтруктурныеЕдиницы";
		
	Запрос.Выполнить();
		
	ЗарплатаКадрыОбщиеНаборыДанных.СоздатьВТИмяРегистраСрезПоследних(
		"ИсторияРегистрацийВНалоговомОргане",
		Запрос.МенеджерВременныхТаблиц,
		Истина,
		ЗарплатаКадрыОбщиеНаборыДанных.ОписаниеФильтраДляСоздатьВТИмяРегистра(
			"ВТСтруктурныеЕдиницы",
			"СтруктурнаяЕдиница"));
		
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ИсторияРегистрацийВНалоговомОргане.Период КАК Период,
		|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	РегистрацииВНалоговомОргане.Код,
		|	РегистрацииВНалоговомОргане.КПП
		|ИЗ
		|	ВТИсторияРегистрацийВНалоговомОрганеСрезПоследних КАК ИсторияРегистрацийВНалоговомОргане
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
		|		ПО ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане = РегистрацииВНалоговомОргане.Ссылка
		|ИТОГИ ПО
		|	СтруктурнаяЕдиница";
		
	ВыборкаПоСтруктурнымЕдиницам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоСтруктурнымЕдиницам.Следующий() Цикл
		
		КоллекцияПериодов = Новый Соответствие;
		ВыборкаПоПериодам = ВыборкаПоСтруктурнымЕдиницам.Выбрать();
		Пока ВыборкаПоПериодам.Следующий() Цикл
			
			СтруктураДанныхРегистрации = Новый Структура("Код,КПП");
			ЗаполнитьЗначенияСвойств(СтруктураДанныхРегистрации, ВыборкаПоПериодам);
			
			КоллекцияПериодов.Вставить(ВыборкаПоПериодам.Период, СтруктураДанныхРегистрации);
			
		КонецЦикла; 
		
		РеквизитыРегистраций.Вставить(ВыборкаПоСтруктурнымЕдиницам.СтруктурнаяЕдиница, КоллекцияПериодов);
		
	КонецЦикла; 
	
	Возврат РеквизитыРегистраций;
	
КонецФункции

Процедура ДоработатьЗапросОтработанногоВремени()
	
	Если Не НастройкиСодержатВыборОтработанногоВремениВПериоде(КомпоновщикНастроек.Настройки) Тогда
		
		Схема = Новый СхемаЗапроса;
		Схема.УстановитьТекстЗапроса(СхемаКомпоновкиДанных.НаборыДанных.НачисленияУдержанияОбъединенные.Элементы.НачисленияУдержания.Запрос);
		
		Для Каждого ПакетЗапроса Из Схема.ПакетЗапросов Цикл
			
			Если ТипЗнч(ПакетЗапроса) = Тип("ЗапросУничтоженияТаблицыСхемыЗапроса") Тогда
				Продолжить;
			КонецЕсли;
			
			Если ПакетЗапроса.ТаблицаДляПомещения = "ВТПериодыОтработанноеВремяСКорректировками" Тогда
				
				Если ПакетЗапроса.Операторы.Количество() > 2 Тогда
					
					ПакетЗапроса.Операторы.Удалить(2);
					ПакетЗапроса.Операторы.Удалить(2);
					СхемаКомпоновкиДанных.НаборыДанных.НачисленияУдержанияОбъединенные.Элементы.НачисленияУдержания.Запрос = Схема.ПолучитьТекстЗапроса();
					
				КонецЕсли;
				
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция НастройкиСодержатВыборОтработанногоВремениВПериоде(Настройки)
	
	Результат = Ложь;
	
	КоллекцияГруппировок = Новый Массив;
	Если ТипЗнч(Настройки) = Тип("ТаблицаКомпоновкиДанных") Тогда
		КоллекцияГруппировок.Добавить(Настройки.Строки);
		КоллекцияГруппировок.Добавить(Настройки.Колонки);
	ИначеЕсли ТипЗнч(Настройки) = Тип("ДиаграммаКомпоновкиДанных") Тогда
		КоллекцияГруппировок.Добавить(Настройки.Серии);
		КоллекцияГруппировок.Добавить(Настройки.Точки);
	Иначе
		КоллекцияГруппировок.Добавить(Настройки.Структура);
	КонецЕсли;
	
	Для Каждого КоллекцияГруппировки Из КоллекцияГруппировок Цикл
		
		Для Каждого НастройкаСтруктуры Из КоллекцияГруппировки Цикл
			
			Для Каждого ЭлементВыбора Из НастройкаСтруктуры.Выбор.Элементы Цикл
				
				Если ТипЗнч(ЭлементВыбора) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
					Продолжить;
				КонецЕсли;
				
				Если ЭлементВыбора.Поле = Новый ПолеКомпоновкиДанных("ОтработаноДнейВПериоде") Тогда
					Результат = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не Результат Тогда
				Результат = НастройкиСодержатВыборОтработанногоВремениВПериоде(НастройкаСтруктуры);
			КонецЕсли;
			
			Если Результат Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Результат Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура УстановитьТипРегистраторов()
	
	МассивТиповРегистраторов = Новый Массив;
	Для Каждого МетаданныеДокумента Из Метаданные.Документы Цикл
		
		Если МетаданныеДокумента.Проведение = Метаданные.СвойстваОбъектов.Проведение.Запретить Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПравоДоступа("Просмотр", МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыНакопления.НачисленияУдержанияПоСотрудникам)
			Или МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыНакопления.ОтработанноеВремяПоСотрудникам)
			Или МетаданныеДокумента.Движения.Содержит(Метаданные.РегистрыНакопления.ВзаиморасчетыССотрудниками) Тогда
			
			МассивТиповРегистраторов.Добавить(Тип("ДокументСсылка." + МетаданныеДокумента.Имя));
			
		КонецЕсли;
		
	КонецЦикла;
	
	ТипыРегистраторов = Новый ОписаниеТипов(МассивТиповРегистраторов);
	УстановитьТипПоляНаборовДанных(СхемаКомпоновкиДанных.НаборыДанных, "Регистратор", ТипыРегистраторов)
	
КонецПроцедуры

Процедура УстановитьТипПоляНаборовДанных(НаборыДанных, ИмяПоля, ТипЗначения)
	
	Для Каждого НаборДанных Из НаборыДанных Цикл
		
		Если ТипЗнч(НаборДанных) = Тип("НаборДанныхОбъединениеСхемыКомпоновкиДанных") Тогда
			УстановитьТипПоляНаборовДанных(НаборДанных.Элементы, ИмяПоля, ТипЗначения)
		КонецЕсли;
		
		ПолеНабора = НаборДанных.Поля.Найти(ИмяПоля);
		Если ПолеНабора <> Неопределено Тогда
			ПолеНабора.ТипЗначения = ТипЗначения;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли