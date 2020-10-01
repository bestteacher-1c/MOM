
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Значение", ВыбираемыйПериод);
	Если НЕ ЗначениеЗаполнено(ВыбираемыйПериод) Тогда
		ВыбираемыйПериод = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ЗапрашиватьРежимВыбораПериодаУВладельца", ЗапрашиватьРежимВыбораПериодаУВладельца) Тогда
		ЗапрашиватьРежимВыбораПериодаУВладельца = Ложь;
	КонецЕсли;
	
	УстановитьРежимВыбораПериода(ЭтаФорма, Параметры.РежимВыбораПериода);
	
	ЦветФонаКнопкиВыбранногоПериода = ЦветаСтиля.ФонПомеченнойКнопкиЦвет;
	ЦветФонаКнопки = ЦветаСтиля.ЦветФонаКнопки;
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьОтображение();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбираемыйПериодПриИзменении(Элемент)
	
	ИзменилсяГод = Истина;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаМесяц01(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 1);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц02(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 2);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц03(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 3);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц04(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 4);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц05(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 5);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц06(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 6);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц07(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 7);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц08(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 8);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц09(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 9);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц10(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 10);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц11(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 11);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаМесяц12(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 12);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаКвартал1(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 1);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаКвартал2(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 4);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаКвартал3(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 7);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаКвартал4(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 10);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПолугодие1(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 1);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПолугодие2(Команда)
	УстановитьВыбираемыйПериод(Год(ВыбираемыйПериод), 7);
	ОтмеченныйПериод = ВыбираемыйПериод;
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыбрать(Команда)
	ВыполнитьВыбор();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаПролистатьГодВМинус(Команда)
	
	ВыбираемыйГод = Год(ВыбираемыйПериод) - 1;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(ВыбираемыйГод, Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПролистатьГодВПлюс(Команда)
	
	ВыбираемыйГод = Год(ВыбираемыйПериод) + 1;
	ОтмеченныйПериод = Неопределено;
	УстановитьВыбираемыйПериод(ВыбираемыйГод, Месяц(ВыбираемыйПериод));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроверитьРежимВыбораПериода()
	
	Если ЗапрашиватьРежимВыбораПериодаУВладельца Тогда
		УстановитьРежимВыбораПериода(ЭтаФорма, ВладелецФормы.РежимВыбораПериода(ВыбираемыйПериод));
	КонецЕсли;
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРежимВыбораПериода(Форма, Знач РежимВыбора)
	
	Если НЕ ЗначениеЗаполнено(РежимВыбора) Тогда
		РежимВыбора = "Месяц";
	КонецЕсли; 
	
	Если Форма.РежимВыбораПериода = ВРег(РежимВыбора) Тогда
		Возврат;
	КонецЕсли; 
	
	Форма.РежимВыбораПериода = ВРег(РежимВыбора);
	
	ГруппаМесяцыВидимость = Ложь;
	ГруппаКварталыВидимость = Ложь;
	ГруппаПолугодияВидимость = Ложь;
		
	Если Форма.РежимВыбораПериода = "МЕСЯЦ" Тогда
		
		ГруппаМесяцыВидимость = Истина;
		Форма.ВыбираемыйПериод = НачалоМесяца(Форма.ВыбираемыйПериод);
		
	ИначеЕсли Форма.РежимВыбораПериода = "КВАРТАЛ" Тогда
		
		ГруппаКварталыВидимость = Истина;
		НомерКвартала = Цел((Месяц(Форма.ВыбираемыйПериод) - 1) / 3 + 1);
		Форма.ВыбираемыйПериод = Дата(Год(Форма.ВыбираемыйПериод), (НомерКвартала - 1) * 3 + 1, 1);
		
	ИначеЕсли Форма.РежимВыбораПериода = "ПОЛУГОДИЕ" Тогда
		
		ГруппаПолугодияВидимость = Истина;
		Форма.ВыбираемыйПериод = Дата(Год(Форма.ВыбираемыйПериод), ?(Месяц(Форма.ВыбираемыйПериод) < 7, 1, 7), 1);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаМесяцы",
		"Видимость",
		ГруппаМесяцыВидимость);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаКварталы",
		"Видимость",
		ГруппаКварталыВидимость);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаПолугодия",
		"Видимость",
		ГруппаПолугодияВидимость);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтображение()
	
	ПроверитьРежимВыбораПериода();
	
	Если РежимВыбораПериода = "МЕСЯЦ" Тогда
		
		Для НомерМесяца = 1 По 12 Цикл
			
			КнопкаМесяца = Элементы["КомандаМесяц" + Формат(НомерМесяца, "ЧЦ=2; ЧВН=")];
			Если НомерМесяца = Месяц(ВыбираемыйПериод) Тогда
				
				Если КнопкаМесяца.ЦветФона <> ЦветФонаКнопкиВыбранногоПериода Тогда
					КнопкаМесяца.ЦветФона = ЦветФонаКнопкиВыбранногоПериода;
				КонецЕсли;
				ЭтаФорма.ТекущийЭлемент = КнопкаМесяца;
				
			Иначе
				
				Если КнопкаМесяца.ЦветФона <> ЦветФонаКнопки Тогда
					КнопкаМесяца.ЦветФона = ЦветФонаКнопки;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПериодСтрокой = Формат(ВыбираемыйПериод, "ДФ='ММММ гггг'")
		
	ИначеЕсли РежимВыбораПериода = "КВАРТАЛ" Тогда
		
		КварталМесяца = (Месяц(ВыбираемыйПериод) - 1) / 3 + 1;
		Для НомерКвартала = 1 По 4 Цикл
			
			КнопкаКвартала = Элементы["КомандаКвартал" + Формат(НомерКвартала, "ЧЦ=1")];
			Если НомерКвартала = КварталМесяца Тогда
				
				Если КнопкаКвартала.ЦветФона <> ЦветФонаКнопкиВыбранногоПериода Тогда
					КнопкаКвартала.ЦветФона = ЦветФонаКнопкиВыбранногоПериода;
				КонецЕсли;
				
				ЭтаФорма.ТекущийЭлемент = КнопкаКвартала;
				
			Иначе
				
				Если КнопкаКвартала.ЦветФона <> ЦветФонаКнопки Тогда
					КнопкаКвартала.ЦветФона = ЦветФонаКнопки;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПериодСтрокой = Формат(КварталМесяца, "ЧЦ=1") + " квартал " + Формат(ВыбираемыйПериод,"ДФ=гггг");
		
	Иначе
		
		Если Месяц(ВыбираемыйПериод) = 1 Тогда
			Элементы.КомандаПолугодие1.ЦветФона = ЦветФонаКнопкиВыбранногоПериода;
			Элементы.КомандаПолугодие2.ЦветФона = ЦветФонаКнопки;
			ПериодСтрокой = "1 полугодие " + Формат(ВыбираемыйПериод,"ДФ=гггг");
		Иначе
			Элементы.КомандаПолугодие1.ЦветФона = ЦветФонаКнопки;
			Элементы.КомандаПолугодие2.ЦветФона = ЦветФонаКнопкиВыбранногоПериода;
			ПериодСтрокой = "2 полугодие " + Формат(ВыбираемыйПериод,"ДФ=гггг");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВыбираемыйПериод(Год, Месяц)
	
	Если ОтмеченныйПериод = Дата(Год, Месяц, 1) И НЕ ИзменилсяГод Тогда
		ВыполнитьВыбор();
	КонецЕсли; 
	
	Если Год < 1 Тогда
		Год = 1;
	КонецЕсли; 
	
	ИзменилсяГод = Ложь;
	ВыбираемыйПериод = Дата(Год, Месяц, 1);
	
	ОбновитьОтображение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВыбор()
	Закрыть(ВыбираемыйПериод);
КонецПроцедуры

#КонецОбласти
