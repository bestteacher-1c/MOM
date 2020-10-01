////////////////////////////////////////////////////////////////////////////////
//
// ИнтеграцияГИСМКлиентУТ: имплементация в УТ клиентской переопределяемой части интеграции с ГИСМ.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСПрикладнымиДокументами

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ТекстУведомленияОСписанииКиЗГИСМОбработкаНавигационнойСсылки.
//
Процедура ТекстУведомленияОСписанииКиЗГИСМОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		ОткрытьФорму("Документ.УведомлениеОСписанииКиЗГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;

КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ТекстЗаявкаНаВыпускКиЗОбработкаНавигационнойСсылки.
//
Процедура ТекстЗаявкаНаВыпускКиЗОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьЗаявкуНаВыпускКиЗ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		ОткрытьФорму("Документ.ЗаявкаНаВыпускКиЗГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ТекстУведомленияОбИмпортеВвозеИзЕАЭСОбработкаНавигационнойСсылки.
//
Процедура ТекстУведомленияОбИмпортеВвозеИзЕАЭСОбработкаНавигационнойСсылки(Форма, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПротоколОбмена" Тогда
		
		ИнтеграцияГИСМКлиент.ОткрытьПротоколОбмена(Форма.Объект.Ссылка, Форма);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "СоздатьУведомлениеГИСМ" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Основание", Форма.Объект.Ссылка);
		
		Если Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпорту") Тогда
			ОткрытьФорму("Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		ИначеЕсли Форма.Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС") Тогда
			ОткрытьФорму("Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Форма.ФормаДокумента", ПараметрыФормы, Форма);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах.
//
Функция ПараметрыОткрытияСпискаОтчетыОРозничныхПродажах() Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ИмяФормы", "Документ.ОтчетОРозничныхПродажах.Форма.ФормаСпискаГИСМ");
	СтруктураВозврата.Вставить("ОткрытьРаспоряжения", Ложь);
	СтруктураВозврата.Вставить("ИмяПоляОтветственный", "Ответственный");
	СтруктураВозврата.Вставить("ИмяПоляОрганизация", "Организация");
	
	Возврат СтруктураВозврата;
	
КонецФункции

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов.
//
Функция ПараметрыОткрытияСпискаВозвратыТоваровОтРозничныхКлиентов() Экспорт
	
	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ИмяФормы", "Документ.ВозвратТоваровОтКлиента.Форма.ФормаСпискаДокументовГИСМ");
	СтруктураВозврата.Вставить("ДальнейшееДействиеГИСМ", ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	СтруктураВозврата.Вставить("ОткрытьРаспоряжения", Ложь);
	СтруктураВозврата.Вставить("ИмяПоляОтветственный", "Менеджер");
	СтруктураВозврата.Вставить("ИмяПоляОрганизация", "Организация");
	
	Возврат СтруктураВозврата;
	
КонецФункции

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ЗаявкаНаВыпускКиЗЗаказанныеКиЗПриИзменении.
//
Процедура ЗаявкаНаВыпускКиЗЗаказанныеКиЗПриИзменении(Форма, КэшированныеЗначения, Элемент) Экспорт
	
	ТекущиеДанные = Форма.Элементы.ЗаказанныеКиЗ.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущиеДанные.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",
	                           Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, "ЗаказанныеКиЗ"));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ОткрытьФормуСпискаДокументов
//
Процедура ОткрытьФормуСпискаДокументов(СписокДокументов, Заголовок) Экспорт

	ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("СписокДокументов", СписокДокументов);
			ПараметрыФормы.Вставить("Заголовок", НСтр(Заголовок));
			
			ОткрытьФорму("ОбщаяФорма.ПросмотрСпискаДокументов",
			                ПараметрыФормы,
			                ЭтотОбъект);

КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ТоварыУведомлениеОбИмпортеНоменклатураКиЗПриИзменении.
//
Процедура ТоварыУведомлениеОбИмпортеНоменклатураКиЗПриИзменении(ТекущаяСтрока, КэшированныеЗначения) Экспорт
	
	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.ХарактеристикаКиЗ);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("НоменклатураКиЗ", "ХарактеристикиКиЗИспользуются"));
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);

КонецПроцедуры

// См. процедуру ИнтеграцияГИСМКлиентПереопределяемый.ТоварыУведомлениеОбИмпортеНоменклатураКиЗПриИзменении.
//
Процедура ОткрытьПодборЗаказываемыхКиЗ(Форма) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ",                          Форма.Объект.Ссылка);
	ПараметрыФормы.Вставить("Контрагент",                        Форма.Объект.Контрагент);
	ПараметрыФормы.Вставить("ОсобенностьУчета",                  ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КиЗГИСМ"));
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров", Истина);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки",              Истина);
	ПараметрыФормы.Вставить("Дата",                              Форма.Объект.Дата);
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументЗакупки.Форма", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор);
	
КонецПроцедуры

// См. функцию ИнтеграцияГИСМКлиентПереопределяемый.ИсточникВыбораЭтоФормаПодбора
//
Функция ИсточникВыбораЭтоФормаПодбора(ИсточникВыбора) Экспорт
	
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборТоваровВДокументЗакупки.Форма.Форма" Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецОбласти



