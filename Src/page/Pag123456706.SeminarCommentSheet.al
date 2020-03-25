page 123456706 "Seminar Comment Sheet"
{
    // CSD1.00 - 2013-03-01 - D. E. Veloper
    //   Chapter 3 - Lab 1
    //     - Created new table

    AutoSplitKey = true;
    Caption = 'Seminar Comment Sheet';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Seminar Comment Line";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field("Code"; Code)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine();
    end;
}

