
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // возврат при получении формы для анализа
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры,
		"Организация, АдресНачисленийВХранилище, ХозяйственнаяОперация, ДатаНачала, ДатаОкончания, Регистратор, ИдентификаторФормыДокумента");
	
	УстановитьПараметрыВыбораДоговора();
	
	ПартнерыИКонтрагенты.ЗаголовокЭлементаПартнерВЗависимостиОтХозяйственнойОперации( ЭтотОбъект, "Партнер", ХозяйственнаяОперация);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ПартнерПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйПриИзменении(Элемент)
	
	УстановитьПараметрыВыбораДоговора();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	НачисленияСервер();
	
	Структура = Новый Структура("АдресНачисленийВХранилище", АдресНачисленийВХранилище);
	ОповеститьОВыборе(Структура);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Функция УстановитьПараметрыВыбораДоговора()
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Организация));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления", Ложь));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ХарактерДоговора",
		Справочники.ДоговорыКредитовИДепозитов.ХарактерДоговораПоОперации(ХозяйственнаяОперация)));
		
	Если Не Партнер.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Партнер", Партнер));
	КонецЕсли;
	Если Не Контрагент.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Контрагент));
	КонецЕсли;
	Если Не Ответственный.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Ответственный", Ответственный));
	КонецЕсли;
	
	Элементы.ДоговорКредитаДепозита.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервере
