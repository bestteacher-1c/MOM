///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет возможность использования сервиса в соответствии с текущим
//  режимом работы и правами пользователя.
//
// Возвращаемое значение:
//	Булево - Истина - использование разрешено, Ложь - в противном случае.
//
Функция ИспользованиеРазрешено() Экспорт

	Возврат СПАРКРиски.ИспользованиеРазрешено();

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СправочникиКонтрагенты() Экспорт
	
	Результат = Новый СписокЗначений;
	
	СвойстваСправочников = СПАРКРиски.СвойстваСправочниковКонтрагентов();
	Для Каждого ОписаниеСправочника Из СвойстваСправочников Цикл
		Результат.Добавить(
			Новый Структура("Имя, ИмяФормыПодбора",
				ОписаниеСправочника.Имя,
				ОписаниеСправочника.ИмяФормыПодбора),
			Метаданные.Справочники[ОписаниеСправочника.Имя].Синоним);
	КонецЦикла;
	
	Результат.СортироватьПоПредставлению();
	
	Возврат Результат;
	
КонецФункции

Процедура ВключитьОтключитьМониторингСобытийКонтрагента(Контрагент, МониторингВключен) Экспорт
	
	Если Не СПАРКРиски.ИспользованиеРазрешено("ПостановкаНаМониторинг;") Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для постановки контрагентов на мониторинг.'");
	КонецЕсли;
	
	СПАРКРиски.ВключитьОтключитьМониторингСобытий(Контрагент, МониторингВключен, Истина);
	
КонецПроцедуры

Процедура ТипыСобытийОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры) Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Спр.Название КАК Название,
	|	Спр.Описание КАК Описание,
	|	Спр.Критичное КАК Критичное,
	|	Спр.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ТипыСобытийСПАРКРиски КАК Спр
	|ГДЕ
	|	НЕ Спр.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Описание");
	
	ДанныеВыбора = Новый СписокЗначений;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПредставлениеСобытия = ?(ПустаяСтрока(Выборка.Описание), Выборка.Название, Выборка.Описание);
		
		Если Выборка.Критичное Тогда
			ДанныеВыбора.Добавить(Выборка.Ссылка,
				ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
					"<body><font color = ""#FF0000"">" + ПредставлениеСобытия + "</span></body>"));
		Иначе
			ДанныеВыбора.Добавить(
				Выборка.Ссылка,
				ПредставлениеСобытия);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#Область ИндексыСПАРКРиски

// Возвращает информацию о контрагенте (индексы и прочая информация).
// В случае, если информации нет в кэше, то инициируется фоновое задание.
// Если передан ИНН, то информация получается напрямую из веб-сервиса без фонового задания.
//
// Параметры:
//  Контрагент - ОпределяемыйТип.КонтрагентБИП, Строка - Контрагент или ИНН контрагента;
//  ПризнакЗагрузкиДанных - Булево, УникальныйИдентификатор - если ИСТИНА, то в случае, если данных нет или они просрочены,
//            то запустить фоновое задание загрузки данных. Если передан УникальныйИдентификатор, то это идентификатор фонового задания.
//
// Возвращаемое значение:
//  Структура: структура с ключами как описано в СПАРКРискиКлиентСервер.НовыйДанныеИндексов().
//
Функция ИндексыСПАРККонтрагента(Контрагент, ПризнакЗагрузкиДанных = Ложь) Экспорт

	Результат = СПАРКРиски.ИндексыСПАРККонтрагента(Контрагент, ПризнакЗагрузкиДанных);

	Возврат Результат;

КонецФункции

// Процедура предназначена для проверки завершенности фоновых заданий.
//
// Параметры:
//  ПроверяемыеФоновыеЗадания - Массив - массив структур, описанных в СПАРКРискиКлиент.НовыйПроверкаЗавершенностиФоновогоЗадания.
//
// Возвращаемое значение:
//   Массив - массив структур, описанных в СПАРКРискиКлиент.НовыйПроверкаЗавершенностиФоновогоЗадания.
//
Функция ПроверкаЗавершенностиФоновыхЗаданий(ПроверяемыеФоновыеЗадания) Экспорт

	Результат = СПАРКРиски.ПроверкаЗавершенностиФоновыхЗаданий(ПроверяемыеФоновыеЗадания);

	Возврат Результат;

