#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеФормаР21001.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "В редакции от 25.01.2012 приказ ФНС России № ММВ-7-6/25@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ДанныеУведомления(ЭкземплярУведомления) Экспорт
	
	СтруктураДанных = Новый Структура;
	
	Если ЭкземплярУведомления.ИмяФормы = "Форма2014_1" Тогда
		
		ДанныеУведомления = ЭкземплярУведомления.ДанныеУведомления.Получить();
		
		Если ТипЗнч(ДанныеУведомления) <> Тип("Структура") Тогда
			Возврат СтруктураДанных;
		КонецЕсли;
		
		Если ДанныеУведомления.ДанныеУведомления.Свойство("Лист005") Тогда
			
			КодСпособаРегистрации = "Б01010000";
			
			Лист005 = ДанныеУведомления.ДанныеУведомления.Лист005;
			
			СпособРегистрации = Неопределено;
			Если Лист005.Свойство(КодСпособаРегистрации, СпособРегистрации) Тогда
				СтруктураДанных.Вставить("СпособРегистрации", СпособРегистрации);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ЕстьВыходЗаГраницы = Ложь;
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	
	НомСтр = 0;
	Для Каждого Стр Из СтруктураПараметров.ДеревоСтраниц.Строки Цикл
		НомСтр = НомСтр + 1;
		МакетПФ = Отчеты.РегламентированноеУведомлениеФормаР21001.ПолучитьМакет("Печать_" + Стр.ИмяМакета);
		
		Если Стр.ИДНаименования = "Лист004" Тогда 
			МногострочнаяЧасть = СтруктураПараметров.МногострочнаяЧасть1;
			УведомлениеОСпецрежимахНалогообложения.ВывестиОКВЭДНаПечать(СтруктураПараметров.ДанныеУведомления[Стр.ИДНаименования].А01010000, "А01010000", МакетПФ.Области);
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
			ВсегоНапечатаноСтрок = 1;
			Для Каждого СтрМнг Из МногострочнаяЧасть Цикл
				Если Не ЗначениеЗаполнено(СтрМнг.А01020000) Тогда 
					Продолжить;
				КонецЕсли;
				
				УведомлениеОСпецрежимахНалогообложения.ВывестиОКВЭДНаПечать(СтрМнг.А01020000, "А01020000_"+ВсегоНапечатаноСтрок, МакетПФ.Области);
				ВсегоНапечатаноСтрок = ВсегоНапечатаноСтрок + 1;
				Если ВсегоНапечатаноСтрок = 57 Тогда 
					ПечатнаяФорма.Вывести(МакетПФ);
					ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
					
					ВсегоНапечатаноСтрок = 1;
					НомСтр = НомСтр + 1;
					МакетПФ = Отчеты.РегламентированноеУведомлениеФормаР21001.ПолучитьМакет("Печать_" + Стр.ИмяМакета);
					//УведомлениеОСпецрежимахНалогообложения.ВывестиОКВЭДНаПечать(СтруктураПараметров.ДанныеУведомления[Стр.ИДНаименования].А01010000, "А01010000", МакетПФ.Области);
					УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
				КонецЕсли;
			КонецЦикла;
			
			ПечатнаяФорма.Вывести(МакетПФ);
			ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		Иначе 
			СтруктураДанныхСтраницы = СтруктураПараметров.ДанныеУведомления[Стр.ИДНаименования];
			
			Для Каждого КЗ Из СтруктураДанныхСтраницы Цикл
				Если ТипЗнч(КЗ.Значение) = Тип("Строка") Тогда 
					Если УведомлениеОСпецрежимахНалогообложения.ЭтоПолеАдресаРегистрационныхЗаявлений(КЗ.Ключ) Тогда 
						УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечатьСКонтролемДляРегистрационныхЗаявлений(ВРег(КЗ.Значение), КЗ.Ключ, МакетПФ.Области, "-", ЕстьВыходЗаГраницы);
					Иначе 
						УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(ВРег(КЗ.Значение), КЗ.Ключ, МакетПФ.Области);
					КонецЕсли;
				ИначеЕсли ТипЗнч(КЗ.Значение) = Тип("Дата") Тогда 
					УведомлениеОСпецрежимахНалогообложения.ВывестиДатуНаПечать(КЗ.Значение, КЗ.Ключ, МакетПФ.Области);
				КонецЕсли;
			КонецЦикла;
			
			УведомлениеОСпецрежимахНалогообложения.ВывестиСтрокуНаПечать(Прав("000"+НомСтр, 3), "НомСтр", МакетПФ.Области);
			
			ПечатнаяФорма.Вывести(МакетПФ);
			ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьВыходЗаГраницы = Истина Тогда 
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Некоторые поля адреса не уместились, рекомендуется воспользоваться печатной формой PDF417'"));
	КонецЕсли;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Если ЗначениеЗаполнено(СведенияОтправки.ДатаДок) Тогда 
		ДатаФормированияФайла = Формат(Дата(Число(Прав(СведенияОтправки.ДатаДок, 4)), Число(Сред(СведенияОтправки.ДатаДок, 4, 2)), Число(Лев(СведенияОтправки.ДатаДок, 2))), "ДФ=yyyyMMdd");
	Иначе
		ДатаФормированияФайла = "00010101";
	КонецЕсли;
	
	Префикс = "RO_R21001_0000_0000_000000000000000_" + ДатаФормированияФайла + "_" + Строка(Новый УникальныйИдентификатор);
	Возврат Префикс;
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура("ЭтоПБОЮЛ", Истина);
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.Дата, "ДФ=dd.MM.yyyy"));
	Данные = Объект.ДанныеУведомления.Получить();
	Если ЗначениеЗаполнено(Данные.ДанныеУведомления.Лист002.П01070501) И ЗначениеЗаполнено(Данные.ДанныеУведомления.Лист002.П01070502) Тогда 
		ОсновныеСведения.Вставить("КодПодр", "" + Данные.ДанныеУведомления.Лист002.П01070501 + "-" + Данные.ДанныеУведомления.Лист002.П01070502);
	Иначе
		ОсновныеСведения.Вставить("КодПодр", "");
	КонецЕсли;
	
	Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетностьПереопределяемый.КраткоеНазваниеПрограммы());
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметрыСРазделами(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДаннымиУзел(Объект.ДанныеУведомления.Получить(), ДеревоВыгрузки);
КонецПроцедуры

Функция СформироватьДеревоСтраниц_Форма2014_1()
	ДеревоСтраниц = Новый ДеревоЗначений;
	ДеревоСтраниц.Колонки.Добавить("ИндексКартинки", Новый ОписаниеТипов("Число"));
	ДеревоСтраниц.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ДеревоСтраниц.Колонки.Добавить("УИД", Новый ОписаниеТипов("УникальныйИдентификатор"));
	ДеревоСтраниц.Колонки.Добавить("ИмяМакета", Новый ОписаниеТипов("Строка"));
	ДеревоСтраниц.Колонки.Добавить("Многостраничность", Новый ОписаниеТипов("Булево"));
	ДеревоСтраниц.Колонки.Добавить("Многострочность", Новый ОписаниеТипов("Булево"));
	ДеревоСтраниц.Колонки.Добавить("ИДНаименования", Новый ОписаниеТипов("Строка"));
	ДеревоСтраниц.Колонки.Добавить("МногострочныеЧасти", Новый ОписаниеТипов("СписокЗначений"));
	
	КорневойУровень = ДеревоСтраниц.Строки;
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Стр. 001";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2014_1_Страница1";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист001";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Стр. 002";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2014_1_Страница2";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист002";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Стр. 003";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2014_1_Страница3";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист003";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Лист А";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2014_1_Страница4";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист004";
	Стр001.МногострочныеЧасти.Добавить("МногострочнаяЧасть1");
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Лист Б";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Форма2014_1_Страница5";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист005";
	
	Возврат ДеревоСтраниц;
КонецФункции

Функция СформироватьДеревоСтраниц(ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда 
		Возврат СформироватьДеревоСтраниц_Форма2014_1();
	КонецЕсли;
КонецФункции

Функция СоздатьЗаполненноеУведомление(Параметры, СуществующийДокументСсылка = Неопределено) Экспорт
	ИмяФормы = Неопределено;
	Если Не Параметры.Свойство("ИмяФормы", ИмяФормы) Тогда 
		ИмяФормы = "Форма2014_1";
	КонецЕсли;
	Дерево = СформироватьДеревоСтраниц(ИмяФормы);
	ИмяОтчета = "РегламентированноеУведомлениеФормаР21001";
	
	ВходящийКонтейнер = Новый Структура("ИмяФормы, ДеревоСтраниц", "1."+ИмяОтчета+".1."+ИмяФормы, Дерево);
	РезультатКонтейнер1 = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.СформироватьКонтейнерДанныхУведомления(ВходящийКонтейнер, РезультатКонтейнер1);
	РезультатКонтейнер2 = Новый Структура;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииСКонтейнеромМногострочныхБлоков(ВходящийКонтейнер, РезультатКонтейнер2);
	
	УведомлениеОСпецрежимахНалогообложения.ДополнитьСлужебнымиСтруктурамиАдреса(РезультатКонтейнер1.ДанныеУведомления);
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Параметры.Организация);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          Параметры.ДополнительныеПараметры);
	
	Контейнер = Новый Структура;
	Для Каждого КЗ Из РезультатКонтейнер1.ДанныеУведомления Цикл 
		Контейнер.Вставить(КЗ.Ключ, ОбщегоНазначения.СкопироватьРекурсивно(КЗ.Значение));
	КонецЦикла;
	
	Для Каждого КЗ Из РезультатКонтейнер2 Цикл 
		Контейнер.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;

	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ИмяОтчета, ИмяФормы, ПараметрыОтчета, Контейнер);
	
	Для Каждого КЗ Из Контейнер Цикл 
		Если РезультатКонтейнер1.ДанныеУведомления.Свойство(КЗ.Ключ) Тогда 
			ЗаполнитьЗначенияСвойств(РезультатКонтейнер1.ДанныеУведомления[КЗ.Ключ], КЗ.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КЗ Из РезультатКонтейнер2 Цикл 
		РезультатКонтейнер2[КЗ.Ключ] = Контейнер[КЗ.Ключ];
	КонецЦикла;
	
	Если ТипЗнч(СуществующийДокументСсылка) = Тип("Структура")
		И СуществующийДокументСсылка.Свойство("Ссылка")
		И ЗначениеЗаполнено(СуществующийДокументСсылка.Ссылка) Тогда 
		
		НовыйДок = СуществующийДокументСсылка.Ссылка.ПолучитьОбъект();
	ИначеЕсли ТипЗнч(СуществующийДокументСсылка) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения")
		И ЗначениеЗаполнено(СуществующийДокументСсылка) Тогда
		
		НовыйДок = СуществующийДокументСсылка.ПолучитьОбъект();
	Иначе
		НовыйДок = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		НовыйДок.Организация = Параметры.Организация;
		НовыйДок.ИмяФормы = ИмяФормы;
		НовыйДок.ИмяОтчета = ИмяОтчета;
		НовыйДок.Дата = ТекущаяДатаСеанса();
		НовыйДок.ДатаПодписи = ТекущаяДатаСеанса();
		НовыйДок.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР21001;
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("ДанныеУведомления, ДеревоСтраниц, МногострочнаяЧасть1",
			РезультатКонтейнер1.ДанныеУведомления, Дерево, РезультатКонтейнер2["МногострочнаяЧасть1"]);
			
	НовыйДок.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	НовыйДок.Записать();
	
	Возврат НовыйДок.Ссылка;
КонецФункции

#КонецОбласти
#КонецЕсли
