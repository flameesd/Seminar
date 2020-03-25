page 123456742 "My Seminars"
{
    // CSD1.00 - 2013-09-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table

    Caption = 'My Seminars';
    PageType = ListPart;
    SourceTable = "My Seminar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seminar No."; "Seminar No.")
                {

                    trigger OnValidate()
                    begin
                        GetSeminar();
                    end;
                }
                field(Name; Seminar.Name)
                {
                    Caption = 'Name';
                }
                field("Seminar Duration"; Seminar."Seminar Duration")
                {
                    Caption = 'Duration';
                }
                field("Seminar Price"; Seminar."Seminar Price")
                {
                    Caption = 'Price';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                Caption = 'Open';
                Image = Edit;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    OpenSeminarCard();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetSeminar();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(Seminar);
    end;

    trigger OnOpenPage()
    begin
        SetRange("User ID", UserId());
    end;

    var
        Seminar: Record Seminar;

    [Scope('Internal')]
    procedure GetSeminar()
    begin
        Clear(Seminar);

        if Seminar.Get("Seminar No.") then;
    end;

    [Scope('Internal')]
    procedure OpenSeminarCard()
    begin
        if Seminar.Get("Seminar No.") then
            PAGE.Run(PAGE::"Seminar Card", Seminar);
    end;
}

