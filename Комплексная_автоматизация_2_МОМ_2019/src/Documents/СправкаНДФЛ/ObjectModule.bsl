#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ВнешниеДанные Экспорт;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.Увольнение") Тогда	
		СтрокаДанныеУвольнения = "Организация, ФизическоеЛицо, ДатаУвольнения";
		ДанныеУвольнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, СтрокаДанныеУвольнения);
		Организация = ДанныеУвольнения["Организация"];
		Сотрудник = ДанныеУвольнения["ФизическоеЛицо"];
		НалоговыйПериод = Год(ДанныеУвольнения["ДатаУвольнения"]);
		СпособФормирования = Перечисления.ПорядокФормированияСправкиОДоходахФизическогоЛица.Сводно;
		Дата = ?(ЗначениеЗаполнено(ДанныеУвольнения["ДатаУвольнения"]), КонецДня(ДанныеУвольнения["ДатаУвольнения"]) + 1, ТекущаяДатаСеанса());
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если СпособФормирования = Перечисления.ПорядокФормированияСправкиОДоходахФизическогоЛица.Сводно Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "РегистрацияВНалоговомОргане");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "КодИФНС");
	КонецЕсли;
	
	Если ВнешниеДанные = Истина Тогда
		Если Не ЗначениеЗаполнено(СпособФормирования) Тогда
			ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "СведенияОДоходах.МесяцНалоговогоПериода");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "НалоговыйПериод");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Организация");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "РегистрацияВНалоговомОргане");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "КодИФНС");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "СпособФормирования");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Дата");
		ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияЗначенияИзМассива(ПроверяемыеРеквизиты, "Номер");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт
	
	СоответствиеСтавокДоходов = УчетНДФЛ.СоответствиеДоходовСтавкам();
	
	Если ЗначениеЗаполнено(Организация) Тогда
		СтруктураДанныхНА = УчетНДФЛ.СправкиНДФЛДанныеНалоговогоАгента(Организация, НалоговыйПериод, РегистрацияВНалоговомОргане, Дата, Телефон, ДолжностьПодписавшегоЛица, СправкуПодписал);
		СтруктураДанныхНА.КодНалоговогоОргана = КодИФНС;
		УчетНДФЛ.СправкиНДФЛПроверитьДанныеНалоговогоАгента(ЭтотОбъект, СтруктураДанныхНА, СпособФормирования, Отказ);
	КонецЕсли;
	
	ПараметрыПроверкиДанныхФизическихЛиц = Документы.СправкаНДФЛ.ПараметрыПроверкиДанныхФизическихЛиц();
	ПараметрыПроверкиДанныхФизическихЛиц.Ссылка						= Ссылка;
	ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные 			= ПолучитьДанныеСотрудникДляПроверки();
	ПараметрыПроверкиДанныхФизическихЛиц.ДатаДокумента				= Дата;
	ПараметрыПроверкиДанныхФизическихЛиц.ПутьКДаннымФизическогоЛица = "";
	ПараметрыПроверкиДанныхФизическихЛиц.ПроверятьАдрес				= Не УчетНДФЛ.ВыводитьФорму2НДФЛ2018Года(НалоговыйПериод, Дата);
	
	Документы.СправкаНДФЛ.ПроверитьДанныеФизическогоЛица(ПараметрыПроверкиДанныхФизическихЛиц, Отказ);
	
	Доходы = СведенияОДоходах.Выгрузить();
	Вычеты = СведенияОВычетах.Выгрузить();
	Уведомления = УведомленияНОоПравеНаВычеты.Выгрузить();
	
	Сводно = (СпособФормирования = Перечисления.ПорядокФормированияСправкиОДоходахФизическогоЛица.Сводно);
	
	НачалоСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Справка 2-НДФЛ по %1:'"), ПараметрыПроверкиДанныхФизическихЛиц.ПроверяемыеДанные);
	
	УчетНДФЛ.СправкиНДФЛПроверитьДанныеОДоходахНалогахВычетах(
		Ссылка,
		Дата,
		ЭтотОбъект,
		"",
		Доходы,
		Вычеты,
		СоответствиеСтавокДоходов,
		НачалоСообщенияОбОшибке,
		Отказ,
		Сводно,,,
		Уведомления);
	
КонецПроцедуры

Функция ПолучитьДанныеСотрудникДляПроверки()
	ДанныеСотрудника = Новый Структура("Сотрудник, ИНН, Фамилия, Имя, Отчество, Адрес, ВидДокумента, СерияДокумента, НомерДокумента,
									   |Гражданство, ДатаРождения, СтатусНалогоплательщика, АдресЗарубежом, СотрудникНаименование");
									   
	ЗаполнитьЗначенияСвойств(ДанныеСотрудника, ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ДанныеСотрудника.Сотрудник) Тогда
		ДанныеСотрудника.СотрудникНаименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеСотрудника.Сотрудник, "Наименование");
	Иначе
		ДанныеСотрудника.СотрудникНаименование = "";
	КонецЕсли;	
	
	Возврат ДанныеСотрудника;
КонецФункции	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли