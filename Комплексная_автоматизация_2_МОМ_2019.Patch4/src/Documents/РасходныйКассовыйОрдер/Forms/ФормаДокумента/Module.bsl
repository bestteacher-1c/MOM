
&НаКлиенте
Процедура bt_Patch4_КассаПриИзмененииПосле(Элемент)

	ПолучитьКассираОрганизации();
	
КонецПроцедуры

&НаСервере
Процедура bt_Patch4_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)

	ПолучитьКассираОрганизации();
	
КонецПроцедуры


// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервере
Процедура ПолучитьКассираОрганизации()
	
	Организация = Справочники.Организации.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Кассы.Владелец КАК Организация
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|ГДЕ
		|	Кассы.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Касса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		Организация = ВыборкаДетальныеЗаписи.Организация;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Организация) = Истина Тогда
		
		ФизическоеЛицо = ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(Организация,,Перечисления.ОтветственныеЛицаОрганизаций.Кассир).ФизическоеЛицо;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Пользователи.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.ФизическоеЛицо = &ФизическоеЛицо";
		
		Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицо);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Следующий() Тогда
			
			Объект.Кассир = ВыборкаДетальныеЗаписи.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры // ПолучитьКассираОрганизации()

