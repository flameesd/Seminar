codeunit 123456734 "Seminar Reg.-Show Ledger"
{
    // CSD1.00 - 2013-04-02 - D. E. Veloper
    //   Chapter 4 - Lab 2
    //     - Created new codeunit

    TableNo = "Seminar Register";

    trigger OnRun()
    begin
        SeminarLedgerEntry.SetRange("Entry No.", "From Entry No.", "To Entry No.");
        PAGE.Run(PAGE::"Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "Seminar Ledger Entry";
}

