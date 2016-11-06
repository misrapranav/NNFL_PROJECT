clc;
close all;

iterations=1000;      
population_size=20;        
w=0.7298;
c1=1.4962;
c2=1.4962;


particle_size=21;            
min_limit = [-20 -20 -20 -.5 -.5 -.5   5  5  5 1 1 1 -3 -3 -3 -3 -3 -3 -3 -3 -3];
max_limit = [ 20  20  20  .5  .5  .5  30 30 30 4 4 4  3  3  3  3  3  3  3  3  3];

max_velocity=0.1*(max_limit-min_limit);
min_velocity=-max_velocity;

position_structure=[1 particle_size];
particle_structure.Position=[];
particle_structure.Cost=[];
particle_structure.Velocity=[];
particle_structure.Best.Position=[];
particle_structure.Best.Cost=[];

particle=repmat(particle_structure, population_size, 1);

GlobalBest.Cost=inf;

for i=1:population_size
    particle(i).Position = unifrnd(min_limit, max_limit, position_structure);
    particle(i).Cost = CostFunction(particle(i).Position, TR_SET);
    particle(i).Velocity= zeros(position_structure);
    particle(i).Best.Position = particle(i).Position;
    particle(i).Best.Cost = particle(i).Cost;
    if (particle(i).Best.Cost<GlobalBest.Cost)
        GlobalBest = particle(i).Best;
    end
end

BestCost=zeros(iterations,1);

for it=1:iterations
    
    for i=1:population_size
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(position_structure).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(position_structure).*(GlobalBest.Position-particle(i).Position);
        
        particle(i).Velocity = max(particle(i).Velocity,min_velocity);
        particle(i).Velocity = min(particle(i).Velocity,max_velocity);
        
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        IsOutside=(particle(i).Position<min_limit | particle(i).Position>max_limit);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        particle(i).Position = max(particle(i).Position,min_limit);
        particle(i).Position = min(particle(i).Position,max_limit);
        
        particle(i).Cost = CostFunction(particle(i).Position, TR_SET);
        
        if (particle(i).Cost<particle(i).Best.Cost)
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            if (particle(i).Best.Cost<GlobalBest.Cost)
                GlobalBest=particle(i).Best;
            end

        end
    end
    
    BestCost(it)=GlobalBest.Cost;
    
    if(mod(it,100)==0)
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    end

end

BestSol = GlobalBest;

figure;
plot(BestCost,'LineWidth',2);
semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;