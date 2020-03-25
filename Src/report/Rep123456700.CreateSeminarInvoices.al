report 123456700 "Create Seminar Invoices"
{
    // CSD1.00 - 2013-06-02 - D. E. Veloper
    //   Chapter 6 - Lab 2
    //     - Created new report

    Caption = 'Create Seminar Invoices';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Seminar Ledger Entry"; "Seminar Ledger Entry")
        {

            trigger OnAfterGetRecord()
            begin
                if "Bill-to Customer No." <> Customer."No." then
                    Customer.Get("Bill-to Customer No.");

                if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1
                else begin
                    if "Seminar Ledger Entry"."Bill-to Customer No." <> SalesHeader."Bill-to Customer No." then begin
                        Window.Update(1, "Bill-to Customer No.");
                        if SalesHeader."No." <> '' then
                            FinalizeSalesInvoiceHeader();
                        InsertSalesInvoiceHeader();
                    end;
                    Window.Update(2, "Seminar Registration No.");

                    case Type of
                        Type::Resource:
                            begin
                                SalesLine.Type := SalesLine.Type::Resource;
                                case "Charge Type" of
                                    "Charge Type"::Instructor:
                                        SalesLine."No." := "Instructor Resource No.";
                                    "Charge Type"::Room:
                                        SalesLine."No." := "Room Resource No.";
                                    "Charge Type"::Participant:
                                        SalesLine."No." := "Instructor Resource No.";
                                end;
                            end;
                    end;

                    SalesLine."Document Type" := SalesHeader."Document Type";
                    SalesLine."Document No." := SalesHeader."No.";
                    SalesLine."Line No." := NextLineNo;
                    SalesLine.Validate("No.");
                    Seminar.Get("Seminar No.");
                    if "Seminar Ledger Entry".Description <> '' then
                        SalesLine.Description := "Seminar Ledger Entry".Description
                    else
                        SalesLine.Description := Seminar.Name;

                    SalesLine."Unit Price" := "Unit Price";
                    if SalesHeader."Currency Code" <> '' then begin
                        SalesHeader.TestField("Currency Factor");
                        SalesLine."Unit Price" :=
                          Round(
                            CurrencyExchRate.ExchangeAmtLCYToFCY(
                            WorkDate(), SalesHeader."Currency Code",
                            SalesLine."Unit Price", SalesHeader."Currency Factor"));
                    end;
                    SalesLine.Validate(Quantity, Quantity);
                    SalesLine.Insert();
                    NextLineNo := NextLineNo + 10000;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                if SalesHeader."No." = '' then
                    Message(Text007Msg)
                else begin
                    FinalizeSalesInvoiceHeader();
                    if NoOfSalesInvErrors = 0 then
                        Message(
                          Text005Msg,
                          NoOfSalesInv)
                    else
                        Message(
                          Text006Msg,
                          NoOfSalesInvErrors)
                end;
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateReq = 0D then
                    Error(Text000Err);
                if DocDateReq = 0D then
                    Error(Text001Err);

                Window.Open(
                  Text002Lbl +
                  Text003Lbl +
                  Text004Lbl);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDateReqField; PostingDateReq)
                    {
                        Caption = 'Posting Date';
                    }
                    field(DocDateReqField; DocDateReq)
                    {
                        Caption = 'Document Date';
                    }
                    field(CalcInvoiceDiscountField; CalcInvoiceDiscount)
                    {
                        Caption = 'Calc. Inv. Discount';
                    }
                    field(PostInvoicesField; PostInvoices)
                    {
                        Caption = 'Post Invoices';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if PostingDateReq = 0D then
                PostingDateReq := WorkDate();
            if DocDateReq = 0D then
                DocDateReq := WorkDate();
            SalesSetup.Get();
            CalcInvoiceDiscount := SalesSetup."Calc. Inv. Discount";
        end;
    }

    labels
    {
    }

    var
        Seminar: Record Seminar;
        CurrencyExchRate: Record "Currency Exchange Rate";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
        SalesPost: Codeunit "Sales-Post";
        CalcInvoiceDiscount: Boolean;
        PostInvoices: Boolean;
        NextLineNo: Integer;
        NoOfSalesInvErrors: Integer;
        NoOfSalesInv: Integer;
        PostingDateReq: Date;
        DocDateReq: Date;
        Window: Dialog;
        Text000Err: Label 'Please enter the posting date.';
        Text001Err: Label 'Please enter the document date.';
        Text002Lbl: Label 'Creating Seminar Invoices...\\';
        Text003Lbl: Label 'Customer No.      #1##########\';
        Text004Lbl: Label 'Registration No.   #2##########\';
        Text005Msg: Label 'The number of invoice(s) created is %1.';
        Text006Msg: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
        Text007Msg: Label 'There is nothing to invoice.';

    local procedure FinalizeSalesInvoiceHeader()
    begin
        with SalesHeader do begin
            if CalcInvoiceDiscount then
                SalesCalcDiscount.Run(SalesLine);
            Get("Document Type", "No.");
            Commit();
            Clear(SalesCalcDiscount);
            Clear(SalesPost);
            NoOfSalesInv := NoOfSalesInv + 1;
            if PostInvoices then begin
                Clear(SalesPost);
                if not SalesPost.Run(SalesHeader) then
                    NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
            end;
        end;
    end;

    local procedure InsertSalesInvoiceHeader()
    begin
        with SalesHeader do begin
            Init();
            "Document Type" := "Document Type"::Invoice;
            "No." := '';
            Insert(true);
            Validate("Sell-to Customer No.", "Seminar Ledger Entry"."Bill-to Customer No.");
            if "Bill-to Customer No." <> "Sell-to Customer No." then
                Validate("Bill-to Customer No.", "Seminar Ledger Entry"."Bill-to Customer No.");
            Validate("Posting Date", PostingDateReq);
            Validate("Document Date", DocDateReq);
            Validate("Currency Code", '');
            Modify();
            Commit();

            NextLineNo := 10000;
        end;
    end;
}

