#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипДанныхЗаполнения = Метаданные.НайтиПоТипу(ТипЗнч(ДанныеЗаполнения));
	Если ТипДанныхЗаполнения <> Неопределено
		И Метаданные.Документы.УдалитьПроизвольныйЭД.ВводитсяНаОсновании.Содержит(ТипДанныхЗаполнения) Тогда
		
		Если ЗначениеЗаполнено(Ссылка) И Направление  = Перечисления.НаправленияЭД.Исходящий
			И (СтатусДокумента = Перечисления.СтатусыЭД.Сформирован
				ИЛИ СтатусДокумента = Перечисления.СтатусыЭД.Подписан
				ИЛИ СтатусДокумента = Перечисления.СтатусыЭД.ПодготовленКОтправке) Тогда
			МожноРедактироватьПередаваемыеПараметры = Истина;
		Иначе
			МожноРедактироватьПередаваемыеПараметры = НЕ ЗначениеЗаполнено(Ссылка); // Если документ еще не записан, то можно редактировать.
		КонецЕсли;
		
		ОснованиеСсылка = ДанныеЗаполнения;
		Если МожноРедактироватьПередаваемыеПараметры Тогда
			Направление  = Перечисления.НаправленияЭД.Исходящий;
			ТребуетсяПодтверждение = Истина;
			ТипДокумента = Перечисления.ТипыЭД.Прочее;
			Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УдалитьПроизвольныйЭД") Тогда
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения,
					"Контрагент, Организация, ДоговорКонтрагента, ТипДокумента, ТребуетсяПодтверждение");
				ТипДокумента			= СтруктураРеквизитов.ТипДокумента;
				ТребуетсяПодтверждение	= СтруктураРеквизитов.ТребуетсяПодтверждение;
				Контрагент				= СтруктураРеквизитов.Контрагент;
				Организация				= СтруктураРеквизитов.Организация;
				ДоговорКонтрагента		= СтруктураРеквизитов.ДоговорКонтрагента;
			Иначе
				Если СтрНайти(ДанныеЗаполнения.Метаданные().ПолноеИмя(), "ПрисоединенныеФайлы") > 0 Тогда
					ОснованиеСсылка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеЗаполнения, "ВладелецФайла");
					ПоместитьВложениеВоВременноеХранилище(ДанныеЗаполнения, ОснованиеСсылка);
				Иначе
					ОснованиеСсылка = ДанныеЗаполнения;
				КонецЕсли;
				СтруктураРеквизитов = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(ОснованиеСсылка);
				Если ТипЗнч(СтруктураРеквизитов) = Тип("Структура") Тогда
					Если ЗначениеЗаполнено(СтруктураРеквизитов.Контрагент) И Контрагент <> СтруктураРеквизитов.Контрагент Тогда
						Контрагент = СтруктураРеквизитов.Контрагент;
					КонецЕсли;
					Если ЗначениеЗаполнено(СтруктураРеквизитов.Организация) И Организация <> СтруктураРеквизитов.Организация Тогда
						Организация = СтруктураРеквизитов.Организация;
					КонецЕсли;
					Если ЗначениеЗаполнено(СтруктураРеквизитов.ДоговорКонтрагента) И ДоговорКонтрагента <> СтруктураРеквизитов.ДоговорКонтрагента Тогда
						ДоговорКонтрагента = СтруктураРеквизитов.ДоговорКонтрагента;
					КонецЕсли;
				КонецЕсли;
				Если ДанныеЗаполнения.Метаданные().Имя = "УдалитьСоглашенияОбИспользованииЭД" Тогда
					ТипДокумента = Перечисления.ТипыЭД.СоглашениеОбЭДО;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		ДокументОснование = ОснованиеСсылка;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоместитьВложениеВоВременноеХранилище(ПрисоединенныйФайлСсылка, ВладелецФайла)
	
	СтруктураФайла = РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайлСсылка, Новый УникальныйИдентификатор);
	СтруктураФайла.Вставить("ОтносительныйПуть", "");
	АдресХранилища = ПоместитьВоВременноеХранилище(СтруктураФайла, Новый УникальныйИдентификатор);
	ОбменСКонтрагентамиСлужебный.ПоместитьПараметрВПараметрыКлиентаНаСервере(ВладелецФайла, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли