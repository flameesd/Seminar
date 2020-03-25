page 123456702 "Seminar Setup"
{
    // CSD1.00 - 2013-02-02 - D. E. Veloper
    //   Chapter 2 - Lab 2
    //     - Created new page
    // 
    // CSD1.00 - 2013-10-01 - D. E. Veloper
    //   Chapter 10 - Lab 1
    //     - Added the General group
    //     - Added the Confirmation Template File field to the General group

    Caption = 'Seminar Setup';
    PageType = Card;
    SourceTable = "Seminar Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Confirmation Template File"; "Confirmation Template File")
                {
                }
            }
            group(Numbering)
            {
                field("Seminar Nos."; "Seminar Nos.")
                {
                }
                field("Seminar Registration Nos."; "Seminar Registration Nos.")
                {
                }
                field("Posted Seminar Reg. Nos."; "Posted Seminar Reg. Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not FindFirst() then
            Insert();
    end;
}

