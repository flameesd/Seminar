page 123456741 "Seminar Manager Activities"
{
    // CSD1.00 - 2013-09-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table

    Caption = 'Seminar Manager Activities';
    PageType = CardPart;
    SourceTable = "Seminar Cue";

    layout
    {
        area(content)
        {
            cuegroup(Registrations)
            {
                Caption = 'Registrations';
                field(Planned; Planned)
                {
                    DrillDownPageID = "Seminar Registration List";
                }
                field(Registered; Registered)
                {
                    DrillDownPageID = "Seminar Registration List";
                }

                //TODO Web client not support
                // actions
                // {
                //     action(New)
                //     {
                //         Caption = 'New';
                //         RunObject = Page "Seminar Registration";
                //         RunPageMode = Create;
                //     }
                // }
            }
            cuegroup("For Posting")
            {
                Caption = 'For Posting';
                field(Closed; Closed)
                {
                    DrillDownPageID = "Seminar Registration List";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}

