codeunit 123456757 "Seminar Statistics Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestStatisticsFromCard()
    var
        SeminarCard: TestPage "Seminar Card";
        SeminarStat: TestPage "Seminar Statistics";
    begin
        SeminarCard.OpenView();
        SeminarCard.First();

        repeat
            SeminarStat.Trap();
            SeminarCard.Statistics.Invoke();

            if SeminarStat.Caption() <> StrSubstNo('View - Seminar Statistics - %1', SeminarCard."No.") then
                Error('Statistics page is not shown for the correct seminar.');

            SeminarStat.OK().Invoke();
        until not SeminarCard.Next();
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestStatisticsFromList()
    var
        SeminarList: TestPage "Seminar List";
        SeminarStat: TestPage "Seminar Statistics";
    begin
        SeminarList.OpenView();
        SeminarList.First();

        repeat
            SeminarStat.Trap();
            SeminarList.Statistics.Invoke();

            if SeminarStat.Caption() <> StrSubstNo('View - Seminar Statistics - %1', SeminarList."No.") then
                Error('Statistics page is not shown for the correct seminar.');

            SeminarStat.OK().Invoke();
        until not SeminarList.Next();
    end;
}

