
#Область СлужебныйПрограммныйИнтерфейс

// Получает информацию о виде расчета.
Функция ПолучитьИнформациюОВидеРасчета(ВидРасчета) Экспорт
	Возврат ЗарплатаКадрыРасширенныйПовтИсп.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
КонецФункции

Функция СведенияОПоказателеРасчетаЗарплаты(Показатель) Экспорт
	Возврат ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Показатель);
КонецФункции

Функция МаксимальноеКоличествоОтображаемыхПоказателей(ИмяПВР = "Начисления") Экспорт
	Возврат ЗарплатаКадрыРасширенныйПовтИсп.МаксимальноеКоличествоОтображаемыхПоказателей(ИмяПВР);
КонецФункции

Функция ИменаПредопределенныхПоказателей() Экспорт 
	
	Возврат ЗарплатаКадрыРасширенныйПовтИсп.ИменаПредопределенныхПоказателей();
	
КонецФункции

Процедура УтвердитьМногофункциональныеДокументы(МассивДокументов) Экспорт 
	
	МногофункциональныеДокументы = ЗарплатаКадрыРасширенныйКлиентСервер.ТипыМногофункциональныхДокументов();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Для Каждого ДокументСсылка Из МассивДокументов Цикл
		
		ТипДокумента = МногофункциональныеДокументы[ТипЗнч(ДокументСсылка)];
		
		// Документ не относится к многофункциональным.
		Если ТипДокумента = Неопределено Тогда
			ТекстОшибки = НСтр("ru='%1 - утверждение не требуется.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
			Продолжить;
		КонецЕсли;
		
		ДокументУтвержден = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументСсылка, ТипДокумента.РеквизитСостояние);
		
		// Документ уже утвержден
		Если ДокументУтвержден Тогда 
			ТекстОшибки = НСтр("ru='%1 - документ уже утвержден.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
			Продолжить;
		КонецЕсли;
		
		// Захват объекта для редактирования.
		Попытка
			ЗаблокироватьДанныеДляРедактирования(ДокументСсылка);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось заблокировать %1. %2'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
			Продолжить;
		КонецПопытки;
		
		// Получение объекта документа.
		Объект = ДокументСсылка.ПолучитьОбъект();
		
		ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
		Если Не ПраваНаДокумент.ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений Тогда 
			ТекстОшибки = НСтр("ru='%1 - недостаточно прав для утверждения документа.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
			Продолжить;
		КонецЕсли;
		
		Объект.ПометкаУдаления = Ложь;
		Объект[ТипДокумента.РеквизитСостояние] = Истина;
		Если ТипДокумента.ВторойОтветственный <> Неопределено Тогда 
			Объект[ТипДокумента.ВторойОтветственный] = ТекущийПользователь;
		КонецЕсли;
		
		Если Не Объект.ПроверитьЗаполнение() Тогда 
			ТекстОшибки = НСтр("ru='%1 - обнаружены ошибки при проверке заполнения документа.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка);
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
			Продолжить;
		КонецЕсли;
		
		// Запись документа
		Попытка
			Объект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ТекстОшибки = НСтр("ru='Не удалось записать %1. %2'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДокументСсылка, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ДокументСсылка);
		КонецПопытки
		
	КонецЦикла;
	
КонецПроцедуры

Функция СравнитьРезультатыРаспределения(Массив1, Массив2, ПутьКДаннымРаспределениеРезультатов) Экспорт
	
	Если СтрНайти(ПутьКДаннымРаспределениеРезультатов, "РаспределениеРезультатовНачислений") > 0 Тогда
		Таблица1 = ОтражениеЗарплатыВБухучетеРасширенный.НоваяТаблицаРаспределениеРезультатовНачислений();
	Иначе
		Таблица1 = ОтражениеЗарплатыВУчете.НоваяТаблицаРаспределениеРезультатовУдержаний();
	КонецЕсли;
	Таблица2 = Таблица1.СкопироватьКолонки();
	
	Для каждого Значение Из Массив1 Цикл
		ЗаполнитьЗначенияСвойств(Таблица1.Добавить(), Значение);
	КонецЦикла;
	Для каждого Значение Из Массив2 Цикл
		ЗаполнитьЗначенияСвойств(Таблица2.Добавить(), Значение);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.КоллекцииИдентичны(Таблица1, Таблица2, ,"ИдентификаторСтроки");

КонецФункции 

Функция ОписаниеШкалыПорядкаНачисленияПроцентовСевернойНадбавки(ПорядокНачисления) Экспорт
	
	Возврат Перечисления.ПорядокНачисленияСеверныхНадбавок.ОписаниеШкалыПоПорядкуНачисления(ПорядокНачисления);
	
КонецФункции

Функция ФизическоеЛицоСотрудника(Сотрудник) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо");
	
КонецФункции

Функция ДанныеТарифныхСеток(Знач ТарифнаяСетка, Знач РазрядКатегория, Знач ТарифнаяСеткаНадбавки, Знач РазрядКатегорияНадбавки, Знач ДатаСведений, Знач СчитатьПоказателиПоДолжности, Знач ПКУ) Экспорт
	
	РаботаВХозрасчетнойОрганизации = ПолучитьФункциональнуюОпцию("РаботаВХозрасчетнойОрганизации");
	
	ДанныеСеток = Новый Структура;
	
	Если РаботаВХозрасчетнойОрганизации Тогда 
		ДанныеСеток.Вставить("СписокПоказателейОклад", РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Ложь));
		ДанныеСеток.Вставить("СписокПоказателейОкладПоДолжности", РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина, Ложь));
	Иначе 
		ДанныеСеток.Вставить("СписокПоказателейОклад", Новый Массив);
		ДанныеСеток.Вставить("СписокПоказателейОкладПоДолжности", РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСетка, Истина, Истина));
	КонецЕсли;
	
	ДанныеСеток.Вставить("СписокПоказателейКвалификационнаяНадбавка", РазрядыКатегорииДолжностей.ПоказателиТарифнойСетки(ТарифнаяСеткаНадбавки, Ложь));
	
	Если РаботаВХозрасчетнойОрганизации Тогда 
		ДанныеСеток.Вставить("ЗначениеПоказателейОклад", РазрядыКатегорииДолжностей.ЗначениеПоказателейТарифнойСетки(ТарифнаяСетка,
			?(СчитатьПоказателиПоДолжности, РазрядКатегория, РазрядКатегорияНадбавки), ДатаСведений));
	Иначе 
		ДанныеСеток.Вставить("ЗначениеПоказателейОклад", Неопределено);
	КонецЕсли;
	
	ИспользоватьПКУДокумента = Не РаботаВХозрасчетнойОрганизации И ПКУ <> Неопределено 
		И ПолучитьФункциональнуюОпцию("РазрешеноИзменениеПКУВКадровыхДокументах");
	Разряд = ?(ИспользоватьПКУДокумента, ПКУ, РазрядКатегория);
	
	ДанныеСеток.Вставить("ЗначениеПоказателейОкладПоДолжности", РазрядыКатегорииДолжностей.ЗначениеПоказателейТарифнойСетки(ТарифнаяСетка, Разряд, ДатаСведений));
	ДанныеСеток.Вставить("ЗначениеПоказателейНадбавка", РазрядыКатегорииДолжностей.ЗначениеПоказателейТарифнойСетки(ТарифнаяСеткаНадбавки, РазрядКатегорияНадбавки, ДатаСведений));
	
	ДанныеТарифнойСетки = РазрядыКатегорииДолжностей.ДанныеТарифнойСетки(ТарифнаяСетка, ДатаСведений);
	
	ЗначенияТарифов = Новый Соответствие;
	Для Каждого ДанныеТарифа Из ДанныеТарифнойСетки.ЗначенияТарифов Цикл 
		ЗначенияТарифов.Вставить(ДанныеТарифа.РазрядКатегория, ДанныеТарифа.Тариф);
	КонецЦикла;
	
	ДанныеСеток.Вставить("ЗначенияТарифов", ЗначенияТарифов);
	ДанныеСеток.Вставить("СписокПоказателейДоплатыЗаКвалификацию", РазрядыКатегорииДолжностей.СписокПоказателейДоплатыЗаКвалификацию());
	
	Возврат ДанныеСеток;
	
КонецФункции

Функция ОписаниеСпособаОкругления(Знач СпособОкругления) Экспорт
	
	Если Не ЗначениеЗаполнено(СпособОкругления) Тогда
		СпособОкругления = Справочники.СпособыОкругленияПриРасчетеЗарплаты.ПоУмолчанию();
	КонецЕсли; 
			
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СпособОкругления, "Точность,ПравилоОкругления");;
	
