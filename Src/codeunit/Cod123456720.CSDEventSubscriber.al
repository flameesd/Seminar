codeunit 123456720 "CSDEventSubscriber"
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;

    var
        PostedSeminarRegHeader: Record "Posted Seminar Reg. Header";
        SeminarLedgEntry: Record "Seminar Ledger Entry";

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterCopyFromResJnlLine', '', true, true)]
    local procedure CSDIntegratedSeminarAfterCopyJnlLine(var ResLedgerEntry: Record "Res. Ledger Entry"; ResJournalLine: Record "Res. Journal Line")
    begin
        ResLedgerEntry."Seminar No." := ResJournalLine."Seminar No.";
        ResLedgerEntry."Seminar Registration No." := ResJournalLine."Seminar Registration No.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterUpdateGlobalDimCode', '', true, true)]
    local procedure CSDIntegratedSeminarAfterUpdateDimCode(TableID: Integer; GlobalDimCodeNo: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    var
        defaultDimension: Record "Default Dimension";
    begin
        if TableID = Database::Seminar then
            defaultDimension.UpdateSeminarGlobalDimCode(GlobalDimCodeNo, AccNo, NewDimValue);        //TODO Can't access to rec."No.", check if the AccNo can be used instead.
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', true, true)]
    local procedure CSDIntegratedSeminarAfterNavFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        navigate: Page Navigate;
    begin
        IF PostedSeminarRegHeader.READPERMISSION() THEN BEGIN
            PostedSeminarRegHeader.RESET();
            PostedSeminarRegHeader.SETFILTER("No.", DocNoFilter);
            PostedSeminarRegHeader.SETFILTER("Posting Date", PostingDateFilter);
            IF PostedSeminarRegHeader.IsEmpty() then
                Message('EMPTY')
            ELSE
                Message('NOT EMPTY');
            navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"Posted Seminar Reg. Header", 0, CopyStr(PostedSeminarRegHeader.TABLECAPTION(), 1, 1024), PostedSeminarRegHeader.COUNT());
        END;
        IF SeminarLedgEntry.READPERMISSION() THEN BEGIN
            SeminarLedgEntry.RESET();
            SeminarLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            SeminarLedgEntry.SETFILTER("Document No.", DocNoFilter);
            SeminarLedgEntry.SETFILTER("Posting Date", PostingDateFilter);
            IF SeminarLedgEntry.IsEmpty() then
                Message('EMPTY')
            ELSE
                Message('NOT EMPTY');
            navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::"Seminar Ledger Entry", 0, CopyStr(SeminarLedgEntry.TABLECAPTION(), 1, 1024), SeminarLedgEntry.COUNT());
        END;
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', true, true)]
    local procedure CSDIntegratedSeminarAfterShowRecords(TableID: Integer)
    begin
        case TableID of
            DATABASE::"Posted Seminar Reg. Header":
                PAGE.RUN(0, PostedSeminarRegHeader);
            DATABASE::"Seminar Ledger Entry":
                PAGE.RUN(0, SeminarLedgEntry);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', true, true)]
    local procedure CSDIntegratedSeminarForDimensionObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption)
    var
        dimensionMgt: Codeunit DimensionManagement;
    begin
        dimensionMgt.InsertObject(TempAllObjWithCaption, Database::Seminar);
    end;
}