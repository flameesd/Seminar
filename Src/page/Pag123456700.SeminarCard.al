page 123456700 "Seminar Card"
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
    //     - Added the Total Price field to the General tab
    //     - Added actions:
    //       - Statistics
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added actions:
    //       - Dimensions

    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = Seminar;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit() then
                            CurrPage.Update();
                    end;
                }
                field(Name; Name)
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Seminar Duration"; "Seminar Duration")
                {
                }
                field("Minimum Participants"; "Minimum Participants")
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
                field("Total Price"; "Total Price")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
            }
            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Seminar Price"; "Seminar Price")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control16; Links)
            {
            }
            systempart(Control17; Notes)
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
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(123456700),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
            group("&Registrations")
            {
                Caption = '&Registrations';
                action(Action25)
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

