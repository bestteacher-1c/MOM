#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

Функция ДокументыОписи(Опись, ТипСведенийСЗВ = Неопределено, СписокКорректируемыхПериодов = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Опись);
	Запрос.УстановитьПараметр("ТипСведений", ТипСведенийСЗВ);
	Запрос.УстановитьПараметр("СписокКорректируемыхПериодов", СписокКорректируемыхПериодов);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.ПачкаДокументов КАК Ссылка
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК КомплектыОтчетностиПерсУчетаСписокПачекСЗВ
	|ГДЕ
	|	КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.Ссылка = &Ссылка
	|	И &Условие";
	
	СтрокаУсловие = "";
	Если ТипСведенийСЗВ <> Неопределено Тогда
		СтрокаУсловие = СтрокаУсловие + " И КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.ПачкаДокументов.ТипСведенийСЗВ = &ТипСведений";
	КонецЕсли;
	
	Если СписокКорректируемыхПериодов <> Неопределено Тогда 
		СтрокаУсловие = СтрокаУсловие + " И КомплектыОтчетностиПерсУчетаСписокПачекСЗВ.ПачкаДокументов.КорректируемыйПериод В (&СписокКорректируемыхПериодов)";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &Условие", СтрокаУсловие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивСсылок = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		МассивСсылок.Добавить(Выборка.Ссылка);		
	КонецЦикла;	
	
	Возврат МассивСсылок;
	
КонецФункции		

Функция НовыйОписьАДВ(Организация, ОтчетныйПериод) Экспорт
	ОписьОбъект = СоздатьДокумент();
	ОписьОбъект.УстановитьСсылкуНового(ПолучитьСсылку());
	ОписьОбъект.ОтчетныйПериод = ОтчетныйПериод;
	ОписьОбъект.Организация = Организация;
	ОписьОбъект.Дата = ТекущаяДатаСеанса();
	ПерсонифицированныйУчет.ПроставитьНомерПачки(ОписьОбъект);
	ОписьОбъект.УстановитьНовыйНомер();
	ПерсонифицированныйУчет.ДокументыКвартальнойОтчетностиЗаполнитьОтветственныхЛиц(ОписьОбъект);
	
	Возврат ОписьОбъект;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции получения данных для заполнения и проведения документа.

