function [bestSolution, bestFitness, iteration]= efo(fhd, dimension, Max_gen, fNumber)
R_rate=0.3;
Ps_rate=0.2;
P_field=0.1;
N_field=0.45;
N_emp=50;
settings;
minval= lbArray;
maxval= ubArray;
problemIndex=fNumber;
N_var=dimension;
em_pop =zeros(N_emp, N_var);
phi = (1 + sqrt(5))/2;%golden ratio
%initializatin
for i=1:N_emp
     em_pop(i,:) = minval + (maxval - minval) .* rand(1,N_var);
end

fit= testFunction(em_pop(1:N_emp,1:N_var)',fhd, problemIndex);
em_pop = [em_pop(:,1:N_var) fit'];
em_pop = sortpop(em_pop,N_var+1);
%random vectors (this is to increase the calculation speed instead of
%determining the random values in each iteration we allocate them in the
%beginning before algorithm start
r_index1 = randi([1 (round(N_emp.* P_field))],[N_var Max_gen]); %random particles from positive field
r_index2 = randi([(round(N_emp.*(1-N_field))) N_emp],[N_var Max_gen]); %random particles from negative field
r_index3 = randi([(round(N_emp.* P_field)+1) (round(N_emp.*(1-N_field))-1)],[N_var Max_gen]);%random particles from neutral field
ps= rand(N_var,Max_gen);%= probability of selecting electromagnets of generated particle from the positive field
r_force = rand(1,Max_gen);%random force in each generation
rp = rand(1,Max_gen);%some random numbers for checking randomness probability in each generation
randomization = rand(1,Max_gen);%coefficient of randomization when generated electro magnet is out of boundary
RI=1;%index of the electromagnet (variable) which is going to be initialized by random number
generation=N_emp;
new_emp = zeros(1,N_var+1); %temporary array to store generated particle 
while (generation <= Max_gen)
    r = r_force(1,generation);
    
    for i=1:N_var
              
        if (ps(i,generation) > Ps_rate)
            new_emp(i) = em_pop(r_index3(i,generation), i) + phi * r * (em_pop(r_index1(i,generation), i) - em_pop(r_index3(i,generation), i)) + r * (em_pop(r_index3(i,generation), i) - em_pop(r_index2(i,generation), i));
        else
            new_emp(i) = em_pop (r_index1(i,generation), i);
        end
        
        %checking whether the generated number is inside boundary or not
        if ( new_emp(i) >= maxval(i) || new_emp(i) <= minval(i) )
            new_emp(i) = minval(i) + (maxval(i) - minval(i)) .* randomization(1, generation);
        end
    end
    %replacement of one electromagnet of generated particle with a random number (only for
    %some generated particles) to bring diversity to the population
    if ( rp(1,generation) < R_rate)
        new_emp(RI) = minval(RI) + (maxval(RI) - minval(RI)) .* randomization(1, generation);
        RI=RI+1;
        
        if (RI > N_var)
            RI=1;
        end
    end
    new_emp(N_var+1)= testFunction(new_emp(1:N_var)',fhd, problemIndex);
    %updating the population if the fitness of the generated particle is better than worst fitness in
    %the population (because the population is sorted by fitness, the last particle is the worst)
    if ( new_emp(N_var+1) < em_pop(N_emp , N_var+1) )
        position=find(em_pop(:,N_var+1) > new_emp(N_var+1));
        em_pop=insert_in_pop(em_pop,new_emp,position(1));
    end
    generation=generation+1;
end
besterr=em_pop(1,N_var+1);

bestFitness=besterr;
bestSolution=em_pop(1,1:N_var);
iteration=generation;
end