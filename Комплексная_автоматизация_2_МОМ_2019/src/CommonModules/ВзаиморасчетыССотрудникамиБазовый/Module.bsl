#Область СлужебныйПрограммныйИнтерфейс

// Для методов служебного API проверка использования отключена,
// т.к. они вызываются из расширенной реализации
// АПК:581-выкл 
// АПК:299-выкл

#Область УправлениеДоступом

Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Справочники.ВедомостьНаВыплатуЗарплатыВБанкПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ВедомостьНаВыплатуЗарплатыВКассуПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВБанк, Истина);
	Списки.Вставить(Метаданные.Документы.ВедомостьНаВыплатуЗарплатыВКассу, Истина);
	
	Списки.Вставить(Метаданные.РегистрыСведений.ОплатаВедомостейНаВыплатуЗарплаты, Истина);

	Списки.Вставить(Метаданные.РегистрыНакопления.БухгалтерскиеВзаиморасчетыССотрудниками, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.ВзаиморасчетыССотрудниками, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.ЗарплатаКВыплате, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.ЗарплатаКВыплатеАвансом, Истина);
	
КонецПроцедуры

Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт

	Описание = Описание + "
	|Справочник.ВедомостьНаВыплатуЗарплатыВБанкПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыВБанкПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьНаВыплатуЗарплатыВБанкПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыВБанкПрисоединенныеФайлы.Изменение.Организации
	|Справочник.ВедомостьНаВыплатуЗарплатыВКассуПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыВКассуПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ВедомостьНаВыплатуЗарплатыВКассуПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ВедомостьНаВыплатуЗарплатыВКассуПрисоединенныеФайлы.Изменение.Организации
	|Документ.ВедомостьНаВыплатуЗарплатыВБанк.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплатыВБанк.Чтение.Организации
	|Документ.ВедомостьНаВыплатуЗарплатыВБанк.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплатыВБанк.Изменение.Организации
	|Документ.ВедомостьНаВыплатуЗарплатыВКассу.Чтение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплатыВКассу.Чтение.Организации
	|Документ.ВедомостьНаВыплатуЗарплатыВКассу.Изменение.ГруппыФизическихЛиц
	|Документ.ВедомостьНаВыплатуЗарплатыВКассу.Изменение.Организации";
	
	Описание = Описание + "
	|РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.ОплатаВедомостейНаВыплатуЗарплаты.Чтение.Организации";
	
	Описание = Описание + "
	|РегистрНакопления.БухгалтерскиеВзаиморасчетыССотрудниками.Чтение.ГруппыФизическихЛиц
	|РегистрНакопления.БухгалтерскиеВзаиморасчетыССотрудниками.Чтение.Организации
	|РегистрНакопления.ВзаиморасчетыССотрудниками.Чтение.ГруппыФизическихЛиц
	|РегистрНакопления.ВзаиморасчетыССотрудниками.Чтение.Организации
	|РегистрНакопления.ЗарплатаКВыплате.Чтение.ГруппыФизическихЛиц
	|РегистрНакопления.ЗарплатаКВыплате.Чтение.Организации
	|РегистрНакопления.ЗарплатаКВыплатеАвансом.Чтение.ГруппыФизическихЛиц
	|РегистрНакопления.ЗарплатаКВыплатеАвансом.Чтение.Организации";
	
КонецПроцедуры

#КонецОбласти

#Область УчетНачисленнойИВыплаченнойЗарплаты

Процедура ЗарегистрироватьНачальныеОстатки(Движения, Отказ, Организация, ПериодРегистрации, Остатки) Экспорт
	
	ЕстьКолонкаСуммаПоБухучету = Остатки.Колонки.Найти("СуммаПоБухучету")<>Неопределено;
	ЕстьКолонкаВыплатыЗаПрошлыеПериоды = Остатки.Колонки.Найти("ВыплатыЗаПрошлыеПериоды")<>Неопределено;

	Если Не ЕстьКолонкаСуммаПоБухучету Тогда 
		Остатки.Колонки.Добавить("СуммаПоБухучету", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	КонецЕсли;
	Если Не ЕстьКолонкаВыплатыЗаПрошлыеПериоды Тогда 
		Остатки.Колонки.Добавить("ВыплатыЗаПрошлыеПериоды", ОбщегоНазначения.ОписаниеТипаЧисло(15,2));
	КонецЕсли;
	
	Если Не (ЕстьКолонкаСуммаПоБухучету И ЕстьКолонкаВыплатыЗаПрошлыеПериоды) Тогда 
		Для Каждого СтрокаОстатка Из Остатки Цикл
			Если Не ЕстьКолонкаСуммаПоБухучету Тогда 
				СтрокаОстатка.СуммаПоБухучету = СтрокаОстатка.Сумма;
			КонецЕсли;
			Если Не ЕстьКолонкаВыплатыЗаПрошлыеПериоды Тогда 
				СтрокаОстатка.ВыплатыЗаПрошлыеПериоды = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаОстатка Из Остатки Цикл
		
		Если СтрокаОстатка.Сумма <> 0 Тогда
				
			ЗарплатаКВыплате = Движения.ЗарплатаКВыплате.ДобавитьПриход();
			ЗаполнитьЗначенияСвойств(ЗарплатаКВыплате, СтрокаОстатка);
			
			ЗарплатаКВыплате.Период			= ПериодРегистрации;
			ЗарплатаКВыплате.Организация	= Организация;
			ЗарплатаКВыплате.СуммаКВыплате	= СтрокаОстатка.Сумма;
			
			Взаиморасчеты = Движения.ВзаиморасчетыССотрудниками.ДобавитьПриход();
			ЗаполнитьЗначенияСвойств(Взаиморасчеты, СтрокаОстатка);
			
			Взаиморасчеты.Период				= ПериодРегистрации;
			Взаиморасчеты.Организация			= Организация;
			Взаиморасчеты.СуммаВзаиморасчетов	= СтрокаОстатка.Сумма;
			Взаиморасчеты.ВидВзаиморасчетов	= Перечисления.ВидыВзаиморасчетовССотрудниками.НачальнаяЗадолженность;
			Взаиморасчеты.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.ПустаяСсылка();
			
			Движения.ЗарплатаКВыплате.Записывать = Истина;
			Движения.ВзаиморасчетыССотрудниками.Записывать = Истина;		
			
		КонецЕсли;	
		
		Если СтрокаОстатка.СуммаПоБухучету <> 0 Тогда
				
			БухВзаиморасчеты = Движения.БухгалтерскиеВзаиморасчетыССотрудниками.ДобавитьПриход();
			ЗаполнитьЗначенияСвойств(БухВзаиморасчеты, СтрокаОстатка);
			
			БухВзаиморасчеты.Период					= НачалоМесяца(ПериодРегистрации) - 1;
			БухВзаиморасчеты.Организация			= Организация;
			БухВзаиморасчеты.СуммаВзаиморасчетов	= СтрокаОстатка.СуммаПоБухучету;
			БухВзаиморасчеты.ВидВзаиморасчетов		= Перечисления.ВидыВзаиморасчетовССотрудниками.НачальнаяЗадолженность;
			БухВзаиморасчеты.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.ПустаяСсылка();
			
			Движения.БухгалтерскиеВзаиморасчетыССотрудниками.Записывать = Истина;
			
		КонецЕсли;	
		
		Если СтрокаОстатка.ВыплатыЗаПрошлыеПериоды <> 0 Тогда
				
			БухВзаиморасчеты = Движения.БухгалтерскиеВзаиморасчетыССотрудниками.ДобавитьРасход();
			ЗаполнитьЗначенияСвойств(БухВзаиморасчеты, СтрокаОстатка);
			
			БухВзаиморасчеты.Период					= НачалоМесяца(ПериодРегистрации) + 60*60*12;
			БухВзаиморасчеты.Организация			= Организация;
			БухВзаиморасчеты.СуммаВзаиморасчетов	= СтрокаОстатка.ВыплатыЗаПрошлыеПериоды;
			БухВзаиморасчеты.ВидВзаиморасчетов		= Перечисления.ВидыВзаиморасчетовССотрудниками.НачальнаяЗадолженность;
			БухВзаиморасчеты.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.ПустаяСсылка();
			
			Движения.БухгалтерскиеВзаиморасчетыССотрудниками.Записывать = Истина;
			
		КонецЕсли;	
		
	КонецЦикла;
			
КонецПроцедуры

Процедура ЗарегистрироватьНачисленнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, ПорядокВыплаты, Начисления = Неопределено, Удержания = Неопределено) Экспорт
	
	ДокументОснование = Движения.ЗарплатаКВыплате.Отбор.Регистратор.Значение;
	
	НачисленнаяЗарплата = ТаблицаНачисленнойЗарплатыДляРегистрации(Начисления, Удержания, Организация, ДокументОснование); 
	
	ЗарегистрироватьНачисленнуюЗарплатуВЗарплатеКВыплате(
		Движения.ЗарплатаКВыплате, 
		ПериодРегистрации, 
		НачисленнаяЗарплата);
		
	ЗарегистрироватьНачисленнуюЗарплатуВоВзаиморасчетах(
		Движения.ВзаиморасчетыССотрудниками, 
		ПериодРегистрации,
		НачисленнаяЗарплата);		
	
	// зарплату, выдаваемую с авансом, помещаем еще и в зарплату к выплате авансом
	Если ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
		ЗарегистрироватьНачисленнуюЗарплатуВЗарплатеКВыплате(
			Движения.ЗарплатаКВыплатеАвансом, 
			ПериодРегистрации, 
			НачисленнаяЗарплата);
	КонецЕсли;
	
	// бухгалтерское сальдо
	ЗарегистрироватьНачисленнуюЗарплатуВоВзаиморасчетах(
		Движения.БухгалтерскиеВзаиморасчетыССотрудниками, 
		КонецМесяца(ПериодРегистрации), 
		НачисленнаяЗарплата);		
	
КонецПроцедуры

Процедура ЗарегистрироватьНачисленныйАванс(Движения, Отказ, Организация, ПериодРегистрации, Начисления = Неопределено, Удержания = Неопределено) Экспорт
	
	ДокументОснование = Движения.ЗарплатаКВыплатеАвансом.Отбор.Регистратор.Значение;
	НачисленнаяЗарплата = ТаблицаНачисленнойЗарплатыДляРегистрации(Начисления, Удержания, Организация, ДокументОснование);
	
	ЗарегистрироватьНачисленнуюЗарплатуВЗарплатеКВыплате(
		Движения.ЗарплатаКВыплатеАвансом, 
		ПериодРегистрации, 
		НачисленнаяЗарплата);
	
КонецПроцедуры

Процедура ЗарегистрироватьВыплаченнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата) Экспорт
	
	ЗарегистрироватьВыплаченнуюЗарплатуВЗарплатаКВыплате(Движения.ЗарплатаКВыплате, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата);
	ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетах(Движения.ВзаиморасчетыССотрудниками, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата);

	// авансовую выплату учитываем и в зарплате к выплате авансом
	Если ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
		ЗарегистрироватьВыплаченнуюЗарплатуВЗарплатаКВыплате(Движения.ЗарплатаКВыплатеАвансом, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата)
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьВыданнуюЗарплату(Движения, Отказ, Организация, ДатаОперации, Зарплата, ПорядокВыплаты) Экспорт
	
	ВидВзаиморасчетов = ВзаиморасчетыССотрудниками.ВидВзаиморасчетовССотрудникамиПоХарактеруВыплатыЗарплаты(ПорядокВыплаты);
	Для Каждого СтрокаЗарплаты Из Зарплата Цикл
		Запись = Движения.БухгалтерскиеВзаиморасчетыССотрудниками.ДобавитьРасход();
		
		ЗаполнитьЗначенияСвойств(Запись, СтрокаЗарплаты);
		Запись.Организация = Организация;
		Запись.Период      = ДатаОперации;
		Запись.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Выплачено;
		Запись.СуммаВзаиморасчетов = СтрокаЗарплаты.Сумма;
		Запись.ВидВзаиморасчетов   = ВидВзаиморасчетов;
		
		Движения.БухгалтерскиеВзаиморасчетыССотрудниками.Записывать = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗарплатаКВыплате

Процедура СоздатьВТЗарплатаКВыплате(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники) Экспорт
	
	Если Параметры.СпособПолучения  = Перечисления.СпособыПолученияЗарплатыКВыплате.Аванс Тогда 
		СоздатьВТЗарплатаКВыплатеАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники);
	ИначеЕсли Параметры.СпособПолучения  = Перечисления.СпособыПолученияЗарплатыКВыплате.ОкончательныйРасчет Тогда 	
		СоздатьВТЗарплатаКВыплатеЗарплата(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники);
	Иначе
		ВызватьИсключение(НСтр("ru = 'Недопустимый способ получения зарплаты к выплате.'"));	
	КонецЕсли;	
	
КонецПроцедуры	

Процедура СоздатьВТПлановыйАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники, КадровыеДанные) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Дата", Параметры.Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сотрудники.Сотрудник,
	|	&Дата КАК Период
	|ПОМЕСТИТЬ ВТСотрудникиИПериод
	|ИЗ
	|	#ВТСотрудники КАК Сотрудники";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
		
	Запрос.Выполнить();
	
	// Получаем кадровые данные сотрудников.
	ОписательВТ = 
		КадровыйУчет.ОписательВременныхТаблицДляСоздатьВТКадровыеДанныеСотрудников(
			МенеджерВременныхТаблиц,
			"ВТСотрудникиИПериод");
	КадровыйУчет.СоздатьВТКадровыеДанныеСотрудников(
		ОписательВТ, ТолькоРазрешенные, "Подразделение, ФОТ, СпособРасчетаАванса, Аванс" + ?(ПустаяСтрока(КадровыеДанные), "", "," + КадровыеДанные));
		
	СтатьиРасходов = ЗарплатаКадры.СтатьиРасходовПоСпособамРасчетовСФизическимиЛицами();
	Запрос.УстановитьПараметр("ОплатаТруда", СтатьиРасходов[Перечисления.СпособыРасчетовСФизическимиЛицами.ОплатаТруда]);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сотрудники.Сотрудник КАК Сотрудник,
	|	Сотрудники.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	КадровыеДанныеСотрудников.Подразделение,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка) КАК СтатьяФинансирования,
	|	&ОплатаТруда КАК СтатьяРасходов,
	|	ВЫБОР
	|		КОГДА КадровыеДанныеСотрудников.СпособРасчетаАванса = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ФиксированнойСуммой)
	|			ТОГДА ЕСТЬNULL(КадровыеДанныеСотрудников.Аванс, 0)
	|		КОГДА КадровыеДанныеСотрудников.СпособРасчетаАванса = ЗНАЧЕНИЕ(Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа)
	|				И ЕСТЬNULL(КадровыеДанныеСотрудников.Аванс, 0) <> 0
	|			ТОГДА ЕСТЬNULL(КадровыеДанныеСотрудников.ФОТ, 0) * КадровыеДанныеСотрудников.Аванс / 100
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СуммаКВыплате
	|ПОМЕСТИТЬ ВТПлановыйАванс
	|ИЗ
	|	#ВТСотрудники КАК Сотрудники
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеСотрудников КАК КадровыеДанныеСотрудников
	|		ПО Сотрудники.Сотрудник = КадровыеДанныеСотрудников.Сотрудник
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТСотрудникиИПериод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ВТКадровыеДанныеСотрудников";
	
	Если Не ПустаяСтрока(КадровыеДанные) Тогда
		
		ТекстПолейКадровыхДанных = "КадровыеДанныеСотрудников.Подразделение,";
		ИменаКадровыхДанных = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(КадровыеДанные, ",", Истина, Истина);
		Для каждого ИмяКадровыхДанных Из ИменаКадровыхДанных Цикл
			
			ТекстПолейКадровыхДанных = ТекстПолейКадровыхДанных + "
				|	КадровыеДанныеСотрудников." + ИмяКадровыхДанных + ",";
			
		КонецЦикла;
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "КадровыеДанныеСотрудников.Подразделение,", ТекстПолейКадровыхДанных);
		
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
КонецПроцедуры	

