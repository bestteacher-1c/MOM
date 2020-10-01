#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Рассчитывает коэффициенты по статистике продаж
//
// Параметры:
//  Параметры		- Структура - содержит настройки расчета коэффициентов
//  АдресХранилища	- Строка - адрес хранилища в которое будут помещен результат проверки.
//
Процедура РассчитатьКоэффициентыПоСтатистикеПродаж(Параметры, АдресХранилища) Экспорт
	
	СхемаКомпоновкиДанных = РегистрыСведений.СезонныеКоэффициенты.ПолучитьМакет("РасчетПоСтатистикеПродаж");
	
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(Параметры.КлючОбщихНастроек, 
		"НастройкиФоновогоЗадания_"+Параметры.УникальныйИдентификатор);
		
	ПользовательскиеНастройки = Неопределено;
	Настройки.Свойство("ПользовательскиеНастройки", ПользовательскиеНастройки);
	
	// Загрузка настроек
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Если ПользовательскиеНастройки <> Неопределено Тогда
		
		КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
		
	КонецЕсли;
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоГода", Дата("00010101"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "НачалоПериода", Параметры.ДатаНачала);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КонецПериода", Параметры.ДатаОкончания);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоЛет", Параметры.КоличествоЛет);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Периодичность", Параметры.Периодичность);
	Если Параметры.Периодичность = Перечисления.Периодичность.День Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоПериодов", 365);
	ИначеЕсли Параметры.Периодичность = Перечисления.Периодичность.Неделя Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоПериодов", 53);
	ИначеЕсли Параметры.Периодичность = Перечисления.Периодичность.Месяц Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоПериодов", 12);
	ИначеЕсли Параметры.Периодичность = Перечисления.Периодичность.Квартал Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоПериодов", 4);
	Иначе
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "КоличествоПериодов", 1);
	КонецЕсли;
	
	Если Настройки.Свойство("ОтборСезонныеГруппы") Тогда
	
		КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(КомпоновщикНастроек, 
			"СезоннаяГруппа", 
			Настройки.ОтборСезонныеГруппы, 
			ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии,,
			Новый Структура("ВПользовательскиеНастройки", Истина));
	
	КонецЕсли; 
	
	Если Параметры.Свойство("ВариантРасчета") Тогда
	
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ВариантРасчета", Параметры.ВариантРасчета);
	
	КонецЕсли;
	
	// Компоновка макета
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновкиДанных = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(),,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Инициализация процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);
	
	// Таблица значений, в которую будет получен результат
	ТаблицаКоэффициентов = Новый ТаблицаЗначений;
	
	// Получение результата
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений.УстановитьОбъект(ТаблицаКоэффициентов);
	ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений.Вывести(ПроцессорКомпоновкиДанных);
	
	ПоместитьВоВременноеХранилище(ТаблицаКоэффициентов, АдресХранилища);
	
	УстановитьПривилегированныйРежим(Истина);
	ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(Параметры.КлючОбщихНастроек, 
		"НастройкиФоновогоЗадания_"+Параметры.УникальныйИдентификатор, Пользователи.ТекущийПользователь());
	
КонецПроцедуры

