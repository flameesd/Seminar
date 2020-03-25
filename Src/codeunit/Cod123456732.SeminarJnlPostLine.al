codeunit 123456732 "Seminar Jnl.-Post Line"
{
    // CSD1.00 - 2013-04-02 - D. E. Veloper
    //   Chapter 4 - Lab 2
    //     - Created new codeunit
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Integrated Dimensions functionality

    TableNo = "Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SeminarJnlLine: Record "Seminar Journal Line";
        SeminarLedgerEntry: Record "Seminar Ledger Entry";
        SeminarRegister: Record "Seminar Register";
        SeminarJnlCheckLine: Codeunit "Seminar Jnl.-Check Line";
        NextEntryNo: Integer;

    [Scope('Internal')]
    procedure RunWithCheck(var SeminarJnlLine2: Record "Seminar Journal Line")
    begin
        SeminarJnlLine.Copy(SeminarJnlLine2);
        Code();
        SeminarJnlLine2 := SeminarJnlLine;
    end;

    [Scope('Internal')]
    procedure "Code"()
    begin
        with SeminarJnlLine do begin
            if EmptyLine() then
                exit;

            SeminarJnlCheckLine.RunCheck(SeminarJnlLine);

            if NextEntryNo = 0 then begin
                SeminarLedgerEntry.LockTable();
                if SeminarLedgerEntry.FindLast() then
                    NextEntryNo := SeminarLedgerEntry."Entry No.";
                NextEntryNo := NextEntryNo + 1;
            end;

            if "Document Date" = 0D then
                "Document Date" := "Posting Date";

            if SeminarRegister."No." = 0 then begin
                SeminarRegister.LockTable();
                if (not SeminarRegister.FindLast()) or (SeminarRegister."To Entry No." <> 0) then begin
                    SeminarRegister.Init();
                    SeminarRegister."No." := SeminarRegister."No." + 1;
                    SeminarRegister."From Entry No." := NextEntryNo;
                    SeminarRegister."To Entry No." := NextEntryNo;
                    SeminarRegister."Creation Date" := Today();
                    SeminarRegister."Source Code" := "Source Code";
                    SeminarRegister."Journal Batch Name" := "Journal Batch Name";
                    SeminarRegister."User ID" := CopyStr(UserId(), 1, 20);
                    SeminarRegister.Insert();
                end;
            end;
            SeminarRegister."To Entry No." := NextEntryNo;
            SeminarRegister.Modify();

            SeminarLedgerEntry.Init();
            SeminarLedgerEntry."Seminar No." := "Seminar No.";
            SeminarLedgerEntry."Posting Date" := "Posting Date";
            SeminarLedgerEntry."Document Date" := "Document Date";
            SeminarLedgerEntry."Entry Type" := "Entry Type";
            SeminarLedgerEntry."Document No." := "Document No.";
            SeminarLedgerEntry.Description := Description;
            SeminarLedgerEntry."Bill-to Customer No." := "Bill-to Customer No.";
            SeminarLedgerEntry."Charge Type" := "Charge Type";
            SeminarLedgerEntry.Type := Type;
            SeminarLedgerEntry.Quantity := Quantity;
            SeminarLedgerEntry."Unit Price" := "Unit Price";
            SeminarLedgerEntry."Total Price" := "Total Price";
            SeminarLedgerEntry."Participant Contact No." := "Participant Contact No.";
            SeminarLedgerEntry."Participant Name" := "Participant Name";
            SeminarLedgerEntry.Chargeable := Chargeable;
            SeminarLedgerEntry."Room Resource No." := "Room Resource No.";
            SeminarLedgerEntry."Instructor Resource No." := "Instructor Resource No.";
            SeminarLedgerEntry."Starting Date" := "Starting Date";
            SeminarLedgerEntry."Seminar Registration No." := "Seminar Registration No.";
            SeminarLedgerEntry."Res. Ledger Entry No." := "Res. Ledger Entry No.";
            SeminarLedgerEntry."Source Type" := "Source Type";
            SeminarLedgerEntry."Source No." := "Source No.";
            SeminarLedgerEntry."Journal Batch Name" := "Journal Batch Name";
            SeminarLedgerEntry."Source Code" := "Source Code";
            SeminarLedgerEntry."Reason Code" := "Reason Code";
            SeminarLedgerEntry."No. Series" := "Posting No. Series";
            SeminarLedgerEntry."User ID" := CopyStr(UserId(), 1, 20);
            SeminarLedgerEntry."Entry No." := NextEntryNo;
            SeminarLedgerEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            SeminarLedgerEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
            SeminarLedgerEntry."Dimension Set ID" := "Dimension Set ID";
            SeminarLedgerEntry.Insert();
            NextEntryNo := NextEntryNo + 1;
        end;
    end;
}

