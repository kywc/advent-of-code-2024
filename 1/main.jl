open("output") do io
    global m = parse.(Int, split(readline(io), ','))
    global n = parse.(Int, split(readline(io), ','))
end

println(sum(abs.(sort(m) .- sort(n))))

d = Dict{Int, Int}()
for num in n
  if !haskey(d, num) 
    d[num] = 1
  else
    d[num] = d[num] + 1
  end
end

tally = 0

for num in m
  global tally = tally + num*get(d,num,0)
end

println(tally)
