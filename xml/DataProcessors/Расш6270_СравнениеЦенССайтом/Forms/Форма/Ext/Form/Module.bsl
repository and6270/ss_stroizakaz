﻿
&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, ВыборДобавлением, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	СтандартнаяОбработка = Ложь;
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Заголовок = "Выберите файл";
	ПараметрыДиалога.Фильтр = "Документ CSV|*.csv";
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПослеПомещенияФайлаНаСервер", ЭтотОбъект);
	НачатьПомещениеФайлаНаСервер(ОповещениеОЗавершении,,,,ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлаНаСервер(ОписаниеПомещенногоФайла, ДополнительныеПараметры) Экспорт
	Если ОписаниеПомещенногоФайла = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	АдресДанных = ОписаниеПомещенногоФайла.Адрес;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьФайл()
	ТабДокмент.Очистить();
	ТипСтрока = Новый ОписаниеТипов("Строка",Новый КвалификаторыСтроки(150));
	ТипЧисло = Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(15,2));
	
	ТабЗначений = Новый ТаблицаЗначений;
	ТабЗначений.Колонки.Добавить("Название",ТипСтрока,"Название");
	ТабЗначений.Колонки.Добавить("Артикул",ТипСтрока,"Артикул");
	ТабЗначений.Колонки.Добавить("Код1с",ТипСтрока,"Код1с");
	ТабЗначений.Колонки.Добавить("Скрыто",Новый ОписаниеТипов("Булево"),"Скрыто");
	ТабЗначений.Колонки.Добавить("Повторяется",Новый ОписаниеТипов("Булево"),"Повторяется");
	ТабЗначений.Колонки.Добавить("Количество",ТипЧисло,"Количество");
	//ТабЗначений.Колонки.Добавить("Единица",ТипСтрока,"Единица");
	ТабЗначений.Колонки.Добавить("Цена",ТипЧисло,"Цена");
	ТабЗначений.Колонки.Добавить("Цена2",ТипЧисло,"Цена2");
	ТабЗначений.Колонки.Добавить("Цена3",ТипЧисло,"Цена3");
	
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("csv");
	ФайлCSV = ПолучитьИзВременногоХранилища(АдресДанных);
	АдресДанных = "";
	ФайлCSV.Записать(ИмяВременногоФайла);
	
	ТекстCSV = Новый ТекстовыйДокумент;
	ТекстCSV.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
	КоличествоСтрок = ТекстCSV.КоличествоСтрок();
	// Пробежимся по шапке
	ТекСтрока = ТекстCSV.ПолучитьСтроку(1);
	ЧастиСтроки = СтрРазделить(ТекСтрока, ";");
	КолонкаНазвание = ЧастиСтроки.Найти("""name : Название""");
	КолонкаАртикул = ЧастиСтроки.Найти("""article : Артикул""");
	КолонкаКод1с = ЧастиСтроки.Найти("""code_1c : 1C""");
	КолонкаСкрыто = ЧастиСтроки.Найти("""hidden : Скрыто""");
	КолонкаКоличиство = ЧастиСтроки.Найти("""amount : Количество""");
	//КолонкаЕдиница = ЧастиСтроки.Найти("""unit : Единица измерения""");
	КолонкаЦена = ЧастиСтроки.Найти("""price : Цена""");
	КолонкаЦена2 = ЧастиСтроки.Найти("""price2 : Цена 2""");
	КолонкаЦена3 = ЧастиСтроки.Найти("""price3 : Цена 3""");
	//КолонкаУИДТовара = ЧастиСтроки.Найти("""uuid : UUID Товара""");
	//КолонкаУИДМодификации = ЧастиСтроки.Найти("""uuid_mod : UUID Модификации""");
	ПоследняяКолонка = Макс(КолонкаНазвание, КолонкаАртикул, КолонкаКод1с, КолонкаСкрыто, КолонкаКоличиство, КолонкаЦена, КолонкаЦена2, КолонкаЦена3);
	// Пробежимся по файлу
	Для НомерСтроки=2 По КоличествоСтрок Цикл
			
		ТекСтрока = ТекстCSV.ПолучитьСтроку(НомерСтроки);
		ЧастиСтроки = СтрРазделить(ТекСтрока, ";");
		
		Если ЧастиСтроки.Количество() < ПоследняяКолонка Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "В строке № " + НомерСтроки + " неверный формат";
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТабЗначений.Добавить();
		НоваяСтрока.Название 	= ЧастиСтроки[КолонкаНазвание];
		НоваяСтрока.Артикул 	= ЧастиСтроки[КолонкаАртикул];
		НоваяСтрока.Код1с		= ЧастиСтроки[КолонкаКод1с];
		НоваяСтрока.Скрыто		= Булево(Число(ЧастиСтроки[КолонкаСкрыто]));
		НоваяСтрока.Количество	= Число(СтрЗаменить(ЧастиСтроки[КолонкаКоличиство],Символ(34),""));
		НоваяСтрока.Цена		= Число(СтрЗаменить(ЧастиСтроки[КолонкаЦена],Символ(34),""));
		НоваяСтрока.Цена2		= Число(СтрЗаменить(ЧастиСтроки[КолонкаЦена2],Символ(34),""));
		НоваяСтрока.Цена3		= Число(СтрЗаменить(ЧастиСтроки[КолонкаЦена3],Символ(34),""));
		НоваяСтрока.Повторяется	= Ложь;
	КонецЦикла;
	Попытка
		УдалитьФайлы(ИмяВременногоФайла); 
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Для Каждого ТекСтрока Из ТабЗначений Цикл
		Если ТекСтрока.Повторяется Тогда
			Продолжить;
		КонецЕсли;
		ПараметрыОтбора = Новый Структура("Код1с", ТекСтрока.Код1с);
		Дубль = ТабЗначений.НайтиСтроки(ПараметрыОтбора);
		Если Дубль.Количество() > 1 Тогда
			Для Каждого НайденаяСтрока Из Дубль Цикл
				НайденаяСтрока.Повторяется = Истина;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаСайт.Название КАК Название,
	|	ТаблицаСайт.Артикул КАК Артикул,
	|	ТаблицаСайт.Код1с КАК Код1с,
	|	ТаблицаСайт.Скрыто КАК Скрыто,
	|	ТаблицаСайт.Количество КАК Количество,
	|	ТаблицаСайт.Цена КАК Цена,
	|	ТаблицаСайт.Цена2 КАК Цена2,
	|	ТаблицаСайт.Цена3 КАК Цена3,
	|	ТаблицаСайт.Повторяется КАК Повторяется
	|ПОМЕСТИТЬ ВТ_ТоварыСайт
	|ИЗ
	|	&ТаблицаСайт КАК ТаблицаСайт
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код1с
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			,
	|			(ВидЦены, Номенклатура) В
	|				(ВЫБРАТЬ
	|					&Цена КАК Цена,
	|					СпрНоменклатура.Ссылка КАК Ссылка
	|				ИЗ
	|					Справочник.Номенклатура КАК СпрНоменклатура
	|				ГДЕ
	|					СпрНоменклатура.Расш6270_ВыгружатьНаСайт)) КАК ЦеныНоменклатурыСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура
	|ПОМЕСТИТЬ ВТ_Цена2
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	|			,
	|			(ВидЦены, Номенклатура) В
	|				(ВЫБРАТЬ
	|					&Цена2 КАК Цена,
	|					СпрНоменклатура.Ссылка КАК Ссылка
	|				ИЗ
	|					Справочник.Номенклатура КАК СпрНоменклатура
	|				ГДЕ
	|					СпрНоменклатура.Расш6270_ВыгружатьНаСайт)) КАК ЦеныНоменклатурыСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Наименование КАК Наименование,
	|	Номенклатура.Код КАК Код
	|ПОМЕСТИТЬ ВТ_Номенклатура
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Расш6270_ВыгружатьНаСайт И НЕ Номенклатура.Расш6270_Недействителен
	|ИНДЕКСИРОВАТЬ ПО
	|	Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Номенклатура.Ссылка, ""<нет в 1с>"") КАК Наименование1С,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Название, ""<нет на сайте>"") КАК Название,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Артикул, ""<нет на сайте>"") КАК Артикул,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Код1с, ""<нет на сайте>"") КАК Код1с,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Повторяется, ЛОЖЬ) КАК Повторяется,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Скрыто, ""<нет на сайте>"") КАК Скрыто,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Количество, ""<нет на сайте>"") КАК Количество,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Цена, ""<нет на сайте>"") КАК СайтЦена,
	|	ЕСТЬNULL(ВТ_Цена.Цена, ""<нет в 1с>"") КАК Розница,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Цена, ""<нет на сайте>"") <> ЕСТЬNULL(ВТ_Цена.Цена, ""<нет в 1с>"") КАК ОшибкаЦена,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Цена2, ""<нет на сайте>"") КАК СайтЦена2,
	|	ЕСТЬNULL(ВТ_Цена2.Цена, ""<нет в 1с>"") КАК Селлер,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Цена2, ""<нет на сайте>"") <> ЕСТЬNULL(ВТ_Цена2.Цена, ""<нет в 1с>"") КАК ОшибкаЦена2,
	|	ЕСТЬNULL(ВТ_ТоварыСайт.Цена3, ""<нет на сайте>"") КАК СайтЦена3
	|ПОМЕСТИТЬ ВТ_Результат
	|ИЗ
	|	ВТ_ТоварыСайт КАК ВТ_ТоварыСайт
	|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Номенклатура КАК ВТ_Номенклатура
	|		ПО (ВТ_ТоварыСайт.Код1с = ВТ_Номенклатура.Код)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Цена КАК ВТ_Цена
	|		ПО (ВТ_ТоварыСайт.Код1с = ВТ_Цена.Номенклатура.Код)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Цена2 КАК ВТ_Цена2
	|		ПО (ВТ_ТоварыСайт.Код1с = ВТ_Цена2.Номенклатура.Код)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Результат.Наименование1С КАК Наименование1С,
	|	ВТ_Результат.Название КАК Название,
	|	ВТ_Результат.Артикул КАК Артикул,
	|	ВТ_Результат.Код1с КАК Код1с,
	|	ВТ_Результат.Повторяется КАК Повторяется,
	|	ВТ_Результат.Скрыто КАК Скрыто,
	|	ВТ_Результат.Количество КАК Количество,
	|	ВТ_Результат.СайтЦена КАК СайтЦена,
	|	ВТ_Результат.Розница КАК Розница,
	|	ВТ_Результат.ОшибкаЦена КАК ОшибкаЦена,
	|	ВТ_Результат.СайтЦена2 КАК СайтЦена2,
	|	ВТ_Результат.Селлер КАК Селлер,
	|	ВТ_Результат.ОшибкаЦена2 КАК ОшибкаЦена2,
	|	ВТ_Результат.СайтЦена3 КАК СайтЦена3
	|ИЗ
	|	ВТ_Результат КАК ВТ_Результат
	|ГДЕ
	|	(ВТ_Результат.Повторяется
	|			ИЛИ ВТ_Результат.ОшибкаЦена
	|			ИЛИ ВТ_Результат.ОшибкаЦена2)";
	
	Запрос.УстановитьПараметр("ТаблицаСайт", ТабЗначений);
	Запрос.УстановитьПараметр("Цена", Цена);
	Запрос.УстановитьПараметр("Цена2", Цена2);
	
	ВыборкаТЗ = Запрос.Выполнить().Выгрузить();
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Построитель = Новый ПостроительОтчета;
	Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ВыборкаТЗ);
	Построитель.ВыводитьЗаголовокОтчета = Ложь;
	Построитель.ВыводитьОбщиеИтоги = Ложь;
	Построитель.ВыводитьПодвалОтчета = Ложь;
	Построитель.ВыводитьПодвалТаблицы = Ложь;
	
	// Условное оформление
	ЭлементОформления = Построитель.УсловноеОформление.Добавить("ФорматБулево", "ФорматБулево");
	ЭлементОформления.Область.Добавить("Повторяется", "Повторяется", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("Скрыто", "Скрыто", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("ОшибкаЦена", "ОшибкаЦена", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("ОшибкаЦена2", "ОшибкаЦена2", ТипОбластиОформления.Поле);
	ЭлементОформления.Оформление.ГоризонтальноеПоложение.Значение = ГоризонтальноеПоложение.Центр;
	ЭлементОформления.Оформление.Формат.Значение  =  "БЛ=-; БИ=Да";
	ЭлементОформления.Оформление.Формат.Использование = Истина;
	ЭлементОформления.Оформление.ГоризонтальноеПоложение.Использование = Истина;
	ЭлементОформления.Использование = Истина;
	
	ЭлементОформления = Построитель.УсловноеОформление.Добавить("ВыделениеЦена", "ВыделениеЦена");
	//ЭлементОформления.Область.Добавить("ОшибкаЦена", "ОшибкаЦена", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("Розница", "Розница", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("СайтЦена", "СайтЦена", ТипОбластиОформления.Поле);
	ЭлементОформления.Отбор.Добавить("ОшибкаЦена");
	ЭлементОформления.Отбор.ОшибкаЦена.ВидСравнения = ВидСравнения.Равно;
	ЭлементОформления.Отбор.ОшибкаЦена.Значение = Истина;
	ЭлементОформления.Отбор.ОшибкаЦена.Использование = Истина;
	ЭлементОформления.Оформление.ЦветФона.Значение = WebЦвета.Розовый;
	ЭлементОформления.Оформление.ЦветФона.Использование = Истина;
	ЭлементОформления.Использование = Истина;
	
	ЭлементОформления = Построитель.УсловноеОформление.Добавить("ВыделениеЦена2", "ВыделениеЦена2");
	//ЭлементОформления.Область.Добавить("ОшибкаЦена2", "ОшибкаЦена2", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("Селлер", "Селлер", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("СайтЦена2", "СайтЦена2", ТипОбластиОформления.Поле);
	ЭлементОформления.Отбор.Добавить("ОшибкаЦена2");
	ЭлементОформления.Отбор.ОшибкаЦена2.ВидСравнения = ВидСравнения.Равно;
	ЭлементОформления.Отбор.ОшибкаЦена2.Значение = Истина;
	ЭлементОформления.Отбор.ОшибкаЦена2.Использование = Истина;
	ЭлементОформления.Оформление.ЦветФона.Значение = WebЦвета.Розовый;
	ЭлементОформления.Оформление.ЦветФона.Использование = Истина;
	ЭлементОформления.Использование = Истина;
	
	ЭлементОформления = Построитель.УсловноеОформление.Добавить("ВыделениеКода", "ВыделениеКода");
	//ЭлементОформления.Область.Добавить("Повторяется", "Повторяется", ТипОбластиОформления.Поле);
	ЭлементОформления.Область.Добавить("Код1с", "Код1с", ТипОбластиОформления.Поле);
	ЭлементОформления.Отбор.Добавить("Повторяется");
	ЭлементОформления.Отбор.Повторяется.ВидСравнения = ВидСравнения.Равно;
	ЭлементОформления.Отбор.Повторяется.Значение = Истина;
	ЭлементОформления.Отбор.Повторяется.Использование = Истина;
	ЭлементОформления.Оформление.ЦветФона.Значение = WebЦвета.Розовый;
	ЭлементОформления.Оформление.ЦветФона.Использование = Истина;
	ЭлементОформления.Использование = Истина;
	
	Построитель.Вывести(ТабличныйДокумент);
	
	//ТабличныйДокумент.Область(1,1,ТабличныйДокумент.ВысотаТаблицы, ТабличныйДокумент.ШиринаТаблицы).ШиринаКолонки = 10;
	
	ТабличныйДокумент.Область(1,1).ШиринаКолонки = 3;
	ТабличныйДокумент.Область(1,2).ШиринаКолонки = 30;
	ТабличныйДокумент.Область(1,3).ШиринаКолонки = 30;
	ТабличныйДокумент.Область(1,4).ШиринаКолонки = 12;
	ТабличныйДокумент.Область(1,5).ШиринаКолонки = 12;
	ТабличныйДокумент.Область(1,6).ШиринаКолонки = 5;
	ТабличныйДокумент.Область(1,7).ШиринаКолонки = 5;
	ТабличныйДокумент.Область(1,8).ШиринаКолонки = 10;
	ТабличныйДокумент.Область(1,9).ШиринаКолонки = 10;
	ТабличныйДокумент.Область(1,10).ШиринаКолонки = 10;
	ТабличныйДокумент.Область(1,11).ШиринаКолонки = 5;
	ТабличныйДокумент.Область(1,12).ШиринаКолонки = 10;
	ТабличныйДокумент.Область(1,13).ШиринаКолонки = 10;
	ТабличныйДокумент.Область(1,14).ШиринаКолонки = 5;
	ТабличныйДокумент.Область(1,15).ШиринаКолонки = 10;
	ТабДокмент = ТабличныйДокумент;
	ТабДокмент.ФиксацияСверху = 1;
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Если НЕ ЭтоАдресВременногоХранилища(АдресДанных) Тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Файл не выбран";
		Сообщение.Поле = "АдресДанных";
		Сообщение.Сообщить();
		Возврат;
	ИначеЕсли Цена.Пустая() Тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Не выбран вид ""Цена"" для сопоставления с сайтом";
		Сообщение.Поле = "Цена";
		Сообщение.Сообщить();
		Возврат;
	ИначеЕсли Цена2.Пустая() Тогда
		Сообщение = новый СообщениеПользователю;
		Сообщение.Текст = "Не выбран вид ""Цена2"" для сопоставления с сайтом";
		Сообщение.Поле = "Цена2";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	ПрочитатьФайл();
КонецПроцедуры
