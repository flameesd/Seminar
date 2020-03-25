table 123456711 "Seminar Registration Line"
{
    // CSD1.00 - 2013-03-01 - D. E. Veloper
    //   Chapter 3 - Lab 1
    //     - Created new table
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added new fields:
    //       - Shortcut Dimension 1 Code
    //       - Shortcut Dimension 2 Code
    //       - Dimension Set ID
    //     - Added functions and modified triggers to support Dimension integration

    Caption = 'Seminar Registration Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Seminar Registration Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then
                    if Registered then
                        Error(Text001Err,
                          FieldCaption("Bill-to Customer No."),
                          FieldCaption(Registered),
                          Registered);

                CreateDim(DATABASE::Customer, "Bill-to Customer No.");
            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            begin
                ContactBusinessRelation.Reset();
                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                if ContactBusinessRelation.FindFirst() then begin
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                    if PAGE.RunModal(PAGE::"Contact List", Contact) = ACTION::LookupOK then
                        "Participant Contact No." := Contact."No.";
                end;

                CalcFields("Participant Name");
            end;

            trigger OnValidate()
            begin
                if ("Bill-to Customer No." <> '') and
                   ("Participant Contact No." <> '')
                then begin
                    Contact.Get("Participant Contact No.");
                    ContactBusinessRelation.Reset();
                    ContactBusinessRelation.SetCurrentKey("Link to Table", "No.");
                    ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                    ContactBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                    if ContactBusinessRelation.FindFirst() then
                        if ContactBusinessRelation."Contact No." <> Contact."Company No." then
                            Error(Text002Err, Contact."No.", Contact.Name, "Bill-to Customer No.");
                end;
            end;
        }
        field(5; "Participant Name"; Text[50])
        {
            CalcFormula = Lookup (Contact.Name WHERE("No." = FIELD("Participant Contact No.")));
            Caption = 'Participant Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Editable = false;
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
        }
        field(10; "Seminar Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Seminar Price';

            trigger OnValidate()
            begin
                Validate("Line Discount %");
            end;
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Seminar Price" = 0 then
                    "Line Discount Amount" := 0
                else begin
                    GLSetup.Get();
                    "Line Discount Amount" := Round("Line Discount %" * "Seminar Price" * 0.01, GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount();
            end;
        }
        field(12; "Line Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            begin
                if "Seminar Price" = 0 then
                    "Line Discount %" := 0
                else begin
                    GLSetup.Get();
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount();
            end;
        }
        field(13; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestField("Bill-to Customer No.");
                TestField("Seminar Price");
                GLSetup.Get();
                Amount := Round(Amount, GLSetup."Amount Rounding Precision");
                "Line Discount Amount" := "Seminar Price" - Amount;
                if "Seminar Price" = 0 then
                    "Line Discount %" := 0
                else
                    "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100, GLSetup."Amount Rounding Precision");
            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            Editable = false;
        }
        field(51; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(52; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions();
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Registered, false);
    end;

    trigger OnInsert()
    begin
        GetSeminarRegHeader();
        "Registration Date" := WorkDate();
        "Seminar Price" := SeminarRegHeader."Seminar Price";
        Amount := SeminarRegHeader."Seminar Price";
    end;

    var
        SeminarRegHeader: Record "Seminar Registration Header";
        ContactBusinessRelation: Record "Contact Business Relation";
        Contact: Record Contact;
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        Text001Err: Label 'You cannot change the %1, because %2 is %3.';
        Text002Err: Label 'Contact %1 %2 is related to a different company than customer %3.';

    [Scope('Internal')]
    procedure GetSeminarRegHeader()
    begin
        if SeminarRegHeader."No." <> "Document No." then
            SeminarRegHeader.Get("Document No.");
    end;

    [Scope('Internal')]
    procedure CalculateAmount()
    begin
        Amount := Round(("Seminar Price" / 100) * (100 - "Line Discount %"));
    end;

    [Scope('Internal')]
    procedure UpdateAmount()
    begin
        GLSetup.Get();
        Amount := Round("Seminar Price" - "Line Discount Amount", GLSetup."Amount Rounding Precision");
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID",
            StrSubstNo('%1 %2',
            "Document No.",
            "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID(
          "Dimension Set ID",
          "Shortcut Dimension 1 Code",
          "Shortcut Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get();
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetSeminarRegHeader();
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, SourceCodeSetup.Seminar,
            "Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code",
            SeminarRegHeader."Dimension Set ID",
            DATABASE::Seminar);
        DimMgt.UpdateGlobalDimFromDimSetID(
          "Dimension Set ID",
          "Shortcut Dimension 1 Code",
          "Shortcut Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(
          FieldNumber,
          ShortcutDimCode,
          "Dimension Set ID");
    end;

    [Scope('Internal')]
    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(
          FieldNumber,
          ShortcutDimCode);
        ValidateShortcutDimCode(
          FieldNumber,
          ShortcutDimCode);
    end;

    [Scope('Internal')]
    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions(
          "Dimension Set ID",
          ShortcutDimCode);
    end;
}

