table 123456704 "Seminar Comment Line"
{
    // CSD1.00 - 2013-03-01 - D. E. Veloper
    //   Chapter 3 - Lab 1
    //     - Created new table

    Caption = 'Seminar Comment Line';
    DrillDownPageID = "Seminar Comment List";
    LookupPageID = "Seminar Comment List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Seminar Registration,Posted Seminar Registration';
            OptionMembers = "Seminar Registration","Posted Seminar Registration";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure SetUpNewLine()
    var
        SeminarCommentLine: Record "Sales Comment Line";
    begin
        SeminarCommentLine.SetRange("Document Type", "Document Type");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange(Date, WorkDate());
        if SeminarCommentLine.IsEmpty() then
            Date := WorkDate();
    end;
}

