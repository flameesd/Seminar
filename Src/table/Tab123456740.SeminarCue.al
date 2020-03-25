table 123456740 "Seminar Cue"
{
    // CSD1.00 - 2013-09-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table

    Caption = 'Seminar Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; Planned; Integer)
        {
            CalcFormula = Count ("Seminar Registration Header" WHERE (Status = CONST (Planning)));
            Caption = 'Planned';
            FieldClass = FlowField;
        }
        field(3; Registered; Integer)
        {
            CalcFormula = Count ("Seminar Registration Header" WHERE (Status = CONST (Registration)));
            Caption = 'Registered';
            FieldClass = FlowField;
        }
        field(4; Closed; Integer)
        {
            CalcFormula = Count ("Seminar Registration Header" WHERE (Status = CONST (Closed)));
            Caption = 'Closed';
            FieldClass = FlowField;
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