Функция СформироватьЗапросПоШапкеДокумента(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	
	ДанныеДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Дата, Руководитель");
	
	МассивНеобходимыхДанных = Новый Массив;
	МассивНеобходимыхДанных.Добавить("ИОФамилия");
	
	КадровыйУчет.СоздатьНаДатуВТКадровыеДанныеФизическихЛиц(Запрос.МенеджерВременныхТаблиц, Истина, ДанныеДокумента.Руководитель, МассивНеобходимыхДанных, ДанныеДокумента.Дата);
	
	ОписаниеИсточникаДанных = ПерсонифицированныйУчет.ОписаниеИсточникаДанныхДляСоздатьВТСведенияОбОрганизациях();
	ОписаниеИсточникаДанных.ИмяТаблицы = "Документ.ОписьПачекСЗВ_6";
	ОписаниеИсточникаДанных.ИмяПоляОрганизация = "Организация";
	ОписаниеИсточникаДанных.ИмяПоляПериод = "ОкончаниеОтчетногоПериода";
	ОписаниеИсточникаДанных.СписокСсылок = Ссылка;

	ПерсонифицированныйУчет.СоздатьВТСведенияОбОрганизацияхПоОписаниюДокументаИсточникаДанных(Запрос.МенеджерВременныхТаблиц, ОписаниеИсточникаДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пачки.ПачкаДокументов КАК Документ
	|ПОМЕСТИТЬ ВТДокументыСЗВ
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК Пачки
	|ГДЕ
	|	Пачки.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(ФормыСЗВ.КоличествоФизлиц) КАК КоличествоФизлиц,
	|	СУММА(ФормыСЗВ.КоличествоИсходных) КАК КоличествоИсходных,
	|	СУММА(ФормыСЗВ.КоличествоКорректирующих) КАК КоличествоКорректирующих,
	|	СУММА(ФормыСЗВ.НачисленоСтраховаяИсходных) КАК НачисленоСтраховаяИсходных,
	|	СУММА(ФормыСЗВ.НачисленоСтраховаяКорректирующих) КАК НачисленоСтраховаяКорректирующих,
	|	СУММА(ФормыСЗВ.НачисленоНакопительнаяИсходных) КАК НачисленоНакопительнаяИсходных,
	|	СУММА(ФормыСЗВ.НачисленоНакопительнаяКорректирующих) КАК НачисленоНакопительнаяКорректирующих,
	|	СУММА(ФормыСЗВ.УплаченоСтраховая) КАК УплаченоСтраховая,
	|	СУММА(ФормыСЗВ.УплаченоНакопительная) КАК УплаченоНакопительная
	|ПОМЕСТИТЬ ВТКоличествоФизлиц
	|ИЗ
	|	(ВЫБРАТЬ
	|		ФормыСЗВ6_1.Сотрудник КАК КоличествоФизлиц,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК КоличествоИсходных,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ КАК КоличествоКорректирующих,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_1.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НачисленоСтраховаяИсходных,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_1.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НачисленоСтраховаяКорректирующих,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_1.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НачисленоНакопительнаяИсходных,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_1.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК НачисленоНакопительнаяКорректирующих,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_1.УплаченоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК УплаченоСтраховая,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_1.УплаченоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК УплаченоНакопительная
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК ФормыСЗВ6_1
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_1.Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ФормыСЗВ6_4.Сотрудник,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_4.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_4.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_4.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_4.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_4.УплаченоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_4.УплаченоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_4.Сотрудники КАК ФормыСЗВ6_4
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_4.Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ФормыСЗВ6_2.Сотрудник,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_2.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_2.НачисленоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_2.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ)
	|				ТОГДА ФормыСЗВ6_2.НачисленоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_2.УплаченоСтраховая
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА ФормыСЗВ6_2.УплаченоНакопительная
	|			ИНАЧЕ 0
	|		КОНЕЦ
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеестрСЗВ_6_2.Сотрудники КАК ФормыСЗВ6_2
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_2.Ссылка) КАК ФормыСЗВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(ВЫБОР
	|			КОГДА ДокументыСЗВ.Документ.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 0
	|			ИНАЧЕ 1
	|		КОНЕЦ) КАК КоличествоКорректирующих,
	|	СУММА(ВЫБОР
	|			КОГДА ДокументыСЗВ.Документ.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоИсходных
	|ПОМЕСТИТЬ ВТКоличествоПачек
	|ИЗ
	|	ВТДокументыСЗВ КАК ДокументыСЗВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Док.Номер,
	|	Док.Дата,
	|	Док.Организация,
	|	СведенияОбОрганизациях.ЮридическоеФизическоеЛицо КАК ЮридическоеФизическоеЛицо,
	|	СведенияОбОрганизациях.ОГРН,
	|	СведенияОбОрганизациях.НаименованиеПолное КАК НаименованиеПолное,
	|	СведенияОбОрганизациях.НаименованиеСокращенное КАК НаименованиеСокращенное,
	|	СведенияОбОрганизациях.Наименование,
	|	СведенияОбОрганизациях.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СведенияОбОрганизациях.КодПоОКПО,
	|	СведенияОбОрганизациях.ИНН,
	|	СведенияОбОрганизациях.КПП,
	|	СведенияОбОрганизациях.КодПоОКПО КАК ОКПО,
	|	ГОД(Док.Дата) КАК Год,
	|	Док.Ответственный,
	|	Док.Комментарий,
	|	Док.ДолжностьРуководителя.Наименование КАК РуководительДолжность,
	|	ЕСТЬNULL(ФИОФизическихЛиц.ИОФамилия, """") КАК Руководитель,
	|	ЕСТЬNULL(ДанныеПоФизлицам.КоличествоФизлиц, 0) КАК ЧислоЗастрахованныхЛиц,
	|	ЕСТЬNULL(ДанныеПоФизлицам.КоличествоИсходных, 0) КАК КолЗЛИсходных,
	|	ЕСТЬNULL(ДанныеПоФизлицам.КоличествоКорректирующих, 0) КАК КолЗЛКорректирующих,
	|	""Р"" КАК ПризнакТарифа,
	|	Док.НомерПачки,
	|	Док.ОтчетныйПериод,
	|	ЕСТЬNULL(КоличествоПачек.КоличествоКорректирующих, 0) КАК КолКорректирующихПачек,
	|	ЕСТЬNULL(КоличествоПачек.КоличествоИсходных, 0) КАК КолИсходныхПачек,
	|	ДанныеПоФизлицам.НачисленоСтраховаяИсходных,
	|	ДанныеПоФизлицам.НачисленоСтраховаяКорректирующих,
	|	ДанныеПоФизлицам.НачисленоНакопительнаяИсходных,
	|	ДанныеПоФизлицам.НачисленоНакопительнаяКорректирующих,
	|	ДанныеПоФизлицам.УплаченоСтраховая,
	|	ДанныеПоФизлицам.УплаченоНакопительная,
	|	Док.ИмяФайлаДляПФР КАК ИмяФайла
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6 КАК Док
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСведенияОбОрганизациях КАК СведенияОбОрганизациях
	|		ПО Док.Организация = СведенияОбОрганизациях.Организация
	|			И Док.ОкончаниеОтчетногоПериода = СведенияОбОрганизациях.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКадровыеДанныеФизическихЛиц КАК ФИОФизическихЛиц
	|		ПО Док.Руководитель = ФИОФизическихЛиц.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоличествоФизлиц КАК ДанныеПоФизлицам
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоличествоПачек КАК КоличествоПачек
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Док.Ссылка = &ДокументСсылка";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Функция СформироватьЗапросПоПачкам(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Установим параметры запроса.
	Запрос.УстановитьПараметр("ДокументСсылка" , Ссылка);
	
	ПерсонифицированныйУчет.СоздатьПоМассивуСсылокВТИсторияРегистрацийВОрганеПФРСрезПоследних(Запрос.МенеджерВременныхТаблиц, Ссылка, "ОписьПачекСЗВ_6.ПачкиДокументов", "ПачкаДокументов");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Пачки.ПачкаДокументов КАК Документ
	|ПОМЕСТИТЬ ВТДокументыСЗВ
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК Пачки
	|ГДЕ
	|	Пачки.Ссылка = &ДокументСсылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ФормыСЗВ.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Таблица,
	|	ФормыСЗВ.Ссылка,
	|	ФормыСЗВ.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|	ФормыСЗВ.НомерПачки КАК НомерПачки,
	|	СУММА(ФормыСЗВ.НачисленоСтраховая) КАК НачисленоСтраховая,
	|	СУММА(ФормыСЗВ.УплаченоСтраховая) КАК УплаченоСтраховая,
	|	СУММА(ФормыСЗВ.НачисленоНакопительная) КАК НачисленоНакопительная,
	|	СУММА(ФормыСЗВ.УплаченоНакопительная) КАК УплаченоНакопительная,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ФормыСЗВ.КолЗЛ) КАК КолЗЛ,
	|	ИсторияРегистрацийВОрганеПФР.РегистрационныйНомерПФР КАК РегистрационныйНомерПФР,
	|	СУММА(ФормыСЗВ.ДоначисленоСтраховая) КАК ДоначисленоСтраховая,
	|	СУММА(ФормыСЗВ.ДоначисленоНакопительная) КАК ДоначисленоНакопительная,
	|	ФормыСЗВ.ИмяФайла,
	|	СУММА(ФормыСЗВ.ДоУплаченоНакопительная) КАК ДоУплаченоНакопительная,
	|	СУММА(ФормыСЗВ.ДоУплаченоСтраховая) КАК ДоУплаченоСтраховая
	|ИЗ
	|	(ВЫБРАТЬ
	|		ФормыСЗВ6_1.Ссылка.ТипСведенийСЗВ КАК ТипСведенийСЗВ,
	|		ФормыСЗВ6_1.Ссылка КАК Ссылка,
	|		ФормыСЗВ6_1.Ссылка.КатегорияЗастрахованныхЛиц КАК КатегорияЗастрахованныхЛиц,
	|		ФормыСЗВ6_1.Ссылка.НомерПачки КАК НомерПачки,
	|		ФормыСЗВ6_1.Сотрудник КАК КолЗЛ,
	|		ФормыСЗВ6_1.НачисленоСтраховая КАК НачисленоСтраховая,
	|		ФормыСЗВ6_1.УплаченоСтраховая КАК УплаченоСтраховая,
	|		ФормыСЗВ6_1.НачисленоНакопительная КАК НачисленоНакопительная,
	|		ФормыСЗВ6_1.УплаченоНакопительная КАК УплаченоНакопительная,
	|		ФормыСЗВ6_1.ДоначисленоСтраховая КАК ДоначисленоСтраховая,
	|		ФормыСЗВ6_1.ДоначисленоНакопительная КАК ДоначисленоНакопительная,
	|		ФормыСЗВ6_1.Ссылка.ИмяФайлаДляПФР КАК ИмяФайла,
	|		ФормыСЗВ6_1.ДоУплаченоНакопительная КАК ДоУплаченоНакопительная,
	|		ФормыСЗВ6_1.ДоУплаченоСтраховая КАК ДоУплаченоСтраховая,
	|		ФормыСЗВ6_1.Ссылка.Организация КАК Организация,
	|		ФормыСЗВ6_1.Ссылка.ОкончаниеОтчетногоПериода КАК ОкончаниеОтчетногоПериода
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_1.Сотрудники КАК ФормыСЗВ6_1
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_1.Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ФормыСЗВ6_4.Ссылка.ТипСведенийСЗВ,
	|		ФормыСЗВ6_4.Ссылка,
	|		ФормыСЗВ6_4.Ссылка.КатегорияЗастрахованныхЛиц,
	|		ФормыСЗВ6_4.Ссылка.НомерПачки,
	|		ФормыСЗВ6_4.Сотрудник,
	|		ФормыСЗВ6_4.НачисленоСтраховая,
	|		ФормыСЗВ6_4.УплаченоСтраховая,
	|		ФормыСЗВ6_4.НачисленоНакопительная,
	|		ФормыСЗВ6_4.УплаченоНакопительная,
	|		ФормыСЗВ6_4.ДоначисленоСтраховая,
	|		ФормыСЗВ6_4.ДоначисленоНакопительная,
	|		ФормыСЗВ6_4.Ссылка.ИмяФайлаДляПФР,
	|		ФормыСЗВ6_4.ДоУплаченоНакопительная,
	|		ФормыСЗВ6_4.ДоУплаченоСтраховая,
	|		ФормыСЗВ6_4.Ссылка.Организация,
	|		ФормыСЗВ6_4.Ссылка.ОкончаниеОтчетногоПериода
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПачкаДокументовСЗВ_6_4.Сотрудники КАК ФормыСЗВ6_4
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_4.Ссылка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ФормыСЗВ6_2.Ссылка.ТипСведенийСЗВ,
	|		ФормыСЗВ6_2.Ссылка,
	|		ФормыСЗВ6_2.Ссылка.КатегорияЗастрахованныхЛиц,
	|		ФормыСЗВ6_2.Ссылка.НомерПачки,
	|		ФормыСЗВ6_2.Сотрудник,
	|		ФормыСЗВ6_2.НачисленоСтраховая,
	|		ФормыСЗВ6_2.УплаченоСтраховая,
	|		ФормыСЗВ6_2.НачисленоНакопительная,
	|		ФормыСЗВ6_2.УплаченоНакопительная,
	|		ФормыСЗВ6_2.ДоначисленоСтраховая,
	|		ФормыСЗВ6_2.ДоначисленоНакопительная,
	|		ФормыСЗВ6_2.Ссылка.ИмяФайлаДляПФР,
	|		ФормыСЗВ6_2.ДоУплаченоНакопительная,
	|		ФормыСЗВ6_2.ДоУплаченоСтраховая,
	|		ФормыСЗВ6_2.Ссылка.Организация,
	|		ФормыСЗВ6_2.Ссылка.ОкончаниеОтчетногоПериода
	|	ИЗ
	|		ВТДокументыСЗВ КАК ДокументыСЗВ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеестрСЗВ_6_2.Сотрудники КАК ФормыСЗВ6_2
	|			ПО ДокументыСЗВ.Документ = ФормыСЗВ6_2.Ссылка) КАК ФормыСЗВ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТИсторияРегистрацийВОрганеПФРСрезПоследних КАК ИсторияРегистрацийВОрганеПФР
	|		ПО ФормыСЗВ.Организация = ИсторияРегистрацийВОрганеПФР.Организация
	|			И ФормыСЗВ.ОкончаниеОтчетногоПериода = ИсторияРегистрацийВОрганеПФР.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ФормыСЗВ.Ссылка,
	|	ФормыСЗВ.КатегорияЗастрахованныхЛиц,
	|	ФормыСЗВ.НомерПачки,
	|	ИсторияРегистрацийВОрганеПФР.РегистрационныйНомерПФР,
	|	ФормыСЗВ.ИмяФайла,
	|	ВЫБОР
	|		КОГДА ФормыСЗВ.ТипСведенийСЗВ = ЗНАЧЕНИЕ(Перечисление.ТипыСведенийСЗВ.ИСХОДНАЯ)
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ
	|
	|УПОРЯДОЧИТЬ ПО
	|	Таблица,
	|	КатегорияЗастрахованныхЛиц,
	|	НомерПачки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для обеспечения формирования выходного файла.

Функция ТекстФайлаОписи(Ссылка)
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента(Ссылка).Выбрать();
	ВыборкаПоШапкеДокумента.Следующий();
	
	ВыборкаПоПачкам = СформироватьЗапросПоПачкам(Ссылка).Выбрать();
	
	// Загружаем формат файла сведений.
	ДеревоФорматаXML = ПолучитьОбщийМакет("ФорматПФР70_2010XML");
	ТекстФорматаXML = ДеревоФорматаXML.ПолучитьТекст();
	
	ДеревоФормата = ЗарплатаКадры.ЗагрузитьXMLВДокументDOM(ТекстФорматаXML);
	
	ТипДокументовПачки = "ОПИСЬ_СВЕДЕНИЙ_ПЕРЕДАВАЕМЫХ_СТРАХОВАТЕЛЕМ";
	
	// Создаем начальное дерево
	ДеревоВыгрузки = ЗарплатаКадры.СоздатьДеревоXML();
	УзелПФР = ПерсонифицированныйУчет.УзелФайлаПФР(ДеревоВыгрузки);
	ПерсонифицированныйУчет.ЗаполнитьИмяИЗаголовокФайла(УзелПФР, ДеревоФормата, ВыборкаПоШапкеДокумента.ИмяФайла);
	// Добавляем ветки ПачкаВходящихДокументов и ВходящаяОпись.
	НаборВходящейОписи = "";
	УзелПачкаВходящихДокументов = ПерсонифицированныйУчет.ЗаполнитьНаборЗаписейВходящаяОписьСЗВ6(УзелПФР, ДеревоФормата, ТипДокументовПачки, ВыборкаПоШапкеДокумента, 1, 1, "ВХОДЯЩАЯ_ОПИСЬ_ДЛЯ_ОПИСИ",НаборВходящейОписи);
	
	ДанныеВходящейОписи = ОбщегоНазначения.СкопироватьРекурсивно(НаборВходящейОписи);
	ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, "ВХОДЯЩАЯ_ОПИСЬ_ПО_СТРАХОВЫМ_ВЗНОСАМ",""), НаборВходящейОписи);
	
	ФорматОписи = ЗарплатаКадры.ЗагрузитьФорматНабораЗаписей(ДеревоФормата, "ОПИСЬ_СВЕДЕНИЙ");
	
	ФорматОписи.НомерВПачке.Значение = 2;
	ФорматОписи.Страхователь.Значение = ДанныеВходящейОписи.СоставительПачки.Значение;
	ЗаполнитьЗначенияСвойств(ФорматОписи.ОтчетныйПериод.Значение,ПерсонифицированныйУчет.ОписаниеОтчетногоПериодаДляФайла(ВыборкаПоШапкеДокумента.ОтчетныйПериод));
	ФорматОписи.ЧислоИсходныхПачек.Значение = ВыборкаПоШапкеДокумента.КолИсходныхПачек;
	ФорматОписи.ЧислоКорректирующихПачек.Значение = ВыборкаПоШапкеДокумента.КолКорректирующихПачек;
	ФорматОписи.ДатаЗаполнения.Значение = ДанныеВходящейОписи.ДатаСоставления.Значение;
	
	ФорматСведенияОбИсходныхСведениях = ОбщегоНазначения.СкопироватьРекурсивно(ФорматОписи.СведенияОбИсходныхСведениях.Значение);
	ФорматОписи.Удалить("СведенияОбИсходныхСведениях");
	
	ФорматСведенияОКорректирующихСведениях = ОбщегоНазначения.СкопироватьРекурсивно(ФорматОписи.СведенияОКорректирующихСведениях.Значение);
	ФорматОписи.Удалить("СведенияОКорректирующихСведениях");
	
	УзелОписи = ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелПачкаВходящихДокументов, ТипДокументовПачки,"");
	ЗарплатаКадры.ДобавитьИнформациюВДерево(УзелОписи, ФорматОписи);
	
	Пока ВыборкаПоПачкам.СледующийПоЗначениюПоля("Таблица") Цикл
		
		ФорматБлока = ?(ВыборкаПоПачкам.Таблица = 1,ФорматСведенияОбИсходныхСведениях,ФорматСведенияОКорректирующихСведениях);
		ТегБлока = ?(ВыборкаПоПачкам.Таблица = 1,"СведенияОбИсходныхСведениях","СведенияОкорректирующихСведениях");
		
		КоличествоЗЛСтрахователя = 0;
		НачисленоСтраховаяСтрахователя = 0;
		НачисленоНакопительнаяСтрахователя = 0;
		ДоначисленоСтраховаяСтрахователя = 0;
		ДоначисленоНакопительнаяСтрахователя = 0;
		УплаченоСтраховаяСтрахователя = 0;
		УплаченоНакопительнаяСтрахователя = 0;
		ДоУплаченоСтраховаяСтрахователя = 0;
		ДоУплаченоНакопительнаяСтрахователя = 0;
		НомерСтроки = 0;
		
		Пока ВыборкаПоПачкам.СледующийПоЗначениюПоля("КатегорияЗастрахованныхЛиц") Цикл
			КоличествоЗЛКатегории = 0;
			НачисленоСтраховаяКатегории = 0;
			ДоначисленоСтраховаяКатегории = 0;
			НачисленоНакопительнаяКатегории = 0;
			ДоначисленоНакопительнаяКатегории = 0;
			УплаченоСтраховаяКатегории = 0;
			УплаченоНакопительнаяКатегории = 0;
			ДоУплаченоСтраховаяКатегории = 0;
			ДоУплаченоНакопительнаяКатегории = 0;
			
			Пока ВыборкаПоПачкам.Следующий() Цикл
				
				НаборЗаписей = ОбщегоНазначения.СкопироватьРекурсивно(ФорматБлока);
				НомерСтроки = НомерСтроки + 1;
				
				НаборЗаписей.ПорядковыйНомер.Значение = НомерСтроки;
				НаборЗаписей.ТипСтрокиОсведениях.Значение = "ПО ПАЧКЕ";
				НаборЗаписей.ИмяФайла.Значение = ВыборкаПоПачкам.ИмяФайла;
				НаборЗаписей.КодКатегории.Значение = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаПоПачкам.КатегорияЗастрахованныхЛиц);
				НаборЗаписей.КоличествоЗЛ.Значение = ВыборкаПоПачкам.КолЗЛ;
				
				НачисленоСтраховая = ВыборкаПоПачкам.НачисленоСтраховая;
				НачисленоНакопительная = ВыборкаПоПачкам.НачисленоНакопительная;
				ДоначисленоСтраховая = ВыборкаПоПачкам.ДоначисленоСтраховая;
				ДоначисленоНакопительная = ВыборкаПоПачкам.ДоначисленоНакопительная;
				УплаченоСтраховая = ВыборкаПоПачкам.УплаченоСтраховая;
				УплаченоНакопительная = ВыборкаПоПачкам.УплаченоНакопительная;
				ДоУплаченоСтраховая = ВыборкаПоПачкам.ДоУплаченоСтраховая;
				ДоУплаченоНакопительная = ВыборкаПоПачкам.ДоУплаченоНакопительная;
				
				Если ВыборкаПоПачкам.Таблица = 1 Тогда
					ПерсонифицированныйУчет.ВписатьВзносыВНаборДанных(НаборЗаписей, НачисленоСтраховая, УплаченоСтраховая, НачисленоНакопительная, УплаченоНакопительная);
				Иначе
					НаборЗаписей.ДоначисленоНаСтраховую.Значение = ДоначисленоСтраховая;
					НаборЗаписей.ДоначисленоНаНакопительную.Значение = ДоначисленоНакопительная;
					НаборЗаписей.ДоуплаченоНаСтраховую.Значение = ДоУплаченоСтраховая;
					НаборЗаписей.ДоуплаченоНаНакопительную.Значение = ДоУплаченоНакопительная;
				КонецЕсли;
				
				ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелОписи, ТегБлока,""), НаборЗаписей);
				
				КоличествоЗЛКатегории = КоличествоЗЛКатегории + ВыборкаПоПачкам.КолЗЛ;
				КоличествоЗЛСтрахователя = КоличествоЗЛСтрахователя + ВыборкаПоПачкам.КолЗЛ;
				НачисленоСтраховаяСтрахователя = НачисленоСтраховаяСтрахователя + НачисленоСтраховая;
				НачисленоНакопительнаяСтрахователя = НачисленоНакопительнаяСтрахователя + НачисленоНакопительная;
				НачисленоСтраховаяКатегории = НачисленоСтраховаяКатегории + НачисленоСтраховая;
				НачисленоНакопительнаяКатегории = НачисленоНакопительнаяКатегории + НачисленоНакопительная;
				УплаченоСтраховаяСтрахователя = УплаченоСтраховаяСтрахователя + УплаченоСтраховая;
				УплаченоНакопительнаяСтрахователя = УплаченоНакопительнаяСтрахователя + УплаченоНакопительная;
				УплаченоСтраховаяКатегории = УплаченоСтраховаяКатегории + УплаченоСтраховая;
				УплаченоНакопительнаяКатегории = УплаченоНакопительнаяКатегории + УплаченоНакопительная;
				ДоначисленоСтраховаяСтрахователя = ДоначисленоСтраховаяСтрахователя + ДоначисленоСтраховая;
				ДоначисленоСтраховаяКатегории = ДоначисленоСтраховаяКатегории + ДоначисленоСтраховая;
				ДоначисленоНакопительнаяСтрахователя = ДоначисленоНакопительнаяСтрахователя + ДоначисленоНакопительная;
				ДоначисленоНакопительнаяКатегории = ДоначисленоНакопительнаяКатегории + ДоначисленоНакопительная;
				ДоУплаченоСтраховаяСтрахователя = ДоУплаченоСтраховаяСтрахователя + ДоУплаченоСтраховая;
				ДоУплаченоНакопительнаяСтрахователя = ДоУплаченоНакопительнаяСтрахователя + ДоУплаченоНакопительная;
				ДоУплаченоСтраховаяКатегории = ДоУплаченоСтраховаяКатегории + ДоУплаченоСтраховая;
				ДоУплаченоНакопительнаяКатегории = ДоУплаченоНакопительнаяКатегории + ДоУплаченоНакопительная;
				
			КонецЦикла;
			
			// Итоги по категории
			НаборЗаписей = ОбщегоНазначения.СкопироватьРекурсивно(ФорматБлока);
			НаборЗаписей.Удалить("ИмяФайла");
			
			НомерСтроки = НомерСтроки + 1;
			
			НаборЗаписей.ПорядковыйНомер.Значение = НомерСтроки;
			НаборЗаписей.ТипСтрокиОсведениях.Значение = "ПО КАТЕГОРИИ";
			НаборЗаписей.КодКатегории.Значение = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаПоПачкам.КатегорияЗастрахованныхЛиц);
			НаборЗаписей.КоличествоЗЛ.Значение = КоличествоЗЛКатегории;
			
			Если ВыборкаПоПачкам.Таблица = 1 Тогда
				ПерсонифицированныйУчет.ВписатьВзносыВНаборДанных(НаборЗаписей, НачисленоСтраховаяКатегории, УплаченоСтраховаяКатегории, НачисленоНакопительнаяКатегории, УплаченоНакопительнаяКатегории);
			Иначе
				НаборЗаписей.ДоначисленоНаСтраховую.Значение = ДоначисленоСтраховаяКатегории;
				НаборЗаписей.ДоначисленоНаНакопительную.Значение = ДоначисленоНакопительнаяКатегории;
				НаборЗаписей.ДоуплаченоНаСтраховую.Значение = ДоУплаченоСтраховаяКатегории;
				НаборЗаписей.ДоуплаченоНаНакопительную.Значение = ДоУплаченоНакопительнаяКатегории;
			КонецЕсли;
			
			ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелОписи, ТегБлока,""), НаборЗаписей);
			
		КонецЦикла;
		
		// Итоги по страхователю
		
		НаборЗаписей = ОбщегоНазначения.СкопироватьРекурсивно(ФорматБлока);
		НаборЗаписей.Удалить("ИмяФайла");
		НаборЗаписей.Удалить("КодКатегории");
		
		НомерСтроки = НомерСтроки + 1;
		
		НаборЗаписей.ПорядковыйНомер.Значение = НомерСтроки;
		НаборЗаписей.ТипСтрокиОсведениях.Значение = "ПО СТРАХОВАТЕЛЮ";
		НаборЗаписей.КоличествоЗЛ.Значение = КоличествоЗЛСтрахователя;
		
		Если ВыборкаПоПачкам.Таблица = 1 Тогда
			ПерсонифицированныйУчет.ВписатьВзносыВНаборДанных(НаборЗаписей, НачисленоСтраховаяСтрахователя, УплаченоСтраховаяСтрахователя, НачисленоНакопительнаяСтрахователя, УплаченоНакопительнаяСтрахователя);
		Иначе
			НаборЗаписей.ДоначисленоНаСтраховую.Значение = ДоначисленоСтраховаяСтрахователя;
			НаборЗаписей.ДоначисленоНаНакопительную.Значение = ДоначисленоНакопительнаяСтрахователя;
			НаборЗаписей.ДоуплаченоНаСтраховую.Значение = ДоУплаченоСтраховаяСтрахователя;
			НаборЗаписей.ДоуплаченоНаНакопительную.Значение = ДоУплаченоНакопительнаяСтрахователя;
		КонецЕсли;
		
		ЗарплатаКадры.ДобавитьИнформациюВДерево(ЗарплатаКадры.ДобавитьУзелВДеревоXML(УзелОписи, ТегБлока,""), НаборЗаписей);
		
	КонецЦикла;
	
	// Преобразуем дерево в строковое описание XML.
	ТекстФайла = ПерсонифицированныйУчет.ПолучитьТекстФайлаИзДереваЗначений(ДеревоВыгрузки);
	
	Возврат ТекстФайла;
	
КонецФункции

Процедура СформироватьФайлОписи(Ссылка)
	
	ТекстФайла = ТекстФайлаОписи(Ссылка);
	
	ИмяФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИмяФайлаДляПФР");
	
	ЗарплатаКадры.ЗаписатьФайлВАрхив(Ссылка, ИмяФайла, ТекстФайла);
	
КонецПроцедуры

Процедура ОбработкаФормированияФайла(Объект) Экспорт
	СформироватьФайлОписи(Объект.Ссылка);
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Процедуры печати документа.

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// АДВ-6-2
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ФормаАДВ_6_2";
	КомандаПечати.Представление = НСтр("ru = 'АДВ-6-2'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт	
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ФормаАДВ_6_2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ФормаАДВ_6_2", "Форма АДВ-6-2", СформироватьПечатнуюФормуАДВ6_2(МассивОбъектов[0], ОбъектыПечати));
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуАДВ6_2(МассивОбъектов, ОбъектыПечати) Экспорт
	
	ВыборкаПоШапкеДокумента = СформироватьЗапросПоШапкеДокумента(МассивОбъектов).Выбрать();
	ВыборкаПоШапкеДокумента.Следующий();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОписьПачекСЗВ_6.ПФ_MXL_ФормаАДВ_6_2");
	
	ДокументРезультат = Новый ТабличныйДокумент;
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Опись_АДВ_6_2";
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьСередина = Макет.ПолучитьОбласть("Середина");
	ОбластьСтрокаИсходных = Макет.ПолучитьОбласть("СтрокаИсходных");
	ОбластьСтрокаКорректирующих = Макет.ПолучитьОбласть("СтрокаКорректирующих");
	ОбластьПустаяТаблицаИсходных = Макет.ПолучитьОбласть("ПустаяТаблицаИсходных");
	ОбластьПустаяТаблицаКорректирующих = Макет.ПолучитьОбласть("ПустаяТаблицаКорректирующих");
	
	ЗаполнитьЗначенияСвойств(ОбластьШапка.Параметры, ВыборкаПоШапкеДокумента);
	ОбластьШапка.Параметры.НаименованиеСокращенное = ВРег(ОбластьШапка.Параметры.НаименованиеСокращенное);
	ЗаполнитьЗначенияСвойств(ОбластьСередина.Параметры, ВыборкаПоШапкеДокумента);
	ЗаполнитьЗначенияСвойств(ОбластьПодвал.Параметры, ВыборкаПоШапкеДокумента);
	
	ОтчетныйПериод = ВыборкаПоШапкеДокумента.ОтчетныйПериод;
	
	Если Год(ОтчетныйПериод) >= 2011 Тогда
		ОбластьШапка.Параметры.ЭтоКварталОтчетногоГода   = Месяц(ОтчетныйПериод) = 1;
		ОбластьШапка.Параметры.ЭтоПолугодиеОтчетногоГода = Месяц(ОтчетныйПериод) = 4;
		ОбластьШапка.Параметры.Это9МесяцевОтчетногоГода  = Месяц(ОтчетныйПериод) = 7;
		ОбластьШапка.Параметры.ЭтоВесьОтчетныйГод        = Месяц(ОтчетныйПериод) = 10;
	Иначе
		ОбластьШапка.Параметры.ЭтоПолугодие2010 = Месяц(ОтчетныйПериод) = 1;
		ОбластьШапка.Параметры.Это2010год = Месяц(ОтчетныйПериод) = 10;
	КонецЕсли;
	
	ОбластьШапка.Параметры.ОтчетныйГод = Формат(Год(ОтчетныйПериод), "ЧГ=");
	
	ДокументРезультат.Вывести(ОбластьШапка);
	
	ВыборкаПоПачкам = СформироватьЗапросПоПачкам(МассивОбъектов).Выбрать();
	
	Если ВыборкаПоШапкеДокумента.КолИсходныхПачек = 0 Тогда
		ДокументРезультат.Вывести(ОбластьПустаяТаблицаИсходных);
	КонецЕсли;
	
	НачисленоСтраховаяСтрахователя = 0;
	НачисленоНакопительнаяСтрахователя = 0;
	ДоначисленоСтраховаяСтрахователя = 0;
	ДоначисленоНакопительнаяСтрахователя = 0;
	УплаченоСтраховаяСтрахователя = 0;
	УплаченоНакопительнаяСтрахователя = 0;
	ДоУплаченоСтраховаяСтрахователя = 0;
	ДоУплаченоНакопительнаяСтрахователя = 0;

	
	Пока ВыборкаПоПачкам.СледующийПоЗначениюПоля("Таблица") Цикл
		
		ВыводимаяОбласть = ?(ВыборкаПоПачкам.Таблица = 1, ОбластьСтрокаИсходных, ОбластьСтрокаКорректирующих);
		Если ВыборкаПоПачкам.Таблица = 2 Тогда
			ОбластьСередина.Параметры.НачисленоСтраховая = НачисленоСтраховаяСтрахователя;
			ОбластьСередина.Параметры.НачисленоНакопительная = НачисленоНакопительнаяСтрахователя;
			ОбластьСередина.Параметры.УплаченоСтраховая = УплаченоСтраховаяСтрахователя;
			ОбластьСередина.Параметры.УплаченоНакопительная = УплаченоНакопительнаяСтрахователя;
			ДокументРезультат.Вывести(ОбластьСередина);
			НачисленоСтраховаяСтрахователя = 0;
			НачисленоНакопительнаяСтрахователя = 0;
			ДоначисленоСтраховаяСтрахователя = 0;
			ДоначисленоНакопительнаяСтрахователя = 0;
			УплаченоСтраховаяСтрахователя = 0;
			УплаченоНакопительнаяСтрахователя = 0;
			ДоУплаченоСтраховаяСтрахователя = 0;
			ДоУплаченоНакопительнаяСтрахователя = 0;
		КонецЕсли;
		
		НомерСтроки = 0;
		Пока ВыборкаПоПачкам.Следующий() Цикл
			
			ЗаполнитьЗначенияСвойств(ВыводимаяОбласть.Параметры, ВыборкаПоПачкам, "КолЗЛ");
			
			НачисленоСтраховая = ВыборкаПоПачкам.НачисленоСтраховая;
			НачисленоНакопительная = ВыборкаПоПачкам.НачисленоНакопительная;
			ДоначисленоСтраховая = ВыборкаПоПачкам.ДоначисленоСтраховая;
			ДоначисленоНакопительная = ВыборкаПоПачкам.ДоначисленоНакопительная;
			УплаченоСтраховая = ВыборкаПоПачкам.УплаченоСтраховая;
			УплаченоНакопительная = ВыборкаПоПачкам.УплаченоНакопительная;
			ДоУплаченоСтраховая = ВыборкаПоПачкам.ДоУплаченоСтраховая;
			ДоУплаченоНакопительная = ВыборкаПоПачкам.ДоУплаченоНакопительная;

			
			Если ВыборкаПоПачкам.Таблица = 1 Тогда
				ВыводимаяОбласть.Параметры.НачисленоСтраховая = НачисленоСтраховая;
				ВыводимаяОбласть.Параметры.НачисленоНакопительная = НачисленоНакопительная;
				ВыводимаяОбласть.Параметры.УплаченоСтраховая = УплаченоСтраховая;
				ВыводимаяОбласть.Параметры.УплаченоНакопительная = УплаченоНакопительная;
			Иначе
				ВыводимаяОбласть.Параметры.ДоНачисленоСтраховая = ДоначисленоСтраховая;
				ВыводимаяОбласть.Параметры.ДоНачисленоНакопительная = ДоначисленоНакопительная;
				ВыводимаяОбласть.Параметры.ДоУплаченоСтраховая = ДоУплаченоСтраховая;
				ВыводимаяОбласть.Параметры.ДоУплаченоНакопительная = ДоУплаченоНакопительная;
			КонецЕсли;
			
			НомерСтроки = НомерСтроки + 1;
			ВыводимаяОбласть.Параметры.НомерСтроки = НомерСтроки;
			ВыводимаяОбласть.Параметры.ИмяФайла = ВыборкаПоПачкам.ИмяФайла;
			ВыводимаяОбласть.Параметры.КодКатегории = ПерсонифицированныйУчет.ПолучитьИмяЭлементаПеречисленияПоЗначению(ВыборкаПоПачкам.КатегорияЗастрахованныхЛиц);
			ДокументРезультат.Вывести(ВыводимаяОбласть);
			
			НачисленоСтраховаяСтрахователя = НачисленоСтраховаяСтрахователя + НачисленоСтраховая;
			НачисленоНакопительнаяСтрахователя = НачисленоНакопительнаяСтрахователя + НачисленоНакопительная;
			УплаченоСтраховаяСтрахователя = УплаченоСтраховаяСтрахователя + УплаченоСтраховая;
			УплаченоНакопительнаяСтрахователя = УплаченоНакопительнаяСтрахователя + УплаченоНакопительная;
			ДоначисленоСтраховаяСтрахователя = ДоначисленоСтраховаяСтрахователя + ДоначисленоСтраховая;
			ДоначисленоНакопительнаяСтрахователя = ДоначисленоНакопительнаяСтрахователя + ДоначисленоНакопительная;
			ДоУплаченоСтраховаяСтрахователя = ДоУплаченоСтраховаяСтрахователя + ДоУплаченоСтраховая;
			ДоУплаченоНакопительнаяСтрахователя = ДоУплаченоНакопительнаяСтрахователя + ДоУплаченоНакопительная;
		КонецЦикла;
	КонецЦикла;
	
	Если ВыборкаПоШапкеДокумента.КолКорректирующихПачек = 0 Тогда
		ОбластьСередина.Параметры.НачисленоСтраховая = НачисленоСтраховаяСтрахователя;
		ОбластьСередина.Параметры.НачисленоНакопительная = НачисленоНакопительнаяСтрахователя;
		ОбластьСередина.Параметры.УплаченоСтраховая = УплаченоСтраховаяСтрахователя;
		ОбластьСередина.Параметры.УплаченоНакопительная = УплаченоНакопительнаяСтрахователя;
		ДокументРезультат.Вывести(ОбластьСередина);
		ДокументРезультат.Вывести(ОбластьПустаяТаблицаКорректирующих);
	Иначе
		ОбластьПодвал.Параметры.ДоНачисленоСтраховая = ДоначисленоСтраховаяСтрахователя;
		ОбластьПодвал.Параметры.ДоНачисленоНакопительная = ДоначисленоНакопительнаяСтрахователя;
		ОбластьПодвал.Параметры.ДоУплаченоСтраховая = ДоУплаченоСтраховаяСтрахователя;
		ОбластьПодвал.Параметры.ДоУплаченоНакопительная = ДоУплаченоНакопительнаяСтрахователя;
	КонецЕсли;
		
	ДокументРезультат.Вывести(ОбластьПодвал);
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ДокументРезультат, 1, ОбъектыПечати, МассивОбъектов);
	
	Возврат ДокументРезультат;
	
КонецФункции

Процедура ЗаполнитьСпискиПечатаемыхДокументов(ОписьСсылка, МассивСЗВ6_1, МассивСЗВ6_2, МассивСЗВ6_4) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ОписьСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК ОписьПачекСЗВ_6ПачкиДокументов
	|ГДЕ
	|	ОписьПачекСЗВ_6ПачкиДокументов.Ссылка = &Ссылка
	|	И ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов ССЫЛКА Документ.ПачкаДокументовСЗВ_6_1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК ОписьПачекСЗВ_6ПачкиДокументов
	|ГДЕ
	|	ОписьПачекСЗВ_6ПачкиДокументов.Ссылка = &Ссылка
	|	И ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов ССЫЛКА Документ.РеестрСЗВ_6_2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов
	|ИЗ
	|	Документ.ОписьПачекСЗВ_6.ПачкиДокументов КАК ОписьПачекСЗВ_6ПачкиДокументов
	|ГДЕ
	|	ОписьПачекСЗВ_6ПачкиДокументов.Ссылка = &Ссылка
	|	И ОписьПачекСЗВ_6ПачкиДокументов.ПачкаДокументов ССЫЛКА Документ.ПачкаДокументовСЗВ_6_4";
	
	Результат = Запрос.ВыполнитьПакет();
	МассивСЗВ6_1 = Результат[0].Выгрузить().ВыгрузитьКолонку("ПачкаДокументов");
	МассивСЗВ6_2 = Результат[1].Выгрузить().ВыгрузитьКолонку("ПачкаДокументов");
	МассивСЗВ6_4 = Результат[2].Выгрузить().ВыгрузитьКолонку("ПачкаДокументов");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции получения данных для заполнения и проведения документа.

Функция ВыгрузитьФайлыВоВременноеХранилище(Ссылка, УникальныйИдентификатор = Неопределено) Экспорт 
	
	ДанныеФайла = ЗарплатаКадры.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификатор);
	
	ОписаниеВыгруженногоФайла = ПерсонифицированныйУчет.ОписаниеВыгруженногоФайлаОтчетности();
	
	ОписаниеВыгруженногоФайла.Владелец = Ссылка;
	ОписаниеВыгруженногоФайла.АдресВоВременномХранилище = ДанныеФайла.СсылкаНаДвоичныеДанныеФайла;
	ОписаниеВыгруженногоФайла.ИмяФайла = ДанныеФайла.ИмяФайла;
	ОписаниеВыгруженногоФайла.ПроверятьCheckXML = Истина;
	ОписаниеВыгруженногоФайла.ПроверятьCheckUFA = Истина;

	
	ВыгруженныеФайлы = Новый Массив;
	ВыгруженныеФайлы.Добавить(ОписаниеВыгруженногоФайла);
	
	Возврат ВыгруженныеФайлы;
	
КонецФункции

#КонецОбласти

#КонецЕсли