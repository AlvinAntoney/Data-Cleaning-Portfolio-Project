/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM PortfolioProject..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate, CONVERT( date, Saledate)
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SaleDate= CONVERT( date, Saledate)

-- If it doesn't Update properly

ALTER TABLE PortfolioProject..NashvilleHousing
Add SaleDateConverted Date

Update PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull( a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b on a.ParcelID= b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
  

  update a
  set PropertyAddress= isnull( a.PropertyAddress,b.PropertyAddress)
  FROM PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b on a.ParcelID= b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null


-------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


 Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant='N' THEN 'NO'
     WHEN SoldAsVacant='Y' THEN 'YES'
	 ELSE SoldAsVacant
	 END
	 From PortfolioProject.dbo.NashvilleHousing


UPDATE PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant='N' THEN 'NO'
     WHEN SoldAsVacant='Y' THEN 'YES'
	 ELSE SoldAsVacant
	 END


 -----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates



WITH RowNumCTE as(
Select *,
ROW_NUMBER() OVER( PARTITION BY ParcelID,
                                PropertyAddress,
								SalePrice,
								Saledate,
								LegalReference
								order by UniqueID ) ROW_NUM
From PortfolioProject.dbo.NashvilleHousing
)

SELECT *                                  --Use DELETE to delete duplicates here
FROM RowNumCTE
WHERE ROW_NUM>1
--ORDER BY PropertyAddress                  -- Will not work while using DELETE


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

-- Dont use it on raw data

Select *
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


