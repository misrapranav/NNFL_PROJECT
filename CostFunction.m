function cost = CostFunction(PARAMS, TR_SET)
    
    TR_SET = [...
        100 90 80 70 60 50 40 20 10 ...
        9 8 7 6 5 4 3 2 1 ...
        .9 .8 .7 .6 .5 .4 .3 .2 .1 0.02 0.01 0.001...
    ];

    [r, n] = size(TR_SET);
    cost  = 0;
    Speed = 0;
    
    for i = 1:n
        E = TR_SET(i);
        CE = 0;
        
        temp = ANFIS(E, CE, PARAMS);

        if( temp >= 0)
            cost = cost + 1000 + temp;
            temp = -temp;
        end

        if( -temp > (E/2) )
            cost = cost + 2000;
        end

        temp = ANFIS(-E, CE, PARAMS);
        if( temp <= 0)
            temp = -1 * temp;
            cost = cost + 1000 + temp;
        end

        if( temp > (E/2) )
            cost = cost + 2000;
        end
    end 

end


function SPEED  = INPUT_FROM_MOTOR(V)
    SPEED = V * 2;
end


