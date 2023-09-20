select *
from CleaningPortfolioProject.dbo.NashvilleHousing

-------------------------------------------------------------------------------------------------

-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
from CleaningPortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted date;

Update NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

-------------------------------------------------------------------------------------------------

-- Populate Property Address Data

select *
from CleaningPortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from CleaningPortfolioProject.dbo.NashvilleHousing a
join CleaningPortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from CleaningPortfolioProject.dbo.NashvilleHousing a
join CleaningPortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from CleaningPortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

from CleaningPortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
from CleaningPortfolioProject.dbo.NashvilleHousing

select OwnerAddress
from CleaningPortfolioProject.dbo.NashvilleHousing



select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from CleaningPortfolioProject.dbo.NashvilleHousing








ALTER TABLE NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2) 


ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


-------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant), Count(SoldAsVacant)
from CleaningPortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ElSE SoldAsVacant
	  END
from CleaningPortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ElSE SoldAsVacant
	  END

-------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH RowNumCTE AS (
select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

from CleaningPortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
-- DELETE
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress




select*
from CleaningPortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select*
from CleaningPortfolioProject.dbo.NashvilleHousing

ALTER TABLE CleaningPortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate
