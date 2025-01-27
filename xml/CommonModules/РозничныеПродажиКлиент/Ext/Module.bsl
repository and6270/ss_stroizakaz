﻿
&ИзменениеИКонтроль("ЗакрытьКассовуюСмену")
Процедура Расш6270_ЗакрытьКассовуюСмену(ПараметрыКассыККМ, ОписаниеОповещенияЗавершение)

	Если (ТипЗнч(ПараметрыКассыККМ) = Тип("фиксированнаяСтруктура")
		Или ТипЗнч(ПараметрыКассыККМ) = Тип("Структура"))
		И ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования Тогда

		СформироватьОтчетОРозничныхПродажах(ПараметрыКассыККМ.КассаККМ);

		ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, Истина);

	Иначе

		ОборудованиеПодключено = Ложь;
		Если ТипЗнч(ПараметрыКассыККМ) = Тип("фиксированнаяСтруктура")
			Или ТипЗнч(ПараметрыКассыККМ) = Тип("Структура") Тогда
			ФискальноеУстройство = ПараметрыКассыККМ.ИдентификаторУстройства;
			ОборудованиеПодключено = МенеджерОборудованияУТКлиент.ОборудованиеПодключено(ФискальноеУстройство);
		Иначе
			ФискальноеУстройство   = ПараметрыКассыККМ;
			ОборудованиеПодключено = Истина;
		КонецЕсли;

		Контекст = Новый Структура;
		Контекст.Вставить("ФискальноеУстройство",         ФискальноеУстройство);
		Контекст.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);

		ПараметрыОперации = ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОткрытияЗакрытияСмены();

		#Удаление
		РеквизитыКассира = РозничныеПродажиВызовСервера.РеквизитыКассира();
		#КонецУдаления
		#Вставка
		РеквизитыКассира = РозничныеПродажиВызовСервера.РеквизитыКассира(,ПараметрыКассыККМ.Организация);
		#КонецВставки
		ПараметрыОперации.Кассир = РеквизитыКассира.Наименование;
		ПараметрыОперации.КассирИНН = РеквизитыКассира.ИНН;

		РеквизитыАдресаМестаРасчетов = РозничныеПродажиВызовСервера.РеквизитыАдресаМестаРасчетов(ФискальноеУстройство);
		ПараметрыОперации.АдресРасчетов = РеквизитыАдресаМестаРасчетов.АдресРасчетов;
		ПараметрыОперации.МестоРасчетов = РеквизитыАдресаМестаРасчетов.МестоРасчетов;

		ПараметрыОбработкиСостоянияСмены = РозничныеПродажиВызовСервера.ПолучитьПараметрыОбработкиСостоянияСмены(ФискальноеУстройство);
		Если ПараметрыОбработкиСостоянияСмены.СтруктураСостояниеКассовойСмены.РазъезднаяТорговля Тогда
			Если ЗначениеЗаполнено(ПараметрыОбработкиСостоянияСмены.СтруктураСостояниеКассовойСмены.АдресРасчетов) Тогда
				ПараметрыОперации.АдресРасчетов = ПараметрыОбработкиСостоянияСмены.СтруктураСостояниеКассовойСмены.АдресРасчетов;	
			КонецЕсли;
			Если ЗначениеЗаполнено(ПараметрыОбработкиСостоянияСмены.СтруктураСостояниеКассовойСмены.МестоРасчетов) Тогда
				ПараметрыОперации.МестоРасчетов = ПараметрыОбработкиСостоянияСмены.СтруктураСостояниеКассовойСмены.МестоРасчетов;	
			КонецЕсли;
		КонецЕсли;

		ОборудованиеЧекопечатающиеУстройстваКлиент.НачатьЗакрытиеСменыНаФискальномУстройстве(
		Новый ОписаниеОповещения("ПослеВыполненияКомандыЗакрытияСмены", ЭтотОбъект, Контекст),
		Новый УникальныйИдентификатор,
		ФискальноеУстройство,
		ПараметрыОперации);

	КонецЕсли;

КонецПроцедуры

&ИзменениеИКонтроль("ОткрытьКассовуюСмену")
Процедура Расш6270_ОткрытьКассовуюСмену(ПараметрыКассыККМ, ОписаниеОповещенияЗавершение)

	ПараметрыОповещенияЗавершенияОперации = Новый Структура;

	КассаККМ = Неопределено;
	КассаККМДляРазъезднойТорговли = Ложь;
	КассаККМБезПодключенияОборудования = Ложь;

	Если (ТипЗнч(ПараметрыКассыККМ) = Тип("фиксированнаяСтруктура")
		Или ТипЗнч(ПараметрыКассыККМ) = Тип("Структура"))
		И ПараметрыКассыККМ.ИспользоватьБезПодключенияОборудования Тогда

		КассаККМБезПодключенияОборудования = Истина;
		КассаККМ = ПараметрыКассыККМ.КассаККМ;
		КассаККМДляРазъезднойТорговли = ПараметрыКассыККМ.РазъезднаяТорговля;

	Иначе

		КассаККМБезПодключенияОборудования = Ложь;
		Если ТипЗнч(ПараметрыКассыККМ) = Тип("фиксированнаяСтруктура")
			Или ТипЗнч(ПараметрыКассыККМ) = Тип("Структура") Тогда
			ФискальноеУстройство = ПараметрыКассыККМ.ИдентификаторУстройства;
		Иначе
			ФискальноеУстройство = ПараметрыКассыККМ;
		КонецЕсли;

		ПараметрыОповещенияЗавершенияОперации.Вставить("ФискальноеУстройство", ФискальноеУстройство);
		#Удаление
		ПараметрыОповещенияЗавершенияОперации.Вставить("РеквизитыКассира", РозничныеПродажиВызовСервера.РеквизитыКассира());
		#КонецУдаления
		#Вставка
		ПараметрыОповещенияЗавершенияОперации.Вставить("РеквизитыКассира", РозничныеПродажиВызовСервера.РеквизитыКассира(,ПараметрыКассыККМ.Организация));
		#КонецВставки
		ПараметрыОповещенияЗавершенияОперации.Вставить("РеквизитыАдресаМестаРасчетов", РозничныеПродажиВызовСервера.РеквизитыАдресаМестаРасчетов(ФискальноеУстройство));

		КассаККМ = РозничныеПродажиВызовСервера.КассаККМПоПодключаемомуОборудованияДляРМК(ФискальноеУстройство);
		Если ЗначениеЗаполнено(КассаККМ) Тогда
			ПараметрыКассыККМФискальногоУстройства = РозничныеПродажиВызовСервера.ПараметрыКассыККМ(КассаККМ);
			КассаККМДляРазъезднойТорговли = ПараметрыКассыККМФискальногоУстройства.РазъезднаяТорговля;
		КонецЕсли;

	КонецЕсли;

	ПараметрыОповещенияЗавершенияОперации.Вставить("КассаККМБезПодключенияОборудования", КассаККМБезПодключенияОборудования);
	ПараметрыОповещенияЗавершенияОперации.Вставить("КассаККМ", КассаККМ);	
	ПараметрыОповещенияЗавершенияОперации.Вставить("ПараметрыКассыККМ", ПараметрыКассыККМ);
	ПараметрыОповещенияЗавершенияОперации.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);

	ОповещениеЗавершенияОперации = Новый ОписаниеОповещения("ОткрытьКассовуюСменуЗавершение", ЭтотОбъект, ПараметрыОповещенияЗавершенияОперации);
	Если КассаККМДляРазъезднойТорговли Тогда
		ПараметрыОткрытияФормы = Новый Структура;
		ОткрытьФорму("Документ.КассоваяСмена.Форма.ФормаЗапросаМестаРасчетов",
		ПараметрыОткрытияФормы,
		,
		,
		,
		,
		ОповещениеЗавершенияОперации,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеЗавершенияОперации, Неопределено);
	КонецЕсли;

КонецПроцедуры
