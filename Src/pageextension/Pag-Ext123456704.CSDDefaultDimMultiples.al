pageextension 123456704 "CSDDefaultDimMultiples" extends "Default Dimensions-Multiple" //"Default Dimensions-Multiple"
{
    procedure SetMultiSeminar(var Seminar: Record Seminar)
    var
        TempDefaultDim2: Record "Default Dimension" temporary;
    begin
        TempDefaultDim2.DELETEALL();
        WITH Seminar DO
            IF FIND('-') THEN
                REPEAT
                    CopyDefaultDimToDefaultDim(DATABASE::Seminar, "No.");
                UNTIL NEXT() = 0;
    end;
}