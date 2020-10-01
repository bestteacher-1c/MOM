
#Область ПрограммныйИнтерфейс

#Область ПереопределяемыеФункцииУправленияПечатью

// Определяет объекты конфигурации, в модулях менеджеров которых размещена процедура ДобавитьКомандыПечати,
// формирующая список команд печати, предоставляемых этим объектом.
// Синтаксис процедуры ДобавитьКомандыПечати см. в документации к подсистеме.
//
// Параметры:
//  СписокОбъектов - Массив - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ОпределитьОбъектыСКомандамиПечати(СписокОбъектов) Экспорт
	
	//++ НЕ ГОСИС
	
	
	//++ НЕ УТ
	СписокОбъектов.Добавить(Документы.РаспределениеПрочихЗатрат);
	СписокОбъектов.Добавить(Документы.НаработкаОбъектовЭксплуатации);
	СписокОбъектов.Добавить(Документы.СписаниеЗатратНаВыпуск);

	СписокОбъектов.Добавить(Справочники.ГрафикиРаботыСотрудников);
	СписокОбъектов.Добавить(Справочники.НематериальныеАктивы);
	СписокОбъектов.Добавить(Справочники.ОбъектыЭксплуатации);
	СписокОбъектов.Добавить(Справочники.ПартииПроизводства);
	СписокОбъектов.Добавить(Справочники.РесурсныеСпецификации);
	СписокОбъектов.Добавить(Документы.АктВыполненныхВнутреннихРабот);
	СписокОбъектов.Добавить(Документы.АктПриемкиВыполненныхРаботОказанныхУслуг);
	СписокОбъектов.Добавить(Документы.ВыкупПринятыхНаХранениеТоваров);
	СписокОбъектов.Добавить(Документы.ВыкупТоваровХранителем);
	СписокОбъектов.Добавить(Документы.ВыработкаСотрудников);
	СписокОбъектов.Добавить(Документы.ДвижениеПродукцииИМатериалов);
	СписокОбъектов.Добавить(Документы.ЗаказМатериаловВПроизводство);
	СписокОбъектов.Добавить(Документы.ЗаказПереработчику);
	СписокОбъектов.Добавить(Документы.ОтгрузкаТоваровСХранения);
	СписокОбъектов.Добавить(Документы.ОтчетПереработчика);
	СписокОбъектов.Добавить(Документы.ПередачаМатериаловВПроизводство);
	СписокОбъектов.Добавить(Документы.ПередачаСырьяПереработчику);
	СписокОбъектов.Добавить(Документы.ПередачаТоваровХранителю);
	СписокОбъектов.Добавить(Документы.ПланПроизводства);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровОтХранителя);
	СписокОбъектов.Добавить(Документы.ПриемкаТоваровНаХранение);
	СписокОбъектов.Добавить(Документы.РаспределениеВозвратныхОтходов);
	СписокОбъектов.Добавить(Документы.СписаниеПринятыхНаХранениеТоваров);
	СписокОбъектов.Добавить(Документы.СписаниеТоваровУХранителя);
	СписокОбъектов.Добавить(Документы.ЭкземплярБюджета);
	//-- НЕ УТ
	
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеПересортицыТоваров);
	СписокОбъектов.Добавить(Обработки.УправлениеПринятойВозвратнойТарой);
	СписокОбъектов.Добавить(Справочники.ДоговорыМеждуОрганизациями);
	СписокОбъектов.Добавить(Справочники.СтруктураПредприятия);
	
	СписокОбъектов.Добавить(Справочники.ВариантыГрафиковКредитовИДепозитов);
	СписокОбъектов.Добавить(Справочники.ГорячиеКлавиши);
	СписокОбъектов.Добавить(Справочники.ГруппыАналитическогоУчетаНоменклатуры);
	СписокОбъектов.Добавить(Справочники.ГруппыФинансовогоУчетаНоменклатуры);
	СписокОбъектов.Добавить(Справочники.ДоговорыКонтрагентов);
	СписокОбъектов.Добавить(Справочники.ДоговорыКредитовИДепозитов);
	СписокОбъектов.Добавить(Справочники.КартыЛояльности);
	СписокОбъектов.Добавить(Справочники.Контрагенты);
	СписокОбъектов.Добавить(Справочники.Номенклатура);
	СписокОбъектов.Добавить(Справочники.ОбластиХранения);
	СписокОбъектов.Добавить(Справочники.Организации);
	СписокОбъектов.Добавить(Справочники.Партнеры);
	СписокОбъектов.Добавить(Справочники.ПравилаОбменаСПодключаемымОборудованиемOffline);
	СписокОбъектов.Добавить(Справочники.ПретензииКлиентов);
	СписокОбъектов.Добавить(Справочники.РабочиеУчастки);
	СписокОбъектов.Добавить(Справочники.СделкиСКлиентами);
	СписокОбъектов.Добавить(Справочники.СертификатыНоменклатуры);
	СписокОбъектов.Добавить(Справочники.СкладскиеПомещения);
	СписокОбъектов.Добавить(Справочники.СкладскиеЯчейки);
	СписокОбъектов.Добавить(Справочники.Склады);
	СписокОбъектов.Добавить(Справочники.СоглашенияСКлиентами);
	СписокОбъектов.Добавить(Справочники.СоглашенияСПоставщиками);
	СписокОбъектов.Добавить(Справочники.ФизическиеЛица);
	СписокОбъектов.Добавить(Справочники.ШтрихкодыУпаковокТоваров);
	СписокОбъектов.Добавить(Документы.АвансовыйОтчет);
	СписокОбъектов.Добавить(Документы.АктВыполненныхРабот);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеОтгрузки);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеПеремещения);
	СписокОбъектов.Добавить(Документы.АктОРасхожденияхПослеПриемки);
	СписокОбъектов.Добавить(Документы.ВводОстатков);
	СписокОбъектов.Добавить(Документы.ВзаимозачетЗадолженности);
	СписокОбъектов.Добавить(Документы.ВнутреннееПотреблениеТоваров);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровОтКлиента);
	СписокОбъектов.Добавить(Документы.ВозвратТоваровПоставщику);
	СписокОбъектов.Добавить(Документы.ВыкупВозвратнойТарыКлиентом);
	СписокОбъектов.Добавить(Документы.ДоверенностьВыданная);
	СписокОбъектов.Добавить(Документы.ЗаданиеНаПеревозку);
	СписокОбъектов.Добавить(Документы.ЗаданиеТорговомуПредставителю);
	СписокОбъектов.Добавить(Документы.ЗаказКлиента);
	СписокОбъектов.Добавить(Документы.ЗаказНаВнутреннееПотребление);
	СписокОбъектов.Добавить(Документы.ЗаказНаПеремещение);
	СписокОбъектов.Добавить(Документы.ЗаказНаСборку);
	СписокОбъектов.Добавить(Документы.ЗаказПоставщику);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	СписокОбъектов.Добавить(Документы.ЗаявкаНаРасходованиеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ИзменениеАссортимента);
	СписокОбъектов.Добавить(Документы.ИнвентаризационнаяОпись);
	СписокОбъектов.Добавить(Документы.ИнвентаризацияНаличныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.КорректировкаПоОрдеруНаТовары);
	СписокОбъектов.Добавить(Документы.КорректировкаПриобретения);
	СписокОбъектов.Добавить(Документы.КорректировкаРеализации);
	СписокОбъектов.Добавить(Документы.КорректировкаРегистров);
	СписокОбъектов.Добавить(Документы.ЛимитыРасходаДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ЛистКассовойКниги);
	СписокОбъектов.Добавить(Документы.НормативРаспределенияПлановПродажПоКатегориям);
	СписокОбъектов.Добавить(Документы.ОжидаемоеПоступлениеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ОперацияПоПлатежнойКарте);
	СписокОбъектов.Добавить(Документы.ОприходованиеИзлишковТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеИзлишковТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеНедостачТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаОтражениеПорчиТоваров);
	СписокОбъектов.Добавить(Документы.ОрдерНаПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ОтборРазмещениеТоваров);
	СписокОбъектов.Добавить(Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ОтчетБанкаПоОперациямЭквайринга);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионера);
	СписокОбъектов.Добавить(Документы.ОтчетКомиссионераОСписании);
	СписокОбъектов.Добавить(Документы.ОтчетКомитенту);
	СписокОбъектов.Добавить(Документы.ОтчетКомитентуОСписании);
	СписокОбъектов.Добавить(Документы.ОтчетОРозничныхПродажах);
	СписокОбъектов.Добавить(Документы.ОтчетПоКомиссииМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ОтчетПоКомиссииМеждуОрганизациямиОСписании);
	СписокОбъектов.Добавить(Документы.ПередачаТоваровМеждуОрганизациями);
	СписокОбъектов.Добавить(Документы.ПеремещениеТоваров);
	СписокОбъектов.Добавить(Документы.ПересортицаТоваров);
	СписокОбъектов.Добавить(Документы.ПересчетТоваров);
	СписокОбъектов.Добавить(Документы.ПланЗакупок);
	СписокОбъектов.Добавить(Документы.ПланОстатков);
	СписокОбъектов.Добавить(Документы.ПланПродаж);
	СписокОбъектов.Добавить(Документы.ПланПродажПоКатегориям);
	СписокОбъектов.Добавить(Документы.ПланСборкиРазборки);
	СписокОбъектов.Добавить(Документы.ПорчаТоваров);
	СписокОбъектов.Добавить(Документы.ПоручениеЭкспедитору);
	СписокОбъектов.Добавить(Документы.ПоступлениеБезналичныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.ПоступлениеТоваровНаСклад);
	СписокОбъектов.Добавить(Документы.ПриобретениеТоваровУслуг);
	СписокОбъектов.Добавить(Документы.ПриобретениеУслугПрочихАктивов);
	СписокОбъектов.Добавить(Документы.ПриходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.ПриходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.ПрочееОприходованиеТоваров);
	СписокОбъектов.Добавить(Документы.ПрочиеДоходыРасходы);
	СписокОбъектов.Добавить(Документы.РаспоряжениеНаПеремещениеДенежныхСредств);
	СписокОбъектов.Добавить(Документы.РаспределениеДоходовПоНаправлениямДеятельности);
	СписокОбъектов.Добавить(Документы.РаспределениеРасходовБудущихПериодов);
	СписокОбъектов.Добавить(Документы.РасходныйКассовыйОрдер);
	СписокОбъектов.Добавить(Документы.РасходныйОрдерНаТовары);
	СписокОбъектов.Добавить(Документы.РасчетСебестоимостиТоваров);
	СписокОбъектов.Добавить(Документы.РеализацияПодарочныхСертификатов);
	СписокОбъектов.Добавить(Документы.РеализацияТоваровУслуг);
	СписокОбъектов.Добавить(Документы.РеализацияУслугПрочихАктивов);
	СписокОбъектов.Добавить(Документы.РегистрацияЦенНоменклатурыПоставщика);
	СписокОбъектов.Добавить(Документы.СборкаТоваров);
	СписокОбъектов.Добавить(Документы.СверкаВзаиморасчетов);
	СписокОбъектов.Добавить(Документы.СверкаНачальныхОстатковПоСкладу);
	СписокОбъектов.Добавить(Документы.СписаниеБезналичныхДенежныхСредств);
	СписокОбъектов.Добавить(Документы.СписаниеЗадолженности);
	СписокОбъектов.Добавить(Документы.СписаниеНедостачТоваров);
	СписокОбъектов.Добавить(Документы.СправкаОПодтверждающихДокументах);
	СписокОбъектов.Добавить(Документы.СчетНаОплатуКлиенту);
	СписокОбъектов.Добавить(Документы.ТаможеннаяДекларацияИмпорт);
	СписокОбъектов.Добавить(Документы.ТранспортнаяНакладная);
	СписокОбъектов.Добавить(Документы.УпаковочныйЛист);
	СписокОбъектов.Добавить(Документы.УстановкаБлокировокЯчеек);
	СписокОбъектов.Добавить(Документы.УстановкаКвотАссортимента);
	СписокОбъектов.Добавить(Документы.УстановкаЦенНоменклатуры);
	СписокОбъектов.Добавить(Обработки.ПечатьЗаданияНаОтборРазмещениеТоваров);
	СписокОбъектов.Добавить(Обработки.РабочееМестоМенеджераПоДоставке);
	СписокОбъектов.Добавить(Обработки.УправлениеОтгрузкой);
	СписокОбъектов.Добавить(Обработки.УправлениеПереданнойВозвратнойТарой);
	СписокОбъектов.Добавить(Обработки.УправлениеПоступлением);
	СписокОбъектов.Добавить(Обработки.ЖурналСкладскихАктов);
	
	УправлениеПечатьюЛокализация.ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента().
