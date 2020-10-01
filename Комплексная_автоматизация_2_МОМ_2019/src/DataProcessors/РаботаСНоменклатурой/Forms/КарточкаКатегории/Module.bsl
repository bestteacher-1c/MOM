
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ИдентификаторыКатегорий", ИдентификаторыКатегорий) 
		ИЛИ ИдентификаторыКатегорий.Количество() = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Не задан идентификатор категории'");
	КонецЕсли;
	
	Параметры.Свойство("ВидНоменклатуры", ВидНоменклатуры);
	
	ТекущийИндекс = 0;
	
	Элементы.ГруппаКнопкиНавигацииПоШирине.Видимость = ИдентификаторыКатегорий.Количество() > 1;
		
	Элементы.ЛистатьНазад.Доступность = Ложь;
	
	Для каждого ЭлементКоллекции Из ИдентификаторыКатегорий Цикл
		НоваяСтрока = КэшПредставленийКатегорий.Добавить();
		НоваяСтрока.Идентификатор = ЭлементКоллекции.Значение;
	КонецЦикла;
	
	ОбновитьСчетчикКатегорий(ЭтотОбъект);
	
	СформироватьПодсказкуФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОтобразитьПредставлениеКатегорий(ТекущийИндекс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЛистатьВперед(Команда)
	
	ТекущийИндекс = ТекущийИндекс + 1;
	
	ОбновитьСчетчикКатегорий(ЭтотОбъект);
	
	УстановитьДоступностьКнопокЛистания();
	
	ОтобразитьПредставлениеКатегорий(ТекущийИндекс);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛистатьНазад(Команда)
	
	ТекущийИндекс = ТекущийИндекс - 1;
	
	ОбновитьСчетчикКатегорий(ЭтотОбъект);
	
	УстановитьДоступностьКнопокЛистания();
	
	ОтобразитьПредставлениеКатегорий(ТекущийИндекс);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьПредставлениеКатегории(ИдентификаторКатегории)
	
	СтрокиКатегорий = КэшПредставленийКатегорий.НайтиСтроки(Новый Структура("Идентификатор", ИдентификаторКатегории));
	
	Если СтрокиКатегорий.Количество() > 0 
		И ЗначениеЗаполнено(СтрокиКатегорий[0].ПутьКТабличномуДокументу) Тогда
		
		КарточкаКатегории = ПолучитьИзВременногоХранилища(СтрокиКатегорий[0].ПутьКТабличномуДокументу);
		Возврат;
	КонецЕсли;
	
	ПараметрыЗавершения = Новый Структура;
	ПараметрыЗавершения.Вставить("ИдентификаторЗадания", Неопределено);
	
	СформироватьПредставлениеКатегорииЗавершение = Новый ОписаниеОповещения("СформироватьПредставлениеКатегорииЗавершение",
		ЭтотОбъект, ПараметрыЗавершения);
						
	РаботаСНоменклатуройКлиент.СформироватьПредставлениеКарточкиКатегории(СформироватьПредставлениеКатегорииЗавершение,
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ИдентификаторКатегории), ЭтотОбъект, Неопределено, Элементы.КарточкаКатегории.ОтображениеСостояния);
		
	Если Не Элементы.КарточкаКатегории.ОтображениеСостояния.Картинка.Вид = ВидКартинки.Пустая Тогда 
		Элементы.КарточкаКатегории.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
		Элементы.КарточкаКатегории.ОтображениеСостояния.Текст = НСтр("ru = 'Карточка категории загружается...'");
		Элементы.КарточкаКатегории.ОтображениеСостояния.Видимость = Истина;
	КонецЕсли;
				
КонецПроцедуры

&НаКлиенте
Процедура СформироватьПредставлениеКатегорииЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	Элементы.КарточкаКатегории.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
	Элементы.КарточкаКатегории.ОтображениеСостояния.Видимость = Ложь;
	Элементы.КарточкаКатегории.ОтображениеСостояния.Текст = "";
	Элементы.КарточкаКатегории.ОтображениеСостояния.Картинка = Неопределено;
	
	ПредставлениеПолучено = Ложь;
	
	ЗаполнитьПредставлениеКатегорий(Результат.АдресРезультата, ПредставлениеПолучено);
	
	Если ПредставлениеПолучено Тогда
		ОтобразитьПредставлениеКатегорий(ТекущийИндекс);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеКатегорий(АдресРезультата, ПредставлениеПолучено)
	
	ПредставленияКатегорий  = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(АдресРезультата) Тогда 
		ПредставленияКатегорий = ПолучитьИзВременногоХранилища(АдресРезультата);
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ПредставленияКатегорий = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ЭлементКоллекции Из ПредставленияКатегорий Цикл
		
		СтрокиДанных = КэшПредставленийКатегорий.НайтиСтроки(Новый Структура("Идентификатор", ЭлементКоллекции.Идентификатор));
		
		Если СтрокиДанных.Количество() > 0 Тогда
			НоваяСтрока = СтрокиДанных[0];
		Иначе
			НоваяСтрока = КэшПредставленийКатегорий.Добавить();	
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоллекции);
		
		НоваяСтрока.ПутьКТабличномуДокументу = ПоместитьВоВременноеХранилище(ЭлементКоллекции.ПредставлениеКатегории, УникальныйИдентификатор);
		
		Если ТипЗнч(ЭлементКоллекции.ПредставлениеКатегории) = Тип("ТабличныйДокумент") Тогда
			ПредставлениеПолучено = Истина;
		Иначе
			ПредставлениеПолучено = Ложь;	
		КонецЕсли;
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПредставлениеКатегорий(ИндексВТаблицеКэшей)

	СформироватьПредставлениеКатегории(КэшПредставленийКатегорий[ИндексВТаблицеКэшей].Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КарточкаКатегорииОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	РаботаСНоменклатуройКлиент.
		ОбработкаРасшифровкиПредставленияКатегории(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПодсказкуФормы()
	
	Элементы.ПодсказкаФормы.Видимость = ИдентификаторыКатегорий.Количество() > 1;
	
	СогласованнаяСтрока = СтрокаСЧислом(";категории;;категориям;категориям;категориям", 
		ИдентификаторыКатегорий.Количество(), ВидЧисловогоЗначения.Количественное);
	
	Элементы.ПодсказкаФормы.Заголовок
		= СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(
			СтрШаблон(
				НСтр("ru = 'Вид номенклатуры <b>%1</b> привязан к %2 %3'"), ВидНоменклатуры, ИдентификаторыКатегорий.Количество(), СогласованнаяСтрока));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКнопокЛистания()
	
	Элементы.ЛистатьВперед.Доступность = ТекущийИндекс < ИдентификаторыКатегорий.Количество() - 1;
	
	Элементы.ЛистатьНазад.Доступность = ТекущийИндекс > 0;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСчетчикКатегорий(Форма)
	
	Форма.НадписьТекущаяПозиция = СтрШаблон("%1/%2", Форма.ТекущийИндекс + 1,  Форма.ИдентификаторыКатегорий.Количество());
	
КонецПроцедуры

#КонецОбласти