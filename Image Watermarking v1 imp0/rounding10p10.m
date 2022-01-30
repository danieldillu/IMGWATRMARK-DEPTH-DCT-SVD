function [rnumber]=rounding10p10(inputNumber)
temp=inputNumber*.1e+10;
temp2=round(temp);
rnumber=temp2/.1e+10;
end