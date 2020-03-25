pageextension 123456703 "CSDSourceCodeSetup" extends "Source Code Setup" //"Source Code Setup"
{
    layout
    {
        addafter("Cost Accounting")
        {
            group("Seminar Management")
            {
                Caption = 'Seminar Management';
                field(Seminar; Seminar)
                {
                    ApplicationArea = All;
                    Description = 'CSD1.00';
                }
            }
        }
    }
}