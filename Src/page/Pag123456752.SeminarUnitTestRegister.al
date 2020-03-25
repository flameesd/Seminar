page 123456752 "Seminar Unit Test Register"
{
    Editable = false;
    PageType = List;
    SourceTable = "Seminar Unit Test Register";
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
                field("User ID"; "User ID")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("Creation Time"; "Creation Time")
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
        area(processing)
        {
            action("Test Entries")
            {
                Caption = 'Test Entries';
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TestEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
                    PAGE.Run(0, TestEntry);
                end;
            }
        }
    }

    var
        TestEntry: Record "Seminar Unit Test Entry";
}

