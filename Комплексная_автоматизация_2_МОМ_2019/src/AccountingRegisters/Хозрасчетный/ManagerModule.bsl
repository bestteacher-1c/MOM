#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ВыполнитьДопОбработкуПроводок(Проводки) Экспорт
	
	Регистратор = Проводки.Отбор.Регистратор.Значение;
	ДополнительныеСвойства = Проводки.ДополнительныеСвойства;
	
	РассчитатьСуммыУправленческогоУчета(Проводки, Регистратор, ДополнительныеСвойства);
	ОбработатьПроводкиНалоговогоУчета(Проводки, Регистратор, ДополнительныеСвойства);
	ОчиститьНеИспользуемыеСуммы(Проводки);
	ПривестиПустыеЗначенияСубконтоСоставногоТипа(Проводки);
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура РассчитатьСуммыУправленческогоУчета(Проводки, Регистратор, ДополнительныеСвойства) 
	
	ЗначениеСвойства = Неопределено;
	ДополнительныеСвойства.Свойство("РассчитатьСуммыУУ", ЗначениеСвойства);
	РассчитатьСуммыУУ = ?(ЗначениеСвойства = Неопределено, Ложь, ЗначениеСвойства);
	РассчитатьСуммыУУ = РассчитатьСуммыУУ И ПолучитьФункциональнуюОпцию("ВестиУУНаПланеСчетовХозрасчетный");
	
	
	ЗначениеСвойства = Неопределено;
	ДополнительныеСвойства.Свойство("РассчитатьСуммыФО", ЗначениеСвойства);
	РассчитатьСуммыФО = ?(ЗначениеСвойства = Неопределено, Ложь, ЗначениеСвойства);
	РассчитатьСуммыФО = РассчитатьСуммыФО И ПолучитьФункциональнуюОпцию("ВестиУчетНаПланеСчетовХозрасчетныйВВалютеФинОтчетности");
	
	Если НЕ РассчитатьСуммыУУ И НЕ РассчитатьСуммыФО Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачалаУУНаПланеСчетовХозрасчетный = Константы.ДатаНачалаУУНаПланеСчетовХозрасчетный.Получить();
	
	Для Каждого Проводка Из Проводки Цикл
		
		Если РассчитатьСуммыУУ И Проводка.Период >= ДатаНачалаУУНаПланеСчетовХозрасчетный Тогда
			ПараметрыРасчетаСуммыУУ = РеглУчетВыборкиСерверПовтИсп.ПараметрыРасчетаСуммыУУ(Проводка.Период);
			Проводка.СуммаУУ = Проводка[ПараметрыРасчетаСуммыУУ.РесурсИсточник] * ПараметрыРасчетаСуммыУУ.Коэффициент;
		КонецЕсли;
		
		Если РассчитатьСуммыФО Тогда
			ПараметрыРасчетаСуммыФО = РеглУчетВыборкиСерверПовтИсп.ПараметрыРасчетаСуммыФО(Проводка.Период);
			Проводка.СуммаФО = Проводка[ПараметрыРасчетаСуммыФО.РесурсИсточник] * ПараметрыРасчетаСуммыФО.Коэффициент;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьСуммуЕслиЗаполнена(Сумма, КорректируемаяСумма = 0)
	
	// Если сумма не заполнена, то не будем ее менять, чтобы не спровоцировать перезапись фактически неизменного набора.
	// Если сумма заполнена, то ее обнулим за счет корректируемой суммы.
	// Например, это используется, когда важно очистить сумму НУ за счет суммы ПР.
	
	Если Не ЗначениеЗаполнено(Сумма) Тогда // Может быть NULL, если набор редактируется вручную
		Возврат;
	КонецЕсли;
	
	КорректируемаяСумма = КорректируемаяСумма + Сумма;
	
	Сумма = 0;
	
КонецПроцедуры

