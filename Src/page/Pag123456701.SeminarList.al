page 123456701 "Seminar List"
{
    // CSD1.00 - 2013-02-02 - D. E. Veloper
    //   Chapter 2 - Lab 2
    //     - Created new page
    // 
    // CSD1.00 - 2013-05-01 - D. E. Veloper
    //   Chapter 5 - Lab 1
    //     - Added actions:
    //       - New (Seminar Registration)
    //       - Seminar Ledger Entries
    //       - Registrations
    // 
    // CSD1.00 - 2013-07-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - Added actions:
    //       - Statistics
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added actions:
    //       - Dimensions - Single
    //       - Dimensions - Multiple

    Caption = 'Seminar List';
    CardPageID = "Seminar Card";
    Editable = false;
    PageType = List;
    SourceTable = Seminar;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Seminar Duration"; "Seminar Duration")
                {
                }
                field("Seminar Price"; "Seminar Price")
                {
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control10; Links)
            {
            }
            systempart(Control11; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Seminar")
            {
                Caption = '&Seminar';
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = WarrantyLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = FIELD("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "Comment Sheet Seminar";
                    RunPageLink = "Table Name" = CONST(Seminar),
                                  "No." = FIELD("No.");
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Seminar Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Charge Type Filter" = FIELD("Charge Type Filter");
                    ShortCutKey = 'F7';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(123456700),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-Multiple")
                    {
                        Caption = 'Dimensions-Multiple';
                        Image = DimensionSets;

                        trigger OnAction()
                        var
                            Seminar: Record Seminar;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Seminar);
                            DefaultDimMultiple.SetMultiSeminar(Seminar);
                            DefaultDimMultiple.RunModal();
                        end;
                    }
                }
            }
            group("&Registrations")
            {
                Caption = '&Registrations';
                action(Action14)
                {
                    Caption = '&Registrations';
                    Image = Timesheet;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Seminar Registration List";
                    RunPageLink = "Seminar No." = FIELD("No.");
                }
            }
        }
        area(creation)
        {
            action("Seminar Registration")
            {
                Caption = 'Seminar Registration';
                Image = NewTimesheet;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = Page "Seminar Registration";
                RunPageLink = "Seminar No." = FIELD("No.");
                RunPageMode = Create;
            }
        }
    }
}

