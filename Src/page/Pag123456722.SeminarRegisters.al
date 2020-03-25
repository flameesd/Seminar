page 123456722 "Seminar Registers"
{
    Editable = false;
    PageType = List;
    SourceTable = "Seminar Register";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("From Entry No."; "From Entry No.")
                {
                }
                field("To Entry No."; "To Entry No.")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Links)
            {
            }
            systempart(Control12; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Register)
            {
                Caption = 'Register';
                action("Seminar Ledger")
                {
                    Caption = 'Seminar Ledger';
                    Image = WarrantyLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Seminar Reg.-Show Ledger";
                }
            }
        }
    }
}

