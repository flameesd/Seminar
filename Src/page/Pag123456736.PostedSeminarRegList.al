page 123456736 "Posted Seminar Reg. List"
{
    // CSD1.00 - 2013-03-02 - D. E. Veloper
    //   Chapter 3 - Lab 2
    //     - Created new page
    // 
    // CSD1.00 - 2013-05-02 - D. E. Veloper
    //   Chapter 5 - Lab 2
    //     - Added the Navigate action
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added the Navigate action

    Caption = 'Posted Seminar Reg. List';
    CardPageID = "Posted Seminar Registration";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Seminar Reg. Header";
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
                field("Starting Date"; "Starting Date")
                {
                }
                field("Seminar No."; "Seminar No.")
                {
                }
                field("Seminar Name"; "Seminar Name")
                {
                }
                field(Status; Status)
                {
                }
                field(Duration; Duration)
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
                field("Room Resource No."; "Room Resource No.")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control18; "Seminar Details FactBox")
            {
                SubPageLink = "No." = FIELD("Seminar No.");
            }
            systempart(Control12; Links)
            {
            }
            systempart(Control13; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "Seminar Comment Sheet";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = WHERE("Document Type" = CONST("Posted Seminar Registration"));
                }
                action("&Charges")
                {
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page "Posted Seminar Charges";
                    RunPageLink = "Document No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions();
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date", "No.");
                    Navigate.Run();
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

