page 123456721 "Seminar Ledger Entries"
{
    // CSD1.00 - 2013-04-02 - D. E. Veloper
    //   Chapter 4 - Lab 2
    //     - Created new page
    // 
    // CSD1.00 - 2013-05-02 - D. E. Veloper
    //   Chapter 5 - Lab 2
    //     - Added the Navigate action
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 5 - Lab 1
    //     - Added the Dimensions action
    //     - Added fields:
    //       - Global Dimension 1 Code
    //       - Global Dimension 2 Code

    Caption = 'Seminar Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Seminar Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Seminar No."; "Seminar No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Charge Type"; "Charge Type")
                {
                }
                field(Type; Type)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Total Price"; "Total Price")
                {
                }
                field(Chargeable; Chargeable)
                {
                }
                field("Participant Contact No."; "Participant Contact No.")
                {
                }
                field("Participant Name"; "Participant Name")
                {
                }
                field("Instructor Resource No."; "Instructor Resource No.")
                {
                }
                field("Room Resource No."; "Room Resource No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Seminar Registration No."; "Seminar Registration No.")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control24; Links)
            {
            }
            systempart(Control25; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                Caption = 'Ent&ry';
                Image = Entry;
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
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.Run();
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
}

