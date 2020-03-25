codeunit 123456754 "Seminar Posting Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    [Test]
    [HandlerFunctions('ConfirmPost')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestPostNotClosed()
    var
        SemReg: Record "Seminar Registration Header";
        Seminar: Record Seminar;
        Resource: Record Resource;
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        Resource.SetRange(Type, Resource.Type::Person);
        Resource.FindFirst();
        SeminarRegistration."Instructor Resource No.".SetValue(Resource."No.");

        Resource.SetRange(Type, Resource.Type::Machine);
        Resource.SetFilter("Maximum Participants", '<>0');
        Resource.FindFirst();
        SeminarRegistration."Room Resource No.".SetValue(Resource."No.");

        asserterror SeminarRegistration."P&ost".Invoke();
        if not ((StrPos(GetLastErrorText(), SemReg.FieldCaption(Status)) > 0) and
           (StrPos(GetLastErrorText(), Format(SemReg.Status::Closed)) > 0))
        then
            Error(GetLastErrorText());
    end;

    [Test]
    [HandlerFunctions('ConfirmPost')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestPostNoParticipants()
    var
        SemReg: Record "Seminar Registration Header";
        Seminar: Record Seminar;
        Resource: Record Resource;
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        Resource.SetRange(Type, Resource.Type::Person);
        Resource.FindFirst();
        SeminarRegistration."Instructor Resource No.".SetValue(Resource."No.");

        Resource.SetRange(Type, Resource.Type::Machine);
        Resource.SetFilter("Maximum Participants", '<>0');
        Resource.FindFirst();
        SeminarRegistration."Room Resource No.".SetValue(Resource."No.");

        SeminarRegistration.Status.SetValue(Format(SemReg.Status::Closed));

        asserterror SeminarRegistration."P&ost".Invoke();
        if GetLastErrorText() <> 'There is no participant to post.' then
            Error(GetLastErrorText());
    end;

    [Test]
    [HandlerFunctions('ConfirmPost')]
    [Scope('Internal')]
    procedure TestPostRegister()
    var
        SemReg: Record "Seminar Registration Header";
        Seminar: Record Seminar;
        Resource: Record Resource;
        Register: Record "Seminar Register";
        SourceCodeSetup: Record "Source Code Setup";
        ContBusRel: Record "Contact Business Relation";
        SeminarRegistration: TestPage "Seminar Registration";
        RegNo: Integer;
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        Resource.SetRange(Type, Resource.Type::Person);
        Resource.FindFirst();
        SeminarRegistration."Instructor Resource No.".SetValue(Resource."No.");

        Resource.SetRange(Type, Resource.Type::Machine);
        Resource.SetFilter("Maximum Participants", '<>0');
        Resource.FindFirst();
        SeminarRegistration."Room Resource No.".SetValue(Resource."No.");

        SeminarRegistration.Status.SetValue(Format(SemReg.Status::Closed));

        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.FindFirst();

        SeminarRegistration.SeminarRegistrationLines.New();
        SeminarRegistration.SeminarRegistrationLines."Bill-to Customer No.".SetValue(ContBusRel."No.");
        SeminarRegistration.SeminarRegistrationLines."Participant Contact No.".SetValue(ContBusRel."Contact No.");

        if Register.FindLast() then;
        RegNo := Register."No.";
        SeminarRegistration."P&ost".Invoke();
        Register.FindLast();
        Register.TestField("No.", RegNo + 1);
        Register.TestField("Creation Date", Today());
        Register.TestField("User ID", UserId());

        SourceCodeSetup.Get();
        Register.TestField("Source Code", SourceCodeSetup.Seminar);
    end;

    [ConfirmHandler]
    [Scope('Internal')]
    procedure ConfirmPost(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;
}

