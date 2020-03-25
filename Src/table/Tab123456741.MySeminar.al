table 123456741 "My Seminar"
{
    // CSD1.00 - 2013-09-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table

    Caption = 'My Seminar';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            NotBlank = true;
            TableRelation = Seminar;
        }
    }

    keys
    {
        key(Key1; "User ID", "Seminar No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

