&НаКлиенте
Перем СуммируемыеЯчейки;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СправкиРасчеты.ИнициализироватьФорму(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СправкиРасчетыКлиент.НачатьОжиданиеФормированияОтчетаПриОткрытии(ЭтотОбъект, ОповещениеЗавершитьФормированиеОтчета());
	// См. далее ЗавершитьФормированиеОтчета()
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СправкиРасчетыКлиент.ПередСохранениемНастроек(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтотОбъект, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	СправкиРасчеты.ПрименитьЗагруженныеПользовательскиеНастройки(ЭтотОбъект, Настройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СправкиРасчетыКлиент.НачатьВыборПериода(
		ЭтотОбъект,
		СтандартнаяОбработка,
		Новый ОписаниеОповещения("НастроитьПериод", ЭтотОбъект));
		
	// Может быть вызван НастроитьПериод() для контекстной передачи управления на сервер
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СправкиРасчетыКлиент.УстановитьТекущийПериод(
		ЭтотОбъект,
		СтандартнаяОбработка,
		Новый ОписаниеОповещения("НастроитьПериод", ЭтотОбъект));
		
	// Может быть вызван НастроитьПериод() для контекстной передачи управления на сервер
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПериод(ТребуетсяВызовСервера, ДополнительныеПараметры) Экспорт // обработчик оповещения
	
	НастроитьПериодНаСервере(ТребуетсяВызовСервера);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПериодНаСервере(Знач ТребуетсяВызовСервера)
	
	СправкиРасчеты.НастроитьПериод(ЭтотОбъект, ТребуетсяВызовСервера);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если СправкиРасчетыКлиентСервер.ОрганизацияВыбранаПовторно(Организация, ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	СправкиРасчеты.ОрганизацияПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

#Область СписокОтборы

// Важно: поле на форме должно иметь предопределенное имя "Отборы"

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтотОбъект, Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтотОбъект, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(
		ЭтотОбъект,
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка,
		ПараметрыВыбораЗначенияОтбора());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПоляТабличногоДокумента

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	БухгалтерскиеОтчетыКлиент.ОбработкаРасшифровкиСтандартногоОтчета(ЭтотОбъект, Элемент, Расшифровка, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	БухгалтерскиеОтчетыКлиент.НачатьРасчетСуммыВыделенныхЯчеек(
		Элементы.Результат,
		ЭтотОбъект,
		ИмяОбработчикаВыделенаОбластьЯчеек());
	
КонецПроцедуры

#Область РасчетСуммыВыделенныхЯчеек

&НаКлиенте
Функция ИмяОбработчикаВыделенаОбластьЯчеек()
	Возврат "Подключаемый_ВыделенаОбластьЯчеек";
КонецФункции

&НаКлиенте
Процедура Подключаемый_ВыделенаОбластьЯчеек()
	
	ТребуетсяВызовСервера = БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		СуммаВыделенныхЯчеек,
		Результат,
		Элементы.Результат,
		СуммируемыеЯчейки);

	Если ТребуетсяВызовСервера Тогда
		РассчитатьСуммуВыделенныхЯчеекНаСервере(СуммируемыеЯчейки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСуммуВыделенныхЯчеекНаСервере(Знач СуммируемыеЯчейки)
	
	СуммаВыделенныхЯчеек = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат,
		СуммируемыеЯчейки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область ФормированиеОтчета

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = НачатьФормированиеОтчета();
	
	СправкиРасчетыКлиент.НачатьОжиданиеФормированияОтчета(ЭтотОбъект, ДлительнаяОперация, ОповещениеЗавершитьФормированиеОтчета());
	
КонецПроцедуры

&НаСервере
Функция НачатьФормированиеОтчета()
	
	Возврат СправкиРасчеты.НачатьФормированиеОтчета(ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Функция ОповещениеЗавершитьФормированиеОтчета()
	
	Возврат Новый ОписаниеОповещения("ЗавершитьФормированиеОтчета", ЭтотОбъект);
	
КонецФункции

&НаКлиенте
// Обработчик оповещения, вызывается по окончании формирования отчета для контекстной передачи управления на сервер
Процедура ЗавершитьФормированиеОтчета(АдресРезультата, НеиспользуемыйПараметр) Экспорт // обработчик оповещения
	
	ЗавершитьФормированиеОтчетаНаСервере(АдресРезультата);
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьФормированиеОтчетаНаСервере(Знач АдресРезультата)
	
	СправкиРасчеты.ЗавершитьФормированиеОтчета(ЭтотОбъект, АдресРезультата);
	
КонецПроцедуры


#КонецОбласти

#Область Настройки

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	
	БухгалтерскиеОтчетыКлиентСервер.ПоказатьНастройки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьНастройки(Команда)
	
	БухгалтерскиеОтчетыКлиентСервер.СкрытьНастройки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область КешКодаБухгалтерскиеОтчеты

&НаКлиенте
Функция ПараметрыВыбораЗначенияОтбора()
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Дата");
	ПараметрыВыбора.Вставить("Номенклатура");
	ПараметрыВыбора.Вставить("Склад");
	ПараметрыВыбора.Вставить("Организация");
	ПараметрыВыбора.Вставить("Контрагент");
	ПараметрыВыбора.Вставить("ДоговорКонтрагента");
	
	ПараметрыВыбора.Дата        = КонецПериода;
	ПараметрыВыбора.Организация = Организация;
	
	Возврат ПараметрыВыбора;
	
КонецФункции

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Параметры");
	СписокПолей.Добавить("Ресурсы");
	СписокПолей.Добавить("Группировки");
	СписокПолей.Добавить("Организация");
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

#КонецОбласти
