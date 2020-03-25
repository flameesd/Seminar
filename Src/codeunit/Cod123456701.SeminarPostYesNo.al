codeunit 123456701 "Seminar-Post (Yes/No)"
{
    // CSD1.00 - 2013-04-05 - D. E. Veloper
    //   Chapter 4 - Lab 5
    //     - Created new codeunit

    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        SeminarRegHeader.Copy(Rec);
        Code();
        Rec := SeminarRegHeader;
    end;

    var
        SeminarRegHeader: Record "Seminar Registration Header";
        SeminarPost: Codeunit "Seminar-Post";
        Text001Qst: Label 'Do you want to post the Registration?';

    local procedure "Code"()
    begin
        if not Confirm(Text001Qst, false) then
            exit;
        SeminarPost.Run(SeminarRegHeader);
        Commit();
    end;
}

