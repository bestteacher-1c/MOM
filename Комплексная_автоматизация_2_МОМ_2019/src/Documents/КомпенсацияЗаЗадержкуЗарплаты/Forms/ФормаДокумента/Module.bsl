#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура;
		ЗначенияДляЗаполнения.Вставить("Месяц",				"Объект.ПериодРегистрации");
		ЗначенияДляЗаполнения.Вставить("ПредыдущийМесяц",	"Объект.ПериодВзаиморасчетов");
		ЗначенияДляЗаполнения.Вставить("Организация",		"Объект.Организация");
		
		Если ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
			ЗначенияДляЗаполнения.Вставить("Подразделение", "Объект.Подразделение");
		КонецЕсли;
		
		ЗначенияДляЗаполнения.Вставить("Ответственный",		"Объект.Ответственный");
		
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		Объект.СтатьяРасходов = ОтражениеЗарплатыВБухучетеРасширенный.СтатьяРасходов290();
		Объект.РегистрироватьДоходыСтраховыхВзносов = 
			ПолучитьФункциональнуюОпцию("РегистрироватьКомпенсациюЗаЗадержкуЗарплатыВДоходахСтраховыхВзносов");
		
		ЗаполнитьДанныеФормыПоОрганизации();
		
		ПриПолученииДанныхНаСервере(РеквизитФормыВЗначение("Объект"));
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_КомпенсацияЗаЗадержкуЗарплаты", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ОбработатьСообщенияПользователю();
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

#Область РедактированиеМесяцаСтрокой

&НаКлиенте
Процедура ПериодРегистрацииПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтаФорма, 
		"Объект.ПериодРегистрации", 
		"ПериодРегистрацииСтрокой", 
		Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, 
		ЭтаФорма, 
		"Объект.ПериодРегистрации", 
		"ПериодРегистрацииСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтаФорма, 
		"Объект.ПериодРегистрации", 
		"ПериодРегистрацииСтрокой", 
		Направление, 
		Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегистрацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодВзаиморасчетовПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
		ЭтаФорма, 
		"Объект.ПериодВзаиморасчетов", 
		"ПериодВзаиморасчетовСтрокой", 
		Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма, 
		ЭтаФорма, 
		"Объект.ПериодВзаиморасчетов", 
		"ПериодВзаиморасчетовСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура ПериодВзаиморасчетовРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
		ЭтаФорма, 
		"Объект.ПериодВзаиморасчетов", 
		"ПериодВзаиморасчетовСтрокой", 
		Направление, 
		Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодВзаиморасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПериодВзаиморасчетовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура КомментарийНачалоВыбора(Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования,
		Форма,
		"Объект.Комментарий");
	
КонецПроцедуры

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтаФорма, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтаФорма, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСостав

&НаКлиенте
Процедура СоставВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Сотрудник) Тогда
		Если Поле.ГиперссылкаЯчейки ИЛИ Поле.ТолькоПросмотр Тогда
			РедактироватьКомпенсациюСтроки(ТекущиеДанные);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Не Копирование Тогда
		ПодобратьСотрудников();
	КонецЕсли;	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоставПередУдалением(Элемент, Отказ)
	
	Для Каждого ВыделеннаяСтрока Из Элемент.ВыделенныеСтроки Цикл
		
		Строка = Объект.Состав.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		Если Строка <> Неопределено Тогда
			ВыделенныеСотрудники.Добавить(Строка.Сотрудник);
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СоставОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СоставОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура СоставОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Массив") Тогда
		ВыбранныеСотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ВыбранноеЗначение);
	Иначе
		ВыбранныеСотрудники = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВыбранноеЗначение);
	КонецЕсли;
	
	Сотрудники = Новый Массив;
	Для Каждого Сотрудник Из ВыбранныеСотрудники Цикл
		
		СтрокиСотрудника = Объект.Состав.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
		
		Если СтрокиСотрудника.Количество() = 0 Тогда
			Сотрудники.Добавить(Сотрудник);
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнитьНаСервере(Сотрудники);
	
КонецПроцедуры

&НаКлиенте
Процедура СоставПослеУдаления(Элемент)
	СоставПослеУдаленияНаСервере();
КонецПроцедуры

