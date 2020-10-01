
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтаФорма, Объект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	// Учесть возможность создания из взаимодействия
	Взаимодействия.ПодготовитьОповещения(ЭтаФорма,Параметры,Ложь);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ПравоДоступа("Изменение", Метаданные.Справочники.ФизическиеЛица) Тогда
		УправлениеДоступом.ПриСозданииФормыЗначенияДоступа(ЭтаФорма);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, НаборЗаписейФИОФизЛиц.Количество());
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	ПрочитатьИсториюФИО();
	
	УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, НаборЗаписейФИОФизЛиц.Количество());
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	Если НаборЗаписейФИОФизЛиц.Количество() = 0 Тогда
		ЗаполнитьФИОПоНаименованию();
	КонецЕсли;
	
	ТекущийОбъект.ФИО = Объект.Наименование;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ФизическиеЛицаУТ.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, Объект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ИмяСобытия = "ОтредактированаИстория" И Параметр.ИмяРегистра = "ФИОФизическихЛиц"
	 И Источник = Объект.Ссылка Тогда
		
		НаборЗаписейФИОФизЛиц.Очистить();
		Для Каждого ТекСтр Из Параметр.МассивЗаписей Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписейФИОФизЛиц.Добавить(), ТекСтр);
		КонецЦикла;
		
		Если НаборЗаписейФИОФизЛиц.Количество() > 0 Тогда
			
			ПоследняяЗапись = НаборЗаписейФИОФизЛиц[НаборЗаписейФИОФизЛиц.Количество() - 1];
			НовоеНаименование = 
				ПоследняяЗапись.Фамилия 
				+ ?(ЗначениеЗаполнено(ПоследняяЗапись.Имя), " ", "") + ПоследняяЗапись.Имя 
				+ ?(ЗначениеЗаполнено(ПоследняяЗапись.Отчество), " ", "") + ПоследняяЗапись.Отчество;
			
			Если Объект.Наименование <> НовоеНаименование Тогда
				Объект.Наименование = НовоеНаименование;
				Модифицированность = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, НаборЗаписейФИОФизЛиц.Количество());
		
	ИначеЕсли ИмяСобытия = "ИзмененыЛичныеДанные" И Параметр.ИмяРегистра = "ФИОФизическихЛиц"
	 И Источник = Объект.Ссылка Тогда
		
		Прочитать();
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ВзаимодействияКлиент.КонтактПослеЗаписи(ЭтаФорма,Объект,ПараметрыЗаписи,"ФизическиеЛица");
	
	ЗаписатьИзмененияФИО();
	
	УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, НаборЗаписейФИОФизЛиц.Количество());
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект, Объект.Наименование, ТекущийОбъект.Ссылка, Истина, 
		?(ЗначениеЗаполнено(Объект.Пол), ?(Объект.Пол = Перечисления.ПолФизическогоЛица.Мужской, 1, 2), Неопределено));	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаполнитьФИОПоНаименованию();
	КонецЕсли;
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	УправлениеКонтактнойИнформациейКлиент.НачатьИзменение(ЭтотОбъект, Элемент);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыбор(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОчистку(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	УправлениеКонтактнойИнформациейКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда.Имя);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.АвтоПодборАдреса(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.ОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, Элемент.Имя, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	УправлениеКонтактнойИнформациейКлиент.НачатьОбработкуНавигационнойСсылки(ЭтотОбъект, Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ПродолжитьОбновлениеКонтактнойИнформации(Результат, ДополнительныеПараметры) Экспорт
	ОбновитьКонтактнуюИнформацию(Результат);
КонецПроцедуры
&НаСервере
Процедура ОбновитьКонтактнуюИнформацию(Результат)
	УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура ИсторияФИО(Команда)
	
	ПараметрыФормы = Новый Структура("ВедущийОбъект, МассивЗаписей", Объект.Ссылка, НаборЗаписейФИОФизЛиц);
	ОткрытьФорму("РегистрСведений.ФИОФизическихЛиц.Форма.РедактированиеИстории", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Склонения(Команда)
	
	СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект, Объект.Наименование, Истина, 
		?(ЗначениеЗаполнено(Объект.Пол), ?(Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПрочитатьИсториюФИО()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ФизическоеЛицо", Объект.Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФИОФизическихЛиц.Период КАК Период,
	|	ФИОФизическихЛиц.ФизическоеЛицо,
	|	ФИОФизическихЛиц.Фамилия,
	|	ФИОФизическихЛиц.Имя,
	|	ФИОФизическихЛиц.Отчество
	|ИЗ
	|	РегистрСведений.ФИОФизическихЛиц КАК ФИОФизическихЛиц
	|ГДЕ
	|	ФИОФизическихЛиц.ФизическоеЛицо = &ФизическоеЛицо
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	НаборЗаписейФИОФизЛиц.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзмененияФИО()
	
	НаборЗаписейРегистра = РеквизитФормыВЗначение("НаборЗаписейФИОФизЛиц");
	
	НаборЗаписейРегистра.Отбор.ФизическоеЛицо.Установить(Объект.Ссылка);
	Для Каждого ТекСтр Из НаборЗаписейРегистра Цикл
		ТекСтр.ФизическоеЛицо = Объект.Ссылка;
	КонецЦикла;
	
	НаборЗаписейРегистра.ДополнительныеСвойства.Вставить("НеФормироватьНаименование");
	
	НаборЗаписейРегистра.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФИОПоНаименованию()
	Перем ПоследняяЗапись;
	
	ДатаЗаписи = НачалоДня(ТекущаяДатаСеанса());
	ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(Объект.Наименование);
	
	Если НаборЗаписейФИОФизЛиц.Количество() > 0 Тогда
		
		ПоследняяЗапись = НаборЗаписейФИОФизЛиц[НаборЗаписейФИОФизЛиц.Количество() - 1];
		
		Если НачалоДня(ПоследняяЗапись.Период) < ДатаЗаписи
		 И (ПоследняяЗапись.Фамилия <> ФИО.Фамилия
		 	ИЛИ ПоследняяЗапись.Имя <> ФИО.Имя
			ИЛИ ПоследняяЗапись.Отчество <> ФИО.Отчество) Тогда
			ПоследняяЗапись = Неопределено; // создадим новую
		КонецЕсли;
		
	Иначе
		
		ДатаЗаписи = ?(ЗначениеЗаполнено(Объект.ДатаРождения), Объект.ДатаРождения, ДатаЗаписи);
		
	КонецЕсли;
	
	Если ПоследняяЗапись = Неопределено Тогда
		
		ПоследняяЗапись = НаборЗаписейФИОФизЛиц.Добавить();
		ПоследняяЗапись.Период = ДатаЗаписи;
		
		УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, НаборЗаписейФИОФизЛиц.Количество());
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПоследняяЗапись, ФИО);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСвойстваГиперссылкиИсторииФИО(Объект, Элементы, КоличествоЗаписей)
	
	Если КоличествоЗаписей > 0 Тогда
		Заголовок =	СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='История ФИО (%1)'"),
			Формат(КоличествоЗаписей, "ЧГ="));
	Иначе
		Заголовок = НСтр("ru='История ФИО'")		
	КонецЕсли;
	
	Элементы.ИсторияФИО.Заголовок   = Заголовок;
	Элементы.ИсторияФИО.Доступность = ЗначениеЗаполнено(Объект.Ссылка);
	
КонецПроцедуры

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект, Объект.Наименование, Истина, 
		?(ЗначениеЗаполнено(Объект.Пол), ?(Объект.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской"), 1, 2), Неопределено));
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти
