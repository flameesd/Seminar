page 123456714 "Seminar Statistics"
{
    // CSD1.00 - 2013-07-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - New page created

    Editable = false;
    PageType = Card;
    SourceTable = Seminar;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control1000000002)
                {
                    ShowCaption = false;
                    group("This Period")
                    {
                        Caption = 'This Period';
                        field("SeminarDateName[1]"; SeminarDateName[1])
                        {
                        }
                        field("TotalPrice[1]"; TotalPrice[1])
                        {
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[1]"; TotalPriceNotChargeable[1])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                        }
                        field("TotalPriceChargeable[1]"; TotalPriceChargeable[1])
                        {
                            Caption = 'Total Price (Chargeable)';
                        }
                    }
                    group("This Year")
                    {
                        Caption = 'This Year';
                        field("SeminarDateName[2]"; SeminarDateName[2])
                        {
                        }
                        field("TotalPrice[2]"; TotalPrice[2])
                        {
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[2]"; TotalPriceNotChargeable[2])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                        }
                        field("TotalPriceChargeable[2]"; TotalPriceChargeable[2])
                        {
                            Caption = 'Total Price (Chargeable)';
                        }
                    }
                    group("Last Year")
                    {
                        Caption = 'Last Year';
                        field("SeminarDateName[3]"; SeminarDateName[3])
                        {
                        }
                        field("TotalPrice[3]"; TotalPrice[3])
                        {
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[3]"; TotalPriceNotChargeable[3])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                        }
                        field("TotalPriceChargeable[3]"; TotalPriceChargeable[3])
                        {
                            Caption = 'Total Price (Chargeable)';
                        }
                    }
                    group("To Date")
                    {
                        Caption = 'To Date';
                        field("SeminarDateName[4]"; SeminarDateName[4])
                        {
                        }
                        field("TotalPrice[4]"; TotalPrice[4])
                        {
                            Caption = 'Total Price';
                        }
                        field("TotalPriceNotChargeable[4]"; TotalPriceNotChargeable[4])
                        {
                            Caption = 'Total Price (Not Chargeable)';
                        }
                        field("TotalPriceChargeable[4]"; TotalPriceChargeable[4])
                        {
                            Caption = 'Total Price (Chargeable)';
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetRange("No.", "No.");
        if CurrentDate <> WorkDate() then begin
            CurrentDate := WorkDate();
            DateFilterCalc.CreateAccountingPeriodFilter(SeminarDateFilter[1], SeminarDateName[1], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[2], SeminarDateName[2], CurrentDate, 0);
            DateFilterCalc.CreateFiscalYearFilter(SeminarDateFilter[3], SeminarDateName[3], CurrentDate, -1);
        end;

        for i := 1 to 4 do begin
            SetFilter("Date Filter", SeminarDateFilter[i]);
            CalcFields("Total Price", "Total Price (Not Chargeable)", "Total Price (Chargeable)");
            TotalPrice[i] := "Total Price";
            TotalPriceNotChargeable[i] := "Total Price (Not Chargeable)";
            TotalPriceChargeable[i] := "Total Price (Chargeable)";
        end;
        SetRange("Date Filter", 0D, CurrentDate);
    end;

    var
        DateFilterCalc: Codeunit "DateFilter-Calc";
        SeminarDateFilter: array[4] of Text[30];
        SeminarDateName: array[4] of Text[30];
        CurrentDate: Date;
        TotalPrice: array[4] of Decimal;
        TotalPriceNotChargeable: array[4] of Decimal;
        TotalPriceChargeable: array[4] of Decimal;
        i: Integer;
}