Процедура ЗаполнитьСуммыНалоговогоУчета(Проводки)
	
	Для Каждого Проводка Из Проводки Цикл
		
		ПериодУчетнойПолитики = НачалоМесяца(Проводка.Период);
		ДанныеУчетнойПолитики = РеглУчетВыборкиСерверПовтИсп.ДанныеУчетнойПолитики(Проводка.Организация, ПериодУчетнойПолитики);
		
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			Продолжить;
		КонецЕсли;
	
		Если Проводка.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СчетДт = Проводка.СчетДт;
		СчетКт = Проводка.СчетКт;
		
		Если БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетУчетаВЭксплуатации(СчетДт)
			ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетУчетаВЭксплуатации(СчетКт) Тогда
			// Налоговые суммы по этим счетам рассчитываются в первичном документе по особым правилам
			Продолжить;
		КонецЕсли;
		
		Если НалоговыйУчет.ЭтоПроводкаПоНачислениюНДС(Проводка) Тогда
			// НДС не учитывается в НУ
			Продолжить;
		КонецЕсли;
		
		Если Не БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетЦелевоеФинансирование(СчетДт) Тогда
			// Налоговые суммы по этим счетам рассчитываются в первичном документе по особым правилам
			СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетДт);
			Если СвойстваСчетаДт.НалоговыйУчет 
				И Проводка.СуммаНУДт = 0 
				И Проводка.СуммаПРДт = 0 
				И Проводка.СуммаВРДт = 0 Тогда
				
				Проводка.СуммаНУДт = Проводка.Сумма;
				
			КонецЕсли;
		КонецЕсли;
		
		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СчетКт);
		Если СвойстваСчетаКт.НалоговыйУчет
			И Проводка.СуммаНУКт = 0
			И Проводка.СуммаПРКт = 0
			И Проводка.СуммаВРКт = 0 Тогда
			
			Проводка.СуммаНУКт = Проводка.Сумма;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете(Проводки)
	
	// Удалим проводки по забалансовым счетам учета доходов и расходов
	ПроводкиКУдалению = Новый Массив;
	Для Каждого Проводка Из Проводки Цикл
		
		СчетДт = Проводка.СчетДт;
		СчетКт = Проводка.СчетКт;
		
		Если БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетЗабалансовогоУчетаДоходов(СчетДт)
 			Или БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетЗабалансовогоУчетаРасходов(СчетКт) Тогда
			// Такие проводки формируем только в этой процедуре
			ПроводкиКУдалению.Добавить(Проводка);
		КонецЕсли;
		
	КонецЦикла;
	
	// Найдем проводки по доходам и расходам, не учитываемым в налоговом учете
	
	ПроводкиПоДоходам = Новый Массив;
	ПроводкиПоРасходам = Новый Массив;
	
	Для Каждого Проводка Из Проводки Цикл
		
		ПериодУчетнойПолитики = НачалоМесяца(Проводка.Период);
		ДанныеУчетнойПолитики = РеглУчетВыборкиСерверПовтИсп.ДанныеУчетнойПолитики(Проводка.Организация, ПериодУчетнойПолитики);

		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль ИЛИ ПроводкиКУдалению.Найти(Проводка) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
	
		Если НалоговыйУчет.ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль(Проводка.СчетКт, Проводка.СубконтоКт) Тогда
			ПроводкиПоДоходам.Добавить(Проводка);
		ИначеЕсли НалоговыйУчет.ЭтоПроводкаРасходыНеУчитываемыеДляНалогаНаПрибыль(Проводка.СчетДт, Проводка.СубконтоДт) Тогда
			ПроводкиПоРасходам.Добавить(Проводка);
		КонецЕсли;
		
	КонецЦикла;
	
	// Обработаем не учитываемые доходы:
	// - обеспечим, чтобы они не отражались в налоговом учете
	// - добавим проводки по забалансовому учету
	
	Для Каждого Проводка Из ПроводкиПоДоходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУКт, Проводка.СуммаПРКт);
		Если НетЗначашихДвиженийВПроводке(Проводка) И ПроводкиКУдалению.Найти(Проводка) = Неопределено Тогда
			ПроводкиКУдалению.Добавить(Проводка);
		КонецЕсли;
		
		СуммаНеУчитываемыхДоходов = Проводка.Сумма - Проводка.СуммаВРДт - Проводка.СуммаПРДт;
		
		Если СуммаНеУчитываемыхДоходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетКт      = БухгалтерскийУчетВызовСервераПовтИсп.СчетДоходыНеУчитываемые();
		НоваяПроводка.СуммаНУКт   = СуммаНеУчитываемыхДоходов;
		
	КонецЦикла;
		
	// Обработаем не учитываемые расходы (также, как и доходы)
	Для Каждого Проводка Из ПроводкиПоРасходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУДт, Проводка.СуммаПРДт);
		Если НетЗначашихДвиженийВПроводке(Проводка) И ПроводкиКУдалению.Найти(Проводка) = Неопределено Тогда
			ПроводкиКУдалению.Добавить(Проводка);
		КонецЕсли;
		
		СуммаНеУчитываемыхРасходов = Проводка.Сумма - Проводка.СуммаВРКт - Проводка.СуммаПРКт;
		
		Если СуммаНеУчитываемыхРасходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если НалоговыйУчет.ОпределитьВнереализационныеДоходыРасходы(Проводка) Тогда
			СчетЗабалансовогоУчета = БухгалтерскийУчетВызовСервераПовтИсп.СчетВнереализационныеРасходыНеУчитываемые();
		ИначеЕсли БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетРасчетыСПерсоналомПоОплатеТруда(Проводка.СчетДт)
					ИЛИ БухгалтерскийУчетВызовСервераПовтИсп.ЭтоСчетРасчетыСПерсоналомПоОплатеТруда(Проводка.СчетКт) Тогда
			СчетЗабалансовогоУчета = БухгалтерскийУчетВызовСервераПовтИсп.СчетВыплатыВпользуФизЛицПоП_1_48();
		Иначе
			СчетЗабалансовогоУчета = БухгалтерскийУчетВызовСервераПовтИсп.СчетДругиеВыплатыПоП_1_48();
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетДт      = СчетЗабалансовогоУчета;
		НоваяПроводка.СуммаНУДт   = СуммаНеУчитываемыхРасходов;
		
	КонецЦикла;
	
	Для Каждого Проводка Из ПроводкиКУдалению Цикл
		Проводки.Удалить(Проводка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОчиститьНеИспользуемыеСуммы(Проводки)
	
	ВестиУУНаПланеСчетовХозрасчетный = ПолучитьФункциональнуюОпцию("ВестиУУНаПланеСчетовХозрасчетный");
	ВестиУчетНаПланеСчетовХозрасчетныйВВалютеФинОтчетности = ПолучитьФункциональнуюОпцию("ВестиУчетНаПланеСчетовХозрасчетныйВВалютеФинОтчетности");
	
	Для Каждого Проводка Из Проводки Цикл
		
		Если НЕ ВестиУУНаПланеСчетовХозрасчетный Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаУУ);
		КонецЕсли;
		
		Если НЕ ВестиУчетНаПланеСчетовХозрасчетныйВВалютеФинОтчетности Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаФО);
		КонецЕсли;
		
		ПериодУчетнойПолитики = НачалоМесяца(Проводка.Период);
		ДанныеУчетнойПолитики = РеглУчетВыборкиСерверПовтИсп.ДанныеУчетнойПолитики(Проводка.Организация, ПериодУчетнойПолитики);
		
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРКт);
			Продолжить;
		КонецЕсли;
	
		// Налог на прибыль уплачивается
		
		Если НЕ ДанныеУчетнойПолитики.ПоддержкаПБУ18 Тогда
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРДт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаПРКт);
			ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаВРКт);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьПроводкиНалоговогоУчета(Проводки, Регистратор, ДополнительныеСвойства)
	
	ПроводкиВведеныПользователем = ЭтоРучноеОтражение(Проводки, Регистратор, ДополнительныеСвойства);
	
	Если ПроводкиВведеныПользователем Тогда
		Возврат;
	КонецЕсли;
	
	СуммыНалоговогоУчетаЗаполнены = // Проводки созданы алгоритмом, который рассчитывает суммы НУ
		ДополнительныеСвойства.Свойство("СуммыНалоговогоУчетаЗаполнены") 
		И ДополнительныеСвойства.СуммыНалоговогоУчетаЗаполнены = Истина;
	
	Если НЕ СуммыНалоговогоУчетаЗаполнены Тогда
		ЗаполнитьСуммыНалоговогоУчета(Проводки);
	КонецЕсли;
	
	ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете(Проводки);
	