Функция ТекстЗапросаПоНачислениям()
	
	Возврат 
	"ВЫБРАТЬ
	|	ГрафикНачислений.Период,
	|	ВариантыГрафиков.Владелец КАК Договор,
	|	ГрафикНачислений.ВариантГрафика,
	|	ГрафикНачислений.Проценты,
	|	ГрафикНачислений.Комиссия
	|ПОМЕСТИТЬ НачисленияПоДоговорам
	|ИЗ
	|	РегистрСведений.ГрафикНачисленийКредитовИДепозитов КАК ГрафикНачислений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыГрафиковКредитовИДепозитов КАК ВариантыГрафиков
	|		ПО ГрафикНачислений.ВариантГрафика = ВариантыГрафиков.Ссылка
	|ГДЕ
	|	ГрафикНачислений.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И ВариантыГрафиков.Используется
	|	И НЕ ВариантыГрафиков.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НачисленияПоДоговорам.Период,
	|	ДоговорыКредитовИДепозитов.Организация,
	|	ДоговорыКредитовИДепозитов.Партнер,
	|	ДоговорыКредитовИДепозитов.Контрагент,
	|	НачисленияПоДоговорам.Договор,
	|	НачисленияПоДоговорам.ВариантГрафика,
	|	НачисленияПоДоговорам.Проценты,
	|	НачисленияПоДоговорам.Комиссия,
	|	ДоговорыКредитовИДепозитов.СтатьяДоходовРасходовПроцентов КАК СтатьяПроцентов,
	|	ДоговорыКредитовИДепозитов.СтатьяДоходовРасходовКомиссии КАК СтатьяКомиссии,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов,
	|	ДоговорыКредитовИДепозитов.ХарактерДоговора
	|ПОМЕСТИТЬ ТекущиеНачисления
	|ИЗ
	|	НачисленияПоДоговорам КАК НачисленияПоДоговорам
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|		ПО НачисленияПоДоговорам.Договор = ДоговорыКредитовИДепозитов.Ссылка
	|ГДЕ
	|	НЕ ДоговорыКредитовИДепозитов.ПометкаУдаления
	|	И ДоговорыКредитовИДепозитов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И ДоговорыКредитовИДепозитов.Организация = &Организация
	|	И ДоговорыКредитовИДепозитов.ХарактерДоговора = &ХарактерДоговора
	|{ГДЕ
	|	ДоговорыКредитовИДепозитов.Партнер.*,
	|	ДоговорыКредитовИДепозитов.Контрагент.*,
	|	НачисленияПоДоговорам.Договор.*,
	|	ДоговорыКредитовИДепозитов.Ответственный.*}
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоФинансовымИнструментам.Период,
	|	РасчетыПоФинансовымИнструментам.АналитикаУчетаПоПартнерам,
	|	КлючиАналитикиУчетаПоПартнерам.Организация,
	|	КлючиАналитикиУчетаПоПартнерам.Партнер,
	|	КлючиАналитикиУчетаПоПартнерам.Контрагент,
	|	РасчетыПоФинансовымИнструментам.Договор,
	|	РасчетыПоФинансовымИнструментам.Сумма КАК Проценты,
	|	0 КАК Комиссия,
	|	РасчетыПоФинансовымИнструментам.ТипГрафика,
	|	РасчетыПоФинансовымИнструментам.ТипСуммы,
	|	РасчетыПоФинансовымИнструментам.СтатьяАналитики
	|ПОМЕСТИТЬ РасчетыПоКредитамДепозитам
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам КАК РасчетыПоФинансовымИнструментам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикиУчетаПоПартнерам
	|		ПО РасчетыПоФинансовымИнструментам.АналитикаУчетаПоПартнерам = КлючиАналитикиУчетаПоПартнерам.КлючАналитики
	|ГДЕ
	|	РасчетыПоФинансовымИнструментам.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И РасчетыПоФинансовымИнструментам.ТипГрафика = ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Начисления)
	|	И КлючиАналитикиУчетаПоПартнерам.Организация = &Организация
	|	И РасчетыПоФинансовымИнструментам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты)
	|	И РасчетыПоФинансовымИнструментам.Регистратор <> &Регистратор
	|{ГДЕ
	|	КлючиАналитикиУчетаПоПартнерам.Партнер.*,
	|	КлючиАналитикиУчетаПоПартнерам.Контрагент.*,
	|	РасчетыПоФинансовымИнструментам.Договор.*,
	|	РасчетыПоФинансовымИнструментам.Договор.Ответственный.* КАК Ответственный}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РасчетыПоФинансовымИнструментам.Период,
	|	РасчетыПоФинансовымИнструментам.АналитикаУчетаПоПартнерам,
	|	КлючиАналитикиУчетаПоПартнерам.Организация,
	|	КлючиАналитикиУчетаПоПартнерам.Партнер,
	|	КлючиАналитикиУчетаПоПартнерам.Контрагент,
	|	РасчетыПоФинансовымИнструментам.Договор,
	|	0,
	|	РасчетыПоФинансовымИнструментам.Сумма,
	|	РасчетыПоФинансовымИнструментам.ТипГрафика,
	|	РасчетыПоФинансовымИнструментам.ТипСуммы,
	|	РасчетыПоФинансовымИнструментам.СтатьяАналитики
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам КАК РасчетыПоФинансовымИнструментам
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикиУчетаПоПартнерам
	|		ПО РасчетыПоФинансовымИнструментам.АналитикаУчетаПоПартнерам = КлючиАналитикиУчетаПоПартнерам.КлючАналитики
	|ГДЕ
	|	РасчетыПоФинансовымИнструментам.Период МЕЖДУ &ДатаНачала И &ДатаОкончания
	|	И РасчетыПоФинансовымИнструментам.ТипГрафика = ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Начисления)
	|	И КлючиАналитикиУчетаПоПартнерам.Организация = &Организация
	|	И РасчетыПоФинансовымИнструментам.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия)
	|	И РасчетыПоФинансовымИнструментам.Регистратор <> &Регистратор
	|{ГДЕ
	|	КлючиАналитикиУчетаПоПартнерам.Партнер.*,
	|	КлючиАналитикиУчетаПоПартнерам.Контрагент.*,
	|	РасчетыПоФинансовымИнструментам.Договор.*,
	|	РасчетыПоФинансовымИнструментам.Договор.Ответственный.* КАК Ответственный}
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыПоКредитамДепозитам.Период КАК Период,
	|	РасчетыПоКредитамДепозитам.АналитикаУчетаПоПартнерам,
	|	РасчетыПоКредитамДепозитам.Организация,
	|	РасчетыПоКредитамДепозитам.Партнер,
	|	РасчетыПоКредитамДепозитам.Контрагент,
	|	РасчетыПоКредитамДепозитам.Договор,
	|	РасчетыПоКредитамДепозитам.ТипГрафика
	|ПОМЕСТИТЬ ПредыдущиеНачисления
	|ИЗ
	|	РасчетыПоКредитамДепозитам КАК РасчетыПоКредитамДепозитам
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыПоКредитамДепозитам.Период,
	|	РасчетыПоКредитамДепозитам.АналитикаУчетаПоПартнерам,
	|	РасчетыПоКредитамДепозитам.Организация,
	|	РасчетыПоКредитамДепозитам.Партнер,
	|	РасчетыПоКредитамДепозитам.Контрагент,
	|	РасчетыПоКредитамДепозитам.Договор,
	|	РасчетыПоКредитамДепозитам.ТипГрафика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекущиеНачисления.Период КАК Дата,
	|	ТекущиеНачисления.Организация,
	|	ТекущиеНачисления.Партнер,
	|	ТекущиеНачисления.Контрагент,
	|	ТекущиеНачисления.Договор,
	|	ТекущиеНачисления.Договор.Подразделение КАК Подразделение,
	|	ТекущиеНачисления.Договор.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТекущиеНачисления.ВариантГрафика,
	|	ТекущиеНачисления.Проценты,
	|	ТекущиеНачисления.Комиссия,
	|	ТекущиеНачисления.СтатьяПроцентов,
	|	ТекущиеНачисления.СтатьяКомиссии,
	|	ТекущиеНачисления.ВалютаВзаиморасчетов,
	|	ПредыдущиеНачисления.Период КАК ПериодНачислено,
	|	ТекущиеНачисления.ХарактерДоговора
	|ИЗ
	|	ТекущиеНачисления КАК ТекущиеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПредыдущиеНачисления КАК ПредыдущиеНачисления
	|		ПО ТекущиеНачисления.Период = ПредыдущиеНачисления.Период
	|			И ТекущиеНачисления.Контрагент = ПредыдущиеНачисления.Контрагент
	|			И ТекущиеНачисления.Договор = ПредыдущиеНачисления.Договор
	|ГДЕ
	|	ПредыдущиеНачисления.Период ЕСТЬ NULL ";
	