КонецФункции

Функция СведенияОбОтветственныхЛицах(СписокФизическихЛиц) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	СведенияОбОтветственных = Новый ТаблицаЗначений;
	СведенияОбОтветственных.Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	СведенияОбОтветственных.Колонки.Добавить("ПредставлениеДолжности", Новый ОписаниеТипов("Строка"));
	СведенияОбОтветственных.Колонки.Добавить("СтруктурнаяЕдиница", Новый ОписаниеТипов());
	
	ЗарплатаКадрыРасширенныйПереопределяемый.ЗаполнитьСведенияОбОтветственныхЛицах(СписокФизическихЛиц, СведенияОбОтветственных, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.СведенияОбОтветственныхЛицах") Тогда
			
			МодульСведенияОбОтветственныхЛицах = ОбщегоНазначения.ОбщийМодуль("СведенияОбОтветственныхЛицах");
			МодульСведенияОбОтветственныхЛицах.ЗаполнитьСведенияОбОтветственныхЛицах(СписокФизическихЛиц, СведенияОбОтветственных);
			
		КонецЕсли;
		
	КонецЕсли; 
	
	СоответствиеПоСтруктурнымЕдиницам = Новый Соответствие;
	
	Если СведенияОбОтветственных.Количество() > 0 Тогда
		
		Для каждого СтрокаСведенияОбОтветственных Из СведенияОбОтветственных Цикл
			
			ОтветственныеОрганизации = СоответствиеПоСтруктурнымЕдиницам.Получить(СтрокаСведенияОбОтветственных.СтруктурнаяЕдиница);
			Если ОтветственныеОрганизации = Неопределено Тогда
				ОтветственныеОрганизации = Новый СписокЗначений;
			КонецЕсли; 
			ОтветственныеОрганизации.Добавить(СтрокаСведенияОбОтветственных.ФизическоеЛицо, СтрокаСведенияОбОтветственных.ПредставлениеДолжности);
			
			СоответствиеПоСтруктурнымЕдиницам.Вставить(СтрокаСведенияОбОтветственных.СтруктурнаяЕдиница, ОтветственныеОрганизации);
			
		КонецЦикла;
		
		Для каждого КлючИЗначение Из СоответствиеПоСтруктурнымЕдиницам Цикл
			КлючИЗначение.Значение.СортироватьПоЗначению();
		КонецЦикла;
		
	КонецЕсли; 
	
	Возврат СоответствиеПоСтруктурнымЕдиницам;
	
КонецФункции

Функция СтруктураПоМетаданным(ПолноеИмяОбъектаМетаданных) Экспорт
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	СтруктураОписания = Новый Структура;
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		СтруктураОписания.Вставить(Реквизит.Имя);
	КонецЦикла;
	
	ТабличныеЧастиОбъекта = Новый Структура;
	ОписаниеТабличныхЧастей = Новый Структура;
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		
		Если ТабличнаяЧасть.Имя = "ДополнительныеРеквизиты" Тогда
			Продолжить;
		КонецЕсли;
		
		ИменаРеквизитов = "";
		ДобавитьЗапятую = Ложь;
		Для каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
			
			Если Не ДобавитьЗапятую Тогда
				ДобавитьЗапятую = Истина;
			Иначе
				ИменаРеквизитов = ИменаРеквизитов + ",";
			КонецЕсли; 
			ИменаРеквизитов = ИменаРеквизитов + Реквизит.Имя;
			
		КонецЦикла;
		
		ОписаниеТабличныхЧастей.Вставить(ТабличнаяЧасть.Имя, ИменаРеквизитов);
		ТабличныеЧастиОбъекта.Вставить(ТабличнаяЧасть.Имя, Новый Массив);
		
	КонецЦикла;
	
	ТабличныеЧастиОбъекта.Вставить("ОписаниеТабличныхЧастей", ОписаниеТабличныхЧастей);
	
	СтруктураОписания.Вставить("ТабличныеЧасти", ТабличныеЧастиОбъекта);
	
	Возврат СтруктураОписания;
	
КонецФункции

Процедура ПередОбновлениемИнтерфейса() Экспорт

	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		Константы.НеИспользоватьНачислениеЗарплаты.Установить(Константы.НеИспользоватьНачислениеЗарплаты.Получить());
	КонецЕсли;

КонецПроцедуры

Функция КоличествоОтображаемыхПоказателей(РежимРаботы, ИмяПВР = "Начисления", ДокументСсылка = Неопределено) Экспорт
	Возврат ЗарплатаКадрыРасширенныйПовтИсп.КоличествоОтображаемыхПоказателей(РежимРаботы, ИмяПВР, ДокументСсылка);
КонецФункции

Функция ЭтоСеверныйСтаж(ВидСтажа) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидСтажа, "КатегорияСтажа") = Перечисления.КатегорииСтажа.Северный;
	
КонецФункции

#КонецОбласти
