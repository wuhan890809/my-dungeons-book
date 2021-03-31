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

local function Wrapper_Create(parentFrame)
    local wrapper = AceGUI:Create("SimpleGroup");
    wrapper:SetLayout("Flow");
    wrapper:SetAutoAdjustHeight(false);
    wrapper:SetFullWidth(true);
    parentFrame:AddChild(wrapper);
    return wrapper;
end

local function GraphWrapper_Create()
    local graphWrapper = AceGUI:Create("SimpleGroup");
    graphWrapper:SetFullWidth(true);
    graphWrapper:SetAutoAdjustHeight(false);
    graphWrapper:SetHeight(150);
    return graphWrapper;
end

local function ScaleSlider_Create()
    local scaleSlider = AceGUI:Create("Slider");
    scaleSlider:SetLabel(L["Scale"]);
    scaleSlider:SetSliderValues(0, 95, 0.5);
    scaleSlider:SetValue(0);
    scaleSlider.editbox:Hide();
    scaleSlider.lowtext:Hide();
    scaleSlider.hightext:Hide();
    scaleSlider:SetCallback("OnRelease", function(widget)
        widget.editbox:Show();
        widget.lowtext:Show();
        widget.hightext:Show();
    end);
    return scaleSlider;
end

local function TimelineSlider_Create()
    local timeLineSlider = AceGUI:Create("Slider");
    timeLineSlider:SetLabel(L["Timeline"]);
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
    return timeLineSlider;
end

local function BaseGraph_Setup(g, xMin, xMax, yMin, yMax)
    g:SetXAxis(xMin, xMax);
    g:SetYAxis(yMin, 1.25 * yMax);
    g:SetFormatXAxisAsTime();
    g:SetGridSpacing(xMax / 5, 1);
    g:SetGridColor({0.5, 0.5, 0.5, 0.5});
    g:SetAxisDrawing(true, true);
    g:SetAxisColor({1.0, 1.0, 1.0, 1.0});
    g:SetAutoScale(false);
    g:CreateGridlines();
end

local function getNewXMax(scale, xMin, gxMax)
    local newXMax = xMin + gxMax * (100 - scale) / 100;
    return (newXMax < gxMax and newXMax) or gxMax;
end

local function getNewXMin(scale, xMax, gxMax)
    local newXMin = gxMax * (100 - scale) / 100 - xMax;
    return (newXMin > 0 and newXMin) or 0;
end

local function SingleFilledAreaGraphData_Setup(series, zeroDelay, xLimit)
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
    return remappedTimeline, remappedTimelineScaled, yMax, gxMax, xMin, xMax;
end

local function IconsGraphData_Setup(series, zeroDelay, xLimit)
    local remappedTimeline = {};
    local maxTimeLineValue = 0;
    for _, v in pairs(series.timeline) do
        local x = v[1] - zeroDelay - 10;
        tinsert(remappedTimeline, {x, v[2]});
        if (x > maxTimeLineValue) then
            maxTimeLineValue = x;
        end
    end

    local remappedTimelineScaled = remappedTimeline;
    local xMax = xLimit or maxTimeLineValue;
    local gxMax = xMax;
    local xMin = 0;
    return remappedTimeline, remappedTimelineScaled, 4, gxMax, xMin, xMax;
end

