page 123456707 "Seminar Comment List"
{
    // CSD1.00 - 2013-03-01 - D. E. Veloper
    //   Chapter 3 - Lab 1
    //     - Created new table

    DataCaptionFields = "No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Seminar Comment Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
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
}

