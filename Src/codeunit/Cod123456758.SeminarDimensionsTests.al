codeunit 123456758 "Seminar Dimensions Tests"
{
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        DimVal1: Record "Dimension Value";
        DimVal2: Record "Dimension Value";

    [Test]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestGlobalDimensionsSeminarCard()
    var
        Seminar: Record Seminar;
        SeminarCard: TestPage "Seminar Card";
        DefaultDim: TestPage "Default Dimensions";
    begin
        GLSetup.Get();
        GLSetup.TestField("Global Dimension 1 Code");
        GLSetup.TestField("Global Dimension 2 Code");

        DimVal1.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        DimVal1.FindFirst();
        DimVal2.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
        DimVal2.FindFirst();

        Seminar.Insert(true);
        Seminar.Validate("Global Dimension 1 Code", DimVal1.Code);
        Seminar.Validate("Global Dimension 2 Code", DimVal2.Code);
        Seminar.Modify(true);

        SeminarCard.OpenView();
        SeminarCard.GotoKey(Seminar."No.");

        DefaultDim.Trap();
        SeminarCard.Dimensions.Invoke();

        DefaultDim.FILTER.SetFilter("Dimension Code", GLSetup."Global Dimension 1 Code");
        DefaultDim."Dimension Value Code".AssertEquals(DimVal1.Code);

        DefaultDim.FILTER.SetFilter("Dimension Code", GLSetup."Global Dimension 2 Code");
        DefaultDim."Dimension Value Code".AssertEquals(DimVal2.Code);
    end;

    [Test]
    [HandlerFunctions('EditDimSetHandler')]
    [TransactionModel(TransactionModel::AutoRollback)]
    [Scope('Internal')]
    procedure TestShortcutDimensionsRegistration()
    var
        Seminar: Record Seminar;
        SemReg: Record "Seminar Registration Header";
        SeminarRegistration: TestPage "Seminar Registration";
    begin
        Seminar.FindFirst();

        SeminarRegistration.OpenNew();
        SeminarRegistration."Seminar No.".SetValue(Seminar."No.");

        GLSetup.Get();
        GLSetup.TestField("Global Dimension 1 Code");
        GLSetup.TestField("Global Dimension 2 Code");

        SeminarRegistration.Dimensions.Invoke();

        SemReg.Get(SeminarRegistration."No.".Value());
        SemReg.TestField("Shortcut Dimension 1 Code", DimVal1.Code);
        SemReg.TestField("Shortcut Dimension 2 Code", DimVal2.Code);
    end;

    [ModalPageHandler]
    [Scope('Internal')]
    procedure EditDimSetHandler(var EditDimSet: TestPage "Edit Dimension Set Entries")
    begin
        DimVal1.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        DimVal1.FindFirst();
        EditDimSet.New();
        EditDimSet."Dimension Code".SetValue(GLSetup."Global Dimension 1 Code");
        EditDimSet.DimensionValueCode.SetValue(DimVal1.Code);

        DimVal2.SetRange("Dimension Code", GLSetup."Global Dimension 2 Code");
        DimVal2.FindFirst();
        EditDimSet.New();
        EditDimSet."Dimension Code".SetValue(GLSetup."Global Dimension 2 Code");
        EditDimSet.DimensionValueCode.SetValue(DimVal2.Code);
        EditDimSet.OK().Invoke();
    end;
}

