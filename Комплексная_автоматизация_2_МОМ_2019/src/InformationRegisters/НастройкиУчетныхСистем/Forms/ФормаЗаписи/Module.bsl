
#Область ОбработчикиСобытийФормы
    
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
    ПолеУчетнаяСистема = "УчетнаяСистема";
    
    Если Параметры.Свойство(ПолеУчетнаяСистема) И ЗначениеЗаполнено(Параметры[ПолеУчетнаяСистема]) Тогда
        УчетнаяСистема = Параметры[ПолеУчетнаяСистема];
        Элементы.УчетнаяСистема.Видимость = Ложь;
        КоманднаяПанель.Видимость = Ложь;
        АвтоЗаголовок = Ложь;
        Заголовок = ИнтеграцияОбъектовОбластейДанныхСловарь.Настройки(); 
    КонецЕсли; 
    
    Если ЗначениеЗаполнено(Запись.УчетнаяСистема) Тогда
        УстановитьПривилегированныйРежим(Истина);
        КлючПодписи = Строка(ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "КлючПодписи"));
        Пароль = Строка(ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "Пароль"));
        ДанныеСертификата = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ДанныеСертификата"); 
        АдресДанныхСертификата = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
        ПарольСертификата = Строка(ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ПарольСертификата"));
        УстановитьПривилегированныйРежим(Ложь);
    КонецЕсли; 
    
    ЗапрашиватьЛогинПароль = Запись.СпособАутентификации = Перечисления.СпособыАутентификации.ОбычнаяПроверка;
    Элементы.ГруппаСпособАутентификации.Доступность = ЗапрашиватьЛогинПароль;
    Элементы.ИмяСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.ПарольСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.КлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    Элементы.ПоказатьКлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
    
    УстановитьПривилегированныйРежим(Истина);
    ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, КлючПодписи, "КлючПодписи");
    Если ЗначениеЗаполнено(АдресДанныхСертификата) Тогда
        ДанныеСертификата = ПолучитьИзВременногоХранилища(АдресДанныхСертификата);
        Если ДанныеСертификата <> Неопределено Тогда
            ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, ДанныеСертификата, "ДанныеСертификата");
        КонецЕсли; 
    КонецЕсли;
    Если ПарольИзменен Тогда
        ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, Пароль, "Пароль");
    КонецЕсли; 
    Если ПарольСертификатаИзменен Тогда
        ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Запись.УчетнаяСистема, ПарольСертификата, "ПарольСертификата");
    КонецЕсли; 
    
    ПарольСертификатаИзменен = Ложь;
    ПарольИзменен = Ложь;
    
    УстановитьПривилегированныйРежим(Ложь);
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы
    
&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры
 
&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
    
    ПарольИзменен = Истина;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура СпособАутентификацииПриИзменении(Элемент)
    
    ЗапрашиватьЛогинПароль = Запись.СпособАутентификации = ПредопределенноеЗначение("Перечисление.СпособыАутентификации.ОбычнаяПроверка");
    Элементы.ГруппаСпособАутентификации.Доступность = ЗапрашиватьЛогинПароль;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСертификатПриИзменении(Элемент)
    
    Элементы.ИмяСертификата.Доступность = Запись.ИспользоватьСертификат;
    Элементы.ПарольСертификата.Доступность = Запись.ИспользоватьСертификат;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ПомещениеСертификатаКлиентаЗавершение", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение, , , Истина, УникальныйИдентификатор);
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ПустаяСтрока(Запись.ИмяСертификата) Тогда
		
		Адрес = ?(СертификатКлиентаИзменен, АдресДанныхСертификата, ПоместитьСертификатКлиентаВоВременноеХранилище());
		ПолучитьФайл(Адрес, Запись.ИмяСертификата, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодписыватьДанныеПриИзменении(Элемент)
    
    Элементы.КлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    Элементы.ПоказатьКлючПодписиЗакрыто.Доступность = Запись.ПодписыватьДанные;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ОповещатьСервисОбИзмененияхПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура АдресСервисаПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ИмяСертификатаПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ПарольСертификатаПриИзменении(Элемент)
    
    ПарольСертификатаИзменен = Истина;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура КлючПодписиПриИзменении(Элемент)
    
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура АдресСервисаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    
    Запись.АдресСервиса = Текст;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ЛогинОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    
    Запись.Логин = Текст;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ПарольОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

    ПарольИзменен = Истина;
    Пароль = Текст;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура ПарольСертификатаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    
    ПарольСертификатаИзменен = Истина;
    ПарольСертификата = Текст;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаКлиенте
Процедура КлючПодписиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
    
    КлючПодписи = Текст;
    ПриИзмененииРеквизита();
    
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКомандФормы
    
&НаКлиенте
Процедура ПоказатьКлючПодписи(Команда)
    
    Если Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаЗакрыто Тогда
        Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаОткрыто;    
    Иначе
        Элементы.СтраницыКлючЗаписи.ТекущаяСтраница = Элементы.СтраницаЗакрыто;
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПомещениеСертификатаКлиентаЗавершение(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Не Результат Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	АдресДанныхСертификата = Адрес;
	ЧастиИмени = СтрРазделить(ВыбранноеИмяФайла, ПолучитьРазделительПути(), Ложь);
	Запись.ИмяСертификата = ЧастиИмени[ЧастиИмени.ВГраница()];
	СертификатКлиентаИзменен = Истина;
	ПриИзмененииРеквизита();
    
КонецПроцедуры

&НаСервере
Функция ПоместитьСертификатКлиентаВоВременноеХранилище()
    
    УстановитьПривилегированныйРежим(Истина);
    ДанныеСертификата = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Запись.УчетнаяСистема, "ДанныеСертификата");
    УстановитьПривилегированныйРежим(Ложь);
	Адрес = ПоместитьВоВременноеХранилище(ДанныеСертификата, УникальныйИдентификатор);
	
	Возврат Адрес;
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииРеквизита()
	
    Если ЗначениеЗаполнено(Запись.УчетнаяСистема) И Запись.УчетнаяСистема = УчетнаяСистема Тогда
        Записать();
    КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти 