#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.Организации");
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("ДоговорыКредитовИДепозитов") Тогда
			ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ДоговорыКредитовИДепозитов");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		//++ НЕ УТ
		ДоходыПоОбъектамЭксплуатации = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.ОбъектыЭксплуатации")));
		ДоходыПоНМАиНИОКР = (ТипЗначения.СодержитТип(Тип("СправочникСсылка.НематериальныеАктивы")));
		//-- НЕ УТ
		
		ДоговорыКредитовИДепозитов = ТипЗначения.СодержитТип(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"));
		
		Если Не ПустаяСтрока(КорреспондирующийСчет) Тогда
			Если ПустаяСтрока(СтрЗаменить(КорреспондирующийСчет, ".", "")) Тогда
				КорреспондирующийСчет = "";
			ИначеЕсли Прав(СокрЛП(КорреспондирующийСчет), 1) = "." Тогда
				КорреспондирующийСчет = Лев(СокрЛП(КорреспондирующийСчет), СтрДлина(СокрЛП(КорреспондирующийСчет)) - 1);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// В УТ не требуется
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если НЕ ЭтоГруппа И НЕ ПринятиеКналоговомуУчету Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидПрочихДоходовИРасходов"); 
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если Отказ ИЛИ ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет") Тогда
		ВидыСчетаДляОчистки = Новый Массив;
		Если ЗначениеЗаполнено(СчетУчета) Тогда
			ВидыСчетаДляОчистки.Добавить(Перечисления.ВидыСчетовРеглУчета.Доходы);
		КонецЕсли;
		Если ВидыСчетаДляОчистки.Количество() Тогда
			РегистрыСведений.СчетаРеглУчетаТребующиеНастройки.ОчиститьПриЗаписиАналитикиУчета(Ссылка, ВидыСчетаДляОчистки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТ

#КонецОбласти


#КонецЕсли