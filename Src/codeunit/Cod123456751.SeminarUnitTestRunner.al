codeunit 123456751 "Seminar Unit Test Runner"
{
    Subtype = TestRunner;

    trigger OnRun()
    begin
        if SetupMode then
            Setup()
        else
            Test();
    end;

    var
        TestSetup: Record "Seminar Unit Test Setup";
        TestRegister: Record "Seminar Unit Test Register";
        TestEntry: Record "Seminar Unit Test Entry";
        Window: Dialog;
        SetupMode: Boolean;
        SetupCodeunitId: Integer;
        Text001Lbl: Label 'Test: ########1# of ########2#\Codeunit: ################3#\Function: ################4#';
        Current: Integer;

    local procedure Test()
    begin
        InitRegister();

        Window.Open(Text001Lbl);
        TestSetup.SetFilter("Function Name", '<>%1', '');
        TestSetup.SetRange(Run, true);
        Window.Update(2, TestSetup.Count());

        TestSetup.Reset();
        TestSetup.SetRange("Function Name", '');
        TestSetup.SetRange(Run, true);
        if TestSetup.FindSet() then
            repeat
                CODEUNIT.Run(TestSetup."Codeunit ID");
            until TestSetup.Next() = 0;

        Window.Close();
    end;

    local procedure Setup()
    begin
        CODEUNIT.Run(SetupCodeunitId);
    end;

    trigger OnBeforeTestRun(CodeUnitId: Integer; CodeUnitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions): Boolean
    begin
        if FunctionName = '' then begin
            if not SetupMode then
                Window.Update(3, CodeUnitName);
            exit(true);
        end;

        if SetupMode then begin
            InsertSetupLine(CodeUnitId, CopyStr(CodeUnitName, 1, 20), CopyStr(FunctionName, 1, 128));
            exit(false);
        end;

        Current := Current + 1;
        Window.Update(1, Current);
        Window.Update(4, FunctionName);

        if TestSetup.Get(CodeUnitId, FunctionName) then
            exit(TestSetup.Run)
        else
            exit(false);
    end;

    trigger OnAfterTestRun(CodeUnitId: Integer; CodeUnitName: Text; FunctionName: Text; FunctionTestPermissions: TestPermissions; Success: Boolean)
    begin
        if FunctionName = '' then
            exit;

        if TestEntry.FindLast() then;
        TestEntry.Init();
        TestEntry."Entry No." := TestEntry."Entry No." + 1;
        TestEntry."Codeunit ID" := CodeUnitId;
        TestEntry."Codeunit Name" := CopyStr(CodeUnitName, 1, 20);
        TestEntry."Function Name" := CopyStr(FunctionName, 1, 128);
        TestEntry.Success := Success;
        if not Success then
            TestEntry."Error Message" := CopyStr(GetLastErrorText(), 1, 250);
        TestEntry."Creation Date" := TestRegister."Creation Date";
        TestEntry."Creation Time" := TestRegister."Creation Time";
        TestEntry.Insert();

        UpdateRegister();
    end;

    local procedure InitRegister()
    begin
        TestEntry.LockTable();
        TestRegister.LockTable();

        if TestRegister.FindLast() then;
        TestRegister.Init();
        TestRegister."No." := TestRegister."No." + 1;
        TestRegister."Creation Date" := Today();
        TestRegister."Creation Time" := Time();
        TestRegister."User ID" := CopyStr(UserId(), 1, 50);
        TestRegister.Insert();
    end;

    local procedure UpdateRegister()
    begin
        if TestRegister."From Entry No." = 0 then
            TestRegister."From Entry No." := TestEntry."Entry No.";
        TestRegister."To Entry No." := TestEntry."Entry No.";
        TestRegister.Modify();
    end;

    [Scope('Internal')]
    procedure InsertSetupLine(CodeUnitId: Integer; CodeUnitName: Text[30]; FunctionName: Text[128])
    begin
        TestSetup.Init();
        TestSetup."Codeunit ID" := CodeUnitId;
        TestSetup."Codeunit Name" := CodeUnitName;
        TestSetup."Function Name" := FunctionName;
        TestSetup.Run := true;
        TestSetup.Insert();
    end;

    [Scope('Internal')]
    procedure SetSetupMode(NewSetupMode: Boolean; NewSetupCodeunitId: Integer)
    begin
        SetupMode := NewSetupMode;
        SetupCodeunitId := NewSetupCodeunitId;
    end;
}

