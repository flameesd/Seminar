pageextension 123456700 "CSDResourceCard" extends "Resource Card" //"Resource Card"
{
    layout
    {
        addafter(Type)
        {
            field("Internal/External"; "Internal/External")
            {
                ApplicationArea = All;
                Description = 'CSD1.00';

            }
        }

        addafter("Personal Data")
        {
            group(Room)
            {
                Caption = 'Room';
                field("Maximum Participants"; "Maximum Participants")
                {
                    Description = 'CSD1.00';
                    ApplicationArea = All;
                }
                field("Quantity Per Day"; "Quantity Per Day")
                {
                    Description = 'CSD1.00';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}