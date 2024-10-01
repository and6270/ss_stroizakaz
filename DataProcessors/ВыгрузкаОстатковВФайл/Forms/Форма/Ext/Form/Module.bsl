﻿
&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНаСервере(ЭтаФорма.Дата);
	Сообщить("ВсеОК");
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНаСервере(Дата)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТоварыНаСкладахОстатки.Номенклатура.Код КАК Код,
	|	ТоварыНаСкладахОстатки.Номенклатура.Наименование КАК Наименование,
	|	ТоварыНаСкладахОстатки.ВНаличииОстаток КАК НаСкладе
	|ИЗ
	|	РегистрНакопления.ТоварыНаСкладах.Остатки(&Дата, Склад.Наименование <> ""Интернет"") КАК ТоварыНаСкладахОстатки";
	Запрос.УстановитьПараметр("Дата", Дата); 
	
	// ТЗ = Новый ТаблицаЗначений;
	ТЗ = Запрос.Выполнить().Выгрузить();
	ЗначениеВФайл("/tmp/ostatki.txt", ТЗ);
	КонецПроцедуры
