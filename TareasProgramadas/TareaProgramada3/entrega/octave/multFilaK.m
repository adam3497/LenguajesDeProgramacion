function Mprime = multFilaK(M, i, k)
    % Multiplica la fila i de la matriz M por la constante k
    M(i,:) = k * M(i,:);
    % devuelve la matriz M en la variable Mprime
    Mprime = M;
end