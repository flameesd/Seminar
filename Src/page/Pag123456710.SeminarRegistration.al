page 123456710 "Seminar Registration"
{
    // CSD1.00 - 2013-03-02 - D. E. Veloper
    //   Chapter 3 - Lab 2
    //     - Created new page
    // 
    // CSD1.00 - 2013-04-05 - D. E. Veloper
    //   Chapter 4 - Lab 5
    //     - Added the Post action
    // 
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 6 - Lab 1
    //     - Added the Print action
    // 
    // CSD1.00 - 2013-08-01 - D. E. Veloper
    //   Chapter 8 - Lab 1
    //     - Added the Dimensions action
    // 
    // CSD1.00 - 2013-10-01 - D. E. Veloper
    //   Chapter 10 - Lab 1
    //     - Added the Send Send Registration Confirmations action

    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = "Seminar Registration Header";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Seminar No."; "Seminar No.")
                {
                }
                field("Seminar Name"; "Seminar Name")
                {
                }
                field("Instructor Resource No."; "Instructor Resource No.")
                {
                }
                field("Instructor Name"; "Instructor Name")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Duration; Duration)
                {
                }
                field("Minimum Participants"; "Minimum Participants")
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
            }
            part(SeminarRegistrationLines; "Seminar Registration Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Seminar Room")
            {
                field("Room Resource No."; "Room Resource No.")
                {
                }
                field("Room Name"; "Room Name")
                {
                }
                field("Room Address"; "Room Address")
                {
                }
                field("Room Address 2"; "Room Address 2")
                {
                }
                field("Room Post Code"; "Room Post Code")
                {
                }
                field("Room City"; "Room City")
                {
                }
                field("Room Country/Reg. Code"; "Room Country/Reg. Code")
                {
                }
                field("Room County"; "Room County")
                {
                }
            }
            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Seminar Price"; "Seminar Price")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control35; "Seminar Details FactBox")
            {
                SubPageLink = "No." = FIELD("Seminar No.");
            }
            part(Control28; "Customer Details FactBox")
            {
                Provider = SeminarRegistrationLines;
                SubPageLink = "No." = FIELD("Bill-to Customer No.");
            }
            systempart(Control29; Links)
            {
            }
            systempart(Control30; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "Seminar Comment Sheet";
                    RunPageLink = "No." = FIELD("No.");
                    RunPageView = WHERE("Document Type" = CONST("Seminar Registration"));
                }
                action("&Charges")
                {
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page "Seminar Charges";
                    RunPageLink = "Document No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDocDim();
                        CurrPage.SaveRecord();
                    end;
                }
            }
        }
        area(processing)
        {
            action("Send Registration Co&nfirmations")
            {
                Caption = 'Send Registration Co&nfirmations';
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    SemMailMgt.SendConfirmations(Rec);
                end;
            }
            group(Posting)
            {
                Caption = 'Posting';
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Seminar-Post (Yes/No)";
                    ShortCutKey = 'F9';
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Participants &List")
                {
                    Caption = 'Participants &List';
                    Ellipsis = true;
                    Image = Print;

                    trigger OnAction()
                    begin
                        SemDocPrint.PrintSeminarRegistrationHeader(Rec);
                    end;
                }
            }
        }
    }

    var
        SemDocPrint: Codeunit "Seminar Document-Print";
        SemMailMgt: Codeunit SeminarMailManagement;
}

