///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ОблачныйАрхив".
// ОбщийМодуль.ОблачныйАрхивПереопределяемый.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПриНачалеРаботыСистемы

// Процедура вызывается из модуля управляемого приложения,
//  затем РаботаСОблачнымАрхивомКлиент.ПриНачалеРаботыСистемы,
//  затем РаботаСОблачнымАрхивомВызовСервера.ПриНачалеРаботыСистемы,
//  затем РаботаСОблачнымАрхивом.ПриНачалеРаботыСистемы,
//  затем РаботаСОблачнымАрхивомПереопределяемый.ПриНачалеРаботыСистемы.
//
// Параметры:
//  СтандартнаяОбработка - Булево - если установить в ЛОЖЬ, то стандартные действия при начале работы системы не будут выполняться.
//
Процедура ПриНачалеРаботыСистемы(СтандартнаяОбработка) Экспорт

КонецПроцедуры

#КонецОбласти

#Область РегламентныеЗадания

// Процедура переопределяет время следующего обновления в регистре сведений "ВсеОбновленияОблачногоАрхива".
//
// Параметры:
//  ВидОбновления            - Строка - Вид обновления, см. РегистрыСведений.ВсеОбновленияОблачногоАрхива.ПолучитьЗначенияДопустимыхВидовОбновления();
//  ДатаПоследнегоОбновления - Дата   - Дата, к которой необходимо прибавлять время отсрочки (в секундах);
//  ДатаСледующегоОбновления - Дата   - Дата, которую необходимо переопределить;
//  ОшибокНеБыло             - Булево - Истина, если ошибок не было.
//
Процедура УстановитьВремяСледующегоОбновления(ВидОбновления, ДатаПоследнегоОбновления, ДатаСледующегоОбновления, ОшибокНеБыло) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ВзаимодействиеСБСП

#Область ОбновлениеИБ

// Процедура вызывается при первом запуске библиотеки БИП.
// Обработчики из библиотеки для общих данных и для области данных уже были вызваны.
// Процедура - для всех областей данных.
// Здесь можно задать действия при первоначальном запуске ИБ.
// Например, программно добавить новости, или изменить свойства лент новостей.
//
// Параметры:
//  КонтекстВыполнения - Структура - специальная структура, куда можно передавать лог выполнения.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПервыйЗапуск(КонтекстВыполнения) Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Обработчики из библиотеки для общих данных и для области данных уже были вызваны.
// Процедура - для всех областей данных.
// Здесь можно задать действия при обновлении ИБ.
// Например, программно добавить новости, или изменить свойства лент новостей, или изменить расписание регламентного задания ВсеОбновленияНовостей.
//
// Параметры:
//  КонтекстВыполнения - Структура - специальная структура, куда можно передавать лог выполнения.
//
Процедура ОбновлениеИнформационнойБазы_ОбщиеДанные_ПерейтиНаВерсию(КонтекстВыполнения) Экспорт

КонецПроцедуры

// Процедура вызывается при первом запуске библиотеки БИП.
// Обработчики из библиотеки для общих данных и для области данных уже были вызваны.
// Процедура - для каждой области данных.
// Здесь можно задать действия при первоначальном запуске ИБ.
// Например, произвести настройки пользователей.
//
// Параметры:
//  КонтекстВыполнения - Структура - специальная структура, куда можно передавать лог выполнения.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПервыйЗапуск(КонтекстВыполнения) Экспорт

КонецПроцедуры

// Процедура вызывается при обновлении библиотеки БИП на любую новую версию.
// Обработчики из библиотеки для общих данных и для области данных уже были вызваны.
// Процедура - для каждой области данных.
// Здесь можно задать действия при обновлении ИБ в области данных.
// Например, произвести настройки пользователей.
//
// Параметры:
//  КонтекстВыполнения - Структура - специальная структура, куда можно передавать лог выполнения.
//
Процедура ОбновлениеИнформационнойБазы_ОбластьДанных_ПерейтиНаВерсию(КонтекстВыполнения) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
