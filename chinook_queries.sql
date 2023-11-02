-- Found queries at: https://github.com/nashville-software-school/bangazon-corp/blob/master/post-orientation-exercises/chinook/02-sql_queries-chinook.md

USE chinook;

-- Provide a query showing Customers (just their full names, customer ID and country) who are not in the US.
SELECT CONCAT(FirstName, ' ', LastName) as "Full Name", CustomerId, Country
FROM customer
WHERE Country <> 'USA';

-- Provide a query only showing the Customers from Brazil.
SELECT *
FROM customer
WHERE Country = 'Brazil';

-- Provide a query showing the Invoices of customers who are from Brazil. The resultant table should show the customer's full name, Invoice ID, Date of the invoice and billing country.
SELECT CONCAT(c.FirstName, ' ', c.LastName) as "Full Name", i.InvoiceId, i.InvoiceDate, i.BillingCountry
FROM customer c, invoice i
WHERE c.CustomerId = i.CustomerId AND c.Country = 'Brazil';

-- Provide a query showing only the Employees who are Sales Agents.
SELECT * 
FROM employee
WHERE title = 'Sales Support Agent';

-- Provide a query showing a unique list of billing countries from the Invoice table.
SELECT DISTINCT BillingCountry
FROM invoice;

-- Provide a query that shows the invoices associated with each sales agent. The resultant table should include the Sales Agent's full name.
SELECT CONCAT(e.FirstName, ' ', e.LastName) as "Sales Agent", i.InvoiceId
FROM invoice i, employee e, customer c
WHERE e.Title = 'Sales Support Agent'
AND c.CustomerId = i.CustomerId
AND e.EmployeeId = c.SupportRepId
ORDER BY i.InvoiceId;

-- Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.
SELECT CONCAT(c.FirstName , " " , c.LastName) as "Customer Name", c.Country, i.InvoiceId, i.Total, CONCAT(e.FirstName, " ", e.LastName) as "Sales Agent", i.InvoiceId
FROM customer c, invoice i, employee e
WHERE c.CustomerId = i.CustomerId
AND c.SupportRepId = e.EmployeeId
ORDER BY i.Total;

-- How many Invoices were there in 2009 and 2011? What are the respective total sales for each of those years?
SELECT COUNT(i.InvoiceId) as "Total Invoices", sum(i.Total), date_format(i.InvoiceDate, '%Y') as YearValue
FROM invoice i
WHERE date_format(i.InvoiceDate, '%Y') IN (2009, 2011) 
GROUP BY YearValue;

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for Invoice ID 37.
SELECT il.InvoiceId, COUNT(il.InvoiceLineId)
FROM invoiceline il
WHERE il.InvoiceId = 37
GROUP BY il.InvoiceId;

-- Looking at the InvoiceLine table, provide a query that COUNTs the number of line items for each Invoice. HINT: GROUP BY
SELECT il.InvoiceId, COUNT(il.InvoiceLineId)
FROM invoiceline il
GROUP BY il.InvoiceId;

-- Provide a query that includes the track name with each invoice line item.
SELECT il.*, t.Name
FROM invoiceline il, track t
WHERE il.TrackId = t.TrackId;

-- Provide a query that includes the purchased track name AND artist name with each invoice line item.
SELECT il.*, t.Name as TrackName, ar.Name as ArtistName
FROM invoiceline il, track t, album al, artist ar
WHERE il.TrackId = t.TrackId
AND t.AlbumId = al.AlbumId
AND al.ArtistId = ar.ArtistId;

-- Provide a query that shows the # of invoices per country. HINT: GROUP BY
SELECT i.BillingCountry, COUNT(i.InvoiceId)
FROM invoice i
GROUP BY i.BillingCountry;

-- Provide a query that shows the total number of tracks in each playlist. The Playlist name should be included on the resultant table.
SELECT p.Name as "Playlist Name", COUNT(pt.TrackId)
FROM playlist p, playlisttrack pt
WHERE p.PlaylistId = pt.PlaylistId
GROUP BY p.PlaylistId;

-- Provide a query that shows all the Tracks, but displays no IDs. The resultant table should include the Album name, Media type and Genre.
SELECT t.Name as "Track Name", a.Title as "Album Name", m.Name as "Media type", g.Name as "Genre"
FROM track t, album a, mediatype m, genre g
WHERE t.AlbumId = a.AlbumId
AND t.MediaTypeId = m.MediaTypeId
AND t.GenreId = g.GenreId;

-- Provide a query that shows all Invoices but includes the # of invoice line items.
SELECT i.*, COUNT(il.InvoiceLineid) as "# of invoice line items"
FROM invoice i, invoiceline il
WHERE i.InvoiceId = il.InvoiceId
GROUP BY il.InvoiceId;

