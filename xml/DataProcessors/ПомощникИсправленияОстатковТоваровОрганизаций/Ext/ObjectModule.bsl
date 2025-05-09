﻿
&ИзменениеИКонтроль("ЗаполнитьМесяцИсправления")
Процедура Расш6270_ЗаполнитьМесяцИсправления()

	МесяцИсправления                          = Неопределено;
	КоличествоПозицийОтрицательныйОстатокБыло = 0;
	КоличествоПозицийРазвернутоеСальдоБыло    = 0;

	ТекстыЗапросовПериодов = Новый Массив;

	ТекстЗапросаШаблонПериода =
	"ВЫБРАТЬ
	|	&ШаблонПериод 										КАК Период,
	|	ТоварыОрганизацийОстатки.Организация 				КАК Организация,
	|	ТоварыОрганизацийОстатки.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	ТоварыОрганизацийОстатки.ВидЗапасов 				КАК ВидЗапасов,
	|	ТоварыОрганизацийОстатки.НомерГТД 					КАК НомерГТД,
	|	ТоварыОрганизацийОстатки.КоличествоОстаток			КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(
	|		&ШаблонГраницаПериода,
	|		ВидЗапасов В (
	|			ВЫБРАТЬ
	|				ВТКонтролируемыеВидыЗапасов.Ссылка
	|			ИЗ
	|				ВТКонтролируемыеВидыЗапасов)) КАК ТоварыОрганизацийОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ШаблонПериод 										КАК Период,
	|	ТоварыОрганизацийВПути.Организация 					КАК Организация,
	|	ТоварыОрганизацийВПути.АналитикаУчетаНоменклатуры 	КАК АналитикаУчетаНоменклатуры,
	|	ТоварыОрганизацийВПути.ВидЗапасов 					КАК ВидЗапасов,
	|	ТоварыОрганизацийВПути.НомерГТД 					КАК НомерГТД,
	|	-ТоварыОрганизацийВПути.КоличествоСторно			КАК КоличествоОстаток
	|ИЗ
	|	ТоварыОрганизацийВПути КАК ТоварыОрганизацийВПути
	|ГДЕ
	|	ТоварыОрганизацийВПути.Период <= &ШаблонПериод
	|	И ТоварыОрганизацийВПути.ВидЗапасов В (
	|		ВЫБРАТЬ
	|			ВТКонтролируемыеВидыЗапасов.Ссылка
	|		ИЗ
	|			ВТКонтролируемыеВидыЗапасов)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ШаблонПериод 												КАК Период,
	|	РезервыТоваровОрганизацийОстатки.Организация 				КАК Организация,
	|	РезервыТоваровОрганизацийОстатки.АналитикаУчетаНоменклатуры	КАК АналитикаУчетаНоменклатуры,
	|	РезервыТоваровОрганизацийОстатки.ВидЗапасов 				КАК ВидЗапасов,
	|	РезервыТоваровОрганизацийОстатки.НомерГТД 					КАК НомерГТД,
	|	РезервыТоваровОрганизацийОстатки.КоличествоОстаток			КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.РезервыТоваровОрганизаций.Остатки(
	|		&ШаблонГраницаПериода,
	|		ВидЗапасов В (
	|			ВЫБРАТЬ
	|				ВТКонтролируемыеВидыЗапасов.Ссылка
	|			ИЗ
	|				ВТКонтролируемыеВидыЗапасов)) КАК РезервыТоваровОрганизацийОстатки";

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ТоварыОрганизаций.Период КАК Период
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций КАК ТоварыОрганизаций
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";

	РезультатЗапроса       = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда

		КонецТекущегоМесяца = КонецМесяца(ТекущаяДатаСеанса());
		ТриГодаНазад        = КонецМесяца(ДобавитьМесяц(КонецТекущегоМесяца, -36));

		РазделыДляПроверки = Новый Массив;
		РазделыДляПроверки.Добавить("РегламентныеОперации");
		РазделыДляПроверки.Добавить("БухгалтерскийУчет");

		ТаблицаДанных = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
		Для Каждого ТекущийРаздел Из РазделыДляПроверки Цикл
			НоваяСтрока        = ТаблицаДанных.Добавить();
			НоваяСтрока.Дата   = ТриГодаНазад;
			НоваяСтрока.Раздел = ТекущийРаздел;
		КонецЦикла;

		ОписаниеДанных = Новый Структура("НоваяВерсия, Данные", Ложь, "");
		ОписаниеОшибки = Новый Структура;
		ДатаЗапрета	   = Дата(1,1,1); // первый разрешенный период
		#Вставка 
		ДатаЗапрета	   = Дата(2024,12,1); // первый разрешенный период
		#КонецВставки

		ИзмененияЗапрещены = ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ТаблицаДанных, ОписаниеДанных, ОписаниеОшибки);		
		Если ИзмененияЗапрещены Тогда
			Для Каждого СтрокаЗапрета Из ОписаниеОшибки.Запреты Цикл
				ТекущийЗапрет = КонецМесяца(СтрокаЗапрета.ДатаЗапрета) + 1;

				Если НЕ ЗначениеЗаполнено(ДатаЗапрета) Тогда
					ДатаЗапрета = ТекущийЗапрет;
				Иначе
					ДатаЗапрета = Макс(ДатаЗапрета, ТекущийЗапрет);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;

		ТриГодаНазад = КонецМесяца(Макс(ТриГодаНазад, Мин(ДатаЗапрета, КонецТекущегоМесяца)));
		ТекМесяц     = Макс(КонецМесяца(ВыборкаДетальныеЗаписи.Период), ТриГодаНазад);

		Пока ТекМесяц <= КонецТекущегоМесяца Цикл
			ТекстЗапроса = ТекстЗапросаШаблонПериода;
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ШаблонГраницаПериода", "ГраницаПериода" + Формат(ТекМесяц, "ДФ=yyyyMM"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ШаблонПериод", "Период" + Формат(ТекМесяц, "ДФ=yyyyMM"));
			ТекстыЗапросовПериодов.Добавить(ТекстЗапроса);

			Запрос.УстановитьПараметр("ГраницаПериода" + Формат(ТекМесяц, "ДФ=yyyyMM"), Новый Граница(ТекМесяц, ВидГраницы.Включая));
			Запрос.УстановитьПараметр("Период" + Формат(ТекМесяц, "ДФ=yyyyMM"), ТекМесяц);

			ТекМесяц = КонецМесяца(ДобавитьМесяц(ТекМесяц, 1));
		КонецЦикла;
		Запрос.УстановитьПараметр("Период" + Формат(ТекМесяц, "ДФ=yyyyMM"), ТекМесяц);

		МенеджерВременныхТаблиц	= Новый МенеджерВременныхТаблиц;
		Обработки.ПомощникИсправленияОстатковТоваровОрганизаций.СформироватьВТКонтролируемыеВидыЗапасов(МенеджерВременныхТаблиц);
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст = 
		ЗапасыСервер.СторнироватьДвиженияТоварыОрганизацийВПути("&Период" + Формат(ТекМесяц, "ДФ=yyyyMM")) + 
		ОбщегоНазначения.РазделительПакетаЗапросов() +

		"ВЫБРАТЬ
		|	ВложенныйЗапрос.Период 						КАК Период,
		|	ВложенныйЗапрос.Организация 				КАК Организация,
		|	ВложенныйЗапрос.АналитикаУчетаНоменклатуры 	КАК АналитикаУчетаНоменклатуры,
		|	ВложенныйЗапрос.ВидЗапасов 					КАК ВидЗапасов,
		|	ВложенныйЗапрос.НомерГТД 					КАК НомерГТД,
		|	СУММА(ВложенныйЗапрос.КоличествоОстаток) 	КАК КоличествоОстаток
		|ПОМЕСТИТЬ ОстаткиНаКонецПериода
		|ИЗ
		|	ТекстЗапросаПериодов КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.Период,
		|	ВложенныйЗапрос.Организация,
		|	ВложенныйЗапрос.АналитикаУчетаНоменклатуры,
		|	ВложенныйЗапрос.ВидЗапасов,
		|	ВложенныйЗапрос.НомерГТД
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Период,
		|	Организация,
		|	АналитикаУчетаНоменклатуры,
		|	ВидЗапасов,
		|	НомерГТД
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТоварыОрганизацийВПути
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОстаткиНаКонецПериода.Период КАК Период
		|ИЗ
		|	ОстаткиНаКонецПериода КАК ОстаткиНаКонецПериода
		|
		|СГРУППИРОВАТЬ ПО
		|	ОстаткиНаКонецПериода.Период,
		|	ОстаткиНаКонецПериода.Организация,
		|	ОстаткиНаКонецПериода.АналитикаУчетаНоменклатуры,
		|	ОстаткиНаКонецПериода.ВидЗапасов,
		|	ОстаткиНаКонецПериода.НомерГТД
		|
		|ИМЕЮЩИЕ
		|	СУММА(ОстаткиНаКонецПериода.КоличествоОстаток) < 0
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ОстаткиНаКонецПериода";

		Запрос.Текст = СтрЗаменить(
		Запрос.Текст, 
		"ТекстЗапросаПериодов", 
		"(" + СтрСоединить(ТекстыЗапросовПериодов, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении()) + ")");

		МесяцИсправления = КонецМесяца(ТекущаяДатаСеанса());
		РезультатЗапроса = Запрос.Выполнить();

		Если НЕ РезультатЗапроса.Пустой() Тогда
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				Если ВыборкаДетальныеЗаписи.Период >= ТриГодаНазад Тогда
					МесяцИсправления = ВыборкаДетальныеЗаписи.Период;
					Прервать;
				КонецЕсли;
			КонецЦикла;

			Запрос           = ЗапросКоличестваПроблемныхПозиций();
			РезультатЗапроса = Запрос.ВыполнитьПакет();
			ВГраница         = РезультатЗапроса.ВГраница();

			ВыборкаДетальныеЗаписи = РезультатЗапроса[ВГраница - 2].Выбрать();
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				ВсегоПроблемныхПозиций = ВыборкаДетальныеЗаписи.КоличествоПозиций;
			КонецЕсли;

			ВыборкаДетальныеЗаписи = РезультатЗапроса[ВГраница - 1].Выбрать();
			Если ВыборкаДетальныеЗаписи.Следующий() Тогда
				КоличествоПозицийОтрицательныйОстатокБыло = ВыборкаДетальныеЗаписи.КоличествоПозиций;
			КонецЕсли;

			КоличествоПозицийРазвернутоеСальдоБыло = ВсегоПроблемныхПозиций - КоличествоПозицийОтрицательныйОстатокБыло;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры
