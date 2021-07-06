%% Problem Parameters
function [bestSolution,  bestFitness, iteration] = Case3_2(cec20so,dimension,maxIteration,i)
CostFunction = @(x) DeJong(x);    
Nvar =dimension;                % Number of Variables
VarLength = [1 Nvar];           % solution vector size
settings;
L_limit = lbArray;              % Lower limit of solution vector
U_limit = ubArray;              % Upper limit of solution vector

%% DDAO Parameters
MaxIt= maxIteration;     % Maximum Number of Iterations
MaxSubIt=1000;    % Maximum Number of Sub-iterations
T0=2000;       % Initial Temp.
alpha=0.995;     % Temp. Reduction Rate
Npop=3;        % Population Size
fhd=cec20so;
fNumber=i;
t=1;

%% Initialization
empty_template.Phase=[];
empty_template.Cost=[];
pop=repmat(empty_template,Npop,1);

% Initialize Best Solution
BestSol.Cost=inf;
% Initialize Population
for i=1:Npop    
    % Initialize Position
    pop(i).Phase= unifrnd(L_limit,U_limit,VarLength);
    % Evaluation
    %pop(i).Cost=CostFunction(pop(i).Phase); 
    pop(i).Cost=testFunction( (pop(i).Phase)', fhd, fNumber );
    t = t+1;
    % Update Best Solution
    if pop(i).Cost<=BestSol.Cost
        BestSol=pop(i);
    end    
end
% Vector to Hold Best Costs
BestCost=zeros(MaxIt,1);
% Intialize Temp.
T = T0;
%% main loop

while(t < MaxIt) %t=1:MaxIt
    newpop = repmat(empty_template,MaxSubIt,1);
    %%%%%
    index = fitnessDistanceBalance(pop, pop(i).Cost );
   
   
        for subit=1:MaxSubIt 
           
        % Create and Evaluate New Solutions        
        newpop(subit).Phase = unifrnd(L_limit,U_limit,VarLength);
        % set the new solution within the search space
        newpop(subit).Phase = max(newpop(subit).Phase, L_limit);
        newpop(subit).Phase = min(newpop(subit).Phase, U_limit);
        % Evaluate new solution
        %newpop(subit).Cost=CostFunction(newpop(subit).Phase);
        newpop(subit).Cost=testFunction( (newpop(subit).Phase)', fhd, fNumber );
        t=t+1;
        end        
        % Sort Neighbors
        [~, SortOrder]=sort([newpop.Cost]);
        newpop=newpop(SortOrder);
        bnew = newpop(1);
        kk = randi(Npop);
        bb = randi(Npop);
        
        
        % forging parameter
        if(rem(t,2)==1)
            if(rand<0.9)
                Mnew.Phase = (pop(kk).Phase-pop(index).Phase)+ bnew.Phase;
            else
                Mnew.Phase = (pop(kk).Phase-pop(bb).Phase)+ bnew.Phase;
            end
        elseif (rem(t,2)==0)
            if(rand<0.9)
                Mnew.Phase = (pop(kk).Phase-pop(bb).Phase)+ bnew.Phase*rand;
            else
                Mnew.Phase = (pop(kk).Phase-pop(bb).Phase)+ bnew.Phase*rand;
            end
        end
        
        
        % set the new solution within the search space
        Mnew.Phase = max(Mnew.Phase, L_limit);
        Mnew.Phase = min(Mnew.Phase, U_limit); 
        % Evaluate new solution
        %Mnew.Cost=CostFunction(Mnew.Phase);
        Mnew.Cost=testFunction( (Mnew.Phase)', fhd, fNumber );
        t=t+1;
        for i=1:Npop            
            if Mnew.Cost <= pop(i).Cost
                pop(i)= Mnew;                
            else
                DELTA=(Mnew.Cost-pop(i).Cost);
                P=exp(-DELTA/T);
                if rand <= P
                    pop(end)= Mnew;                                      
                end            
            end  
            % Update Best Solution Ever Found
            if pop(i).Cost <= BestSol.Cost
                BestSol=pop(i);
            end  
        end
    
    % Store Best Cost Ever Found
    BestCost(t)=BestSol.Cost;    
 % Display Iteration Information
    %disp(['Iteration = ' num2str(t) ': Best Cost = ' num2str(BestCost(t))]);    
    % Update Temp.
    T=alpha*T;
end
bestSolution=BestCost;
bestFitness=BestSol.Cost;
iteration=t;

