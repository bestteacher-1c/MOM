
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ДанныеДокумента = ПолучитьДанныеДокументаПоСсылке(ПараметрКоманды);
	
	Если ДанныеДокумента.Проведен = Истина Тогда
		
		Сообщить("нельзя заполнять проведеннный документ! Снимите документ с проводки.");
		Возврат;
	
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрКоманды",ПараметрКоманды);
	ДополнительныеПараметры.Вставить("ПараметрыВыполненияКоманды",ПараметрыВыполненияКоманды);
	
	ПоказатьВводЗначения(
	Новый ОписаниеОповещения("ВыбратьОрганизациюЗавершение", ЭтотОбъект, ДополнительныеПараметры)
	,,"По какой организации анализируем продажи", Тип("СправочникСсылка.Организации"));
	
КонецПроцедуры


// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Процедура ЗаполнитьПроизводствоБезЗаказаПоДаннымПоПродажамЗаПериод(Ссылка, Организация, Склад, СкладПроизводство, Дата1, Дата2)
	
	Запрос = Новый Запрос;
	
	Если Организация = Справочники.Организации.ПолучитьСсылку(
		Новый УникальныйИдентификатор("d24dcb00-901b-4b79-92bf-18000983ac86")) Тогда   //мом
		
		ГФУ_Ссылка = Справочники.ГруппыФинансовогоУчетаНоменклатуры.ПолучитьСсылку(
		Новый УникальныйИдентификатор("26520fd5-13fb-11e9-9593-9367f7e3dc6e"));  //Мом
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	Продажи.АналитикаУчетаНоменклатуры КАК АналитикаУчНоменклатуры,
		|	Продажи.КоличествоОборот КАК Количество,
		|	13 КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ ВТПродажи
		|ИЗ
		|	РегистрНакопления.ВыручкаИСебестоимостьПродаж.Обороты(
		|			&Дата1,
		|			&Дата2,
		|			,
		|			АналитикаУчетаПоПартнерам.Организация = &Организация
		|				И ВЫБОР
		|					КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ Склад = &Склад
		|				КОНЕЦ) КАК Продажи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
		|	АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	ВТПродажи.Количество КАК Количество,
		|	ВТПродажи.СтатусУказанияСерий КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ ВТПродажиНоменклатуры
		|ИЗ
		|	ВТПродажи КАК ВТПродажи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
		|		ПО (ВТПродажи.АналитикаУчНоменклатуры = АналитикаУчетаНоменклатуры.КлючАналитики)
		|ГДЕ
		|	АналитикаУчетаНоменклатуры.Номенклатура.ГруппаФинансовогоУчета = &ГруппаФинансовогоУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПродажиНоменклатуры.Номенклатура КАК Номенклатура,
		|	ВТПродажиНоменклатуры.Характеристика КАК Характеристика,
		|	ВТПродажиНоменклатуры.Серия КАК Серия,
		|	&СкладПроизводство КАК Получатель,
		|	ВТПродажиНоменклатуры.Назначение КАК Назначение,
		|	ВТПродажиНоменклатуры.Количество КАК Количество,
		|	ВТПродажиНоменклатуры.Количество КАК КоличествоУпаковок,
		|	ВТПродажиНоменклатуры.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	ЕСТЬNULL(ОсновныеСпецификации.Спецификация, ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаяСсылка)) КАК Спецификация,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад) КАК НаправлениеВыпуска,
		|	ЛОЖЬ КАК УдалитьОсновноеИзделиеГруппыЗатрат,
		|	ЛОЖЬ КАК ПередатьДавальцу
		|ИЗ
		|	ВТПродажиНоменклатуры КАК ВТПродажиНоменклатуры
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСпецификации КАК ОсновныеСпецификации
		|		ПО ВТПродажиНоменклатуры.Номенклатура = ОсновныеСпецификации.Номенклатура
		|			И ВТПродажиНоменклатуры.Характеристика = ОсновныеСпецификации.Характеристика
		|			И (ОсновныеСпецификации.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))";
		
	ИначеЕсли Организация = Справочники.Организации.ПолучитьСсылку(
		Новый УникальныйИдентификатор("109056ba-3f27-11e4-1785-9c8e997b6465")) Тогда    //ип
		
		ГФУ_Ссылка = Справочники.ГруппыФинансовогоУчетаНоменклатуры.ПолучитьСсылку(
		Новый УникальныйИдентификатор("3d2f1032-0f45-11ea-a8af-c88f7804aed9"));  //ИП
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	Продажи.АналитикаУчетаНоменклатуры КАК АналитикаУчНоменклатуры,
		|	Продажи.КоличествоОборот КАК Количество,
		|	13 КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ ВТПродажи
		|ИЗ
		|	РегистрНакопления.ВыручкаИСебестоимостьПродаж.Обороты(
		|			&Дата1,
		|			&Дата2,
		|			,
		|			АналитикаУчетаПоПартнерам.Организация = &Организация
		|				И ВЫБОР
		|					КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ Склад = &Склад
		|				КОНЕЦ) КАК Продажи
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияНоменклатураНоменклатураОбороты.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	ДвиженияНоменклатураНоменклатураОбороты.КоличествоОборот КАК Количество
		|ПОМЕСТИТЬ ВТПеремещение
		|ИЗ
		|	РегистрНакопления.ДвиженияНоменклатураНоменклатура.Обороты(
		|			&Дата1,
		|			&Дата2,
		|			,
		|			Организация = &Организация
		|				И ВЫБОР
		|					КОГДА &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
		|						ТОГДА ИСТИНА
		|					ИНАЧЕ Склад = &Склад
		|				КОНЕЦ
		|				И КорСклад.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)) КАК ДвиженияНоменклатураНоменклатураОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РС_АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	РС_АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	РС_АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	РС_АналитикаУчетаНоменклатуры.МестоХранения КАК Склад,
		|	РС_АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	ВТПродажи.Количество КАК Количество,
		|	ВТПродажи.СтатусУказанияСерий КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ ВТПродажиИПеремещенияНоменклатуры
		|ИЗ
		|	ВТПродажи КАК ВТПродажи
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК РС_АналитикаУчетаНоменклатуры
		|		ПО ВТПродажи.АналитикаУчНоменклатуры = РС_АналитикаУчетаНоменклатуры.КлючАналитики
		|ГДЕ
		|	РС_АналитикаУчетаНоменклатуры.Номенклатура.ГруппаФинансовогоУчета = &ГруппаФинансовогоУчета
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РС_АналитикаУчетаНоменклатуры.Номенклатура,
		|	РС_АналитикаУчетаНоменклатуры.Характеристика,
		|	РС_АналитикаУчетаНоменклатуры.Серия,
		|	РС_АналитикаУчетаНоменклатуры.МестоХранения,
		|	РС_АналитикаУчетаНоменклатуры.Назначение,
		|	ВТПеремещение.Количество,
		|	13
		|ИЗ
		|	ВТПеремещение КАК ВТПеремещение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК РС_АналитикаУчетаНоменклатуры
		|		ПО ВТПеремещение.АналитикаУчетаНоменклатуры = РС_АналитикаУчетаНоменклатуры.КлючАналитики
		|ГДЕ
		|	РС_АналитикаУчетаНоменклатуры.Номенклатура.ГруппаФинансовогоУчета = &ГруппаФинансовогоУчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПродажиИПеремещенияНоменклатуры.Номенклатура КАК Номенклатура,
		|	ВТПродажиИПеремещенияНоменклатуры.Характеристика КАК Характеристика,
		|	ВТПродажиИПеремещенияНоменклатуры.Серия КАК Серия,
		|	ВТПродажиИПеремещенияНоменклатуры.Склад КАК Склад,
		|	ВТПродажиИПеремещенияНоменклатуры.Назначение КАК Назначение,
		|	СУММА(ВТПродажиИПеремещенияНоменклатуры.Количество) КАК Количество,
		|	ВТПродажиИПеремещенияНоменклатуры.СтатусУказанияСерий КАК СтатусУказанияСерий
		|ПОМЕСТИТЬ ВТНоменклатураКПроизводству
		|ИЗ
		|	ВТПродажиИПеремещенияНоменклатуры КАК ВТПродажиИПеремещенияНоменклатуры
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТПродажиИПеремещенияНоменклатуры.Номенклатура,
		|	ВТПродажиИПеремещенияНоменклатуры.Характеристика,
		|	ВТПродажиИПеремещенияНоменклатуры.Серия,
		|	ВТПродажиИПеремещенияНоменклатуры.Склад,
		|	ВТПродажиИПеремещенияНоменклатуры.Назначение,
		|	ВТПродажиИПеремещенияНоменклатуры.СтатусУказанияСерий
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТНоменклатураКПроизводству.Номенклатура КАК Номенклатура,
		|	ВТНоменклатураКПроизводству.Характеристика КАК Характеристика,
		|	ВТНоменклатураКПроизводству.Серия КАК Серия,
		|	&СкладПроизводство КАК Получатель,
		|	ВТНоменклатураКПроизводству.Назначение КАК Назначение,
		|	ВТНоменклатураКПроизводству.Количество КАК Количество,
		|	ВТНоменклатураКПроизводству.Количество КАК КоличествоУпаковок,
		|	ВТНоменклатураКПроизводству.СтатусУказанияСерий КАК СтатусУказанияСерий,
		|	ЕСТЬNULL(ОсновныеСпецификации.Спецификация, ЗНАЧЕНИЕ(Справочник.РесурсныеСпецификации.ПустаяСсылка)) КАК Спецификация,
		|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад) КАК НаправлениеВыпуска,
		|	ЛОЖЬ КАК УдалитьОсновноеИзделиеГруппыЗатрат,
		|	ЛОЖЬ КАК ПередатьДавальцу
		|ИЗ
		|	ВТНоменклатураКПроизводству КАК ВТНоменклатураКПроизводству
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСпецификации КАК ОсновныеСпецификации
		|		ПО ВТНоменклатураКПроизводству.Номенклатура = ОсновныеСпецификации.Номенклатура
		|			И ВТНоменклатураКПроизводству.Характеристика = ОсновныеСпецификации.Характеристика
		|			И (ОсновныеСпецификации.Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка))";
		
	КонецЕсли;



	Запрос.Текст = ТекстЗапроса;
	
	Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Дата1",Дата1);
	Запрос.УстановитьПараметр("Дата2",КонецДня(Дата2));
	Запрос.УстановитьПараметр("Склад",Склад);
	Запрос.УстановитьПараметр("СкладПроизводство",СкладПроизводство);
	Запрос.УстановитьПараметр("ГруппаФинансовогоУчета",ГФУ_Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ДокОбъект = Ссылка.ПолучитьОбъект();
	
	ДокОбъект.ВыходныеИзделия.Очистить();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() = Истина Цикл
		
		НоваяСтрока = ДокОбъект.ВыходныеИзделия.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		
	КонецЦикла;
	
	ДокОбъект.Записать();
	
КонецПроцедуры // ПолучитьДанныеПоПродажамЗаПериод()


// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ВыбратьОрганизациюЗавершение(Организация, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Организация) = Истина Тогда
		
		ДополнительныеПараметры.Вставить("Организация", Организация);
		
		ПоказатьВводЗначения(
		Новый ОписаниеОповещения("ВыбратьСкладЗавершение", ЭтотОбъект, ДополнительныеПараметры)
		,ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка"),"СКЛАД АНАЛИЗА ПРОДАЖ!!", Тип("СправочникСсылка.Склады"));
		
		Сообщить("СКЛАД АНАЛИЗА ПРОДАЖ!!");
		
	КонецЕсли;
	
	
КонецПроцедуры // ВыбратьОрганизациюЗавершение()


// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ВыбратьСкладЗавершение(Склад,ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Склад) = Истина Тогда
		
		ДополнительныеПараметры.Вставить("Склад", Склад);
		
		СкладПроизводство = ПолучитьСсылкуНаСкладПроизводство();
		
		ПоказатьВводЗначения(
		Новый ОписаниеОповещения("ВыбратьСкладПроизводстваЗавершение",
		ЭтотОбъект, ДополнительныеПараметры)
		,СкладПроизводство,"НА КАКОЙ СКЛАД БУДЕТ ВЫПУЩЕНА ПРОДУКЦИЯ!!", );
		
		Сообщить("НА КАКОЙ СКЛАД БУДЕТ ВЫПУЩЕНА ПРОДУКЦИЯ!!");
	
	КонецЕсли;

КонецПроцедуры // ПолучитьДатуНачалаАнализаЗавершение()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ВыбратьСкладПроизводстваЗавершение(Склад,ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Склад) = Истина Тогда
		
		ДополнительныеПараметры.Вставить("СкладПроизводство", Склад);
		
		ПоказатьВводДаты(
		Новый ОписаниеОповещения("ПолучитьДатуНачалаАнализаЗавершение"
		, ЭтотОбъект, ДополнительныеПараметры)
		,,"Дата начала анализа продаж",);
	
	КонецЕсли;

КонецПроцедуры // ПолучитьДатуНачалаАнализаЗавершение()

&НаСервере
Функция ПолучитьСсылкуНаСкладПроизводство()

	Возврат Справочники.Склады.НайтиПоНаименованию("Производство",Истина);

КонецФункции // ПолучитьСсылкуНаСкладПроизводство()



// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ПолучитьДатуНачалаАнализаЗавершение(Дата,ДополнительныеПараметры) Экспорт

	Если Дата <> Неопределено Тогда
		
		ДополнительныеПараметры.Вставить("Дата1", Дата);
	
		ПоказатьВводДаты(
		Новый ОписаниеОповещения("ПолучитьДатуОкончанияАнализаЗавершение",ЭтотОбъект, ДополнительныеПараметры)
		,Дата,"Дата окончания анализа продаж",);
	
	КонецЕсли;

КонецПроцедуры // ПолучитьДатуНачалаАнализаЗавершение()


// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ПолучитьДатуОкончанияАнализаЗавершение(Дата,ДополнительныеПараметры) Экспорт

	Если Дата <> Неопределено Тогда
	
	  ЗаполнитьПроизводствоБезЗаказаПоДаннымПоПродажамЗаПериод(
	    ДополнительныеПараметры.ПараметрКоманды,
	    ДополнительныеПараметры.Организация,
		ДополнительныеПараметры.Склад,
		ДополнительныеПараметры.СкладПроизводство,
	    ДополнительныеПараметры.Дата1,
	    Дата);
		
		//ЗаполнитьРеализациюПоДаннымПоПродажамЗаПериод(
		//ДополнительныеПараметры.Товары,
		//ДополнительныеПараметры.Организация,
		//ДополнительныеПараметры.Дата1,
		//Дата);
		
		ДополнительныеПараметры.ПараметрыВыполненияКоманды.Источник.Прочитать();
	
	КонецЕсли;

КонецПроцедуры // ПолучитьДатуНачалаАнализаЗавершение()


// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция ПолучитьДанныеДокументаПоСсылке(Ссылка)

	Вернем = Новый Структура;
	
	Вернем.Вставить("Проведен", Ссылка.Проведен);
	
	Возврат Вернем;

КонецФункции // ПолучитьДанныеДокументаПоСсылке()

	


