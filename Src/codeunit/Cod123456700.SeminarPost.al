codeunit 123456700 "Seminar-Post"
{
    // CSD1.00 - 2013-04-05 - D. E. Veloper
    //   Chapter 4 - Lab 5
    //     - Created new codeunit
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Integrated Dimensions functionality

    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        ClearAll();
        SeminarRegHeader := Rec;
        with SeminarRegHeader do begin
            TestField("Posting Date");
            TestField("Document Date");
            TestField("Seminar No.");
            TestField(Duration);
            TestField("Instructor Resource No.");
            TestField("Room Resource No.");
            TestField(Status, Status::Closed);

            CheckDim();

            SeminarRegLine.Reset();
            SeminarRegLine.SetRange("Document No.", "No.");
            if SeminarRegLine.IsEmpty() then
                Error(Text001Err);

            Window.Open(
              '#1#################################\\' +
               Text002Msg);
            Window.Update(1, StrSubstNo('%1 %2', Text003Msg, "No."));

            if SeminarRegHeader."Posting No." = '' then begin
                TestField("Posting No. Series");
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", "Posting Date", true);
                Modify();
                Commit();
            end;
            SeminarRegLine.LockTable();

            SourceCodeSetup.Get();
            SourceCode := SourceCodeSetup.Seminar;

            PstdSeminarRegHeader.Init();
            PstdSeminarRegHeader.TransferFields(SeminarRegHeader);
            PstdSeminarRegHeader."No." := "Posting No.";
            PstdSeminarRegHeader."No. Series" := "Posting No. Series";
            PstdSeminarRegHeader."Source Code" := SourceCode;
            PstdSeminarRegHeader."User ID" := CopyStr(UserId(), 1, 50);
            PstdSeminarRegHeader.Insert();

            Window.Update(1, StrSubstNo(Text004Msg, "No.",
              PstdSeminarRegHeader."No."));

            CopyCommentLines(
              SeminarCommentLine."Document Type"::"Seminar Registration",
              SeminarCommentLine."Document Type"::"Posted Seminar Registration",
              "No.", PstdSeminarRegHeader."No.");
            CopyCharges("No.", PstdSeminarRegHeader."No.");

            LineCount := 0;
            SeminarRegLine.Reset();
            SeminarRegLine.SetRange("Document No.", "No.");
            if SeminarRegLine.FindSet() then
                repeat
                    LineCount := LineCount + 1;
                    Window.Update(2, LineCount);

                    SeminarRegLine.TestField("Bill-to Customer No.");
                    SeminarRegLine.TestField("Participant Contact No.");

                    if not SeminarRegLine."To Invoice" then begin
                        SeminarRegLine."Seminar Price" := 0;
                        SeminarRegLine."Line Discount %" := 0;
                        SeminarRegLine."Line Discount Amount" := 0;
                        SeminarRegLine.Amount := 0;
                    end;

                    // Post seminar entry
                    PostSeminarJnlLine(2); // Participant

                    // Insert posted seminar registration line
                    PstdSeminarRegLine.Init();
                    PstdSeminarRegLine.TransferFields(SeminarRegLine);
                    PstdSeminarRegLine."Document No." := PstdSeminarRegHeader."No.";
                    PstdSeminarRegLine.Insert();
                until SeminarRegLine.Next() = 0;

            // Post charges to seminar ledger
            PostCharges();

            // Post instructor to seminar ledger
            PostSeminarJnlLine(0); // Instructor

            // Post seminar room to seminar ledger
            PostSeminarJnlLine(1); // Room

            Delete();
            SeminarRegLine.DeleteAll();

            SeminarCommentLine.SetRange("Document Type",
              SeminarCommentLine."Document Type"::"Seminar Registration");
            SeminarCommentLine.SetRange("No.", "No.");
            SeminarCommentLine.DeleteAll();

            SeminarCharge.SetRange(Description);
            SeminarCharge.DeleteAll();
        end;
        Rec := SeminarRegHeader;
    end;

    var
        SeminarRegHeader: Record "Seminar Registration Header";
        SeminarRegLine: Record "Seminar Registration Line";
        PstdSeminarRegHeader: Record "Posted Seminar Reg. Header";
        PstdSeminarRegLine: Record "Posted Seminar Reg. Line";
        SeminarCommentLine: Record "Seminar Comment Line";
        SeminarCommentLine2: Record "Seminar Comment Line";
        SeminarCharge: Record "Seminar Charge";
        PstdSeminarCharge: Record "Posted Seminar Charge";
        Room: Record Resource;
        Instructor: Record Resource;
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record "Seminar Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ResJnlLine: Record "Res. Journal Line";
        SeminarJnlPostLine: Codeunit "Seminar Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        SourceCode: Code[10];
        LineCount: Integer;
        Text001Err: Label 'There is no participant to post.';
        Text002Msg: Label 'Posting lines              #2######\';
        Text003Msg: Label 'Registration';
        Text004Msg: Label 'Registration %1  -> Posted Reg. %2';
        Text005Err: Label 'The combination of dimensions used in %1 is blocked. %2';
        Text006Err: Label 'The combination of dimensions used in %1,  line no. %2 is blocked. %3';
        Text007Err: Label 'The dimensions used in %1 are invalid. %2';
        Text008Err: Label 'The dimensions used in %1, line no. %2 are invalid. %3';

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SeminarCommentLine.Reset();
        SeminarCommentLine.SetRange("Document Type", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := ToDocumentType;
                SeminarCommentLine2."No." := ToNumber;
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.Next() = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20])
    begin
        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", FromNumber);
        if SeminarCharge.FindSet() then
            repeat
                PstdSeminarCharge.TransferFields(SeminarCharge);
                PstdSeminarCharge."Document No." := ToNumber;
                PstdSeminarCharge.Insert();
            until SeminarCharge.Next() = 0;
    end;

    local procedure PostResJnlLine(Resource: Record Resource): Integer
    begin
        with SeminarRegHeader do begin
            Resource.TestField("Quantity Per Day");
            ResJnlLine.Init();
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine."Reason Code" := "Reason Code";
            ResJnlLine.Description := "Seminar Name";
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Posting No. Series" := "Posting No. Series";
            ResJnlLine."Source Code" := SourceCode;
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            ResJnlLine."Unit Cost" := Resource."Unit Cost";
            ResJnlLine."Qty. per Unit of Measure" := 1;
            ResJnlLine.Quantity := Duration * Resource."Quantity Per Day";
            ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" * ResJnlLine.Quantity;
            ResJnlLine."Seminar No." := "Seminar No.";
            ResJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
            ResJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            ResJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            ResJnlLine."Dimension Set ID" := "Dimension Set ID";
            ResJnlPostLine.RunWithCheck(ResJnlLine);
        end;

        ResLedgEntry.FindLast();
        exit(ResLedgEntry."Entry No.");
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor,Room,Participant,Charge)
    begin
        with SeminarRegHeader do begin
            SeminarJnlLine.Init();
            SeminarJnlLine."Seminar No." := "Seminar No.";
            SeminarJnlLine."Posting Date" := "Posting Date";
            SeminarJnlLine."Document Date" := "Document Date";
            SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Charge Type" := ChargeType;
            SeminarJnlLine."Instructor Resource No." := "Instructor Resource No.";
            SeminarJnlLine."Starting Date" := "Starting Date";
            SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Room Resource No." := "Room Resource No.";
            SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
            SeminarJnlLine."Source No." := "Seminar No.";
            SeminarJnlLine."Source Code" := SourceCode;
            SeminarJnlLine."Reason Code" := "Reason Code";
            SeminarJnlLine."Posting No. Series" := "Posting No. Series";
            SeminarJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            SeminarJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            SeminarJnlLine."Dimension Set ID" := "Dimension Set ID";
            case ChargeType of
                ChargeType::Instructor:
                    begin
                        Instructor.Get("Instructor Resource No.");
                        SeminarJnlLine.Description := Instructor.Name;
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := false;
                        SeminarJnlLine.Quantity := Duration;
                        // Post to resource ledger
                        SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                    end;
                ChargeType::Room:
                    begin
                        Room.Get("Room Resource No.");
                        SeminarJnlLine.Description := Room.Name;
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := false;
                        SeminarJnlLine.Quantity := Duration;
                        // Post to resource ledger
                        SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Room);
                    end;
                ChargeType::Participant:
                    begin
                        SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                        SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                        SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name";
                        SeminarJnlLine.Description := SeminarRegLine."Participant Name";
                        SeminarJnlLine.Type := SeminarJnlLine.Type::Resource;
                        SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice";
                        SeminarJnlLine.Quantity := 1;
                        SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                        SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                        SeminarJnlLine."Dimension Set ID" := SeminarRegLine."Dimension Set ID";
                    end;
                ChargeType::Charge:
                    begin
                        SeminarJnlLine.Description := SeminarCharge.Description;
                        SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No.";
                        SeminarJnlLine.Type := SeminarCharge.Type;
                        SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                        SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price";
                        SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                        SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                    end;
            end;
            SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
        end;
    end;

    local procedure PostCharges()
    begin
        SeminarCharge.Reset();
        SeminarCharge.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarCharge.FindSet() then
            repeat
                PostSeminarJnlLine(3); // Charge
            until SeminarCharge.Next() = 0;
    end;

    local procedure CheckDim()
    var
        SeminarRegLine2: Record "Seminar Registration Line";
    begin
        SeminarRegLine2."Line No." := 0;
        CheckDimValuePosting(SeminarRegLine2);
        CheckDimComb(SeminarRegLine2);

        SeminarRegLine2.SetRange("Document No.", SeminarRegHeader."No.");
        if SeminarRegLine2.FindSet() then
            repeat
                CheckDimComb(SeminarRegLine2);
                CheckDimValuePosting(SeminarRegLine2);
            until SeminarRegLine2.Next() = 0;
    end;

    local procedure CheckDimComb(SeminarRegLine: Record "Seminar Registration Line")
    begin
        if SeminarRegLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb(SeminarRegHeader."Dimension Set ID") then
                Error(
                  Text005Err,
                  SeminarRegHeader."No.", DimMgt.GetDimCombErr());

        if SeminarRegLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(SeminarRegLine."Dimension Set ID") then
                Error(
                  Text006Err,
                  SeminarRegHeader."No.", SeminarRegLine."Line No.", DimMgt.GetDimCombErr());
    end;

    local procedure CheckDimValuePosting(var SeminarRegLine2: Record "Seminar Registration Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if SeminarRegLine2."Line No." = 0 then begin
            TableIDArr[1] := DATABASE::Seminar;
            NumberArr[1] := SeminarRegHeader."Seminar No.";
            TableIDArr[2] := DATABASE::Resource;
            NumberArr[2] := SeminarRegHeader."Instructor Resource No.";
            TableIDArr[3] := DATABASE::Resource;
            NumberArr[3] := SeminarRegHeader."Room Resource No.";
            if not DimMgt.CheckDimValuePosting(
              TableIDArr,
              NumberArr,
              SeminarRegHeader."Dimension Set ID")
            then
                Error(
                  Text007Err,
                  SeminarRegHeader."No.",
                  DimMgt.GetDimValuePostingErr());
        end else begin
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := SeminarRegLine2."Bill-to Customer No.";
            if not DimMgt.CheckDimValuePosting(
              TableIDArr,
              NumberArr,
              SeminarRegLine2."Dimension Set ID")
            then
                Error(
                  Text008Err,
                  SeminarRegHeader."No.", SeminarRegLine2."Line No.", DimMgt.GetDimValuePostingErr());
        end;
    end;
}

