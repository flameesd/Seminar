table 123456700 "Seminar"
{
    // CSD1.00 - 2013-02-02 - D. E. Veloper
    //   Chapter 2 - Lab 2
    //     - Created new table
    // 
    // CSD1.00 - 2013-07-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - Added fields:
    //       - Date Filter
    //       - Charge Type Filter
    //       - Total Price
    //       - Total Price (Not Chargeable)
    //       - Total Price (Chargeable)
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added fields:
    //       - Global Dimension 1 Code
    //       - Global Dimension 2 Code
    //       - Global Dimension 1 Filter
    //       - Global Dimension 2 Filter
    //     - Added functions:
    //       - ValidateShortcutDimCode
    //     - Updated OnInsert and OnModify triggers

    Caption = '¸';
    LookupPageID = "Seminar Card";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then
                    "Search Name" := Name;
            end;
        }
        field(3; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
        }
        field(4; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(5; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(6; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(7; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(8; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(9; Comment; Boolean)
        {
            CalcFormula = Exist ("Comment Line Seminar" WHERE("Table Name" = CONST(Seminar),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Seminar Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Seminar Price';
        }
        field(11; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
            end;
        }
        field(12; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(13; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(21; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(22; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(30; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(31; "Charge Type Filter"; Option)
        {
            Caption = 'Charge Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = 'Instructor,Room,Participant,Charge';
            OptionMembers = Instructor,Room,Participant,Charge;
        }
        field(32; "Total Price"; Decimal)
        {
            CalcFormula = Sum ("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = FIELD("No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Charge Type" = FIELD("Charge Type Filter")));
            Caption = 'Total Price';
            FieldClass = FlowField;
        }
        field(33; "Total Price (Not Chargeable)"; Decimal)
        {
            CalcFormula = Sum ("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = FIELD("No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Charge Type" = FIELD("Charge Type Filter"),
                                                                          Chargeable = CONST(false)));
            Caption = 'Total Price (Not Chargeable)';
            FieldClass = FlowField;
        }
        field(34; "Total Price (Chargeable)"; Decimal)
        {
            CalcFormula = Sum ("Seminar Ledger Entry"."Total Price" WHERE("Seminar No." = FIELD("No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Charge Type" = FIELD("Charge Type Filter"),
                                                                          Chargeable = CONST(true)));
            Caption = 'Total Price (Chargeable)';
            FieldClass = FlowField;
        }
        field(41; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(42; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CommentLine.Reset();
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Seminar);
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll();

        DimMgt.DeleteDefaultDim(DATABASE::Seminar, "No.");
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        DimMgt.UpdateDefaultDim(
          DATABASE::Seminar, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today();
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today();
    end;

    var
        SeminarSetup: Record "Seminar Setup";
        CommentLine: Record "Comment Line Seminar";
        Seminar: Record Seminar;
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;

    [Scope('Internal')]
    procedure AssistEdit(): Boolean
    begin
        with Seminar do begin
            Seminar := Rec;
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("No.");
                Rec := Seminar;
                exit(true);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Seminar, "No.", FieldNumber, ShortcutDimCode);
        Modify();
    end;
}