&НаСервере
Процедура СоставПослеУдаленияНаСервере()
	
	Для Каждого ВыделенныйСотрудник Из ВыделенныеСотрудники Цикл
		
		УдаляемыеСтроки = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", ВыделенныйСотрудник.Значение));
		Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
			Объект.Начисления.Удалить(УдаляемаяСтрока);
		КонецЦикла;	
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СоставСуммаКомпенсацииПриИзменении(Элемент)
	СоставСуммаКомпенсацииПриИзмененииНаСервере(Элементы.Состав.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура СоставСуммаКомпенсацииПриИзмененииНаСервере(ИдентификаторСтроки)
	
	ТекущиеДанные = Объект.Состав.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	СуммаКомпенсации = ТекущиеДанные.СуммаКомпенсации;
	
	НачисленияСотрудника = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", ТекущиеДанные.Сотрудник));
	
	ЗарплатаКадры.РазнестиСуммуПоБазе(СуммаКомпенсации, НачисленияСотрудника, "СуммаКомпенсации");
	
	Для Каждого Начисление Из НачисленияСотрудника Цикл
		Если Начисление.СуммаКомпенсации = 0 Тогда
			Объект.Начисления.Удалить(Начисление);
		КонецЕсли;	
	КонецЦикла;
		
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

&НаКлиенте
Процедура Заполнить(Команда)
	ОчиститьСообщения();
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	ПодобратьСотрудников();		
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьКомпенсацию(Команда)
	РедактироватьКомпенсациюСтроки(Элементы.Состав.ТекущиеДанные);	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "ПериодРегистрацииСтрокой");
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
	
	Для Каждого СтрокаСостава Из Объект.Состав Цикл
		ПриПолученииДанныхСтрокиСостава(СтрокаСостава);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриПолученииДанныхСтрокиСостава(СтрокаСостава) Экспорт
	
	СтрокиНачисленийСотрудника = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", СтрокаСостава.Сотрудник));
	
	СтрокаСостава.СуммаКомпенсации = 
		Объект.Начисления.Выгрузить(СтрокиНачисленийСотрудника, "СуммаКомпенсации").Итог("СуммаКомпенсации");
	
	РабочиеМеста = Объект.Начисления.Выгрузить(СтрокиНачисленийСотрудника, "Подразделение");
	РабочиеМеста.Свернуть("Подразделение");
	РасшифровкаРабочихМест = "";
	Если РабочиеМеста.Количество() > 1 Тогда
		РасшифровкаРабочихМест = 
			НРег(ЧислоПрописью(РабочиеМеста.Количество(),,НСтр("ru = 'рабочее место, рабочих места, рабочих мест, с, ,,,,0'")));
	КонецЕсли;
	
	ПериодыВзаиморасчетов = Объект.Начисления.Выгрузить(СтрокиНачисленийСотрудника, "ПериодВзаиморасчетов");
	ПериодыВзаиморасчетов.Свернуть("ПериодВзаиморасчетов");
	РасшифровкаПериодов = "";
	Если ПериодыВзаиморасчетов.Количество() = 1 Тогда
		// Единственный период взаиморасчетов
		Если Не ЗначениеЗаполнено(ПериодыВзаиморасчетов[0].ПериодВзаиморасчетов) Тогда
			// пуст - комментировать нечего
		ИначеЕсли ПериодыВзаиморасчетов[0].ПериодВзаиморасчетов = Объект.ПериодВзаиморасчетов Тогда 
			// совпадает с выплачиваемым периодом - комментировать нечего
		Иначе
			ПредставлениеПериода = 
				НРег(ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(ПериодыВзаиморасчетов[0].ПериодВзаиморасчетов));
			РасшифровкаПериодов = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'за %1'"), ПредставлениеПериода);
		КонецЕсли;	
	Иначе
		// Периодов несколько, есть отличающиеся от выплачиваемого периода
		ПериодыВзаиморасчетов.Сортировать("ПериодВзаиморасчетов");
		ПредставлениеПериодов = "";
		Для Индекс = 0 По ПериодыВзаиморасчетов.Количество()-1 Цикл
			
			// пустые периоды не показываем
			Если Не ЗначениеЗаполнено(ПериодыВзаиморасчетов[Индекс].ПериодВзаиморасчетов) Тогда
				Продолжить;
			КонецЕсли;
			
			// период документа в комментарий не включаем
			Если ПериодыВзаиморасчетов[Индекс].ПериодВзаиморасчетов = Объект.ПериодВзаиморасчетов Тогда
				Продолжить;
			КонецЕсли;
			
			Если Индекс = 3 Тогда
				ПредставлениеПериодов = ПредставлениеПериодов + "...";
				Прервать;
			ИначеЕсли Индекс > 0 Тогда
				ПредставлениеПериодов = ПредставлениеПериодов + ", ";
			КонецЕсли;

			ПредставлениеПериодов = 
				ПредставлениеПериодов 
				+ НРег(ЗарплатаКадрыКлиентСервер.ПолучитьПредставлениеМесяца(ПериодыВзаиморасчетов[Индекс].ПериодВзаиморасчетов));
			
		КонецЦикла;	
		
		Если ЗначениеЗаполнено(ПредставлениеПериодов) Тогда
			РасшифровкаПериодов = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'в т.ч. за %1'"), ПредставлениеПериодов);
		КонецЕсли;	
		
	КонецЕсли;	
	
	СтрокаСостава.Расшифровка = "";
	Если ЗначениеЗаполнено(РасшифровкаПериодов) Тогда
		СтрокаСостава.Расшифровка = СтрокаСостава.Расшифровка + РасшифровкаПериодов;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РасшифровкаРабочихМест) Тогда
		СтрокаСостава.Расшифровка = 
			СтрокаСостава.Расшифровка
			+ ?(ЗначениеЗаполнено(СтрокаСостава.Расшифровка), "; "+Символы.ПС, "")
			+ РасшифровкаРабочихМест;
	КонецЕсли;

