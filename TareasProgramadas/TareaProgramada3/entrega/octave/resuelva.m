% utilice M = load('matrix.txt'); para cargar la matriz en Octave
% y luego ejecute valores = resuelva(M); para resolver el sistema de ecuaciones
function valores = resuelva(M)
    % Encuentra los valores de las variables que resuelven el 
    % sistema de ecuaciones lineales representado por la matriz M
    
    % Eliminación hacia adelante
    % Obtenemos el tamaño de la matriz y se guarda en filas y columnas
    [filas, columnas] = size(M);
    
    % se forma la diagonal de la matriz, haciendo los elementos por debajo de cada elemento ceros
    for j = 1:filas-1
        for i = j+1:filas
            % Si el elemento aij es cero, intercambiar filas
            if M(j,j) == 0
                % realizamos un bucle para buscar una fila que no tenga un 0 en 
                % el elemento akj, siendo k = {j+1, filas} 
                for k = j+1:filas
                    % Si el elemento akj es diferente de 0
                    if M(k,j) ~= 0
                        % Guardamos la fila (M(j,:)) que queremos intercambiar en una variable temporal
                        temp = M(j,:);
                        % Luego le asignamos a esa fila, la fila que no tiene como un 0 en el elemento akj 
                        M(j,:) = M(k,:);
                        % Y por último, a la fila akj le asignamos la fila que habíamos guardado en la variable temporal
                        M(k,:) = temp;
                        % salimos del for ya que encontramos una fila en el elemento akj diferente de 0
                        break;
                    end
                end
            end
            % una vez confirmamos que el elemento aij es diferente de 0
            % Hacer cero los elementos debajo de aij
            % Obtenemos el número que se necesita para hacaer el elemento debajo de aij cero 
            k = M(i,j) / M(j,j);
            % negamos k ya que queros hacer el elemento debajo de aij cero
            M = sume(M, i, j, -k);
        end
    end
    
    % Sustitución hacia atrás
    % Este bucle calcula el valor de cada variable desconocida `x_i`, comenzando por la última variable `x_n`
    % luego la variable `x_{n-1}`, y así sucesivamente hasta llegar a la primera variable `x_1`  
    valores = zeros(1, columnas-1);
    for j = filas:-1:1 % iteración desde filas hasta 1, restandole -1 en cada iteración
        % obtenemos el valor de la variable `x_i`
        temp = M(j,columnas);
        % se hace uso de los términos `x_i` que ya han sido calculados con anterioridad para calcular el 
        % `x_i` actual, para ello se suma temp - el valor del coeficiente dentro de M de la variable `x_i` 
        % correspondiendte en cada iteración 
        for i = columnas-1:-1:j+1 
            temp = temp - M(j,i)*valores(i);
        end
        % guardamos el valor de la variable `x_i`, el cual se toma como la división entre la suma 
        % por su coeficiente en la matriz M
        % así vamos armando el vector de resultado valores
        valores(j) = temp / M(j,j);
    end
end
