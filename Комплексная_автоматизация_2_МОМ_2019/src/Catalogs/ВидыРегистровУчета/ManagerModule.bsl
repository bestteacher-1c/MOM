#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает вид регистра по имени объекта и по варианту отчета.
//
// Параметры:
//   ПолноеИмяОбъектаМетаданных - Строка - например, "Отчет.КарточкаСчета".
//   ВариантОтчета              - Строка - имя варианта.
//
// Возвращаемое значение:
//   СправочникСсылка.ВидыРегистровУчета - вид регистра.
//
Функция ПолучитьВидРегистраБухгалтерскогоУчетаДляОтчета(ПолноеИмяОбъектаМетаданных, ВариантОтчета = "") Экспорт
	
	Если ВариантОтчета = Неопределено Тогда
		ВариантОтчета = "";
	КонецЕсли;
	
	ИдентификаторОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяОбъектаМетаданных);
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Отчет", ИдентификаторОтчета);
	Запрос.Параметры.Вставить("ВариантОтчета", ВариантОтчета);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыРегистровУчета.Ссылка
	|ИЗ
	|	Справочник.ВидыРегистровУчета КАК ВидыРегистровУчета
	|ГДЕ
	|	ВидыРегистровУчета.Отчет = &Отчет
	|	И ВидыРегистровУчета.ВариантОтчета = &ВариантОтчета
	|";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ВидыРегистровУчета.ПустаяСсылка();
	
КонецФункции

// Заполняет виды регистров учета при обновлении конфигурации.
//
Процедура ЗаполнитьВидыРегистровУчета() Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Стандартные отчеты
	ВидРегистра = Справочники.ВидыРегистровУчета.АнализСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.АнализСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "АнализСубконто";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.АнализСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.АнализСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "АнализСчета";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ГлавнаяКнига.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ГлавнаяКнига);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.КарточкаСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.КарточкаСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "КарточкаСубконто";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.КарточкаСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.КарточкаСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "КарточкаСчета";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотноСальдоваяВедомость.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотноСальдоваяВедомость);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотноСальдоваяВедомость";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотноСальдоваяВедомостьПоСчету.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотноСальдоваяВедомостьПоСчету);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотноСальдоваяВедомостьПоСчету";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотыМеждуСубконто.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотыМеждуСубконто);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотыМеждуСубконто";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОборотыСчета.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОборотыСчета);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОборотыСчета";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ОтчетПоПроводкам.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ОтчетПоПроводкам);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ОтчетПоПроводкам";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СводныеПроводки.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СводныеПроводки);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "СводныеПроводки";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.ШахматнаяВедомость.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.ШахматнаяВедомость);
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ВидРегистра.ВариантОтчета = "ШахматнаяВедомость";
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	// Справки расчеты
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетТранспортногоНалога.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетТранспортногоНалога);
	ВидРегистра.ВариантОтчета = "РасчетТранспортногоНалога";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетЗемельногоНалога.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетЗемельногоНалога);
	ВидРегистра.ВариантОтчета = "РасчетЗемельногоНалога";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	ВидРегистра = Справочники.ВидыРегистровУчета.СправкаРасчетТорговогоСбора.ПолучитьОбъект();
	ВидРегистра.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Отчеты.СправкаРасчетТорговогоСбора);
	ВидРегистра.ВариантОтчета = "РасчетТорговогоСбора";
	ВидРегистра.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидРегистра.Отчет, "Синоним");
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВидРегистра, Истина);
	
	// Заполним прочие другие отчеты, которые могут быть в конфигурации.
	ОбновлениеИнформационнойБазыБППереопределяемый.ЗаполнитьВидыРегистровУчета();
	
КонецПроцедуры

// Возвращает поля естественного ключа.
//
// Возвращаемое значение:
//   ПоляЕстественногоКлюча - Массив - содержит поля:
//     * Отчет         - Строка - имя отчета.
//     * ВариантОтчета - Строка - имя варианта.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить("Отчет");
	Результат.Добавить("ВариантОтчета");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
