%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                 %
%             UNIVERSIDADE FEDERAL DE VIÇOSA - CAMPUS RIO PARANAÍBA               %
%                                                                                 %
%                             DONKEY  KONG                                        %
%                                                                                 %
%                  Desenvolvido por : Tiemy, Natália e Luigi                      %
%                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CENÁRIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
barril([4,0]).
barril([5,0]).
barril([1,2]).
barril([1,4]).
barril([5,4]).
barril([8,3]).
muro([]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MOVIMENTAÇÃO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%para CIMA
s([X,Y],[X,Y2]):- Y<4, Y2 is Y + 1,
	pertence([[X,Y],[X,Y2]],[[[3,0],[3,1]],[[9,1],[9,2]],[[6,2],[6,3]],[[3,3],[3,4]]]).

%para BAIXO
s([X,Y],[X,Y2]):- Y>0, Y2 is Y - 1,
	pertence([[X,Y],[X,Y2]],[[[3,1],[3,0]],[[9,2],[9,1]],[[6,3],[6,2]],[[3,4],[3,3]]]).

%para ESQUERDA
s([X,Y],[X2,Y]):- X>0, X2 is X - 2,barril([X3,Y]),X3 is X-1,not(obstaculos([X2,Y])).
s([X,Y],[X2,Y]):- X>0, X2 is X - 1,not(obstaculo([X2,Y])).

%para DIREITA
s([X,Y],[X2,Y]):- X<9, X2 is X + 2,barril([X3,Y]),X3 is X+1,not(obstaculos([X2,Y])).
s([X,Y],[X2,Y]):- X<9, X2 is X + 1,not(obstaculo([X2,Y])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%% REGRAS DE CONDIÇÕES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

donkey([X,Y]):- peach([X2,Y]), X is X2-1.

obstaculo(X):- barril(X);muro(X).
obstaculos(X):- barril(X);muro(X);pertence(X,[[3,0],[3,1],[9,1],[9,2],[6,2],[6,3],[3,3],[3,4]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%% MANIPULAÇÃO DE LISTAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Verificar se o elemento pertence a lista
pertence(Elem,[Elem|_]).
pertence(Elem,[_|Cauda]):- pertence(Elem,Cauda).

%Concatenar lista
concatena([], L, L).
concatena([Cab|L1], L2,[Cab|L3]):-concatena(L1, L2, L3).

%Inverter lista
inv([],[]).
inv([Elem|Cauda], Lista_inv):-inv(Cauda,Cauda_Inv),concatena(Cauda_Inv,[Elem], Lista_inv).

%Retirar um elemento da lista
retirar_elemento(Elem,[Elem|Cauda],Cauda).
retirar_elemento(Elem,[Elem1|Cauda],[Elem1|Cauda1]):- retirar_elemento(Elem,Cauda,Cauda1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNÇÃO DE BUSCA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Busca em largura

solucao_bl(Mario,Martelo,Peach,Solucao):- 
	busca_em_largura([[Mario]],Martelo,Solucao1),
	busca_em_largura([[Martelo]],Peach,Solucao2),
	concatena(Solucao2,Solucao1,Solucao3),
	retirar_elemento(Martelo,Solucao3,Solucao4),inv(Solucao4,Solucao).

busca_em_largura([[Estado|Caminho]|_],Destino,[Estado|Caminho]):- Destino=Estado.

busca_em_largura([Primeiro|Outros],Destino,Solucao):- 
	estende(Primeiro,Sucessores),
	concatena(Outros,Sucessores,NovaFronteira),
	busca_em_largura(NovaFronteira,Destino,Solucao).

estende([Estado|Caminho],ListaSucessores):- 
	bagof([Sucessor,Estado|Caminho],
	(s(Estado,Sucessor),not(pertence(Sucessor,[Estado|Caminho]))),ListaSucessores),!.

estende(_,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNÇÃO MAIN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main(Mario,Martelo,Peach,Solucao):- solucao_bl(Mario,Martelo,Peach,Solucao),
write("
O caminho percorrido foi ---->  
"), write(Solucao),
write("

A localização do martelo : "),write(Martelo),
write("
A localização da Peach : "),write(Peach),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
