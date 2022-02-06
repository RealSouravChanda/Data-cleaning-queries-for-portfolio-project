/*
Cleaning Data in SQL Queries
*/

use portfolioproject

select * 
from  [dbo].[NashvilleHousing]

-- Standardize Date Format


select SaleDate,CONVERT(date,SaleDate) 
from  [dbo].[NashvilleHousing]



alter table [dbo].[NashvilleHousing]
add SaleDateConverted date ;

update  [dbo].[NashvilleHousing] 
set SaleDateConverted = CONVERT(date,SaleDate) ;

select SaleDateConverted 
from NashvilleHousing

-- Populate Property Address data

select    * 
from NashvilleHousing
--where PropertyAddress is null 
order by ParcelID


select  a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [dbo].[NashvilleHousing]  a
join [dbo].[NashvilleHousing]  b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] 
	where a.PropertyAddress  is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 from [dbo].[NashvilleHousing]  a
join [dbo].[NashvilleHousing]  b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress  is null


	
-- Breaking out Address into Individual Columns (Address, City, State)


select    PropertyAddress
from NashvilleHousing
--where PropertyAddress is null 
--order by ParcelID

select 
SUBSTRING(propertyAddress,1,CHARINDEX(',',propertyAddress)-1) as Address ,
SUBSTRING(propertyAddress,CHARINDEX(',',propertyAddress)+1 ,len(propertyAddress) ) as city
from [dbo].[NashvilleHousing];

alter table NashvilleHousing
add propertySplitAddress nvarchar(255);

update [dbo].[NashvilleHousing]
set propertySplitAddress =  SUBSTRING(propertyAddress,1,CHARINDEX(',',propertyAddress)-1) 



alter table [dbo].[NashvilleHousing]
add propertySplitCity  nvarchar(255);

update [dbo].[NashvilleHousing]
set propertySplitCity = SUBSTRING(propertyAddress,CHARINDEX(',',propertyAddress)+1 ,len(propertyAddress) )

 
select *
from [dbo].[NashvilleHousing]




 
select OwnerAddress
from [dbo].[NashvilleHousing]


select 
PARSENAME(replace(ownerAddress,',','.'),3)  
, PARSENAME(replace(ownerAddress,',','.'),2)
,PARSENAME(replace(ownerAddress,',','.'),1)
from [dbo].[NashvilleHousing]


alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update [dbo].[NashvilleHousing]
set OwnerSplitAddress = PARSENAME(replace(ownerAddress,',','.'),3)



alter table [dbo].[NashvilleHousing]
add OwnerSplitCity  nvarchar(255);

update [dbo].[NashvilleHousing]
set OwnerSplitCity =  PARSENAME(replace(ownerAddress,',','.'),2)



alter table [dbo].[NashvilleHousing]
add OwnerSplitState  nvarchar(255);

update [dbo].[NashvilleHousing]
set OwnerSplitState = PARSENAME(replace(ownerAddress,',','.'),1)


select * 
from [dbo].[NashvilleHousing]




-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from [dbo].[NashvilleHousing]
group by SoldAsVacant
order by 2


select SoldAsVacant
,case   when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else  SoldAsVacant
		end
from [dbo].[NashvilleHousing]

update [dbo].[NashvilleHousing]
set SoldAsVacant =  case   when SoldAsVacant = 'Y' then 'Yes'
					when SoldAsVacant = 'N' then 'No'
					else  SoldAsVacant
					end


-- Remove Duplicates

with RownunCTE as (
select *,
	ROW_NUMBER() over(
	partition by parcelID,
				 propertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
	order by uniqueID
	) row_num

from [dbo].[NashvilleHousing]
--order by ParcelID
)
 delete  
 from RownunCTE
 where row_num > 1 
  --order by PropertyAddress

  

-- Delete Unused Columns

select *   
 from [dbo].[NashvilleHousing]


 alter table [dbo].[NashvilleHousing]
 drop column propertyAddress, owneraddress,TaxDistrict

 alter table [dbo].[NashvilleHousing]
 drop column SaleDate



 --thankyou by SouravChanda--