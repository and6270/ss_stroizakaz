﻿Процедура ВыполнитьКоманду() Экспорт
	// Соберем остатки товаров для Яндекс маркета
	Товары = ПолучитьОстаткиДляЯндекса();
	// Сделаем файл JSON
	ТоварыJSON = ПолучитьJSON(Товары);
	// отправим json в яндекс    
	Результат = ОтправитьОстаткиЯндексМаркет(ТоварыJSON);
	
КонецПроцедуры

Функция ПолучитьОстаткиДляЯндекса()
	
	МасТоваров = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.Номенклатура КАК Наименование,
		|	ТоварыНаСкладахОстатки.Номенклатура.Расш6270_ShopSKU КАК shopSKU,
		|	СУММА(ТоварыНаСкладахОстатки.ВНаличииОстаток) КАК count
		|ПОМЕСТИТЬ ВТ_ОстаткиТоваровДляЯндекс
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			&Дата,
		|			Склад В (&Склады)
		|				И Номенклатура.Расш6270_ВыгружатьДляЯндекса) КАК ТоварыНаСкладахОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ТоварыНаСкладахОстатки.Номенклатура.Расш6270_ShopSKU,
		|	ТоварыНаСкладахОстатки.Номенклатура
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Номенклатура.Расш6270_ShopSKU КАК shopSKU,
		|	ЕСТЬNULL(ВТ_ОстаткиТоваровДляЯндекс.count, 0) КАК count
		|ИЗ
		|	Справочник.Номенклатура КАК Номенклатура
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ОстаткиТоваровДляЯндекс КАК ВТ_ОстаткиТоваровДляЯндекс
		|		ПО (ВТ_ОстаткиТоваровДляЯндекс.Наименование = Номенклатура.Ссылка)
		|ГДЕ
		|	Номенклатура.Расш6270_ВыгружатьДляЯндекса
		|	И НЕ Номенклатура.Расш6270_ShopSKU = """"";
	
	Склады = Новый Массив;
	Склады.Добавить(Справочники.Склады.НайтиПоНаименованию("Алексеевка", Истина));
	//Склады.Добавить(Справочники.Склады.НайтиПоНаименованию("Бирюч", Истина));
	
	ТекДата = ТекущаяДата();
	
	Запрос.УстановитьПараметр("Дата", ТекДата);
	Запрос.УстановитьПараметр("Склады", Склады);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если ПустаяСтрока(Выборка.shopSKU) Тогда
			Продолжить;
		КонецЕсли;
		
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	        
		СтруктураТовараКоличество = Новый Структура;
		СтруктураТовараКоличество.Вставить("count", Выборка.count); // количество 
		СтруктураТовараКоличество.Вставить("type", "FIT");
		//СтруктураТовараКоличество.Вставить("updatedAt", "2023-12-20T15:01:01Z");  
		СтруктураТовараКоличество.Вставить("updatedAt", ТекДата);

		МассивКоличество = новый Массив;
		МассивКоличество.Добавить(СтруктураТовараКоличество);
		
		СтруктураТовара = Новый Структура;
		СтруктураТовара.Вставить("sku", Выборка.shopSKU); //sku товара
		СтруктураТовара.Вставить("warehouseId", 1018954); // ид склада
		СтруктураТовара.Вставить("items", МассивКоличество);
		
		МасТоваров.Добавить(СтруктураТовара); 
	КонецЦикла;
	Возврат Новый Структура("skus", МасТоваров);
КонецФункции   

Функция ПолучитьJSON(СтруктураТоваров)
	ПараметрыЗаписиJSON = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписиJSON);
	// формат даты
	НастройкиСериализации = Новый НастройкиСериализацииJSON;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	НастройкиСериализации.ВариантЗаписиДаты = ВариантЗаписиДатыJSON.ЛокальнаяДатаСоСмещением;
	
	ЗаписатьJSON(ЗаписьJSON, СтруктураТоваров,НастройкиСериализации);
	СтрокаJSON = ЗаписьJSON.Закрыть();
	Возврат СтрокаJSON;
КонецФункции

Функция ОтправитьОстаткиЯндексМаркет(ТоварыJSON)
	Соединение = Новый HTTPСоединение("api.partner.market.yandex.ru",,,,,,
        Новый ЗащищенноеСоединениеOpenSSL());        
	Заголовки = Новый Соответствие;    
	Заголовки.Вставить("Authorization", "Bearer "); //вставить ключ автризации если понадобится
	Пер_compaignID = "75565417";
	АдреснаяСтрока = "/campaigns/" + Пер_compaignID + "/offers/stocks";
	Запрос = Новый HTTPЗапрос(АдреснаяСтрока, Заголовки);
	Запрос.УстановитьТелоИзСтроки(ТоварыJSON);
	Результат = Соединение.Записать(Запрос);
	Если Результат.КодСостояния <> 200 Тогда  
		ТекстОшибки = Результат.ПолучитьТелоКакСтроку();
		ДобавитьЗаписьВЖурналРегистрации(ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
    Возврат Неопределено;
КонецФункции       

Процедура ДобавитьЗаписьВЖурналРегистрации(ТекстОшибки)

    //Индексы хранятся в каталоге 1Cv8Log в файлах с расширением .lgx
    ЗаписьЖурналаРегистрации("Выгрузка на яндекс маркет", УровеньЖурналаРегистрации.Ошибка,,,
    ТекстОшибки, РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
    //ЗаписьЖурналаРегистрации(<ИмяСобытия>, <Уровень>, <ОбъектМетаданных к которому относится событие>, <Данные>, <Комментарий>, <РежимТранзакции>)
    //Обработчик...

КонецПроцедуры
