family(person('���� ������ ��������',year(1992),sex('�'),month(45000)),
       person('�������� ������� ���������',year(1991),sex('�'),month(40000)),
       [
           children('������ ������ ��������',year(2010),sex('�'),month(0),twins('��')),
           children('����� ������� ��������',year(2010),sex('�'),month(0),twins('��'))
       ]).

family(person('������ ������� ���������',year(1990),sex('�'),month(35000)),
       person('��������� ������� ���������',year(1989),sex('�'),month(45000)),
       [
           children('����� ������� ����������',year(2008),sex('�'),month(0),twins('���'))
       ]).

family(person('������ ���������� ���������',year(1976),sex('�'),month(20000)),
       person('������ ���������� ���������',year(1980),sex('�'),month(15000)),
       [
           children('������ ���������� ���������',year(1998),sex('�'),month(18000),twins('���'))
       ]).

family(person('�������� �������� ���������',year(1992),sex('�'),month(65000)),
       person('��������� �������� ���������',year(1991),sex('�'),month(35000)),
       [
           children('������ �������� ������������',year(2008),sex('�'),month(0),twins('���')),
           children('����� �������� ������������',year(2010),sex('�'),month(0),twins('���'))
       ]).

family(person('������ �������� ���������',year(1990),sex('�'),month(80000)),
       person('��������� ��������� ��������',year(1989),sex('�'),month(0)),
       [
           children('��������� ��������� ���������',year(2008),sex('�'),month(10),twins('���'))
       ]).

family(person('���� ����� ������������',year(1988),sex('�'),month(120000)),
       person('�������� ����� �������������',year(1987),sex('�'),month(85000)),
       [
           children('������ ����� ������',year(2006),sex('�'),month(0),twins('��')),
           children('������� ����� ������',year(2006),sex('�'),month(0),twins('��')),
           children('����� ����� ��������',year(2009),sex('�'),month(0),twins('��')),
           children('��� ����� ��������',year(2009),sex('�'),month(0),twins('��'))
       ]).


/* 1. ���������, ���������� �� � �� �������� ������� (�� ���); */
q1(Fio) :- family(person(FIO,_,_,_),_,[H|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,person(FIO,_,_,_),[H|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,_,[children(FIO,_,_,_,_)|T]), Fio = FIO, write(FIO), nl,fail;
           family(_,_,[_|T]), member(children(Fio,_,_,_,_),T), write(Fio), nl,fail.

/* 2. ����� ���� ���������� �����; */
q2 :- family(_,_,[children(FIO,_,_,month(Month),_)]), Month > 0, write(FIO), nl,fail.

/* 3. ����� ���� ���������� �����, ��� ����� ������ ��� � ����; */
q3 :- family(person(FIO,_,_,month(HMonth)),person(_,_,_,month(WMonth)),_), HMonth > 0, HMonth > WMonth, write(FIO), nl,fail.

/* 4. ����� ���� �����, ������� �� �������� � �������� �� ���������� ����; */
q4(Year) :- family(person(FIO,year(YEAR),_,month(0)),_,_), YEAR < Year, write(FIO), nl,fail;
            family(_,person(FIO,year(YEAR),_,month(0)),_), YEAR < Year, write(FIO), nl,fail;
            family(_,_,[children(FIO,year(YEAR),_,month(0),_)|_]), YEAR < Year, write(FIO), nl,fail;
            family(_,_,[_|T]), member(children(FIO,year(YEAR),_,month(0),_),T), YEAR < Year, write(FIO), nl,fail.

/* 5. ����� ����� �����, � ������� ���� ��������. */
q5 :- (family(HUSBAND,WIFE,[children(FIO,_,_,_,twins('��'))|T]); family(HUSBAND,WIFE,[_|T]), member(children(FIO,_,_,_,twins('��')),T)), write(HUSBAND-WIFE), nl,fail.

interface1 :-
    new(Dialog, dialog('���� ������ �����')),
    send_list(Dialog, append, [
        new(A, text_item('���')),
        new(MyList, list_browser),
        button('�����', message(@prolog,
            output1, MyList, A?selection)),
        button('��������', message(MyList, clear)),
        button('�����', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output1(MyList,A) :- send(MyList, clear),
    q1(A,FIO),
    send(MyList, append, FIO),
    fail.

interface2 :-
    new(Dialog, dialog('���� ������ �����')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('�����', message(@prolog,
            output2, MyList)),
        button('��������', message(MyList, clear)),
        button('�����', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output2(MyList) :- send(MyList, clear),
    q2(FIO),
    send(MyList, append, FIO),
    fail.

interface3 :-
    new(Dialog, dialog('���� ������ �����')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('�����', message(@prolog,
            output3, MyList)),
        button('��������', message(MyList, clear)),
        button('�����', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output3(MyList) :- send(MyList, clear),
    q3(FIO),
    send(MyList, append, FIO),
    fail.

  interface4 :-
    new(Dialog, dialog('���� ������ �����')),
    send_list(Dialog, append, [
        new(D, int_item('��� ��������')),
        new(MyList, list_browser),
        button('�����', message(@prolog,
            output4, MyList, D?selection)),
        button('��������', message(MyList, clear)),
        button('�����', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output4(MyList,D) :- send(MyList, clear),
    q4(D,FIO),
    send(MyList, append, FIO),
    fail.

interface5 :-
    new(Dialog, dialog('���� ������ �����')),
    send_list(Dialog, append, [
        new(MyList, list_browser),
        button('�����', message(@prolog,
            output5, MyList)),
        button('��������', message(MyList, clear)),
        button('�����', message(Dialog, destroy))
    ]),
    send(MyList, alignment, center),
    send(MyList, size, size(50,20)),
    send(Dialog, open(point(100,400))).

output5(MyList) :- send(MyList, clear),
    q5(FIO),
    send(MyList, append, FIO),
    fail.
