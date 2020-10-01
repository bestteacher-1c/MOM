
#Область ПрограммныйИнтерфейс

// Функция возвращает ссылку на документ по заданной форме.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, отображающая данные документа, ссылку на
//                             который требутеся вернуть.
//
// Результат:
//  Ссылка на документ.
//
// Пример:
//  Возврат Форма.Объект.Ссылка;
// 
Функция ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма) Экспорт
	
	ПроверяемоеСвойство = Новый Структура("Объект", Неопределено);
	ЗаполнитьЗначенияСвойств(ПроверяемоеСвойство, Форма);
	
	Если ПроверяемоеСвойство.Объект <> Неопределено Тогда
		ПроверяемоеСвойство = Новый Структура("Ссылка", Неопределено);
		ЗаполнитьЗначенияСвойств(ПроверяемоеСвойство, Форма.Объект);
		Если ПроверяемоеСвойство.Ссылка <> Неопределено Тогда
			Возврат Форма.Объект.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ПерсонифицированныйУчетКлиентСервер.ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма);
	
КонецФункции

// Функция возвращает ссылку на организацию-отправитель документа по заданной форме.
// 
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма, из которой производится отправка.
//
// Результат:
//  СправочникСсылка.Организации,
//	Неопределено, если получить ссылку на организацию не получилось.
//
Функция ПолучитьСсылкуНаОрганизациюОтправляемогоДокументаПоФорме(Форма) Экспорт
	
КонецФункции

// Функция возвращает строкой имя объекта метаданных.
// 
// 
// Параметры:
//	Имя - строка, условное имя объекта
//	Возможные варианты:
//		УведомлениеОКонтролируемыхСделках
//		РеестрСведенийНаВыплатуПособийФСС
//		СправкиНДФЛДляПередачиВНалоговыйОрган
//
// Результат:
//	Строка, имя объекта метаданных, если объект данного вида присутствует в конфигурации данного прикладного решения
//	Неопределено, если объект данного вида отсутствует в конфигурации данного прикладного решения.
// 
// Пример:
// 	Если Имя = "СправкиНДФЛДляПередачиВНалоговыйОрган" Тогда 
//		Возврат "СправкиНДФЛДляПередачиВНалоговыйОрган";
//	Иначе
//		Возврат Неопределено;
//	КонецЕсли;
Функция ИмяОбъектаМетаданных(Имя) Экспорт
	Если Имя = "СправкиНДФЛДляПередачиВНалоговыйОрган" Тогда 
		Возврат "СправкиНДФЛДляПередачиВНалоговыйОрган";
	ИначеЕсли Имя = "ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ" Тогда
		Возврат "ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ";
	ИначеЕсли Имя = "РеестрСведенийНаВыплатуПособийФСС" Тогда 
		Возврат "РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий";
	ИначеЕсли Имя = "ЗаявлениеОВвозеТоваров" Тогда
		Возврат "ЗаявлениеОВвозеТоваров";
	ИначеЕсли Имя = "ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде" Тогда
		Возврат "ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде";
	ИначеЕсли Имя = "УведомлениеОКонтролируемыхСделках" Тогда
		Возврат "УведомлениеОКонтролируемыхСделках";
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Функция возвращает тип организации
//
// Параметры
//  Отсутствуют
//
// Возвращаемое значение:
//   Тип   - тип организации в данной базе.
//
Функция ТипОрганизации() Экспорт
	
	Возврат Тип("СправочникСсылка.Организации");

КонецФункции

// Функция возвращает тип физ лица
//
// Параметры
//  Отсутствуют
//
// Возвращаемое значение:
//   Тип   - тип физ лица в данной базе.
//
Функция ТипФизЛица() Экспорт
	
	Возврат Тип("СправочникСсылка.ФизическиеЛица");

КонецФункции

#Область ДокументыПоТребованиюФНС

// Определяет соответствие между видом документа ФНС и массивом типов ссылок на соответствующие объекты метаданных.
//
// Параметры:
//  СоответствиеВидовДокументов  - Соответствие, значения соответствия требуется переопределить.
//
//	Ключ		- ПеречислениеСсылка.ВидыПредставляемыхДокументов
//	 Значение	- Массив, 
//			элементы массива	- Тип, тип ссылки на объект метаданных. 
//
Процедура ОпределитьСоответствиеТиповИсточниковВидамДокументовФНС(СоответствиеВидовДокументов) Экспорт
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.СчетФактура"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.КорректировочныйСчетФактура"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаПриобретения"));
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомитенту"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ОтчетКомиссионера"));
	МассивТипов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов"));
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияУслугПрочихАктивов"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.АктПриемкиСдачиРабот"), МассивТипов); 
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаПриобретения"));
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ТоварнаяНакладнаяТОРГ12"), МассивТипов);
		
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.УПД"), МассивТипов);
		
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученный"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураПолученныйНалоговыйАгент"));
	МассивТипов.Добавить(Тип("ДокументСсылка.СчетФактураВыданный"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.УКД"), МассивТипов);
		
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ПередачаТоваров"), МассивТипов);
		
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.АктВыполненныхРабот"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеУслугПрочихАктивов"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ПередачаУслуг"), МассивТипов);
		
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаПриобретения"));
	МассивТипов.Добавить(Тип("ДокументСсылка.КорректировкаРеализации"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ПриобретениеТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	МассивТипов.Добавить(Тип("ДокументСсылка.ВозвратТоваровПоставщику"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ТоварноТранспортнаяНакладная"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ТаможеннаяДекларацияИмпорт"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ГрузоваяТаможеннаяДекларация"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.Договор"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.КнигаПокупокДляПередачиВЭлектронномВиде"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.КнигаПокупок"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.КнигаПродажДляПередачиВЭлектронномВиде"));
	СоответствиеВидовДокументов.Вставить(
	ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.КнигаПродаж"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ДополнительныйЛистКнигиПокупок"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ДополнительныйЛистКнигиПродаж"), МассивТипов);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ЖурналУчетаСчетовФактурДляПередачиВЭлектронномВиде"));
	СоответствиеВидовДокументов.Вставить(
		ПредопределенноеЗначение("Перечисление.ВидыПредставляемыхДокументов.ЖурналПолученныхИВыставленныхСчетовФактур"), МассивТипов);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
