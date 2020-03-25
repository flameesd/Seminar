codeunit 123456705 "SeminarMailManagement"
{
    // CSD1.00 - 2013-10-01 - D. E. Veloper
    //   Chapter 10 - Lab 1
    //     - Created new codeunit


    trigger OnRun()
    begin
    end;

    var
        SeminarSetup: Record "Seminar Setup";
        CompanyInfo: Record "Company Information";
        SMTP: Codeunit "SMTP Mail";
        Environment: DotNet Environment;
        NoOfErrors: Integer;
        ConfirmationBody: Text;
        Text001Lbl: Label 'Registration Confirmation for Seminar "%1"';
        Text002Err: Label 'Sending e-mail confirmations was not successful. The last error message was:\\%1';
        Text003Msg: Label 'All e-mail confirmations have been sent successfully.';

    [Scope('Internal')]
    procedure Initialize()
    var
        Template: File;
        Line: Text;
    begin
        SeminarSetup.Get();
        SeminarSetup.TestField("Confirmation Template File");

        CompanyInfo.Get();
        CompanyInfo.TestField(Name);
        CompanyInfo.TestField("E-Mail");

        Clear(SMTP);
        NoOfErrors := 0;
        ConfirmationBody := '';

        Template.TextMode(true);
        Template.WriteMode(false);
        Template.Open(SeminarSetup."Confirmation Template File");
        while Template.Pos() < Template.Len() do begin
            Template.Read(Line);
            ConfirmationBody += Line + Environment.NewLine();
        end;
        Template.Close();
    end;

    [Scope('Internal')]
    procedure SendConfirmations(SemRegHeader: Record "Seminar Registration Header")
    var
        SemRegLine: Record "Seminar Registration Line";
        Contact: Record Contact;
    begin
        Initialize();

        SemRegLine.SetRange("Document No.", SemRegHeader."No.");
        if SemRegLine.FindSet(true) then
            repeat
                Contact.Get(SemRegLine."Participant Contact No.");
                Contact.TestField("E-Mail");
                if SendMail(
                  Contact."E-Mail",
                  StrSubstNo(
                    Text001Lbl,
                    SemRegHeader."Seminar Name"),
                  StrSubstNo(
                    ConfirmationBody,
                    Contact.Name,
                    SemRegHeader."Seminar Name",
                    SemRegHeader."Starting Date"))
                then begin
                    SemRegLine."Confirmation Date" := Today();
                    SemRegLine.Modify();
                end;
            until SemRegLine.Next() = 0;

        if NoOfErrors > 0 then
            Error(Text002Err, SMTP.GetLastSendMailErrorText());

        Message(Text003Msg);
    end;

    local procedure SendMail(ToEmail: Text; Subject: Text; Body: Text): Boolean
    begin
        SMTP.CreateMessage(
          CompanyInfo.Name,
          CompanyInfo."E-Mail",
          ToEmail,
          Subject,
          Body,
          false);

        if not SMTP.TrySend() then begin
            NoOfErrors := NoOfErrors + 1;
            exit(false);
        end else
            exit(true);
    end;
}

