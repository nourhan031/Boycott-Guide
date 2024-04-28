:- consult('data.pl').

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
    

% point 11
% Find an alternative for the given item and calculates the difference in price
%
getTheDifferenceInPriceBetweenItemAndAlternative(Item, Alternative, DiffPrice) :-
    alternative(Item, Alternative),
    item(Item, _, ItemPrice),
    item(Alternative, _, AlternativePrice),
    DiffPrice is ItemPrice - AlternativePrice.
