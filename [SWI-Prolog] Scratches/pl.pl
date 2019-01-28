family(person('Иван Иванов Иванович',year(1992),sex('М'),month(45000)),
       person('Светлана Иванова Сергеевна',year(1991),sex('Ж'),month(40000)),
       [
           children('Андрей Иванов Иванович',year(2010),sex('М'),month(0),twins('да')),
           children('Мария Иванова Ивановна',year(2010),sex('Ж'),month(0),twins('да'))
       ]).

family(person('Кирилл Тищенко Андреевич',year(1990),sex('М'),month(35000)),
       person('Анастасия Тищенко Андреевна',year(1989),sex('Ж'),month(45000)),
       [
           children('Мария Тищенко Кирилловна',year(2008),sex('Ж'),month(0),twins('нет'))
       ]).

family(person('Сергей Касперский Федорович',year(1976),sex('М'),month(20000)),
       person('Марина Касперская Сергеевна',year(1980),sex('Ж'),month(15000)),
       [
           children('Кирилл Касперский Сергеевич',year(1998),sex('М'),month(18000),twins('нет'))
       ]).

family(person('Вениамин Плющенко Андреевич',year(1992),sex('М'),month(65000)),
       person('Екатерина Плющенко Сергеевна',year(1991),sex('Ж'),month(35000)),
       [
           children('Кирилл Плющенко Вениаминович',year(2008),sex('М'),month(0),twins('нет')),
           children('Алена Плющенко Вениаминовна',year(2010),sex('Ж'),month(0),twins('нет'))
       ]).

family(person('Никита Невзоров Федорович',year(1990),sex('М'),month(80000)),
       person('Екатерина Невзорова Анреевна',year(1989),sex('Ж'),month(0)),
       [
           children('Анастасия Невзорова Никитична',year(2008),sex('Ж'),month(10),twins('нет'))
       ]).

family(person('Иван Кроль Владимирович',year(1988),sex('М'),month(120000)),
       person('Кристина Кроль Владиславовна',year(1987),sex('Ж'),month(85000)),
       [
           children('Андрей Кроль Иванов',year(2006),sex('М'),month(0),twins('да')),
           children('Аркадий Кроль Иванов',year(2006),sex('М'),month(0),twins('да')),
           children('Мария Кроль Ивановна',year(2009),sex('Ж'),month(0),twins('да')),
           children('Зоя Кроль Ивановна',year(2009),sex('Ж'),month(0),twins('да'))
       ]).


/* 1. Проверить, существует ли в БД заданный человек (по ФИО); */
q1(Fio) :- family(person(FIO,_,_,_),_,[H|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,person(FIO,_,_,_),[H|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,_,[children(FIO,_,_,_,_)|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,_,[_|T]), member(children(Fio,_,_,_,_),T), write(Fio), nl,fail.

/* 2. Найти всех работающих детей; */
q2 :- family(_,_,[children(FIO,_,_,month(Month),_)]), Month > 0, write(FIO), nl,fail.

/* 3. Найти всех работающих мужей, чей доход больше чем у жены; */
q3 :- family(person(FIO,_,_,month(HMonth)),person(_,_,_,month(WMonth)),_), HMonth > 0, HMonth > WMonth, write(FIO), nl,fail.

/* 4. Найти всех людей, которые не работают и родились до указанного года; */
q4(Year) :- family(person(FIO,year(YEAR),_,month(0)),_,_), YEAR < Year, write(FIO), nl,fail;
            family(_,person(FIO,year(YEAR),_,month(0)),_), YEAR < Year, write(FIO), nl,fail;
            family(_,_,[children(FIO,year(YEAR),_,month(0),_)|_]), YEAR < Year, write(FIO), nl,fail;
            family(_,_,[_|T]), member(children(FIO,year(YEAR),_,month(0),_),T), YEAR < Year, write(FIO), nl,fail.

/* 5. Найти число семей, у которых есть близнецы. */
q5 :- (family(HUSBAND,WIFE,[children(FIO,_,_,_,twins('да'))|T]); family(HUSBAND,WIFE,[_|T]), member(children(FIO,_,_,_,twins('да')),T)), write(HUSBAND-WIFE), nl,fail.

interface1 :-
    new(Dialog, dialog('База данных семей')),
    send_list(Dialog, append, [
        new(A, text_item('ФИО')),
        new(MyList, list_browser),
        button('Найти', message(@prolog,
            output1, MyList, A?selection)),
        button('Очистить', message(MyList, clear)),
        button('Выход', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output1(MyList,A) :- send(MyList, clear),
    q1(A,FIO),
    send(MyList, append, FIO),
    fail.

interface2 :-
    new(Dialog, dialog('База данных семей')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('Найти', message(@prolog,
            output2, MyList)),
        button('Очистить', message(MyList, clear)),
        button('Выход', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output2(MyList) :- send(MyList, clear),
    q2(FIO),
    send(MyList, append, FIO),
    fail.

interface3 :-
    new(Dialog, dialog('База данных семей')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('Найти', message(@prolog,
            output3, MyList)),
        button('Очистить', message(MyList, clear)),
        button('Выход', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output3(MyList) :- send(MyList, clear),
    q3(FIO),
    send(MyList, append, FIO),
    fail.

  interface4 :-
    new(Dialog, dialog('База данных семей')),
    send_list(Dialog, append, [
        new(D, int_item('Год рождения')),
        new(MyList, list_browser),
        button('Найти', message(@prolog,
            output4, MyList, D?selection)),
        button('Очистить', message(MyList, clear)),
        button('Выход', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output4(MyList,D) :- send(MyList, clear),
    q4(D,FIO),
    send(MyList, append, FIO),
    fail.

interface5 :-
    new(Dialog, dialog('База данных семей')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('Найти', message(@prolog,
            output5, MyList)),
        button('Очистить', message(MyList, clear)),
        button('Выход', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output5(MyList) :- send(MyList, clear),
    q5(FIO),
    send(MyList, append, FIO),
    fail.
