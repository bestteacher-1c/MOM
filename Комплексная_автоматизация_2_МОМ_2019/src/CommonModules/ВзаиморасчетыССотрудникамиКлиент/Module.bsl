#Область ПрограммныйИнтерфейс

// Возвращает имя события оповещения об изменении состояния оплаты ведомости на выплату зарплаты.
// Уместно использовать в платежных документах в вызовах Оповестить:
// 	Оповестить(ВзаиморасчетыССотрудникамиКлиент.ИмяСобытияИзмененияОплатыВедомости());
//
// Возвращаемое значение:
// 	Строка - имя события
//
Функция ИмяСобытияИзмененияОплатыВедомости() Экспорт
	Возврат "ИзменениеОплатыВедомости"
КонецФункции

#КонецОбласти