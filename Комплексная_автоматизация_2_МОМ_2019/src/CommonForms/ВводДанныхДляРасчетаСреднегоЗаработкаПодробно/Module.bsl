#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущаяКорректировка;

&НаКлиенте
Перем ТекущаяСумма;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СоставнаяЧасть") Тогда
		СоставнаяЧасть = Параметры.СоставнаяЧасть;
	КонецЕсли;
	Если Параметры.Свойство("Месяц") Тогда
		Месяц = Параметры.Месяц;
	КонецЕсли;
	Сотрудник = Параметры.Сотрудник;
	ИспользоватьИсточникиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплатаРасширенный");
	ИспользоватьСтатьиРасходов = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользуетсяЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД") Или ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВДВБюджетномУчреждении");
	
	ЭтоГодоваяПремия = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ГодовыеПремии().Найти(СоставнаяЧасть) <> Неопределено;
	ГодГодовыхПремий = Параметры.Год;
	
	Если ЭтоГодоваяПремия Тогда
		Заголовок = Строка(СоставнаяЧасть);
		ТекстПодсказки = СтрШаблон(НСтр("ru = 'Расшифровка годовой премии сотрудника %1 за %2'"), Сотрудник, Формат(Параметры.Год, "ЧГ=")); 
	Иначе
		ШаблонПредставления = НСтр("ru = 'Заработок за %2'");
		Если ЗначениеЗаполнено(СоставнаяЧасть) Тогда
			ШаблонПредставления = НСтр("ru = '%1 за %2'");
		КонецЕсли;
		Заголовок = СтрШаблон(ШаблонПредставления, СоставнаяЧасть, Формат(Месяц, "ДФ='ММММ гггг'"));
		ТекстПодсказки = СтрШаблон(НСтр("ru = 'Расшифровка среднего заработка сотрудника %1 за %2'"), Сотрудник, Формат(Месяц, "ДФ='ММММ гггг'")); 
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СреднийЗаработок", "Подсказка", ТекстПодсказки);
		
	УстановитьВидимостьКолонок();
	
	ЗаполнитьДанныеФормы(Параметры.ДанныеРасшифровки);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СреднийЗаработокПриИзменении(Элемент)
	
	СуммаИтог = СреднийЗаработок.Итог("Сумма");
	СуммаНеИндексируетсяИтог = СреднийЗаработок.Итог("СуммаНеИндексируется");
	
КонецПроцедуры

&НаКлиенте
Процедура СреднийЗаработокСуммаВсегоПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.СреднийЗаработок.ТекущиеДанные;
	ДанныеСтроки.СуммаНеИндексируется = Мин(ДанныеСтроки.СуммаНеИндексируется, ДанныеСтроки.Сумма);
	
КонецПроцедуры

