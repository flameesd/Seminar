page 123456740 "Seminar Manager Role Center"
{
    // CSD1.00 - 2013-09-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table
    //     - 9175 Obsolete (Delete)

    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control2)
            {
                ShowCaption = false;
                part(Control4; "Seminar Manager Activities")
                {
                }
                systempart(Control5; Outlook)
                {
                }
            }
            group(Control3)
            {
                ShowCaption = false;
                part(Control6; "My Seminars")
                {
                }
                part(Control9; "My Customers")
                {
                }
                systempart(Control8; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(Registrations)
            {
                Caption = 'Registrations';
                RunObject = Page "Seminar Registration List";
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                RunObject = Page "Seminar List";
            }
            action(Instructors)
            {
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = WHERE (Type = CONST (Person));
            }
            action(Rooms)
            {
                Caption = 'Rooms';
                RunObject = Page "Resource List";
                RunPageView = WHERE (Type = CONST (Machine));
            }
            action(Customers)
            {
                Caption = 'Customers';
                RunObject = Page "Customer List";
            }
            action(Contacts)
            {
                Caption = 'Contacts';
                RunObject = Page "Contact List";
            }
        }
        area(sections)
        {
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = RegisteredDocs;
                action("Posted Seminar Registrations")
                {
                    Caption = 'Posted Seminar Registrations';
                    RunObject = Page "Posted Seminar Reg. List";
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                }
                action(Registers)
                {
                    Caption = 'Registers';
                    RunObject = Page "Seminar Registers";
                }
            }
        }
        area(creation)
        {
            action("Seminar Registration")
            {
                Caption = 'Seminar Registration';
                Image = NewTimesheet;
                RunObject = Page "Seminar Registration";
            }
            action("Sales Invoice")
            {
                Caption = 'Sales Invoice';
                Image = NewInvoice;
                RunObject = Page "Sales Invoice";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            action("Create Invoices")
            {
                Caption = 'Create Invoices';
                Image = CreateJobSalesInvoice;
                RunObject = Report "Create Seminar Invoices";
            }
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                RunObject = Page Navigate;
            }
        }
        area(reporting)
        {
            action("Participant List")
            {
                Caption = 'Participant List';
                Image = "Report";
                RunObject = Report "Seminar Reg.-Participant List";
            }
        }
    }
}

