/*
Cleaning Data in SQL Queries
*/
---
Select *
from project.dbo.Nashvile;

-- Standardize Data Format

Select SaleDate, CONVERT(date,SaleDate)
from project.dbo.Nashvile;

update Nashvile
set SaleDate = CONVERT(date,SaleDate);

alter table Nashvile
add SaleDateConverted Date;

Update Nashvile
set SaleDateConverted = CONVERT(Date,SaleDate);

--Populate Property Address date

Select *
from project.dbo.Nashvile
--where PropertyAddress is null
order by ParcelID;

Select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from project.dbo.Nashvile a
join project.dbo.Nashvile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from project.dbo.Nashvile a
join project.dbo.Nashvile b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from project.dbo.Nashvile;
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from project.dbo.Nashvile;

alter table Nashvile
add PropertySplitAddress nvarchar(255);

Update Nashvile
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);

alter table Nashvile
add PropertySplitCity nvarchar(255);

Update Nashvile
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress));

select*
from project.dbo.Nashvile;

select OwnerAddress
from project.dbo.Nashvile;

Select 
PARSENAME(replace(OwnerAddress, ',', '.'), 3), 
PARSENAME(replace(OwnerAddress, ',', '.'), 2),
PARSENAME(replace(OwnerAddress, ',', '.'), 1)
from project.dbo.Nashvile

alter table Nashvile
add OwnerSplitAddess nverchar(255);

Update Nashvile
set OwnerSplitAddess = PARSENAME(replace(OwnerAddress, ',', '.'), 3);

alter table Nashvile
add OwnerSplitCity nverchar(255);

Update Nashvile
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2);

alter table Nashvile
add OwnerSplitState nvarchar(255);

Update Nashvile
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.'), 1);

select *
from project.dbo.Nashvile;

--Change Y and N and to Yes and No in "Sold as Vacant" field

select Distinct(SoldAsVacant),count(SoldAsVacant)
from project.dbo.Nashvile
group by SoldAsVacant
order by 2;


select SoldAsVacant
,case	when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from project.dbo.Nashvile

update Nashvile
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
						end


-- Remove Duplicates

with RowNumCTE as (
select *,
	ROW_NUMBER() over(
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by 
					UniqueID
					) row_num

from project.dbo.Nashvile
--order by ParcelID
)
delete
from RowNumCTE
where row_num >1
--order by PropertyAddress;

--delete Unused Columns

select *
from project.dbo.Nashvile

alter table Nashvile
Drop column OwnerAddress, TaxDistrict, PropertyAddress












