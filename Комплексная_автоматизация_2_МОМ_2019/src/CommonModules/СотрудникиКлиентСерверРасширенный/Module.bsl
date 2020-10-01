#Область СлужебныеПроцедурыИФункции

#Область ОбработчикиСобытийМодуляМенеджера

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Наименование");
	Поля.Добавить("УточнениеНаименования");
	Поля.Добавить("ФизическоеЛицо");
	Поля.Добавить("Ссылка");
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДополнительнымиФормами

Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	ОписаниеФормы = СотрудникиКлиентСервер.ОбщееОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
	Если ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.ВыплатаЗарплаты" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ДатаПриема");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущееПодразделение");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "Сотрудник.Наименование");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектам");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ЛицевыеСчетаСотрудниковПоЗарплатнымПроектамПрежняя");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("МестаВыплатыЗарплатыПодразделений");
		ОписаниеФормы.ДополнительныеДанные.Вставить("МестаВыплатыЗарплатыПодразделенийПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("МестаВыплатыЗарплатыСотрудников");
		ОписаниеФормы.ДополнительныеДанные.Вставить("МестаВыплатыЗарплатыСотрудниковПрочитан");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудников");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("БухучетЗарплатыСотрудниковПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.ДоговорыГПХ" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.НачисленияИУдержания" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.Сотрудники.Форма.Отсутствия" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.Страхование" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ГоловнаяОрганизация", "Сотрудник.ГоловнаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ТекущаяОрганизация");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СозданиеНового");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СтудентРаботающийВСтудотряде", "Сотрудник.СтудентРаботающийВСтудотряде");
		
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ЛьготаПриНачисленииПособий", "ФизическоеЛицо.ЛьготаПриНачисленииПособий");
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ПостоянноПроживалВКрыму18Марта2014Года", "ФизическоеЛицо.ПостоянноПроживалВКрыму18Марта2014Года");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("НаборЗаписейВременноПребывающиеПринятыеПоДолгосрочнымДоговорам");
		ОписаниеФормы.ДополнительныеДанные.Вставить("НаборЗаписейВременноПребывающиеПринятыеПоДолгосрочнымДоговорамПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОбИнвалидностиФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОбИнвалидностиФизическихЛицНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОбИнвалидностиФизическихЛицНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОбИнвалидностиФизическихЛицНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОбИнвалидностиФизическихЛицПрежняя");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыЗастрахованныхФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыЗастрахованныхФизическихЛицНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыЗастрахованныхФизическихЛицНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыЗастрахованныхФизическихЛицНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтатусыЗастрахованныхФизическихЛицПрежняя");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭС");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СведенияОЛьготахФизическихЛицПострадавшихВАварииЧАЭСПрочитан");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.ВоинскийУчет" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВоинскийУчет");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВоинскийУчетНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВоинскийУчетНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВоинскийУчетНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВоинскийУчетПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.Семья" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("СостоянияВБракеФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СостоянияВБракеФизическихЛицНаборЗаписей");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СостоянияВБракеФизическихЛицНаборЗаписейПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СостоянияВБракеФизическихЛицНоваяЗапись");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СостоянияВБракеФизическихЛицПрежняя");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.ТрудоваяДеятельность" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
		ОписаниеФормы.ДополнительныеДанные.Вставить("НаградыФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("НаградыФизическихЛицПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтажиФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("СтажиФизическихЛицПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ТрудоваяДеятельностьФизическихЛиц");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ТрудоваяДеятельностьФизическихЛицПрочитан");
		ОписаниеФормы.ДополнительныеДанные.Вставить("ВидыСтажаТрудовойДеятельностиФизическихЛиц");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.Справки" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
	ИначеЕсли ИмяОткрываемойФормы = "Справочник.ФизическиеЛица.Форма.ОбразованиеКвалификация" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("ФизическоеЛицоСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ИмеетИзобретения", "ФизическоеЛицо.ИмеетИзобретения");
		ОписаниеФормы.РеквизитыОбъекта.Вставить("ИмеетНаучныеТруды", "ФизическоеЛицо.ИмеетНаучныеТруды");
		
	ИначеЕсли ИмяОткрываемойФормы = "ОбщаяФорма.СОТП" Тогда
		
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("СотрудникСсылка");
		ОписаниеФормы.КлючевыеРеквизиты.Вставить("Заголовок", "ФизическоеЛицо.Наименование");
		
	Иначе
		
		СтандартнаяОбработка = Истина;
		
		Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ГосударственнаяСлужбаКлиентСервер");
			Модуль.ДополнитьОписаниеДополнительнойФормыСотрудника(ОписаниеФормы, ИмяОткрываемойФормы, СтандартнаяОбработка);
		КонецЕсли;
		
		Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ОхранаТруда") Тогда
			Модуль = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ОхранаТрудаКлиентСервер");
			Модуль.ДополнитьОписаниеДополнительнойФормыСотрудника(ОписаниеФормы, ИмяОткрываемойФормы, СтандартнаяОбработка);
		КонецЕсли;
		
		Если СтандартнаяОбработка Тогда
			ОписаниеФормы = СотрудникиКлиентСерверБазовый.ОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОписаниеФормы;
	
КонецФункции

#КонецОбласти

#Область ФормированиеПредставления

Функция ПредставлениеСотрудникаПоДаннымФормыСотрудника(Форма) Экспорт
	
	ДанныеДляФормированияПредставления = Новый Структура;
	
	ДанныеДляФормированияПредставления.Вставить("ПравилоФормированияПредставления", Форма.ПравилоФормированияПредставления());
	
	ФИО = Новый Структура("Фамилия,Имя,Отчество");
	ЗаполнитьЗначенияСвойств(ФИО, Форма.ФизическоеЛицо);
	
	ДанныеДляФормированияПредставления.Вставить("ФИО", ФИО);
	ДанныеДляФормированияПредставления.Вставить("ФИОПолные", Форма.ФизическоеЛицо.ФИО);
	ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияФизическогоЛица", Форма.ФизическоеЛицо.УточнениеНаименования);
	ДанныеДляФормированияПредставления.Вставить("УточнениеНаименованияСотрудника", Форма.Сотрудник.УточнениеНаименования);
	
	ДанныеДляФормированияПредставления.Вставить("Организация", Форма.ТекущаяОрганизация);
	ДанныеДляФормированияПредставления.Вставить("ВидЗанятости", Форма.ТекущийВидЗанятости);
	ДанныеДляФормированияПредставления.Вставить("ДатаУвольнения", Форма.ДатаУвольнения);
	
	Возврат ПредставлениеЭлемента(ДанныеДляФормированияПредставления);
	
КонецФункции

Функция ПредставлениеЭлемента(ДанныеДляФормированияПредставления) Экспорт
	
	ПравилоФормированияПредставления = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("ПравилоФормированияПредставления", ПравилоФормированияПредставления);
	
	ФИОПолные = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("ФИОПолные", ФИОПолные);
	
	ФИО = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("ФИО", ФИО);
	
	Если Не ЗначениеЗаполнено(ФИО) Тогда
		ФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИОПолные);
	КонецЕсли;
	
	ВидЗанятости = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("ВидЗанятости", ВидЗанятости);
	
	РольСотрудникаДоговорник = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("РольСотрудникаДоговорник", РольСотрудникаДоговорник);
	
	ДатаУвольнения = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("ДатаУвольнения", ДатаУвольнения);
	
	УточнениеНаименованияФизическогоЛица = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("УточнениеНаименованияФизическогоЛица", УточнениеНаименованияФизическогоЛица);
	
	УточнениеНаименованияСотрудника = Неопределено;
	ДанныеДляФормированияПредставления.Свойство("УточнениеНаименованияСотрудника", УточнениеНаименованияСотрудника);
	
	Если ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОДополнение") Тогда
		
		Представление = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
		ПредставлениеВидаЗанятости = "";
		ПредставлениеУволенности = "";
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоДополнение")
		Или Не ЗначениеЗаполнено(ПравилоФормированияПредставления) Тогда
		
		Представление = ФИОПолные;
		ПредставлениеВидаЗанятости = "";
		ПредставлениеУволенности = "";
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОВидЗанятостиДополнение") Тогда
		
		Представление = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
		ПредставлениеВидаЗанятости = ПредставлениеВидаЗанятости(ВидЗанятости, РольСотрудникаДоговорник);
		ПредставлениеУволенности = "";
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоВидЗанятостиДополнение") Тогда
		
		Представление = ФИОПолные;
		ПредставлениеВидаЗанятости = ПредставлениеВидаЗанятости(ВидЗанятости, РольСотрудникаДоговорник);
		ПредставлениеУволенности = "";
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОВидЗанятостиУволенДополнение") Тогда
		
		Представление = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
		ПредставлениеВидаЗанятости = ПредставлениеВидаЗанятости(ВидЗанятости, РольСотрудникаДоговорник);
		ПредставлениеУволенности = ПредставлениеУволенности(ДатаУвольнения);
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоВидЗанятостиУволенДополнение") Тогда
		
		Представление = ФИОПолные;
		ПредставлениеВидаЗанятости = ПредставлениеВидаЗанятости(ВидЗанятости, РольСотрудникаДоговорник);
		ПредставлениеУволенности = ПредставлениеУволенности(ДатаУвольнения);
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИОУволенДополнение") Тогда
		
		Представление = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ФамилияИнициалы(ФИО);
		ПредставлениеВидаЗанятости = "";
		ПредставлениеУволенности = ПредставлениеУволенности(ДатаУвольнения);
		
	ИначеЕсли ПравилоФормированияПредставления = ПредопределенноеЗначение("Перечисление.ВариантыПравилФормированияПредставленияЭлементовСправочникаСотрудники.ФамилияИмяОтчествоУволенДополнение") Тогда
		
		Представление = ФИОПолные;
		ПредставлениеВидаЗанятости = "";
		ПредставлениеУволенности = ПредставлениеУволенности(ДатаУвольнения);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Представление) Тогда
		Представление = "";
	КонецЕсли;
	
	ПредставлениеВидаЗанятостиУволенности = "";
	Если Не ПустаяСтрока(ПредставлениеВидаЗанятости) Тогда
		ПредставлениеВидаЗанятостиУволенности = ПредставлениеВидаЗанятости;
	КонецЕсли; 
	
	Если Не ПустаяСтрока(ПредставлениеУволенности) Тогда
		ПредставлениеВидаЗанятостиУволенности = ?(ПустаяСтрока(ПредставлениеВидаЗанятостиУволенности), "", ПредставлениеВидаЗанятостиУволенности + ", ") + ПредставлениеУволенности;
	КонецЕсли; 
	
	Если Не ПустаяСтрока(ПредставлениеВидаЗанятостиУволенности) Тогда
		Представление = Представление + " (" + ПредставлениеВидаЗанятостиУволенности + ")";
	КонецЕсли; 
	
	Если Не ПустаяСтрока(УточнениеНаименованияФизическогоЛица) Тогда
		Представление = Представление + " " + УточнениеНаименованияФизическогоЛица;
	КонецЕсли; 
	
	Если Не ПустаяСтрока(УточнениеНаименованияСотрудника) Тогда
		Представление = Представление + " " + УточнениеНаименованияСотрудника;
	КонецЕсли; 
	
	Возврат Представление; 
	
