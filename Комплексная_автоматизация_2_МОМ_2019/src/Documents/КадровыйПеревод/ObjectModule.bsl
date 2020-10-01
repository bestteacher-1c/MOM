#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") Тогда
			
			Если ДанныеЗаполнения.Действие = "Исправить" Тогда
				
				ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
				
				ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
				ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
				
			ИначеЕсли ДанныеЗаполнения.Действие = "ЗаполнитьПослеПереноса" Тогда
				ЗаполнитьПослеПереноса(ДанныеЗаполнения)
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.АдаптацияУвольнение") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("АдаптацияУвольнение");
		Модуль.ОбработкаЗаполненияКадровогоПриказа(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ЗаполнитьКадровыйПереводПоЗаключениюМедицинскогоОсмотра(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или Не ДанныеЗаполнения.Свойство("ЕжегодныеОтпуска") Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
				Сотрудник						= ДанныеЗаполнения.Сотрудник;
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("ДатаНачала") Тогда
				ДатаНачала						= ДанныеЗаполнения.ДатаНачала;
			КонецЕсли;
			Если ДанныеЗаполнения.Свойство("ДолжностьПоШтатномуРасписанию") Тогда
				ДолжностьПоШтатномуРасписанию	= ДанныеЗаполнения.ДолжностьПоШтатномуРасписанию;
			КонецЕсли;
		КонецЕсли;
		
		ДанныеДокумента = ОстаткиОтпусков.ОписаниеПараметровДанныхКадровогоДокумента();
		ДанныеДокумента.Регистратор = Ссылка;
		ДанныеДокумента.Сотрудник = Сотрудник;
		ДанныеДокумента.ДатаСобытия = ДатаНачала;
		
		ДанныеНовойПозиции = ОстаткиОтпусков.ОписаниеПараметровДанныхПозиции();
		ДанныеНовойПозиции.ДолжностьПоШтатномуРасписанию = ДолжностьПоШтатномуРасписанию;
		ДанныеНовойПозиции.Подразделение = Подразделение;
		ДанныеНовойПозиции.Территория = Территория;
		ДанныеНовойПозиции.Должность = Должность;
		
		ОстаткиОтпусков.ЗаполнитьПоложеннымиПравамиСотрудника(ЕжегодныеОтпуска, ДанныеДокумента, ДанныеНовойПозиции);
			
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.КадровыйПеревод.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Дата перевода'"), , , Ложь);
	
	ПроверкаСтрокиСписочногоДокумента = ДополнительныеСвойства.Свойство("ПроверкаСтрокиСписочногоДокумента");
	Если ПроверкаСтрокиСписочногоДокумента Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Дата");
	КонецЕсли;
	
	ИсключаемыеРегистраторы = Новый Массив;
	
	ИсключаемыеРегистраторы.Добавить(Ссылка);
	Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
		ИсключаемыеРегистраторы.Добавить(ИсправленныйДокумент);
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ	= Неопределено;
	ПараметрыПолученияСотрудниковОрганизаций.ИсключаемыйРегистратор		= ИсключаемыеРегистраторы;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	Если ДатаНачала > ДатаОкончания
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Дата окончания не может быть меньше даты перевода'"), ЭтотОбъект, "ДатаОкончания", ,Отказ);
		
	КонецЕсли;
	
	Если ИзменитьПодразделениеИДолжность Тогда
		УправлениеШтатнымРасписанием.ПроверитьВозможностьПроведенияСрочныхКадровыхПереводов(Ссылка, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ЭтотОбъект), Отказ);
	КонецЕсли;
	
	Если Не ИзменитьПодразделениеИДолжность Тогда
		// Не требуется заполнять подразделение и количество ставок, если оно не изменяется.
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОбособленноеПодразделение");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Подразделение");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Должность");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДолжностьПоШтатномуРасписанию");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоСтавок");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидЗанятости");
	Иначе
		// Если изменяем позицию, то требуется проверить ШР.
		ПроверитьСоответствиеПозицииШРПодразделению(Отказ);
	КонецЕсли;
	
	// Не требуется заполнять ОбособленноеПодразделение если в организации не используются обособленные подразделения.
	ПараметрыФО = Новый Структура("Организация", Организация);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленныеПодразделенияРасширенная", ПараметрыФО) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ОбособленноеПодразделение");
	КонецЕсли;
	
	// Не требуется заполнять график, если он не изменяется.
	Если Не ИзменитьГрафикРаботы Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ГрафикРаботы");
	КонецЕсли;
	
	// Не требуется заполнять способ расчета аванса, если он не изменяется.
	Если Не ИзменитьАванс Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СпособРасчетаАванса");
	КонецЕсли;
	
	ПроверяемыйРеквизитЕжегодныеОтпуска = ПроверяемыеРеквизиты.Найти("ЕжегодныеОтпуска");
	Если ПроверяемыйРеквизитЕжегодныеОтпуска <> Неопределено Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыйРеквизитЕжегодныеОтпуска);
	КонецЕсли;
	
	// проверка КоличествоДнейВГод
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Для каждого Отпуск Из ЕжегодныеОтпуска Цикл
		Если НЕ ЗначениеЗаполнено(Отпуск.КоличествоДнейВГод) И НЕ ОстаткиОтпусков.ЭтоСтажевыйОтпуск(Отпуск.ВидЕжегодногоОтпуска) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не заполнено количество дней в год для отпуска %1'"), Отпуск.ВидЕжегодногоОтпуска);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "", ,Отказ);
		КонецЕсли;
	КонецЦикла;
	МассивНепроверяемыхРеквизитов.Добавить("ЕжегодныеОтпуска.КоличествоДнейВГод");
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	// Если производится операция бронирования позиции штатного расписания, то никаких действий больше не производится.
	ТолькоБронированиеПозиции = БронированиеПозиции И ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций");
	Если Не ТолькоБронированиеПозиции Тогда
	
		ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
		
		Если ИзменитьНачисления И НачисленияУтверждены Тогда
			
			КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(
				ЭтотОбъект, ДатаНачала, "Начисления,Льготы", "Показатели", Отказ, Истина, , "Начисление,Льгота", , Истина);
			
		КонецЕсли;
		
		ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Ссылка, Сотрудник, ДатаНачала);
		
		ДокументыДляИсключения = Новый Массив;
		ДокументыДляИсключения.Добавить(Ссылка);
		Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
			ДокументыДляИсключения.Добавить(ИсправленныйДокумент);
		КонецЕсли;
		КадровыйУчет.ПроверитьВозможностьПроведенияПоКадровомуУчету(ВремяРегистрации, Сотрудник, ДокументыДляИсключения, Отказ, Перечисления.ВидыКадровыхСобытий.Перемещение);
		
		Если ИзменитьПодразделениеИДолжность
			И Не ПроверкаСтрокиСписочногоДокумента Тогда
			
			ПроверяемаяСтруктура = СотрудникиФормыРасширенный.ПустаяСтруктураДляПроверкиКонфликтовВидовЗанятостиСотрудников();
			ЗаполнитьЗначенияСвойств(ПроверяемаяСтруктура, ЭтотОбъект);
			ПроверяемаяСтруктура.ДатаСобытия = ДатаНачала;
			
			ПроверяемыеСтруктуры = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПроверяемаяСтруктура);
			
			ДокументыДляИсключения = Новый Массив;
			ДокументыДляИсключения.Добавить(Ссылка);
			Если ЗначениеЗаполнено(ИсправленныйДокумент) Тогда
				ДокументыДляИсключения.Добавить(ИсправленныйДокумент);
			КонецЕсли;
			
			СообщениеОКонфликтах = СотрудникиФормыРасширенный.СообщениеОКонфликтахВидовЗанятостиСотрудников(
				ПроверяемыеСтруктуры, Организация, ДокументыДляИсключения);
			
			Для каждого КонфликтыСотрудника Из СообщениеОКонфликтах Цикл
				ОбщегоНазначения.СообщитьПользователю(КонфликтыСотрудника.Значение, Ссылка, "ВидЗанятости", "Объект", Отказ);
			КонецЦикла;
			
		КонецЕсли;
	
		ПроверитьИндивидуальныйГрафик(Отказ);
		
		Если Не ПроверкаСтрокиСписочногоДокумента Тогда
			ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		КонецЕсли;
		
		ОписаниеПолейСтажаПФР = УчетСтажаПФРРасширенный.ОписаниеПолейКадровогоПеревода();
		ОписаниеПолейСтажаПФР.ИмяПоляДатаОкончания = "ДатаОкончания";
		ОписаниеПолейСтажаПФР.ИмяПоляПризнакаСохраненияЛьготногоСтажа = "НаПериодПереводаСохранятьЛьготныйСтажПФР";
		ОписаниеПолейСтажаПФР.ИмяПоляВидСтажаПФР = "ВидСтажаПФР";
		
		УчетСтажаПФРРасширенный.ПроверитьДанныеКадровогоПеревода(ЭтотОбъект, ОписаниеПолейСтажаПФР, Отказ);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.КадровыйРезерв") Тогда 
			Модуль = ОбщегоНазначения.ОбщийМодуль("КадровыйРезерв");
			Модуль.ПроверитьЗаполнениеВидаРезерваВТабличнойЧасти(ЭтотОбъект, "КадровыйРезерв", ПроверяемыеРеквизиты, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.КадровыйПеревод.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.КадровыйПеревод.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		ДолжностьПозиции = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДолжностьПоШтатномуРасписанию, "Должность");
		Если Должность <> ДолжностьПозиции Тогда
			Должность = ДолжностьПозиции;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ДолжностьПоШтатномуРасписанию) Тогда
			ДолжностьПоШтатномуРасписанию = Справочники.ШтатноеРасписание.ПустаяСсылка();
		КонецЕсли; 
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения); 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НеРегистрироватьБухучет = НЕ ИзменитьПодразделениеИДолжность Или ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций") И БронированиеПозиции;
	ИмяТаблицы 			= "Документ.КадровыйПеревод";
	ИмяПоляПериод 		= "Таблица.ДатаНачала";
	ИмяПоляДействуетДо 	= "Таблица.ДатаОкончания";
	ОтражениеЗарплатыВБухучетеРасширенный.ОбновитьСведенияОБухучетеЗарплатыСотрудников(ЭтотОбъект,НеРегистрироватьБухучет,ИмяТаблицы,ИмяПоляПериод,ИмяПоляДействуетДо);	
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЦепочкиДокументов") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ЦепочкиДокументов");
		Модуль.УстановитьВторичныеРеквизитыДокументаЗамещения(ЭтотОбъект);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда.МедицинскиеОсмотры") Тогда
		МодульМедицинскиеОсмотры = ОбщегоНазначения.ОбщийМодуль("МедицинскиеОсмотры");
		МодульМедицинскиеОсмотры.ПриЗаписиДокументаОтстранения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПослеПереноса(ДанныеЗаполнения)
	
	ДанныеДокумента = ОстаткиОтпусков.ОписаниеПараметровДанныхКадровогоДокумента();
	ДанныеДокумента.Регистратор = Ссылка;
	ДанныеДокумента.Сотрудник 	= Сотрудник;
	ДанныеДокумента.ДатаСобытия = ДатаНачала;
	
	ДанныеНовойПозиции = ОстаткиОтпусков.ОписаниеПараметровДанныхПозиции();
	ДанныеНовойПозиции.ДолжностьПоШтатномуРасписанию = ДолжностьПоШтатномуРасписанию;
	ДанныеНовойПозиции.Подразделение 	= Подразделение;
	ДанныеНовойПозиции.Должность 		= Должность;
	ДанныеНовойПозиции.Территория 		= Территория;
	
	ОстаткиОтпусков.ЗаполнитьПоложеннымиПравамиСотрудника(ЕжегодныеОтпуска, ДанныеДокумента, ДанныеНовойПозиции);
	
	ЗапрашиваемыеЗначения = Новый Структура;
	ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
	ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
	ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
	ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	
КонецПроцедуры

Процедура ПроверитьСоответствиеПозицииШРПодразделению(Отказ)
	
	ИспользоватьШтатноеРасписание =  ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	Если ИспользоватьШтатноеРасписание И ЗначениеЗаполнено(ДолжностьПоШтатномуРасписанию) И ЗначениеЗаполнено(Подразделение) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ПодразделениеПоШтатномуРасписанию = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДолжностьПоШтатномуРасписанию, "Подразделение");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ПодразделениеПоШтатномуРасписанию <> Подразделение Тогда
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Позиция штатного расписания (%1) не соответствует выбранному подразделению'") + " (%2)",
					ДолжностьПоШтатномуРасписанию, Подразделение);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Подразделение", , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры	

Функция ИндивидуальныйГрафикНаМесяцПеревода() Экспорт 
	ДанныеГрафика = Новый Структура("Ссылка,Дата,Номер");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ИндивидуальныйГрафик.Ссылка,
	|	ИндивидуальныйГрафик.Номер,
	|	ИндивидуальныйГрафик.Дата
	|ИЗ
	|	Документ.ИндивидуальныйГрафик.ДанныеОВремени КАК ИндивидуальныйГрафикДанныеОВремени
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИндивидуальныйГрафик КАК ИндивидуальныйГрафик
	|		ПО ИндивидуальныйГрафикДанныеОВремени.Ссылка = ИндивидуальныйГрафик.Ссылка
	|ГДЕ
	|	ИндивидуальныйГрафикДанныеОВремени.Сотрудник = &Сотрудник
	|	И НАЧАЛОПЕРИОДА(ИндивидуальныйГрафик.ПериодРегистрации, МЕСЯЦ) = НАЧАЛОПЕРИОДА(&ДатаНачала, МЕСЯЦ)
	|	И ИндивидуальныйГрафик.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	ИндивидуальныйГрафик.Ссылка,
	|	ИндивидуальныйГрафик.Номер,
	|	ИндивидуальныйГрафик.Дата";
	Запрос.УстановитьПараметр("ДатаНачала", НачалоМесяца(ДатаНачала));
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ДанныеГрафика, Выборка);
	КонецЕсли;
	
	Возврат ДанныеГрафика
