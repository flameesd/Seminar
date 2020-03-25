table 123456701 "Seminar Setup"
{
    // CSD1.00 - 2013-02-02 - D. E. Veloper
    //   Chapter 2 - Lab 2
    //     - Created new table
    // 
    // CSD1.00 - 2013-10-01 - D. E. Veloper
    //   Chapter 10 - Lab 1
    //     - Added the Confirmation Template File field

    Caption = 'Seminar Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Seminar Nos."; Code[10])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Seminar Registration Nos."; Code[10])
        {
            Caption = 'Seminar Registration Nos.';
            TableRelation = "No. Series";
        }
        field(4; "Posted Seminar Reg. Nos."; Code[10])
        {
            Caption = 'Posted Seminar Reg. Nos.';
            TableRelation = "No. Series";
        }
        field(5; "Confirmation Template File"; Text[250])
        {
            Caption = 'Confirmation Template File';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

