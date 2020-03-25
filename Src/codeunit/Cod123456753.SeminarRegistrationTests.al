codeunit 123456753 "Seminar Registration Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarRegistrationFromSeminarList()
    var
        Seminar: Record Seminar;
        SeminarList: TestPage "Seminar List";
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        SeminarList.OpenView();
        SeminarList.First();
        SeminarRegistration.Trap();
        SeminarList."Seminar Registration".Invoke();
        SeminarRegistration."Starting Date".Activate();

        Seminar.Get(SeminarList."No.".Value());
        SeminarRegistration."Seminar No.".AssertEquals(Seminar."No.");
        SeminarRegistration."Seminar Name".AssertEquals(Seminar.Name);
        SeminarRegistration.Duration.AssertEquals(Seminar."Seminar Duration");
        SeminarRegistration."Minimum Participants".AssertEquals(Seminar."Minimum Participants");
        SeminarRegistration."Maximum Participants".AssertEquals(Seminar."Maximum Participants");
        SeminarRegistration."Seminar Price".AssertEquals(Seminar."Seminar Price");
        SeminarRegistration."Gen. Prod. Posting Group".AssertEquals(Seminar."Gen. Prod. Posting Group");
        SeminarRegistration."VAT Prod. Posting Group".AssertEquals(Seminar."VAT Prod. Posting Group");

        SeminarRegistration.OK().Invoke();
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarRegistrationRoom()
    var
        Seminar: Record Seminar;
        Resource: Record Resource;
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        Resource.SetRange(Type, Resource.Type::Machine);
        Resource.SetFilter("Maximum Participants", '<>0');
        Resource.FindFirst();

        SeminarRegistration."Room Resource No.".SetValue(Resource."No.");
        SeminarRegistration."Room Name".AssertEquals(Resource.Name);
        SeminarRegistration."Room Address".AssertEquals(Resource.Address);
        SeminarRegistration."Room Address 2".AssertEquals(Resource."Address 2");
        SeminarRegistration."Room Post Code".AssertEquals(Resource."Post Code");
        SeminarRegistration."Room City".AssertEquals(Resource.City);
        SeminarRegistration."Room County".AssertEquals(Resource.County);
        SeminarRegistration."Room Country/Reg. Code".AssertEquals(Resource."Country/Region Code");

        SeminarRegistration.OK().Invoke();
    end;

    [Test]
    [HandlerFunctions('ConfirmMaxParticipants')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarRegistrationRoomMaxParticipants()
    var
        Seminar: Record Seminar;
        Resource: Record Resource;
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        Resource.SetRange(Type, Resource.Type::Machine);
        Resource.SetFilter("Maximum Participants", '<>0');
        Resource.FindFirst();

        SeminarRegistration."Maximum Participants".SetValue(Resource."Maximum Participants" + 1);
        SeminarRegistration."Room Resource No.".SetValue(Resource."No.");
        SeminarRegistration."Maximum Participants".AssertEquals(Resource."Maximum Participants");

        SeminarRegistration.OK().Invoke();
    end;

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestSeminarRegistrationDelete()
    var
        SemReg: Record "Seminar Registration Header";
        Seminar: Record Seminar;
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();
        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        SemReg.Get(SeminarRegistration."No.".Value());
        SemReg.TestField(Status, SemReg.Status::Planning);
        asserterror SemReg.Delete(true);
        SeminarRegistration.Close();

        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");
        SeminarRegistration.Status.SetValue(Format(SemReg.Status::Canceled));
        SemReg.Get(SeminarRegistration."No.".Value());
        SeminarRegistration.OK().Invoke();
        SemReg.Find('=');
        SemReg.Delete(true);
    end;

    [ConfirmHandler]
    [Scope('Internal')]
    procedure ConfirmMaxParticipants(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;
}