-- Provide a query that shows total sales made by each sales agent.
SELECT e.EmployeeId, CONCAT(e.FirstName, ' ', e.LastName) as EmployeeName, sum(i.Total)
FROM employee e, customer c, invoice i
WHERE c.CustomerId = i.CustomerId 
AND c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

-- Which sales agent made the most in sales in 2009?
SELECT CONCAT(e.FirstName, ' ', e.LastName) as "Employee Name", sum(i.Total)
FROM employee e, customer c, invoice i
WHERE e.EmployeeId = c.SupportRepId
AND c.CustomerId = i.CustomerId
AND DATE_FORMAT(i.InvoiceDate, '%Y') = 2009
GROUP BY e.EmployeeId
ORDER BY sum(i.Total) DESC LIMIT 1;

-- Which sales agent made the most in sales in 2010?
SELECT CONCAT(e.FirstName, ' ', e.LastName) as "Employee Name", sum(i.Total)
FROM employee e, customer c, invoice i
WHERE e.EmployeeId = c.SupportRepId
AND c.CustomerId = i.CustomerId
AND DATE_FORMAT(i.InvoiceDate, '%Y') = 2010
GROUP BY e.EmployeeId
ORDER BY sum(i.Total) DESC LIMIT 1;

-- Which sales agent made the most in sales over all?
SELECT CONCAT(e.FirstName, ' ', e.LastName) as "Employee Name", sum(i.Total)
FROM employee e, customer c, invoice i
WHERE e.EmployeeId = c.SupportRepId
AND c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY sum(i.Total) DESC LIMIT 1;

-- Provide a query that shows the # of customers assigned to each sales agent.
SELECT e.EmployeeId, CONCAT(e.FirstName, ' ', e.LastName), COUNT(c.CustomerId) as "# of customers"
FROM employee e, customer c
WHERE e.EmployeeId = c.SupportRepId
GROUP BY e.EmployeeId;

-- Provide a query that shows the total sales per country. Which country's customers spent the most?
SELECT i.BillingCountry, SUM(i.Total) as TotalSales
FROM invoice i
GROUP BY i.BillingCountry
ORDER BY TotalSales DESC LIMIT 1;

-- Provide a query that shows the most purchased track of 2013.
SELECT t.Name as TrackName, SUM(il.Quantity) as Quantity
FROM invoice i, invoiceline il, track t
WHERE i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
AND DATE_FORMAT(i.InvoiceDate, '%Y') = 2013
GROUP BY t.Name
ORDER BY Quantity DESC LIMIT 1;

-- test code
select i.InvoiceId, i.CustomerId, i.InvoiceDate, il.InvoiceId, il.InvoiceLineId, il.TrackId, t.Name, il.Quantity
from invoice i, invoiceline il, track t where i.InvoiceId = il.InvoiceId and date_format(i.InvoiceDate, '%Y') = 2013 and t.TrackId = il.TrackId
order by t.TrackId;
-- test code

select t.TrackId, t.Name, sum(il.Quantity) as Quantity
from invoice i, invoiceline il, track t 
where i.InvoiceId = il.InvoiceId 
and t.TrackId = il.TrackId 
and date_format(i.InvoiceDate, '%Y') = 2013
group by t.TrackId
order by Quantity DESC;

SELECT t.Name as TrackName, SUM(il.Quantity) as Quantity
FROM invoice i, invoiceline il, track t
WHERE i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
AND DATE_FORMAT(i.InvoiceDate, '%Y') = 2013
GROUP BY TrackName
ORDER BY Quantity DESC;

-- Provide a query that shows the top 5 most purchased tracks over all.
SELECT t.Name as TrackName, SUM(il.Quantity) as Quantity
FROM invoice i, invoiceline il, track t
WHERE i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY Quantity DESC LIMIT 5;

-- Provide a query that shows the top 3 best selling artists.
SELECT ar.Name, SUM(il.Quantity) as Quantity
FROM invoice i, invoiceline il, track t, album al, artist ar
WHERE i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
AND t.AlbumId = al.AlbumId
AND al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY Quantity DESC LIMIT 3;

-- Provide a query that shows the most purchased Media Type.
SELECT m.Name, COUNT(t.TrackId) as num
FROM track t, mediatype m
WHERE t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY num DESC LIMIT 1;

-- Provide a query that shows the number tracks purchased in all invoices that contain more than one genre. 
SELECT t.Name, COUNT(DISTINCT t.GenreId) as CNT
FROM invoice i, invoiceline il, track t
WHERE i.InvoiceId = il.InvoiceId
AND il.TrackId = t.TrackId
GROUP BY t.Name
HAVING CNT >= 2
ORDER BY CNT DESC;

select * from track t where Name = 'The Trooper';

