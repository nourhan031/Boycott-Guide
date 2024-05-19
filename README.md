# Boycott-Guide

A Prolog program to manage customer orders, calculate order prices, and handle boycotted items.<br> 
It provides various functionalities to list, count, and modify orders, check for boycotted items, and find alternatives.

**Usage:**<br>
1- To list all orders of a customer by their username:<br>
<code>list_orders(CustomerUsername, Orders).</code>
<br>
2- To count the number of orders a customer has made:<br>
<code>countOrdersOfCustomer(CustomerName, Count).</code>
<br>
3- To get all items in a specific order for a given customer:<br>
<code>getItemsInOrderById(CustomerName, OrderID, Items).</code>
<br>
4- To calculate the number of items in a customer's order:<br>
<code>getNumOfItems(Name, OrderId, Result).</code>
<br>
5- To calculate the total price of a given order:<br>
<code>calcPriceOfOrder(CustomerName, OrderID, TotalPrice).</code>
<br>
6- To check if an item or company is boycotted:<br>
<code>isBoycott(X).</code>
<br>
7- To get the justification for boycotting an item or company:<br>
<code>whyToBoycott(X, Justification).</code>
<br>
8- To remove boycotted items from an order:<br>
<code>removeBoycottItemsFromAnOrder(CustomerName, OrderID, ModifiedOrder).</code>
<br>
9- To replace boycotted items in an order with their alternatives:<br>
<code>replaceBoycottItemsFromAnOrder(Username, OrderID, NewList).</code>
<br>
10- To get the total price of alternative items for a specific order:<br>
<code>getAlternativesTotalPrice(CustomerName, OrderID, Alternatives, TotalPrice).</code>
<br>
11- To find the price difference between an item and its alternative:<br>
<code>getTheDifferenceInPriceBetweenItemAndAlternative(Item, Alternative, DiffPrice).</code>
<br>
12- To add a new item to the knowledge base:<br>
<code>add_item(ItemName, CompanyName, Price).</code>
<br>
13- To remove an existing item from the knowledge base:<br>
<code>remove_item(ItemName, CompanyName, Price).</code>
<br>
