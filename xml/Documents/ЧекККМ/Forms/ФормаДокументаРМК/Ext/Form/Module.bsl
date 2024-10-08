﻿
&НаКлиенте
Процедура Расш6270_ЗаполнитьИзЗаказаПосле(Команда)
		Оп = Новый ОписаниеОповещения("Расш6270_ПослеВыбораДокументаЗаказаКлиента",ЭтотОбъект);
	ОткрытьФорму("Документ.ЗаказКлиента.ФормаВыбора",,ЭтотОбъект, ЭтотОбъект.УникальныйИдентификатор,,,Оп);
КонецПроцедуры

&НаКлиенте
Процедура Расш6270_ПослеВыбораДокументаЗаказаКлиента(Заказ, ДополнительныеПараметры) Экспорт
	Если Заказ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Расш6270_ЗаполнитьККМИзЗаказаНаСервере(Заказ);
	ПересчитатьДокументНаКлиенте(); //не уверен
КонецПроцедуры

&НаСервере
Процедура Расш6270_ЗаполнитьККМИзЗаказаНаСервере(Заказ)
	Кассир = Объект.Кассир; 
	СтавкаНДС =  Справочники.СтавкиНДС.БезНДС; // Всегда без НДС
	Объект.Товары.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаказКлиентаТовары.Номенклатура КАК Номенклатура,
		|	ЗаказКлиентаТовары.Цена КАК Цена,
		|	ЗаказКлиентаТовары.СуммаСНДС КАК Сумма,
		|	ЗаказКлиентаТовары.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
		|	ЗаказКлиентаТовары.Количество КАК Количество,
		|	ЗаказКлиентаТовары.КоличествоУпаковок КАК КоличествоУпаковок
		|ИЗ
		|	Документ.ЗаказКлиента.Товары КАК ЗаказКлиентаТовары
		|ГДЕ
		|	ЗаказКлиентаТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Заказ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар Тогда
			Строка = Объект.Товары.Добавить();
		    ЗаполнитьЗначенияСвойств(Строка,Выборка);
			Строка.СтавкаНДС = СтавкаНДС;
			Строка.Продавец  = Кассир;
		Иначе
			Сообщить("Позиция " + Выборка.Номенклатура + " не добавлена, т.к не является товаром");
		КонецЕсли;		
	КонецЦикла;
КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ИзменитьКассуККМ")
Процедура Расш6270_ИзменитьКассуККМ(КассаККМ)
#Удаление

	Объект.КассаККМ = КассаККМ;
	ПараметрыКассыККМ = Новый ФиксированнаяСтруктура(Справочники.КассыККМ.ПараметрыКассыККМ(Объект.КассаККМ));
	ВерсияФФД = МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетВерсиюФФД(ПараметрыКассыККМ.ИдентификаторУстройства);

	НовыйЧекНаСервере();
#КонецУдаления
#Вставка
// Здесь можно описать новое поведение.
    // Вставить содержимое метода.
	ПереносимТовары = Ложь;
	Если Объект.Статус <> Перечисления.СтатусыЧековККМ.Пробит И Объект.Товары.Количество() Тогда
		тов = Объект.Товары.Выгрузить();	
		ПереносимТовары = Истина;
	КонецЕсли;

	Объект.КассаККМ = КассаККМ;
	ПараметрыКассыККМ = Новый ФиксированнаяСтруктура(Справочники.КассыККМ.ПараметрыКассыККМ(Объект.КассаККМ));
	ВерсияФФД = МенеджерОборудованияВызовСервера.ФискальноеУстройствоПоддерживаетВерсиюФФД(ПараметрыКассыККМ.ИдентификаторУстройства);

	НовыйЧекНаСервере();
	
	Если ПереносимТовары Тогда 
		Объект.Товары.Загрузить(тов);
	КонецЕсли;

#КонецВставки

КонецПроцедуры

&НаСервере
&ИзменениеИКонтроль("ОбновитьЗаголовокФормы")
Процедура Расш6270_ОбновитьЗаголовокФормы()
#Удаление

	Заголовок = НСтр("ru = 'Продажа (Кассир: %Кассир%, Продавец: %Продавец%)'");
	Заголовок = СтрЗаменить(Заголовок, "%Кассир%", Объект.Кассир);
	Заголовок = СтрЗаменить(Заголовок, "%Продавец%", ?(ЗначениеЗаполнено(ТекущийПродавец),ТекущийПродавец, НСтр("ru='<Не выбран>'")));

#КонецУдаления
#Вставка
// Здесь можно описать новое поведение.
    Заголовок = НСтр("ru = 'Продажа (Касса: %Кассир%, Продавец: %Продавец%)'");
	Заголовок = СтрЗаменить(Заголовок, "%Кассир%", Объект.Организация);
	Заголовок = СтрЗаменить(Заголовок, "%Продавец%", ?(ЗначениеЗаполнено(ТекущийПродавец),ТекущийПродавец, НСтр("ru='<Не выбран>'")));
	//Меняем цвет фона командной панели
	Если Объект.Организация.ИНН = "312261201888" Тогда
		Элементы.ГруппаВерхняяКоманднаяПанель.ЦветФона = WebЦвета.БледноЗеленый;
	Иначе
		Элементы.ГруппаВерхняяКоманднаяПанель.ЦветФона = WebЦвета.ТусклоРозовый;
	КонецЕсли;
#КонецВставки
КонецПроцедуры

