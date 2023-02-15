classdef source < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        ImportdataButton    matlab.ui.control.Button
        UIAxes              matlab.ui.control.UIAxes
        rate_label          matlab.ui.control.Label
        rate2               matlab.ui.control.Label
        AbnormalitiesLabel  matlab.ui.control.Label
    end

%by BraveKek







    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ImportdataButton
        function ImportdataButtonPushed(app, event)
        [file,path] = uigetfile('*.mat')
        if file==0
            return
        end
        ECG = load(fullfile(path,file));
        ECG = struct2array(ECG)
        time= [1:length(ECG)];
        plot(app.UIAxes,time,ECG)
        grid(app.UIAxes,'on')
        [PA PT]= findpeaks(ECG,'MinPeakHeight',400)
        QRC = diff(PT)
        average_time = mean(QRC)
         rateps = 1000/average_time
         ratepm = 60*rateps
        app.rate_label.Visible='on'
        app.rate_label.Text= strcat('Heart Rate(BPM): ',int2str(ratepm))
        app.rate2.Text =strcat('Heart Rate(BPS): ',int2str(rateps))
        if ratepm >100
            app.AbnormalitiesLabel.Text = 'Abnormalities:Tachycardia detected normal heart rate shouldnt exceed 100 BPM'
        elseif rate <60
            app.AbnormalitiesLabel.Text ='Abnormalities:Bradycardia detected normal heart rate shouldnt be blow 60 BPM'
        end

 
 %https://github.com/BraveCake?tab=repositories
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create ImportdataButton
            app.ImportdataButton = uibutton(app.UIFigure, 'push');
            app.ImportdataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportdataButtonPushed, true);
            app.ImportdataButton.Position = [143 101 100 22];
            app.ImportdataButton.Text = 'Import data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'ECG Signal')
            xlabel(app.UIAxes, 'Time (ms)')
            ylabel(app.UIAxes, ' Amplitude')
            app.UIAxes.Position = [100 188 477 185];

            % Create rate_label
            app.rate_label = uilabel(app.UIFigure);
            app.rate_label.Visible = 'off';
            app.rate_label.Position = [431 101 121 22];
            app.rate_label.Text = 'Heart Rate (BPM) :    ';

            % Create rate2
            app.rate2 = uilabel(app.UIFigure);
            app.rate2.Position = [431 71 121 22];
            app.rate2.Text = '';

            % Create AbnormalitiesLabel
            app.AbnormalitiesLabel = uilabel(app.UIFigure);
            app.AbnormalitiesLabel.Position = [100 31 477 22];
            app.AbnormalitiesLabel.Text = 'Abnormalities:';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = source

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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
