#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Регистратор = Отбор.Регистратор.Значение;
	
	ОтменаПроведения = ?(ДополнительныеСвойства.Свойство("РежимЗаписи"),
		ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения,
		Ложь);
		
	Если НЕ ОтменаПроведения И ТипЗнч(Регистратор) = Тип("ДокументСсылка.ПланПроизводства") Тогда
		
		Если Справочники.ВидыПланов.ПланироватьПолуфабрикатыАвтоматически(
				ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Регистратор, "ВидПлана")) Тогда
			
			МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
			
		    ПрочитатьСтарыеИНовыеДвижения(МенеджерВременныхТаблиц, Регистратор);
			
			ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", МенеджерВременныхТаблиц);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		
		СформироватьОчередьДопланированияПолуфабрикатов(
			ДополнительныеСвойства.МенеджерВременныхТаблиц,
			Отбор.Регистратор.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПрочитатьСтарыеИНовыеДвижения(МенеджерВременныхТаблиц, ПланПроизводства)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтарыеДвижения.Период КАК Период,
	|	СтарыеДвижения.ПланПроизводства КАК ПланПроизводства,
	|	СтарыеДвижения.ПодразделениеДиспетчер КАК ПодразделениеДиспетчер,
	|	СтарыеДвижения.Назначение КАК Назначение,
	|	СтарыеДвижения.Сценарий КАК Сценарий,
	|	СтарыеДвижения.Номенклатура КАК Номенклатура,
	|	СтарыеДвижения.Характеристика КАК Характеристика,
	|	СтарыеДвижения.Количество КАК Количество
	|ПОМЕСТИТЬ СтарыеДвижения
	|ИЗ
	|	РегистрНакопления.ПланыПотребленияМатериалов КАК СтарыеДвижения
	|ГДЕ
	|	СтарыеДвижения.Регистратор = &Ссылка
	|	И СтарыеДвижения.ЭтоПолуфабрикат = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НовыеДвижения.Период КАК Период,
	|	НовыеДвижения.ПланПроизводства КАК ПланПроизводства,
	|	НовыеДвижения.ПодразделениеДиспетчер КАК ПодразделениеДиспетчер,
	|	НовыеДвижения.Назначение КАК Назначение,
	|	НовыеДвижения.Сценарий КАК Сценарий,
	|	НовыеДвижения.Номенклатура КАК Номенклатура,
	|	НовыеДвижения.Характеристика КАК Характеристика,
	|	НовыеДвижения.Количество КАК Количество
	|ПОМЕСТИТЬ НовыеДвижения
	|ИЗ
	|	&НовыеДвижения КАК НовыеДвижения
	|ГДЕ
	|	НовыеДвижения.ЭтоПолуфабрикат = ИСТИНА");
	
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ПланПроизводства);
	Запрос.УстановитьПараметр("НовыеДвижения", ЭтотОбъект);
	
	Запрос.Выполнить();
	
КонецПроцедуры

Процедура СформироватьОчередьДопланированияПолуфабрикатов(МенеджерВременныхТаблиц, ПланПроизводства)
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОчередьРасчета.ДатаПроизводства,
	|	ОчередьРасчета.ПланПроизводства,
	|	ОчередьРасчета.Подразделение,
	|	ОчередьРасчета.Назначение,
	|	ОчередьРасчета.Сценарий,
	|	ОчередьРасчета.Номенклатура,
	|	ОчередьРасчета.Характеристика,
	|	ИСТИНА КАК ВыпускПолуфабрикатов
	|ИЗ
	|	(ВЫБРАТЬ
	|		НовыеДвижения.ПланПроизводства КАК ПланПроизводства,
	|		НовыеДвижения.Номенклатура КАК Номенклатура,
	|		НовыеДвижения.Характеристика КАК Характеристика,
	|		НовыеДвижения.Количество КАК КоличествоРазность,
	|		НовыеДвижения.Период КАК ДатаПроизводства,
	|		НовыеДвижения.Сценарий КАК Сценарий,
	|		НовыеДвижения.ПодразделениеДиспетчер КАК Подразделение,
	|		НовыеДвижения.Назначение КАК Назначение
	|	ИЗ
	|		НовыеДвижения КАК НовыеДвижения
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		СтарыеДвижения.ПланПроизводства,
	|		СтарыеДвижения.Номенклатура,
	|		СтарыеДвижения.Характеристика,
	|		-СтарыеДвижения.Количество,
	|		СтарыеДвижения.Период,
	|		СтарыеДвижения.Сценарий,
	|		СтарыеДвижения.ПодразделениеДиспетчер,
	|		СтарыеДвижения.Назначение
	|	ИЗ
	|		СтарыеДвижения КАК СтарыеДвижения) КАК ОчередьРасчета
	|
	|СГРУППИРОВАТЬ ПО
	|	ОчередьРасчета.ДатаПроизводства,
	|	ОчередьРасчета.ПланПроизводства,
	|	ОчередьРасчета.Подразделение,
	|	ОчередьРасчета.Назначение,
	|	ОчередьРасчета.Сценарий,
	|	ОчередьРасчета.Номенклатура,
	|	ОчередьРасчета.Характеристика
	|
	|ИМЕЮЩИЕ
	|	СУММА(ОчередьРасчета.КоличествоРазность) <> 0";
	
	ТаблицаОчередь = Запрос.Выполнить().Выгрузить();
	
	ДополнительныеСвойства.МенеджерВременныхТаблиц.Закрыть();
	
	Если ТаблицаОчередь.Количество() > 0 Тогда
		
		РегистрыСведений.ОчередьРасчетаПланаПроизводства.ЗаписатьОчередь(ТаблицаОчередь, ПланПроизводства);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
