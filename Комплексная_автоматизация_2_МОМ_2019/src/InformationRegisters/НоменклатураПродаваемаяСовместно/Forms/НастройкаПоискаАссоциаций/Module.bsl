
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПериодПоискаАссоциацийОписание = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(
			Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
			Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно));
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
	
		Элементы.НастроитьРасписание.Видимость = Ложь;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПериодПоискаАссоциацийОписание = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(
			Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
			Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно));
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовПриИзменении(Элемент)
	
	ПериодПоискаАссоциацийОписание = СтрШаблон(НСтр("ru = 'По данным за период: %1.'"),
		ОбеспечениеКлиентСервер.ОписаниеНастройки(
			Константы.ПериодичностьДляАнализаНоменклатурыПродаваемойСовместно,
			Константы.КоличествоПериодовДляАнализаНоменклатурыПродаваемойСовместно));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	
	Идентификатор = ПолучитьИдентификаторРегламетногоЗадания();
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписаниеРегламентногоЗадания(Идентификатор));
	Диалог.Показать(Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект, Новый Структура("Идентификатор", Идентификатор)));
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Идентификатор = ДополнительныеПараметры.Идентификатор;
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Расписание);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервереБезКонтекста
Функция ПолучитьИдентификаторРегламетногоЗадания()
	
	УстановитьПривилегированныйРежим(Истина);
	Задание = РегламентныеЗаданияСервер.Задание(Метаданные.РегламентныеЗадания.ОбновлениеНоменклатурыПродаваемойСовместно);
	Возврат РегламентныеЗаданияСервер.УникальныйИдентификатор(Задание);
	
КонецФункции

&НаСервереБезКонтекста
Функция УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Знач Расписание)
	
	ПараметрыЗадания = Новый Структура("Расписание", Расписание);
	РегламентныеЗаданияСервер.ИзменитьЗадание(Идентификатор, ПараметрыЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРасписаниеРегламентногоЗадания(Идентификатор)
	
	Задание = РегламентныеЗаданияСервер.Задание(Идентификатор);
	Возврат Задание.Расписание;
	
КонецФункции

#КонецОбласти

#КонецОбласти
