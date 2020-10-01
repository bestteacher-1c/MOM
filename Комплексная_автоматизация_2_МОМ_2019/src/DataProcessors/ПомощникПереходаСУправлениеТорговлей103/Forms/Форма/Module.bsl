#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоУправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	
	Если Параметры.Свойство("ПутьКФайлуЗагрузки") И ЗначениеЗаполнено(Параметры.ПутьКФайлуЗагрузки) Тогда
		Объект.ИмяФайлаОбмена = Параметры.ПутьКФайлуЗагрузки;
	КонецЕсли;
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru='Обработка не предназначена для работы в режиме веб-клиента'"));
	КонецЕсли;
	
	Если НЕ ЭтоУправлениеТорговлей Тогда
		ПоказатьОповещениеПользователя(НСтр("ru='Помощник работает только в УТ'"));
		Закрыть();
	КонецЕсли;
	
	СтатусВыполненнойЗагрузки = Ложь;
	// Устанавливаем текущую таблицу переходов
	ТаблицаПереходовПоСценарию();
	// Позиционируемся на первом шаге помощника
	УстановитьПорядковыйНомерПерехода(1);
	
	Если НЕ ЭтоБазовая Тогда
		ИзменитьПорядковыйНомерПерехода(+2);
		Элементы.КомандаНазад.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ИмяФайлаОбмена) Тогда
		
		ИзменитьПорядковыйНомерПерехода(+3);
		
		Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
			
			ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПоместитьВХранилищеФайлСоСпискомБаз(УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейс();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаОбменаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Заголовок", НСтр("ru = 'Выберите путь к файлу выгрузки данных из УТ 10.3'"));
	ПараметрыДиалога.Вставить("Фильтр", "Файл выгрузки (*.xml)|*.xml");
	ПараметрыДиалога.Вставить("МножественныйВыбор", Ложь);

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект",           Объект);
	ДополнительныеПараметры.Вставить("ИмяСвойства",      "ИмяФайлаОбмена");
	ДополнительныеПараметры.Вставить("ПараметрыДиалога", ПараметрыДиалога);
	
	Оповещение = Новый ОписаниеОповещения("ОбработчикВыбораФайлаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстПредупреждения = НСтр("ru = 'Для данной операции необходимо установить расширение для веб-клиента 1С:Предприятие.'");
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредупреждения, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораФайлаЗавершение(Знач Результат, Знач ДополнительныеПараметры) Экспорт

	Если НЕ Результат = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСвойства = ДополнительныеПараметры.ИмяСвойства;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ЗаполнитьЗначенияСвойств(Диалог, ДополнительныеПараметры.ПараметрыДиалога);
	
	Диалог.ПолноеИмяФайла = Объект[ИмяСвойства];
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьФайлЗавершениеОтображенияДиалогаВыбораФайла", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлЗавершениеОтображенияДиалогаВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяСвойства = ДополнительныеПараметры.ИмяСвойства;
	Объект[ИмяСвойства] = ВыбранныеФайлы[0];

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалееВыборИБ(Команда)
	
	ОбработкаВыбораИБИзСписка(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазадВыборИБ(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазадНачало(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-2);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияКомандаДалее()
	
	КомандаДалее(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЗагрузкаИБНажатие(Элемент)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЗагрузкаФайлНажатие(Элемент)
	
	ИзменитьПорядковыйНомерПерехода(+2);
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИБВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораИБИзСписка(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокИБПриАктивизацииСтроки(Элемент)
	
	Элементы.КомандаДалееВыборИБ.Доступность = Не Элемент.ТекущиеДанные.Folder;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияПереходовПомощника

&НаКлиенте
Процедура ОбработкаВыбораИБИзСписка(Знач Оповещение)
	
	ПутьКОбработкеСПравилами = Неопределено;
	
	ПолучитьФайлыОбновления(Новый ОписаниеОповещения("ОбработкаВыбораИБИзСпискаЗавершение", ЭтотОбъект, Новый Структура("Оповещение", Оповещение)));

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораИБИзСпискаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Оповещение = ДополнительныеПараметры.Оповещение;
	
	Если НЕ ЗначениеЗаполнено(Результат) Тогда
		ВыполнитьОбработкуОповещения(Оповещение);
		Возврат;
	КонецЕсли;
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Результат);
	ПутьКОбработкеСПравилами = "";
	#Если Не ВебКлиент Тогда
	ПутьКОбработкеСПравилами = ПолучитьИмяВременногоФайла("epf");
	#КонецЕсли
	ДвоичныеДанные.Записать(ПутьКОбработкеСПравилами);
	
	ВыбраннаяСтрока = Элементы.СписокИБ.ТекущиеДанные;
	
	Если ВыбраннаяСтрока = Неопределено ИЛИ ВыбраннаяСтрока.Folder Тогда
		ВыполнитьОбработкуОповещения(Оповещение);
		Возврат;
	КонецЕсли;
	
	ПутьКПлатформе = "";
	#Если Не ВебКлиент Тогда
		Объект.ИмяФайлаОбмена = ПолучитьИмяВременногоФайла("xml");
		ПутьКПлатформе = КаталогПрограммы();
	#КонецЕсли
	
	СтрокаКоманды = """%ПутьКПлатформе%1cv8"" ENTERPRISE /IBConnectionString ""%СтрокаСоединенияИБ%"" /Execute ""%ПутьКОбработкеСПравилами%"" /C ""Trade103Data=""""%ПутьКФайлуВыгрузки%"""" Trade103StartUnloading=""""True""""""";
	СтрокаСоединенияИБ = СтрЗаменить(ВыбраннаяСтрока.СтрокаСоединения + ";", "=""", "=""""");
	СтрокаСоединенияИБ = СтрЗаменить(СтрокаСоединенияИБ, """;", """""");
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКПлатформе%", ПутьКПлатформе);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%СтрокаСоединенияИБ%", СтрокаСоединенияИБ);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКФайлуВыгрузки%", Объект.ИмяФайлаОбмена);
	СтрокаКоманды = СтрЗаменить(СтрокаКоманды, "%ПутьКОбработкеСПравилами%", ПутьКОбработкеСПравилами);
	
	ДопПараметрыЗапуска = Новый Структура("Оповещение, ПутьКОбработкеСПравилами");
	ДопПараметрыЗапуска.Оповещение               = Оповещение;
	ДопПараметрыЗапуска.ПутьКОбработкеСПравилами = ПутьКОбработкеСПравилами;
	
	Оповещение = Новый ОписаниеОповещения("ОбработкаЗапускаПриложенияЗавершение", ЭтотОбъект, ДопПараметрыЗапуска);
	
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("ТекущийКаталог", ПутьКПлатформе);
	ПараметрыЗапуска.Вставить("Оповещение", Оповещение);
	
	ФайловаяСистемаКлиент.ЗапуститьПрограмму(СтрокаКоманды, ПараметрыЗапуска);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗапускаПриложенияЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт
	
	Если КодВозврата = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение);
		Возврат;
	КонецЕсли;
	
	ИзменитьПорядковыйНомерПерехода(+2);
	
	Если Элементы.ПанельОсновная.ТекущаяСтраница = Элементы.СтраницаОжидания Тогда
		
		ПодключитьОбработчикОжидания("ОбработчикОжиданияКомандаДалее", 0.1, Истина);
		
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение);
	
	ОповещениеУдаление = Новый ОписаниеОповещения("УдалитьФайлыЗавершение", ЭтотОбъект);
	НачатьУдалениеФайлов(ОповещениеУдаление, ДополнительныеПараметры.ПутьКОбработкеСПравилами); 
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлыЗавершение(ДополнительныеПараметры) Экспорт
    Возврат;
КонецПроцедуры

// Процедура определяет таблицу переходов по сценарию №1.
// Для заполнения таблицы переходов используется процедура ТаблицаПереходовНоваяСтрока().
//
&НаКлиенте
Процедура ТаблицаПереходовПоСценарию()
	
	ТаблицаПереходов.Очистить();
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаВыборТипаЗагрузки", 
									"СтраницаНавигацииВыборТипаЗагрузки", "СтраницаДекорацииВыборТипаЗагрузки");
	ТаблицаПереходовНоваяСтрока(1, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаВыборИБ", "СтраницаНавигацииВыборИБ",
									"СтраницаДекорацииВыборИБ");
	ТаблицаПереходовНоваяСтрока(2, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаПриветствие", "СтраницаНавигацииНачало",
									"СтраницаДекорацииНачало");
	СтруктураПараметров.ИмяОбработчикаПриПереходеДалее = "СтраницаПриветствие_ПриПереходеДалее";
	СтруктураПараметров.ИмяОбработчикаПриОткрытии = "СтраницаПриветствие_ПриОткрытии";
	ТаблицаПереходовНоваяСтрока(3, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаОжидания", "СтраницаНавигацииОжидание",
									"СтраницаДекорацииОжидание");
	СтруктураПараметров.ИмяОбработчикаПриПереходеДалее = "СтраницаОжидания_ПриПереходеДалее";
	СтруктураПараметров.ИмяОбработчикаПриОткрытии = "СтраницаОжидания_ПриОткрытии";
	ТаблицаПереходовНоваяСтрока(4, СтруктураПараметров);
	
	СтруктураПараметров = СоздатьСтруктуруПараметровСтрокиПерехода("СтраницаЗавершение", "СтраницаНавигацииОкончание",
									"СтраницаДекорацииОкончание");
	СтруктураПараметров.ИмяОбработчикаПриОткрытии = "СтраницаЗавершение_ПриОткрытии";
	ТаблицаПереходовНоваяСтрока(5, СтруктураПараметров);
	
КонецПроцедуры

// Готовит структуру параметров для дальнейшего добавления строки в таблицу переходов.
//
// Параметры:
//
//  	ИмяОсновнойСтраницы - Строка. Имя страницы панели "ПанельОсновная", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыНавигации - Строка. Имя страницы панели "ПанельНавигации", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыДекорации - Строка. Имя страницы панели "ПанельДекорации",
//		которая соответствует текущему номеру перехода.
&НаКлиенте
Функция СоздатьСтруктуруПараметровСтрокиПерехода(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации)
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяОсновнойСтраницы", ИмяОсновнойСтраницы);
	СтруктураПараметров.Вставить("ИмяСтраницыНавигации", ИмяСтраницыНавигации);
	СтруктураПараметров.Вставить("ИмяСтраницыДекорации", ИмяСтраницыДекорации);
	СтруктураПараметров.Вставить("ИмяОбработчикаПриОткрытии", "");
	СтруктураПараметров.Вставить("ИмяОбработчикаПриПереходеДалее", "");
	СтруктураПараметров.Вставить("ИмяОбработчикаПриПереходеНазад", "");
	Возврат СтруктураПараметров;
КонецФункции

// Добавляет новую строку в конец текущей таблицы переходов
//
// Параметры:
//
//  ПорядковыйНомерПерехода (обязательный) - Число. Порядковый номер перехода, который соответствует текущему шагу 
//  перехода
//  СтруктураПараметров - Структура, содержащая значения колонок в строке таблицы переходов
//  	ИмяОсновнойСтраницы - Строка. Имя страницы панели "ПанельОсновная", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыНавигации - Строка. Имя страницы панели "ПанельНавигации", 
//		которая соответствует текущему номеру перехода.
//
//  	ИмяСтраницыДекорации - Строка. Имя страницы панели "ПанельДекорации", которая соответствует 
//  	текущему номеру перехода.
//
//  	ИмяОбработчикаПриОткрытии - Строка. Имя функции-обработчика события открытия текущей страницы 
//  	помощника
//
//  	ИмяОбработчикаПриПереходеДалее - Строка. Имя функции-обработчика события перехода на следующую 
//  	страницу помощника.
//
//  	ИмяОбработчикаПриПереходеНазад - Строка. Имя функции-обработчика события перехода на предыдущую 
//  	страницу помощника.
// 
&НаСервере
Процедура ТаблицаПереходовНоваяСтрока(ПорядковыйНомерПерехода, СтруктураПараметров)
	
	НоваяСтрока = ТаблицаПереходов.Добавить();
	
	НоваяСтрока.ПорядковыйНомерПерехода = ПорядковыйНомерПерехода;
	ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПараметров);
КонецПроцедуры


&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	ПорядковыйНомерПерехода = Значение;
	Если ПорядковыйНомерПерехода < 0 Тогда
		ПорядковыйНомерПерехода = 0;
	КонецЕсли;
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеДалее
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
				Отказ = Истина;
			КонецПопытки;
			
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		СтрокаПерехода = СтрокиПерехода[0];
		
		// обработчик ПриПереходеНазад
		Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад) Тогда
			
			ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
			ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
			
			Отказ = Ложь;
			
			Попытка
				Выполнить(ИмяПроцедуры);
			Исключение
				Отказ = Истина;
			КонецПопытки;
			
			Если Отказ Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Попытка
			Выполнить(ИмяПроцедуры);
		Исключение
			Отказ = Истина;
		КонецПопытки;
		
		Если Отказ Тогда
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			Возврат;
		ИначеЕсли ПропуститьСтраницу Тогда
			Если ЭтоПереходДалее Тогда
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				Возврат;
			Иначе
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Установка отображения текущей страницы
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПерехода

&НаКлиенте
Процедура Подключаемый_СтраницаВыборИБ_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)

	Элементы.СписокИБ.Развернуть(0, Ложь);

КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаПриветствие"
//
// Параметры:
//
// Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
// ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
// ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	Элементы.КомандаДалее.КнопкаПоУмолчанию = Истина;
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаПриветствие".
//
// Параметры:
// Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаПриветствие_ПриПереходеДалее(Отказ)
	
	ОчиститьСообщения();
	
	// Проверка файла данных
	ТекстСообщения = "";
	
	Если НЕ ЗначениеЗаполнено(СокрЛП(Объект.ИмяФайлаОбмена)) Тогда
		СообщитьПользователюОбОшибке(НСтр("ru = 'Не указан путь к файлу с данными'"));
		Отказ = Истина;
	Иначе
		ФайлОбмена = Новый Файл(Объект.ИмяФайлаОбмена);
		ФайлОбмена.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ОбработчикПроверкиСуществованияФайлОбмена",
			ЭтотОбъект));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПроверкиСуществованияФайлОбмена(Существует, ДополнительныеПараметры) Экспорт

	Если Существует Тогда
		Оповещение = Новый ОписаниеОповещения("ОбработкаЗагрузкиФайла", ЭтотОбъект);
		НачатьПомещениеФайла(Оповещение, АдресВременногоХранилища, Объект.ИмяФайлаОбмена, Ложь, УникальныйИдентификатор);
	Иначе
		СообщитьПользователюОбОшибке(НСтр("ru = 'По указанному пути файл с данными не найден'"));
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаЗагрузкиФайла(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	АдресВременногоХранилища = Адрес;
	
	ОповещениеУдаление = Новый ОписаниеОповещения("УдалитьФайлыЗавершение", ЭтотОбъект);
	НачатьУдалениеФайлов(ОповещениеУдаление, Объект.ИмяФайлаОбмена);
	
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаЗавершение"
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаЗавершение_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Элементы.КомандаГотово.КнопкаПоУмолчанию = Истина;
	Элементы.НадписьСтатусЗагрузки.Заголовок = ?(СтатусВыполненнойЗагрузки,
												НСтр("ru = 'Загрузка данных успешно завершена!'"),
												НСтр("ru = 'Загрузка данных выполненна с ошибками!'"));
	Элементы.НадписьВариантовПродолжения.Заголовок = ?(
												СтатусВыполненнойЗагрузки,
												НСтр("ru = 'Нажмите кнопку ""Готово"" для выхода из помощника.'"),
												НСтр("ru = 'Для того чтобы попробовать загрузить еще раз, нажмите ""Назад""'") + ", "
												+ НСтр("ru = 'для выхода из помошника, нажимите ""Готово""'"));
	ЗаполнитьИтоговуюИнформацию();
	
	Если ЭтоБазовая И СтатусВыполненнойЗагрузки Тогда
		СтруктураПараметров = СтроковыеФункцииКлиентСервер.ПараметрыИзСтроки(ПараметрЗапуска);
		Если СтруктураПараметров.Свойство("Trade103Data") Тогда
			Закрыть();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик перехода далее (на следующую страницу) при уходе со страницы помощника "СтраницаОжидания".
//
// Параметры:
// Отказ - Булево - флаг отказа от выполнения перехода далее;
//					если в обработчике поднять этот флаг, то переход на следующую страницу выполнен не будет.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриПереходеДалее(Отказ)
	
	ЗагруженыНастройки = Ложь;
	Состояние(НСтр("ru = 'Загрузка данных...'"),, НСтр("ru = 'Выполняется загрузка данных из конфигурации ""Управление торговлей"" ред. 10.3'"));
	СтатусВыполненнойЗагрузки = ЗагрузитьНаСервере();
	
КонецПроцедуры

// Обработчик выполняется при открытии страницы помощника "СтраницаОжидания"
//
// Параметры:
//
//  Отказ - Булево - флаг отказа от открытия страницы;
//			если в обработчике поднять этот флаг, то переход на страницу выполнен не будет,
//			останется открытой предыдущая страница помощника согласно направлению перехода (вперед или назад).
//
//  ПропуститьСтраницу - Булево. Если поднять этот флаг, то страница будет пропущена
//			и управление перейдет на следующую страницу помощника согласно направлению перехода (вперед или назад).
//
//  ЭтоПереходДалее (только чтение) - Булево - флаг определяет направление перехода.
//			Истина - выполняется переход далее; Ложь - выполняется переход назад.
//
// Логика данного обработчика пропускает отображение
// страницы помощника "СтраницаОжидания", если выполняется переход назад.
//
&НаКлиенте
Процедура Подключаемый_СтраницаОжидания_ПриОткрытии(Отказ, ПропуститьСтраницу, Знач ЭтоПереходДалее)
	
	Если Не ЭтоПереходДалее Тогда
		
		ПропуститьСтраницу = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоместитьВХранилищеФайлСоСпискомБаз(УникальныйИдентификаторФормы)
	
	ПутьКБазам = "\1C\1CEStart\ibases.v8i";
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Попытка
			ФайлСписокБаз = РабочийКаталогДанныхПользователя() + СтрЗаменить(ПутьКБазам,"\","/");
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;

	Иначе
		Попытка
			Скрипт = Новый COMОбъект("WScript.Shell");
			ФайлСписокБаз = Скрипт.ExpandEnvironmentStrings("%appdata%") + ПутьКБазам;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
		КонецПопытки;
	КонецЕсли;
	
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещенныеФайлы = Новый Массив;
	Файл = Новый Файл(ФайлСписокБаз);
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя,));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикПомещенияФайлов", ЭтотОбъект);
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы, , Ложь, УникальныйИдентификаторФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт

	Если НЕ ПомещенныеФайлы = Неопределено Тогда
		АдресФайлаСоСпискомИБ = ПомещенныеФайлы[0].Хранение;
		СформироватьСписокЗарегистрированныхБаз(АдресФайлаСоСпискомИБ, Истина);
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область Прочее
&НаСервере
Процедура СообщитьПользователюОбОшибке(ТекстСообщения)
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"ИмяФайлаОбмена", "ИмяФайлаОбмена");
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНаСервере()
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	// получаем имя временного файла в локальной ФС на сервере
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	// получаем файл правил для зачитки
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	
	ИмяВременногоФайлаПротоколаОбмена = ПолучитьИмяВременногоФайла("txt");
	
	Обработка = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	Обработка.ИмяФайлаОбмена                        = ИмяВременногоФайла;
	Обработка.РежимОбмена                           = "Загрузка";
	Обработка.ЗапоминатьЗагруженныеОбъекты          = Ложь;
	Обработка.ВыводВПротоколСообщенийОбОшибках      = Истина;
	Обработка.ВыводВПротоколИнформационныхСообщений = Ложь;
	Обработка.ИмяФайлаПротоколаОбмена               = ИмяВременногоФайлаПротоколаОбмена;
	
	Обработка.ЗагружатьДанныеВРежимеОбмена               			= Истина;
	Обработка.ОбъектыПоСсылкеЗагружатьБезПометкиУдаления 			= Истина;
	Обработка.ОптимизированнаяЗаписьОбъектов             			= Истина;
	Обработка.ЗапоминатьЗагруженныеОбъекты               			= Истина;
	Обработка.НеВыводитьНикакихИнформационныхСообщенийПользователю	= Истина;
	Обработка.ВыводВОкноСообщенийИнформационныхСообщений 			= Ложь;

	ДатаНачалаЗагрузки = ТекущаяДатаСеанса();

	УстановитьПривилегированныйРежим(Истина);
	Обработка.ВыполнитьЗагрузку();
	ЗагрузкаВыполнена = НЕ Обработка.ФлагОшибки;
	УстановитьПривилегированныйРежим(Ложь);
	
	ДатаОкончанияЗагрузки = ТекущаяДатаСеанса();
	
	ПротоколОбмена = Новый ТекстовыйДокумент;
	ПротоколОбмена.Прочитать(ИмяВременногоФайлаПротоколаОбмена);
	
	ЗагруженыНастройки = Ложь;
	Если ЗагрузкаВыполнена
		И ТипЗнч(Обработка.Параметры) = Тип("Структура")
		И Обработка.Параметры.Свойство("ЗагруженыНастройки") Тогда
			ЗагруженыНастройки = Истина;
	КонецЕсли;
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайлаПротоколаОбмена);  // Удаляем временный файл правил
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Удаление файла'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;	
	
	Возврат ЗагрузкаВыполнена;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьИтоговуюИнформацию()
	
	ИмяМакета = ?(ЗагруженыНастройки, "МакетИтоговойИнформацииНастройки", "МакетИтоговойИнформации");
	ИтоговаяИнформация = Обработки.ПомощникПереходаСУправлениеТорговлей103.ПолучитьМакет(ИмяМакета).ПолучитьТекст();
	
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#ДатаНачалаЗагрузки#", ДатаНачалаЗагрузки);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#ДатаОкончанияЗагрузки#", ДатаОкончанияЗагрузки);
	ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#КоличествоЗагруженныхОбъектов#", КоличествоЗагруженныхОбъектов);
	
	Если СтатусВыполненнойЗагрузки Тогда
		
		Если ЗагруженыНастройки Тогда
		
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	ВалютаРегламентированногоУчета,
			|	ВалютаУправленческогоУчета,
			|	ДополнительнаяКолонкаПечатныхФормДокументов,
			|	ЕдиницаИзмеренияВеса,
			|	ЕдиницаИзмеренияОбъема,
			|	ЗаголовокСистемы,
			|	ИспользоватьАвтоматическиеСкидкиВПродажах,
			|	ИспользоватьДополнительныеРеквизитыИСведения,
			|	ИспользоватьЗаказыКлиентов,
			|	ИспользоватьЗаказыПоставщикам,
			|	ИспользоватьКартыЛояльности,
			|	ИспользоватьКачествоТоваров,
			|	ИспользоватьКомиссиюПриЗакупках,
			|	ИспользоватьНесколькоВидовНоменклатуры,
			|	ИспользоватьКомиссиюПриПродажах,
			|	ИспользоватьНоменклатуруПоставщиков,
			|	ИспользоватьОплатуПлатежнымиКартами,
			|	ИспользоватьПодключаемоеОборудование,
			|	ИспользоватьРозничныеПродажи,
			|	ИспользоватьСерииНоменклатуры,
			|	ИспользоватьУпаковкиНоменклатуры,
			|	ИспользоватьХарактеристикиНоменклатуры,
			|	ИспользоватьЦеновыеГруппы,
			|	ПрефиксУзлаРаспределеннойИнформационнойБазы,
			|	ИспользоватьСкладыВТабличнойЧастиДокументовЗакупки,
			|	ИспользоватьСкладыВТабличнойЧастиДокументовПродажи,
			|	ОграничиватьДоступНаУровнеЗаписей,
			|	ИспользоватьРаздельныйУчетПоНалогообложению,
			|	ИспользоватьПартнеровИКонтрагентов,
			|	ИспользоватьПодразделения,
			|	ИспользоватьМногооборотнуюТару,
			|	ИспользоватьНаборы,
			|	ИспользованиеСоглашенийСКлиентами,
			|	ИспользоватьОрдерныеСклады,
			|	Константы.ИспользоватьДоговорыСКлиентами,
			|	ВЫБОР КОГДА Константы.ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента
			|		И Константы.ИспользоватьРасширенныеВозможностиЗаказаКлиента ТОГДА
			|			&ВариантИспользованияЗаказов1
			|	ИНАЧЕ
			|			&ВариантИспользованияЗаказов2
			|	КОНЕЦ КАК ИспользованиеЗаказов,
			|	Константы.ИспользоватьПричиныОтменыЗаказовКлиентов,
			|	Константы.ИспользоватьПричиныОтменыЗаказовПоставщикам,
			|	Константы.ИспользоватьДоговорыСПоставщиками,
			|	Константы.НеЗакрыватьЗаказыПоставщикамБезПолнойОплаты,
			|	Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОплаты,
			|	Константы.НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки,
			|	Константы.НеЗакрыватьЗаказыПоставщикамБезПолногоПоступления,
			|	Константы.ИспользоватьДоверенностиНаПолучениеТМЦ,
			|	Константы.ИспользоватьБизнесРегионы
			|ИЗ
			|	Константы КАК Константы";
			
			Запрос.УстановитьПараметр("ВариантИспользованияЗаказов1", НСтр("ru = 'Заказ со склада и под заказ'"));
			Запрос.УстановитьПараметр("ВариантИспользованияЗаказов2", НСтр("ru = 'Заказ как счет'"));
			
			Результат = Запрос.Выполнить().Выгрузить();
			
			Для Каждого Колонка Из Результат.Колонки Цикл
				Значение = Результат[0][Колонка.Имя];
				Значение = ?(ТипЗнч(Значение) = Тип("Булево"), Формат(Значение, "БЛ=Выключено; БИ=Включено"), Строка(Значение));
				ИтоговаяИнформация = СтрЗаменить(ИтоговаяИнформация, "#" + Колонка.Имя + "#", Значение);
			КонецЦикла;
			
		КонецЕсли;
	Иначе
		ИтоговаяИнформация = ИтоговаяИнформация + Символы.ПС+ НСтр("ru = 'Протокол ошибок'") + ": ";
		ИтоговаяИнформация = ИтоговаяИнформация + Символы.ПС+ ПротоколОбмена.ПолучитьТекст();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьСписокЗарегистрированныхБаз(АдресФайлаСоСпискомИБ, ФайловыйРежим)
	
	СписокИБДерево = Обработки.ПомощникПереходаСУправлениеТорговлей103.СформироватьСписокЗарегистрированныхБаз(АдресФайлаСоСпискомИБ, ФайловыйРежим);
	
	ЗначениеВРеквизитФормы(СписокИБДерево, "СписокИБ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФайлыОбновления(Знач Оповещение)
	
	ДанныеПользователя = Новый Структура("Логин, Пароль, ПользовательПроксиСервера, ПарольПроксиСервера, ИспользоватьПрокси");
	ПолучитьНастройкиПодключения(ДанныеПользователя);
	
	Если НЕ ЗначениеЗаполнено(ДанныеПользователя.Пароль) 
		ИЛИ НЕ ЗначениеЗаполнено(ДанныеПользователя.Логин) Тогда
		
		ОповещениеИПП = Новый ОписаниеОповещения("ПолучитьФайлыОбновленияЗавершение", ЭтотОбъект, Новый Структура("ДанныеПользователя", ДанныеПользователя));
	
		ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеИПП, ЭтаФорма);
		
		Ответ = Неопределено;
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение,ПолучитьФайлыССервера(ДанныеПользователя));
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьФайлыОбновленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ПолучитьФайлыССервера(ДополнительныеПараметры.ДанныеПользователя);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьНастройкиПодключения(ДанныеПользователя)
	
	// Авторизация на прокси
	НастройкаПроксиСервера = ПолучениеФайловИзИнтернета.НастройкиПроксиНаКлиенте();
	Если ТипЗнч(НастройкаПроксиСервера) = Тип("Соответствие") Тогда
		ДанныеПользователя.ИспользоватьПрокси = НастройкаПроксиСервера.Получить("ИспользоватьПрокси");
		Если ДанныеПользователя.ИспользоватьПрокси Тогда
			ДанныеПользователя.ПользовательПроксиСервера = НастройкаПроксиСервера.Получить("Пользователь");
			ДанныеПользователя.ПарольПроксиСервера       = НастройкаПроксиСервера.Получить("Пароль");
		КонецЕсли;
	КонецЕсли;
	
	// Авторизация на сервере
	УстановитьПривилегированныйРежим(Истина);
	ЛогинПароль = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	Если ЛогинПароль <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ДанныеПользователя, ЛогинПароль);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьФайлыССервера(ДанныеПользователя)
	
	ПолучитьНастройкиПодключения(ДанныеПользователя);
	
	СсылкаНаСкачивание = ПолучитьСсылкуНаСкачивание(ДанныеПользователя);
	Если СсылкаНаСкачивание = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПолучения = Новый Структура("Пользователь,Пароль");
	ПараметрыПолучения.Пользователь = ДанныеПользователя.Логин;
	ПараметрыПолучения.Пароль = ДанныеПользователя.Пароль;
	
	Для каждого ЭлемСсылка Из СсылкаНаСкачивание.fileDtoList Цикл
		
		// Получение файлов с сервера
		Адрес = ЭлемСсылка.url;
		
		ИмяФайла = ПолучитьИмяФайла(Адрес);
		
		Если НЕ СтрНайти(ИмяФайла, ".epf") Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Результат = ПолучениеФайловИзИнтернета.СкачатьФайлВоВременноеХранилище(Адрес, ПараметрыПолучения, Истина);
			Если НЕ Результат.Статус Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.СообщениеОбОшибке);
				Возврат Неопределено;
			КонецЕсли;
			
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Неудачная попытка соединения.'"));
			Возврат Неопределено;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат Результат.Путь;
	
КонецФункции

&НаСервере
Функция ПолучитьСсылкуНаСкачивание(ДанныеПользователя)

	URIПространстваИменСервиса = "http://file.api.update.onec.ru";
	ИмяСервиса = "UpdateFilesApiImplService";
	ИмяПорта = "UpdateFilesApiImplPort";
	
	ИмяКонфигурации     = ИнтернетПоддержкаПользователей.ИмяКонфигурации();
	ВерсияКонфигурации  = ИнтернетПоддержкаПользователей.ВерсияКонфигурации();
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ВерсияПриложения    = СистемнаяИнформация.ВерсияПриложения;
	
	// Получения ссылок на скачивание
	Попытка
		Прокси = WSСсылки.UpdateFilesApiImplService.СоздатьWSПрокси(URIПространстваИменСервиса, ИмяСервиса, ИмяПорта);
		СсылкаНаСкачивание = Прокси.getFilesForUpdateToVersion(
			ДанныеПользователя.Логин,
			ДанныеПользователя.Пароль,
			ИмяКонфигурации,
			ВерсияКонфигурации,
			ВерсияКонфигурации,
			ВерсияПриложения);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Неудачная попытка соединения.'"));
		Возврат Неопределено;
		
	КонецПопытки;
	
	Если СсылкаНаСкачивание.fileDtoList.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СсылкаНаСкачивание;
	
КонецФункции 
 
&НаСервере
Функция ПолучитьНомерПоследнегоСимвола(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда
			Возврат ПозицияСимвола; 
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;	
	КонецЦикла;

	Возврат 0;
  	
КонецФункции

&НаСервере
Функция ПолучитьИмяФайла(Знач ПутьКФайлу) Экспорт

	ПозицияСимвола = ПолучитьНомерПоследнегоСимвола(ПутьКФайлу, "/"); 
	Если ПозицияСимвола > 1 Тогда
		Возврат Сред(ПутьКФайлу, ПозицияСимвола + 1, СтрДлина(ПутьКФайлу)); 
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

#КонецОбласти
#КонецОбласти