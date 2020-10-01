
#Область СлужебныеПроцедурыИФункции

Функция ЭтоПартнер(Пользователь = Неопределено) Экспорт
	Возврат ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь();
КонецФункции

Функция ВводИнформацииПоНоменклатуреБезКонтроля(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ВводИнформацииПоНоменклатуреБезКонтроля", Пользователь, Ложь);
КонецФункции

Функция ВводИнформацииПоПартнеруБезКонтроля(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ВводИнформацииПоПартнеруБезКонтроля", Пользователь, Ложь);
КонецФункции

Функция ДобавлениеИзменениеНастройкиПечатиОбъектов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНастройкиПечатиОбъектов", Пользователь, Ложь);
КонецФункции

Функция ИзменениеИндивидуальныхСоглашений(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеИндивидуальныхСоглашенийСКлиентами", Пользователь, Ложь);
КонецФункции

Функция ИзменениеТиповыхСоглашений(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеТиповыхСоглашенийСКлиентами", Пользователь, Ложь);
КонецФункции

Функция ЗаписьВыданнойДоверенностиВОкончательномСтатусе(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ЗаписьВыданнойДоверенностиВОкончательномСтатусе", Пользователь, Ложь);
КонецФункции

Функция ЗачетОплаты(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ЗачетОплаты", Пользователь, Ложь);
КонецФункции

Функция ОтгрузкаПартнерамЗапрещенныхСегментов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ОтгрузкаПартнерамЗапрещенныхСегментов", Пользователь, Ложь);
КонецФункции

Функция ОтклонениеОтУсловийЗакупок(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ОтклонениеОтУсловийЗакупок", Пользователь, Ложь);
КонецФункции

Функция ОтклонениеОтУсловийПродаж(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ОтклонениеОтУсловийПродаж", Пользователь, Ложь);
КонецФункции

Функция ПравоНаВводГрафиковРаботыРЦ(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДоступностиДляРасписанияРаботы", Пользователь, Ложь);
КонецФункции

Функция ПравоНаВводДоступностиВидовРЦ(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеДоступностиДляГрафикаПроизводства", Пользователь, Ложь);
КонецФункции

Функция ВзятиеРасходногоОрдераВРаботу(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ВзятиеРасходногоОрдераВРаботу", Пользователь, Ложь);
КонецФункции

Функция ПропускКонтроляТоваровОрганизацийПриОтменеПриходов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ПропускКонтроляТоваровОрганизацийПриОтменеПриходов", Пользователь, Ложь);
КонецФункции

Функция РеализацияСверхЗаказа(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("РеализацияСверхЗаказа", Пользователь, Ложь);
КонецФункции

Функция ВнутреннееПотреблениеСверхЗаказа(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ВнутреннееПотреблениеСверхЗаказа", Пользователь, Ложь);
КонецФункции

//++ НЕ УТ

// Определяет наличие прав на добавление строк сверх заказа при передаче материалов в производство.
//
Функция ПередачаМатериаловВПроизводствоСверхЗаказа(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("ПередачаМатериаловВПроизводствоСверхЗаказа", Пользователь, Ложь);
КонецФункции

//-- НЕ УТ

Функция РедактированиеВидовЗапасовДокументов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("РедактированиеВидовЗапасовДокументов", Пользователь, Ложь);
КонецФункции

Функция СогласованиеЗаявокНаРасходованиеДенежныхСредств(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СогласованиеЗаявокНаРасходованиеДенежныхСредств", Пользователь, Ложь);
КонецФункции

Функция СогласованиеРаспоряженийНаПеремещениеДенежныхСредств(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СогласованиеРаспоряженийНаПеремещениеДенежныхСредств", Пользователь, Ложь);
КонецФункции

Функция СозданиеАктовВыполненныхРаботБезЗаказа(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СозданиеАктовВыполненныхРаботБезЗаказа", Пользователь, Ложь);
КонецФункции

Функция СозданиеРеализацииТоваровУслугБезЗаказа(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СозданиеРеализацииТоваровУслугБезЗаказа", Пользователь, Ложь);
КонецФункции

Функция СохранениеНастроекПечатиОбъектовПоУмолчанию(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("СохранениеНастроекПечатиОбъектовПоУмолчанию", Пользователь, Ложь);
КонецФункции

Функция УстановкаЦенНоменклатурыБезСогласования(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("УстановкаЦенНоменклатурыБезСогласования", Пользователь, Ложь);
КонецФункции

Функция УтверждениеЗаявокНаРасходованиеДенежныхСредств(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("УтверждениеЗаявокНаРасходованиеДенежныхСредств", Пользователь, Ложь);
КонецФункции

Функция УтверждениеРаспоряженийНаПеремещениеДенежныхСредств(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("УтверждениеРаспоряженийНаПеремещениеДенежныхСредств", Пользователь, Ложь);
КонецФункции

Функция ПечатьЭтикетокИЦенников(Пользователь = Неопределено) Экспорт
	Возврат ПравоДоступа("Просмотр", Метаданные.Обработки.ПечатьЭтикетокИЦенников);
КонецФункции

Функция ПравоСозданияПартнера() Экспорт
	Возврат ПравоДоступа("Добавление", Метаданные.Справочники.Партнеры);
КонецФункции 

Функция УтверждениеАвансовыхОтчетов(Пользователь = Неопределено) Экспорт
	Возврат Пользователи.РолиДоступны("УтверждениеАвансовыхОтчетов", Пользователь, Ложь);
КонецФункции

Функция ИменаРолейСПравомДобавления(ИмяОбъектаМетаданных) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваРолей.Роль.Имя КАК ИмяРоли
	|ИЗ
	|	РегистрСведений.ПраваРолей КАК ПраваРолей
	|ГДЕ
	|	НЕ ПраваРолей.Роль.ПометкаУдаления
	|	И НЕ ПраваРолей.ОбъектМетаданных.ПометкаУдаления
	|	И ПраваРолей.Добавление
	|	И ПраваРолей.ОбъектМетаданных.ПолноеИмя = &ПолноеИмя";
	
	Запрос.УстановитьПараметр("ПолноеИмя", ИмяОбъектаМетаданных);
	
	МассивРолей = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИмяРоли");
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат МассивРолей;
	
КонецФункции

#КонецОбласти
