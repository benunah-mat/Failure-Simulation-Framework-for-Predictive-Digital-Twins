function D = damage_evolution_model(machine,t,dt,k,a,b,c,d)

D = zeros(size(t));

for i = 2:length(t)


growth = k*(machine.Load^a) * ...
         (machine.Temperature^b) * ...
         (machine.Speed^c) * ...
         (machine.Lubrication^-d);

D(i) = D(i-1) + growth*dt;

if D(i) >= 1
    D(i:end) = 1;
    break
end


end
