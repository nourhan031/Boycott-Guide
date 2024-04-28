:- consult('data.pl').

% Check if item is a memeber of a list or not
is_member(X,[X|_]).
is_member(X,[_|T]):-
    is_member(X,T).


% Return the length of a list
len([],0).
len([_|T],L):-
    len(T,NewL),
    L is NewL+1.


% (1)
list_orders(CustomerUsername, Orders):-
    customer(CustomerID, CustomerUsername),% Get the customer id
    return_orders(CustomerID, [], Orders),% Call return_orders
    !.

return_orders(CustomerID, AccOrders, Orders) :-
    order(CustomerID, OrderID, OrderItems),
    \+ is_member(order(CustomerID, OrderID,_), AccOrders), % Ensure order is not already in the list
    NewAccOrders = [order(CustomerID, OrderID, OrderItems) | AccOrders],
    return_orders(CustomerID, NewAccOrders, Orders).
return_orders(_,Orders, Orders).

% (2)
countOrdersOfCustomer(Customername,Count):-
    list_orders(Customername,Result),
    len(Result,Count).




% (4) Returns the number of items of a cutomer buys
% Takes customer name and order id and return the items number
getNumOfItems(Name, OrderId , Result):-
    customer(CustomerId,Name),% Returns the Customer ID
    order(CustomerId,OrderId,List),% Use custoemr id and order id to get the items list
    len(List,Result).% pass the list to len rule and it returns the length of this list




% point 5
% Calculate the price of a given order given customer Name and order id
%
% Base case: If there are no more items in the order, the total price is 0.
calcPriceOfOrder(_, [], 0).
% Recursive case: If there are items in the order, add the price of the first item to the total price and recurse on the rest of the items.
calcPriceOfOrder(CustomerName, OrderID, TotalPrice) :-
    customer(CustomerID, CustomerName),
    order(CustomerID, OrderID, Items),
    calcPriceOfItems(Items, TotalPrice).

% calculate the total price of a list of items.
calcPriceOfItems([], 0).
calcPriceOfItems([First|Rest], TotalPrice) :-
    item(First, _, Price),
    calcPriceOfItems(Rest, RestPrice),
    TotalPrice is Price + RestPrice.

% point 6
% Given the item name or company name, determine whether we need to boycott or not
%
isBoycott(X) :-
    (item(X, Company, _);
     X = Company),
    boycott_company(Company, _).

% point 7
% Find the justification to boycott a given item or company
%
whyToBoycott(X, Justification) :-
    (item(X, Company, _); 
    X = Company),
    boycott_company(Company, Justification).


% point 8
%
% Predicate to remove boycott items from an order
removeBoycottItemsFromAnOrder(CustomerName, OrderID, ModifiedOrder) :-
    customer(CustomerID, CustomerName),         % Get the customer ID based on the name
    order(CustomerID, OrderID, Items),          % Get the items associated with the order ID and customer ID
    removeBoycottItemsFromOrder(Items, [], ModifiedOrder),% Remove boycott items
    !. 

% Base case: If there are no more items, the modified order is the same as the accumulator
removeBoycottItemsFromOrder([], ModifiedOrder, ModifiedOrder).

% If the item belongs to a boycotted company, skip it and continue with the recursion
removeBoycottItemsFromOrder([Item|Rest], Acc, ModifiedOrder) :-
    item(Item, Company,_),                    % Get the company associated with the item
    boycott_company(Company,_),               % Check if the company is boycotted
    removeBoycottItemsFromOrder(Rest, Acc, ModifiedOrder). % Skip the item and continue with the recursion

% Recursive case: If there are items in the list and they do not belong to boycotted companies
removeBoycottItemsFromOrder([Item|Rest], Acc, ModifiedOrder) :-
    item(Item, Company,_),                    % Get the company associated with the item
    \+ boycott_company(Company,_),            % Check if the company is not boycotted
    removeBoycottItemsFromOrder(Rest, [Item|Acc], ModifiedOrder). % Add the item to the accumulator and continue with the recursion





% point 9
%

% Predicate to replace boycott items from an order with their alternatives
replaceBoycottItemsFromAnOrder(Username, OrderID, NewList) :-
    customer(CustID, Username),         % Retrieve customer ID from username
    order(CustID, OrderID, Items),      % Retrieve items from the order
    replaceBoycottItems(Items, NewList).% Replace boycott items with alternatives

% Predicate to replace boycott items from a list of items
replaceBoycottItems([], []). % Base case: empty list
replaceBoycottItems([Item|Rest], [NewItem|UpdatedList]) :-
    boycottItem(Item),                  % Check if the item is boycotted
    alternative(Item, NewItem),         % Find alternative for the boycotted item
    replaceBoycottItems(Rest, UpdatedList). % Continue with the rest of the list
replaceBoycottItems([Item|Rest], [Item|UpdatedList]) :-
    \+ boycottItem(Item),               % If not boycotted, keep it
    replaceBoycottItems(Rest, UpdatedList). % Continue with the rest of the list

% Predicate to check if an item is boycotted
boycottItem(Item) :-
    item(Item, Company, _),
    boycott_company(Company, _).



%Point 10
%Return the alternative items total price of a specific order
getAlternativesTotalPrice(CustomerName,OrderID,Alternatives,TotalPrice):-
  
   getOrderItems(CustomerName,OrderID,Items),%First get order items
   getAlternativesItems(Items,Alternatives),%then return alternatives of these items
   getListPrice(Alternatives,Prices),%Get the Prices of each item in alternatives
   getTotalPrice(Prices,TotalPrice),%finally compute the sum of all prices you get
    !.

% Get the list of items in a specific order using customer name and order id
getOrderItems(CustomerName,OrderID , List):-
    customer(CustomerID,CustomerName),
    order(CustomerID,OrderID, List).


% Return a list of prices for all items in the input list
% Iterates on the list and save the price of each in Price[]
getListPrice([H|[]],[Price|[]]):-
    item(H,_,Price).
getListPrice([H|T], Price):-
    getListPrice(T,NewPrice),
    item(H,_,X),
    Price = [X|NewPrice].
    

% As the same of getListPrice but it returns the alternatives of an item list
getAlternativesItems([H|[]],[Alternative|[]]):-
    alternative(H,Alternative).

getAlternativesItems([H|T], Alternatives):-
    getAlternativesItems(T,NewA),
    alternative(H,X),
    Alternatives = [X|NewA].

getAlternativesItems(Item,Item).%In case of the item has no alternatives

% Takes a list of prices and return the sum of all elements.
getTotalPrice([] , 0).
getTotalPrice([H|T],Total):-
    getTotalPrice(T,NewTotal),
    Total is H + NewTotal.

    

% point 11
% Find an alternative for the given item and calculates the difference in price
%
getTheDifferenceInPriceBetweenItemAndAlternative(Item, Alternative, DiffPrice) :-
    alternative(Item, Alternative),
    item(Item, _, ItemPrice),
    item(Alternative, _, AlternativePrice),
    DiffPrice is ItemPrice - AlternativePrice.
