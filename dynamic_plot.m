function dynamic_plot
F = figure();
val = 1;
x = 1:100;
y = 1:0.1:10.9;
plot(x,y)
H = uicontrol(F,'Style','slider');
addlistener(H, 'Value', 'PostSet',@myCallBack);
end
function myCallBack(hObj,event,x,y)
val = 100*get(event.AffectedObject,'Value')
plot(x,y.*val)
end