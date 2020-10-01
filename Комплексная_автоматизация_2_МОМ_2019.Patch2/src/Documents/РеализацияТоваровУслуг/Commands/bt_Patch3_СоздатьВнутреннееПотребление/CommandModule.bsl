

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	
	НадоСоздаватьВнутреннееПотребление = Ложь;
	
	ВнутреннееПотребление = ПолучитьСсылкуНаВнутренееПотребление(ПараметрКоманды, НадоСоздаватьВнутреннееПотребление);
	
	Если НадоСоздаватьВнутреннееПотребление = Истина Тогда
		
		ЗаполнитьВнутренееПотреблениеНаОснованииРеализацииТоваровУслуг(ПараметрКоманды, ВнутреннееПотребление);
		
	КонецЕсли;
	
	ОткрытьФорму("Документ.ВнутреннееПотреблениеТоваров.Форма.ФормаДокумента", 
	Новый Структура("Ключ", ВнутреннееПотребление));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСсылкуНаВнутренееПотребление(РеализацияТоваровУслуг, НадоСоздаватьВнутреннееПотребление)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДополнительныеСведения.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСведения КАК ДополнительныеСведения
	|ГДЕ
	|	ДополнительныеСведения.Объект = &Объект
	|	И ДополнительныеСведения.Свойство.Имя = &Имя";
	
	Запрос.УстановитьПараметр("Имя", "ВнутреннееПотреблений_234fcf9137a84b7f8c98e70401858fb6");
	Запрос.УстановитьПараметр("Объект", РеализацияТоваровУслуг);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		УИД = Новый УникальныйИдентификатор(ВыборкаДетальныеЗаписи.Значение);
		СсылкаНаВнутреннееПотребление = Документы.ВнутреннееПотреблениеТоваров.ПолучитьСсылку(УИД);
		
		
		Если СсылкаНаВнутреннееПотребление.ПолучитьОбъект() = Неопределено Тогда
			
			НадоСоздаватьВнутреннееПотребление = Истина;
			
			СсылкаНаВнутреннееПотребление = Документы.ВнутреннееПотреблениеТоваров.ПустаяСсылка();
			
			МенеджерЗаписи = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Объект = РеализацияТоваровУслуг;
			МенеджерЗаписи.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "ВнутреннееПотреблений_234fcf9137a84b7f8c98e70401858fb6");
			МенеджерЗаписи.Значение = "";
			
			Попытка
				
				МенеджерЗаписи.Записать();
				
			Исключение
				
				Сообщить(ОписаниеОшибки());
				Сообщить("Удалите вручную строку из свойства ""Внутреннее потребление""");
				
			КонецПопытки;
			
		КонецЕсли;
		
	Иначе
		
		СсылкаНаВнутреннееПотребление = Документы.ВнутреннееПотреблениеТоваров.ПустаяСсылка();
		НадоСоздаватьВнутреннееПотребление = Истина;
		
	КонецЕсли;
	
	Возврат СсылкаНаВнутреннееПотребление;
	
КонецФункции // ПолучитьСсылкуНаПриход()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ЗаполнитьВнутренееПотреблениеНаОснованииРеализацииТоваровУслуг(РеализацияТоваровУслуг, ВнутреннееПотребление)
	
	РеализацияТоваровУслугОбъект = Документы.ВнутреннееПотреблениеТоваров.СоздатьДокумент();
	
	Запрос = Новый Запрос;    
	Запрос.УстановитьПараметр("РеализацияТоваровИУслуг", РеализацияТоваровУслуг);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Дата КАК Дата,
	|	РеализацияТоваровУслуг.Подразделение КАК Подразделение,
	|	РеализацияТоваровУслуг.Склад КАК Склад,
	|	РеализацияТоваровУслуг.Организация КАК Организация
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка = &РеализацияТоваровИУслуг
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РеализацияТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	РеализацияТоваровУслугТовары.Характеристика КАК Характеристика,
	|	РеализацияТоваровУслугТовары.Серия КАК Серия,
	|	РеализацияТоваровУслугТовары.КоличествоУпаковок КАК КоличествоУпаковок,
	|	РеализацияТоваровУслугТовары.Количество КАК Количество,
	|	РеализацияТоваровУслугТовары.Упаковка КАК Упаковка,
	|	РеализацияТоваровУслугТовары.Назначение КАК Назначение
	|ИЗ
	|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
	|ГДЕ
	|	РеализацияТоваровУслугТовары.Ссылка = &РеализацияТоваровИУслуг";
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = МассивРезультатов.Получить(1).Выбрать();
	
	Статья = ПланыВидовХарактеристик.СтатьиРасходов.ПолучитьСсылку(
		Новый УникальныйИдентификатор("1e0215a9-d2c8-11e9-a72d-9d41603d49f8"));
	
	Пока ВыборкаДетальныеЗаписи.Следующий() = Истина Цикл
		
		НоваяСтрока = РеализацияТоваровУслугОбъект.Товары.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		
		НоваяСтрока.СтатьяРасходов = Статья;
		
	КонецЦикла;
	
	ВыборкаДетальныеЗаписи = МассивРезультатов.Получить(0).Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	РеализацияТоваровУслугОбъект.Дата = ВыборкаДетальныеЗаписи.Дата;
	РеализацияТоваровУслугОбъект.Организация = Справочники.Организации.ПолучитьСсылку(
	Новый УникальныйИдентификатор("1ad79775-ac7e-4b60-909c-1c9582a3fa2e"));
	
	РеализацияТоваровУслугОбъект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию;
	
	РеализацияТоваровУслугОбъект.Ответственный = Пользователи.ТекущийПользователь();
	РеализацияТоваровУслугОбъект.Склад = ВыборкаДетальныеЗаписи.Склад;
	
	Попытка
		
		РеализацияТоваровУслугОбъект.Записать();
		
		
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
		
	КонецПопытки;
	
	
	ВнутреннееПотребление = РеализацияТоваровУслугОбъект.Ссылка;
	
	МенеджерЗаписи = РегистрыСведений.ДополнительныеСведения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Объект = РеализацияТоваровУслуг;
	МенеджерЗаписи.Свойство = ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоРеквизиту("Имя", "ВнутреннееПотреблений_234fcf9137a84b7f8c98e70401858fb6");
	МенеджерЗаписи.Значение = ВнутреннееПотребление.УникальныйИдентификатор();
	
	Попытка
		
		МенеджерЗаписи.Записать();
		
		
	Исключение
		Сообщить(ОписаниеОшибки());
		
	КонецПопытки;
	
КонецПроцедуры
