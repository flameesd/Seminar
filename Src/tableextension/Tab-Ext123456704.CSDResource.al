tableextension 123456704 "CSDResource" extends Resource
{
    // CSD1.00 - 2013-02-01 - D. E. Veloper
    //   Chapter 2 - Lab 1
    //     - Added new fields:
    //       - Internal/External
    //       - Maximum Participants


    fields
    {
        field(123456701; "Internal/External"; Option)
        {
            Caption = 'Internal/External';
            Description = 'CSD1.00';
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(123456702; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            Description = 'CSD1.00';
        }
        field(123456703; "Quantity Per Day"; Decimal)
        {
            Caption = 'Quantity Per Day';
            Description = 'CSD1.00';
        }
    }
}

