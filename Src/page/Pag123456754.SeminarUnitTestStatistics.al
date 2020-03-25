page 123456754 "Seminar Unit Test Statistics"
{
    Editable = false;
    SourceTable = "Seminar Unit Test Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                fixed(Control3)
                {
                    ShowCaption = false;
                    group("Last Run")
                    {
                        Caption = 'Last Run';
                        field("Succeeded[1]"; Succeeded[1])
                        {
                            Caption = 'Succeeded';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(1, true, false);
                            end;
                        }
                        field("Failed[1]"; Failed[1])
                        {
                            Caption = 'Failed';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(1, false, true);
                            end;
                        }
                        field("Succeeded[1]+Failed[1]"; Succeeded[1] + Failed[1])
                        {
                            Caption = 'Total';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(1, true, true);
                            end;
                        }
                        field("Succeeded[1]/(Succeeded[1]+Failed[1])"; Succeeded[1] / (Succeeded[1] + Failed[1]))
                        {
                            Caption = 'Success Rate';
                            DecimalPlaces = 2 : 2;
                        }
                    }
                    group("Previous Run")
                    {
                        Caption = 'Previous Run';
                        field("Succeeded[2]"; Succeeded[2])
                        {
                            Caption = 'Succeeded';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(2, true, false);
                            end;
                        }
                        field("Failed[2]"; Failed[2])
                        {
                            Caption = 'Failed';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(2, false, true);
                            end;
                        }
                        field("Succeeded[2]+Failed[2]"; Succeeded[2] + Failed[2])
                        {
                            Caption = 'Total';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(2, true, true);
                            end;
                        }
                        field("Succeeded[2]/(Succeeded[2]+Failed[2])"; Succeeded[2] / (Succeeded[2] + Failed[2]))
                        {
                            Caption = 'Success Rate';
                            DecimalPlaces = 2 : 2;
                        }
                    }
                    group("All Previous Runs")
                    {
                        Caption = 'All Previous Runs';
                        field("Succeeded[3]"; Succeeded[3])
                        {
                            Caption = 'Succeeded';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(3, true, false);
                            end;
                        }
                        field("Failed[3]"; Failed[3])
                        {
                            Caption = 'Failed';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(3, false, true);
                            end;
                        }
                        field("Succeeded[3]+Failed[3]"; Succeeded[3] + Failed[3])
                        {
                            Caption = 'Total';
                            DrillDown = true;

                            trigger OnDrillDown()
                            begin
                                ShowEntries(3, true, true);
                            end;
                        }
                        field("Succeeded[3]/(Succeeded[3]+Failed[3])"; Succeeded[3] / (Succeeded[3] + Failed[3]))
                        {
                            Caption = 'Success Rate';
                            DecimalPlaces = 2 : 2;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        TestEntry.SetRange("Codeunit ID", "Codeunit ID");
        if "Function Name" <> '' then
            TestEntry.SetRange("Function Name", "Function Name");

        if TestRegister.FindLast() then
            for i := 1 to 3 do begin
                case i of
                    1:
                        TestEntry.SetRange("Entry No.", TestRegister."From Entry No.", TestRegister."To Entry No.");
                    2:
                        if TestRegister2.Get(TestRegister."No." - 1) then
                            TestEntry.SetRange("Entry No.", TestRegister2."From Entry No.", TestRegister2."To Entry No.")
                        else
                            TestEntry.SetRange("Entry No.", 0, 0);
                    3:
                        if TestRegister."No." > 1 then
                            TestEntry.SetRange("Entry No.", 1, TestRegister2."To Entry No.")
                        else
                            TestEntry.SetRange("Entry No.", 0, 0);
                end;
                View[i] := TestEntry.GetView();
                TestEntry.SetRange(Success, true);
                Succeeded[i] := TestEntry.Count();
                TestEntry.SetRange(Success, false);
                Failed[i] := TestEntry.Count();
            end;
    end;

    var
        TestRegister: Record "Seminar Unit Test Register";
        TestRegister2: Record "Seminar Unit Test Register";
        TestEntry: Record "Seminar Unit Test Entry";
        Succeeded: array[3] of Integer;
        Failed: array[3] of Integer;
        View: array[3] of Text;
        i: Integer;

    [Scope('Internal')]
    procedure ShowEntries(i: Integer; Success: Boolean; Failure: Boolean)
    begin
        TestEntry.SetView(View[i]);
        if Success xor Failure then
            TestEntry.SetRange(Success, Success);

        PAGE.Run(0, TestEntry);
    end;
}

