function Mprime = sume(M, i, j, k)
    % Le suma a la fila i de la matriz M, la fila j multiplicada 
    % por la constante k
    M(i,:) = M(i,:) + k * M(j,:);
    % se devuelve la matriz resultante en Mprime
    Mprime = M;
end