#КонецОбласти

Функция ВидВзаиморасчетовССотрудникамиПоХарактеруВыплатыЗарплаты(ПорядокВыплаты) Экспорт
	
	Если ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
		ВидВзаиморасчетов = Перечисления.ВидыВзаиморасчетовССотрудниками.ВыплатаАванса
	ИначеЕсли ПорядокВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Зарплата Тогда 	
		ВидВзаиморасчетов = Перечисления.ВидыВзаиморасчетовССотрудниками.ВыплатаЗарплаты
	Иначе
		ВидВзаиморасчетов = Неопределено
	КонецЕсли;
	
	Возврат ВидВзаиморасчетов
	
КонецФункции

// АПК:299-вкл
// АПК:581-вкл

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

/// ЗарегистрироватьНачисленнуюЗарплату

Функция ТаблицаНачисленнойЗарплатыДляРегистрации(Начисления, Удержания, Организация, ДокументОснование)
	
	Таблица = ВзаиморасчетыССотрудниками.НоваяТаблицаНачисленнойЗарплаты();
	
	Таблица.Колонки.Удалить("Сумма");
	Таблица.Колонки.Удалить("СуммаКорректировкиВыплаты");
	Таблица.Колонки.Добавить(
		"СуммаКВыплате",
		Метаданные.РегистрыНакопления.ЗарплатаКВыплате.Ресурсы.СуммаКВыплате.Тип);
	Таблица.Колонки.Добавить(
		"СуммаВзаиморасчетов",
		Метаданные.РегистрыНакопления.ВзаиморасчетыССотрудниками.Ресурсы.СуммаВзаиморасчетов.Тип);
	Таблица.Колонки.Добавить(
		"ГруппаНачисленияУдержанияВыплаты",
		Метаданные.РегистрыНакопления.ВзаиморасчетыССотрудниками.Реквизиты.ГруппаНачисленияУдержанияВыплаты.Тип);
	
	// Перенос исходных данных в результирующую таблицу
	Если Начисления <> НеОпределено Тогда
		Для Каждого Начисление Из Начисления Цикл
			СтрокаТаблицы = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Начисление);
			СтрокаТаблицы.СуммаКВыплате       = Начисление.Сумма + Начисление.СуммаКорректировкиВыплаты;
			СтрокаТаблицы.СуммаВзаиморасчетов = Начисление.Сумма;
			СтрокаТаблицы.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Начислено;
		КонецЦикла;
	КонецЕсли;
	Если Удержания <> НеОпределено Тогда
		Для Каждого Удержание Из Удержания Цикл
			СтрокаТаблицы = Таблица.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, Удержание);
			СтрокаТаблицы.СуммаКВыплате       = -(Удержание.Сумма - Удержание.СуммаКорректировкиВыплаты);
			СтрокаТаблицы.СуммаВзаиморасчетов = - Удержание.Сумма;
			СтрокаТаблицы.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Удержано;
		КонецЦикла;
	КонецЕсли;
	
	// Приведение к основным сотрудникам
	Сотрудники = Таблица.ВыгрузитьКолонку("Сотрудник");
	ГоловныеСотрудники = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Сотрудники, "ГоловнойСотрудник");
	Для Каждого СтрокаТаблицы Из Таблица Цикл
		СтрокаТаблицы.Сотрудник = ГоловныеСотрудники[СтрокаТаблицы.Сотрудник]
	КонецЦикла;
	
	// Свертка результирующей таблицы  
	КолонкиСуммирования = Новый Массив;
	КолонкиСуммирования.Добавить("СуммаКВыплате");
	КолонкиСуммирования.Добавить("СуммаВзаиморасчетов");
	КолонкиГруппировок = Новый Массив;
	Для Каждого Колонка Из Таблица.Колонки Цикл
		Если КолонкиСуммирования.Найти(Колонка.Имя) = Неопределено Тогда
			КолонкиГруппировок.Добавить(Колонка.Имя)
		КонецЕсли	
	КонецЦикла;
	Таблица.Свернуть(
		СтрСоединить(КолонкиГруппировок, ", "),
		СтрСоединить(КолонкиСуммирования, ", "));

	// Заполнение опциональных параметров (организации и документа-основания)
	Таблица.Колонки.ПервичныйРегистратор.Имя = "ДокументОснование";
	Для Каждого Строка Из Таблица Цикл
		Если Не ЗначениеЗаполнено(Строка.ДокументОснование) Тогда
			Строка.ДокументОснование = ДокументОснование;
		КонецЕсли;	
		Если Не ЗначениеЗаполнено(Строка.Организация) Тогда
			Строка.Организация = Организация;
		КонецЕсли;	
	КонецЦикла;	
	
	Возврат Таблица
	
КонецФункции

Процедура ЗарегистрироватьНачисленнуюЗарплатуВЗарплатеКВыплате(НаборЗаписей, ПериодРегистрации, НачисленнаяЗарплата)
	
	Для Каждого Начисление Из НачисленнаяЗарплата Цикл
		Если Начисление.СуммаКВыплате <> 0 Тогда
			ЗарплатаКВыплате = НаборЗаписей.ДобавитьПриход();
			
			ЗаполнитьЗначенияСвойств(ЗарплатаКВыплате, Начисление);
			ЗарплатаКВыплате.Период               = ПериодРегистрации;
			ЗарплатаКВыплате.ПериодВзаиморасчетов = ПериодРегистрации;
			
			НаборЗаписей.Записывать = Истина;
		КонецЕсли	
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьНачисленнуюЗарплатуВоВзаиморасчетах(НаборЗаписей, ПериодРегистрации, НачисленнаяЗарплата)
	
	Для Каждого Начисление Из НачисленнаяЗарплата Цикл
		Если Начисление.СуммаВзаиморасчетов <> 0 Тогда
			Взаиморасчеты = НаборЗаписей.ДобавитьПриход();
					
			ЗаполнитьЗначенияСвойств(Взаиморасчеты, Начисление);
			Взаиморасчеты.Период            = ПериодРегистрации;
			Взаиморасчеты.ВидВзаиморасчетов = Перечисления.ВидыВзаиморасчетовССотрудниками.ПустаяСсылка();
			
			НаборЗаписей.Записывать = Истина;
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

/// ЗарегистрироватьВыплаченнуюЗарплату

Процедура ЗарегистрироватьВыплаченнуюЗарплатуВЗарплатаКВыплате(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата)
	
	Для Каждого СтрокаЗарплаты Из Зарплата Цикл
		Запись = НаборЗаписей.ДобавитьРасход();
		
		ЗаполнитьЗначенияСвойств(Запись, СтрокаЗарплаты);
		Запись.Организация	= Организация;
		Запись.Период		= ПериодРегистрации;
		Запись.СуммаКВыплате= СтрокаЗарплаты.Сумма;
		
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетах(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата)
	
	// Получение переносов задолженности по строкам зарплаты
	ПереносимыеСуммы = ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахПереносимыеСуммы(Зарплата);
	
	// Регистрация выплаты (с учетом переноса задолженности)
	ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахДобавитьВыплату(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата, ПереносимыеСуммы);

	// Регистрация переносов задолженности
	ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахДобавитьПеренос(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата, ПереносимыеСуммы)

КонецПроцедуры

Функция ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахПереносимыеСуммы(Зарплата)
	
	ПереносимыеСуммы = Новый Соответствие;
	Для Каждого СтрокаЗарплаты Из Зарплата Цикл
		ПереносимыеСуммы.Вставить(СтрокаЗарплаты, 0)
	КонецЦикла;	
	
	КолонкаИндексСтроки = Зарплата.Колонки.Добавить("ИндексСтроки", ОбщегоНазначения.ОписаниеТипаЧисло(7));
	Для ИндексСтроки = 0 По Зарплата.Количество() - 1 Цикл
		Зарплата[ИндексСтроки].ИндексСтроки = ИндексСтроки
	КонецЦикла;
	
	// Сопоставление отрицательных сумм с кандидатами на "доноров" для переноса задолженности,
	// с упорядочиванием положительных строк по степени сходства с реципиентом.
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Зарплата", Зарплата);
    Запрос.Текст = 
    "ВЫБРАТЬ
    |	Зарплата.ИндексСтроки,
    |	Зарплата.ФизическоеЛицо,
    |	Зарплата.СтатьяФинансирования,
    |	Зарплата.СтатьяРасходов,
    |	Зарплата.Сотрудник,
    |	Зарплата.Подразделение,
    |	Зарплата.ПериодВзаиморасчетов,
    |	Зарплата.Сумма
    |ПОМЕСТИТЬ ВТЗарплата
    |ИЗ
    |	&Зарплата КАК Зарплата
    |;
    |
    |////////////////////////////////////////////////////////////////////////////////
    |ВЫБРАТЬ
    |	ЗарплатаОтрицательная.ИндексСтроки КАК ИндексОтрицательнойСтроки,
    |	ЗарплатаПоложительная.ИндексСтроки КАК ИндексПоложительнойСтроки
    |ИЗ
    |	ВТЗарплата КАК ЗарплатаОтрицательная
    |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТЗарплата КАК ЗарплатаПоложительная
    |		ПО ЗарплатаОтрицательная.ФизическоеЛицо = ЗарплатаПоложительная.ФизическоеЛицо
    |			И ЗарплатаОтрицательная.СтатьяФинансирования = ЗарплатаПоложительная.СтатьяФинансирования
    |			И ЗарплатаОтрицательная.СтатьяРасходов = ЗарплатаПоложительная.СтатьяРасходов
    |			И (ЗарплатаОтрицательная.Сумма < 0)
    |			И (ЗарплатаПоложительная.Сумма > 0)
    |
    |УПОРЯДОЧИТЬ ПО
    |	ЗарплатаОтрицательная.ФизическоеЛицо,
    |	ИндексОтрицательнойСтроки,
    |	ВЫБОР
    |		КОГДА ЗарплатаОтрицательная.Сотрудник = ЗарплатаПоложительная.Сотрудник
    |			ТОГДА ИСТИНА
    |		ИНАЧЕ ЛОЖЬ
    |	КОНЕЦ УБЫВ,
    |	ВЫБОР
    |		КОГДА ЗарплатаОтрицательная.Подразделение = ЗарплатаПоложительная.Подразделение
    |			ТОГДА ИСТИНА
    |		ИНАЧЕ ЛОЖЬ
    |	КОНЕЦ УБЫВ,
    |	ЗарплатаОтрицательная.Сумма УБЫВ,
    |	ЗарплатаПоложительная.Сумма,
    |	ЗарплатаПоложительная.ИндексСтроки";
	
    Выборка = Запрос.Выполнить().Выбрать();
	
	// формирование переносимых сумм
	
	Пока Выборка.СледующийПоЗначениюПоля("ИндексОтрицательнойСтроки") Цикл
		ОтрицательнаяСтрока = Зарплата[Выборка.ИндексОтрицательнойСтроки];
		Пока Выборка.Следующий() Цикл
			ПоложительнаяСтрока = Зарплата[Выборка.ИндексПоложительнойСтроки];
			ПереносимаяСумма = 
				МИН(
					-ОтрицательнаяСтрока.Сумма + ПереносимыеСуммы[ОтрицательнаяСтрока], 
					 ПоложительнаяСтрока.Сумма - ПереносимыеСуммы[ПоложительнаяСтрока]);
			ПереносимыеСуммы[ОтрицательнаяСтрока] = ПереносимыеСуммы[ОтрицательнаяСтрока] - ПереносимаяСумма;
			ПереносимыеСуммы[ПоложительнаяСтрока] = ПереносимыеСуммы[ПоложительнаяСтрока] + ПереносимаяСумма ;
			Если ОтрицательнаяСтрока.Сумма = ПереносимыеСуммы[ОтрицательнаяСтрока] Тогда 
				Прервать
			КонецЕсли;
		КонецЦикла;    
	КонецЦикла;    
	
	Зарплата.Колонки.Удалить(КолонкаИндексСтроки);
	
	Возврат ПереносимыеСуммы
	
КонецФункции	

