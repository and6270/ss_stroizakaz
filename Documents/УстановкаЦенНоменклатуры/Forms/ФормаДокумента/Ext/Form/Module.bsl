﻿&НаСервере
Процедура ЗаполнитьСтрокиНаСервере(ЗаполняемыйВидЦен) Экспорт
	
	Колонки = "Номенклатура,Характеристика,Упаковка,Цена";		
	ТаблицаТоваров = РаботаСТабличнымиЧастями.СтрокиИзБуфераОбмена(, Колонки);
	
	Если Не ЗначениеЗаполнено(ТаблицаТоваров) Или ТаблицаТоваров.Колонки.Найти("Номенклатура") = Неопределено Тогда
		Возврат;
	КонецЕсли;			
	Если ТаблицаТоваров.Колонки.Найти("Характеристика") = Неопределено Тогда
			ТаблицаТоваров.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;

	Если ТаблицаТоваров.Колонки.Найти("Цена") = Неопределено Тогда
		ТаблицаТоваров.Колонки.Добавить("Цена", Новый ОписаниеТипов("Число"));
	КонецЕсли;

	УстановкаЦенСервер.ДобавитьТоварыПоОтбору(ЭтаФорма, Неопределено, ТаблицаТоваров, ЗаполняемыйВидЦен);
	
КонецПроцедуры