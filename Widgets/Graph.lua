--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Widgets
]]

local AceGUI = LibStub("AceGUI-3.0");
local LibGraph = LibStub("LibGraphMdb-2.0");

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local defaultColor = {0, 112, 222, 0.5};

--[[--
@param[type=Frame] parentFrame
@param[type=string] name
@param[type=table] series
@param[type=number] zeroDelay
@param[type=number] xLimit
@param[type=number] graphHeight
@return[type=Frame]
]]
function MyDungeonsBook:SingleFilledAreaGraph_Create(parentFrame, name, series, zeroDelay, xLimit, graphHeight)
    local wrapper = AceGUI:Create("SimpleGroup");
    wrapper:SetLayout("Flow");
    wrapper:SetAutoAdjustHeight(false);
    wrapper:SetFullWidth(true);
    parentFrame:AddChild(wrapper);
    local graphWidth = parentFrame.frame.width - 40;
    local graphWrapper = AceGUI:Create("SimpleGroup");
    graphWrapper:SetFullWidth(true);
    graphWrapper:SetAutoAdjustHeight(false);
    graphWrapper:SetHeight(150);
    local g = LibGraph:CreateGraphLine(name, graphWrapper.frame, "TOPLEFT", "TOPLEFT", 5, 0, graphWidth, graphHeight);

    local remappedTimeline = {};
    local yMax = -1;
    local lastValue = 0;
    local maxTimeLineValue = 0;
    for _, v in pairs(series.timeline) do
        local x = v[1] - zeroDelay - 10;
        tinsert(remappedTimeline, {x, lastValue});
        tinsert(remappedTimeline, {x, v[2]});
        lastValue = v[2];
        if (v[2] > yMax) then
            yMax = v[2];
        end
        if (x > maxTimeLineValue) then
            maxTimeLineValue = x;
        end
    end

    local remappedTimelineScaled = remappedTimeline;
    local xMax = xLimit or maxTimeLineValue;
    local gxMax = xMax;
    local xMin = 0;

    tinsert(remappedTimeline, {xMax, lastValue});

    g:SetXAxis(xMin, xMax);
    g:SetYAxis(0, 1.25 * yMax);
    g:SetFormatXAxisAsTime();
    g:SetGridSpacing(xMax / 5, 1);
    g:SetGridColor({0.5, 0.5, 0.5, 0.5});
    g:SetAxisDrawing(true, true);
    g:SetAxisColor({1.0, 1.0, 1.0, 1.0});
    g:SetAutoScale(false);
    g:CreateGridlines();
    g:AddFilledDataSeries(remappedTimelineScaled, defaultColor);

    local scaleValue = 0;

    local function getNewXMax(scale)
        local newXMax = xMin + gxMax * (100 - scale) / 100;
        return (newXMax < gxMax and newXMax) or gxMax;
    end
    local function getNewXMin(scale)
        local newXMin = gxMax * (100 - scale) / 100 - xMax;
        return (newXMin > 0 and newXMin) or 0;
    end
    local function updateGraph()
        g:SetXAxis(xMin, xMax);
        g:SetGridSpacing((xMax - xMin) / 5, 1);
        g:ResetData();
        remappedTimelineScaled = {};
        for i = 1, #remappedTimeline do
            local v = remappedTimeline[i];
            if (v[1] <= xMax and v[1] >= xMin) then
                tinsert(remappedTimelineScaled, v);
            end
        end
        if (#remappedTimelineScaled > 0) then
            tinsert(remappedTimelineScaled, 1, { xMin, remappedTimelineScaled[1][2] });
            local last = remappedTimelineScaled[#remappedTimelineScaled];
            tinsert(remappedTimelineScaled, { xMax, last[2] });
        end
        g:AddFilledDataSeries(remappedTimelineScaled, defaultColor);
    end

    local timeLineSlider = AceGUI:Create("Slider");
    local scaleSlider = AceGUI:Create("Slider");
    scaleSlider:SetLabel(L["Scale"]);
    scaleSlider:SetSliderValues(0, 95, 0.5);
    scaleSlider:SetValue(0);
    scaleSlider:SetCallback("OnValueChanged", function(_, _, newScaleValue)
        scaleValue = newScaleValue;
        local xMaxForTimeline = gxMax * scaleValue / 100;
        local currentTimeLineValue = timeLineSlider:GetValue();
        if (currentTimeLineValue > xMaxForTimeline) then
            timeLineSlider:SetValue(xMaxForTimeline);
        end
        if (currentTimeLineValue < 0) then
            timeLineSlider:SetValue(0);
        end
        timeLineSlider:SetSliderValues(0, xMaxForTimeline, 5);
        xMax = getNewXMax(scaleValue);
        xMin = getNewXMin(scaleValue);
        updateGraph();
    end);
    scaleSlider.editbox:Hide();
    scaleSlider.lowtext:Hide();
    scaleSlider.hightext:Hide();
    scaleSlider:SetCallback("OnRelease", function(widget)
        widget.editbox:Show();
        widget.lowtext:Show();
        widget.hightext:Show();
    end);
    wrapper:AddChild(scaleSlider);
    wrapper:AddChild(graphWrapper);

    timeLineSlider:SetLabel(L["Timeline"]);
    timeLineSlider:SetSliderValues(xMin, 0, 5);
    timeLineSlider:SetValue(xMin);
    timeLineSlider:SetCallback("OnValueChanged", function(_, _, newXMin)
        xMin = newXMin;
        xMax = getNewXMax(scaleValue);
        updateGraph();
    end);
    timeLineSlider:SetFullWidth(true);
    timeLineSlider.editbox:Hide();
    timeLineSlider.lowtext:Hide();
    timeLineSlider.hightext:Hide();
    timeLineSlider.label:Hide();
    timeLineSlider:SetCallback("OnRelease", function(widget)
        widget.editbox:Show();
        widget.lowtext:Show();
        widget.hightext:Show();
        widget.label:Show();
    end);
    wrapper:AddChild(timeLineSlider);
    wrapper:SetHeight(300);
    return g, scaleSlider, timeLineSlider;
end
