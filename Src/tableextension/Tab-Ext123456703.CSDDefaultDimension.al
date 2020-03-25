tableextension 123456703 "CSDDefaultDimension" extends "Default Dimension" //"Default Dimension"
{
    procedure UpdateSeminarGlobalDimCode(GlobalDimCodeNo: Integer; SeminarNo: Code[20]; NewDimValue: Code[20])
    var
        Seminar: Record Seminar;
    BEGIN
        IF Seminar.GET(SeminarNo) THEN
            CASE GlobalDimCodeNo OF
                1:
                    Seminar."Global Dimension 1 Code" := NewDimValue;
                2:
                    Seminar."Global Dimension 2 Code" := NewDimValue;
            END;
    END;
}