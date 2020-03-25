codeunit 123456702 "Seminar-Printed"
{
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 6 - Lab 1
    //     - Created new codeunit

    TableNo = "Seminar Registration Header";

    trigger OnRun()
    begin
        Find();
        "No. Printed" := "No. Printed" + 1;
        Modify();
        Commit();
    end;
}