КонецФункции

Процедура ПроверитьИндивидуальныйГрафик(Отказ)
	Если НЕ ИзменитьГрафикРаботы
		Или ДатаНачала = НачалоМесяца(ДатаНачала) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьИндивидуальныйГрафикПриСменеГрафикаРаботы") Тогда
		Возврат;
	КонецЕсли;
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Ссылка, Сотрудник, ДатаНачала);
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), "ОсновноеНачисление,ГрафикРаботы", ВремяРегистрации - 1);
	Если КадровыеДанныеСотрудников.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ОсновноеНачисление = КадровыеДанныеСотрудников[0].ОсновноеНачисление;
	Если НЕ ЗначениеЗаполнено(ОсновноеНачисление) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОсновногоНачисления = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОсновноеНачисление, "ТребуетсяРасчетНормыВремени,УчетВремениВЧасах");
	ВремяВЧасах = ДанныеОсновногоНачисления.УчетВремениВЧасах;
	ТребуетсяРасчетНормыВремени = ДанныеОсновногоНачисления.ТребуетсяРасчетНормыВремени;
	
	Если ТребуетсяРасчетНормыВремени И НЕ УчетРабочегоВремениРасширенный.НормыПриСменеГрафиковСовпадают(КадровыеДанныеСотрудников[0].ГрафикРаботы, ГрафикРаботы, ДатаНачала, ВремяВЧасах) Тогда
		ДанныеИндивидуальногоГрафика = ИндивидуальныйГрафикНаМесяцПеревода();
		Если НЕ ЗначениеЗаполнено(ДанныеИндивидуальногоГрафика.Ссылка) Тогда
			ТекстСообщения = НСтр("ru = 'Изменение графика работы привело к изменению нормы рабочего времени. 
								|В такой ситуации необходимо обязательно ввести индивидуальный график на месяц в котором происходит перевод сотрудника.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли