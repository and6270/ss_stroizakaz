﻿
&НаСервере
Процедура Расш6270_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ПриобретениеТоваровУслуг.Ссылка КАК Ссылка,
	               |	ПриобретениеТоваровУслуг.ПометкаУдаления КАК ПометкаУдаления,
	               |	ПриобретениеТоваровУслуг.Номер КАК Номер,
	               |	ПриобретениеТоваровУслуг.Дата КАК Дата,
	               |	ПриобретениеТоваровУслуг.Проведен КАК Проведен,
	               |	ПриобретениеТоваровУслуг.Валюта КАК Валюта,
	               |	ПриобретениеТоваровУслуг.Партнер КАК Партнер,
	               |	ПриобретениеТоваровУслуг.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	               |	ПриобретениеТоваровУслуг.Подразделение КАК Подразделение,
	               |	ПриобретениеТоваровУслуг.Склад КАК Склад,
	               |	ПриобретениеТоваровУслуг.Контрагент КАК Контрагент,
	               |	ПриобретениеТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	               |	ПриобретениеТоваровУслуг.СуммаВзаиморасчетовПоЗаказу КАК СуммаВзаиморасчетовПоЗаказу,
	               |	ПриобретениеТоваровУслуг.Менеджер КАК Менеджер,
	               |	ПриобретениеТоваровУслуг.ЗаказПоставщику КАК ЗаказПоставщику,
	               |	ПриобретениеТоваровУслуг.ПодотчетноеЛицо КАК ПодотчетноеЛицо,
	               |	ПриобретениеТоваровУслуг.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	               |	ПриобретениеТоваровУслуг.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	               |	ПриобретениеТоваровУслуг.Комментарий КАК Комментарий,
	               |	ПриобретениеТоваровУслуг.УдалитьДатаПлатежа КАК УдалитьДатаПлатежа,
	               |	ПриобретениеТоваровУслуг.ЗакупкаПодДеятельность КАК ЗакупкаПодДеятельность,
	               |	ПриобретениеТоваровУслуг.ФормаОплаты КАК ФормаОплаты,
	               |	ПриобретениеТоваровУслуг.Согласован КАК Согласован,
	               |	ПриобретениеТоваровУслуг.НалогообложениеНДС КАК НалогообложениеНДС,
	               |	ПриобретениеТоваровУслуг.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	               |	ПриобретениеТоваровУслуг.БанковскийСчетОрганизации КАК БанковскийСчетОрганизации,
	               |	ПриобретениеТоваровУслуг.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	               |	ПриобретениеТоваровУслуг.ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	               |	ПриобретениеТоваровУслуг.Грузоотправитель КАК Грузоотправитель,
	               |	ПриобретениеТоваровУслуг.БанковскийСчетКонтрагента КАК БанковскийСчетКонтрагента,
	               |	ПриобретениеТоваровУслуг.БанковскийСчетГрузоотправителя КАК БанковскийСчетГрузоотправителя,
	               |	ПриобретениеТоваровУслуг.Сделка КАК Сделка,
	               |	ПриобретениеТоваровУслуг.Принял КАК Принял,
	               |	ПриобретениеТоваровУслуг.ПринялДолжность КАК ПринялДолжность,
	               |	ПриобретениеТоваровУслуг.ПоступлениеПоЗаказам КАК ПоступлениеПоЗаказам,
	               |	ПриобретениеТоваровУслуг.ГруппаФинансовогоУчета КАК ГруппаФинансовогоУчета,
	               |	ПриобретениеТоваровУслуг.РегистрироватьЦеныПоставщика КАК РегистрироватьЦеныПоставщика,
	               |	ПриобретениеТоваровУслуг.Договор КАК Договор,
	               |	ПриобретениеТоваровУслуг.Автор КАК Автор,
	               |	ПриобретениеТоваровУслуг.Руководитель КАК Руководитель,
	               |	ПриобретениеТоваровУслуг.ПорядокРасчетов КАК ПорядокРасчетов,
	               |	ПриобретениеТоваровУслуг.ВернутьМногооборотнуюТару КАК ВернутьМногооборотнуюТару,
	               |	ПриобретениеТоваровУслуг.ДатаВозвратаМногооборотнойТары КАК ДатаВозвратаМногооборотнойТары,
	               |	ПриобретениеТоваровУслуг.СостояниеЗаполненияМногооборотнойТары КАК СостояниеЗаполненияМногооборотнойТары,
	               |	ПриобретениеТоваровУслуг.ТребуетсяЗалогЗаТару КАК ТребуетсяЗалогЗаТару,
	               |	ПриобретениеТоваровУслуг.ДопоступлениеПоДокументу КАК ДопоступлениеПоДокументу,
	               |	ПриобретениеТоваровУслуг.НазначениеАванса КАК НазначениеАванса,
	               |	ПриобретениеТоваровУслуг.КоличествоДокументов КАК КоличествоДокументов,
	               |	ПриобретениеТоваровУслуг.КоличествоЛистов КАК КоличествоЛистов,
	               |	ПриобретениеТоваровУслуг.ГлавныйБухгалтер КАК ГлавныйБухгалтер,
	               |	ПриобретениеТоваровУслуг.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	               |	ПриобретениеТоваровУслуг.СпособДоставки КАК СпособДоставки,
	               |	ПриобретениеТоваровУслуг.ПеревозчикПартнер КАК ПеревозчикПартнер,
	               |	ПриобретениеТоваровУслуг.ЗонаДоставки КАК ЗонаДоставки,
	               |	ПриобретениеТоваровУслуг.ВремяДоставкиС КАК ВремяДоставкиС,
	               |	ПриобретениеТоваровУслуг.ВремяДоставкиПо КАК ВремяДоставкиПо,
	               |	ПриобретениеТоваровУслуг.АдресДоставки КАК АдресДоставки,
	               |	ПриобретениеТоваровУслуг.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	               |	ПриобретениеТоваровУслуг.ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформацияПоДоставке,
	               |	ПриобретениеТоваровУслуг.АдресДоставкиПеревозчика КАК АдресДоставкиПеревозчика,
	               |	ПриобретениеТоваровУслуг.АдресДоставкиПеревозчикаЗначенияПолей КАК АдресДоставкиПеревозчикаЗначенияПолей,
	               |	ПриобретениеТоваровУслуг.ОсобыеУсловияПеревозки КАК ОсобыеУсловияПеревозки,
	               |	ПриобретениеТоваровУслуг.ОсобыеУсловияПеревозкиОписание КАК ОсобыеУсловияПеревозкиОписание,
	               |	ПриобретениеТоваровУслуг.НаправлениеДеятельности КАК НаправлениеДеятельности,
	               |	ПриобретениеТоваровУслуг.УдалитьТоварноТранспортнаяНакладнаяЕГАИС КАК УдалитьТоварноТранспортнаяНакладнаяЕГАИС,
	               |	ПриобретениеТоваровУслуг.ЕстьАлкогольнаяПродукция КАК ЕстьАлкогольнаяПродукция,
	               |	ПриобретениеТоваровУслуг.Соглашение КАК Соглашение,
	               |	ПриобретениеТоваровУслуг.Организация КАК Организация,
	               |	ПриобретениеТоваровУслуг.КурсЧислитель КАК КурсЧислитель,
	               |	ПриобретениеТоваровУслуг.КурсЗнаменатель КАК КурсЗнаменатель,
	               |	ПриобретениеТоваровУслуг.УдалитьПорядокОплаты КАК УдалитьПорядокОплаты,
	               |	ПриобретениеТоваровУслуг.ЕстьМаркируемаяПродукцияГИСМ КАК ЕстьМаркируемаяПродукцияГИСМ,
	               |	ПриобретениеТоваровУслуг.ЕстьКиЗГИСМ КАК ЕстьКиЗГИСМ,
	               |	ПриобретениеТоваровУслуг.ВариантПриемкиТоваров КАК ВариантПриемкиТоваров,
	               |	ПриобретениеТоваровУслуг.СуммаВзаиморасчетовПоТаре КАК СуммаВзаиморасчетовПоТаре,
	               |	ПриобретениеТоваровУслуг.АвансовыйОтчет КАК АвансовыйОтчет,
	               |	ПриобретениеТоваровУслуг.НаименованиеВходящегоДокумента КАК НаименованиеВходящегоДокумента,
	               |	ПриобретениеТоваровУслуг.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		НоменклатураПартнера КАК НоменклатураПартнера,
	               |		Характеристика КАК Характеристика,
	               |		Упаковка КАК Упаковка,
	               |		КоличествоУпаковок КАК КоличествоУпаковок,
	               |		Количество КАК Количество,
	               |		КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	               |		Цена КАК Цена,
	               |		ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	               |		ПроцентРучнойСкидки КАК ПроцентРучнойСкидки,
	               |		СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	               |		УдалитьСтавкаНДС КАК УдалитьСтавкаНДС,
	               |		Сумма КАК Сумма,
	               |		СтавкаНДС КАК СтавкаНДС,
	               |		СуммаНДС КАК СуммаНДС,
	               |		СуммаСНДС КАК СуммаСНДС,
	               |		СтатьяРасходов КАК СтатьяРасходов,
	               |		АналитикаРасходов КАК АналитикаРасходов,
	               |		КодСтроки КАК КодСтроки,
	               |		НомерГТД КАК НомерГТД,
	               |		Склад КАК Склад,
	               |		ЗаказПоставщику КАК ЗаказПоставщику,
	               |		УдалитьНомерСтрокиДокументаПоставщика КАК УдалитьНомерСтрокиДокументаПоставщика,
	               |		Сертификат КАК Сертификат,
	               |		НомерПаспорта КАК НомерПаспорта,
	               |		СтатусУказанияСерий КАК СтатусУказанияСерий,
	               |		УдалитьСтатусУказанияСерийНаСкладах КАК УдалитьСтатусУказанияСерийНаСкладах,
	               |		УдалитьСтатусУказанияСерийТоварыУПартнеров КАК УдалитьСтатусУказанияСерийТоварыУПартнеров,
	               |		Сделка КАК Сделка,
	               |		СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	               |		СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов,
	               |		ВидЗапасов КАК ВидЗапасов,
	               |		ИдентификаторСтроки КАК ИдентификаторСтроки,
	               |		УдалитьАналитикаУчетаПартий КАК УдалитьАналитикаУчетаПартий,
	               |		Назначение КАК Назначение,
	               |		Серия КАК Серия,
	               |		АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |		УдалитьАналитикаУчетаНоменклатурыТоварыУПартнеров КАК УдалитьАналитикаУчетаНоменклатурыТоварыУПартнеров,
	               |		Подразделение КАК Подразделение,
	               |		СписатьНаРасходы КАК СписатьНаРасходы,
	               |		НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	               |		ДатаВходящегоДокумента КАК ДатаВходящегоДокумента,
	               |		ОбъектРасчетов КАК ОбъектРасчетов,
	               |		НаименованиеВходящегоДокумента КАК НаименованиеВходящегоДокумента,
	               |		СуммаИтог КАК СуммаИтог
	               |	) КАК Товары,
	               |	ПриобретениеТоваровУслуг.ДополнительныеРеквизиты.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Свойство КАК Свойство,
	               |		Значение КАК Значение,
	               |		ТекстоваяСтрока КАК ТекстоваяСтрока
	               |	) КАК ДополнительныеРеквизиты,
	               |	ПриобретениеТоваровУслуг.РасшифровкаПлатежа.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		УдалитьЗаказ КАК УдалитьЗаказ,
	               |		Сумма КАК Сумма,
	               |		ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	               |		СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	               |		ОбъектРасчетов КАК ОбъектРасчетов
	               |	) КАК РасшифровкаПлатежа,
	               |	ПриобретениеТоваровУслуг.Серии.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Серия КАК Серия,
	               |		Количество КАК Количество,
	               |		Номенклатура КАК Номенклатура,
	               |		Характеристика КАК Характеристика,
	               |		Назначение КАК Назначение,
	               |		Склад КАК Склад
	               |	) КАК Серии,
	               |	ПриобретениеТоваровУслуг.ВидыЗапасов.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		ИдентификаторСтроки КАК ИдентификаторСтроки,
	               |		АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	               |		УдалитьАналитикаУчетаНоменклатурыТоварыУПартнеров КАК УдалитьАналитикаУчетаНоменклатурыТоварыУПартнеров,
	               |		ВидЗапасов КАК ВидЗапасов,
	               |		НомерГТД КАК НомерГТД,
	               |		Количество КАК Количество,
	               |		КоличествоПоРНПТ КАК КоличествоПоРНПТ,
	               |		ЗаказПоставщику КАК ЗаказПоставщику,
	               |		ВидЗапасовПолучателя КАК ВидЗапасовПолучателя,
	               |		УдалитьСтавкаНДС КАК УдалитьСтавкаНДС,
	               |		Цена КАК Цена,
	               |		СтавкаНДС КАК СтавкаНДС,
	               |		СуммаНДС КАК СуммаНДС,
	               |		СуммаСНДС КАК СуммаСНДС,
	               |		СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	               |		СуммаНДСВзаиморасчетов КАК СуммаНДСВзаиморасчетов,
	               |		ОбъектРасчетов КАК ОбъектРасчетов,
	               |		СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	               |		СписатьНаРасходы КАК СписатьНаРасходы,
	               |		СтатьяРасходов КАК СтатьяРасходов,
	               |		АналитикаРасходов КАК АналитикаРасходов,
	               |		Подразделение КАК Подразделение
	               |	) КАК ВидыЗапасов,
	               |	ПриобретениеТоваровУслуг.ЭтапыГрафикаОплаты.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Заказ КАК Заказ,
	               |		СверхЗаказа КАК СверхЗаказа,
	               |		ВариантОплаты КАК ВариантОплаты,
	               |		ДатаПлатежа КАК ДатаПлатежа,
	               |		Сдвиг КАК Сдвиг,
	               |		ПроцентПлатежа КАК ПроцентПлатежа,
	               |		СуммаПлатежа КАК СуммаПлатежа,
	               |		ПроцентЗалогаЗаТару КАК ПроцентЗалогаЗаТару,
	               |		СуммаЗалогаЗаТару КАК СуммаЗалогаЗаТару,
	               |		СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	               |		СуммаВзаиморасчетовПоТаре КАК СуммаВзаиморасчетовПоТаре,
	               |		ОбъектРасчетов КАК ОбъектРасчетов,
	               |		ВариантОтсчета КАК ВариантОтсчета
	               |	) КАК ЭтапыГрафикаОплаты,
	               |	ПриобретениеТоваровУслуг.ШтрихкодыУпаковок.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	               |		ЗначениеШтрихкода КАК ЗначениеШтрихкода
	               |	) КАК ШтрихкодыУпаковок,
	               |	ПриобретениеТоваровУслуг.МоментВремени КАК МоментВремени,
	               |	СостоянияЭД.СостояниеЭДО КАК СостояниеЭДО,
	               |	СостоянияЭД.ПредставлениеСостояния КАК ПредставлениеСостояния,
	               |	ЕСТЬNULL(Расш6270_Состояние.Булево, ЛОЖЬ) КАК ЕстьУстановкаЦен
	               |ИЗ
	               |	Документ.ПриобретениеТоваровУслуг КАК ПриобретениеТоваровУслуг
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СостоянияПоОбъектамУчетаЭДО КАК СостоянияЭД
	               |		ПО (СостоянияЭД.СсылкаНаОбъект = ПриобретениеТоваровУслуг.Ссылка)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Расш6270_Состояние КАК Расш6270_Состояние
	               |		ПО (ПриобретениеТоваровУслуг.Ссылка = Расш6270_Состояние.Объект)";
		
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	СвойстваСписка.ОсновнаяТаблица = "Документ.ПриобретениеТоваровУслуг";
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокДокументыПоступления, СвойстваСписка);
	
	НовыйЭлемент = Элементы.Добавить("ЕстьУстановкаЦен", Тип("ПолеФормы"), Элементы.СписокДокументыПоступления);
	НовыйЭлемент.ПутьКДанным		= "СписокДокументыПоступления.ЕстьУстановкаЦен";
	НовыйЭлемент.Вид				= ВидПоляФормы.ПолеФлажка;
	НовыйЭлемент.ТолькоПросмотр		= Истина;
	НовыйЭлемент.Заголовок			= "Цена установлена";
КонецПроцедуры
