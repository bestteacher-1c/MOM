#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыКартЛояльности.ТипКарты КАК ТипКарты,
	|	ВидыКартЛояльности.Персонализирована КАК Персонализирована
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности
	|ГДЕ
	|	ВидыКартЛояльности.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
	
		Если ЗначениеЗаполнено(Штрихкод) И (Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ Выборка.ТипКарты = Перечисления.ТипыКарт.Смешанная) Тогда
			
			КартыЛояльности = КартыЛояльностиВызовСервера.НайтиКартыЛояльностиПоШтрихкоду(Штрихкод);
			Для Каждого СтрокаТЧ Из КартыЛояльности.ЗарегистрированныеКартыЛояльности Цикл
				Если СтрокаТЧ.Ссылка <> Ссылка И СтрокаТЧ.ВидКарты = Владелец Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Такой штрихкод уже зарегистрирован для карты лояльности ""%1""'"), СтрокаТЧ.Ссылка),
						ЭтотОбъект,
						"Штрихкод",
						,
						Отказ);
				КонецЕсли;
			КонецЦикла;
			
			КартаСоответствуетДиапазону = Ложь;
			ВозможныеВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(Штрихкод, Перечисления.ТипыКодовКарт.Штрихкод);
			Для Каждого ВозможныйВидКарты Из ВозможныеВидыКарт Цикл
				Если ВозможныйВидКарты = Владелец Тогда
					КартаСоответствуетДиапазону = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ КартаСоответствуетДиапазону Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Штрихкод не входит в допустимый диапазон штрихкодов ""%1""'"), Владелец),
					ЭтотОбъект,
					"Штрихкод",
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(МагнитныйКод) И (Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ Выборка.ТипКарты = Перечисления.ТипыКарт.Смешанная) Тогда
			
			КартыЛояльности = КартыЛояльностиСервер.НайтиКартыЛояльностиПоМагнитномуКоду(МагнитныйКод);
			Для Каждого СтрокаТЧ Из КартыЛояльности.ЗарегистрированныеКартыЛояльности Цикл
				Если СтрокаТЧ.Ссылка <> Ссылка И СтрокаТЧ.ВидКарты = Владелец Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Такой магнитный код уже зарегистрирован для карты лояльности ""%1""'"), СтрокаТЧ.Ссылка),
						ЭтотОбъект,
						"МагнитныйКод",
						,
						Отказ);
				КонецЕсли;
			КонецЦикла;
			
			КартаСоответствуетДиапазону = Ложь;
			ВозможныеВидыКарт = КартыЛояльностиСервер.ПолучитьВозможныеВидыКартыЛояльностиПоКодуКарты(МагнитныйКод, Перечисления.ТипыКодовКарт.МагнитныйКод);
			Для Каждого ВозможныйВидКарты Из ВозможныеВидыКарт Цикл
				Если ВозможныйВидКарты = Владелец Тогда
					КартаСоответствуетДиапазону = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если НЕ КартаСоответствуетДиапазону Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Магнитный код не входит в допустимый диапазон штрихкодов ""%1""'"), Владелец),
					ЭтотОбъект,
					"МагнитныйКод",
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Штрихкод");
		КонецЕсли;
		Если Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
			МассивНепроверяемыхРеквизитов.Добавить("МагнитныйКод");
		КонецЕсли;
		Если Не Выборка.Персонализирована Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Партнер");
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыКартЛояльности.ТипКарты КАК ТипКарты,
	|	ВидыКартЛояльности.Персонализирована КАК Персонализирована
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности
	|ГДЕ
	|	ВидыКартЛояльности.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Магнитная Тогда
		Штрихкод = "";
	КонецЕсли;
	
	Если Выборка.ТипКарты = Перечисления.ТипыКарт.Штриховая Тогда
		МагнитныйКод = "";
	КонецЕсли;
	
	Если Не Выборка.Персонализирована Тогда
		Партнер    = Неопределено;
		Контрагент = Неопределено;
		Соглашение = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Наименование = "";
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