КонецФункции

&НаСервере
Процедура НачисленияСервер()
	
	// Получим таблицу начислений по графику
	ПостроительЗапроса = Новый ПостроительЗапроса(ТекстЗапросаПоНачислениям());
	ПостроительЗапроса.Параметры.Вставить("ДатаНачала", ДатаНачала);
	ПостроительЗапроса.Параметры.Вставить("ДатаОкончания", ДатаОкончания);
	ПостроительЗапроса.Параметры.Вставить("Организация", Организация);
	ПостроительЗапроса.Параметры.Вставить("Регистратор", Регистратор);
	ПостроительЗапроса.Параметры.Вставить("ХарактерДоговора",
		Справочники.ДоговорыКредитовИДепозитов.ХарактерДоговораПоОперации(ХозяйственнаяОперация));
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Партнер");
		НовыйОтбор.Установить(Партнер);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Контрагент");
		НовыйОтбор.Установить(Контрагент);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДоговорКредитаДепозита) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Договор");
		НовыйОтбор.Установить(ДоговорКредитаДепозита);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ответственный) Тогда
		НовыйОтбор = ПостроительЗапроса.Отбор.Добавить("Ответственный");
		НовыйОтбор.Установить(Ответственный);
	КонецЕсли;
	
	ПостроительЗапроса.Выполнить();
	НачисленияГрафика = ПостроительЗапроса.Результат.Выгрузить();
	Начисления = НачисленияГрафика.СкопироватьКолонки("Дата,Партнер,Контрагент,Договор,Подразделение,НаправлениеДеятельности,ВалютаВзаиморасчетов");
	
	МассивТипов = Новый Массив();
	Начисления.Колонки.Добавить("СтатьяДоходовРасходов",Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов,ПланВидовХарактеристикСсылка.СтатьиРасходов"));
	Начисления.Колонки.Добавить("ТипСуммыГрафика",Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСуммГрафикаКредитовИДепозитов"));
	Начисления.Колонки.Добавить("Сумма",ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	Начисления.Колонки.Добавить("СуммаВзаиморасчетов",ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	
	// Перенесем таблицу начислений по графику в табличную часть документа
	НеЗаполненныеДоговора = Новый Соответствие;
	ПустаяСтатьяДоходов = ПланыВидовХарактеристик.СтатьиДоходов.ПустаяСсылка();
	ПустаяСтатьяРасходов = ПланыВидовХарактеристик.СтатьиРасходов.ПустаяСсылка();
	
	КурсРегл = РаботаСКурсамиВалют.ПолучитьКурсВалюты(Константы.ВалютаРегламентированногоУчета.Получить(), ДатаОкончания);
	Для Каждого Стр Из НачисленияГрафика Цикл
		
		Если Стр.Проценты + Стр.Комиссия = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Стр.Проценты > 0 Тогда
			
			НоваяСтрока = Начисления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			НоваяСтрока.СтатьяДоходовРасходов = Стр.СтатьяПроцентов;
			НоваяСтрока.ТипСуммыГрафика = Перечисления.ТипыСуммГрафикаКредитовИДепозитов.Проценты;
			НоваяСтрока.СуммаВзаиморасчетов = Стр.Проценты;
			
		КонецЕсли;// есть проценты
		
		Если Стр.Комиссия > 0 Тогда
			
			НоваяСтрока = Начисления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Стр);
			НоваяСтрока.СтатьяДоходовРасходов = Стр.СтатьяКомиссии;
			НоваяСтрока.ТипСуммыГрафика = Перечисления.ТипыСуммГрафикаКредитовИДепозитов.Комиссия;
			НоваяСтрока.СуммаВзаиморасчетов = Стр.Комиссия;
			
		КонецЕсли;// есть комисия
		
	КонецЦикла;// по графику начислений
	
	АдресНачисленийВХранилище = ПоместитьВоВременноеХранилище(Начисления, УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент);
	УстановитьПараметрыВыбораДоговора();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
