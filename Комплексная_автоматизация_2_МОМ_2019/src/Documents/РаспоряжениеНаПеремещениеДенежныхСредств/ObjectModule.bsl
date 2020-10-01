#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
// 		НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
// 		ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
// 		Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Валюта") Тогда
			Валюта = ДанныеЗаполнения.Валюта;
		КонецЕсли;
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.НеСогласовано;
	ДатаПлатежа = Дата(1, 1, 1);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если (Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате
		Или Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано)
		И ЗначениеЗаполнено(ДатаПлатежа)
		И ДатаПлатежа < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru='Дата платежа не может быть меньше даты документа'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаПлатежа",
			, // ПутьКДанным
			Отказ);
	КонецЕсли;
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
		
	ДенежныеСредстваСервер.ПроверитьКассуПолучателя(ЭтотОбъект, Отказ);
	ДенежныеСредстваСервер.ПроверитьБанковскийСчетПолучатель(ЭтотОбъект, Отказ);
	
	Если Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано Тогда
		
		ПравоСогласования = ПраваПользователяПовтИсп.СогласованиеРаспоряженийНаПеремещениеДенежныхСредств();
		Если Не ПравоСогласования Тогда
			ТекстОшибки = НСтр("ru='У вас нет права согласования распоряжений на перемещение денежных средств.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате Тогда
		
		ПравоУтверждения = ПраваПользователяПовтИсп.УтверждениеРаспоряженийНаПеремещениеДенежныхСредств();
		Если Не ПравоУтверждения Тогда
			ТекстОшибки = НСтр("ru='У вас нет права утверждения к оплате распоряжений на перемещение денежных средств.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,
				, // Поле
				, // ПутьКДанным
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	//++ НЕ УТ
	Если Не ПлатежиПо275ФЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ТипПлатежаФЗ275");
	КонецЕсли;
	//-- НЕ УТ
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано Тогда
			Если КтоРешил <> Пользователи.ТекущийПользователь() Тогда
				КтоРешил = Пользователи.ТекущийПользователь();
			КонецЕсли;
		ИначеЕсли Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате Тогда
			Если Не ЗначениеЗаполнено(КтоРешил) Тогда
				КтоРешил = Пользователи.ТекущийПользователь();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПредопределеннаяСтатьяДДС(ХозяйственнаяОперация, Валюта);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по регистрам
	Движения.ДенежныеСредстваКВыплате.ДополнительныеСвойства.Вставить("РассчитыватьИзменения", Истина);
	ДенежныеСредстваСервер.ОтразитьДенежныеСредстваКВыплате(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Валюта = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(Валюта);
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Организация, Валюта);
		КассаПолучатель = Касса;
		БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, Валюта);
		БанковскийСчетПолучатель = БанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
