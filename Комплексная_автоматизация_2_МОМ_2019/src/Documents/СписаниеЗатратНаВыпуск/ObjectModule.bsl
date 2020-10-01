#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("ДанныеШапки") Тогда
			
			ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
			
		ИначеЕсли ДанныеЗаполнения.Свойство("Период") Тогда
			
			Если ДанныеЗаполнения.Период < НачалоМесяца(ТекущаяДатаСеанса()) Тогда
				Дата = КонецМесяца(ДанныеЗаполнения.Период);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "ВыходныеИзделия";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = ОбщегоНазначенияУТ.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "ВозвратныеОтходы";
	ПараметрыПроверки.ПроверитьВозможностьОкругления = Ложь;
	ОбщегоНазначенияУТ.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеЗатратНаВыпуск);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
	Если Не Справочники.Номенклатура.ХарактеристикиИспользуются(Номенклатура) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Характеристика");
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура("Номенклатура, Характеристика");
	ЗаполнитьЗначенияСвойств(СтруктураОтбора, ЭтотОбъект);
	НайденныеСтроки = ВыходныеИзделия.НайтиСтроки(СтруктураОтбора);
	
	КоличествоПоТЧ = 0;
	Для Каждого Строка Из НайденныеСтроки Цикл
		КоличествоПоТЧ = КоличествоПоТЧ + Строка.Количество;
	КонецЦикла;
	
	Если КоличествоПоТЧ <> Количество Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Количество продукции по документу не соответствует табличной части.'"),
			ЭтотОбъект,
			"Количество",
			,
			Отказ);
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СтруктураКлючейАналитики = Новый Структура("Номенклатура,Характеристика,Склад,Серия, Назначение");
	ЗаполнитьЗначенияСвойств(СтруктураКлючейАналитики, ЭтотОбъект);
	СтруктураКлючейАналитики.Склад = Подразделение;
	
	УстановитьПривилегированныйРежим(Истина);
	АналитикаУчетаПродукции = РегистрыСведений.АналитикаУчетаНоменклатуры.ЗначениеКлючаАналитики(СтруктураКлючейАналитики);
	УстановитьПривилегированныйРежим(Ложь);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеЗатратНаВыпуск);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(Неопределено, Неопределено, Неопределено, Неопределено);
		
		ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
		ИменаПолей.Вставить("Произвольный", "Подразделение");
		ИменаПолей.Вставить("Работа", "Подразделение");
		
		РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(МатериалыИУслуги, МестаУчета, ИменаПолей);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.СписаниеЗатратНаВыпуск.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по регистрам
	ЗатратыСервер.ОтразитьМатериалыИРаботыВПроизводстве(ДополнительныеСвойства, Движения, Отказ);
	ЗатратыСервер.ОтразитьРаспоряженияНаСписаниеПоНормативам(ДополнительныеСвойства, Движения, Отказ);
	СкладыСервер.ОтразитьДвиженияСерийТоваров(ДополнительныеСвойства, Движения, Отказ);
	
	// Завершение проведения
	СформироватьСписокРегистровДляКонтроля();
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.ДанныеШапки);
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения.ДанныеШапки.Период) 
		И ДанныеЗаполнения.ДанныеШапки.Период < НачалоМесяца(ТекущаяДатаСеанса()) Тогда
		Дата = КонецМесяца(ДанныеЗаполнения.ДанныеШапки.Период);
	КонецЕсли;
	
	Если ДанныеЗаполнения.ДанныеШапки.Свойство("ОтборПоСпецификации") 
		Или ДанныеЗаполнения.Свойство("ВыходныеИзделия")
		Или ДанныеЗаполнения.Свойство("Распоряжения") Тогда
		ПараметрыОтбора = Новый Структура("Период, Организация, Спецификация, Назначение");
	Иначе
		ПараметрыОтбора = Новый Структура("Период, Организация, Спецификация, Номенклатура, Характеристика, Серия, Назначение");
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("ВыходныеИзделия") Тогда
		ПараметрыОтбора.Вставить("ВыходныеИзделия", ДанныеЗаполнения.ВыходныеИзделия);
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("Распоряжения") Тогда
		ПараметрыОтбора.Вставить("Распоряжения", ДанныеЗаполнения.Распоряжения);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПараметрыОтбора, ДанныеЗаполнения.ДанныеШапки);
	
	ДанныеРаспоряжений = Документы.СписаниеЗатратНаВыпуск.РезультатыЗапросовПоОстаткамКОформлению(ПараметрыОтбора);
	
	СтрокиРаспоряжений = ДанныеРаспоряжений.Распоряжения.Выгрузить();
	
	Документы.СписаниеЗатратНаВыпуск.ЗаполнитьДокументПоНормативам(ЭтотОбъект, СтрокиРаспоряжений);
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный             = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура СформироватьСписокРегистровДляКонтроля()
	
	Массив = Новый Массив;
	
	Если ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Массив.Добавить(Движения.РаспоряженияНаСписаниеПоНормативам);
	КонецЕсли;
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
