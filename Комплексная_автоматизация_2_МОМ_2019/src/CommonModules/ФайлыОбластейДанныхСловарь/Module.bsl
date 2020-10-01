
#Область СлужебныйПрограммныйИнтерфейс

Функция КорневоеСобытие() Экспорт
	
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Файлы областей данных'", КодЯзыка);
	
КонецФункции

Функция ФайлНеНайденПоИдентификатору() Экспорт
	Возврат НСтр("ru = 'Файл с идентификатором ''%1'' не найден.'");
КонецФункции

Функция ФайлНеНайденПоПолномуИмени() Экспорт
	Возврат НСтр("ru = 'Файл ''%1'' не найден.'");
КонецФункции

Функция ИмяФайлаДляСохраненияНеЗадано() Экспорт
	Возврат НСтр("ru = 'Не задано имя файла для сохранения.'");
КонецФункции

Функция ИнформацияОФайлеОтсутствует() Экспорт
	Возврат НСтр("ru = 'Отсутствует информация о файле.'");
КонецФункции

Функция НеверныйТипЗаданияФайла() Экспорт
	Возврат НСтр("ru = 'Неверный тип задания файла.'");
КонецФункции

Функция УдалениеФайлаИзХранилища() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Удаление файла из хранилища.'", КодЯзыка);
КонецФункции

Функция УдалениеФайлаТома() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Удаление файла тома'", КодЯзыка);	
КонецФункции

Функция УстановкаПризнакаВременный() Экспорт
	КодЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	Возврат НСтр("ru = 'Установка признака ''Временный''.'", КодЯзыка);
КонецФункции

Функция ПереданИдентификаторНекорректногоТипа() Экспорт 
	
	Возврат НСтр("ru = 'Передан идентификатор некорректного типа. Ожидается: УникальныйИдентификатор, получено: %1'");
	
КонецФункции

Функция НельзяЗаписыватьДанныеПриВключенномРазделенииБезУказанияРазделителя() Экспорт
	
	Возврат НСтр("ru = 'Нельзя записывать данные при включенном разделении без указания разделителя.'");
	
КонецФункции

#КонецОбласти 
