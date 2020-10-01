#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	ЗначениеНовогоСтатуса = Перечисления.СтатусыПланов[НовыйСтатус];
	
	Статус = ЗначениеНовогоСтатуса;
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроверитьДействиеМоделиБюджетирования(РежимЗаписи, Отказ);

	ПараметрыОпции = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", ПараметрыОпции) Тогда
		Статус = Перечисления.СтатусыПланов.Утвержден;
	КонецЕсли;
	
	ПроведениеСерверУТ.УстановитьРежимПроведения(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	// Инициализация данных документа
	Документы.ЭкземплярБюджета.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Движения по регистрам
	РегистрыНакопления.ОборотыБюджетов.ОтразитьДвижения(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "ПроводитьЭкземплярыБюджетовОтложено") Тогда
		БюджетированиеСервер.ПоставитьДокументВОчередьПроведения(Ссылка);
		БюджетированиеСервер.ЗапуститьОтложенноеПроведениеФоновымЗаданием(Ссылка);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	СтруктураПараметров = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоОрганизациям", СтруктураПараметров) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ФормироватьБюджетыПоПодразделениям", СтруктураПараметров) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Подразделение");
	КонецЕсли;
	
	ИспользоватьУтверждениеБюджетов = ПолучитьФункциональнуюОпцию("ИспользоватьУтверждениеБюджетов", СтруктураПараметров);
	СтатусСохраненногоДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Статус");

	Если ИспользоватьУтверждениеБюджетов 
		И Не Пользователи.РолиДоступны("УтверждениеЭкземпляровБюджетов",, Ложь) Тогда
			ЕстьОшибкаДоступа = Истина;
			
			Если Статус = Перечисления.СтатусыПланов.Утвержден Тогда
				ТекстОшибки = НСтр("ru='Нет доступа на утверждение экземпляров бюджетов.'");
			ИначеЕсли СтатусСохраненногоДокумента = Перечисления.СтатусыПланов.Утвержден Тогда
				ТекстОшибки = НСтр("ru='Нет доступа на изменение утвержденных экземпляров бюджетов.'");
			Иначе
				ЕстьОшибкаДоступа = Ложь;
			КонецЕсли;
			
			Если ЕстьОшибкаДоступа Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,
					, // Поле
					, // ПутьКДанным
					Отказ);
			КонецЕсли;
	КонецЕсли;
		
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("НачалоПериода") Тогда
		НачалоПериода = ДанныеЗаполнения.НачалоПериода;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОкончаниеПериода") Тогда
		ОкончаниеПериода = ДанныеЗаполнения.ОкончаниеПериода;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ВидБюджета") Тогда
		ВидБюджета = ДанныеЗаполнения.ВидБюджета;
		МодельБюджетирования = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидБюджета, "Владелец");
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Сч = 1;
		Пока Сч <=6 Цикл
			Если ДанныеЗаполнения.Свойство("Аналитика" + Сч) Тогда
				ЭтотОбъект["Аналитика" + Сч] = ДанныеЗаполнения["Аналитика" + Сч];
			КонецЕсли;
			Сч = Сч + 1;
		КонецЦикла;
	КонецЕсли;

	
	Если Не ЗначениеЗаполнено(НачалоПериода) ИЛИ Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		
		ТекущаяДата = ТекущаяДатаСеанса();
		Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
			НачалоПериода = ТекущаяДата;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
			ОкончаниеПериода = ТекущаяДата;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидБюджета) Тогда
			Справочники.ВидыБюджетов.ВыровнятьДатыПоПериодичностиБюджета(ВидБюджета, НачалоПериода, ОкончаниеПериода);
		КонецЕсли;
		
	КонецЕсли;
	
	ГраницаФактДанных = Справочники.ВидыБюджетов.ГраницаФактическихДанныхПоВидуБюджета(ВидБюджета, НачалоПериода);
	
	Если Не ЗначениеЗаполнено(МодельБюджетирования) Тогда
		МодельБюджетирования = Справочники.МоделиБюджетирования.МодельБюджетированияПоУмолчанию();
	КонецЕсли;
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры


Процедура ПроверитьДействиеМоделиБюджетирования(РежимЗаписи, Отказ)
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Действует = Справочники.МоделиБюджетирования.МодельБюджетированияДействует(МодельБюджетирования);
		Если НЕ Действует Тогда
			ТекстОшибки = НСтр("ru='Проведение документа запрещено, модель бюджетирования не действует.'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОшибки,
					ЭтотОбъект,,,
					Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