КонецФункции

Функция ПредставлениеВидаЗанятости(ВидЗанятости, РольСотрудникаДоговорник)
	
	Представление = "";
	
	Если ЗначениеЗаполнено(ВидЗанятости) Тогда
		
		Если ВидЗанятости = ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ВнутреннееСовместительство") Тогда
			Представление = НСтр("ru='вн. совм'") + ".";
		КонецЕсли;
		
	ИначеЕсли РольСотрудникаДоговорник = Истина Тогда
		Представление = НСтр("ru='дог'") + ".";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ПредставлениеУволенности(ДатаУвольнения)
	
	Представление = "";
	
	Если ЗначениеЗаполнено(ДатаУвольнения) Тогда
		Представление = НСтр("ru='ув'") + ".";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции


#КонецОбласти


Процедура УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным) Экспорт
	
	ВидимостьГруппы = Ложь;
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.БронированиеКомандировок") Тогда
		МодульБронированиеКомандировокКлиентСервер = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("БронированиеКомандировокКлиентСервер");
		МодульБронированиеКомандировокКлиентСервер.ОпределитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным, ВидимостьГруппы);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ГруппаФамилияИмяЛатиницей",
		"Видимость",
		ВидимостьГруппы);
		
КонецПроцедуры


Процедура УстановитьИнформациюОДругихРоляхФизическогоЛица(Форма) Экспорт
	
	ИнфоТекст = "";
	МассивОписанийРолей = Новый Массив;
	
	Если Форма.РолиФизическогоЛица.Количество() > 0 Тогда
		
		ЯвляетсяАкционером = Форма.РолиФизическогоЛица.НайтиСтроки(Новый Структура("Роль", ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.Акционер"))).Количество() > 0;
		ПолучаетДоходПоИнымДоговорам = Форма.РолиФизическогоЛица.НайтиСтроки(Новый Структура("Роль", ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.ПрочийПолучательДоходов"))).Количество() > 0;
		БывшийСотрудник = Форма.РолиФизическогоЛица.НайтиСтроки(Новый Структура("Роль", ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.БывшийСотрудник"))).Количество() > 0;
		РаздатчикЗарплаты = Форма.РолиФизическогоЛица.НайтиСтроки(Новый Структура("Роль", ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.РаздатчикЗарплаты"))).Количество() > 0;
		
		Если ЯвляетсяАкционером Тогда
			МассивОписанийРолей.Добавить(НСтр("ru='является акционером'"));
		КонецЕсли;
		
		Если ПолучаетДоходПоИнымДоговорам Тогда
			МассивОписанийРолей.Добавить(НСтр("ru='получает доход по прочим договорам'"));
		КонецЕсли;
		
		Если БывшийСотрудник Тогда
			МассивОписанийРолей.Добавить(НСтр("ru='является бывшим сотрудником'"));
		КонецЕсли;
		
		Если РаздатчикЗарплаты Тогда
			МассивОписанийРолей.Добавить(НСтр("ru='является раздатчиком зарплаты'"));
		КонецЕсли;
		
	КонецЕсли;
	
	Если МассивОписанийРолей.Количество() > 0 Тогда
		
		ИнфоТекст = "%1 " + МассивОписанийРолей[0];
		
		Если МассивОписанийРолей.Количество() > 1 Тогда
			ИнфоТекст = ИнфоТекст + ", " + НСтр("ru='а также'") + " " + МассивОписанийРолей[1];
		КонецЕсли;
		
		Если МассивОписанийРолей.Количество() > 2 Тогда
			
			Если МассивОписанийРолей.Количество() > 3 Тогда
				ИнфоТекст = ИнфоТекст + ", " + МассивОписанийРолей[2] + " " + НСтр("ru='и'") + " " + МассивОписанийРолей[3];
			Иначе
				ИнфоТекст = ИнфоТекст + " " + НСтр("ru='и'") + " " + МассивОписанийРолей[2];
			КонецЕсли;
			
		КонецЕсли;
		
		ДругиеРолиИнфоТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ИнфоТекст,
			Форма.ФизическоеЛицоСсылка);
		
	Иначе
		
		Если Форма.ОднаОрганизация Тогда
			ИнфоТекст = НСтр("ru='%1 не имеет других взаимоотношений с нашей организацией.'");
		Иначе
			ИнфоТекст = НСтр("ru='%1 не имеет других взаимоотношений с нашими организациями.'");
		КонецЕсли;
		
		ДругиеРолиИнфоТекст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ИнфоТекст,
			Форма.ФизическоеЛицоСсылка);
		
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма, "ДругиеРолиРасшифровкаГруппа", ДругиеРолиИнфоТекст);
	
	КоличествоОписаний = 0;
	КоличествоПеречисляемыхРолей = 15;
	
	Для каждого РольФизическогоЛица Из Форма.РолиФизическогоЛица Цикл
		
		ОписаниеРоли = "";
		Если РольФизическогоЛица.Роль = ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.Акционер") Тогда
			ОписаниеРоли = НСтр("ru='Акционер %1'");
		ИначеЕсли РольФизическогоЛица.Роль = ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.ПрочийПолучательДоходов") Тогда
			ОписаниеРоли = НСтр("ru='Получает доход  по прочим договорам в %1'");
		ИначеЕсли РольФизическогоЛица.Роль = ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.БывшийСотрудник") Тогда
			ОписаниеРоли = НСтр("ru='Бывший сотрудник %1'");
		ИначеЕсли РольФизическогоЛица.Роль = ПредопределенноеЗначение("Перечисление.РолиФизическихЛиц.РаздатчикЗарплаты") Тогда
			ОписаниеРоли = НСтр("ru='Раздатчик зарплаты в %1'");
		КонецЕсли;
		
		Если Не ПустаяСтрока(ОписаниеРоли) Тогда
			
			КоличествоОписаний = КоличествоОписаний + 1;
			
			Форма["ДругиеРолиРасшифровка" + КоличествоОписаний] = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ОписаниеРоли,
				РольФизическогоЛица.Организация);
			
			Форма.Элементы["ДругиеРолиРасшифровка" + КоличествоОписаний].Видимость = Истина;
			
			Если КоличествоОписаний >= КоличествоПеречисляемыхРолей Тогда
				Прервать;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерОписания = КоличествоОписаний + 1 По КоличествоПеречисляемыхРолей Цикл
		Форма.Элементы["ДругиеРолиРасшифровка" + НомерОписания].Видимость = Ложь;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРазмерМесяцевСтрокиСтажа(СтрокаСтажа) Экспорт
	СтрокаСтажа.РазмерМесяцев = ВсегоМесяцевПоСтрокеСтажа(СтрокаСтажа);
КонецПроцедуры

Функция ВсегоМесяцевПоСтрокеСтажа(СтрокаСтажа) Экспорт
	
	Возврат СтрокаСтажа.Месяцев + СтрокаСтажа.Лет * 12;;
	
КонецФункции

Функция ПользовательскиеОтборы(Список) Экспорт
	
	Для каждого ЭлементПользовательскихНастроек Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		
		Если ТипЗнч(ЭлементПользовательскихНастроек) = Тип("ОтборКомпоновкиДанных") Тогда
			Возврат ЭлементПользовательскихНастроек.Элементы;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