// изменяет указанный реквизит таблицы на сезонный коэффициент
//
// Параметры:
//  ТаблицаНоменклатуры	- ТаблицаЗначений - Таблица в которой должно содержаться поле "Номенклатура" 
//							и изменяемый реквизит
//  Параметры			- Структура - Дополнительные параметры расчета сезонных коэффициентов.
//
Процедура ИзменитьНаСезонныйКоэффициент(ТаблицаНоменклатуры, Параметры) Экспорт 
	
	ДатаНачала                  = Параметры.ДатаНачала;
	ДатаОкончания               = Параметры.ДатаОкончания;
	ДатаНачалаСдвиг             = Параметры.ДатаНачалаСдвиг;
	ДатаОкончанияСдвиг          = Параметры.ДатаОкончанияСдвиг;
	Периодичность               = Параметры.Периодичность;
	ИспользуетсяСмещениеПериода = Параметры.ИспользуетсяСмещениеПериода;
	СмещениеПериода             = Параметры.СмещениеПериода;
	ИмяПоля                     = Параметры.ИмяПоля;
	Партнер                     = Параметры.Партнер;
	Склад                       = Параметры.Склад;
	РазрядностьОкругления       = Параметры.ТочностьОкругления + 3;
	
	НеобходимоРазбитьНаПериоды = Ложь;
	Если ТаблицаНоменклатуры.Колонки.Найти("Период") = Неопределено Тогда
		
		Периоды = Новый Массив;
		ТекущаяДатаСдвига = ДатаНачалаСдвиг;
		
		Пока Истина Цикл
			
			ТекущаяДатаСдвига = ОбщегоНазначенияУТКлиентСервер.РассчитатьДатуНачалаБлижайшегоПериода(ТекущаяДатаСдвига, Периодичность);
			
			Если ТекущаяДатаСдвига > ДатаОкончанияСдвиг Тогда
				Прервать;
			КонецЕсли; 
			
			Периоды.Добавить(НачалоДня(ТекущаяДатаСдвига));
			ТекущаяДатаСдвига = ТекущаяДатаСдвига + 1;
		
		КонецЦикла; 
		
		Если Периоды.Количество() >= 2 Тогда
			
			НеобходимоРазбитьНаПериоды = Истина;
			
			ТаблицаНоменклатурыСПериодом = ТаблицаНоменклатуры.СкопироватьКолонки();
			ТаблицаНоменклатурыСПериодом.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
			
			Для Каждого СтрокаТаблицы Из ТаблицаНоменклатуры Цикл
				
				Для Каждого ДатаПериода Из Периоды Цикл
					
					СтрокаСПериодом = ТаблицаНоменклатурыСПериодом.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаСПериодом, СтрокаТаблицы);
					СтрокаСПериодом.Период = ДатаПериода;
					
				КонецЦикла; 
				
			КонецЦикла;
			
			ТаблицаНоменклатуры = ТаблицаНоменклатурыСПериодом;
			
		КонецЕсли; 
		
	Иначе
		ТаблицаПериоды = ТаблицаНоменклатуры.Скопировать(,"Период");
		ТаблицаПериоды.Свернуть("Период");
		Периоды = ТаблицаПериоды.ВыгрузитьКолонку("Период")
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	%ПолеПериод%
	|	%ПолеПартнер% КАК Партнер,
	|	%ПолеСклад% КАК Склад,
	|	ТаблицаНоменклатуры.Номенклатура
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	&ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	%ПолеПериодНачало% КАК Период,
	|	%ПолеПериодОкончание% КАК ПериодОкончание,
	|	%ПолеПериодБезСдвигаНачало% КАК ПериодБезСдвига,
	|	%ПолеПериодБезСдвигаОкончание% КАК ПериодБезСдвигаОкончание,
	|	ТаблицаНоменклатуры.Номенклатура,
	|	ТаблицаНоменклатуры.Партнер,
	|	ТаблицаНоменклатуры.Склад,
	| %ПолеСезоннаяГруппаБизнесРегиона% КАК СезоннаяГруппаБизнесРегиона,
	|	СпрНоменклатура.СезоннаяГруппа
	|ПОМЕСТИТЬ СезонныеГруппы
	|ИЗ
	|	ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО ТаблицаНоменклатуры.Номенклатура = СпрНоменклатура.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Партнер,
	|	ВложенныйЗапрос.Склад,
	|	СУММА(ВложенныйЗапрос.Коэффициент) КАК Коэффициент,
	|	СУММА(ВложенныйЗапрос.КоэффициентСдвиг) КАК КоэффициентСдвиг
	|ПОМЕСТИТЬ Коэффициенты
	|ИЗ
	|	(ВЫБРАТЬ
	|		СезонныеГруппы.Период КАК Период,
	|		СезонныеГруппы.Номенклатура КАК Номенклатура,
	|		СезонныеГруппы.Партнер КАК Партнер,
	|		СезонныеГруппы.Склад КАК Склад,
	|		СУММА(СезонныеКоэффициенты.Коэффициент) КАК Коэффициент,
	|		СУММА(0) КАК КоэффициентСдвиг
	|	ИЗ
	|		СезонныеГруппы КАК СезонныеГруппы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СезонныеКоэффициенты КАК СезонныеКоэффициенты
	|			ПО СезонныеГруппы.СезоннаяГруппа = СезонныеКоэффициенты.СезоннаяГруппа
	|				И СезонныеГруппы.СезоннаяГруппаБизнесРегиона = СезонныеКоэффициенты.СезоннаяГруппаБизнесРегиона
	|				И (СезонныеКоэффициенты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День))
	|				И (ВЫБОР
	|					КОГДА ГОД(СезонныеГруппы.ПериодБезСдвига) <> ГОД(СезонныеГруппы.ПериодБезСдвигаОкончание)
	|						ТОГДА СезонныеКоэффициенты.НомерПериода >= 1
	|									И СезонныеКоэффициенты.НомерПериода <= ДЕНЬГОДА(СезонныеГруппы.ПериодБезСдвигаОкончание)
	|								ИЛИ СезонныеКоэффициенты.НомерПериода >= ДЕНЬГОДА(СезонныеГруппы.ПериодБезСдвига)
	|									И СезонныеКоэффициенты.НомерПериода <= 365
	|					ИНАЧЕ СезонныеКоэффициенты.НомерПериода >= ДЕНЬГОДА(СезонныеГруппы.ПериодБезСдвига)
	|							И СезонныеКоэффициенты.НомерПериода <= ДЕНЬГОДА(СезонныеГруппы.ПериодБезСдвигаОкончание)
	|				КОНЕЦ)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СезонныеГруппы.Номенклатура,
	|		СезонныеГруппы.Период,
	|		СезонныеГруппы.Партнер,
	|		СезонныеГруппы.Склад
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СезонныеГруппы.Период,
	|		СезонныеГруппы.Номенклатура,
	|		СезонныеГруппы.Партнер КАК Партнер,
	|		СезонныеГруппы.Склад КАК Склад,
	|		СУММА(0),
	|		СУММА(СезонныеКоэффициенты.Коэффициент)
	|	ИЗ
	|		СезонныеГруппы КАК СезонныеГруппы
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СезонныеКоэффициенты КАК СезонныеКоэффициенты
	|			ПО СезонныеГруппы.СезоннаяГруппа = СезонныеКоэффициенты.СезоннаяГруппа
	|				И СезонныеГруппы.СезоннаяГруппаБизнесРегиона = СезонныеКоэффициенты.СезоннаяГруппаБизнесРегиона
	|				И (СезонныеКоэффициенты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День))
	|				И (ВЫБОР
	|					КОГДА ГОД(СезонныеГруппы.Период) <> ГОД(СезонныеГруппы.ПериодОкончание)
	|						ТОГДА СезонныеКоэффициенты.НомерПериода >= 1
	|									И СезонныеКоэффициенты.НомерПериода <= ДЕНЬГОДА(СезонныеГруппы.ПериодОкончание)
	|								ИЛИ СезонныеКоэффициенты.НомерПериода >= ДЕНЬГОДА(СезонныеГруппы.Период)
	|									И СезонныеКоэффициенты.НомерПериода <= 365
	|					ИНАЧЕ СезонныеКоэффициенты.НомерПериода >= ДЕНЬГОДА(СезонныеГруппы.Период)
	|							И СезонныеКоэффициенты.НомерПериода <= ДЕНЬГОДА(СезонныеГруппы.ПериодОкончание)
	|				КОНЕЦ)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		СезонныеГруппы.Номенклатура,
	|		СезонныеГруппы.Период,
	|		СезонныеГруппы.Партнер,
	|		СезонныеГруппы.Склад) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Период,
	|	ВложенныйЗапрос.Партнер,
	|	ВложенныйЗапрос.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Коэффициенты.Номенклатура КАК Номенклатура,
	|	Коэффициенты.Партнер КАК Партнер,
	|	Коэффициенты.Склад КАК Склад,
	|	СУММА(Коэффициенты.Коэффициент) КАК КоэффициентЗнаменатель
	|ПОМЕСТИТЬ КоэффициентыЗнаменатель
	|ИЗ
	|	Коэффициенты КАК Коэффициенты
	|		
	|		СГРУППИРОВАТЬ ПО
	|			Коэффициенты.Номенклатура,
	|			Коэффициенты.Партнер,
	|			Коэффициенты.Склад
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Коэффициенты.Период КАК Период,
	|	Коэффициенты.Номенклатура КАК Номенклатура,
	|	Коэффициенты.Партнер КАК Партнер,
	|	Коэффициенты.Склад КАК Склад,
	|	Коэффициенты.КоэффициентСдвиг КАК КоэффициентРазбиенияЧислитель,
	|	КоэффициентыЗнаменатель.КоэффициентЗнаменатель КАК КоэффициентРазбиенияЗнаменатель,
	|	ВЫБОР
	|		КОГДА Коэффициенты.Коэффициент = 0
	|			ТОГДА 0
	|		ИНАЧЕ Коэффициенты.КоэффициентСдвиг / Коэффициенты.Коэффициент
	|	КОНЕЦ КАК Коэффициент
	|ИЗ
	|	Коэффициенты КАК Коэффициенты
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоэффициентыЗнаменатель КАК КоэффициентыЗнаменатель
	|		ПО Коэффициенты.Номенклатура = КоэффициентыЗнаменатель.Номенклатура
	|			И Коэффициенты.Партнер = КоэффициентыЗнаменатель.Партнер
	|			И Коэффициенты.Склад = КоэффициентыЗнаменатель.Склад
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Партнер,
	|	Склад,
	|	Период";
	
	
	Запрос.УстановитьПараметр("ТаблицаНоменклатуры",         ТаблицаНоменклатуры);
	Запрос.УстановитьПараметр("Периодичность",               Периодичность);
	Запрос.УстановитьПараметр("ИспользуетсяСмещениеПериода", ИспользуетсяСмещениеПериода);
	Запрос.УстановитьПараметр("СмещениеПериода",             СмещениеПериода);
	
	ЕстьКолонкаПериод  = ТаблицаНоменклатуры.Колонки.Найти("Период")  <> Неопределено;
	ЕстьКолонкаПартнер = ТаблицаНоменклатуры.Колонки.Найти("Партнер") <> Неопределено;
	ЕстьКолонкаСклад   = ТаблицаНоменклатуры.Колонки.Найти("Склад")   <> Неопределено;
	
	Если ЕстьКолонкаПартнер Тогда
		
		ПолеПартнер = "ТаблицаНоменклатуры.Партнер";
		
	Иначе 
		
		ПолеПартнер = "&Партнер";
		Запрос.УстановитьПараметр("Партнер", Партнер);
	
	КонецЕсли; 
	
	Если ЕстьКолонкаСклад Тогда
		
		ПолеСклад = "ТаблицаНоменклатуры.Склад";
		
	Иначе 
		
		ПолеСклад = "&Склад";
		Запрос.УстановитьПараметр("Склад", Склад);
	
	КонецЕсли; 
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесРегионы") Тогда
		
		ПолеСезоннаяГруппаБизнесРегиона = 
		"ВЫБОР
		|		КОГДА НЕ ТаблицаНоменклатуры.Партнер.БизнесРегион.СезоннаяГруппа ЕСТЬ NULL И НЕ ТаблицаНоменклатуры.Партнер.БизнесРегион.СезоннаяГруппа = ЗНАЧЕНИЕ(Справочник.СезонныеГруппыБизнесРегионов.ПустаяСсылка)
		|			ТОГДА ТаблицаНоменклатуры.Партнер.БизнесРегион.СезоннаяГруппа
		|		КОГДА НЕ ТаблицаНоменклатуры.Склад.БизнесРегион.СезоннаяГруппа ЕСТЬ NULL И НЕ ТаблицаНоменклатуры.Склад.БизнесРегион.СезоннаяГруппа = ЗНАЧЕНИЕ(Справочник.СезонныеГруппыБизнесРегионов.ПустаяСсылка)
		|			ТОГДА ТаблицаНоменклатуры.Склад.БизнесРегион.СезоннаяГруппа
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СезонныеГруппыБизнесРегионов.Прочие)
		|КОНЕЦ";
		
	Иначе 
		
		ПолеСезоннаяГруппаБизнесРегиона = "ЗНАЧЕНИЕ(Справочник.СезонныеГруппыБизнесРегионов.Прочие)";
		
	КонецЕсли;
	
	Если ЕстьКолонкаПериод Тогда
		
		ПолеПериод = "ТаблицаНоменклатуры.Период КАК Период,";
		ПолеПериодНачало = "ТаблицаНоменклатуры.Период";
		ПолеПериодОкончание = "ВЫБОР &Периодичность
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, НЕДЕЛЯ)
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ДЕКАДА)
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, МЕСЯЦ)
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, КВАРТАЛ)
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ПОЛУГОДИЕ)
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
		|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ГОД)
		|		ИНАЧЕ КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ДЕНЬ)
		|	КОНЕЦ";
		Если ИспользуетсяСмещениеПериода Тогда
			
			ПолеПериодБезСдвигаНачало = "ВЫБОР &Периодичность
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, НЕДЕЛЯ, &СмещениеПериода), НЕДЕЛЯ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ДЕКАДА, &СмещениеПериода), ДЕКАДА)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, МЕСЯЦ, &СмещениеПериода), МЕСЯЦ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, КВАРТАЛ, &СмещениеПериода), КВАРТАЛ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ПОЛУГОДИЕ, &СмещениеПериода), ПОЛУГОДИЕ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
			|			ТОГДА НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ГОД, &СмещениеПериода), ГОД)
			|		ИНАЧЕ НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ДЕНЬ, &СмещениеПериода), ДЕНЬ)
			|	КОНЕЦ";
		
		Иначе
			ПолеПериодБезСдвигаНачало = "ТаблицаНоменклатуры.Период";
		КонецЕсли; 
		
		Если ИспользуетсяСмещениеПериода Тогда
			
			ПолеПериодБезСдвигаОкончание = "ВЫБОР &Периодичность
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, НЕДЕЛЯ, &СмещениеПериода), НЕДЕЛЯ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ДЕКАДА, &СмещениеПериода), ДЕКАДА)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, МЕСЯЦ, &СмещениеПериода), МЕСЯЦ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, КВАРТАЛ, &СмещениеПериода), КВАРТАЛ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ПОЛУГОДИЕ, &СмещениеПериода), ПОЛУГОДИЕ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
			|			ТОГДА КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ГОД, &СмещениеПериода), ГОД)
			|		ИНАЧЕ КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(ТаблицаНоменклатуры.Период, ДЕНЬ, &СмещениеПериода), ДЕНЬ)
			|	КОНЕЦ";
		
		Иначе
			ПолеПериодБезСдвигаОкончание = "ВЫБОР &Периодичность
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, НЕДЕЛЯ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ДЕКАДА)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, МЕСЯЦ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, КВАРТАЛ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ПОЛУГОДИЕ)
			|		КОГДА ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
			|			ТОГДА КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ГОД)
			|		ИНАЧЕ КОНЕЦПЕРИОДА(ТаблицаНоменклатуры.Период, ДЕНЬ)
			|	КОНЕЦ";
		КонецЕсли;
		
	Иначе
		
		ПолеПериод = "";
		ПолеПериодНачало = "&ДатаНачалаСдвиг";
		ПолеПериодОкончание = "&ДатаОкончанияСдвиг";
		ПолеПериодБезСдвигаНачало = "&ДатаНачала";
		ПолеПериодБезСдвигаОкончание = "&ДатаОкончания";
		
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ДатаНачалаСдвиг", ДатаНачалаСдвиг);
		Запрос.УстановитьПараметр("ДатаОкончанияСдвиг", ДатаОкончанияСдвиг);
		
	КонецЕсли; 
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПериод%",                      ПолеПериод);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПериодНачало%",                ПолеПериодНачало);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПериодОкончание%",             ПолеПериодОкончание);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПериодБезСдвигаНачало%",       ПолеПериодБезСдвигаНачало);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПериодБезСдвигаОкончание%",    ПолеПериодБезСдвигаОкончание);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеПартнер%",                     ПолеПартнер);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеСклад%",                       ПолеСклад);
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ПолеСезоннаяГруппаБизнесРегиона%", ПолеСезоннаяГруппаБизнесРегиона);
	
	Если Периодичность = Перечисления.Периодичность.Месяц Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "СезонныеКоэффициенты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)",
												 "СезонныеКоэффициенты.Периодичность = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДЕНЬГОДА",
												 "МЕСЯЦ");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();

	СезонныеКоэффициенты = РезультатЗапроса.Выгрузить();
	КоличествоПериодов = Периоды.Количество();
	
	ОтборГруппаКоэффицентов = Новый Структура("Номенклатура", Неопределено);
	Если ЕстьКолонкаПартнер Тогда
		ОтборГруппаКоэффицентов.Вставить("Партнер", Неопределено);
	КонецЕсли;
	Если ЕстьКолонкаСклад Тогда
		ОтборГруппаКоэффицентов.Вставить("Склад", Неопределено);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаНоменклатуры Цикл
		
		Если ОтборГруппаКоэффицентов.Номенклатура <> СтрокаТЧ.Номенклатура
			Или (ЕстьКолонкаПартнер И ОтборГруппаКоэффицентов.Партнер <> СтрокаТЧ.Партнер)
			Или (ЕстьКолонкаСклад И ОтборГруппаКоэффицентов.Склад <> СтрокаТЧ.Склад) Тогда
			
			ОтборГруппаКоэффицентов.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
			Если ЕстьКолонкаПартнер Тогда
				ОтборГруппаКоэффицентов.Вставить("Партнер", СтрокаТЧ.Партнер);
			КонецЕсли;
			Если ЕстьКолонкаСклад Тогда
				ОтборГруппаКоэффицентов.Вставить("Склад", СтрокаТЧ.Склад);
			КонецЕсли;
			                     
			ГруппаСезонныхКоэффицентов = СезонныеКоэффициенты.НайтиСтроки(ОтборГруппаКоэффицентов);
			
			Коэффициенты = Новый Массив();
			Если ГруппаСезонныхКоэффицентов.Количество() > 0 Тогда
				Для Каждого СезонныйКоэффициент Из ГруппаСезонныхКоэффицентов Цикл
					Коэффициенты.Добавить(СезонныйКоэффициент.КоэффициентРазбиенияЧислитель);	
				КонецЦикла;
			Иначе
				Для Каждого Период Из Периоды Цикл
					Коэффициенты.Добавить(1);	
				КонецЦикла;
			КонецЕсли;
				
			КоличествоРаспределения = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
				СтрокаТЧ[ИмяПоля], 
				Коэффициенты,
				3 + Параметры.ТочностьОкругления);
				
			СоответствиеПериодКоличествоРаспределения = Новый Соответствие;
			Индекс = 0;
			Если ГруппаСезонныхКоэффицентов.Количество() > 0 Тогда
				Для Каждого СезонныйКоэффициент Из ГруппаСезонныхКоэффицентов Цикл
					СоответствиеПериодКоличествоРаспределения.Вставить(СезонныйКоэффициент.Период, КоличествоРаспределения[Индекс]);
					Индекс = Индекс + 1;
				КонецЦикла;
			Иначе
				Для Каждого Период Из Периоды Цикл
					СоответствиеПериодКоличествоРаспределения.Вставить(Период, КоличествоРаспределения[Индекс]);
					Индекс = Индекс + 1;
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
		
		Отбор = Новый Структура;
		Отбор.Вставить("Номенклатура", СтрокаТЧ.Номенклатура);
		
		Если ЕстьКолонкаПериод Тогда
			Отбор.Вставить("Период", СтрокаТЧ.Период);
		КонецЕсли; 
		Если ЕстьКолонкаПартнер Тогда
			Отбор.Вставить("Партнер", СтрокаТЧ.Партнер);
		КонецЕсли;
		Если ЕстьКолонкаСклад Тогда
			Отбор.Вставить("Склад", СтрокаТЧ.Склад);
		КонецЕсли;
		
		НайденныеСтроки = СезонныеКоэффициенты.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			
			Если НеобходимоРазбитьНаПериоды Тогда
				
				Если НайденныеСтроки[0].КоэффициентРазбиенияЗнаменатель = null ИЛИ НайденныеСтроки[0].КоэффициентРазбиенияЗнаменатель = 0 Тогда
					СтрокаТЧ[ИмяПоля] = 0;
				Иначе 
									
					СтрокаТЧ[ИмяПоля] = СоответствиеПериодКоличествоРаспределения.Получить(СтрокаТЧ.Период);
					
				КонецЕсли; 
				
			Иначе 
				
				СтрокаТЧ[ИмяПоля] = СтрокаТЧ[ИмяПоля] * НайденныеСтроки[0].Коэффициент;
				
			КонецЕсли; 
			
		ИначеЕсли НеобходимоРазбитьНаПериоды Тогда
			
			СтрокаТЧ[ИмяПоля] = СоответствиеПериодКоличествоРаспределения.Получить(СтрокаТЧ.Период);
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры
 

#КонецОбласти

#КонецЕсли