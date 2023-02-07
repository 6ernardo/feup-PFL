--Tipos criados para a representação do Polinómio
type Term = (Char, Float) -- sendo Char a variável e Float o expoente. ex.: ('z', 4) => z^4
type Variables = [Term] -- Conjunto das variáveis existintes num polinómio e o respetivo grau. ex.: [('x', 2),('y', 3)] => x^2*y^3
type Monomial = (Float, Variables) -- Representação de um Monómio, sendo Float o coeficiente. ex.: (2, [('x', 2),('y', 3)]) => 2*x^2*y^3
type Polynomial = [Monomial] -- Polinómio, um conjunto formado por monómios. e.: [(2, [('x', 2),('y', 3)]), (0, [('x',1)])] => 2*x^2*y^3 + 0*x^1

-------------------------------------------------------------------------------------------------------------------------------------------------

--FUNÇAO A) NORMALIZAR POLINÓMIOS
normalizar :: Polynomial -> String
normalizar a = polynomialToString (normalizePolynomial a)

--FUNÇAO B) ADICIONAR POLINÓMIOS
adicionar :: Polynomial -> Polynomial -> String
adicionar a b = polynomialToString (normalizePolynomial (a++b))

--FUNÇAO C) MULTIPLICAR POLINÓMIOS
multiplicar :: Polynomial -> Polynomial -> String
multiplicar a b = polynomialToString (normalizePolynomial (multPolynomial a b))

--FUNÇAO D) DERIVAR POLINÓMIOS
--Char 'a' representa a ordem da derivação, 'p' representa o polinómio. derivar 'x' p corresponde a derivar p em função a x.
derivar :: Char -> Polynomial -> String
derivar a p = polynomialToString (normalizePolynomial (derivatePolynomial a p))

-------------------------------------------------------------------------------------------------------------------------------------------------

-- AUXILIARES POLYNOMIAL PARA STRING

--Função que passa Variables para String
variablesToString :: Variables -> String
variablesToString [] = []
variablesToString (x:xs) = if xs == [] then (fst x) : "^" ++ show((snd x)) else (fst x) : "^" ++ show((snd x)) ++ "*" ++ variablesToString xs

--Função que passa Monomial para String
monomialToString :: Monomial -> String
monomialToString x = if variablesToString (snd x) == [] then show(abs(fst x)) else show(abs(fst x)) ++ "*" ++ variablesToString (snd x)

--Função que passa Polynomial para String
polynomialToString :: Polynomial -> String
polynomialToString [] = "0"
polynomialToString (x:xs) = if xs == [] then monomialToString x else (monomialToString x) ++ aux ++ polynomialToString xs
  where aux = if fst (head xs) > 0 then " + " else " - "


-- AUXILIARES FUNÇÂO NORMALIZAR

-- Variables de expoente 0 correspondem a 1. Esta função retira termos de expoente 0 da lista Variables.
simplifyConstantTerms :: Variables -> Variables
simplifyConstantTerms [] = []
simplifyConstantTerms (x:xs) | snd x == 0 = simplifyConstantTerms xs
                             | otherwise = x : simplifyConstantTerms xs

-- Retira Monomials iguais a 0 da lista Polynomial
removeNullMonomials :: Polynomial -> Polynomial
removeNullMonomials [] = []
removeNullMonomials (x:xs) | fst x == 0 = removeNullMonomials xs
                           | otherwise = x : removeNullMonomials xs

-- Aplica a função simplifyConstantTerms ao membros da lista Polynomial
simplifyPolynomials :: Polynomial -> Polynomial
simplifyPolynomials [] = []
simplifyPolynomials (x:xs) = (fmap (simplifyConstantTerms) x) : simplifyPolynomials xs

-- Adiciona dois monómios
addMonomial :: Monomial -> Monomial -> Monomial
addMonomial a b = (fst a + fst b, snd a)

-- Verifica se um monómio independente e cada um dos monómios da lista têm as mesmas variáveis, se sim soma os monómios e acrescenta-o á lista Polynomial
addMonomialAux :: Monomial -> Polynomial -> Polynomial
addMonomialAux a [] = [a]
addMonomialAux a (b:bs) = if (snd a)==(snd b) then addMonomialAux (addMonomial a b) bs else b : addMonomialAux a bs

--Usa as funções auxiliares definidas para normalizar o polinómio
normalizePolynomial :: Polynomial -> Polynomial
normalizePolynomial [] = []
normalizePolynomial (x:xs) = simplifyPolynomials z
  where y = addMonomialAux x (normalizePolynomial xs)
        z = removeNullMonomials y


-- AUXILIARES FUNÇAO MULTIPLICAR

-- Realiza o produto de dois monómios
multMonomial :: Monomial -> Monomial -> Monomial
multMonomial a b = (fst a * fst b, snd a ++ snd b)

-- Realiza o produto de um monómio por um polinómio
multMonomialAux :: Monomial -> Polynomial -> Polynomial
multMonomialAux a [] = []
multMonomialAux a (b:bs) = multMonomial a b : multMonomialAux a bs

-- Multiplica dois polinómios
multPolynomial :: [Monomial] -> Polynomial -> Polynomial
multPolynomial _ [] = []
multPolynomial [] _ = []
multPolynomial (a:as) b = multMonomialAux a b ++ multPolynomial as b


-- AUXILIARES FUNÇAO DERIVAR

-- Deriva um Monomial 'm' em função a um Char 'a'. A Variables pode ser passada á funçao pela forma "snd m".
derivateMonomial :: Char -> Monomial -> Variables -> Monomial
derivateMonomial a m [] = (0,[])
derivateMonomial a m (v:vs) = if (derivateMonomialAux a (snd m)) == False then (0, aux) else if a == fst v then ((fst m * snd v), aux) else derivateMonomial a m vs
  where aux = derivateVariables a (snd m)

-- Verifica se variable tem a variavel 'a'. Não tendo, um monómio com esta Variable derivado em função a 'a' vai ser igual a 0.
-- Retorna true se a derivada for diferente de 0.
derivateMonomialAux :: Char -> Variables -> Bool
derivateMonomialAux a [] = False
derivateMonomialAux a (v:vs) = if a == fst v then True else derivateMonomialAux a vs

-- Retorna as Variables derivando em funçao a 'a'
derivateVariables :: Char -> Variables -> Variables
derivateVariables a [] = []
derivateVariables a (v:vs) = if a == fst v then (a, (snd v) -1):vs else v : derivateVariables a vs

-- Deriva os monómios de Polynomial, retorna o polinómio derivada em funçao a 'a'.
derivatePolynomial :: Char -> Polynomial -> Polynomial
derivatePolynomial a [] = []
derivatePolynomial a (p:ps) = [(derivateMonomial a p (snd p))] ++ (derivatePolynomial a ps)
