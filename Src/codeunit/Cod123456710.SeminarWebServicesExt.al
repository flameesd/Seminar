codeunit 123456710 "Seminar Web Services Ext."
{
    // CSD1.00 - 2013-11-01 - D. E. Veloper
    //   Chapter 11 - Lab 1
    //     - Created new codeunit


    trigger OnRun()
    begin
    end;

    var
        Text001Err: Label 'You cannot register for this seminar. Maximum number of participants have already been registered.';

    [Scope('Internal')]
    procedure RegisterParticipant(SemRegHeader: Record "Seminar Registration Header"; CustNo: Code[20]; ContNo: Code[20])
    var
        SemRegLine: Record "Seminar Registration Line";
        LineNo: Integer;
    begin
        LineNo := 10000;
        SemRegLine.LockTable();
        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindLast() then
            LineNo := LineNo + SemRegLine."Line No.";

        SemRegHeader.CalcFields("Registered Participants");
        if SemRegHeader."Registered Participants" >= SemRegHeader."Maximum Participants" then
            Error(Text001Err);

        SemRegLine.Reset();
        SemRegLine.Init();
        SemRegLine.Validate("Document No.", SemRegHeader."No.");
        SemRegLine."Line No." := LineNo;
        SemRegLine.Validate("Bill-to Customer No.", CustNo);
        SemRegLine.Validate("Participant Contact No.", ContNo);
        SemRegLine."Registration Date" := Today();
        SemRegLine.Insert(true);
    end;
}

