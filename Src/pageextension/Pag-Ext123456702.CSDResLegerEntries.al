pageextension 123456702 "CSDResLegerEntries" extends "Resource Ledger Entries" //"Resource Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Seminar No."; "Seminar No.")
            {
                ApplicationArea = All;
                Description = 'CSD1.00';
            }

            field("Seminar Registration No."; "Seminar Registration No.")
            {
                ApplicationArea = All;
                Description = 'CSD1.00';
            }
        }
    }

    actions
    {
    }
}