page 123456713 "Seminar Registration List"
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
    //     - Added the Send Registration Confirmations action
    // 
    // CSD1.00 - 2013-11-01 - D. E. Veloper
    //   Chapter 11 - Lab 1
    //     - Added the Registered Participants field

    Caption = 'Seminar Registration List';
    CardPageID = "Seminar Registration";
    Editable = false;
    PageType = List;
    SourceTable = "Seminar Registration Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
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
                field(Status; Status)
                {
                }
                field(Duration; Duration)
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
                field("Room Resource No."; "Room Resource No.")
                {
                }
                field("Registered Participants"; "Registered Participants")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control18; "Seminar Details FactBox")
            {
                SubPageLink = "No." = FIELD("Seminar No.");
            }
            systempart(Control12; Links)
            {
            }
            systempart(Control13; Notes)
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

