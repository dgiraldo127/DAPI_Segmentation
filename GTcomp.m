function statistics = GTcomp(img,GT)
if ~isequal(size(img),size(GT))
    fprintf('Mask and Ground Truth are different dimensions, invalid.\n')
    TruePositive = NaN;
    TrueNegative = NaN;
    FalsePositive = NaN;
    FalseNegative = NaN;
elseif isa(img,'logical') == 0 || isa(GT,'logical') == 0
    fprintf('Mask or Ground Truth is of invalid data type.\n')
    TruePositive = NaT;
    TrueNegative = NaT;
    FalsePositive = NaT;
    FalseNegative = NaT;
else
    TruePositive = 0;
    TrueNegative = 0;
    FalsePositive = 0;
    FalseNegative = 0;
    for ii = 1:size(GT,1)
        for jj = 1:size(GT,2)
            if img(ii,jj) == 1 && GT(ii,jj) == 1
                TruePositive = TruePositive + 1;
            elseif img(ii,jj) == 0 && GT(ii,jj) == 0
                TrueNegative = TrueNegative + 1;
            elseif img(ii,jj) == 1 && GT(ii,jj) == 0
                FalsePositive = FalsePositive + 1;
            elseif img(ii,jj) == 0 && GT(ii,jj) == 1
                FalseNegative = FalseNegative + 1;
            end
        end
    end
end

TP = TruePositive;
TN = TrueNegative;
FP = FalsePositive;
FN = FalseNegative;

statistics.TruePositive = TP;
statistics.TrueNegative = TN;
statistics.FalsePositive = FP;
statistics.FalseNegative = FN;
statistics.F1_Score = TP/(TP+0.5*(FP+FN));
statistics.Precision = TP/(TP+FP);
statistics.Recall = TP/(TP+FN);
statistics.Specificity_DIC = TN/(TN+FP);
end
