codeunit 123456756 "Seminar Reporting Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    [Test]
    [HandlerFunctions('HandlePartListReport')]
    [TransactionModel(TransactionModel::None)]
    [Scope('Internal')]
    procedure TestReportSelections()
    var
        SemReg: Record "Seminar Registration Header";
        Seminar: Record Seminar;
        Resource: Record Resource;
        ContBusRel: Record "Contact Business Relation";
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

        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        ContBusRel.FindFirst();

        SeminarRegistration.SeminarRegistrationLines.New();
        SeminarRegistration.SeminarRegistrationLines."Bill-to Customer No.".SetValue(ContBusRel."No.");
        SeminarRegistration.SeminarRegistrationLines."Participant Contact No.".SetValue(ContBusRel."Contact No.");

        SeminarRegistration."Participants &List".Invoke();
    end;

    [ReportHandler]
    [Scope('Internal')]
    procedure HandlePartListReport(var Rpt: Report "Seminar Reg.-Participant List")
    begin
        // No code is necessary. If the handler isn't run, an error occurs anyway.
    end;
}

