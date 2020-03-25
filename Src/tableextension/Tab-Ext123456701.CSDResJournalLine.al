tableextension 123456701 "CSDResJournalLine" extends "Res. Journal Line"
{
    fields
    {
        field(123456700; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            DataClassification = CustomerContent;
            Description = 'CSD1.00';
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