Процедура ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахДобавитьВыплату(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата, ПереносимыеСуммы)
	
	ВидВзаиморасчетов = ВзаиморасчетыССотрудниками.ВидВзаиморасчетовССотрудникамиПоХарактеруВыплатыЗарплаты(ПорядокВыплаты);
	Для Каждого СтрокаЗарплаты Из Зарплата Цикл
		Запись = НаборЗаписей.ДобавитьРасход();
		
		ЗаполнитьЗначенияСвойств(Запись, СтрокаЗарплаты);
		Запись.Организация = Организация;
		Запись.Период      = ПериодРегистрации;
		Запись.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Выплачено;
		Запись.СуммаВзаиморасчетов	= СтрокаЗарплаты.Сумма - ПереносимыеСуммы[СтрокаЗарплаты];
		Запись.ВидВзаиморасчетов	= ВидВзаиморасчетов;
		
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьВыплаченнуюЗарплатуВоВзаиморасчетахДобавитьПеренос(НаборЗаписей, Организация, ПериодРегистрации, ПорядокВыплаты, Зарплата, ПереносимыеСуммы)
	
	// Сворачивание переносов задолженности для исключения дублирования строк с противоположными знаками.
	КолонкиГруппировокПереносов = "ФизическоеЛицо, СтатьяФинансирования, СтатьяРасходов, Сотрудник, Подразделение";
	ПереносыЗадолженности = НаборЗаписей.ВыгрузитьКолонки(СтрШаблон("%1, СуммаВзаиморасчетов", КолонкиГруппировокПереносов));
	Для Каждого ПереносимаяСумма Из ПереносимыеСуммы Цикл
		ПереносЗадолженности = ПереносыЗадолженности.Добавить();
		ЗаполнитьЗначенияСвойств(ПереносЗадолженности, ПереносимаяСумма.Ключ);
		ПереносЗадолженности.СуммаВзаиморасчетов = ПереносимаяСумма.Значение;
	КонецЦикла;	
	ПереносыЗадолженности.Свернуть(КолонкиГруппировокПереносов, "СуммаВзаиморасчетов");
	
	// Регистрация переносов задолженности
	Для Каждого СтрокаЗарплаты Из ПереносыЗадолженности Цикл
		Запись = НаборЗаписей.ДобавитьРасход();
		
		ЗаполнитьЗначенияСвойств(Запись, СтрокаЗарплаты);
		Запись.Организация = Организация;
		Запись.Период = ПериодРегистрации;
		Запись.ГруппаНачисленияУдержанияВыплаты = Перечисления.ГруппыНачисленияУдержанияВыплаты.Выплачено;
		Запись.ВидВзаиморасчетов	= Перечисления.ВидыВзаиморасчетовССотрудниками.ПереносЗадолженности;
		
		НаборЗаписей.Записывать = Истина;
	КонецЦикла;
	
КонецПроцедуры

/// СоздатьВТЗарплатаКВыплате

Процедура СоздатьВТЗарплатаКВыплатеАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники) 
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",              Параметры.Организация);
	Запрос.УстановитьПараметр("ПериодРегистрации",        Параметры.ПериодРегистрации);
	Запрос.УстановитьПараметр("СтатьяФинансирования",     Параметры.СтатьяФинансирования);
	Запрос.УстановитьПараметр("СтатьяРасходов",           Параметры.СтатьяРасходов);
	Запрос.УстановитьПараметр("ИгнорируемыеРегистраторы", Параметры.ИгнорируемыеРегистраторы);	
	
	// Получаем размеры плановых авансов сотрудников
	ВзаиморасчетыССотрудниками.СоздатьВТПлановыйАванс(МенеджерВременныхТаблиц, Истина, Параметры, ИмяВТСотрудники);

	// Определяем суммы авансов к выплате
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|	&ПериодРегистрации КАК ПериодВзаиморасчетов,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|	СУММА(ЗарплатаКВыплатеОстатки.СуммаКВыплате) КАК КВыплате
	|ПОМЕСТИТЬ ВТЗарплатаКВыплате
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПлановыйАванс.Сотрудник КАК Сотрудник,
	|		ПлановыйАванс.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ПлановыйАванс.Подразделение КАК Подразделение,
	|		ПлановыйАванс.СтатьяФинансирования КАК СтатьяФинансирования,
	|		ПлановыйАванс.СтатьяРасходов КАК СтатьяРасходов,
	|		НЕОПРЕДЕЛЕНО КАК ДокументОснование,
	|		ПлановыйАванс.СуммаКВыплате КАК СуммаКВыплате
	|	ИЗ
	|		ВТПлановыйАванс КАК ПлановыйАванс
	|	ГДЕ
	|		&ОтборПоСтатьям
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплатеОстатки.Сотрудник,
	|		ЗарплатаКВыплатеОстатки.ФизическоеЛицо,
	|		ЗарплатаКВыплатеОстатки.Подразделение,
	|		ЗарплатаКВыплатеОстатки.СтатьяФинансирования,
	|		ЗарплатаКВыплатеОстатки.СтатьяРасходов,
	|		ЗарплатаКВыплатеОстатки.ДокументОснование,
	|		ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплатеАвансом.Остатки(
	|				КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ),
	|				ПериодВзаиморасчетов = &ПериодРегистрации
	|					И Организация = &Организация
	|					И &ОтборПоСтатьям
	|					И Сотрудник В
	|						(ВЫБРАТЬ
	|							Сотрудники.Сотрудник
	|						ИЗ
	|							#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплате.Сотрудник,
	|		ЗарплатаКВыплате.ФизическоеЛицо,
	|		ЗарплатаКВыплате.Подразделение,
	|		ЗарплатаКВыплате.СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов,
	|		ЗарплатаКВыплате.ДокументОснование,
	|		ВЫБОР
	|			КОГДА ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЗарплатаКВыплате.СуммаКВыплате
	|			ИНАЧЕ ЗарплатаКВыплате.СуммаКВыплате
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплатеАвансом КАК ЗарплатаКВыплате
	|	ГДЕ
	|		ЗарплатаКВыплате.Регистратор В(&ИгнорируемыеРегистраторы)
	|		И ЗарплатаКВыплате.Период < КОНЕЦПЕРИОДА(&ПериодРегистрации, МЕСЯЦ)
	|		И ЗарплатаКВыплате.ПериодВзаиморасчетов = &ПериодРегистрации
	|		И ЗарплатаКВыплате.Организация = &Организация
	|		И &ОтборПоСтатьям
	|		И ЗарплатаКВыплате.Сотрудник В
	|				(ВЫБРАТЬ
	|					Сотрудники.Сотрудник
	|				ИЗ
	|					#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОстатки.Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование
	|
	|ИМЕЮЩИЕ
	|	СУММА(ЗарплатаКВыплатеОстатки.СуммаКВыплате) <> 0";
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"&ОтборПоСтатьям", 
		ВзаиморасчетыССотрудниками.ОтборПоСтатьямЗарплатыКВыплате(Параметры));
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"#ВТСотрудники", 
		ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
	ЗарплатаКадры.УничтожитьВТ(МенеджерВременныхТаблиц, "ВТПлановыйАванс");
	
КонецПроцедуры	

Процедура СоздатьВТЗарплатаКВыплатеЗарплата(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Организация",              Параметры.Организация);
	Запрос.УстановитьПараметр("ПериодВзаиморасчетов",     КонецМесяца(Параметры.ПериодРегистрации));
	Запрос.УстановитьПараметр("СтатьяФинансирования",     Параметры.СтатьяФинансирования);
	Запрос.УстановитьПараметр("СтатьяРасходов",           Параметры.СтатьяРасходов);
	Запрос.УстановитьПараметр("ИгнорируемыеРегистраторы", Параметры.ИгнорируемыеРегистраторы);	
	
	// Остатки сумм к выплате по указанным сотрудникам
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|	ЗарплатаКВыплатеОстатки.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|	СУММА(ЗарплатаКВыплатеОстатки.СуммаКВыплате) КАК КВыплате
	|ПОМЕСТИТЬ ВТЗарплатаКВыплате
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗарплатаКВыплатеОстатки.Сотрудник КАК Сотрудник,
	|		ЗарплатаКВыплатеОстатки.ФизическоеЛицо КАК ФизическоеЛицо,
	|		ЗарплатаКВыплатеОстатки.Подразделение КАК Подразделение,
	|		ЗарплатаКВыплатеОстатки.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|		ЗарплатаКВыплатеОстатки.СтатьяФинансирования КАК СтатьяФинансирования,
	|		ЗарплатаКВыплатеОстатки.СтатьяРасходов КАК СтатьяРасходов,
	|		ЗарплатаКВыплатеОстатки.ДокументОснование КАК ДокументОснование,
	|		ЗарплатаКВыплатеОстатки.СуммаКВыплатеОстаток КАК СуммаКВыплате
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплате.Остатки(
	|				,
	|				ПериодВзаиморасчетов <= &ПериодВзаиморасчетов
	|					И Организация = &Организация
	|					И &ОтборПоСтатьям
	|					И Сотрудник В
	|						(ВЫБРАТЬ
	|							Сотрудники.Сотрудник
	|						ИЗ
	|							#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗарплатаКВыплате.Сотрудник,
	|		ЗарплатаКВыплате.ФизическоеЛицо,
	|		ЗарплатаКВыплате.Подразделение,
	|		ЗарплатаКВыплате.ПериодВзаиморасчетов,
	|		ЗарплатаКВыплате.СтатьяФинансирования,
	|		ЗарплатаКВыплате.СтатьяРасходов,
	|		ЗарплатаКВыплате.ДокументОснование,
	|		ВЫБОР
	|			КОГДА ЗарплатаКВыплате.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЗарплатаКВыплате.СуммаКВыплате
	|			ИНАЧЕ ЗарплатаКВыплате.СуммаКВыплате
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.ЗарплатаКВыплате КАК ЗарплатаКВыплате
	|	ГДЕ
	|		ЗарплатаКВыплате.Регистратор В(&ИгнорируемыеРегистраторы)
	|		И ЗарплатаКВыплате.ПериодВзаиморасчетов <= &ПериодВзаиморасчетов
	|		И ЗарплатаКВыплате.Организация = &Организация
	|		И &ОтборПоСтатьям
	|		И ЗарплатаКВыплате.Сотрудник В
	|				(ВЫБРАТЬ
	|					Сотрудники.Сотрудник
	|				ИЗ
	|					#ВТСотрудники КАК Сотрудники)) КАК ЗарплатаКВыплатеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗарплатаКВыплатеОстатки.Сотрудник,
	|	ЗарплатаКВыплатеОстатки.ФизическоеЛицо,
	|	ЗарплатаКВыплатеОстатки.Подразделение,
	|	ЗарплатаКВыплатеОстатки.ПериодВзаиморасчетов,
	|	ЗарплатаКВыплатеОстатки.СтатьяФинансирования,
	|	ЗарплатаКВыплатеОстатки.СтатьяРасходов,
	|	ЗарплатаКВыплатеОстатки.ДокументОснование";
	Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"&ОтборПоСтатьям", 
		ВзаиморасчетыССотрудниками.ОтборПоСтатьямЗарплатыКВыплате(Параметры));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "#ВТСотрудники", ИмяВТСотрудники);
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти
