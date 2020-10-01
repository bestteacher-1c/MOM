#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") И ДанныеЗаполнения.Свойство("ДокументОснование") Тогда
		ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения.ДокументОснование);
	КонецЕсли;
	
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ИнвентаризацияОС") Тогда
		ОбработкаЗаполненияИнвентаризацияОС(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПоступлениеАрендованныхОС") Тогда
		ОбработкаЗаполненияПоступлениеАрендованныхОС(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ И ДополнительныеСвойства.РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
		Документы.ВыбытиеАрендованныхОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства, "РеестрДокументов,ДокументыПоОС");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
		РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
		
	ПроверитьЧтоОСПолученыОтАрендодателя(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ОчиститьЗаписатьДвижения(Движения, "Хозрасчетный");
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	Если НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Дата) Тогда
		УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
		УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
		УчетОСВызовСервера.ПроверитьСоответствиеМестонахожденияОС(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
		УчетОСВызовСервера.ПроверитьЗаполнениеСчетаУчетаОС(ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	КонецЕсли;
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	
	Документы.ВыбытиеАрендованныхОС.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РегистрыСведений.РеестрДокументов.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	РегистрыСведений.ДокументыПоОС.ЗаписатьДанныеДокумента(Ссылка, ДополнительныеСвойства, Отказ);
	
	ПроведениеСерверУТ.ЗагрузитьТаблицыДвижений(ДополнительныеСвойства, Движения);
	
	РеглУчетПроведениеСервер.ЗарегистрироватьКОтражению(ЭтотОбъект, ДополнительныеСвойства, Движения, Отказ);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	Если Не Отказ И НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Дата) Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	ПроведениеСерверУТ.СформироватьЗаписиРегистровЗаданий(ЭтотОбъект);
	
	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	ДокументНаОсновании = ЗначениеЗаполнено(ДокументОснование);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер,
		|	&Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения,
		|	&Подразделение КАК Подразделение,
		|	НЕОПРЕДЕЛЕНО КАК МОЛ");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ОбработкаЗаполненияПоступлениеАрендованныхОС(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДанныеЗаполнения", ДанныеЗаполнения);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИСТИНА КАК ДокументНаОсновании,
	|	ПоступлениеАрендованныхОС.Ссылка КАК ДокументОснование,
	|	ПоступлениеАрендованныхОС.Организация КАК Организация,
	|	ПоступлениеАрендованныхОС.Подразделение КАК Подразделение,
	|	ПоступлениеАрендованныхОС.Арендодатель КАК Арендодатель,
	|	ПоступлениеАрендованныхОС.ОС.(
	|		ОсновноеСредство КАК ОсновноеСредство
	|	)
	|ИЗ
	|	Документ.ПоступлениеАрендованныхОС КАК ПоступлениеАрендованныхОС
	|ГДЕ
	|	ПоступлениеАрендованныхОС.Ссылка = &ДанныеЗаполнения";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	ОС.Загрузить(Выборка.ОС.Выгрузить());
	
КонецПроцедуры

Процедура ОбработкаЗаполненияИнвентаризацияОС(Знач ДанныеЗаполнения)
	
	ДокументОснование = Неопределено;
	МассивНомеровСтрок = Неопределено;
	СообщатьОбОшибках = Истина;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДокументОснование = ДанныеЗаполнения.ДокументОснование;
		МассивНомеровСтрок = ДанныеЗаполнения.МассивНомеровСтрок;
		СообщатьОбОшибках = ДанныеЗаполнения.СообщатьОбОшибках;
	Иначе
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДокументОснование) Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗапроса = Документы.ИнвентаризацияОС.ДанныеЗаполненияНаОснованииИнвентаризации22(ДокументОснование, "ВыбытиеАрендованныхОС", МассивНомеровСтрок);
	Если РезультатЗапроса.ТабличнаяЧасть = Неопределено Или РезультатЗапроса.ТабличнаяЧасть.Пустой() Тогда
		Если СообщатьОбОшибках Тогда
			ТекстОшибки = НСтр("ru='В документе %1 отсутствуют строки требующие заполнения перемещения'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ДокументОснование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.ДокументОснование");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Реквизиты.Выбрать();
	Выборка.Следующий();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	СуммаЧастичнойНедостачи = 0;
	
	Выборка = РезультатЗапроса.ТабличнаяЧасть.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Подразделение) Тогда
			Арендодатель = Выборка.Арендодатель;
			Подразделение = Выборка.УчетПодразделение;
		КонецЕсли;
		
		Если Арендодатель = Выборка.Арендодатель И Подразделение = Выборка.УчетПодразделение Тогда
			НоваяСтрока = ОС.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьЧтоОСПолученыОтАрендодателя(Отказ)

	Если НЕ ЗначениеЗаполнено(Арендодатель)
		ИЛИ НЕ ЗначениеЗаполнено(Организация)
		ИЛИ НЕ ЗначениеЗаполнено(Подразделение)
		ИЛИ НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Дата) Тогда
		Возврат;
	КонецЕсли; 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство
	|ПОМЕСТИТЬ ТаблицаОС
	|ИЗ
	|	&ТаблицаОС КАК ТаблицаОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаОС.НомерСтроки КАК НомерСтроки,
	|	ВЫРАЗИТЬ(ТаблицаОС.ОсновноеСредство КАК Справочник.ОбъектыЭксплуатации).Представление КАК ОсновноеСредствоПредставление,
	|	МестонахождениеОС.Организация КАК Организация,
	|	МестонахождениеОС.Местонахождение КАК Местонахождение,
	|	МестонахождениеОС.Местонахождение.Представление КАК МестонахождениеПредставление,
	|	ПервоначальныеСведенияОС.Арендодатель КАК Арендодатель,
	|	ПервоначальныеСведенияОС.Арендодатель.Представление КАК АрендодательПредставление
	|ИЗ
	|	ТаблицаОС КАК ТаблицаОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(
	|				&Дата,
	|				Регистратор <> &Регистратор
	|					И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ТаблицаОС.ОсновноеСредство
	|						ИЗ
	|							ТаблицаОС)) КАК МестонахождениеОС
	|		ПО (МестонахождениеОС.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПервоначальныеСведенияОС.СрезПоследних(
	|				&Дата,
	|				Регистратор <> &Регистратор
	|					И Организация = &Организация
	|					И ОсновноеСредство В
	|						(ВЫБРАТЬ
	|							ТаблицаОС.ОсновноеСредство
	|						ИЗ
	|							ТаблицаОС)) КАК ПервоначальныеСведенияОС
	|		ПО (ПервоначальныеСведенияОС.ОсновноеСредство = ТаблицаОС.ОсновноеСредство)
	|ГДЕ
	|	(МестонахождениеОС.Местонахождение <> &Подразделение
	|			ИЛИ МестонахождениеОС.Организация <> &Организация
	|			ИЛИ ПервоначальныеСведенияОС.Арендодатель <> &Арендодатель
	|			ИЛИ ПервоначальныеСведенияОС.ОсновноеСредство ЕСТЬ NULL)
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("Арендодатель", Арендодатель);
	Запрос.УстановитьПараметр("ТаблицаОС", ОС.Выгрузить());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Путь = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Выборка.НомерСтроки, "ОсновноеСредство");
		
		Если НЕ ЗначениеЗаполнено(Выборка.Арендодатель) Тогда
			ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" не числится полученным в аренду на %2'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ОсновноеСредствоПредставление, Формат(Дата, "ДЛФ=D"));
			
		ИначеЕсли Выборка.Организация <> Организация Тогда
			ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" получено в аренду в другую организацию ""%2""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ОсновноеСредствоПредставление, Выборка.ОрганизацияПредставление);
			
		ИначеЕсли Выборка.Арендодатель <> Арендодатель Тогда
			ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" получено в аренду от другого арендодателя ""%2""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ОсновноеСредствоПредставление, Выборка.АрендодательПредставление);
			
		ИначеЕсли Выборка.Местонахождение <> Подразделение Тогда
			ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" получено в аренду в другое подразделение ""%2""'");
			ТекстСообщения = СтрШаблон(ТекстСообщения, Выборка.ОсновноеСредствоПредставление, Выборка.МестонахождениеПредставление);
			
		КонецЕсли; 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Путь,, Отказ);
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
