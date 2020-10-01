
#Область ОбработчикиСобытийФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ПоказатьПериод(Форма)
	
	СтрПериодОтчета = ПредставлениеПериода(
		НачалоДня(Форма.мДатаНачалаПериодаОтчета), КонецДня(Форма.мДатаКонцаПериодаОтчета), "ФП = Истина");
	
	Форма.ПолеВыбораПериодичностиПоказаПериода = СтрПериодОтчета;
	
	КоличествоФорм = РегламентированнаяОтчетностьКлиентСервер.КоличествоФормСоответствующихВыбранномуПериоду(Форма);
	Если КоличествоФорм >= 1 Тогда
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость = КоличествоФорм > 1;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Истина;
			
	Иначе
		
		Форма.Элементы.ПолеРедакцияФормы.Видимость	 = Ложь;
		Форма.Элементы.ОткрытьФормуОтчета.Доступность = Ложь;
		
		Форма.ОписаниеНормативДок = "Отсутствует в программе.";
		
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ВыборФормыРегламентированногоОтчетаПоУмолчанию(Форма);
	
	// В РезультирующаяТаблица - действующие на выбранный период формы.
	// Заполним список выбора форм отчетности.
	Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Очистить();
	
	Для Каждого ЭлФорма Из Форма.РезультирующаяТаблица Цикл
		Форма.Элементы.ПолеРедакцияФормы.СписокВыбора.Добавить(ЭлФорма.РедакцияФормы);
	КонецЦикла;
	
	// Для периодов ранее 2013 года ссылку Изменения законадательства скрываем.
	ГодПериода = Год(Форма.мДатаКонцаПериодаОтчета);
	Форма.Элементы.ПолеСсылкаИзмененияЗаконодательства.Видимость = ГодПериода > 2012;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПериод(Форма, Шаг)
	
	Форма.мДатаКонцаПериодаОтчета  = КонецМесяца(ДобавитьМесяц(Форма.мДатаКонцаПериодаОтчета, Шаг));
	Форма.мДатаНачалаПериодаОтчета = НачалоМесяца(Форма.мДатаКонцаПериодаОтчета);
	
	ПоказатьПериод(Форма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация              = Параметры.Организация;
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	мПериодичность           = Параметры.мПериодичность;
	мСкопированаФорма        = Параметры.мСкопированаФорма;
	мСохраненныйДок          = Параметры.мСохраненныйДок;
	
	ЭтаФормаИмя = Строка(ЭтаФорма.ИмяФормы);
	ИсточникОтчета = РегламентированнаяОтчетностьВызовСервера.ИсточникОтчета(ЭтаФормаИмя);
	ЗначениеВДанныеФормы(РегламентированнаяОтчетностьВызовСервера.ОтчетОбъект(ИсточникОтчета).ТаблицаФормОтчета(),
		мТаблицаФормОтчета);
	
	мТаблицаФормОтчета.Сортировать("ДатаНачалоДействия Убыв");
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
	
	ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	ПеречислениеПериодичностьМесяц = Перечисления.Периодичность.Месяц;
	
	Если НЕ ЗначениеЗаполнено(мДатаНачалаПериодаОтчета) И НЕ ЗначениеЗаполнено(мДатаКонцаПериодаОтчета) Тогда
		мДатаКонцаПериодаОтчета = КонецМесяца(ДобавитьМесяц(ТекущаяДатаСеанса(), -1));
		Если мДатаКонцаПериодаОтчета < КонецМесяца('20200430') Тогда
			мДатаКонцаПериодаОтчета = КонецМесяца('20200430');
		КонецЕсли;
		мДатаНачалаПериодаОтчета = НачалоМесяца(мДатаКонцаПериодаОтчета);
	КонецЕсли;
	
	мПериодичность = ПеречислениеПериодичностьМесяц;
	
	Элементы.ПолеРедакцияФормы.Видимость = НЕ (мТаблицаФормОтчета.Количество() > 1);
	
	ИзменитьПериод(ЭтаФорма, 0);
	
	Если НЕ ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ОргПоУмолчанию) Тогда
		Организация = ОргПоУмолчанию;
	КонецЕсли;
	
	Элементы.Организация.СписокВыбора.ЗагрузитьЗначения(СписокДоступныхЮридическихЛиц().ВыгрузитьЗначения());
	
	Если Элементы.Организация.СписокВыбора.НайтиПоЗначению(Организация) = Неопределено Тогда
		Организация = Неопределено;
	КонецЕсли;
	
	ДоступныеОрганизацииОтсутствуют = Ложь;
	
	Если Элементы.Организация.СписокВыбора.Количество() = 0 Тогда
		
		ДоступныеОрганизацииОтсутствуют = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		
		Сообщение.ИдентификаторНазначения = ЭтаФорма.УникальныйИдентификатор;
		
		Сообщение.Текст = ДоступныеОрганизацииОтсутствуютТекст();
		
		Сообщение.Сообщить();
		
		Элементы.Организация.КнопкаОткрытия = Ложь;
		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
		
		Элементы.Организация.СписокВыбора.Очистить();
		Элементы.НадписьОрганизация.Видимость = Ложь;
		
	КонецЕсли;
	
	// Вычислим общую часть ссылки на ИзмененияЗаконодательства.
	ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "http://v8.1c.ru/lawmonitor/lawchanges.jsp?";
	СпрРеглОтчетов = Справочники.РегламентированныеОтчеты;
	НайденнаяСсылка = СпрРеглОтчетов.НайтиПоРеквизиту("ИсточникОтчета", ИсточникОтчета);
	
	Если НайденнаяСсылка = СпрРеглОтчетов.ПустаяСсылка() Тогда
		
	    ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "";
		
	Иначе
		
	    УИДОтчета = НайденнаяСсылка.УИДОтчета;
		
		Фильтр1 = "regReportForm=" + УИДОтчета;
		Фильтр2 = "regReportOnly=true";
		УИДКонфигурации = "";
		РегламентированнаяОтчетностьПереопределяемый.ПолучитьУИДКонфигурации(УИДКонфигурации);
		Фильтр3 = "userConfiguration=" + УИДКонфигурации;
		
		ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства +
		                                                Фильтр1 + "&" + Фильтр2 + "&" + Фильтр3;
														
	КонецЕсли; 
													
	ПолеСсылкаИзмененияЗаконодательства = "Изменения законодательства";
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеРедакцияФормыПриИзменении(Элемент)
	
	СтрРедакцияФормы = ПолеРедакцияФормы;
	// Ищем в таблице мТаблицаФормОтчета для определения выбранной формы отчета.
	ЗаписьПоиска = Новый Структура;
	ЗаписьПоиска.Вставить("РедакцияФормы",СтрРедакцияФормы);
	МассивСтрок = мТаблицаФормОтчета.НайтиСтроки(ЗаписьПоиска);	
	
	Если МассивСтрок.Количество() > 0 Тогда
		
	    ВыбраннаяФорма = МассивСтрок[0];
		// Присваиваем.
	    мВыбраннаяФорма		= ВыбраннаяФорма.ФормаОтчета;
		ОписаниеНормативДок	= ВыбраннаяФорма.ОписаниеОтчета;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтчета(Команда)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		
		Возврат;
		
	КонецЕсли;
	
	Если мСкопированаФорма <> Неопределено Тогда
		
		Если мВыбраннаяФорма <> мСкопированаФорма Тогда
			
			ПоказатьПредупреждение(, НСтр("ru='Форма отчета изменилась, копирование невозможно!'"));
			
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1'"),
		РегламентированнаяОтчетностьКлиент.ОсновнаяФормаОрганизацияНеЗаполненаВывестиТекст());
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", мДатаНачалаПериодаОтчета);
	ПараметрыФормы.Вставить("мСохраненныйДок",          мСохраненныйДок);
	ПараметрыФормы.Вставить("мСкопированаФорма",        мСкопированаФорма);
	ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета",  мДатаКонцаПериодаОтчета);
	ПараметрыФормы.Вставить("мПериодичность",           мПериодичность);
	ПараметрыФормы.Вставить("Организация",              Организация);
	ПараметрыФормы.Вставить("мВыбраннаяФорма",          мВыбраннаяФорма);
	ПараметрыФормы.Вставить("ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417",
		РегламентированнаяОтчетностьКлиент.ДоступенМеханизмПечатиРеглОтчетностиСДвухмернымШтрихкодомPDF417());
	
	ОткрытьФорму(СтрЗаменить(ЭтаФорма.ИмяФормы, "ОсновнаяФорма", "") + мВыбраннаяФорма, ПараметрыФормы, , Истина);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПредыдущийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, -1);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСледующийПериод(Команда)
	
	ИзменитьПериод(ЭтаФорма, 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФорму(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФормуЗавершение", ЭтотОбъект);
	РегламентированнаяОтчетностьКлиент.ВыбратьФормуОтчетаИзДействующегоСписка(ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФормуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		мВыбраннаяФорма = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	СписокВыбора = СписокДоступныхЮридическихЛиц(Текст);
	
	Если СписокВыбора.Количество() > 0 И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора = СписокВыбора;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ДоступныеОрганизацииОтсутствуют Тогда
		
		ПоказатьПредупреждение(, ДоступныеОрганизацииОтсутствуютТекст());
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	Текст = ВРег(СокрЛП(Элементы.Организация.ТекстРедактирования));
	
	Если НЕ (ЗначениеЗаполнено(Текст) И ЗначениеЗаполнено(Организация)) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СписокДоступныхЮридическихЛиц(Знач Текст = Неопределено)
	
	СписокВыбора = Новый СписокЗначений;
	РегламентированнаяОтчетность.ПолучитьСписокДоступныхЮридическихЛиц(СписокВыбора, Текст);
	
	Возврат СписокВыбора;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДоступныеОрганизацииОтсутствуютТекст()
	
	Возврат НСтр(
	"ru='Декларацию по акцизам на нефтяное сырье представляют только организации (пп.34 п.1 ст.182 НК РФ).
	|В справочнике ""Организации"" сведения об организациях отсутствуют.'");
	
КонецФункции

&НаКлиенте
Процедура ПолеСсылкаИзмененияЗаконодательстваНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ОбщаяЧастьСсылкиНаИзмененияЗаконодательства = "" Тогда
	    // Нет общей части - ничего не делаем.
		Возврат;
	КонецЕсли; 
	
	// Фильтр4 - год.
	Фильтр4 = "currentYear=" + Формат(Год(мДатаКонцаПериодаОтчета),"ЧГ=0");
	
	// Фильтр5 - квартал.
	МесяцКонцаКварталаОтчета = Месяц(КонецКвартала(мДатаКонцаПериодаОтчета));
	КварталОтчета = МесяцКонцаКварталаОтчета/3;
	
	Фильтр5 = "currentQuartal=" + Строка(КварталОтчета);

	СсылкаИзмененияЗаконодательства = ОбщаяЧастьСсылкиНаИзмененияЗаконодательства + 
										"&" + Фильтр4 + "&" + Фильтр5;
										
	ОнлайнСервисыРегламентированнойОтчетностиКлиент.ПопытатьсяПерейтиПоНавигационнойСсылке(СсылкаИзмененияЗаконодательства);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметр = "Активизировать" Тогда
	
		Если ИмяСобытия = ЭтаФорма.Заголовок Тогда
		
			ЭтаФорма.Активизировать();
		
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти