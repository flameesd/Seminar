codeunit 123456731 "Seminar Jnl.-Check Line"
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
        RunCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        Text000Err: Label 'cannot be a closing date.';
        Text001Err: Label 'is not within your range of allowed posting dates.';
        Text002Err: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003Err: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';

    [Scope('Internal')]
    procedure RunCheck(var SemJnlLine: Record "Seminar Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        with SemJnlLine do begin
            if EmptyLine() then
                exit;

            TestField("Posting Date");
            TestField("Instructor Resource No.");
            TestField("Seminar No.");

            case "Charge Type" of
                "Charge Type"::Instructor:
                    TestField("Instructor Resource No.");
                "Charge Type"::Room:
                    TestField("Room Resource No.");
                "Charge Type"::Participant:
                    TestField("Participant Contact No.");
            end;

            if Chargeable then
                TestField("Bill-to Customer No.");

            if "Posting Date" = ClosingDate("Posting Date") then
                FieldError("Posting Date", Text000Err);

            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                if UserId() <> '' then
                    if UserSetup.Get(UserId()) then begin
                        AllowPostingFrom := UserSetup."Allow Posting From";
                        AllowPostingTo := UserSetup."Allow Posting To";
                    end;
                if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                    GLSetup.Get();
                    AllowPostingFrom := GLSetup."Allow Posting From";
                    AllowPostingTo := GLSetup."Allow Posting To";
                end;
                if AllowPostingTo = 0D then
                    AllowPostingTo := 99991231D;
            end;
            if ("Posting Date" < AllowPostingFrom) or ("Posting Date" > AllowPostingTo) then
                FieldError("Posting Date", Text001Err);

            if ("Document Date" <> 0D) then
                if ("Document Date" = ClosingDate("Document Date")) then
                    FieldError("Document Date", Text000Err);

            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                Error(
                  Text002Err,
                  TableCaption(), "Journal Template Name",
                  "Journal Batch Name", "Line No.",
                  DimMgt.GetDimCombErr());
            TableID[1] := DATABASE::Seminar;
            No[1] := "Seminar No.";
            TableID[2] := DATABASE::Resource;
            No[2] := "Instructor Resource No.";
            TableID[3] := DATABASE::Resource;
            No[3] := "Room Resource No.";
            if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                if "Line No." <> 0 then
                    Error(
                      Text003Err,
                      TableCaption(), "Journal Template Name",
                      "Journal Batch Name", "Line No.",
                      DimMgt.GetDimValuePostingErr())
                else
                    Error(DimMgt.GetDimValuePostingErr());
        end;
    end;
}

