page 123456751 "Seminar Unit Test Setup"
{
    Caption = 'Seminar Unit Test Setup';
    PageType = List;
    SourceTable = "Seminar Unit Test Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codeunit ID"; "Codeunit ID")
                {
                }
                field("Codeunit Name"; "Codeunit Name")
                {
                    Editable = false;
                }
                field("Function Name"; "Function Name")
                {
                    Editable = false;
                }
                field(Run; Run)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control8; Links)
            {
            }
            systempart(Control9; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Run Tests")
            {
                Caption = 'Run Tests';
                Image = AddAction;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"Seminar Unit Test Runner");
                end;
            }
            action("Test Entries")
            {
                Caption = 'Test Entries';
                Image = CalculateLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TestEntry: Record "Seminar Unit Test Entry";
                begin
                    TestEntry.SetRange("Codeunit ID", "Codeunit ID");
                    if "Function Name" <> '' then
                        TestEntry.SetRange("Function Name", "Function Name");
                    PAGE.Run(0, TestEntry);
                end;
            }
            action(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Seminar Unit Test Statistics";
                RunPageLink = "Codeunit ID" = FIELD("Codeunit ID"),
                              "Function Name" = FIELD("Function Name");
                ShortCutKey = 'F7';
            }
        }
    }
}

