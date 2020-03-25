tableextension 123456702 "CSDResLedgerEntry" extends "Res. Ledger Entry" //"Res. Ledger Entry"
{
    fields
    {
        field(123456700; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            Description = 'CSD1.00';
            DataClassification = CustomerContent;
            TableRelation = Seminar;
        }

        field(123456701; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
            Description = 'CSD1.00';
            DataClassification = CustomerContent;
            TableRelation = "Posted Seminar Reg. Header";
        }


    }

}