КонецФункции

// Из результата работы веб-сервиса, сохраненного в 
//
// Параметры:
//  АдресВременногоХранилища - Строка - адрес временного хранилища, в котором хранится
//                                      результат вызова СервисСПАРКРиски.ЗагрузитьИндексыКонтрагентов.
//
// Возвращаемое значение:
//   Структура - структура, как описано в СПАРКРискиКлиентСервер.НовыйДанныеИндексов.
//
Функция ПолучитьПервыйИндекс(АдресВременногоХранилища) Экспорт

	Результат = СПАРКРискиКлиентСервер.НовыйДанныеИндексов();
	Результат.РаботаВМоделиСервиса = ОбщегоНазначения.РазделениеВключено();
	Результат.ДанныеАутентификацииЗаполнены
		= ИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	
	// После вызова функции необходимо самостоятельно дозаполнить ключ ДатаОбновления:
	//  ТекущаяДатаСеанса() - для сервера или ОбщегоНазначенияКлиент.ДатаСеанса() - для клиента.
	Результат.Вставить("ДатаОбновления", ТекущаяДатаСеанса());

	ТипСтруктура       = Тип("Структура");
	ТипТаблицаЗначений = Тип("ТаблицаЗначений");

	Если ПустаяСтрока(АдресВременногоХранилища) Тогда
		Результат.Вставить("ВидОшибки", Перечисления.ВидыОшибокСПАРКРиски.НеизвестнаяОшибка);
		Результат.Вставить("ТекстОшибки", НСтр("ru='Вызов веб-сервиса не сохранил данные в хранилище.'"));
		Результат.Вставить("СостояниеВыводаДанных", Перечисления.СостоянияВыводаИндексовСПАРКРиски.ВКэшеНетДанных);
		Результат.Вставить("СостояниеЗагрузкиДанных", Перечисления.СостоянияЗагрузкиИндексовСПАРКРиски.ПустаяСсылка());
	Иначе
		ДанныеХранилища = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
		Если (ТипЗнч(ДанныеХранилища) = ТипСтруктура) Тогда
			Если (ДанныеХранилища.Свойство("ЗначенияИндексов"))
				И (ТипЗнч(ДанныеХранилища.ЗначенияИндексов) = ТипТаблицаЗначений)
				И (ДанныеХранилища.ЗначенияИндексов.Количество() > 0) Тогда
				ЗаполнитьЗначенияСвойств(Результат, ДанныеХранилища.ЗначенияИндексов[0]);
				ЗаполнитьЗначенияСвойств(
					Результат,
					ДанныеХранилища,
					"ДоступностьПодключенияТестовогоПериода, ОшибкаПриПроверкеТестовогоПериода");
				// Если есть общая ошибка, то заполнить ее.
			КонецЕсли;
			Если НЕ ДанныеХранилища.ВидОшибки.Пустая() Тогда
				Результат.Вставить("ВидОшибки", ДанныеХранилища.ВидОшибки);
				Результат.Вставить("ПодлежитПроверке", Истина); // Чтобы отобразилась панель с описанием сервиса.
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Функция получает цвет стиля по имени элемента стиля.
//
// Параметры:
// ИмяЦветаСтиля - Строка -  Имя элемента стиля.
//
// Возвращаемое значение:
// Цвет.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт

	Возврат ЦветаСтиля[ИмяЦветаСтиля];

КонецФункции

#КонецОбласти

#Область СобытияМониторингаСПАРКРиски

Функция ОпределитьДанныеРасшифровкиСобытияМониторингаСПАРКРиски(
		АдресДанных,
		Идентификатор,
		СтандартнаяОбработка) Экспорт
	
	Возврат Отчеты.СобытияМониторингаСПАРКРиски.ОпределитьДанныеРасшифровкиОтчета(
		АдресДанных,
		Идентификатор,
		СтандартнаяОбработка);
	
КонецФункции

#КонецОбласти

#Область БСПНастройкиПрограммы

Процедура ИнтернетПоддержкаИСервисы_ИспользоватьСервисСПАРКРискиПриИзменении(Знач Значение) Экспорт
	
	Константы.ИспользоватьСервисСПАРКРиски.Установить(Значение);
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти