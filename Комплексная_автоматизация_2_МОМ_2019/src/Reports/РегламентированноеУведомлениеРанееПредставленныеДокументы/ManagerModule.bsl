#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеРанееПредставленныеДокументы.Форма.Форма2015_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "Утверждено письмом ФНС России от 07.11.2018 № ЕД-4-15/21688@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ПечатьСразу_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат СформироватьМакет_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Для данного заявления выгрузка не предусмотрена", УникальныйИдентификатор);
	ВызватьИсключение "";
КонецФункции

Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2015_1");
	ОЧ1 = МакетУведомления.ПолучитьОбласть("Ч1");
	ОЧ2 = МакетУведомления.ПолучитьОбласть("Ч2");
	ОЧ3 = МакетУведомления.ПолучитьОбласть("Ч3");
	Титульный = Объект.ДанныеУведомления.Получить().Титульный;
	ЗаполнитьЗначенияСвойств(ОЧ1.Параметры, Титульный);
	ЗаполнитьЗначенияСвойств(ОЧ2.Параметры, Титульный);
	ЗаполнитьЗначенияСвойств(ОЧ3.Параметры, Титульный);
	ПечатнаяФорма.Вывести(ОЧ1);
	Если Не ПечатнаяФорма.ПроверитьВывод(ОЧ2) Тогда 
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	ПечатнаяФорма.Вывести(ОЧ2);
	Если Не ПечатнаяФорма.ПроверитьВывод(ОЧ3) Тогда 
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЕсли;
	ПечатнаяФорма.Вывести(ОЧ3);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2015_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2015_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ПолучитьНазваниеОргана(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2015_1" Тогда
		СтруктураПараметров = Объект.ДанныеУведомления.Получить();
		Титульный = СтруктураПараметров.Титульный[0];
		Возврат Титульный.Орган;
	КонецЕсли;
	Возврат "";
КонецФункции
#КонецОбласти
#КонецЕсли