КонецПроцедуры

Процедура ПривестиПустыеЗначенияСубконтоСоставногоТипа(Проводки)
	
	КэшВидыСоставныхСубконто = Новый Соответствие;
	
	Для Каждого Проводка Из Проводки Цикл
		
		Для Каждого Субконто Из Проводка.СубконтоДт Цикл
			
			Если НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И Субконто.Значение <> Неопределено 
				И СоставнойТипСубконто(Субконто.Ключ, КэшВидыСоставныхСубконто) Тогда
				Проводка.СубконтоДт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			
		КонецЦикла;
		
		Для Каждого Субконто Из Проводка.СубконтоКт Цикл
			
			Если НЕ ЗначениеЗаполнено(Субконто.Значение) 
				И Субконто.Значение <> Неопределено 
				И СоставнойТипСубконто(Субконто.Ключ, КэшВидыСоставныхСубконто) Тогда
				Проводка.СубконтоКт.Вставить(Субконто.Ключ, Неопределено);
			КонецЕсли;
			
		КонецЦикла;
				
	КонецЦикла;
	
КонецПроцедуры

Функция СоставнойТипСубконто(ВидСубконто, КэшВидыСоставныхСубконто)
	
	Составной = КэшВидыСоставныхСубконто.Получить(ВидСубконто);
	
	Если Составной = Неопределено Тогда
		Составной = ВидСубконто.ТипЗначения.Типы().Количество() > 1;
		КэшВидыСоставныхСубконто.Вставить(ВидСубконто, Составной);
	КонецЕсли;
	
	Возврат Составной;
	
КонецФункции

Функция ЭтоРучноеОтражение(Проводки, Регистратор, ДополнительныеСвойства)
	
	ТипРегистратора = ТипЗнч(Регистратор);
	
	ЭтоРучноеОтражение = 
		(ТипРегистратора = Тип("ДокументСсылка.РегламентнаяОперация"))
		Или (ТипРегистратора = Тип("ДокументСсылка.ОперацияБух"))
		Или ДополнительныеСвойства.Свойство("РучноеОтражение") И ДополнительныеСвойства.РучноеОтражение
		Или (ОбщегоНазначения.ЕстьРеквизитОбъекта("РучнаяКорректировка", Регистратор.Метаданные()) И Регистратор.РучнаяКорректировка);
		
	Возврат ЭтоРучноеОтражение;
	
КонецФункции

Функция НетЗначашихДвиженийВПроводке(Проводка)
	
	Возврат Проводка.Сумма = 0 И Проводка.СуммаУУ = 0 И Проводка.СуммаФО = 0
			И Проводка.СуммаНУДт = 0 И Проводка.СуммаПРДт = 0 И Проводка.СуммаВРДт = 0
			И Проводка.СуммаНУКт = 0 И Проводка.СуммаПРКт = 0 И Проводка.СуммаВРКт = 0
			И Проводка.ВалютнаяСуммаДт = 0 И Проводка.КоличествоДт = 0
			И Проводка.ВалютнаяСуммаКт = 0 И Проводка.КоличествоКт = 0;
	
КонецФункции

#КонецОбласти

#КонецЕсли