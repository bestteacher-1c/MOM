

#Область ОписаниеПеременных

&НаСервере
Перем ОбъектЭтогоОтчета; // Объект метаданных отчета, из которого открыта форма записи.

&НаКлиенте
Перем УправляемаяФормаВладелец; // Форма отчета, из которого открыта форма записи.

&НаКлиенте
Перем УникальностьФормы; // Уникальный идентификатор формы отчета.


// Форма выбора из списка, ввода пары значений, форма длительной операции, 
// записи регистра, ввода данных по ОП и т.д.
// Любая открытая из данной формы форма в режиме блокировки владельца.
&НаКлиенте
Перем ОткрытаяФормаПотомокСБлокировкойВладельца Экспорт;

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекстПредупреждения = НСтр("ru='Данная форма предназначена для редактирования данных из форм регламентированных отчетов.
										|
										|Открытие данной формы не из формы регламентированного отчета не предусмотрено!'");
	
	// Ищем управляемую форму, откуда открыли.
	Если ВладелецФормы = Неопределено Тогда
		
	    Отказ = Истина;		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
				
	ТекущийРодитель = ВладелецФормы;
	 
	Пока НЕ РегламентированнаяОтчетностьАЛКОКлиентСервер.ЭтоУправляемаяФормаИлиФормаКлиентскогоПриложения(ТекущийРодитель) Цикл
	    ТекущийРодитель = ТекущийРодитель.Родитель;		
	КонецЦикла;
	
	УправляемаяФормаВладелец = ТекущийРодитель;
		
	ИмяФормыВладельца 	= УправляемаяФормаВладелец.ИмяФормы;
		
	Если СтрНайти(ИмяФормыВладельца, "РегламентированныйОтчетАлко") = 0 Тогда
	
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	
	КонецЕсли;
	
	УникальностьФормы   = УправляемаяФормаВладелец.УникальностьФормы;
	Оповестить("ОткрытаФормаЗаписиРегистра", ЭтаФорма, УникальностьФормы);
		
	ТекущееСостояниеВладельца = УправляемаяФормаВладелец.ТекущееСостояние;
	
    ДокументЗаписи = 		УправляемаяФормаВладелец.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИндексСтраницыЗаписи = 	УправляемаяФормаВладелец.ИндексАктивнойСтраницыВРегистре;
	ИндексСтраницы = 		УправляемаяФормаВладелец.НомерАктивнойСтраницыМногострочногоРаздела;
	НомерПоследнейЗаписи = 	УправляемаяФормаВладелец.КоличествоСтрок;
	МаксИндексСтраницы = 	УправляемаяФормаВладелец.МаксИндексСтраницы;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
				
		// Заполним измерения, их нет на форме.
	    Запись.Активно = Истина;
		
		Запись.Документ = ДокументЗаписи;
				
		НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
	    Запись.ИндексСтроки = НомерПоследнейЗаписи;
		
		Модифицированность = Истина;
		
	КонецЕсли;
		
	Заголовок = "Адрес места осуществления деятельности";
	
	ЭтоПБОЮЛ = УправляемаяФормаВладелец.ЭтоПБОЮЛ;
	ПодготовкаНаСервере();
	
	Если (ВладелецФормы.ТекущийЭлемент <> Неопределено) 
		и НЕ (ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование")
		Тогда
		
		ИмяАктивногоПоля = ВладелецФормы.ТекущийЭлемент.Имя;
		
	    АктивноеПоле = Элементы.Найти(ИмяАктивногоПоля);
		Если НЕ АктивноеПоле = Неопределено Тогда
			
			Если ИмяАктивногоПоля = "П000000000201" Тогда
			    ТекущийЭлемент = АктивноеПоле;
			КонецЕсли; 
		
		КонецЕсли;
	
	КонецЕсли;
				
КонецПроцедуры


&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Оповестить("ЗакрытаФормаЗаписиРегистра", , УникальностьФормы);
	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповещаем о необходимости пересчета итогов форму-владелец для активных записей.
	Если ВнесеныИзменения и Запись.Активно Тогда
	    		
		// Оповещаем форму-владелец о изменениях.
		ИнформацияДляПересчетаИтогов = Новый Структура;
		ИнформацияДляПересчетаИтогов.Вставить("ИмяРегистра", 		ИмяРегистра);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтраницы", 	ИндексСтраницы);
		ИнформацияДляПересчетаИтогов.Вставить("ИндексСтроки", 		Запись.ИндексСтроки);
		ИнформацияДляПересчетаИтогов.Вставить("НачальноеЗначение", 	НачальноеЗначениеСтруктураДанных);
		ИнформацияДляПересчетаИтогов.Вставить("КонечноеЗначение", 	КонечноеЗначениеСтруктураДанных);
		
		Оповестить("ПересчетИтогов", ИнформацияДляПересчетаИтогов, УникальностьФормы);
	
	КонецЕсли;
	
	ВнесеныИзменения = Ложь;
			
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЦветСтиляНезаполненныйРеквизит 	= ЦветаСтиля["ЦветНезаполненныйРеквизитБРО"];
	ЦветСтиляЦветГиперссылкиБРО		= ЦветаСтиля["ЦветГиперссылкиБРО"];
	
	ЗаполнитьАдресПредставлениеНаСервере();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
				
	ВнесеныИзменения = Модифицированность;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		// Обработка ситуаций "битых" внутренних данных отчета, когда из отчета пришло неверное значение последней строки.
		// Теперь всегда перед записью проверяем последний индекс строки в регистре.
		
		СписокСоставаРегистра = Новый СписокЗначений;
		СписокСоставаРегистра.Добавить("Измерения");
		СтруктураИзмерений = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(
																		ИмяРегистра, СписокСоставаРегистра);
	
		Пока РегламентированнаяОтчетностьАЛКО.СуществуетЗапись(Запись, ИмяРегистра, СтруктураИзмерений) Цикл
			
			НомерПоследнейЗаписи = НомерПоследнейЗаписи + 1;
			Запись.ИндексСтроки = НомерПоследнейЗаписи;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоПервоеРедактирование = Ложь;
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "ДобавлениеСтроки");
		
	ИначеЕсли ВнесеныИзменения Тогда
		
		// Нужно записать первоначальные данные Записи регистра в журнал.
		// Но сделать это надо только для случая первого изменения Записи после последнего сохранения отчета,
		// чтобы была информация о данных до изменения в случае отката внесенных изменений, если
		// отказался пользователь от сохранения отчета.
		
		ЭтоПервоеРедактирование = РегламентированнаяОтчетностьАЛКО.ЭтоПервоеРедактированиеЗаписиРегистра(ТекущийОбъект.Документ, ИмяРегистра, 
															ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки);
				
	КонецЕсли;
	
	Если ЭтоПервоеРедактирование Тогда
		
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("НачальноеЗначение", НачальноеЗначение);
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		// Нужно сохранить первоначальные данные.
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, ТекущийОбъект.ИндексСтроки, "Редактирование", Ресурсы);
	Иначе
									
		Ресурсы = Новый Структура;
		Ресурсы.Вставить("КоличествоСтрок", НомерПоследнейЗаписи);		
		Ресурсы.Вставить("МаксИндексСтраницы", МаксИндексСтраницы);
		
		РегламентированнаяОтчетностьАЛКО.ДобавитьВРегистрЖурнала(ТекущийОбъект.Документ, ИмяРегистра,
									ИндексСтраницыЗаписи, 0, "Сервис", Ресурсы);							
	КонецЕсли;
	
	Если ВнесеныИзменения Тогда
		РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
											Запись, ИмяРегистра, КонечноеЗначениеСтруктураДанных);
	КонецЕсли;
										
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
    	МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
     	МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = УникальностьФормы Тогда
		
		Если НРег(ИмяСобытия) = НРег("ЗакрытьОткрытыеФормыЗаписи") Тогда			
		    Модифицированность = Ложь;
			Закрыть();			
		КонецЕсли;
					
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
		
