page 123456723 "Seminar Report Selection"
{
    // CSD1.00 - 2013-06-01 - D. E. Veloper
    //   Chapter 6 - Lab 1
    //     - Created new page

    Caption = 'Seminar Report Selection';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Seminar Report Selections";
    UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2Regis)
            {
                Caption = 'Usage';
                OptionCaption = 'Registration';

                trigger OnValidate()
                begin
                    SetUsageFilter();
                    ReportUsage2OnAfterValidate();
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field(Sequence; Sequence)
                {
                }
                field("Report ID"; "Report ID")
                {
                    LookupPageID = Objects;
                }
                field("Report Name"; "Report Name")
                {
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord();
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter();
    end;

    var
        ReportUsage2Regis: Option Registration;

    local procedure SetUsageFilter()
    begin
        FilterGroup(2);
        case ReportUsage2Regis of
            ReportUsage2Regis::Registration:
                SetRange(Usage, Usage::Registration);
        end;
        FilterGroup(0);
    end;

    local procedure ReportUsage2OnAfterValidate()
    begin
        CurrPage.Update();
    end;
}

