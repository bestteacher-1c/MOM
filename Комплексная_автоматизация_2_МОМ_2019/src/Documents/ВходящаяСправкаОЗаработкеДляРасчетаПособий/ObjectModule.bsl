#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("Организация", Организация);
		ДанныеЗаполнения.Свойство("Сотрудник", Сотрудник);
		ДанныеЗаполнения.Свойство("Страхователь", Страхователь);
		ДанныеЗаполнения.Свойство("ПериодРаботыС", ПериодРаботыС);
		ДанныеЗаполнения.Свойство("ПериодРаботыПо", ПериодРаботыПо);
		
		// Данные о заработке заполняем безусловно.
		АдресДанныхОЗаработкеВХранилище = Неопределено;
		Если ДанныеЗаполнения.Свойство("АдресДанныхОЗаработкеВХранилище", АдресДанныхОЗаработкеВХранилище) Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ПолучитьИзВременногоХранилища(АдресДанныхОЗаработкеВХранилище), ДанныеОЗаработке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетПособийСоциальногоСтрахованияРасширенный.ЗарегистрироватьДанныеСтрахователей(
	Движения, Отказ, Дата, Ссылка, Сотрудник, Страхователь, ДанныеПоГодам(), ПериодРаботыС, ПериодРаботыПо);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеПоГодам()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДанныеПоГодам.РасчетныйГод КАК Год,
	|	СУММА(ДанныеПоГодам.Заработок) КАК Сумма,
	|	СУММА(ДанныеПоГодам.ДнейБолезниУходаЗаДетьми) КАК ДнейБолезниУходаЗаДетьми
	|ИЗ
	|	Документ.ВходящаяСправкаОЗаработкеДляРасчетаПособий.ДанныеОЗаработке КАК ДанныеПоГодам
	|ГДЕ
	|	ДанныеПоГодам.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеПоГодам.РасчетныйГод");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли