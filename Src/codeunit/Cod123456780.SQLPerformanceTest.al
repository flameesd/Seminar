codeunit 123456780 "SQL Performance Test"
{

    trigger OnRun()
    begin
        Customer.SetRange(City, 'London');
        Customer.FindFirst();
        repeat
            Customer."Name 2" := 'Updated' + Format(CurrentDateTime());
            Customer.Modify();
        until Customer.Next() = 0;

        Message('Ready!');
    end;

    var
        Customer: Record Customer;
}

