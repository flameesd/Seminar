table 123456710 "Seminar Registration Header"
{
    // CSD1.00 - 2013-03-01 - D. E. Veloper
    //   Chapter 3 - Lab 1
    //     - Created new table
    // 
    // CSD1.00 - 2013-05-01 - D. E. Veloper
    //   Chapter 5 - Lab 1
    //     - Added code to the OnInsert trigger to apply the record link filter
    // 
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 5 - Lab 1
    //     - Added fields:
    //       - No. Printed
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added new fields:
    //       - Shortcut Dimension 1 Code
    //       - Shortcut Dimension 2 Code
    //       - Dimension Set ID
    //     - Added functions and modified triggers to support Dimension integration
    // 
    // CSD1.00 - 2013-11-01 - D. E. Veloper
    //   Chapter 11 - Lab 1
    //     - Added fields:
    //       - Registered Participants

    Caption = 'Seminar Registration Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get();
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if "Starting Date" <> xRec."Starting Date" then
                    TestField(Status, Status::Planning);
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = Seminar;

            trigger OnValidate()
            begin
                if "Seminar No." <> xRec."Seminar No." then begin
                    SeminarRegLine.Reset();
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, true);
                    if not SeminarRegLine.IsEmpty() then
                        Error(
                          Text002Err,
                          FieldCaption("Seminar No."),
                          SeminarRegLine.TableCaption(),
                          SeminarRegLine.FieldCaption(Registered),
                          true);

                    Seminar.Get("Seminar No.");
                    Seminar.TestField(Blocked, false);
                    Seminar.TestField("Gen. Prod. Posting Group");
                    Seminar.TestField("VAT Prod. Posting Group");
                    "Seminar Name" := Seminar.Name;
                    Duration := Seminar."Seminar Duration";
                    "Seminar Price" := Seminar."Seminar Price";
                    "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";
                end;

                CreateDim(
                  DATABASE::Seminar, "Seminar No.",
                  DATABASE::Resource, "Instructor Resource No.",
                  DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource WHERE(Type = CONST(Person));

            trigger OnValidate()
            begin
                CalcFields("Instructor Name");

                CreateDim(
                  DATABASE::Seminar, "Seminar No.",
                  DATABASE::Resource, "Instructor Resource No.",
                  DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(6; "Instructor Name"; Text[50])
        {
            CalcFormula = Lookup (Resource.Name WHERE("No." = FIELD("Instructor Resource No."),
                                                      Type = CONST(Person)));
            Caption = 'Instructor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning,Registration,Closed,Canceled;
        }
        field(8; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource WHERE(Type = CONST(Machine));

            trigger OnValidate()
            begin
                if "Room Resource No." = '' then begin
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Reg. Code" := '';
                end else begin
                    SeminarRoom.Get("Room Resource No.");
                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                    if (CurrFieldNo <> 0) then
                        if (SeminarRoom."Maximum Participants" <> 0) and
                           (SeminarRoom."Maximum Participants" < "Maximum Participants")
                        then
                            if Confirm(Text004Qst, true,
                                 "Maximum Participants",
                                 SeminarRoom."Maximum Participants",
                                 FieldCaption("Maximum Participants"),
                                 "Maximum Participants",
                                 SeminarRoom."Maximum Participants")
                            then
                                "Maximum Participants" := SeminarRoom."Maximum Participants";
                end;

                CreateDim(
                  DATABASE::Seminar, "Seminar No.",
                  DATABASE::Resource, "Instructor Resource No.",
                  DATABASE::Resource, "Room Resource No.");
            end;
        }
        field(12; "Room Name"; Text[100])
        {
            Caption = 'Room Name';
        }
        field(13; "Room Address"; Text[100])
        {
            Caption = 'Room Address';
        }
        field(14; "Room Address 2"; Text[100])
        {
            Caption = 'Room Address 2';
        }
        field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            TableRelation = "Post Code".Code;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed());
            end;
        }
        field(16; "Room City"; Text[30])
        {
            Caption = 'Room City';

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed());
            end;
        }
        field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            TableRelation = "Country/Region";
        }
        field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
        }
        field(19; "Seminar Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Seminar Price';

            trigger OnValidate()
            begin
                if ("Seminar Price" <> xRec."Seminar Price") and
                   (Status <> Status::Canceled)
                then begin
                    SeminarRegLine.Reset();
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, false);
                    if SeminarRegLine.FindSet(false, false) then
                        if Confirm(Text005Qst, false,
                             FieldCaption("Seminar Price"),
                             SeminarRegLine.TableCaption())
                        then begin
                            repeat
                                SeminarRegLine.Validate("Seminar Price", "Seminar Price");
                                SeminarRegLine.Modify();
                            until SeminarRegLine.Next() = 0;
                            Modify();
                        end;
                end;
            end;
        }
        field(20; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(21; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(22; Comment; Boolean)
        {
            CalcFormula = Exist ("Seminar Comment Line" WHERE("Document Type" = CONST("Seminar Registration"),
                                                              "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(25; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
        }
        field(26; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        field(27; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series".Code;

            trigger OnLookup()
            begin
                with SeminarRegHeader do begin
                    SeminarRegHeader := Rec;
                    SeminarSetup.Get();
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series")
                    then
                        Validate("Posting No. Series");
                    Rec := SeminarRegHeader;
                end;
            end;

            trigger OnValidate()
            begin
                if "Posting No. Series" <> '' then begin
                    SeminarSetup.Get();
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(40; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
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
        field(61; "Registered Participants"; Integer)
        {
            CalcFormula = Count ("Seminar Registration Line" WHERE("Document No." = FIELD("No.")));
            Caption = 'Registered Participants';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim();
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status, Status::Canceled);

        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.SetRange(Registered, true);
        if SeminarRegLine.Find('-') then
            Error(
              Text001Err,
              SeminarRegLine.TableCaption(),
              SeminarRegLine.FieldCaption(Registered),
              true);
        SeminarRegLine.SetRange(Registered);
        SeminarRegLine.DeleteAll(true);

        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", "No.");
        if not SeminarCharge.IsEmpty() then
            Error(Text006Err, SeminarCharge.TableCaption());

        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        InitRecord();

        if GetFilter("Seminar No.") <> '' then
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
                Validate("Seminar No.", GetRangeMin("Seminar No."));
    end;

    var
        PostCode: Record "Post Code";
        Seminar: Record Seminar;
        SeminarCommentLine: Record "Seminar Comment Line";
        SeminarCharge: Record "Seminar Charge";
        SeminarRegHeader: Record "Seminar Registration Header";
        SeminarRegLine: Record "Seminar Registration Line";
        SeminarRoom: Record Resource;
        SeminarSetup: Record "Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Text001Err: Label 'You cannot delete the Seminar Registration, because there is at least one %1 where %2=%3.';
        Text002Err: Label 'You cannot change the %1, because there is at least one %2 with %3=%4.';
        Text004Qst: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        Text005Qst: Label 'Should the new %1 be copied to all %2 that are not yet invoiced?';
        Text006Err: Label 'You cannot delete the Seminar Registration, because there is at least one %1.';
        Text009Qst: Label 'You may have changed a dimension.\\Do you want to update the lines?';

    [Scope('Internal')]
    procedure AssistEdit(OldSeminarRegHeader: Record "Seminar Registration Header"): Boolean
    begin
        with SeminarRegHeader do begin
            SeminarRegHeader := Rec;
            SeminarSetup.Get();
            SeminarSetup.TestField("Seminar Registration Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", "No. Series") then begin
                SeminarSetup.Get();
                SeminarSetup.TestField("Seminar Registration Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := SeminarRegHeader;
                exit(true);
            end;
        end;
    end;

    [Scope('Internal')]
    procedure InitRecord()
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        "Document Date" := WorkDate();
        SeminarSetup.Get();
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    [Scope('Internal')]
    procedure SeminarRegLinesExist(): Boolean
    begin
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        exit(SeminarRegLine.FindFirst());
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get();
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No,
          SourceCodeSetup.Seminar,
          "Shortcut Dimension 1 Code",
          "Shortcut Dimension 2 Code", 0, 0);
        if (OldDimSetID <> "Dimension Set ID") and
          SeminarRegLinesExist()
        then begin
            Modify();
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(
          FieldNumber,
          ShortcutDimCode,
          "Dimension Set ID");
        if "No." <> '' then
            Modify();
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist() then
                UpdateAllLineDim(
                  "Dimension Set ID",
                  OldDimSetID);
        end;
    end;

    [Scope('Internal')]
    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", "No.",
            "Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify();
            if SeminarRegLinesExist() then
                UpdateAllLineDim(
                  "Dimension Set ID",
                  OldDimSetID);
        end;
    end;

    [Scope('Internal')]
    procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text009Qst) then
            exit;
        SeminarRegLine.Reset();
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.LockTable();
        if SeminarRegLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(
                  SeminarRegLine."Dimension Set ID",
                  NewParentDimSetID,
                  OldParentDimSetID);
                if SeminarRegLine."Dimension Set ID" <> NewDimSetID
                then begin
                    SeminarRegLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      SeminarRegLine."Dimension Set ID",
                      SeminarRegLine."Shortcut Dimension 1 Code",
                      SeminarRegLine."Shortcut Dimension 2 Code");
                    SeminarRegLine.Modify();
                end;
            until SeminarRegLine.Next() = 0;
    end;
}