КонецПроцедуры	

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ЗаполнитьДанныеФормыПоОрганизации();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли; 
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноЗаполнитьКомпенсации() Тогда
		ТекущийОбъект.ЗаполнитьКомпенсации();
	КонецЕсли;	
	
	ОбработатьСообщенияПользователю();
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьНаСервере(Сотрудники)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноЗаполнитьКомпенсации() Тогда
		ТекущийОбъект.ДополнитьКомпенсации(Сотрудники);
	КонецЕсли;	
	
	ОбработатьСообщенияПользователю();
	
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);	
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьСообщенияПользователю()
	
	Сообщения = ПолучитьСообщенияПользователю(Ложь);
	
	Для Каждого Сообщение Из Сообщения Цикл
		Если СтрНайти(Сообщение.Поле, "ПериодРегистрации") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПериодРегистрацииСтрокой";
		КонецЕсли;
		Если СтрНайти(Сообщение.Поле, "ПериодВзаиморасчетов") Тогда
			Сообщение.Поле = "";
			Сообщение.ПутьКДанным = "ПериодВзаиморасчетовСтрокой";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСотрудников()
	
	НачалоПериодаПримененияОтбора = Объект.ПериодВзаиморасчетов;
	ОкончаниеПериодаПримененияОтбора = КонецМесяца(Объект.ПериодВзаиморасчетов);
	
	ПараметрыОткрытия = Неопределено;
	КадровыйУчетРасширенныйКлиент.ДобавитьПараметрыОтбораПоФункциональнойОпцииВыполнятьРасчетЗарплатыПоПодразделениям(
		ЭтаФорма, ПараметрыОткрытия);
		
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.Состав,
		Объект.Организация,
		Объект.Подразделение,
		НачалоПериодаПримененияОтбора,
		ОкончаниеПериодаПримененияОтбора,
		,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
		
КонецПроцедуры

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	Возврат ПоместитьВоВременноеХранилище(Объект.Состав.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура РедактироватьКомпенсациюСтроки(ДанныеСтроки) Экспорт
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	
	ПараметрыОткрытия.Вставить("Организация",			ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	ПараметрыОткрытия.Вставить("ПериодВзаиморасчетов",	Дата(1,1,1));
	ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Объект);
	
	ПараметрыОткрытия.Вставить("Сотрудник", 			ДанныеСтроки.Сотрудник);
	ПараметрыОткрытия.Вставить("АдресВХранилищеНачисленийСотрудника", АдресВХранилищеНачисленийСотрудника(ДанныеСтроки.Сотрудник));
	
	ПараметрыОткрытия.Вставить("ТолькоПросмотр",		ТолькоПросмотр);
	
	Оповещение = Новый ОписаниеОповещения("РедактироватьКомпенсациюСтрокиЗавершение", ЭтотОбъект);
	ОткрытьФорму("Документ.КомпенсацияЗаЗадержкуЗарплаты.Форма.РедактированиеКомпенсацииСотрудника", ПараметрыОткрытия, ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьКомпенсациюСтрокиЗавершение(РезультатыРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатыРедактирования <> Неопределено И РезультатыРедактирования.Модифицированность Тогда
		РедактироватьКомпенсациюСтрокиЗавершениеНаСервере(РезультатыРедактирования)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РедактироватьКомпенсациюСтрокиЗавершениеНаСервере(РезультатыРедактирования) Экспорт
	
	Сотрудник = РезультатыРедактирования.Сотрудник;
	
	СтрокиСостава = Объект.Состав.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Если СтрокиСостава.Количество() <> 0 Тогда
		СтрокаСостава  = СтрокиСостава[0]
	Иначе
		Возврат
	КонецЕсли;	

	НачисленияСтроки = ПолучитьИзВременногоХранилища(РезультатыРедактирования.АдресВХранилищеНачисленийСотрудника);
	
	УдаляемыеСтроки = Объект.Начисления.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник));
	Для Каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Объект.Начисления.Удалить(УдаляемаяСтрока);
	КонецЦикла;	
	
	Для Каждого Начисление Из НачисленияСтроки Цикл
		СтрокаТЧ = Объект.Начисления.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, Начисление);
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтрокаСостава, "Сотрудник");
	КонецЦикла;	
	
	ПриПолученииДанныхСтрокиСостава(СтрокаСостава);
		
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийСотрудника(Сотрудник) Экспорт
	Возврат ПоместитьВоВременноеХранилище(Объект.Начисления.Выгрузить(Новый Структура("Сотрудник", Сотрудник)), УникальныйИдентификатор);
КонецФункции	

#КонецОбласти
