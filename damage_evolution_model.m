function D = damage_evolution_model(machine,t,dt,k,a,b,c,d)

gamma = 3;   % damage acceleration factor

D = zeros(size(t));

for i = 2:length(t)

base_growth = k*(machine.Load^a) * ...
              (machine.Temperature^b) * ...
              (machine.Speed^c) * ...
              (machine.Lubrication^-d);

growth = base_growth * (1 + gamma*D(i-1));

D(i) = D(i-1) + growth*dt;

if D(i) >= 1
    D(i:end) = 1;
    break
end

end

end
