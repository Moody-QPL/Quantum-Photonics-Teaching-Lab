classdef CD48_App_exported < matlab.apps.AppBase
%Author: Quynh Dang
%Last revision: 2/24/21
    
    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        GridLayout                      matlab.ui.container.GridLayout
        LeftPanel                       matlab.ui.container.Panel
        ParametersettingsPanel          matlab.ui.container.Panel
        ImpeadanceButtonGroup           matlab.ui.container.ButtonGroup
        HighButton                      matlab.ui.control.RadioButton
        LowButton                       matlab.ui.control.RadioButton
        TriggerlevelVLabel              matlab.ui.control.Label
        TriggerlevelVSlider             matlab.ui.control.Slider
        SetButton                       matlab.ui.control.Button
        RepeatperiodinmsEditFieldLabel  matlab.ui.control.Label
        RepeatPeriodEditField           matlab.ui.control.NumericEditField
        CountersassignmentPanel         matlab.ui.container.Panel
        ACheckBox_1                     matlab.ui.control.CheckBox
        BCheckBox_1                     matlab.ui.control.CheckBox
        CCheckBox_1                     matlab.ui.control.CheckBox
        DCheckBox_1                     matlab.ui.control.CheckBox
        CounterLabel_1                  matlab.ui.control.Label
        ACheckBox_2                     matlab.ui.control.CheckBox
        BCheckBox_2                     matlab.ui.control.CheckBox
        CCheckBox_2                     matlab.ui.control.CheckBox
        DCheckBox_2                     matlab.ui.control.CheckBox
        CounterLabel_2                  matlab.ui.control.Label
        ACheckBox_3                     matlab.ui.control.CheckBox
        BCheckBox_3                     matlab.ui.control.CheckBox
        CCheckBox_3                     matlab.ui.control.CheckBox
        DCheckBox_3                     matlab.ui.control.CheckBox
        CounterLabel_3                  matlab.ui.control.Label
        ACheckBox_4                     matlab.ui.control.CheckBox
        BCheckBox_4                     matlab.ui.control.CheckBox
        CCheckBox_4                     matlab.ui.control.CheckBox
        DCheckBox_4                     matlab.ui.control.CheckBox
        CounterLabel_4                  matlab.ui.control.Label
        ACheckBox_5                     matlab.ui.control.CheckBox
        BCheckBox_5                     matlab.ui.control.CheckBox
        CCheckBox_5                     matlab.ui.control.CheckBox
        DCheckBox_5                     matlab.ui.control.CheckBox
        CounterLabel_5                  matlab.ui.control.Label
        ACheckBox_6                     matlab.ui.control.CheckBox
        BCheckBox_6                     matlab.ui.control.CheckBox
        CCheckBox_6                     matlab.ui.control.CheckBox
        DCheckBox_6                     matlab.ui.control.CheckBox
        CounterLabel_6                  matlab.ui.control.Label
        ACheckBox_7                     matlab.ui.control.CheckBox
        BCheckBox_7                     matlab.ui.control.CheckBox
        CCheckBox_7                     matlab.ui.control.CheckBox
        DCheckBox_7                     matlab.ui.control.CheckBox
        CounterLabel_7                  matlab.ui.control.Label
        ACheckBox_8                     matlab.ui.control.CheckBox
        BCheckBox_8                     matlab.ui.control.CheckBox
        CCheckBox_8                     matlab.ui.control.CheckBox
        DCheckBox_8                     matlab.ui.control.CheckBox
        CounterLabel_8                  matlab.ui.control.Label
        ResetButton                     matlab.ui.control.Button
        ClearAllButton                  matlab.ui.control.Button
        RuntimeLimitmsLabel             matlab.ui.control.Label
        RuntimeValue                    matlab.ui.control.NumericEditField
        ConnectButton                   matlab.ui.control.StateButton
        COMPortEditFieldLabel           matlab.ui.control.Label
        COMPortEditField                matlab.ui.control.NumericEditField
        SettingsLabel                   matlab.ui.control.Label
        ToggleButton                    matlab.ui.control.StateButton
        PossiblebugsanddebuggingTextArea  matlab.ui.control.TextArea
        RightPanel                      matlab.ui.container.Panel
        UIAxes                          matlab.ui.control.UIAxes
        UIAxes_2                        matlab.ui.control.UIAxes
        UIAxes_3                        matlab.ui.control.UIAxes
        UIAxes_4                        matlab.ui.control.UIAxes
        UIAxes_5                        matlab.ui.control.UIAxes
        UIAxes_6                        matlab.ui.control.UIAxes
        UIAxes_7                        matlab.ui.control.UIAxes
        UIAxes_8                        matlab.ui.control.UIAxes
        OverflowClearButton             matlab.ui.control.StateButton
        CountratecpsEditFieldLabel      matlab.ui.control.Label
        CountratecpsEditField           matlab.ui.control.NumericEditField
        CountratecpsEditField_2Label    matlab.ui.control.Label
        CountratecpsEditField_2         matlab.ui.control.NumericEditField
        CountratecpsEditField_3Label    matlab.ui.control.Label
        CountratecpsEditField_3         matlab.ui.control.NumericEditField
        CountratecpsEditField_4Label    matlab.ui.control.Label
        CountratecpsEditField_4         matlab.ui.control.NumericEditField
        CountratecpsEditField_5Label    matlab.ui.control.Label
        CountratecpsEditField_5         matlab.ui.control.NumericEditField
        CountratecpsEditField_6Label    matlab.ui.control.Label
        CountratecpsEditField_6         matlab.ui.control.NumericEditField
        CountratecpsEditField_7Label    matlab.ui.control.Label
        CountratecpsEditField_7         matlab.ui.control.NumericEditField
        CountratecpsEditField_8Label    matlab.ui.control.Label
        CountratecpsEditField_8         matlab.ui.control.NumericEditField
        SaveDataandSettingsButton       matlab.ui.control.Button
        StartPlotButton                 matlab.ui.control.Button
        StopPlotButton                  matlab.ui.control.Button
        TestboardButton                 matlab.ui.control.Button
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    
    properties (Access = public)
        ser                  % ser port
        counter1                        %counter1 data
        counter2                        %counter2 data
        counter3                        %counter3 data
        counter4                        %counter4 data
        counter5                        %counter5 data
        counter6                        %counter6 data
        counter7                        %counter7 data
        counter8                        %counter8 data
        countrate                       %countrate data
        TimeBinEdges                    %bin left edges + last right edge
        myTimer                         %Timer to update plot
        overflow_status                 %overflow digit
        period                          %fixed period
        runtime
    end

    methods (Access = private)
        
        %format impeadance input to ready-to-send command
        function z_cmd = formatImpeadanceCmd(app)
            if app.HighButton.Value==true && app.LowButton.Value==true
                z_cmd ='Z\r';
            elseif app.HighButton.Value == true
                z_cmd = 'Z\r';
            elseif app.LowButton.Value == true
                z_cmd = 'z\r';
            else
                z_cmd ='Z\r';
            end
        end
        
        %format trigger level to ready-to-send Ln command
        function Ln_cmd = formatTriggerCmd(app)
            voltage = app.TriggerlevelVSlider.Value;
            trigger_value = voltage/4.02 * 256;
            Ln_cmd = strcat('L',int2str(trigger_value),'\r');
        end
        
        %format repeat period to ready-to-send rn command
        function rn_cmd = formatRepeatPeriodCmd(app)
            RepeadPeriodException(app)
            n = app.RepeatPeriodEditField.Value;
            rn_cmd = strcat('r', int2str(n), '\r');
        end
        
        %format counter assignment to ready-to-send command, SnABCD
        function Sn_cmd = formatCounterAssignmentCmd(~, n, ACheckBox, BCheckBox, CCheckBox, DCheckBox)
            if ACheckBox.Value == true
                A='1';
            else
                A='0';
            end
            
            if BCheckBox.Value ==true
                B='1';
            else
                B='0';
            end
            
            if CCheckBox.Value == true
                C='1';
            else
                C='0';
            end
            
            if DCheckBox.Value ==true
                D='1';
            else
                D='0';
            end
            
            Sn_cmd = strcat('S', int2str(n), A, B, C, D);
        end
        
        %get integration time
        function runtime = getRunTimeLimit(app)
            val = app.RuntimeValue.Value;
            if val < app.RepeatPeriodEditField.Value
                app.RuntimeValue.Value = 3600000;
                runtime = 3600000;
            else
                runtime = app.RuntimeValue.Value;
            end
        end
        
        %%update histogram every 0.1s
        function updateGuiTimer(app, ~)
            
            allCounts = fgetl(app.ser);
            countList = strsplit(allCounts,' ');
            app.overflow_status = str2double(countList(9));            
            
            %append new value to list
            app.counter1 = [app.counter1 str2double(countList(1))];
            app.counter2 = [app.counter2 str2double(countList(2))];
            app.counter3 = [app.counter3 str2double(countList(3))];
            app.counter4 = [app.counter4 str2double(countList(4))];
            app.counter5 = [app.counter5 str2double(countList(5))];
            app.counter6 = [app.counter6 str2double(countList(6))];
            app.counter7 = [app.counter7 str2double(countList(7))];
            app.counter8 = [app.counter8 str2double(countList(8))];
            
            app.TimeBinEdges = [app.TimeBinEdges (app.TimeBinEdges(end) + app.period)];
            
            %stop the timer once it reached desired runtime
            while app.runtime < app.TimeBinEdges(end)
                TurnOffTimer(app);
                return;
            end
            
            %If overflow happens:
            while app.overflow_status == 1
                TurnOffTimer(app);
                fprintf(app.ser, 'E');
                uialert(app.UIFigure, 'Detected overflow flag. Overflow cleared. Reading data stopped. Try again', 'Overflow Warning');
                return;
            end
            
            CalculateCountRate(app);
            
            if length(app.counter1)< 2
                %ignore the first count value, in case there is leftover count
                %stored in buffer
                app.counter1(1) = 0;
                app.counter2(1) = 0;
                app.counter3(1) = 0;
                app.counter4(1) = 0;
                app.counter5(1) = 0;
                app.counter6(1) = 0;
                app.counter7(1) = 0;
                app.counter8(1) = 0;
                app.TimeBinEdges(2) = 0;
            end

            UpdateCountRate(app);
            PlotCountHistogram(app);      
        end
        
        function restoreInitialCountList(app)
            %restore count initial list
            app.counter1=[];                        %counter1 data
            app.counter2=[];                        %counter2 data
            app.counter3=[];                        %counter3 data
            app.counter4=[];                        %counter4 data
            app.counter5=[];                        %counter5 data
            app.counter6=[];                        %counter6 data
            app.counter7=[];                        %counter7 data
            app.counter8=[];                        %counter8 data
            app.countrate=[0 0 0 0 0 0 0 0];         %countrate data
            app.overflow_status = 0;
            app.TimeBinEdges = [0];              % the most left edge of the histogram
            
        end
        
        function TurnOffTimer(app)
            while isequal(get(app.myTimer, "Running"), 'on')
                stop(app.myTimer);
            end
        end
        
        %flush all the data stored in InputBuffer
        function flushInputBuffer(app)
            if app.ser.BytesAvailable > 0
                fread(app.ser, app.ser.BytesAvailable);
            end
        end
        
        function TurnOffToggle(app)
            %turn off toggle
            while app.ToggleButton.Value == true
                app.ToggleButton.Value = false;
                fprintf(app.ser, 'R');
            end
            
        end
        
        function UpdateCountRate(app)
            app.CountratecpsEditField.Value = app.countrate(1);
            app.CountratecpsEditField_2.Value = app.countrate(2);
            app.CountratecpsEditField_3.Value = app.countrate(3);
            app.CountratecpsEditField_4.Value = app.countrate(4);
            app.CountratecpsEditField_5.Value = app.countrate(5);
            app.CountratecpsEditField_6.Value = app.countrate(6);
            app.CountratecpsEditField_7.Value = app.countrate(7);
            app.CountratecpsEditField_8.Value = app.countrate(8);
            
            
        end
        
        function PlotCountHistogram(app)
            l = length(app.TimeBinEdges);
            
            histogram(app.UIAxes, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter1);
            histogram(app.UIAxes_2, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter2);
            histogram(app.UIAxes_3, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter3);
            histogram(app.UIAxes_4, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter4);
            histogram(app.UIAxes_5, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter5);
            histogram(app.UIAxes_6, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter6);
            histogram(app.UIAxes_7, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter7);
            histogram(app.UIAxes_8, "BinEdges", app.TimeBinEdges,'BinCounts',app.counter8);
            
            if l > 25
                
                max1 = max(app.counter1((l-25):(l-1))) * 1.2;
                max2 = max(app.counter2((l-25):(l-1))) * 1.2;
                max3 = max(app.counter3((l-25):(l-1))) * 1.2;
                max4 = max(app.counter4((l-25):(l-1))) * 1.2;
                max5 = max(app.counter5((l-25):(l-1))) * 1.2;
                max6 = max(app.counter6((l-25):(l-1))) * 1.2;
                max7 = max(app.counter7((l-25):(l-1))) * 1.2;
                max8 = max(app.counter8((l-25):(l-1))) * 1.2;
                
                %rescale y axis
                
                
                app.UIAxes.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_2.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_3.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_4.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_5.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_6.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_7.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                app.UIAxes_8.XLim = [app.TimeBinEdges(l-25) app.TimeBinEdges(l)];
                
                app.UIAxes.YLim = [0 max1];
                app.UIAxes_2.YLim = [0 max2]; 
                app.UIAxes_3.YLim = [0 max3];
                app.UIAxes_4.YLim = [0 max4];
                app.UIAxes_5.YLim = [0 max5];
                app.UIAxes_6.YLim = [0 max6];
                app.UIAxes_7.YLim = [0 max7];
                app.UIAxes_8.YLim = [0 max8];
                
        
            elseif l>2 && l <26
                % letter L (the sencond index) and number 1 (the first index)
                app.UIAxes.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_2.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_3.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_4.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_5.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_6.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_7.XLim = [0 app.TimeBinEdges(end)];
                app.UIAxes_8.XLim = [0 app.TimeBinEdges(end)];
            end  
        end
        
        function CalculateCountRate(app)
            if app.TimeBinEdges(end) == 0
                app.countrate(1:8)=0;
            else
                %get countrate values
                
                a = length(app.counter1);
                if a < 27
                    m = a;
                    sum1 = sum(app.counter1);
                    sum2 = sum(app.counter2);
                    sum3 = sum(app.counter3);
                    sum4 = sum(app.counter4);
                    sum5 = sum(app.counter5);
                    sum6 = sum(app.counter6);
                    sum7 = sum(app.counter7);
                    sum8 = sum(app.counter8);
                else
                    m=25;
                    sum1 = sum(app.counter1((a-25):a));
                    sum2 = sum(app.counter2((a-25):a));
                    sum3 = sum(app.counter3((a-25):a));
                    sum4 = sum(app.counter4((a-25):a));
                    sum5 = sum(app.counter5((a-25):a));
                    sum6 = sum(app.counter6((a-25):a));
                    sum7 = sum(app.counter7((a-25):a));
                    sum8 = sum(app.counter8((a-25):a));
                end
                
                app.countrate(1) = sum1/(m*app.period);
                app.countrate(2) = sum2/(m*app.period);
                app.countrate(3) = sum3/(m*app.period);
                app.countrate(4) = sum4/(m*app.period);
                app.countrate(5) = sum5/(m*app.period);
                app.countrate(6) = sum6/(m*app.period);
                app.countrate(7) = sum7/(m*app.period);
                app.countrate(8) = sum8/(m*app.period);
                           
            end           
            
        end
        
        function RepeadPeriodException(app)
            while app.RepeatPeriodEditField.Value <100
                app.RepeatPeriodEditField.Value = 100;
            end
        end
        
        function DataTable = formatDataTable(app)
          
            CounterList = {'Counter 1';'Counter 2';'Counter 3';'Counter 4';'Counter 5';'Counter 6';'Counter 7';'Counter 8'};
            %Get all counter assingments in human readable format
            
            %change data from row to column
            count1 = app.counter1';
            count2 = app.counter2';
            count3 = app.counter3';
            count4 = app.counter4';
            count5 = app.counter5';
            count6 = app.counter6';
            count7 = app.counter7';
            count8 = app.counter8';
            
            DataTable = table(count1, count2, count3, count4,count5,count6, count7,count8);
            DataTable.Properties.VariableNames = CounterList;
            
        end
        
        function counterSetting = CounterReadableAssignment(~, counterLabel, ACheckBox, BCheckBox, CCheckBox, DCheckBox)
            if ACheckBox.Value == true
                A='A';
            else
                A='-';
            end
            
            if BCheckBox.Value ==true
                B='B';
            else
                B='-';
            end
            
            if CCheckBox.Value == true
                C='C';
            else
                C='-';
            end
            
            if DCheckBox.Value ==true
                D='D';
            else
                D='-';
            end
            
            counterSetting = strcat(counterLabel, ": ",A,B,C,D, " ");
            counterSetting = strrep(counterSetting, '-','');
        end
        
        function asgnList = AssignAllCounter(app)
            c1 = CounterReadableAssignment(app, 'Counter 1', app.ACheckBox_1, app.BCheckBox_1, app.CCheckBox_1, app.DCheckBox_1);
            c2 = CounterReadableAssignment(app, 'Counter 2', app.ACheckBox_2, app.BCheckBox_2, app.CCheckBox_2, app.DCheckBox_2);
            c3 = CounterReadableAssignment(app, 'Counter 3', app.ACheckBox_3, app.BCheckBox_3, app.CCheckBox_3, app.DCheckBox_3);
            c4 = CounterReadableAssignment(app, 'Counter 4', app.ACheckBox_4, app.BCheckBox_4, app.CCheckBox_4, app.DCheckBox_4);
            c5 = CounterReadableAssignment(app, 'Counter 5', app.ACheckBox_5, app.BCheckBox_5, app.CCheckBox_5, app.DCheckBox_5);
            c6 = CounterReadableAssignment(app, 'Counter 6', app.ACheckBox_6, app.BCheckBox_6, app.CCheckBox_6, app.DCheckBox_6);
            c7 = CounterReadableAssignment(app, 'Counter 7', app.ACheckBox_7, app.BCheckBox_7, app.CCheckBox_7, app.DCheckBox_7);
            c8 = CounterReadableAssignment(app, 'Counter 8', app.ACheckBox_8, app.BCheckBox_8, app.CCheckBox_8, app.DCheckBox_8);
      
            asgnList = [c1;c2;c3;c4;c5;c6;c7;c8];
           
        end
        
        function boardSetting = settings(app)
            RuntimeVal = int2str(getRunTimeLimit(app)) +" ms. ";
            RepeatTimeVal = int2str(app.RepeatPeriodEditField.Value)+ " ms. ";
            TriggerLevelVal = int2str(app.TriggerlevelVSlider.Value) +" V. ";
                       
            if formatImpeadanceCmd(app)=="z/r"
                Impeadance = 'Low.';
            else
                Impeadance = 'High.';
            end
            
            CounterAssignment = AssignAllCounter(app);
            
            boardSetting = [" "; "Settings: "; strcat('Runtime: ',RuntimeVal); CounterAssignment;
                strcat('Repeat Period: ',RepeatTimeVal);strcat('Trigger Level: ',TriggerLevelVal); strcat('Impeadance: ',Impeadance)];
        end
        
        %set paramerter callback
        function SetParameter(app)
           
            TurnOffTimer(app);
            %set all required command
            z_cmd = formatImpeadanceCmd(app);               %impeadance
            Ln_cmd = formatTriggerCmd(app);                 %trigger level  
            rn_cmd = formatRepeatPeriodCmd(app);            %repeat period
            app.runtime = getRunTimeLimit(app);
                        
            S1_cmd = formatCounterAssignmentCmd(app, 0, app.ACheckBox_1, app.BCheckBox_1, app.CCheckBox_1, app.DCheckBox_1); %Counter 1
            S2_cmd = formatCounterAssignmentCmd(app, 1, app.ACheckBox_2, app.BCheckBox_2, app.CCheckBox_2, app.DCheckBox_2); %Counter 2
            S3_cmd = formatCounterAssignmentCmd(app, 2, app.ACheckBox_3, app.BCheckBox_3, app.CCheckBox_3, app.DCheckBox_3); %Counter 3
            S4_cmd = formatCounterAssignmentCmd(app, 3, app.ACheckBox_4, app.BCheckBox_4, app.CCheckBox_4, app.DCheckBox_4); %Counter 4
            S5_cmd = formatCounterAssignmentCmd(app, 4, app.ACheckBox_5, app.BCheckBox_5, app.CCheckBox_5, app.DCheckBox_5); %Counter 5
            S6_cmd = formatCounterAssignmentCmd(app, 5, app.ACheckBox_6, app.BCheckBox_6, app.CCheckBox_6, app.DCheckBox_6); %Counter 6
            S7_cmd = formatCounterAssignmentCmd(app, 6, app.ACheckBox_7, app.BCheckBox_7, app.CCheckBox_7, app.DCheckBox_7); %Counter 7
            S8_cmd = formatCounterAssignmentCmd(app, 7, app.ACheckBox_8, app.BCheckBox_8, app.CCheckBox_8, app.DCheckBox_8); %Counter 8
            
            %toggle need to be off in oder for the setting to take effect
            TurnOffToggle(app); 
            
            
            fprintf(app.ser, z_cmd);
            fprintf(app.ser, Ln_cmd);
            fprintf(app.ser, rn_cmd);
            fprintf(app.ser, S1_cmd);
            fprintf(app.ser, S2_cmd);
            fprintf(app.ser, S3_cmd);
            fprintf(app.ser, S4_cmd);
            fprintf(app.ser, S5_cmd);
            fprintf(app.ser, S6_cmd);
            fprintf(app.ser, S7_cmd);
            fprintf(app.ser, S8_cmd);
            
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
           
            restoreInitialCountList(app);
            %initialize the timer object
            app.myTimer = timer('ExecutionMode', 'fixedSpacing','TasksToExecute',inf);
            app.myTimer.TimerFcn = @(~,~)app.updateGuiTimer;
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {921, 921};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {460, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end

        % Button pushed function: SetButton
        function SetButtonPushed(app, event)
           
            TurnOffTimer(app);
            restoreInitialCountList(app);

            %set all required command
            z_cmd = formatImpeadanceCmd(app);               %impeadance
            Ln_cmd = formatTriggerCmd(app);                 %trigger level  
            rn_cmd = formatRepeatPeriodCmd(app);            %repeat period
            getRunTimeLimit(app);
                        
            S1_cmd = formatCounterAssignmentCmd(app, 0, app.ACheckBox_1, app.BCheckBox_1, app.CCheckBox_1, app.DCheckBox_1); %Counter 1
            S2_cmd = formatCounterAssignmentCmd(app, 1, app.ACheckBox_2, app.BCheckBox_2, app.CCheckBox_2, app.DCheckBox_2); %Counter 2
            S3_cmd = formatCounterAssignmentCmd(app, 2, app.ACheckBox_3, app.BCheckBox_3, app.CCheckBox_3, app.DCheckBox_3); %Counter 3
            S4_cmd = formatCounterAssignmentCmd(app, 3, app.ACheckBox_4, app.BCheckBox_4, app.CCheckBox_4, app.DCheckBox_4); %Counter 4
            S5_cmd = formatCounterAssignmentCmd(app, 4, app.ACheckBox_5, app.BCheckBox_5, app.CCheckBox_5, app.DCheckBox_5); %Counter 5
            S6_cmd = formatCounterAssignmentCmd(app, 5, app.ACheckBox_6, app.BCheckBox_6, app.CCheckBox_6, app.DCheckBox_6); %Counter 6
            S7_cmd = formatCounterAssignmentCmd(app, 6, app.ACheckBox_7, app.BCheckBox_7, app.CCheckBox_7, app.DCheckBox_7); %Counter 7
            S8_cmd = formatCounterAssignmentCmd(app, 7, app.ACheckBox_8, app.BCheckBox_8, app.CCheckBox_8, app.DCheckBox_8); %Counter 8
            
            %port need to be connected in order to send command
            if app.ConnectButton.Value == true
                %toggle need to be off in oder for the setting to take effect
                TurnOffToggle(app)
                
                fprintf(app.ser, z_cmd);
                fprintf(app.ser, Ln_cmd);
                fprintf(app.ser, rn_cmd);
                fprintf(app.ser, S1_cmd);
                fprintf(app.ser, S2_cmd);
                fprintf(app.ser, S3_cmd);
                fprintf(app.ser, S4_cmd);
                fprintf(app.ser, S5_cmd);
                fprintf(app.ser, S6_cmd);
                fprintf(app.ser, S7_cmd);
                fprintf(app.ser, S8_cmd);
            else
                uialert(app.UIFigure,'Try checking your COM port # => Connect','CD48 Device not connected');
            end
        end

        % Button pushed function: ClearAllButton
        function ClearAllButtonPushed(app, event)
            TurnOffTimer(app);
            restoreInitialCountList(app);
            TurnOffToggle(app)
            
            app.COMPortEditField.Value = 0;
            
            %clear all setting field
            app.RuntimeValue.Value = 0;
            app.RepeatPeriodEditField.Value = 0;
            app.TriggerlevelVSlider.Value = 0;

            app.ACheckBox_1.Value = false; 
            app.BCheckBox_1.Value = false;
            app.CCheckBox_1.Value = false;
            app.DCheckBox_1.Value = false;
            
            app.ACheckBox_2.Value = false; 
            app.BCheckBox_2.Value = false;
            app.CCheckBox_2.Value = false;
            app.DCheckBox_2.Value = false;
            
            app.ACheckBox_3.Value = false; 
            app.BCheckBox_3.Value = false;
            app.CCheckBox_3.Value = false;
            app.DCheckBox_3.Value = false;
            
            app.ACheckBox_4.Value = false; 
            app.BCheckBox_4.Value = false;
            app.CCheckBox_4.Value = false;
            app.DCheckBox_4.Value = false;
            
            app.ACheckBox_5.Value = false; 
            app.BCheckBox_5.Value = false;
            app.CCheckBox_5.Value = false;
            app.DCheckBox_5.Value = false;
            
            app.ACheckBox_6.Value = false; 
            app.BCheckBox_6.Value = false;
            app.CCheckBox_6.Value = false;
            app.DCheckBox_6.Value = false;
            
            app.ACheckBox_7.Value = false; 
            app.BCheckBox_7.Value = false;
            app.CCheckBox_7.Value = false;
            app.DCheckBox_7.Value = false;
            
            app.ACheckBox_8.Value = false; 
            app.BCheckBox_8.Value = false;
            app.CCheckBox_8.Value = false;
            app.DCheckBox_8.Value = false;
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            TurnOffTimer(app);
            restoreInitialCountList(app);
            TurnOffToggle(app)
            
            %impeadance back to high
            app.HighButton.Value = true;
            app.LowButton.Value = false;
            
            %repeat period back to 100ms
            app.RepeatPeriodEditField.Value = 100;
            
            %trigger level back to 1.0V
            app.TriggerlevelVSlider.Value = 1.0;
            
            %runtime of 3600000 = 1hr
            app.RuntimeValue.Value = 3600000;
            
            %Counter back to default
            app.ACheckBox_1.Value = true; %counter 1, single count at channel A
            app.BCheckBox_1.Value = false;
            app.CCheckBox_1.Value = false;
            app.DCheckBox_1.Value = false;
            
            
            app.BCheckBox_2.Value = true; %counter 2, single count at channel B
            app.ACheckBox_2.Value = false;             
            app.CCheckBox_2.Value = false;
            app.DCheckBox_2.Value = false;
            
            app.CCheckBox_3.Value = true; %counter 3, single count at channel C
            app.ACheckBox_3.Value = false; 
            app.BCheckBox_3.Value = false;            
            app.DCheckBox_3.Value = false;
            
            app.DCheckBox_4.Value = true; %counter 4, single count at channel D
            app.ACheckBox_4.Value = false; 
            app.BCheckBox_4.Value = false;
            app.CCheckBox_4.Value = false;

            app.ACheckBox_5.Value = true; %counter 5, 2-fold coincidence count at AB
            app.BCheckBox_5.Value = true;
            app.CCheckBox_5.Value = false;
            app.DCheckBox_5.Value = false;
            
            app.ACheckBox_6.Value = true; %counter 6, 2-fold coincidence count at AC
            app.CCheckBox_6.Value = true;
            app.BCheckBox_6.Value = false;
            app.DCheckBox_6.Value = false;
            
            app.ACheckBox_7.Value = true; %counter 7, 2-fold coincidence count at AD
            app.DCheckBox_7.Value = true;
            app.BCheckBox_7.Value = false;
            app.CCheckBox_7.Value = false;
            
            app.ACheckBox_8.Value = true; %counter 8, 3-fold coincidence count at ABC
            app.BCheckBox_8.Value = true;
            app.CCheckBox_8.Value = true;
            app.DCheckBox_8.Value = false;
        end

        % Button pushed function: TestboardButton
        function TestboardButtonPushed(app, event)

            if app.ConnectButton.Value == true
                fprintf(app.ser, 'T');
            else
                uialert(app.UIFigure,'Try checking your COM port # => Connect','CD48 Device not connected');
            end
        end

        % Button pushed function: StartPlotButton
        function StartPlotButtonPushed(app, event)
            if app.ConnectButton.Value == false
                uialert(app.UIFigure,'The specified COM port is not available, try again', "Port Warning");
                return
            
            else
                SetParameter(app);
                while app.ToggleButton.Value == false               
                    fprintf(app.ser, 'R');
                    app.ToggleButton.Value = true;
                end
                
                TurnOffTimer(app);
                flushInputBuffer(app);
                restoreInitialCountList(app);
                
                app.period = (app.RepeatPeriodEditField.Value)/1000;
                set(app.myTimer, "Period", app.period);
                set(app.myTimer, "StartDelay", app.period)
                start(app.myTimer);               
            end
    
        end

        % Value changed function: ConnectButton
        function ConnectButtonValueChanged(app, event)
            value = app.ConnectButton.Value;
            COMnumber = app.COMPortEditField.Value;
            COMport = strcat("COM", int2str(COMnumber));
            if ~any(strcmp(serialportlist,COMport))
                app.ConnectButton.Value = false;
                uialert(app.UIFigure,'The specified COM port is not available, try again', "Port Warning");
                return
            end
            app.ser = serial(COMport);
            app.ser.BaudRate = 9600;
            app.ser.Terminator = 'LF';
            app.ser.ReadAsyncMode = 'manual';

            if value == 0 %to disconnect
                %Turn timer off if needed
                while isequal(get(app.myTimer, "Running"), 'on')
                    stop(app.myTimer);
                end
                
                %disconnect if port is open
                if isequal(app.ser.Status, 'open')
                    %turn toggle off before disconnect                    
                    TurnOffToggle(app);
                    
                    %close port, clear buffer memory
                    fclose(app.ser);                    
                    flushInputBuffer(app);
                
                end
            elseif value == 1 %to connect
                fclose(instrfindall);
                app.ser.InputBufferSize = 100000;
                
                fopen(app.ser);
                
                %in case what stored in the buffer is not all the memory
                %currently in the board
                flushInputBuffer(app);
                flushInputBuffer(app);
                flushInputBuffer(app);
                
                %get toggle status from command p to the borad
                % and set our toggle value
                fprintf(app.ser, 'p');
                out = strsplit(fgetl(app.ser), ' ');
                toggle_value = out(10);        
                app.ToggleButton.Value = str2double(toggle_value);
                
            end
            
        end

        % Value changed function: ToggleButton
        function ToggleButtonValueChanged(app, event)
            value = app.ToggleButton.Value;
            if app.ConnectButton.Value == true
                if value == true
                    flushInputBuffer(app);
                    fprintf(app.ser, 'R');
                elseif value == false
                    fprintf(app.ser, 'R');
                    %flush after turn off
                    flushInputBuffer(app);
                end
            else
                app.ToggleButton.Value = false;
                uialert(app.UIFigure,'Try checking your COM port # => Connect','CD48 Device not connected');
            end 
        end

        % Value changed function: OverflowClearButton
        function OverflowClearButtonValueChanged(app, event)
            value = app.OverflowClearButton.Value;
            if value == true
                fprintf(app.ser, "E");
                %not allow user to switch state of this button to overflow
                app.OverflowClearButton.Value = false;
            elseif value == false
                %clear overflow by sending E to the board. Only work if the
                %serial port is connected
                fprintf(app.ser, "E");
                fprintf(app.ser, "E");
                %clear exisiting memory
                flushInputBuffer(app);
            end
        end

        % Button pushed function: SaveDataandSettingsButton
        function SaveDataandSettingsButtonPushed(app, event)
            [file, path] = uiputfile('*.txt', 'Save Data File'); 
            figure(app.UIFigure);
            if isequal(file,0) || isequal(path,0)
               return;
            else
               DataFileName = fullfile(path,file);
               DataTable = formatDataTable(app);
               writetable(DataTable, DataFileName);
               
               BoardSettings = settings(app);
               fid = fopen(DataFileName, 'a+');
               fprintf(fid, '%s\n', BoardSettings);
               fclose(fid);
            end
      
        end

        % Button pushed function: StopPlotButton
        function StopPlotButtonPushed(app, event)
            TurnOffTimer(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1446 921];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.Resize = 'off';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {460, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.BackgroundColor = [0.902 0.902 0.902];
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create ParametersettingsPanel
            app.ParametersettingsPanel = uipanel(app.LeftPanel);
            app.ParametersettingsPanel.Title = 'Parameter settings';
            app.ParametersettingsPanel.BackgroundColor = [0.902 0.902 0.902];
            app.ParametersettingsPanel.FontWeight = 'bold';
            app.ParametersettingsPanel.FontSize = 16;
            app.ParametersettingsPanel.Position = [21 11 422 617];

            % Create ImpeadanceButtonGroup
            app.ImpeadanceButtonGroup = uibuttongroup(app.ParametersettingsPanel);
            app.ImpeadanceButtonGroup.Title = 'Impeadance:';
            app.ImpeadanceButtonGroup.BackgroundColor = [0.902 0.902 0.902];
            app.ImpeadanceButtonGroup.FontAngle = 'italic';
            app.ImpeadanceButtonGroup.FontWeight = 'bold';
            app.ImpeadanceButtonGroup.FontSize = 14;
            app.ImpeadanceButtonGroup.Position = [0 525 421 56];

            % Create HighButton
            app.HighButton = uiradiobutton(app.ImpeadanceButtonGroup);
            app.HighButton.Text = 'High';
            app.HighButton.FontSize = 14;
            app.HighButton.Position = [91 8 58 23];
            app.HighButton.Value = true;

            % Create LowButton
            app.LowButton = uiradiobutton(app.ImpeadanceButtonGroup);
            app.LowButton.Text = 'Low';
            app.LowButton.FontSize = 14;
            app.LowButton.Position = [308 8 65 23];

            % Create TriggerlevelVLabel
            app.TriggerlevelVLabel = uilabel(app.ParametersettingsPanel);
            app.TriggerlevelVLabel.HorizontalAlignment = 'right';
            app.TriggerlevelVLabel.FontSize = 14;
            app.TriggerlevelVLabel.FontWeight = 'bold';
            app.TriggerlevelVLabel.FontAngle = 'italic';
            app.TriggerlevelVLabel.Position = [1 500 114 26];
            app.TriggerlevelVLabel.Text = 'Trigger level (V)';

            % Create TriggerlevelVSlider
            app.TriggerlevelVSlider = uislider(app.ParametersettingsPanel);
            app.TriggerlevelVSlider.Limits = [0 4.02];
            app.TriggerlevelVSlider.Position = [17 491 388 3];
            app.TriggerlevelVSlider.Value = 1.0;

            % Create SetButton
            app.SetButton = uibutton(app.ParametersettingsPanel, 'push');
            app.SetButton.ButtonPushedFcn = createCallbackFcn(app, @SetButtonPushed, true);
            app.SetButton.Position = [309 13 100 40];
            app.SetButton.Text = 'Set ';

            % Create RepeatperiodinmsEditFieldLabel
            app.RepeatperiodinmsEditFieldLabel = uilabel(app.ParametersettingsPanel);
            app.RepeatperiodinmsEditFieldLabel.HorizontalAlignment = 'right';
            app.RepeatperiodinmsEditFieldLabel.FontSize = 14;
            app.RepeatperiodinmsEditFieldLabel.FontWeight = 'bold';
            app.RepeatperiodinmsEditFieldLabel.FontAngle = 'italic';
            app.RepeatperiodinmsEditFieldLabel.Position = [4 388 143 23];
            app.RepeatperiodinmsEditFieldLabel.Text = 'Repeat period in ms';

            % Create RepeatPeriodEditField
            app.RepeatPeriodEditField = uieditfield(app.ParametersettingsPanel, 'numeric');
            app.RepeatPeriodEditField.HorizontalAlignment = 'left';
            app.RepeatPeriodEditField.FontSize = 14;
            app.RepeatPeriodEditField.Position = [208 386 208 22];
            app.RepeatPeriodEditField.Value = 100;

            % Create CountersassignmentPanel
            app.CountersassignmentPanel = uipanel(app.ParametersettingsPanel);
            app.CountersassignmentPanel.Title = 'Counters assignment';
            app.CountersassignmentPanel.BackgroundColor = [0.902 0.902 0.902];
            app.CountersassignmentPanel.FontAngle = 'italic';
            app.CountersassignmentPanel.FontWeight = 'bold';
            app.CountersassignmentPanel.FontSize = 14;
            app.CountersassignmentPanel.Position = [0 61 422 306];

            % Create ACheckBox_1
            app.ACheckBox_1 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_1.Text = 'A';
            app.ACheckBox_1.Position = [124 253 30 22];
            app.ACheckBox_1.Value = true;

            % Create BCheckBox_1
            app.BCheckBox_1 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_1.Text = 'B';
            app.BCheckBox_1.Position = [210 253 30 22];

            % Create CCheckBox_1
            app.CCheckBox_1 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_1.Text = 'C';
            app.CCheckBox_1.Position = [293 253 31 22];

            % Create DCheckBox_1
            app.DCheckBox_1 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_1.Text = 'D';
            app.DCheckBox_1.Position = [377 253 31 22];

            % Create CounterLabel_1
            app.CounterLabel_1 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_1.Position = [18 253 62 22];
            app.CounterLabel_1.Text = 'Counter 1';

            % Create ACheckBox_2
            app.ACheckBox_2 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_2.Text = 'A';
            app.ACheckBox_2.Position = [124 220 30 22];

            % Create BCheckBox_2
            app.BCheckBox_2 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_2.Text = 'B';
            app.BCheckBox_2.Position = [210 220 30 22];
            app.BCheckBox_2.Value = true;

            % Create CCheckBox_2
            app.CCheckBox_2 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_2.Text = 'C';
            app.CCheckBox_2.Position = [293 220 31 22];

            % Create DCheckBox_2
            app.DCheckBox_2 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_2.Text = 'D';
            app.DCheckBox_2.Position = [377 220 31 22];

            % Create CounterLabel_2
            app.CounterLabel_2 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_2.Position = [18 220 62 22];
            app.CounterLabel_2.Text = 'Counter 2';

            % Create ACheckBox_3
            app.ACheckBox_3 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_3.Text = 'A';
            app.ACheckBox_3.Position = [124 187 30 22];

            % Create BCheckBox_3
            app.BCheckBox_3 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_3.Text = 'B';
            app.BCheckBox_3.Position = [210 187 30 22];

            % Create CCheckBox_3
            app.CCheckBox_3 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_3.Text = 'C';
            app.CCheckBox_3.Position = [293 187 31 22];
            app.CCheckBox_3.Value = true;

            % Create DCheckBox_3
            app.DCheckBox_3 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_3.Text = 'D';
            app.DCheckBox_3.Position = [377 187 31 22];

            % Create CounterLabel_3
            app.CounterLabel_3 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_3.Position = [18 187 62 22];
            app.CounterLabel_3.Text = 'Counter 3:';

            % Create ACheckBox_4
            app.ACheckBox_4 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_4.Text = 'A';
            app.ACheckBox_4.Position = [124 153 30 22];

            % Create BCheckBox_4
            app.BCheckBox_4 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_4.Text = 'B';
            app.BCheckBox_4.Position = [210 153 30 22];

            % Create CCheckBox_4
            app.CCheckBox_4 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_4.Text = 'C';
            app.CCheckBox_4.Position = [293 153 31 22];

            % Create DCheckBox_4
            app.DCheckBox_4 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_4.Text = 'D';
            app.DCheckBox_4.Position = [377 153 31 22];
            app.DCheckBox_4.Value = true;

            % Create CounterLabel_4
            app.CounterLabel_4 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_4.Position = [18 153 62 22];
            app.CounterLabel_4.Text = 'Counter 4:';

            % Create ACheckBox_5
            app.ACheckBox_5 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_5.Text = 'A';
            app.ACheckBox_5.Position = [124 120 30 22];
            app.ACheckBox_5.Value = true;

            % Create BCheckBox_5
            app.BCheckBox_5 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_5.Text = 'B';
            app.BCheckBox_5.Position = [210 120 30 22];
            app.BCheckBox_5.Value = true;

            % Create CCheckBox_5
            app.CCheckBox_5 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_5.Text = 'C';
            app.CCheckBox_5.Position = [293 120 31 22];

            % Create DCheckBox_5
            app.DCheckBox_5 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_5.Text = 'D';
            app.DCheckBox_5.Position = [377 120 31 22];

            % Create CounterLabel_5
            app.CounterLabel_5 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_5.Position = [18 120 62 22];
            app.CounterLabel_5.Text = 'Counter 5:';

            % Create ACheckBox_6
            app.ACheckBox_6 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_6.Text = 'A';
            app.ACheckBox_6.Position = [124 86 30 22];
            app.ACheckBox_6.Value = true;

            % Create BCheckBox_6
            app.BCheckBox_6 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_6.Text = 'B';
            app.BCheckBox_6.Position = [210 86 30 22];

            % Create CCheckBox_6
            app.CCheckBox_6 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_6.Text = 'C';
            app.CCheckBox_6.Position = [293 86 31 22];
            app.CCheckBox_6.Value = true;

            % Create DCheckBox_6
            app.DCheckBox_6 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_6.Text = 'D';
            app.DCheckBox_6.Position = [377 86 31 22];

            % Create CounterLabel_6
            app.CounterLabel_6 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_6.Position = [18 86 62 22];
            app.CounterLabel_6.Text = 'Counter 6:';

            % Create ACheckBox_7
            app.ACheckBox_7 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_7.Text = 'A';
            app.ACheckBox_7.Position = [124 52 30 22];
            app.ACheckBox_7.Value = true;

            % Create BCheckBox_7
            app.BCheckBox_7 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_7.Text = 'B';
            app.BCheckBox_7.Position = [210 52 30 22];

            % Create CCheckBox_7
            app.CCheckBox_7 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_7.Text = 'C';
            app.CCheckBox_7.Position = [293 52 31 22];

            % Create DCheckBox_7
            app.DCheckBox_7 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_7.Text = 'D';
            app.DCheckBox_7.Position = [377 52 31 22];
            app.DCheckBox_7.Value = true;

            % Create CounterLabel_7
            app.CounterLabel_7 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_7.Position = [18 52 62 22];
            app.CounterLabel_7.Text = 'Counter 7:';

            % Create ACheckBox_8
            app.ACheckBox_8 = uicheckbox(app.CountersassignmentPanel);
            app.ACheckBox_8.Text = 'A';
            app.ACheckBox_8.Position = [124 17 30 22];
            app.ACheckBox_8.Value = true;

            % Create BCheckBox_8
            app.BCheckBox_8 = uicheckbox(app.CountersassignmentPanel);
            app.BCheckBox_8.Text = 'B';
            app.BCheckBox_8.Position = [210 17 30 22];
            app.BCheckBox_8.Value = true;

            % Create CCheckBox_8
            app.CCheckBox_8 = uicheckbox(app.CountersassignmentPanel);
            app.CCheckBox_8.Text = 'C';
            app.CCheckBox_8.Position = [293 17 31 22];
            app.CCheckBox_8.Value = true;

            % Create DCheckBox_8
            app.DCheckBox_8 = uicheckbox(app.CountersassignmentPanel);
            app.DCheckBox_8.Text = 'D';
            app.DCheckBox_8.Position = [377 17 31 22];

            % Create CounterLabel_8
            app.CounterLabel_8 = uilabel(app.CountersassignmentPanel);
            app.CounterLabel_8.Position = [18 17 62 22];
            app.CounterLabel_8.Text = 'Counter 8:';

            % Create ResetButton
            app.ResetButton = uibutton(app.ParametersettingsPanel, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.Position = [15 11 100 40];
            app.ResetButton.Text = 'Reset ';

            % Create ClearAllButton
            app.ClearAllButton = uibutton(app.ParametersettingsPanel, 'push');
            app.ClearAllButton.ButtonPushedFcn = createCallbackFcn(app, @ClearAllButtonPushed, true);
            app.ClearAllButton.Position = [164 13 100 40];
            app.ClearAllButton.Text = 'Clear All';

            % Create RuntimeLimitmsLabel
            app.RuntimeLimitmsLabel = uilabel(app.ParametersettingsPanel);
            app.RuntimeLimitmsLabel.HorizontalAlignment = 'right';
            app.RuntimeLimitmsLabel.FontSize = 14;
            app.RuntimeLimitmsLabel.FontWeight = 'bold';
            app.RuntimeLimitmsLabel.FontAngle = 'italic';
            app.RuntimeLimitmsLabel.Position = [4 423 135 23];
            app.RuntimeLimitmsLabel.Text = 'Runtime Limit (ms)';

            % Create RuntimeValue
            app.RuntimeValue = uieditfield(app.ParametersettingsPanel, 'numeric');
            app.RuntimeValue.HorizontalAlignment = 'left';
            app.RuntimeValue.FontSize = 14;
            app.RuntimeValue.Position = [208 424 209 22];
            app.RuntimeValue.Value = 3600000;

            % Create ConnectButton
            app.ConnectButton = uibutton(app.LeftPanel, 'state');
            app.ConnectButton.ValueChangedFcn = createCallbackFcn(app, @ConnectButtonValueChanged, true);
            app.ConnectButton.Text = 'Connect';
            app.ConnectButton.Position = [216 639 104 40];

            % Create COMPortEditFieldLabel
            app.COMPortEditFieldLabel = uilabel(app.LeftPanel);
            app.COMPortEditFieldLabel.HorizontalAlignment = 'right';
            app.COMPortEditFieldLabel.FontSize = 14;
            app.COMPortEditFieldLabel.FontWeight = 'bold';
            app.COMPortEditFieldLabel.Position = [20 647 82 23];
            app.COMPortEditFieldLabel.Text = 'COM Port #';

            % Create COMPortEditField
            app.COMPortEditField = uieditfield(app.LeftPanel, 'numeric');
            app.COMPortEditField.FontWeight = 'bold';
            app.COMPortEditField.Position = [117 648 76 22];
            app.COMPortEditField.Value = 4;

            % Create SettingsLabel
            app.SettingsLabel = uilabel(app.LeftPanel);
            app.SettingsLabel.FontSize = 25;
            app.SettingsLabel.FontWeight = 'bold';
            app.SettingsLabel.Position = [180 871 99 42];
            app.SettingsLabel.Text = 'Settings';

            % Create ToggleButton
            app.ToggleButton = uibutton(app.LeftPanel, 'state');
            app.ToggleButton.ValueChangedFcn = createCallbackFcn(app, @ToggleButtonValueChanged, true);
            app.ToggleButton.Text = 'Toggle';
            app.ToggleButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ToggleButton.Position = [338 639 105 40];

            % Create PossiblebugsanddebuggingTextArea
            app.PossiblebugsanddebuggingTextArea = uitextarea(app.LeftPanel);
            app.PossiblebugsanddebuggingTextArea.FontSize = 14;
            app.PossiblebugsanddebuggingTextArea.Position = [25 691 418 168];
            app.PossiblebugsanddebuggingTextArea.Value = {'READ ME'; 'Setup info'; ''; '1. If the app window appears to be too big, check Computer/Settings/Display Settings. Recommend 100%'; ' '; '2.  Steps to connect:'; '    i)   Find port number with Start/Devices Manager '; '    ii)  Open PORT => Check the Port'; '    iii) Enter onto COM port # above, then Connect'; ''; '3. If runtime < repeat time period, it will be set to 3600000'; '4. Maximum repeat period is 65000 ms'; '5. Minimum repeat period is 100 ms'; ''; ''};

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.ForegroundColor = [1 1 1];
            app.RightPanel.BackgroundColor = [0.902 0.902 0.902];
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            title(app.UIAxes, 'Counter 1')
            xlabel(app.UIAxes, 'Time bin ')
            ylabel(app.UIAxes, 'Counts')
            app.UIAxes.Position = [34 642 300 230];

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.RightPanel);
            title(app.UIAxes_2, 'Counter 2')
            xlabel(app.UIAxes_2, 'Time bin ')
            ylabel(app.UIAxes_2, 'Counts')
            app.UIAxes_2.Position = [343 642 300 230];

            % Create UIAxes_3
            app.UIAxes_3 = uiaxes(app.RightPanel);
            title(app.UIAxes_3, 'Counter 3')
            xlabel(app.UIAxes_3, 'Time bin ')
            ylabel(app.UIAxes_3, 'Counts')
            app.UIAxes_3.Position = [654 643 300 230];

            % Create UIAxes_4
            app.UIAxes_4 = uiaxes(app.RightPanel);
            title(app.UIAxes_4, 'Counter 4')
            xlabel(app.UIAxes_4, 'Time bin ')
            ylabel(app.UIAxes_4, 'Counts')
            app.UIAxes_4.Position = [34 345 300 230];

            % Create UIAxes_5
            app.UIAxes_5 = uiaxes(app.RightPanel);
            title(app.UIAxes_5, 'Counter 5')
            xlabel(app.UIAxes_5, 'Time bin ')
            ylabel(app.UIAxes_5, 'Counts')
            app.UIAxes_5.Position = [343 344 300 230];

            % Create UIAxes_6
            app.UIAxes_6 = uiaxes(app.RightPanel);
            title(app.UIAxes_6, 'Counter 6')
            xlabel(app.UIAxes_6, 'Time bin ')
            ylabel(app.UIAxes_6, 'Counts')
            app.UIAxes_6.Position = [654 346 300 230];

            % Create UIAxes_7
            app.UIAxes_7 = uiaxes(app.RightPanel);
            title(app.UIAxes_7, 'Counter 7')
            xlabel(app.UIAxes_7, 'Time bin ')
            ylabel(app.UIAxes_7, 'Counts')
            app.UIAxes_7.Position = [343 55 300 230];

            % Create UIAxes_8
            app.UIAxes_8 = uiaxes(app.RightPanel);
            title(app.UIAxes_8, 'Counter 8')
            xlabel(app.UIAxes_8, 'Time bin ')
            ylabel(app.UIAxes_8, 'Counts')
            app.UIAxes_8.Position = [654 55 300 230];

            % Create OverflowClearButton
            app.OverflowClearButton = uibutton(app.RightPanel, 'state');
            app.OverflowClearButton.ValueChangedFcn = createCallbackFcn(app, @OverflowClearButtonValueChanged, true);
            app.OverflowClearButton.Text = 'Overflow/Clear';
            app.OverflowClearButton.FontSize = 15;
            app.OverflowClearButton.Position = [190 115 120 60];

            % Create CountratecpsEditFieldLabel
            app.CountratecpsEditFieldLabel = uilabel(app.RightPanel);
            app.CountratecpsEditFieldLabel.HorizontalAlignment = 'right';
            app.CountratecpsEditFieldLabel.FontWeight = 'bold';
            app.CountratecpsEditFieldLabel.Position = [34 610 90 23];
            app.CountratecpsEditFieldLabel.Text = 'Countrate(cps)';

            % Create CountratecpsEditField
            app.CountratecpsEditField = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField.Editable = 'off';
            app.CountratecpsEditField.Position = [139 611 100 22];

            % Create CountratecpsEditField_2Label
            app.CountratecpsEditField_2Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_2Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_2Label.FontWeight = 'bold';
            app.CountratecpsEditField_2Label.Position = [343 610 94 23];
            app.CountratecpsEditField_2Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_2
            app.CountratecpsEditField_2 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_2.Editable = 'off';
            app.CountratecpsEditField_2.Position = [452 611 100 22];

            % Create CountratecpsEditField_3Label
            app.CountratecpsEditField_3Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_3Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_3Label.FontWeight = 'bold';
            app.CountratecpsEditField_3Label.Position = [654 610 94 23];
            app.CountratecpsEditField_3Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_3
            app.CountratecpsEditField_3 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_3.Editable = 'off';
            app.CountratecpsEditField_3.Position = [763 611 100 22];

            % Create CountratecpsEditField_4Label
            app.CountratecpsEditField_4Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_4Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_4Label.FontWeight = 'bold';
            app.CountratecpsEditField_4Label.Position = [34 311 94 23];
            app.CountratecpsEditField_4Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_4
            app.CountratecpsEditField_4 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_4.Editable = 'off';
            app.CountratecpsEditField_4.FontWeight = 'bold';
            app.CountratecpsEditField_4.Position = [143 312 100 22];

            % Create CountratecpsEditField_5Label
            app.CountratecpsEditField_5Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_5Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_5Label.FontWeight = 'bold';
            app.CountratecpsEditField_5Label.Position = [343 311 94 23];
            app.CountratecpsEditField_5Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_5
            app.CountratecpsEditField_5 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_5.Editable = 'off';
            app.CountratecpsEditField_5.Position = [452 312 100 22];

            % Create CountratecpsEditField_6Label
            app.CountratecpsEditField_6Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_6Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_6Label.FontWeight = 'bold';
            app.CountratecpsEditField_6Label.Position = [654 311 94 23];
            app.CountratecpsEditField_6Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_6
            app.CountratecpsEditField_6 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_6.Editable = 'off';
            app.CountratecpsEditField_6.Position = [763 312 100 22];

            % Create CountratecpsEditField_7Label
            app.CountratecpsEditField_7Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_7Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_7Label.FontWeight = 'bold';
            app.CountratecpsEditField_7Label.Position = [333 22 94 23];
            app.CountratecpsEditField_7Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_7
            app.CountratecpsEditField_7 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_7.Editable = 'off';
            app.CountratecpsEditField_7.FontWeight = 'bold';
            app.CountratecpsEditField_7.Position = [442 23 100 22];

            % Create CountratecpsEditField_8Label
            app.CountratecpsEditField_8Label = uilabel(app.RightPanel);
            app.CountratecpsEditField_8Label.HorizontalAlignment = 'right';
            app.CountratecpsEditField_8Label.FontWeight = 'bold';
            app.CountratecpsEditField_8Label.Position = [654 23 94 23];
            app.CountratecpsEditField_8Label.Text = 'Countrate (cps)';

            % Create CountratecpsEditField_8
            app.CountratecpsEditField_8 = uieditfield(app.RightPanel, 'numeric');
            app.CountratecpsEditField_8.Editable = 'off';
            app.CountratecpsEditField_8.FontWeight = 'bold';
            app.CountratecpsEditField_8.Position = [763 24 100 22];

            % Create SaveDataandSettingsButton
            app.SaveDataandSettingsButton = uibutton(app.RightPanel, 'push');
            app.SaveDataandSettingsButton.ButtonPushedFcn = createCallbackFcn(app, @SaveDataandSettingsButtonPushed, true);
            app.SaveDataandSettingsButton.FontSize = 15;
            app.SaveDataandSettingsButton.Position = [43 35 266 39];
            app.SaveDataandSettingsButton.Text = 'Save Data and Settings';

            % Create StartPlotButton
            app.StartPlotButton = uibutton(app.RightPanel, 'push');
            app.StartPlotButton.ButtonPushedFcn = createCallbackFcn(app, @StartPlotButtonPushed, true);
            app.StartPlotButton.FontSize = 15;
            app.StartPlotButton.Position = [43 197 120 60];
            app.StartPlotButton.Text = 'Start Plot';

            % Create StopPlotButton
            app.StopPlotButton = uibutton(app.RightPanel, 'push');
            app.StopPlotButton.ButtonPushedFcn = createCallbackFcn(app, @StopPlotButtonPushed, true);
            app.StopPlotButton.FontSize = 15;
            app.StopPlotButton.Position = [190 197 120 60];
            app.StopPlotButton.Text = 'Stop Plot';

            % Create TestboardButton
            app.TestboardButton = uibutton(app.RightPanel, 'push');
            app.TestboardButton.ButtonPushedFcn = createCallbackFcn(app, @TestboardButtonPushed, true);
            app.TestboardButton.FontSize = 15;
            app.TestboardButton.Position = [44 115 119 60];
            app.TestboardButton.Text = 'Test board';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CD48_App_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
            
        end
    end
end