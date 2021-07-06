%algorithms = {'DDAO','Case1','Case2','Case3','Case4','Case5','Case6','Case7','Case8','Case9','Case10','Case11','Case12','Case13','Case14','Case15','Case2_1','Case2_2','Case2_3','Case2_4','Case2_5','Case2_6','Case2_7','Case2_8','Case2_9','Case2_10','Case2_11','Case2_12','Case2_13','Case2_14','Case2_15','Case3_1','Case3_2','Case3_3','Case3_4','Case3_5','Case3_6','Case3_7','Case3_8','Case3_9','Case3_10','Case3_11','Case3_12','Case3_13','Case3_14','Case3_15'};
algorithms = {'Case3_16','Case3_17','Case3_18'};
dimension = 50; 
run = 25; 
maxIteration = 10000*dimension;
filename = 'result';
functionsNumber = 10;
solution = zeros(functionsNumber, run);
globalMins = [100, 1100, 700, 1900, 1700, 1600, 2100, 2200, 2400, 2500];
paths;
cec20so = str2func('cec20_func_so'); 
for ii = 1 : length(algorithms)
    disp(algorithms(ii));
    algorithm = str2func(char(algorithms(ii)));
    for i = 1 : functionsNumber
        disp(i);
        for j = 1 : run
            [bestSolution, bestFitness, iteration] = algorithm(cec20so, dimension, maxIteration, i);
            solution(i, j) = bestFitness - globalMins(i);
   
        end
    end
    xlswrite(strcat(filename, '-d=', num2str(dimension), '.xlsx'), solution, func2str(algorithm));
    eD = strcat(func2str(algorithm), '-Bitti :)');
    disp(eD);
end