&НаКлиенте
Процедура СреднийЗаработокСуммаНеИндексируетсяПриИзменении(Элемент)
	
	ДанныеСтроки = Элементы.СреднийЗаработок.ТекущиеДанные;
	ДанныеСтроки.Сумма = Макс(ДанныеСтроки.СуммаНеИндексируется, ДанныеСтроки.Сумма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеДанныхРасшифровки(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть(ДанныеРасшифровки());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКолонок()
	
	// Настроим видимость существующих колонок.
	
	// Премии
	ЭтоПремия = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.Премии().Найти(СоставнаяЧасть) <> Неопределено;
	ЭтоГодоваяПремия = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ГодовыеПремии().Найти(СоставнаяЧасть) <> Неопределено;
	Элементы.СреднийЗаработокДатаНачалаБазовогоПериода.Видимость = ЭтоПремия;
	Элементы.СреднийЗаработокКоличествоМесяцев.Видимость = ЭтоПремия И Не ЭтоГодоваяПремия;
	
	// Видимость колонки неиндексируемой суммы устанавливаем по настройке.
	ВидимостьСуммыНеИндексируется = Ложь;
	НастройкиРасчета = УчетСреднегоЗаработка.НастройкиРасчетаСреднегоЗаработка();
	Если СоставнаяЧасть = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ОбщийЗаработок Тогда
		ВидимостьСуммыНеИндексируется = НастройкиРасчета.ИспользоватьОсновныеНачисленияБезИндексации;
	ИначеЕсли СоставнаяЧасть = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ПремияПроцентом Тогда
		ВидимостьСуммыНеИндексируется = НастройкиРасчета.ИспользоватьПремииПроцентомБезИндексации;
	ИначеЕсли СоставнаяЧасть = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ПремияФиксированнойСуммой Тогда
		ВидимостьСуммыНеИндексируется = НастройкиРасчета.ИспользоватьПремииСуммойБезИндексации;
	ИначеЕсли СоставнаяЧасть = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ПремияГодоваяПроцентом Тогда
		ВидимостьСуммыНеИндексируется = НастройкиРасчета.ИспользоватьПремииЗаГодПроцентомБезИндексации;
	ИначеЕсли СоставнаяЧасть = Перечисления.УчетНачисленийВСреднемЗаработкеОбщий.ПремияГодоваяФиксированнойСуммой Тогда
		ВидимостьСуммыНеИндексируется = НастройкиРасчета.ИспользоватьПремииЗаГодСуммойБезИндексации;
	КонецЕсли;
	Элементы.СреднийЗаработокСуммаНеИндексируется.Видимость = ВидимостьСуммыНеИндексируется;
	
	// Если премия годовая, имеет значение, в каком месяце она начислена
	Элементы.СреднийЗаработокПериод.Видимость = ЭтоГодоваяПремия;
	
	// Статьи финансирования
	Элементы.СреднийЗаработокСтатьяФинансирования.Видимость = ИспользоватьИсточникиФинансирования;
	Элементы.СреднийЗаработокСтатьяРасходов.Видимость = ИспользоватьСтатьиРасходов;
	Элементы.СреднийЗаработокОблагаетсяЕНВД.Видимость = ИспользуетсяЕНВД;
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДанныеФормы(ДанныеРасшифровки)
	
	ОтборСтрок = Новый Структура(
		"ДатаНачалаБазовогоПериода, 
		|Год, 
		|КоличествоМесяцев, 
		|СтатьяФинансирования,
		|СпособОтраженияЗарплатыВБухучете,
		|СтатьяРасходов,
		|ОблагаетсяЕНВД,
		|Период");
		
	Для Каждого СтрокаРасшифровки Из ДанныеРасшифровки Цикл
		ЗаполнитьЗначенияСвойств(ОтборСтрок, СтрокаРасшифровки);
		НайденныеСтроки = СреднийЗаработок.НайтиСтроки(ОтборСтрок);
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокаТаблицы = СреднийЗаработок.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ОтборСтрок);
		Иначе
			СтрокаТаблицы = НайденныеСтроки[0];
		КонецЕсли;
		СтрокаТаблицы.Сумма = СтрокаТаблицы.Сумма + СтрокаРасшифровки.Сумма;
		Если СтрокаРасшифровки.Свойство("Индексируется") И Не СтрокаРасшифровки.Индексируется Тогда
			СтрокаТаблицы.СуммаНеИндексируется = СтрокаТаблицы.СуммаНеИндексируется + СтрокаРасшифровки.Сумма;
		КонецЕсли;
	КонецЦикла;	
	
	СуммаИтог = СреднийЗаработок.Итог("Сумма");
	СуммаНеИндексируетсяИтог = СреднийЗаработок.Итог("СуммаНеИндексируется");
	
КонецПроцедуры	

&НаКлиенте
Функция ДанныеРасшифровки()
	
	ДанныеРасшифровки = Новый Массив;
	Для Каждого СтрокаТаблицы Из СреднийЗаработок Цикл
		ОписаниеСтроки = УчетСреднегоЗаработкаКлиентСервер.ОписаниеСтрокиДанныхОНачисленияхОбщегоСреднегоЗаработка();
		ДанныеРасшифровки.Добавить(ОписаниеСтроки);
		ЗаполнитьЗначенияСвойств(ОписаниеСтроки, СтрокаТаблицы);
		ОписаниеСтроки.Сотрудник = Сотрудник;
		ОписаниеСтроки.СоставнаяЧасть = СоставнаяЧасть;
		ОписаниеСтроки.Индексируется = Истина;
		ОписаниеСтроки.Сумма = СтрокаТаблицы.Сумма - СтрокаТаблицы.СуммаНеИндексируется;
		Если ЭтоГодоваяПремия Тогда
			ОписаниеСтроки.Год = ГодГодовыхПремий;
		Иначе
			// Для годовых премий не заполняем, так как может быть использовано несколько дат начислений.
			ОписаниеСтроки.Период = Месяц;
		КонецЕсли;
		Если СтрокаТаблицы.СуммаНеИндексируется > 0  Тогда
			// Если введена неиндексируемая сумма, добавляем ее отдельной строкой.
			ОписаниеСтроки = УчетСреднегоЗаработкаКлиентСервер.ОписаниеСтрокиДанныхОНачисленияхОбщегоСреднегоЗаработка();
			ДанныеРасшифровки.Добавить(ОписаниеСтроки);
			ЗаполнитьЗначенияСвойств(ОписаниеСтроки, СтрокаТаблицы);
			ОписаниеСтроки.Сотрудник = Сотрудник;
			ОписаниеСтроки.СоставнаяЧасть = СоставнаяЧасть;
			ОписаниеСтроки.Индексируется = Ложь;
			ОписаниеСтроки.Сумма = СтрокаТаблицы.СуммаНеИндексируется;
			Если ЭтоГодоваяПремия Тогда
				ОписаниеСтроки.Год = ГодГодовыхПремий;
			Иначе
				ОписаниеСтроки.Период = Месяц;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДанныеРасшифровки;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьЗаполнениеДанныхРасшифровки(Отказ)
	
	// Во всех строках обязательно должны быть заполнены суммы и статьи финансирования (если они используются).
	Индекс = 0;
	Пока Индекс < СреднийЗаработок.Количество() Цикл
		Если Не ЗначениеЗаполнено(СреднийЗаработок[Индекс].Сумма) Тогда
			ИмяПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("СреднийЗаработок[%1].Сумма", Индекс);
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Сумма не заполнена.'"), , ИмяПоля, , Отказ);
		КонецЕсли;
		Если ИспользоватьИсточникиФинансирования Тогда
			Если Не ЗначениеЗаполнено(СреднийЗаработок[Индекс].СтатьяФинансирования) Тогда
				ИмяПоля = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("СреднийЗаработок[%1].СтатьяФинансирования", Индекс);
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Статья финансирования не заполнена.'"), , ИмяПоля, , Отказ);
			КонецЕсли;
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