КонецПроцедуры


&НаКлиенте
Процедура П000000000201ПриИзменении(Элемент)
	ОбработкаПослеИзменения();
КонецПроцедуры


&НаКлиенте
Процедура П000000000202Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры


&НаКлиенте
Процедура П000000000203Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры


&НаКлиенте
Процедура П000000000204Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры


&НаКлиенте
Процедура П000000000205Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры


&НаКлиенте
Процедура П000000000206Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры


&НаКлиенте
Процедура П000000000207Нажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВводАдресаНаКлиенте();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьИЗакрыть(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если НЕ Модифицированность Тогда
	    Закрыть();
	Иначе	
	    Записать();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура РедактироватьАдрес(Команда)
	ВводАдресаНаКлиенте();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьАдресПредставлениеНаСервере()

	АдресПредставление = ?(ЗначениеЗаполнено(Запись.П0000000Адрес), Запись.П0000000Адрес, "Заполнить");
	АдресXML = Запись.П0000000VNUTR;
	
	Если (АдресПредставление = "Заполнить") Тогда
		
		// Попытаемся заполнить по имеющимся данным.
		
		// Заполняем шаблон.
		АдресМестаДеятельности = РегламентированнаяОтчетностьАЛКО.СтруктураАдресаИзСтрокиСтруктурыХранения(АдресXML);
		Представление = АдресМестаДеятельности.ПредставлениеАдреса;
		
		Если ЗначениеЗаполнено(СтрЗаменить(Представление, ",", "")) Тогда
			
			РегламентированнаяОтчетностьАЛКОКлиентСервер.ЗаполнитьЗаписьРегистраЛицензийИзСтруктурыАдреса(
																		Запись, АдресМестаДеятельности);
			АдресПредставление = Представление;
		    Модифицированность = Истина;
				
		КонецЕсли; 
				
	КонецЕсли;
	
	Элементы.АдресПредставление.ЦветТекста = ?(АдресПредставление = "Заполнить", 
												ЦветСтиляНезаполненныйРеквизит, ЦветСтиляЦветГиперссылкиБРО); 
	
КонецПроцедуры


&НаСервере
Процедура ПодготовкаНаСервере()
	
	ДоступностьПолейНаСервере();	
	ЗаполнитьАдресПредставлениеНаСервере();
		
	// Заполним начальное значение всех полей записи во внутреннем формате.
	ИмяРегистра = РегламентированнаяОтчетностьАЛКО.ПолучитьИмяОбъектаМетаданныхПоИмениФормы(ИмяФормы);
	
	Если ТекущееСостояниеВладельца = "Добавление" или ТекущееСостояниеВладельца = "Копирование" Тогда
		
		Запись.ИДДокИндСтраницы = РегламентированнаяОтчетностьАЛКО.ПолучитьИдДокИндСтраницы(Запись.Документ, ИндексСтраницыЗаписи);
		Запись.Организация = Запись.Документ.Организация;
		
		// Начальные данные в этих случаях всегда пустые.
		НачальноеЗначениеСтруктураДанных = РегламентированнаяОтчетностьАЛКО.ПолучитьСтруктуруДанныхЗаписиРегистраСведений(ИмяРегистра);
		НачальноеЗначение = ЗначениеВСтрокуВнутр(НачальноеЗначениеСтруктураДанных);
		
	Иначе
		НачальноеЗначение = РегламентированнаяОтчетностьАЛКО.ПолучитьВнутреннееПредставлениеСтруктурыДанныхЗаписи(
															Запись, ИмяРегистра, НачальноеЗначениеСтруктураДанных);
	КонецЕсли;	
		
КонецПроцедуры


&НаСервере
Процедура ДоступностьПолейНаСервере()
	
	Элементы.П000000000201.Видимость = НЕ ЭтоПБОЮЛ;
	Запись.П000000000201 = ?(ЭтоПБОЮЛ, "", Запись.П000000000201);
	
КонецПроцедуры


&НаСервере
Функция ОбъектОтчета(ИмяФормыОбъекта)
	
	Возврат РегламентированнаяОтчетностьАЛКО.ОбъектОтчетаАЛКО(ИмяФормыОбъекта, ОбъектЭтогоОтчета);
	
КонецФункции


&НаСервере
Процедура ОбработкаПослеИзменения()
	
	ОбъектОтчета(ИмяФормыВладельца).ОбработкаЗаписи(ИмяРегистра, Запись);	 
	Модифицированность = РегламентированнаяОтчетностьАЛКО.ЗаписьИзменилась(Запись, НачальноеЗначениеСтруктураДанных);
	
КонецПроцедуры


&НаКлиенте
Процедура ВводАдресаНаКлиенте()
	
	СтандартнаяОбработка = Ложь;
	
	ЗаголовокФормыВвода = "Ввод адреса";
	ВидКонтактнойИнформации = УправляемаяФормаВладелец.СтруктураРеквизитовФормы.СправочникиВидыКонтактнойИнформации.ТолькоНациональныйАдрес;
		
	Оповещение = Новый ОписаниеОповещения("ВводАдресаЗавершениеНаКлиенте", ЭтаФорма);
	
	РегламентированнаяОтчетностьАЛКОКлиент.ВызватьФормуВводаАдресаКонтрагента(
					Запись.П0000000VNUTR, ЗаголовокФормыВвода, Оповещение, ВидКонтактнойИнформации);
		
КонецПроцедуры


&НаКлиенте
Процедура ВводАдресаЗавершениеНаКлиенте(Результат, Параметры) Экспорт

	Если НЕ (ТипЗнч(Результат) = Тип("Структура")) Тогда
		Возврат;	
	КонецЕсли;
	
	СтруктураАдреса = Неопределено;
	РегламентированнаяОтчетностьАЛКОКлиент.ВводАдресаКонтрагентаЗавершениеНаКлиенте(Результат, 
				Запись.П0000000Адрес, Запись.П0000000VNUTR, Модифицированность, СтруктураАдреса);
				
	РегламентированнаяОтчетностьАЛКОКлиентСервер.ЗаполнитьЗаписьРегистраЛицензийИзСтруктурыАдреса(
																		Запись, СтруктураАдреса);
				
	ЗаполнитьАдресПредставлениеНаСервере();
	ОбработкаПослеИзменения();
	
КонецПроцедуры 

#КонецОбласти
