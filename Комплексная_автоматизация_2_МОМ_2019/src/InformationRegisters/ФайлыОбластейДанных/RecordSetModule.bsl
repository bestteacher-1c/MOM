#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
    
#Область ОбработчикиСобытий
    
Процедура ПередЗаписью(Отказ, Замещение)
    
    Если ОбменДанными.Загрузка Тогда
        Возврат;
    КонецЕсли;
	
	Словарь = ФайлыОбластейДанныхСловарь;
    
    Если Количество() > 0 И Не РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
        ВызватьИсключение Словарь.НельзяЗаписыватьДанныеПриВключенномРазделенииБезУказанияРазделителя();
    КонецЕсли; 
    
    Сейчас = ТекущаяУниверсальнаяДата();
    
    Для Каждого Запись Из ЭтотОбъект Цикл
        Запись.ДатаФайла = Сейчас;
    КонецЦикла;
    
КонецПроцедуры

#КонецОбласти 

#КонецЕсли