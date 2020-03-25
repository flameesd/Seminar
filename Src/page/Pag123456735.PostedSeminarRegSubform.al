page 123456735 "Posted Seminar Reg. Subform"
{
    // CSD1.00 - 2013-04-03 - D. E. Veloper
    //   Chapter 4 - Lab 3
    //     - Created new page
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added the Dimensions action

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Posted Seminar Reg. Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Participant Contact No."; "Participant Contact No.")
                {
                }
                field("Participant Name"; "Participant Name")
                {
                }
                field(Participated; Participated)
                {
                }
                field("Registration Date"; "Registration Date")
                {
                }
                field("Confirmation Date"; "Confirmation Date")
                {
                }
                field("To Invoice"; "To Invoice")
                {
                }
                field(Registered; Registered)
                {
                }
                field("Seminar Price"; "Seminar Price")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
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
    }
}