// Используется в случае, когда необходимо сократить список форматов сохранения, предлагаемый пользователю
// перед сохранением печатной формы в файл, либо перед отправкой по почте.
//
// Параметры:
//  ТаблицаФорматов - ТаблицаЗначений - коллекция форматов сохранения:
//   * ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента - значение в платформе, соответствующее формату;
//   * Ссылка        - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//   * Представление - Строка - представление типа файла (заполняется из перечисления);
//   * Расширение    - Строка - тип файла для операционной системы;
//   * Картинка      - Картинка - значок формата.
//
Процедура ЗаполнитьНастройкиФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией УправлениеПечатью.КомандыПечатиФормы.
// Используется для общих форм, у которых нет модуля менеджера для размещения в нем процедуры ДобавитьКомандыПечати,
// для случаев, когда штатных средств добавления команд в такие формы недостаточно. Например, если нужны свои команды,
// которых нет в других объектах.
// 
// Параметры:
//  ИмяФормы             - Строка - полное имя формы, в которой добавляются команды печати;
//  КомандыПечати        - ТаблицаЗначений - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати;
//  СтандартнаяОбработка - Булево - при установке значения Ложь не будет автоматически заполняться коллекция КомандыПечати.
//
Процедура ДобавитьКомандыПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
	Если ИмяФормы = "Документ.ОрдерНаОтражениеПорчиТоваров.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.СписаниеБезналичныхДенежныхСредств.ДобавитьКомандыПечати(КоллекцияКомандПечати);
		Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОрдерНаОтражениеПорчиТоваров";
			КонецЕсли;
		КонецЦикла;
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КоллекцияКомандПечати, "Документ.ОрдерНаОтражениеПорчиТоваров");
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	
	ИначеЕсли ИмяФормы = "ЖурналДокументов.ОтчетыКомитентам.Форма.ФормаСпискаДокументов" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ОтчетКомитенту.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитенту";
			КонецЕсли;
		КонецЦикла;
		
		ДобавляемыеКомандыПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		Документы.ОтчетКомитентуОСписании.ДобавитьКомандыПечати(ДобавляемыеКомандыПечати);
		Для Каждого КомандаПечати Из ДобавляемыеКомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ОтчетКомитентуОСписании";
			КонецЕсли;
			Отбор = Новый Структура("Идентификатор,Представление,МенеджерПечати,Обработчик");
			ЗаполнитьЗначенияСвойств(Отбор, КомандаПечати);
			НайденныеКоманды = КомандыПечати.НайтиСтроки(Отбор);
			Если НайденныеКоманды.Количество() = 0 Тогда
				ЗаполнитьЗначенияСвойств(КомандыПечати.Добавить(), КомандаПечати);
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитенту");
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ОтчетКомитентуОСписании");
	
	ИначеЕсли ИмяФормы = "Обработка.ЖурналДокументовЗакупки.Форма.ФормаВыбораРаспоряжения" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Документы.ЗаказПоставщику.ДобавитьКомандыПечати(КомандыПечати);
		Для Каждого КомандаПечати Из КомандыПечати Цикл
			Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
				КомандаПечати.МенеджерПечати = "Документ.ЗаказПоставщику";
			КонецЕсли;
		КонецЦикла;
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Документ.ЗаказПоставщику");
	
	ИначеЕсли ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСпискаКонтекст" 
	 ИЛИ ИмяФормы = "Справочник.СертификатыНоменклатуры.Форма.ФормаСписка" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Справочники.СертификатыНоменклатуры.ДобавитьКомандыПечати(КомандыПечати);
		
		ДополнительныеОтчетыИОбработки.ПриПолученииКомандПечати(КомандыПечати, "Справочник.СертификатыНоменклатуры");
		
	ИначеЕсли ИмяФормы = "Справочник.ШтрихкодыУпаковокТоваров.Форма.ФормаЭлемента"
		ИЛИ ИмяФормы = "Справочник.ШтрихкодыУпаковокТоваров.Форма.ФормаСписка" Тогда
		
		//СтандартнаяОбработка = Ложь;
		//Если НЕ ПраваПользователяПовтИсп.ПечатьЭтикетокИЦенников() Тогда
		//	Возврат;
		//КонецЕсли;
		//
		//КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
		//
		//КомандаПечати = КоллекцияКомандПечати.Добавить();
		//КомандаПечати.Обработчик = "УправлениеПечатьюУТКлиент.ПечатьШтрихкодовУпаковок";
		//КомандаПечати.Идентификатор = "ШтрихкодыУпаковок";
		//КомандаПечати.Представление = НСтр("ru = 'Печать штрихкодов упаковок'");
		//
		//ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КоллекцияКомандПечати, КомандыПечати);
		
	КонецЕсли;
	
	УправлениеПечатьюЛокализация.ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка);
	
КонецПроцедуры

// Дополнительные настройки списка команд печати в журналах документов.
//
// Параметры:
//  НастройкиСписка - Структура - модификаторы списка команд печати.
//   * МенеджерКомандПечати     - МенеджерОбъекта - менеджер объекта, в котором формируется список команд печати;
//   * АвтоматическоеЗаполнение - Булево - заполнять команды печати из объектов, входящих в состав журнала.
//                                         Если установлено значение Ложь, то список команд печати журнала будет
//                                         заполнен вызовом метода ДобавитьКомандыПечати из модуля менеджера журнала.
//                                         Значение по умолчанию: Истина - метод ДобавитьКомандыПечати будет вызван из
//                                         модулей менеджеров документов, входящих в состав журнала.
Процедура ПолучитьНастройкиСпискаКомандПечати(НастройкиСписка) Экспорт
	
	УправлениеПечатьюЛокализация.ПриПолученииНастроекСпискаКомандПечати(НастройкиСписка);
	
КонецПроцедуры

// Вызывается после завершения вызова процедуры Печать менеджера печати объекта, имеет те же параметры.
// Может использоваться для постобработки всех печатных форм при их формировании.
// Например, можно вставить в колонтитул дату формирования печатной формы.
//
// Параметры:
//  МассивОбъектов - Массив - список объектов, для которых была выполнена процедура Печать;
//  ПараметрыПечати - Структура - произвольные параметры, переданные при вызове команды печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - содержит табличные документы и дополнительную информацию;
//  ОбъектыПечати - СписокЗначений - соответствие между объектами и именами областей в табличных документах, где
//                                   значение - Объект, представление - имя области с объектом в табличных документах;
//  ПараметрыВывода - Структура - параметры, связанные с выводом табличных документов:
//   * ПараметрыОтправки - Структура - информация для заполнения письма при отправке печатной формы по электронной почте.
//                                     Содержит следующие поля (описание см. в общем модуле конфигурации
//                                     РаботаСПочтовымиСообщениямиКлиент в процедуре СоздатьНовоеПисьмо):
//    ** Получатель;
//    ** Тема,
//    ** Текст.
Процедура ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если ТипЗнч(МассивОбъектов) = Тип("Массив")
		И МассивОбъектов.Количество()
		И ТипЗнч(МассивОбъектов[0]) = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		ДоставкаТоваров.ПриПечати(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	ИначеЕсли ТипЗнч(МассивОбъектов) = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		МассивЗаданий = Новый Массив;
		МассивЗаданий.Добавить(МассивОбъектов);
		ДоставкаТоваров.ПриПечати(МассивЗаданий, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет параметры отправки печатных форм при подготовке письма.
// Может использоваться, например, для подготовки текста письма.
//
// Параметры:
//  ПараметрыОтправки - Структура - коллекция параметров:
//   * Получатель - Массив - коллекция имен получателей;
//   * Тема - Строка - тема письма;
//   * Текст - Строка - текст письма;
//   * Вложения - Структура - коллекция вложений:
//    ** АдресВоВременномХранилище - Строка - адрес вложения во временном хранилище;
//    ** Представление - Строка - имя файла вложения.
//  ОбъектыПечати - Массив - коллекция объектов, по которым сформированы печатные формы.
//  ПараметрыВывода - Структура - параметр ПараметрыВывода в вызове процедуры Печать.
//  ПечатныеФормы - ТаблицаЗначений - коллекция табличных документов:
//   * Название - Строка - название печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатая форма.
Процедура ПередОтправкойПоПочте(ПараметрыОтправки, ПараметрыВывода, ОбъектыПечати, ПечатныеФормы) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Конструктор для параметра КоллекцияПечатныхФорм процедуры Печать.
//
// ВозвращаемоеЗначение:
//  ТаблицаЗначений - пустая коллекция печатных форм:
//   * ИмяМакета - Строка - идентификатор печатной формы;
//   * ИмяВРЕГ - Строка - идентификатор в верхнем регистре символов для быстрого поиска;
//   * СинонимМакета - Строка - представление печатной формы;
//   * ТабличныйДокумент - ТабличныйДокумент - печатная форма;
//   * Экземпляров - Число - количество копий, которое необходимо вывести на печать;
//   * Картинка - Картинка - (не используется);
//   * ПолныйПутьКМакету - Строка - используется для быстрого перехода к редактированию макета печатной формы;
//   * ИмяФайлаПечатнойФормы - Строка - имя файла;
//                           - Соответствие - имена файлов для каждого объекта:
//                              ** Ключ - ЛюбаяСсылка - ссылка на объект печати;
//                              ** Значение - Строка - имя файла;
//   * ОфисныеДокументы - Соответствие - коллекция печатных форм в формате офисных документов:
//                         ** Ключ - Строка - адрес во временном хранилище двоичных данных печатной формы;
//                         ** Значение - Строка - имя файла печатной формы.
Функция ПодготовитьКоллекциюПечатныхФорм(Знач ИменаМакетов) Экспорт
	
	Макеты = Новый ТаблицаЗначений;
	Макеты.Колонки.Добавить("ИмяМакета");
	Макеты.Колонки.Добавить("ИмяВРЕГ");
	Макеты.Колонки.Добавить("СинонимМакета");
	Макеты.Колонки.Добавить("ТабличныйДокумент");
	Макеты.Колонки.Добавить("Экземпляров");
	Макеты.Колонки.Добавить("Картинка");
	Макеты.Колонки.Добавить("ПолныйПутьКМакету");
	Макеты.Колонки.Добавить("ИмяФайлаПечатнойФормы");
	Макеты.Колонки.Добавить("ОфисныеДокументы");
	
	Если ТипЗнч(ИменаМакетов) = Тип("Строка") Тогда
		ИменаМакетов = СтрРазделить(ИменаМакетов, ",");
	КонецЕсли;
	
	Для Каждого ИмяМакета Из ИменаМакетов Цикл
		Макет = Макеты.Найти(ИмяМакета, "ИмяМакета");
		Если Макет = Неопределено Тогда
			Макет = Макеты.Добавить();
			Макет.ИмяМакета = ИмяМакета;
			Макет.ИмяВРЕГ = ВРег(ИмяМакета);
			Макет.Экземпляров = 1;
		Иначе
			Макет.Экземпляров = Макет.Экземпляров + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Макеты;
	
КонецФункции

#КонецОбласти
