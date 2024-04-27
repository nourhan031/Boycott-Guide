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

% point 11
% Find an alternative for the given item and calculates the difference in price
%
getTheDifferenceInPriceBetweenItemAndAlternative(Item, Alternative, DiffPrice) :-
    alternative(Item, Alternative),
    item(Item, _, ItemPrice),
    item(Alternative, _, AlternativePrice),
    DiffPrice is ItemPrice - AlternativePrice.
