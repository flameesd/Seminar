table 123456751 "Seminar Unit Test Setup"
{
    Caption = 'Seminar Unit Test Setup';

    fields
    {
        field(1; "Codeunit ID"; Integer)
        {
            Caption = 'Codeunit ID';
            NotBlank = true;
        }
        field(2; "Codeunit Name"; Text[30])
        {
            Caption = 'Codeunit Name';
            NotBlank = true;
        }
        field(3; "Function Name"; Text[128])
        {
            Caption = 'Function Name';
        }
        field(4; Run; Boolean)
        {
            Caption = 'Run';
        }
    }

    keys
    {
        key(Key1; "Codeunit ID", "Function Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        TestSetup: Record "Seminar Unit Test Setup";
    begin
        TestField("Function Name", '');

        TestSetup.SetRange("Codeunit ID", "Codeunit ID");
        TestSetup.SetFilter("Function Name", '<>%1', '');
        TestSetup.DeleteAll();
    end;

    trigger OnInsert()
    begin
        if "Function Name" = '' then begin
            Object.Get(Object.Type::Codeunit, '', "Codeunit ID");
            "Codeunit Name" := Object.Name;
            Run := true;
            TestRunner.SetSetupMode(true, "Codeunit ID");
            TestRunner.Run();
        end;
    end;

    var
        "Object": Record "Object";
        TestRunner: Codeunit "Seminar Unit Test Runner";
}

