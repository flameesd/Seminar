table 123456753 "Seminar Unit Test Entry"
{
    DrillDownPageID = "Seminar Unit Test Entries";
    LookupPageID = "Seminar Unit Test Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Codeunit ID"; Integer)
        {
            Caption = 'Codeunit ID';
        }
        field(3; "Codeunit Name"; Text[30])
        {
            Caption = 'Codeunit Name';
        }
        field(4; "Function Name"; Text[128])
        {
            Caption = 'Function Name';
        }
        field(5; Success; Boolean)
        {
            Caption = 'Success';
        }
        field(6; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(7; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(8; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

