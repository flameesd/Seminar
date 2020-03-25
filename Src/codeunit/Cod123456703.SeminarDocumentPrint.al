codeunit 123456703 "Seminar Document-Print"
{
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 6 - Lab 1
    //     - Created new codeunit


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure PrintSeminarRegistrationHeader(SeminarRegHeader: Record "Seminar Registration Header")
    var
        ReportSelection: Record "Seminar Report Selections";
    begin
        SeminarRegHeader.SetRecFilter();
        ReportSelection.SetRange(Usage, ReportSelection.Usage::Registration);
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.Ascending := false;
        ReportSelection.Find('-');
        repeat
            REPORT.RunModal(ReportSelection."Report ID", true, false, SeminarRegHeader);
        until ReportSelection.Next() = 0;
    end;
}

