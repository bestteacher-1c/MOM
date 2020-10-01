#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Сотрудник") И ЗначениеЗаполнено(ДанныеЗаполнения.Сотрудник) Тогда
			ОбъектОснование = ДанныеЗаполнения.Сотрудник;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование, , Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Сотрудник", ОбъектОснование);
		Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДатаСеанса());
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	НазначениеПодработки.Ссылка
			|ИЗ
			|	Документ.НазначениеПодработки КАК НазначениеПодработки
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПрекращениеПодработки КАК ПрекращениеПодработки
			|		ПО НазначениеПодработки.Ссылка = ПрекращениеПодработки.ДокументОснование
			|			И (ПрекращениеПодработки.Проведен)
			|ГДЕ
			|	НазначениеПодработки.ГоловнойСотрудник = &Сотрудник
			|	И (НазначениеПодработки.ДатаОкончания >= &ДатаОкончания
			|			ИЛИ НазначениеПодработки.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1))
			|	И НазначениеПодработки.Проведен
			|	И ПрекращениеПодработки.Ссылка ЕСТЬ NULL ";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Если Выборка.Количество() = 1 Тогда
				
				Выборка.Следующий();
				ОбъектОснование = Выборка.Ссылка
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.НазначениеПодработки") Тогда
		Документы.ПрекращениеПодработки.ЗаполнитьОбъектПоНазначениюПодработки(ЭтотОбъект, ОбъектОснование);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	// Кадровый учет
	НеобходимыеДанные = "ФизическоеЛицо,ДолжностьПоШтатномуРасписанию,КоличествоСтавок,ВидЗанятости";
	КадровыеДанныеСотрудника = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СовмещающийСотрудник), НеобходимыеДанные, ДатаОкончания);
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудника[0];
	
	КадровыеСобытия = Документы.ПрекращениеПодработки.КадровыеСобытияУвольнение(СовмещающийСотрудник, ДатаОкончания, ФизическоеЛицо, КадровыеДанныеСотрудника.ДолжностьПоШтатномуРасписанию, КадровыеДанныеСотрудника.КоличествоСтавок);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(Ссылка, Движения, РежимПроведения, Отказ,,, ЭтотОбъект, "ДатаОкончания");
	
	КадровыйУчет.СформироватьКадровыеДвижения(ЭтотОбъект, Движения, КадровыеСобытия);
	
	ЗанятостьПозицийШтатногоРасписания = ОбщегоНазначенияБЗК.ТаблицаЗначенийПоИмениРегистраСведений("ЗанятостьПозицийШтатногоРасписания");
	СтрокаЗанятости = ЗанятостьПозицийШтатногоРасписания.Добавить();
	СтрокаЗанятости.Период = КонецДня(ДатаОкончания) + 1;
	СтрокаЗанятости.Сотрудник = СовмещающийСотрудник;
	СтрокаЗанятости.ФизическоеЛицо = КадровыеДанныеСотрудника.ФизическоеЛицо;
	СтрокаЗанятости.ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	СтрокаЗанятости.ПозицияШтатногоРасписания = КадровыеДанныеСотрудника.ДолжностьПоШтатномуРасписанию;
	СтрокаЗанятости.ВидЗанятостиПозиции = Перечисления.ВидыЗанятостиПозицийШтатногоРасписания.Свободна;
	СтрокаЗанятости.КоличествоСтавок = КадровыеДанныеСотрудника.КоличествоСтавок;
	СтрокаЗанятости.ЗамещаемыйСотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ОтсутствующийСотрудник");
	
	КадровыйУчетРасширенный.СформироватьДвиженияЗанятостьПозицийШтатногоРасписания(Движения, ЗанятостьПозицийШтатногоРасписания);
	
	// Прекращаем плановые начисления и удержания.
	РасчетЗарплатыРасширенный.ПрекратитьВсеПлановыеНачисленияУдержания(Движения, СовмещающийСотрудник, КонецДня(ДатаОкончания) + 1, Организация, Ложь);
	
	СостоянияСотрудников.ЗарегистрироватьСостояниеСотрудника(Движения, Ссылка, СовмещающийСотрудник, Перечисления.СостоянияСотрудника.Увольнение, КонецДня(ДатаОкончания) + 1);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаОкончания, "Объект.ДатаОкончания", Отказ, НСтр("ru='Дата окончания'"), , , Ложь);
	
	Если ЗначениеЗаполнено(ГоловнойСотрудник) И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ИсключаемыеСсылки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Ссылка);
		
		Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
			ИсключаемыеСсылки.Добавить(ИсправленныйДокумент);
		КонецЕсли;
		
		КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(
			ДатаОкончания, СовмещающийСотрудник, ИсключаемыеСсылки, Отказ, Перечисления.ВидыКадровыхСобытий.Увольнение);
		
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ,"ПериодическиеСведения");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
		
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ПрекращениеПодработки.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	КадровыеДанныеПодработки = КадровыйУчет.КадровыеДанныеСотрудников(Истина, СовмещающийСотрудник, "ГоловнойСотрудник,ФизическоеЛицо,НазначениеПодработки");
	Если КадровыеДанныеПодработки.Количество() > 0 Тогда
		
		ДанныеПодработки = КадровыеДанныеПодработки[0];
		
		ФизическоеЛицо = ДанныеПодработки.ФизическоеЛицо;
		ГоловнойСотрудник = ДанныеПодработки.ГоловнойСотрудник;
		
		Если ДокументОснование <> ДанныеПодработки.НазначениеПодработки Тогда
			ДокументОснование = ДанныеПодработки.НазначениеПодработки;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли