pageextension 123456701 "CSDResourceList" extends "Resource List" //Resource List
{
    layout
    {
        addafter(Type)
        {
            field("Internal/External"; "Internal/External")
            {
                Description = 'CSD1.00';
                ApplicationArea = All;
            }

            field("Maximum Participants"; "Maximum Participants")
            {
                Description = 'CSD1.00';
                ApplicationArea = All;
                Visible = ShowMaxParticipants;
            }
        }

        modify(Type)
        {
            Visible = Showtype;
        }

    }

    trigger OnOpenPage()
    begin
        FilterGroup(3);
        Showtype := GetFilter(Type) = '';
        ShowMaxParticipants := GETFILTER(Type) = FORMAT(Type::Machine);
        FilterGroup(0);
    end;


    var
        [InDataSet]
        Showtype: Boolean;
        [InDataSet]
        ShowMaxParticipants: Boolean;
}