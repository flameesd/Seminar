codeunit 123456752 "Seminar Master Data Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarSetupLookups()
    var
        SeminarSetup: TestPage "Seminar Setup";
        NoSeries: TestPage "No. Series";
        NoSeriesCode: Code[10];
    begin
        SeminarSetup.OpenEdit();

        NoSeries.OpenView();
        NoSeries.First();
        NoSeries.Next();

        NoSeriesCode := CopyStr(SeminarSetup."Seminar Nos.".Value(), 1, 10);
        SeminarSetup."Seminar Nos.".SetValue(NoSeries.Code.Value());
        SeminarSetup."Seminar Nos.".SetValue(NoSeriesCode);

        NoSeries.Next();

        NoSeriesCode := CopyStr(SeminarSetup."Seminar Registration Nos.".Value(), 1, 10);
        SeminarSetup."Seminar Registration Nos.".SetValue(NoSeries.Code.Value());
        SeminarSetup."Seminar Registration Nos.".SetValue(NoSeriesCode);

        asserterror SeminarSetup."Seminar Nos.".SetValue('_ _ _ _ _');
        asserterror SeminarSetup."Seminar Registration Nos.".SetValue('_ _ _ _ _');

        NoSeries.OK().Invoke();
        SeminarSetup.OK().Invoke();
    end;

    [Test]
    [HandlerFunctions('NoSeriesListHandler')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarCardNoSeries()
    var
        SeminarCard: TestPage "Seminar Card";
    begin
        SeminarCard.OpenNew();
        SeminarCard."No.".AssistEdit();
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarCardVATProdPostingGroup()
    var
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        SeminarCard: TestPage "Seminar Card";
    begin
        SeminarCard.OpenEdit();
        SeminarCard.Last();
        SeminarCard."Gen. Prod. Posting Group".SetValue('');
        SeminarCard."VAT Prod. Posting Group".SetValue('');

        GenProdPostingGroup.SetFilter("Def. VAT Prod. Posting Group", '<>%1', '');
        GenProdPostingGroup.FindFirst();
        SeminarCard."Gen. Prod. Posting Group".SetValue(GenProdPostingGroup.Code);
        SeminarCard."VAT Prod. Posting Group".AssertEquals(GenProdPostingGroup."Def. VAT Prod. Posting Group");
        SeminarCard.OK().Invoke();
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarListLedgerEntries()
    var
        SemLedgEntry: Record "Seminar Ledger Entry";
        SeminarList: TestPage "Seminar List";
        SemLedgEntries: TestPage "Seminar Ledger Entries";
    begin
        SemLedgEntry.FindFirst();

        SeminarList.OpenView();
        SeminarList.GotoKey(SemLedgEntry."Seminar No.");
        SemLedgEntries.Trap();
        SeminarList."Ledger E&ntries".Invoke();
        if SemLedgEntries.FILTER.GetFilter("Seminar No.") <> SeminarList."No.".Value() then
            Error('Unexpected filter on %1.', SemLedgEntries.Caption());
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarCardLedgerEntries()
    var
        SemLedgEntry: Record "Seminar Ledger Entry";
        SeminarCard: TestPage "Seminar List";
        SemLedgEntries: TestPage "Seminar Ledger Entries";
    begin
        SemLedgEntry.FindFirst();

        SeminarCard.OpenView();
        SeminarCard.GotoKey(SemLedgEntry."Seminar No.");
        SemLedgEntries.Trap();
        SeminarCard."Ledger E&ntries".Invoke();
        if SemLedgEntries.FILTER.GetFilter("Seminar No.") <> SeminarCard."No.".Value() then
            Error('Unexpected filter on %1.', SemLedgEntries.Caption());
    end;

    [ModalPageHandler]
    [Scope('Internal')]
    procedure NoSeriesListHandler(var NoSeriesList: TestPage "No. Series List")
    var
        SeminarSetup: Record "Seminar Setup";
        NoSeriesRel: Record "No. Series Relationship";
        NoSeries: Record "No. Series";
    begin
        SeminarSetup.Get();
        NoSeriesList.GotoKey(SeminarSetup."Seminar Nos.");

        NoSeriesRel.SetRange(Code, SeminarSetup."Seminar Nos.");
        if NoSeriesRel.FindSet() then
            repeat
                NoSeriesList.GotoKey(NoSeriesRel."Series Code");
            until NoSeriesRel.Next() = 0;

        NoSeriesList.First();
        repeat
            if NoSeriesList.Code.Value() <> SeminarSetup."Seminar Nos." then begin
                NoSeriesRel.Code := SeminarSetup."Seminar Nos.";
                NoSeriesRel."Series Code" := CopyStr(NoSeriesList.Code.Value(), 1, 20);
                NoSeriesRel.Find('=');
            end;
        until not NoSeriesList.Next();

        NoSeries.FindSet();
        repeat
            NoSeriesRel.Code := SeminarSetup."Seminar Nos.";
            NoSeriesRel."Series Code" := NoSeries.Code;
            NoSeriesRel.Find('=');
        until NoSeriesRel.IsEmpty();
        asserterror NoSeriesList.GotoKey(NoSeries.Code);

        NoSeriesList.GotoKey(SeminarSetup."Seminar Nos.");
        NoSeriesList.OK().Invoke();
    end;
}