local function IconsGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline, encounterSeries, series)
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
    local encounterSeriesScaled = {};
    for i = 1, #encounterSeries do
        local v = encounterSeries[i];
        if (v[1] <= xMax and v[1] >= xMin) then
            tinsert(encounterSeriesScaled, v);
        end
    end
    if (#encounterSeriesScaled > 0) then
        tinsert(encounterSeriesScaled, 1, { xMin, encounterSeriesScaled[1][2] });
        local last = encounterSeriesScaled[#encounterSeriesScaled];
        tinsert(encounterSeriesScaled, { xMax, last[2] });
    end
    g:AddIconSeries(remappedTimelineScaled, series.size, series.icon);
    g:AddFilledDataSeries(encounterSeriesScaled, defaultColor);
end

local function SingleFilledAreaGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline)
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
    local wrapper = Wrapper_Create(parentFrame);
    local graphWidth = parentFrame.frame.width - 40;
    local graphWrapper = GraphWrapper_Create();
    local g = LibGraph:CreateGraphLine(name, graphWrapper.frame, "TOPLEFT", "TOPLEFT", 5, 0, graphWidth, graphHeight);

    local remappedTimeline, remappedTimelineScaled, yMax, gxMax, xMin, xMax = SingleFilledAreaGraphData_Setup(series, zeroDelay, xLimit);

    BaseGraph_Setup(g, xMin, xMax, 0, yMax);
    g:AddFilledDataSeries(remappedTimelineScaled, defaultColor);

    local scaleValue = 0;

    local timeLineSlider = TimelineSlider_Create();
    local scaleSlider = ScaleSlider_Create();

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
        xMax = getNewXMax(scaleValue, xMin, gxMax);
        xMin = getNewXMin(scaleValue, xMax, gxMax);
        SingleFilledAreaGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline);
    end);
    wrapper:AddChild(scaleSlider);

    wrapper:AddChild(graphWrapper);

    timeLineSlider:SetSliderValues(xMin, 0, 5);
    timeLineSlider:SetValue(xMin);
    timeLineSlider:SetCallback("OnValueChanged", function(_, _, newXMin)
        xMin = newXMin;
        xMax = getNewXMax(scaleValue, xMin, gxMax);
        SingleFilledAreaGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline);
    end);
    wrapper:AddChild(timeLineSlider);
    wrapper:SetHeight(250);
    return g, scaleSlider, timeLineSlider;
end

--[[--
@param[type=Frame] parentFrame
@param[type=string] name
@param[type=table] series
@param[type=number] zeroDelay
@param[type=number] xLimit
@param[type=number] graphHeight
@param[type=table] legend
@return[type=Frame]
]]
function MyDungeonsBook:SingleIconsGraph_Create(parentFrame, name, series, encounterSeries, zeroDelay, xLimit, graphHeight, legend)
    local wrapper = Wrapper_Create(parentFrame);
    local graphWidth = parentFrame.frame.width - 40;
    local graphWrapper = GraphWrapper_Create();
    local g = LibGraph:CreateGraphLine(name, graphWrapper.frame, "TOPLEFT", "TOPLEFT", 5, 0, graphWidth, graphHeight);
    g:SetYLabels(true, false);
    g.CustomYLabels = legend;
    local remappedTimeline, remappedTimelineScaled, yMax, gxMax, xMin, xMax = IconsGraphData_Setup(series, zeroDelay, xLimit);
    BaseGraph_Setup(g, xMin, xMax, 0, yMax);
    g:AddFilledDataSeries(encounterSeries, defaultColor);
    g:AddIconSeries(remappedTimelineScaled, series.size, series.icon);

    local scaleValue = 0;

    local timeLineSlider = TimelineSlider_Create();
    local scaleSlider = ScaleSlider_Create();
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
        xMax = getNewXMax(scaleValue, xMin, gxMax);
        xMin = getNewXMin(scaleValue, xMax, gxMax);
        IconsGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline, encounterSeries, series);
    end);
    wrapper:AddChild(scaleSlider);

    wrapper:AddChild(graphWrapper);

    timeLineSlider:SetSliderValues(xMin, 0, 5);
    timeLineSlider:SetValue(xMin);
    timeLineSlider:SetCallback("OnValueChanged", function(_, _, newXMin)
        xMin = newXMin;
        xMax = getNewXMax(scaleValue, xMin, gxMax);
        IconsGraph_Update(g, xMin, xMax, remappedTimelineScaled, remappedTimeline, encounterSeries, series);
    end);
    wrapper:AddChild(timeLineSlider);
    wrapper:SetHeight(300);
    return g, scaleSlider, timeLineSlider, wrapper;
end
