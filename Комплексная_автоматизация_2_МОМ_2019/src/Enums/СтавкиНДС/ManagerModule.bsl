#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет ставки НДС, операции, отраженные по которым, подлежат регистрации в книге продаж.
//
// Параметры:
//   ВходящиеПараметры - Структура, Число - параметры для определения ставок.
//    Если передана Структура, то она должна содержать ключи:
//     * ПрименяетсяОсвобождениеОтУплатыНДС - Булево - признак применения освобождения от уплаты
//               НДС по статье 145 НК. 
//     * ПлательщикНДС - Булево - признак применения общей системы налогообложения.
//     * ВерсияПостановленияНДС1137 - Число - см. УчетНДСПереопределяемый.ВерсияПостановленияНДС1137.
//
// Возвращаемое значение:
//   Массив - ставки НДС.
Функция СтавкиПоОперациямОтражаемымВКнигеПродаж(ВходящиеПараметры) Экспорт
	
	Если ТипЗнч(ВходящиеПараметры) = Тип("Число") Тогда
		Параметры = Новый Структура();
		Параметры.Вставить("ПрименяетсяОсвобождениеОтУплатыНДС", Ложь);
		Параметры.Вставить("ПлательщикНДС",                      Истина);
		Параметры.Вставить("ВерсияПостановленияНДС1137",         ВходящиеПараметры);

	ИначеЕсли ТипЗнч(ВходящиеПараметры) = Тип("Структура") Тогда
		Параметры = ВходящиеПараметры;

	Иначе
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Перечисления.СтавкиНДС.СтавкиПоОперациямОтражаемымВКнигеПродаж(): недопустимый тип параметра %2, ожидается Число или Структура.'"), ТипЗнч(Параметры));
	КонецЕсли;

	МассивСтавок = Новый Массив;
	
	Если Параметры.ПрименяетсяОсвобождениеОтУплатыНДС Тогда
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.БезНДС);
	ИначеЕсли Параметры.ПлательщикНДС Тогда
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС0);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС10);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС10_110);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС18);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС18_118);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС20);
		МассивСтавок.Добавить(Перечисления.СтавкиНДС.НДС20_120);
		Если Параметры.ВерсияПостановленияНДС1137 < 3 Тогда
			МассивСтавок.Добавить(Перечисления.СтавкиНДС.БезНДС);
		КонецЕсли;
	КонецЕсли;
	
	Возврат МассивСтавок;
	
КонецФункции
//++ НЕ УТ

// Определяет ставку НДС, операции, отраженные по которым, подлежат регистрации в книге продаж.
//
// Параметры:
//   ВидСтавки - ПеречислениеСсылка.ВидыСтавокНДС  - вид ставки, для которой определяется значений.
//   Период - Дата - дата, на которую определяется ставка
//
// Возвращаемое значение:
//   ПеречислениеСсылка.СтавкиНДС - значение ставки НДС.
Функция СтавкаНДС(ВидСтавки, Период) Экспорт
	
	Если ВидСтавки = Перечисления.ВидыСтавокНДС.Общая Тогда
		Возврат УчетНДСКлиентСервер.ОбщаяСтавкаНДС(Период);
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.ОбщаяРасчетная Тогда
		Возврат УчетНДСКлиентСервер.ОбщаяРасчетнаяСтавкаНДС(Период);
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.Пониженная Тогда
		Возврат Перечисления.СтавкиНДС.НДС10;
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.ПониженнаяРасчетная Тогда
		Возврат Перечисления.СтавкиНДС.НДС10_110;
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.Нулевая Тогда
		Возврат Перечисления.СтавкиНДС.НДС0;
	ИначеЕсли ВидСтавки = Перечисления.ВидыСтавокНДС.БезНДС Тогда
		Возврат Перечисления.СтавкиНДС.БезНДС;
	Иначе
		Возврат Перечисления.СтавкиНДС.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции
//-- НЕ УТ
#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	МассивИсключаемыхЗначений = Новый Массив;
	
	Если Параметры.Свойство("ИсключатьДробныеСтавки") И Параметры.ИсключатьДробныеСтавки Тогда
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС10_110);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС18_118);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС20_120);
	КонецЕсли;
	
	Если Параметры.Свойство("ТолькоДробныеСтавки") И Параметры.ТолькоДробныеСтавки Тогда
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.БезНДС);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС0);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС10);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС18);
		МассивИсключаемыхЗначений.Добавить(Перечисления.СтавкиНДС.НДС20);
	КонецЕсли;
	
	Если МассивИсключаемыхЗначений.Количество() > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОбщегоНазначенияУТВызовСервера.ДоступныеДляВыбораЗначенияПеречисления(
			"СтавкиНДС",
			ДанныеВыбора,
			Параметры,
			МассивИсключаемыхЗначений);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

