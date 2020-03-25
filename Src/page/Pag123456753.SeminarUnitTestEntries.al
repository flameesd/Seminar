page 123456753 "Seminar Unit Test Entries"
{
    Caption = 'Seminar Unit Test Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Seminar Unit Test Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Codeunit ID"; "Codeunit ID")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                }
                field("Codeunit Name"; "Codeunit Name")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                }
                field("Function Name"; "Function Name")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                }
                field(Success; Success)
                {
                    Style = Attention;
                    StyleExpr = Attention;
                }
                field("Error Message"; "Error Message")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                }
                field("Creation Date"; "Creation Date")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                    Visible = DateTimeVisible;
                }
                field("Creation Time"; "Creation Time")
                {
                    Style = Attention;
                    StyleExpr = Attention;
                    Visible = DateTimeVisible;
                }
                field("Entry No."; "Entry No.")
                {
                    Style = Attention;
                    StyleExpr = Attention;
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
    }

    trigger OnAfterGetRecord()
    begin
        Attention := not Success;
    end;

    trigger OnOpenPage()
    begin
        DateTimeVisible := ((GetFilter("Entry No.") = '') and (GetFilter("Codeunit ID") <> '')) or (GetFilter(Success) <> '');
    end;

    var
        [InDataSet]
        Attention: Boolean;
        [InDataSet]
        DateTimeVisible: Boolean;
}

