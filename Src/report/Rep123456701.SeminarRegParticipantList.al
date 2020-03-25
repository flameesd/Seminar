report 123456701 "Seminar Reg.-Participant List"
{
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 6 - Lab 1
    //     - Created new report
    DefaultLayout = RDLC;
    RDLCLayout = './Layout/SeminarRegParticipantList.rdlc';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    Caption = 'Seminar Reg.-Participant List';

    dataset
    {
        dataitem("Seminar Registration Header"; "Seminar Registration Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Seminar No.";
            column(No_SeminarRegistrationHeader; "Seminar Registration Header"."No.")
            {
                IncludeCaption = true;
            }
            column(SeminarNo_SeminarRegistrationHeader; "Seminar Registration Header"."Seminar No.")
            {
                IncludeCaption = true;
            }
            column(SeminarName_SeminarRegistrationHeader; "Seminar Registration Header"."Seminar Name")
            {
                IncludeCaption = true;
            }
            column(StartingDate_SeminarRegistrationHeader; "Seminar Registration Header"."Starting Date")
            {
                IncludeCaption = true;
            }
            column(Duration_SeminarRegistrationHeader; "Seminar Registration Header".Duration)
            {
                IncludeCaption = true;
            }
            column(InstructorName_SeminarRegistrationHeader; "Seminar Registration Header"."Instructor Name")
            {
                IncludeCaption = true;
            }
            column(RoomName_SeminarRegistrationHeader; "Seminar Registration Header"."Room Name")
            {
                IncludeCaption = true;
            }
            dataitem("Seminar Registration Line"; "Seminar Registration Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(BilltoCustomerNo_SeminarRegistrationLine; "Seminar Registration Line"."Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(ParticipantContactNo_SeminarRegistrationLine; "Seminar Registration Line"."Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column(ParticipantName_SeminarRegistrationLine; "Seminar Registration Line"."Participant Name")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Instructor Name");
            end;

            trigger OnPostDataItem()
            begin
                if not CurrReport.Preview() then
                    CODEUNIT.Run(CODEUNIT::"Seminar-Printed", "Seminar Registration Header");
            end;

            trigger OnPreDataItem()
            begin
                CompanyInformation.Get();
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        SeminarRegistrationHeader = 'Seminar Registration Header';
    }

    var
        CompanyInformation: Record "Company Information";
}

